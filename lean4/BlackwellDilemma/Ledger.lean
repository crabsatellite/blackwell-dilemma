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
import BlackwellDilemma.UnifiedPhase
import BlackwellDilemma.UnifiedTrapPrevalence
import BlackwellDilemma.UnifiedCognitiveThreshold
import BlackwellDilemma.UnifiedThresholdAlpha
import BlackwellDilemma.UnifiedSupermodularCognition
import BlackwellDilemma.UnifiedSentimentalImmunity
import BlackwellDilemma.UnifiedPrincipalOptimum
import BlackwellDilemma.UnifiedRandomGraphPhase

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
    title := "Connectivity Phase Transition and Conditional Welfare Regimes at p_c"
    kind := .theorem
    sourceLine := 439
    route := .mixed
    blocker := "Conditional on reference-gated square-lattice giant-component and subcritical-moment profiles, the giant-conditional vanishing bound, persistent-isolation unconditional constant-order bound, and oracle information-decay comparison are kernel derived from one linked cluster law."
    evidence := .conditionalProof
      BlackwellDilemma.LatticePhase.SquareLatticePercolationPremise
      BlackwellDilemma.LatticePhase.LatticePhaseClaim
      BlackwellDilemma.LatticePhase.latticePhaseClaim_from_references }

def claimTrapPrevalence : PaperClaim :=
  { label := "prop:trap-prevalence"
    title := "Generic Trap Prevalence"
    kind := .proposition
    sourceLine := 493
    route := .local
    blocker := "Closed by an exhaustive 13-edge square-grid support, a normalized nonnegative finite product law, exact Uniform reward-window masses, exact p^10(1-p)^3/108 cylinder mass, and the induced static/dynamic ranking reversal."
    evidence := .proved
      BlackwellDilemma.TrapPrevalence.TrapPrevalenceClaim
      BlackwellDilemma.TrapPrevalence.trapPrevalenceClaim_proved }

def claimCognitiveThreshold : PaperClaim :=
  { label := "thm:cognitive-threshold"
    title := "Cognitive Crossing and Conditional Lattice Amplification"
    kind := .theorem
    sourceLine := 523
    route := .semanticRepair
    blocker := "Closed for the explicit reveal-or-erasure cognition experiment and Gaussian two-route welfare. The lattice conclusion is an exact conditional depth-witness transfer to unboundedness in probability; posterior-to-cutoff and cylinder-to-threshold identification remain stated model premises rather than hidden proof steps."
    evidence := .proved
      BlackwellDilemma.CognitiveThreshold.CognitiveThresholdClaim
      BlackwellDilemma.CognitiveThreshold.cognitiveThresholdClaim_proved }

def claimThresholdAlpha : PaperClaim :=
  { label := "prop:threshold-alpha"
    title := "Cognitive Threshold Increases with Instrumental Rationality"
    kind := .proposition
    sourceLine := 570
    route := .local
    blocker := "Closed in the explicit alpha-loaded cognitive crossing model: endpoint conditions give unique kappa thresholds, positive loading makes the threshold strictly increasing in alpha, and a fixed-kappa score inside (0, loading) gives a unique alpha crossing with exact welfare regimes."
    evidence := .proved
      BlackwellDilemma.ThresholdAlpha.ThresholdAlphaClaim
      BlackwellDilemma.ThresholdAlpha.thresholdAlphaClaim_proved }

def claimSupermodular : PaperClaim :=
  { label := "prop:supermodular"
    title := "Local Information--Cognition Complementarity"
    kind := .proposition
    sourceLine := 595
    route := .mixed
    blocker := "Closed for the explicit state-conditioned reveal-or-erasure score and the manuscript's exact Gaussian inverse-noise scale: both derivative identities and strict mixed-partial positivity on the moderate-SNR region are kernel proved; the regional increasing-differences interpretation is pinned to Topkis."
    evidence := .proved
      BlackwellDilemma.SupermodularCognition.SupermodularCognitionClaim
      BlackwellDilemma.SupermodularCognition.supermodularCognitionClaim_proved }

