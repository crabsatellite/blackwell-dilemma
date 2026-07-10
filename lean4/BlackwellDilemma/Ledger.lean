/-
  BlackwellDilemma/Ledger.lean

  Paper-level proof ledger for "Information Value Under Endogenous
  Feasibility".  This file deliberately tracks only the labelled theorem,
  proposition, lemma, and corollary environments in the manuscript.

  A claim can be closed only by constructing `ClaimEvidence.proved`, whose
  second field is a proof of the exact proposition stored in its first field.
  There is no editable `status := closed` field.
-/

import BlackwellDilemma.Basic
import BlackwellDilemma.PhysicalIrreducibility
import BlackwellDilemma.UnifiedWelfare
import BlackwellDilemma.UnifiedCanonical
import BlackwellDilemma.UnifiedInterior
import BlackwellDilemma.UnifiedTwoRegime
import BlackwellDilemma.UnifiedCognitiveFiveState
import BlackwellDilemma.UnifiedBayesianImmunity
import BlackwellDilemma.UnifiedComplementarity
import BlackwellDilemma.UnifiedBayesianNaiveFiveState
import BlackwellDilemma.UnifiedGeneralTree
import BlackwellDilemma.UnifiedErrorCompounding
import BlackwellDilemma.UnifiedGreedyReversal
import BlackwellDilemma.UnifiedConditionalReduction
import BlackwellDilemma.UnifiedInformationDecay
import BlackwellDilemma.UnifiedTopoCluster
import BlackwellDilemma.Infrastructure.FiniteLocalTrapEvent
import BlackwellDilemma.Infrastructure.FiniteTorusLocalSupports
import BlackwellDilemma.Infrastructure.KappaStarClosedForm
import BlackwellDilemma.Infrastructure.SeparatedBlockPlacements
import BlackwellDilemma.Infrastructure.UnboundedInProbability

namespace BlackwellDilemma.Ledger

open MeasureTheory

inductive ClaimKind where
  | theorem
  | proposition
  | lemma
  | corollary
  deriving DecidableEq, BEq, Repr

/-- Engineering route for an unclosed claim. This is scheduling metadata and
never contributes to mathematical closure. -/
inductive WorkClass where
  | local
  | mixed
  | externalLibrary
  | semanticRepair
  deriving DecidableEq, BEq, Repr

/-- Evidence carried by one manuscript claim.

`proved` is the only constructor counted as closed. `partial` stores a real
kernel proof of a strict subclaim. `conditional` stores a derivation whose
premise remains explicit. `refutedEncoding` records a machine refutation of a
retired formal target; it is evidence about the encoding, not evidence for the
paper claim. -/
inductive ClaimEvidence : Type where
  | unformalized
  | partialProof (subclaim : Prop) (proof : subclaim)
  | conditionalProof (assumption statement : Prop)
      (derive : assumption -> statement)
  | refutedEncoding (statement : Prop) (refutation : Not statement)
  | proved (statement : Prop) (proof : statement)

inductive ClaimState where
  | unformalized
  | partialEvidence
  | conditionalEvidence
  | refutedEncoding
  | closed
  deriving DecidableEq, BEq, Repr

def ClaimEvidence.state : ClaimEvidence -> ClaimState
  | .unformalized => .unformalized
  | .partialProof _ _ => .partialEvidence
  | .conditionalProof _ _ _ => .conditionalEvidence
  | .refutedEncoding _ _ => .refutedEncoding
  | .proved _ _ => .closed

/-- This flag can evaluate to true only for the constructor that contains a
proof of its stored proposition. -/
def ClaimEvidence.hasFullProof : ClaimEvidence -> Bool
  | .proved _ _ => true
  | _ => false

structure PaperClaim where
  label : String
  title : String
  kind : ClaimKind
  sourceLine : Nat
  route : WorkClass
  blocker : String
  evidence : ClaimEvidence

def PaperClaim.state (claim : PaperClaim) : ClaimState :=
  claim.evidence.state

def PaperClaim.isClosed (claim : PaperClaim) : Bool :=
  claim.state == ClaimState.closed

