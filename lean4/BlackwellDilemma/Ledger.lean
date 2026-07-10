/-
  BlackwellDilemma/Ledger.lean

  Paper-level proof ledger for "Information Value Under Endogenous
  Feasibility".  This file deliberately tracks only the 29 labelled theorem,
  proposition, lemma, and corollary environments in the manuscript.

  A claim can be closed only by constructing `ClaimEvidence.proved`, whose
  second field is a proof of the exact proposition stored in its first field.
  There is no editable `status := closed` field.
-/

import BlackwellDilemma.Basic
import BlackwellDilemma.PhysicalIrreducibility
import BlackwellDilemma.Infrastructure.FiniteLocalTrapEvent
import BlackwellDilemma.Infrastructure.FiniteTorusLocalSupports
import BlackwellDilemma.Infrastructure.KappaStarClosedForm
import BlackwellDilemma.Infrastructure.SeparatedBlockPlacements
import BlackwellDilemma.Infrastructure.TrapTreeBernoulliWelfare
import BlackwellDilemma.Infrastructure.UnboundedInProbability
import BlackwellDilemma.Infrastructure.VanishingGiantLoss

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

def TopologicalLossOrderStatisticsAlgebraCore : Prop :=
  forall n k : Nat, 1 <= k -> k <= n ->
    (n : Real) / (n + 1) - (k : Real) / (k + 1) =
      ((n : Real) - k) / ((n + 1) * (k + 1))

theorem topologicalLossOrderStatisticsAlgebraCore_proved :
    TopologicalLossOrderStatisticsAlgebraCore := by
  intro n k _hkPos _hkLe
  have hn : Ne ((n : Real) + 1) 0 := by
    exact ne_of_gt (by positivity)
  have hk : Ne ((k : Real) + 1) 0 := by
    exact ne_of_gt (by positivity)
  field_simp
  ring

def TopoClusterPartialCore : Prop :=
  TopologicalLossOrderStatisticsAlgebraCore /\
    BlackwellDilemma.Infrastructure.TopoGiantLossEnvelopePrinciple

theorem topoClusterPartialCore_proved : TopoClusterPartialCore := by
  exact ⟨topologicalLossOrderStatisticsAlgebraCore_proved,
    BlackwellDilemma.Infrastructure.topoGiantLossEnvelopePrinciple_proved⟩

/-! ## Manuscript inventory

The source line is the `\\begin{...}` line in the current canonical manuscript.
Closure is never read from `route` or `blocker`; it is derived solely from the
constructor of `evidence`. -/

def claimDecomposition : PaperClaim :=
  { label := "thm:decomp"
    title := "Canonical Welfare Decomposition"
    kind := .theorem
    sourceLine := 252
    route := .local
    blocker := "Identity is proved; sign, uniqueness, and oracle clauses still need one exact bundled statement."
    evidence := .partialProof DecompositionIdentityCore decompositionIdentityCore_proved }

def claimInfoDecay : PaperClaim :=
  { label := "prop:info-decay"
    title := "Informational Decay"
    kind := .proposition
    sourceLine := 286
    route := .mixed
    blocker := "Requires a genuine oracle kernel plus an n-uniform cluster-size bound; constant-zero carriers are excluded."
    evidence := .unformalized }

def claimTopoCluster : PaperClaim :=
  { label := "prop:topo-cluster"
    title := "Topological Loss - Cluster Size Relation"
    kind := .proposition
    sourceLine := 295
    route := .mixed
    blocker := "The algebraic ratio is proved; the conditional expectation and both asymptotic regimes remain."
    evidence := .partialProof TopoClusterPartialCore
      topoClusterPartialCore_proved }

def claimPhysical : PaperClaim :=
  { label := "prop:physical"
    title := "Physical Irreducibility"
    kind := .proposition
    sourceLine := 322
    route := .local
    blocker := "Restate the expectation inequality, tightness, and strict positive-gap clauses over one exact IDP model."
    evidence := .unformalized }

def claimWrongness : PaperClaim :=
  { label := "lem:wrongness"
    title := "Wrongness of the Greedy Policy Under Topology-Blind Signals"
    kind := .lemma
    sourceLine := 355
    route := .semanticRepair
    blocker := "Replace the hand-coded scalar reward kernel with a graph, signal, and policy-derived terminal reward."
    evidence := .unformalized }

def claimConditionalReduction : PaperClaim :=
  { label := "lem:conditional-reduction"
    title := "Conditional Reduction Under State Augmentation"
    kind := .lemma
    sourceLine := 390
    route := .mixed
    blocker := "Needs a genuine Blackwell experiment-ordering theorem on the conditional reachable action set."
    evidence := .unformalized }