def claimSentimental : PaperClaim :=
  { label := "prop:sentimental"
    title := "Sentimental Immunity"
    kind := .proposition
    sourceLine := 635
    route := .semanticRepair
    blocker := "Closed for the explicit two-route alpha-weighted policy: a negative instrumental gap and positive known sentimental gap yield an interior policy-score threshold, monotone welfare below it, the deterministic sentimental endpoint, and antitone welfare above it. No universal claim remains when the sentimental gap has the opposite sign."
    evidence := .proved
      BlackwellDilemma.SentimentalImmunity.SentimentalImmunityClaim
      BlackwellDilemma.SentimentalImmunity.sentimentalImmunityClaim_proved }

def claimPrincipalOptimum : PaperClaim :=
  { label := "prop:principal-optimum"
    title := "Interior Optimal Precision for Heterogeneous Populations"
    kind := .proposition
    sourceLine := 662
    route := .semanticRepair
    blocker := "Closed for finite heterogeneous populations under explicit nonnegative weights, individual continuity, a common tail-dominance threshold, and a witnessed positive aggregate improvement. Matched cognitive shifts with pointwise increasing differences and unique aggregate optima yield monotone optimal precision. A separate continuous two-type reduced form proves that a strict precision valley can occur; threshold mass alone is not claimed to imply it."
    evidence := .proved
      BlackwellDilemma.PrincipalOptimum.PrincipalOptimumClaim
      BlackwellDilemma.PrincipalOptimum.principalOptimumClaim_proved }

def claimCanonical : PaperClaim :=
  { label := "prop:canonical"
    title := "Canonical Welfare"
    kind := .proposition
    sourceLine := 740
    route := .semanticRepair
    blocker := "The Gaussian trap law is explicit and the four-state route expectation and limits are kernel proved."
    evidence := .proved
      BlackwellDilemma.CanonicalGaussianRoute.CanonicalWelfareClaim
      BlackwellDilemma.CanonicalGaussianRoute.canonicalWelfareClaim_proved }

def claimInteriorOptimum : PaperClaim :=
  { label := "prop:interior-optimum"
    title := "Interior Optimum"
    kind := .proposition
    sourceLine := 800
    route := .semanticRepair
    blocker := "The open-edge five-state route distribution, exact loss formula, and unique positive global minimizer are kernel proved; the reported numerical location is gated separately by deterministic computation."
    evidence := .proved
      BlackwellDilemma.FiveStateRouting.InteriorOptimumClaim
      BlackwellDilemma.FiveStateRouting.interiorOptimumClaim_proved }

def claimTwoRegimeFiveState : PaperClaim :=
  { label := "prop:two-regime-five-state"
    title := "Two-Regime Structure of the 5-State Instance"
    kind := .proposition
    sourceLine := 840
    route := .semanticRepair
    blocker := "The finite route distribution, greedy-loss regimes, strict optimal-value comparative statics, and perfect-topology loss decomposition are kernel proved; partially informative topology-signal behavior is owned by the separate cognitive claim."
    evidence := .proved
      BlackwellDilemma.FiveStateTwoRegime.TwoRegimeClaim
      BlackwellDilemma.FiveStateTwoRegime.twoRegimeClaim_proved }

def claimThresholdFiveState : PaperClaim :=
  { label := "prop:threshold-five-state"
    title := "Cognitive Sufficiency on the 5-State Instance"
    kind := .proposition
    sourceLine := 892
    route := .semanticRepair
    blocker := "The reveal-or-erasure topology experiment, explicit five-state routing welfare, reward-precision monotonicity, prior and perfect-topology endpoints, finite-precision oracle gap, and zero restoring-depth infimum are kernel proved."
    evidence := .proved
      BlackwellDilemma.FiveStateCognition.CognitiveFiveStateClaim
      BlackwellDilemma.FiveStateCognition.cognitiveFiveStateClaim_proved }