theorem PaperClaim.isClosed_eq_hasFullProof (claim : PaperClaim) :
    claim.isClosed = claim.evidence.hasFullProof := by
  cases hEvidence : claim.evidence <;>
    simp [PaperClaim.isClosed, PaperClaim.state, ClaimEvidence.state,
      ClaimEvidence.hasFullProof, hEvidence] <;> decide

/-! ## Kernel-proved strict subclaims

These are intentionally recorded as partial evidence. The corresponding paper
environments contain additional clauses that are not supplied by these proof
terms. -/

def DecompositionIdentityCore : Prop :=
  forall {Omega : Type} [MeasurableSpace Omega] (setup : WelfareSetup Omega),
    setup.welfare = setup.W_topo + setup.W_info

theorem decompositionIdentityCore_proved : DecompositionIdentityCore := by
  intro Omega _inst setup
  exact setup.gap_welfare_decomposition

/-- The repaired paper theorem keeps the original algebraic decomposition and
    adds the complete strategy-aligned dynamic-oracle bundle. -/
def DecompositionClaim : Prop :=
  DecompositionIdentityCore /\
    (forall {V : Type} [Fintype V] [DecidableEq V] [Nonempty V]
      {Omega : Type} [MeasurableSpace Omega]
      (setup : UnifiedWelfareSetup V Omega),
      setup.UnifiedDecompositionBundle)

theorem decompositionClaim_proved : DecompositionClaim := by
  constructor
  · exact decompositionIdentityCore_proved
  · intro V _fintype _decidableEq _nonempty Omega _measurableSpace setup
    exact setup.unifiedDecompositionBundle_proved

def PhysicalIrreducibilityClaim : Prop :=
  forall {V : Type} [Fintype V] [DecidableEq V] [Nonempty V]
    {Omega : Type} [MeasurableSpace Omega]
    (setup : UnifiedWelfareSetup V Omega),
    setup.toWelfareSetup.welfare <= setup.toWelfareSetup.W_topo /\
      setup.toWelfareSetup.W_topo <= setup.relaxedWelfareSetup.W_topo /\
      (forall beta : Real,
        HasDerivAt (fun _ : Real => setup.relaxedWelfareSetup.W_topo) 0 beta) /\
      setup.oracleWelfareSetup.welfare = setup.toWelfareSetup.W_topo /\
      (forall omega,
        setup.terminalReward omega <= setup.oracleReward omega /\
          setup.oracleReward omega <= setup.relaxedReward omega /\
          (setup.oracleReward omega = setup.relaxedReward omega ↔
            exists t : IDPState V,
              (setup.model omega).Reaches (setup.start omega) t /\
                (setup.model omega).IsStopping t /\
                (setup.model omega).welfare t.current =
                  setup.relaxedReward omega))

theorem physicalIrreducibilityClaim_proved : PhysicalIrreducibilityClaim := by
  intro V _fintype _decidableEq _nonempty Omega _measurableSpace setup
  exact
    ⟨setup.welfare_le_dynamic_topology_component,
      setup.dynamic_topology_component_le_relaxed_topology_component,
      setup.relaxed_topology_signal_immune,
      setup.oracle_welfare_eq_agent_dynamic_topology_component,
      fun omega =>
        ⟨setup.terminalReward_le_oracleReward omega,
          setup.oracleReward_le_relaxedReward omega,
          (setup.model omega).oracleValue_eq_relaxedOracleValue_iff_terminalComplete
            (setup.start omega)⟩⟩

/-! ## Manuscript inventory

The source line is the `\\begin{...}` line in the current canonical manuscript.
Closure is never read from `route` or `blocker`; it is derived solely from the
constructor of `evidence`. -/

def claimDecomposition : PaperClaim :=
  { label := "thm:decomp"
    title := "Canonical Welfare Decomposition"
    kind := .theorem
    sourceLine := 262
    route := .local
    blocker := "The relaxed identity and strategy-aligned dynamic-oracle bundle are kernel proved."
    evidence := .proved DecompositionClaim decompositionClaim_proved }