def claimDilemma : PaperClaim :=
  { label := "thm:dilemma"
    title := "Welfare Non-Monotonicity Under Endogenous Feasibility"
    kind := .theorem
    sourceLine := 405
    route := .semanticRepair
    blocker := "Depends on paper-faithful wrongness, conditional reduction, and uniform information decay."
    evidence := .unformalized }

def claimPhase : PaperClaim :=
  { label := "thm:phase"
    title := "Phase Transition at p_c"
    kind := .theorem
    sourceLine := 419
    route := .externalLibrary
    blocker := "Requires genuine finite-torus supercritical and subcritical percolation theorems, not witness functions."
    evidence := .unformalized }

def claimTrapPrevalence : PaperClaim :=
  { label := "prop:trap-prevalence"
    title := "Generic Trap Prevalence"
    kind := .proposition
    sourceLine := 473
    route := .local
    blocker := "The finite edge/reward product mass and ranking reversal are proved; still construct this event on Z2 and prove it is contained in the paper's dynamic-value reversal event."
    evidence := .partialProof
      BlackwellDilemma.Infrastructure.TrapPrevalenceLocalKernelBundle
      BlackwellDilemma.Infrastructure.trapPrevalenceLocalKernelBundle_proved }

def claimCognitiveThreshold : PaperClaim :=
  { label := "thm:cognitive-threshold"
    title := "Characterization of the Blackwell Regime"
    kind := .theorem
    sourceLine := 509
    route := .semanticRepair
    blocker := "Parts 1-5 need the genuine posterior/policy model; Part 6 has finite-torus supports and a cofinal closed-form depth expression, but still needs a concrete trap-tree embedding and proof that the actual posterior threshold equals or dominates that expression."
    evidence := .partialProof
      BlackwellDilemma.Infrastructure.Part6DepthGrowthKernelBundle
      BlackwellDilemma.Infrastructure.part6DepthGrowthKernelBundle_proved }

def claimThresholdAlpha : PaperClaim :=
  { label := "prop:threshold-alpha"
    title := "Cognitive Threshold Increases with Instrumental Rationality"
    kind := .proposition
    sourceLine := 556
    route := .local
    blocker := "Requires differentiability and sign hypotheses for the actual welfare transition functional."
    evidence := .unformalized }

def claimSupermodular : PaperClaim :=
  { label := "prop:supermodular"
    title := "Supermodular Complementarity"
    kind := .proposition
    sourceLine := 581
    route := .mixed
    blocker := "Algebraic Topkis infrastructure exists; the actual posterior welfare cross-partial remains to be derived."
    evidence := .unformalized }

def claimPolicyComplementarity : PaperClaim :=
  { label := "cor:policy-complementarity"
    title := "Policy Complementarity"
    kind := .corollary
    sourceLine := 616
    route := .local
    blocker := "Close after the exact supermodularity proposition is available."
    evidence := .unformalized }

def claimSentimental : PaperClaim :=
  { label := "prop:sentimental"
    title := "Sentimental Immunity"
    kind := .proposition
    sourceLine := 623
    route := .semanticRepair
    blocker := "Current alpha threshold is defined over a hand-coded welfare carrier; rebuild it from the IDP policy."
    evidence := .unformalized }

def claimPrincipalOptimum : PaperClaim :=
  { label := "prop:principal-optimum"
    title := "Interior Optimal Precision for Heterogeneous Populations"
    kind := .proposition
    sourceLine := 650
    route := .local
    blocker := "Needs continuity, tail behavior, and a genuine heterogeneous aggregate welfare model."
    evidence := .unformalized }

def claimDisclosure : PaperClaim :=
  { label := "cor:disclosure"
    title := "Disclosure Policy Design"
    kind := .corollary
    sourceLine := 672
    route := .local
    blocker := "Close from the exact principal optimum and differentiated-policy definitions."
    evidence := .unformalized }

def claimCanonical : PaperClaim :=
  { label := "prop:canonical"
    title := "Canonical Welfare"
    kind := .proposition
    sourceLine := 737
    route := .semanticRepair
    blocker := "Replace branch-selected scalar formulas with the five-state signal and routing expectation."
    evidence := .unformalized }

def claimInteriorOptimum : PaperClaim :=
  { label := "prop:interior-optimum"
    title := "Interior Optimum"
    kind := .proposition
    sourceLine := 797
    route := .local
    blocker := "Formalize the paper loss function and prove the minimizer and numerical bound on that function."
    evidence := .unformalized }

def claimTwoRegimeFiveState : PaperClaim :=
  { label := "prop:two-regime-five-state"
    title := "Two-Regime Structure of the 5-State Instance"
    kind := .proposition
    sourceLine := 835
    route := .local
    blocker := "Bundle all clauses over the paper five-state model; theorem-name aliases do not count as closure."
    evidence := .unformalized }