def claimPMonotonicityFiveState : PaperClaim :=
  { label := "prop:p-monotonicity-five-state"
    title := "Reward-Precision Monotonicity for Structurally Aware Five-State Agents"
    kind := .proposition
    sourceLine := 952
    route := .semanticRepair
    blocker := "The positive-depth reward-precision monotonicity, exact restoring-depth set, right-hand prior limit, finite-precision topology endpoint, strict oracle gap, and iterated oracle limit are kernel proved on the shared reveal-or-erasure carrier."
    evidence := .proved
      BlackwellDilemma.FiveStateCognition.RewardPrecisionMonotonicityClaim
      BlackwellDilemma.FiveStateCognition.rewardPrecisionMonotonicityClaim_proved }

def claimBayesianImmunity : PaperClaim :=
  { label := "thm:bayesian-immunity"
    title := "Bayesian Immunity"
    kind := .theorem
    sourceLine := 980
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
    sourceLine := 1003
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
    sourceLine := 1026
    route := .semanticRepair
    blocker := "The strict prior-only rule is derived on the concrete five-state carrier: threshold 4/9, monotone bridge regime, constant trap regime, explicit boundary tie-breaks, and oracle gap."
    evidence := .proved
      BlackwellDilemma.BayesianNaiveFiveState.BayesianNaiveFiveStateClaim
      BlackwellDilemma.BayesianNaiveFiveState.bayesianNaiveFiveStateClaim_proved }

def claimGeneralTree : PaperClaim :=
  { label := "thm:general-tree"
    title := "Non-Monotonicity on General Graphs"
    kind := .theorem
    sourceLine := 1065
    route := .semanticRepair
    blocker := "C2-prime supplies the positive greedy-path gap and the explicit C4 tail-rate certificate controls the remainder; C4 remains a graph-family model verification condition."
    evidence := .proved
      BlackwellDilemma.GeneralTreeTail.GeneralTreeReversalClaim
      BlackwellDilemma.GeneralTreeTail.generalTreeReversalClaim_proved }

def claimErrorCompounding : PaperClaim :=
  { label := "prop:error-compounding"
    title := "Error Compounding"
    kind := .proposition
    sourceLine := 1110
    route := .local
    blocker := "The independent Gaussian comparison channel, finite Bernoulli path welfare, strict exponential gain bound, and sInf cognitive threshold bracket are machine derived; the estimator threshold band remains an explicit model condition."
    evidence := .proved
      BlackwellDilemma.ErrorCompounding.ErrorCompoundingClaim
      BlackwellDilemma.ErrorCompounding.errorCompoundingClaim_proved }

def claimErPhase : PaperClaim :=
  { label := "cor:er-phase"
    title := "Phase Transition on Erdos-Renyi Graphs"
    kind := .corollary
    sourceLine := 1147
    route := .externalLibrary
    blocker := "Conditional on the registry-gated Erdos-Renyi local-fragmentation and linear-giant profiles, the persistent-singleton constant-order welfare bound, giant-conditional vanishing loss, and blocking-threshold algebra are kernel derived. No synthetic random-graph carrier remains."
    evidence := .conditionalProof
      BlackwellDilemma.RandomGraphPhase.ERReferencePremise
      BlackwellDilemma.RandomGraphPhase.ERPhaseClaim
      BlackwellDilemma.RandomGraphPhase.erPhaseClaim_from_references }

def claimPowerLaw : PaperClaim :=
  { label := "cor:power-law"
    title := "Application: Power-Law Networks"
    kind := .corollary
    sourceLine := 1161
    route := .externalLibrary
    blocker := "Conditional on the registry-gated heavy-tail and finite-moment configuration-model giant profiles, the conditional welfare limit, exact finite-moment blocking threshold, and retained-moment criterion are kernel derived. The old criterion-as-definition carrier has been removed."
    evidence := .conditionalProof
      BlackwellDilemma.RandomGraphPhase.PowerLawReferencePremise
      BlackwellDilemma.RandomGraphPhase.PowerLawPhaseClaim
      BlackwellDilemma.RandomGraphPhase.powerLawPhaseClaim_from_references }

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