def claimInfoDecay : PaperClaim :=
  { label := "prop:info-decay"
    title := "Informational Decay"
    kind := .proposition
    sourceLine := 309
    route := .mixed
    blocker := "The regret bound, Mills specialization, signal-noise rate, topology averaging, and uniform-in-network conclusion are machine derived under the explicit pairwise-Gaussian selection interface and uniform reachable-set first-moment condition."
    evidence := .proved
      BlackwellDilemma.InformationDecay.InformationDecayClaim
      BlackwellDilemma.InformationDecay.informationDecayClaim_proved }

def claimTopoCluster : PaperClaim :=
  { label := "prop:topo-cluster"
    title := "Topological Loss - Cluster Size Relation"
    kind := .proposition
    sourceLine := 318
    route := .mixed
    blocker := "The order-statistics loss algebra, fixed-fraction conditional limit, and persistent-singleton unconditional constant-order bound are machine derived; the iid-Uniform expectation identity is reference-gated."
    evidence := .proved
      BlackwellDilemma.TopoCluster.TopoClusterClaim
      BlackwellDilemma.TopoCluster.topoClusterClaim_proved }

def claimPhysical : PaperClaim :=
  { label := "prop:physical"
    title := "Physical Irreducibility"
    kind := .proposition
    sourceLine := 345
    route := .local
    blocker := "The finite-IDP dynamic and relaxed irreducibility bounds are kernel proved; asymptotic scaling is owned by prop:topo-cluster."
    evidence := .proved PhysicalIrreducibilityClaim
      physicalIrreducibilityClaim_proved }

def claimWrongness : PaperClaim :=
  { label := "lem:wrongness"
    title := "Wrongness of the Greedy Policy Under Topology-Blind Signals"
    kind := .lemma
    sourceLine := 382
    route := .semanticRepair
    blocker := "The forced-continuation degree-two graph reduction, Gaussian route probabilities, terminal rewards, finite-precision overshoot, perfect-signal limit, and strict reversal pair are machine derived."
    evidence := .proved
      BlackwellDilemma.GreedyReversal.WrongnessClaim
      BlackwellDilemma.GreedyReversal.wrongnessClaim_proved }

def claimConditionalReduction : PaperClaim :=
  { label := "lem:conditional-reduction"
    title := "Conditional Reduction Under State Augmentation"
    kind := .lemma
    sourceLine := 409
    route := .mixed
    blocker := "Finite stochastic-kernel composition proves the fixed-reachable-set Blackwell value comparison; nonnegative averaging, topological invariance, and the topology-plus-information decomposition are machine derived."
    evidence := .proved
      BlackwellDilemma.ConditionalReduction.ConditionalReductionClaim
      BlackwellDilemma.ConditionalReduction.conditionalReductionClaim_proved }

def claimDilemma : PaperClaim :=
  { label := "thm:dilemma"
    title := "Welfare Non-Monotonicity Under Endogenous Feasibility"
    kind := .theorem
    sourceLine := 424
    route := .semanticRepair
    blocker := "The publication theorem isolates the exact forced-two-route greedy reversal; conditional oracle monotonicity and percolation asymptotics remain separately reference gated."
    evidence := .proved
      BlackwellDilemma.GreedyReversal.DilemmaClaim
      BlackwellDilemma.GreedyReversal.dilemmaClaim_proved }

def claimPhase : PaperClaim :=
  { label := "thm:phase"
    title := "Phase Transition at p_c"
    kind := .theorem
    sourceLine := 439
    route := .externalLibrary
    blocker := "Requires genuine finite-torus supercritical and subcritical percolation theorems, not witness functions."
    evidence := .unformalized }

def claimTrapPrevalence : PaperClaim :=
  { label := "prop:trap-prevalence"
    title := "Generic Trap Prevalence"
    kind := .proposition
    sourceLine := 493
    route := .local
    blocker := "The finite edge/reward product mass and ranking reversal are proved; still construct this event on Z2 and prove it is contained in the paper's dynamic-value reversal event."
    evidence := .partialProof
      BlackwellDilemma.Infrastructure.TrapPrevalenceLocalKernelBundle
      BlackwellDilemma.Infrastructure.trapPrevalenceLocalKernelBundle_proved }