def claimFiveStatePolicy : PaperClaim :=
  { label := "cor:five-state-policy"
    title := "Policy Mapping on the 5-State Instance"
    kind := .corollary
    sourceLine := 864
    route := .local
    blocker := "Depends on the exact two-regime and principal-objective results."
    evidence := .unformalized }

def claimThresholdFiveState : PaperClaim :=
  { label := "prop:threshold-five-state"
    title := "Cognitive Sufficiency on the 5-State Instance"
    kind := .proposition
    sourceLine := 884
    route := .semanticRepair
    blocker := "Replace the one-edge routing witness with the stated five-state cognitive agent."
    evidence := .unformalized }

def claimPMonotonicityFiveState : PaperClaim :=
  { label := "prop:p-monotonicity-five-state"
    title := "p-Monotonicity on the 5-State Instance"
    kind := .proposition
    sourceLine := 900
    route := .local
    blocker := "State the correct p domain and prove monotonicity for the paper threshold, excluding junk-value extensions."
    evidence := .unformalized }

def claimBayesianImmunity : PaperClaim :=
  { label := "thm:bayesian-immunity"
    title := "Bayesian Immunity"
    kind := .theorem
    sourceLine := 935
    route := .externalLibrary
    blocker := "Requires a formal Blackwell comparison-of-experiments theorem and a genuine Bayesian IDP specialization."
    evidence := .unformalized }

def claimComplementarity : PaperClaim :=
  { label := "prop:complementarity"
    title := "Information-Knowledge Complementarity"
    kind := .proposition
    sourceLine := 944
    route := .mixed
    blocker := "The arithmetic mixture lemma is insufficient; derive the dominance premise from the paper agent model."
    evidence := .unformalized }

def claimBayesianNaiveFiveState : PaperClaim :=
  { label := "prop:bayesian-naive-five-state"
    title := "Bayesian-Naive Threshold on the 5-State Instance"
    kind := .proposition
    sourceLine := 962
    route := .semanticRepair
    blocker := "Rebuild reversal and recovery from the stated Bayesian-naive routing rule."
    evidence := .unformalized }

def claimGeneralTree : PaperClaim :=
  { label := "thm:general-tree"
    title := "Non-Monotonicity on General Graphs"
    kind := .theorem
    sourceLine := 1001
    route := .semanticRepair
    blocker := "Current wrapper uses a manufactured kernel witness; derive the reversal from V_g, reachability, and C2-prime."
    evidence := .unformalized }

def claimErrorCompounding : PaperClaim :=
  { label := "prop:error-compounding"
    title := "Error Compounding"
    kind := .proposition
    sourceLine := 1050
    route := .local
    blocker := "The finite Bernoulli choice model proves Parts 1-4 and the displayed depth closed form is cofinal; still derive the Gaussian bridge probability and identify cStar from the actual posterior threshold equation."
    evidence := .partialProof
      BlackwellDilemma.Infrastructure.ErrorCompoundingKernelBundle
      BlackwellDilemma.Infrastructure.errorCompoundingKernelBundle_proved }

def claimErPhase : PaperClaim :=
  { label := "cor:er-phase"
    title := "Phase Transition on Erdos-Renyi Graphs"
    kind := .corollary
    sourceLine := 1087
    route := .externalLibrary
    blocker := "Requires formal random-graph component-size and survival-probability results."
    evidence := .unformalized }

def claimPowerLaw : PaperClaim :=
  { label := "cor:power-law"
    title := "Application: Power-Law Networks"
    kind := .corollary
    sourceLine := 1101
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
    claimPolicyComplementarity,
    claimSentimental,
    claimPrincipalOptimum,
    claimDisclosure,
    claimCanonical,
    claimInteriorOptimum,
    claimTwoRegimeFiveState,
    claimFiveStatePolicy,
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

theorem paperClaims_count : paperClaims.length = 29 := rfl

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
  have hMember : claimDecomposition ∈ paperClaims := by
    simp [paperClaims]
  have hClosed := hComplete claimDecomposition hMember
  exact (by decide :
    Ne (ClaimState.partialEvidence == ClaimState.closed) true) hClosed

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

#eval IO.println s!"paper_claims_total={paperClaims.length}"
#eval IO.println s!"paper_claims_closed={paperClaimClosedCount}"
#eval IO.println s!"paper_claims_partial={paperClaimPartialCount}"
#eval IO.println s!"paper_claims_conditional={paperClaimConditionalCount}"
#eval IO.println s!"paper_claims_refuted_encoding={paperClaimRefutedEncodingCount}"
#eval IO.println s!"paper_claims_unformalized={paperClaimUnformalizedCount}"

#eval paperClaims.forM fun claim =>
  IO.println
    s!"paper_claim={claim.label}|{claimStateName claim.state}|{workClassName claim.route}"

end BlackwellDilemma.Ledger