def claimCognitiveThreshold : PaperClaim :=
  { label := "thm:cognitive-threshold"
    title := "Characterization of the Blackwell Regime"
    kind := .theorem
    sourceLine := 523
    route := .semanticRepair
    blocker := "Parts 1-5 need the genuine posterior/policy model; Part 6 has finite-torus supports and a cofinal closed-form depth expression, but still needs a concrete trap-tree embedding and proof that the actual posterior threshold equals or dominates that expression."
    evidence := .partialProof
      BlackwellDilemma.Infrastructure.Part6DepthGrowthKernelBundle
      BlackwellDilemma.Infrastructure.part6DepthGrowthKernelBundle_proved }

def claimThresholdAlpha : PaperClaim :=
  { label := "prop:threshold-alpha"
    title := "Cognitive Threshold Increases with Instrumental Rationality"
    kind := .proposition
    sourceLine := 570
    route := .local
    blocker := "Requires differentiability and sign hypotheses for the actual welfare transition functional."
    evidence := .unformalized }

def claimSupermodular : PaperClaim :=
  { label := "prop:supermodular"
    title := "Supermodular Complementarity"
    kind := .proposition
    sourceLine := 595
    route := .mixed
    blocker := "Algebraic Topkis infrastructure exists; the actual posterior welfare cross-partial remains to be derived."
    evidence := .unformalized }

def claimSentimental : PaperClaim :=
  { label := "prop:sentimental"
    title := "Sentimental Immunity"
    kind := .proposition
    sourceLine := 635
    route := .semanticRepair
    blocker := "Current alpha threshold is defined over a hand-coded welfare carrier; rebuild it from the IDP policy."
    evidence := .unformalized }

def claimPrincipalOptimum : PaperClaim :=
  { label := "prop:principal-optimum"
    title := "Interior Optimal Precision for Heterogeneous Populations"
    kind := .proposition
    sourceLine := 662
    route := .local
    blocker := "Needs continuity, tail behavior, and a genuine heterogeneous aggregate welfare model."
    evidence := .unformalized }

def claimCanonical : PaperClaim :=
  { label := "prop:canonical"
    title := "Canonical Welfare"
    kind := .proposition
    sourceLine := 734
    route := .semanticRepair
    blocker := "The Gaussian trap law is explicit and the four-state route expectation and limits are kernel proved."
    evidence := .proved
      BlackwellDilemma.CanonicalGaussianRoute.CanonicalWelfareClaim
      BlackwellDilemma.CanonicalGaussianRoute.canonicalWelfareClaim_proved }

def claimInteriorOptimum : PaperClaim :=
  { label := "prop:interior-optimum"
    title := "Interior Optimum"
    kind := .proposition
    sourceLine := 794
    route := .semanticRepair
    blocker := "The open-edge five-state route distribution, exact loss formula, and unique positive global minimizer are kernel proved; the reported numerical location is gated separately by deterministic computation."
    evidence := .proved
      BlackwellDilemma.FiveStateRouting.InteriorOptimumClaim
      BlackwellDilemma.FiveStateRouting.interiorOptimumClaim_proved }

def claimTwoRegimeFiveState : PaperClaim :=
  { label := "prop:two-regime-five-state"
    title := "Two-Regime Structure of the 5-State Instance"
    kind := .proposition
    sourceLine := 834
    route := .semanticRepair
    blocker := "The finite route distribution, greedy-loss regimes, strict optimal-value comparative statics, and perfect-topology loss decomposition are kernel proved; partially informative topology-signal behavior is owned by the separate cognitive claim."
    evidence := .proved
      BlackwellDilemma.FiveStateTwoRegime.TwoRegimeClaim
      BlackwellDilemma.FiveStateTwoRegime.twoRegimeClaim_proved }

def claimThresholdFiveState : PaperClaim :=
  { label := "prop:threshold-five-state"
    title := "Cognitive Sufficiency on the 5-State Instance"
    kind := .proposition
    sourceLine := 886
    route := .semanticRepair
    blocker := "The reveal-or-erasure topology experiment, explicit five-state routing welfare, reward-precision monotonicity, prior and perfect-topology endpoints, finite-precision oracle gap, and zero restoring-depth infimum are kernel proved."
    evidence := .proved
      BlackwellDilemma.FiveStateCognition.CognitiveFiveStateClaim
      BlackwellDilemma.FiveStateCognition.cognitiveFiveStateClaim_proved }

def claimPMonotonicityFiveState : PaperClaim :=
  { label := "prop:p-monotonicity-five-state"
    title := "Reward-Precision Monotonicity for Structurally Aware Five-State Agents"
    kind := .proposition
    sourceLine := 946
    route := .semanticRepair
    blocker := "The positive-depth reward-precision monotonicity, exact restoring-depth set, right-hand prior limit, finite-precision topology endpoint, strict oracle gap, and iterated oracle limit are kernel proved on the shared reveal-or-erasure carrier."
    evidence := .proved
      BlackwellDilemma.FiveStateCognition.RewardPrecisionMonotonicityClaim
      BlackwellDilemma.FiveStateCognition.rewardPrecisionMonotonicityClaim_proved }

def claimBayesianImmunity : PaperClaim :=
  { label := "thm:bayesian-immunity"
    title := "Bayesian Immunity"
    kind := .theorem
    sourceLine := 974
    route := .externalLibrary
    blocker := "Conditional on the cited Blackwell fixed-decision-problem comparison, the unified IDP stopping and signal-contingent rule sets are kernel proved nonempty and precision-independent, every rule outcome has a feasible traversal witness, the experiment sequence carries an explicit Blackwell ordering, and the finite percolation expectation lift is kernel proved."
    evidence := .conditionalProof
      BlackwellDilemma.BayesianImmunity.Blackwell1953FixedFeasiblePremise
      BlackwellDilemma.BayesianImmunity.BayesianImmunityClaim
      BlackwellDilemma.BayesianImmunity.bayesianImmunityClaim_from_blackwell }

def claimComplementarity : PaperClaim :=
  { label := "prop:complementarity"
    title := "Information-Knowledge Complementarity"
    kind := .proposition
    sourceLine := 997
    route := .mixed
    blocker := "Conditional on the cited Blackwell comparison, Bayesian derivative nonnegativity, the concrete five-state greedy derivative sign after its unique optimum, and the population-mixture cross partial are machine derived."
    evidence := .conditionalProof
      BlackwellDilemma.BayesianImmunity.Blackwell1953FixedFeasiblePremise
      BlackwellDilemma.Complementarity.ComplementarityClaim
      BlackwellDilemma.Complementarity.complementarityClaim_from_blackwell }

def claimBayesianNaiveFiveState : PaperClaim :=
  { label := "prop:bayesian-naive-five-state"
    title := "Bayesian-Naive Threshold on the 5-State Instance"
    kind := .proposition
    sourceLine := 1020
    route := .semanticRepair
    blocker := "The strict prior-only rule is derived on the concrete five-state carrier: threshold 4/9, monotone bridge regime, constant trap regime, explicit boundary tie-breaks, and oracle gap."
    evidence := .proved
      BlackwellDilemma.BayesianNaiveFiveState.BayesianNaiveFiveStateClaim
      BlackwellDilemma.BayesianNaiveFiveState.bayesianNaiveFiveStateClaim_proved }

def claimGeneralTree : PaperClaim :=
  { label := "thm:general-tree"
    title := "Non-Monotonicity on General Graphs"
    kind := .theorem
    sourceLine := 1059
    route := .semanticRepair
    blocker := "C2-prime supplies the positive greedy-path gap and the explicit C4 tail-rate certificate controls the remainder; C4 remains a graph-family model verification condition."
    evidence := .proved
      BlackwellDilemma.GeneralTreeTail.GeneralTreeReversalClaim
      BlackwellDilemma.GeneralTreeTail.generalTreeReversalClaim_proved }

def claimErrorCompounding : PaperClaim :=
  { label := "prop:error-compounding"
    title := "Error Compounding"
    kind := .proposition
    sourceLine := 1104
    route := .local
    blocker := "The independent Gaussian comparison channel, finite Bernoulli path welfare, strict exponential gain bound, and sInf cognitive threshold bracket are machine derived; the estimator threshold band remains an explicit model condition."
    evidence := .proved
      BlackwellDilemma.ErrorCompounding.ErrorCompoundingClaim
      BlackwellDilemma.ErrorCompounding.errorCompoundingClaim_proved }

def claimErPhase : PaperClaim :=
  { label := "cor:er-phase"
    title := "Phase Transition on Erdos-Renyi Graphs"
    kind := .corollary
    sourceLine := 1141
    route := .externalLibrary
    blocker := "Requires formal random-graph component-size and survival-probability results."
    evidence := .unformalized }

def claimPowerLaw : PaperClaim :=
  { label := "cor:power-law"
    title := "Application: Power-Law Networks"
    kind := .corollary
    sourceLine := 1155
    route := .externalLibrary
    blocker := "Requires a formal configuration-model percolation threshold theorem."
    evidence := .unformalized }

def paperClaims : List PaperClaim :=
  [ claimDecomposition,
    claimInfoDecay,
    claimTopoCluster,
    claimPhysical,
    claimWrongness,
    claimConditionalReduction,
    claimDilemma,
    claimPhase,
    claimTrapPrevalence,
    claimCognitiveThreshold,
    claimThresholdAlpha,
    claimSupermodular,
    claimSentimental,
    claimPrincipalOptimum,
    claimCanonical,
    claimInteriorOptimum,
    claimTwoRegimeFiveState,
    claimThresholdFiveState,
    claimPMonotonicityFiveState,
    claimBayesianImmunity,
    claimComplementarity,
    claimBayesianNaiveFiveState,
    claimGeneralTree,
    claimErrorCompounding,
    claimErPhase,
    claimPowerLaw ]

def paperClaimLabels : List String := paperClaims.map PaperClaim.label

theorem paperClaims_count : paperClaims.length = 26 := rfl

theorem paperClaimLabels_nodup : paperClaimLabels.Nodup := by decide

def paperClaimCountByState (state : ClaimState) : Nat :=
  (paperClaims.filter fun claim => claim.state == state).length

def paperClaimClosedCount : Nat := paperClaimCountByState .closed
def paperClaimPartialCount : Nat := paperClaimCountByState .partialEvidence
def paperClaimConditionalCount : Nat :=
  paperClaimCountByState .conditionalEvidence
def paperClaimRefutedEncodingCount : Nat :=
  paperClaimCountByState .refutedEncoding
def paperClaimUnformalizedCount : Nat :=
  paperClaimCountByState .unformalized

/-- Complete closure means every actual manuscript claim carries a `proved`
constructor. It is not an editable count or status flag. -/
def CompletePaperKernelOnly : Prop :=
  forall claim : PaperClaim, claim ∈ paperClaims -> claim.isClosed = true

theorem completePaperKernelOnly_notYet : Not CompletePaperKernelOnly := by
  intro hComplete
  have hMember : claimPhase ∈ paperClaims := by
    simp [paperClaims]
  have hClosed := hComplete claimPhase hMember
  exact (by decide :
    Ne (ClaimState.unformalized == ClaimState.closed) true) hClosed

def claimStateName : ClaimState -> String
  | .unformalized => "unformalized"
  | .partialEvidence => "partial"
  | .conditionalEvidence => "conditional"
  | .refutedEncoding => "refuted-encoding"
  | .closed => "closed"

def workClassName : WorkClass -> String
  | .local => "local"
  | .mixed => "mixed"
  | .externalLibrary => "external-library"
  | .semanticRepair => "semantic-repair"

def claimKindName : ClaimKind -> String
  | .theorem => "theorem"
  | .proposition => "proposition"
  | .lemma => "lemma"
  | .corollary => "corollary"

#eval IO.println s!"paper_claims_total={paperClaims.length}"
#eval IO.println s!"paper_claims_closed={paperClaimClosedCount}"
#eval IO.println s!"paper_claims_partial={paperClaimPartialCount}"
#eval IO.println s!"paper_claims_conditional={paperClaimConditionalCount}"
#eval IO.println s!"paper_claims_refuted_encoding={paperClaimRefutedEncodingCount}"
#eval IO.println s!"paper_claims_unformalized={paperClaimUnformalizedCount}"

#eval paperClaims.forM fun claim =>
  IO.println
    s!"paper_claim={claim.label}|{claimStateName claim.state}|{workClassName claim.route}"

#eval paperClaims.forM fun claim =>
  IO.println
    s!"paper_claim_meta={claim.label}|{claimKindName claim.kind}|{claim.sourceLine}"

end BlackwellDilemma.Ledger
