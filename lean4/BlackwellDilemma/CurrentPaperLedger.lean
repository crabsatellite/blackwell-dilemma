/- Proof-carrying ledger for the current 17-page Theory and Decision paper. -/

import BlackwellDilemma.CurrentPosterior
import BlackwellDilemma.CurrentTwoAction
import BlackwellDilemma.CurrentRouteReversal
import BlackwellDilemma.CurrentCognition
import BlackwellDilemma.CurrentComplementarity
import BlackwellDilemma.CurrentFiveState
import BlackwellDilemma.UnifiedIDP
import BlackwellDilemma.UnifiedWelfare

namespace BlackwellDilemma.CurrentPaperLedger

open BlackwellDilemma.CurrentPosterior
open BlackwellDilemma.CurrentTwoAction
open BlackwellDilemma.CurrentRouteReversal
open BlackwellDilemma.CurrentGaussian
open BlackwellDilemma.CurrentCognition
open BlackwellDilemma.CurrentComplementarity
open BlackwellDilemma.CurrentFiveState

inductive ObjectKind where
  | definition
  | theorem
  | proposition
  | lemma
  deriving DecidableEq, BEq, Repr

inductive Evidence : Type where
  | definitional
  | proved (statement : Prop) (proof : statement)
  | conditional (assumption statement : Prop) (derive : assumption -> statement)
  | unformalized

def Evidence.isUnfinished : Evidence -> Bool
  | .conditional _ _ _ => true
  | .unformalized => true
  | _ => false

def Evidence.isClosed : Evidence -> Bool
  | .definitional => true
  | .proved _ _ => true
  | _ => false

structure Entry where
  label : String
  title : String
  kind : ObjectKind
  binding : String
  evidence : Evidence

def PosteriorConvexityFrontierClaim : Prop :=
  forall (Theta : Type) [Fintype Theta]
    (g : (Theta -> Real) -> Real),
    RespectsFiniteBlackwellRefinements Theta g <->
      ConvexOn Real (posteriorSet Theta) g

theorem posteriorConvexityFrontierClaim_proved :
    PosteriorConvexityFrontierClaim := by
  intro Theta _ g
  exact posteriorConvexityFrontier Theta g

def TwoActionAlignmentClaim : Prop :=
  forall (E : Type) [NormedAddCommGroup E] [NormedSpace Real E]
    [FiniteDimensional Real E]
    (U0 Dv Du : E →ₗ[Real] Real) (boundaryGap : Real) (C : Set E),
    Convex Real C -> (0 : E) ∈ interior C -> AbsorbsDirections C -> Dv ≠ 0 ->
      (ConvexOn Real C
          (twoActionWelfareWithBoundary U0 Dv Du boundaryGap) <->
        boundaryGap = 0 /\ PositivelyAligned Dv Du)

theorem twoActionAlignmentClaim_proved : TwoActionAlignmentClaim := by
  intro E _ _ _ U0 Dv Du boundaryGap C hC hInterior hAbsorb hDv
  exact twoActionAffineAlignmentOnInteriorDomain
    U0 Dv Du boundaryGap C hC hInterior hAbsorb hDv

def RouteReversalClaim : Prop :=
  forall routeOneValue routeTwoValue scoreGap : Real,
    0 < scoreGap -> routeOneValue < routeTwoValue ->
      (forall beta,
        terminalWelfare routeOneValue routeTwoValue scoreGap beta =
          routeOneValue +
            Phi (-scoreGap * CurrentRouteReversal.precisionScale beta) *
              (routeTwoValue - routeOneValue)) /\
      StrictAntiOn
        (terminalWelfare routeOneValue routeTwoValue scoreGap)
        (Set.Ioi 0)

theorem routeReversalClaim_proved : RouteReversalClaim := by
  intro routeOneValue routeTwoValue scoreGap hGap hContinuation
  exact ⟨terminalWelfare_formula routeOneValue routeTwoValue scoreGap,
    routeReversal_strictAntiOn hGap hContinuation⟩

def RestorationClaim : Prop :=
  (forall (Theta Action : Type) [Fintype Theta]
    [Fintype Action] [Nonempty Action]
    (M : PosteriorDecisionModel Theta Action),
    (forall action theta,
      M.subjectivePayoff action theta = M.objectivePayoff action theta) ->
      RespectsFiniteBlackwellRefinements Theta M.inducedPosteriorWelfare) /\
  (forall (Omega : Type) [Fintype Omega]
    (weight before after : Omega -> Real),
    (forall omega, 0 <= weight omega) ->
    (forall omega, before omega <= after omega) ->
      finiteExpectation weight before <= finiteExpectation weight after)

theorem restorationClaim_proved : RestorationClaim := by
  constructor
  · intro Theta Action _ _ _ M hAligned
    exact alignedObjective_respectsFiniteBlackwellRefinements Theta M hAligned
  · intro Omega _ weight before after hWeight hPointwise
    exact finiteExpectation_mono hWeight hPointwise

def FeasibilityPolicyDecompositionClaim : Prop :=
  forall {V : Type} [Fintype V] [DecidableEq V] [Nonempty V]
    {Omega : Type} [MeasurableSpace Omega]
    (setup : UnifiedWelfareSetup V Omega),
      setup.toWelfareSetup.welfare =
        setup.toWelfareSetup.W_topo + setup.toWelfareSetup.W_info /\
      setup.toWelfareSetup.W_topo <= 0 /\
      setup.toWelfareSetup.W_info <= 0 /\
      setup.oracleWelfareSetup.welfare = setup.toWelfareSetup.W_topo

theorem feasibilityPolicyDecompositionClaim_proved :
    FeasibilityPolicyDecompositionClaim := by
  intro V _ _ _ Omega _ setup
  exact ⟨setup.welfare_decomposition,
    setup.dynamic_topology_component_nonpos,
    setup.informational_residual_nonpos,
    setup.oracle_welfare_eq_agent_dynamic_topology_component⟩

def ComplementarityClaim : Prop :=
  BlackwellDilemma.CurrentComplementarity.LocalComplementarityClaim

theorem complementarityClaim_proved : ComplementarityClaim :=
  BlackwellDilemma.CurrentComplementarity.localComplementarityClaim_proved

def InteriorOptimumClaim : Prop :=
  BlackwellDilemma.CurrentFiveState.InteriorOptimumClaim

theorem interiorOptimumClaim_proved : InteriorOptimumClaim :=
  BlackwellDilemma.CurrentFiveState.interiorOptimumClaim_proved

def entryPosteriorWelfare : Entry :=
  { label := "def:posterior-welfare"
    title := "Induced posterior welfare"
    kind := .definition
    binding := "CurrentPosterior.PosteriorDecisionModel"
    evidence := .definitional }

def entryConvexityFrontier : Entry :=
  { label := "thm:convexity-frontier"
    title := "Posterior-convexity frontier"
    kind := .theorem
    binding := "CurrentPosterior.posteriorConvexityFrontier"
    evidence := .proved PosteriorConvexityFrontierClaim
      posteriorConvexityFrontierClaim_proved }

def entryTwoActionAlignment : Entry :=
  { label := "thm:two-action-alignment"
    title := "Two-action alignment"
    kind := .theorem
    binding := "CurrentTwoAction.twoActionAffineAlignmentOnInteriorDomain"
    evidence := .proved TwoActionAlignmentClaim
      twoActionAlignmentClaim_proved }

def entryIDP : Entry :=
  { label := "def:idp"
    title := "Irreversibility Decision Problem"
    kind := .definition
    binding := "IDPModel; IDPState.initial; IDPModel.Step; IDPModel.IsStopping; UnifiedWelfareSetup"
    evidence := .definitional }

def entryRouteReversal : Entry :=
  { label := "thm:route-reversal"
    title := "Route-reversal theorem"
    kind := .theorem
    binding := "CurrentRouteReversal.routeReversal_strictAntiOn"
    evidence := .proved RouteReversalClaim routeReversalClaim_proved }

def entryRestoration : Entry :=
  { label := "thm:restoration"
    title := "Restoration under feasibility knowledge"
    kind := .theorem
    binding := "CurrentPosterior.alignedObjective_respectsFiniteBlackwellRefinements"
    evidence := .proved RestorationClaim restorationClaim_proved }

def entryDecomposition : Entry :=
  { label := "lem:decomposition"
    title := "Feasibility and policy decomposition"
    kind := .lemma
    binding := "UnifiedWelfareSetup.welfare_decomposition"
    evidence := .proved FeasibilityPolicyDecompositionClaim
      feasibilityPolicyDecompositionClaim_proved }

def entryCognitiveThreshold : Entry :=
  { label := "thm:cognitive-threshold"
    title := "Cognitive threshold"
    kind := .theorem
    binding := "CurrentCognition.cognitiveThresholdClaim_proved"
    evidence := .proved CognitiveThresholdClaim cognitiveThresholdClaim_proved }

def entryComplementarity : Entry :=
  { label := "prop:complementarity"
    title := "Local information-knowledge complementarity"
    kind := .proposition
    binding := "CurrentComplementarity.localComplementarityClaim_proved"
    evidence := .proved ComplementarityClaim complementarityClaim_proved }

def entryInteriorOptimum : Entry :=
  { label := "prop:interior-optimum"
    title := "Interior optimal precision"
    kind := .proposition
    binding := "CurrentFiveState.interiorOptimumClaim_proved"
    evidence := .proved InteriorOptimumClaim interiorOptimumClaim_proved }

def currentPaperEntries : List Entry := [
  entryPosteriorWelfare,
  entryConvexityFrontier,
  entryTwoActionAlignment,
  entryIDP,
  entryRouteReversal,
  entryRestoration,
  entryDecomposition,
  entryCognitiveThreshold,
  entryComplementarity,
  entryInteriorOptimum
]

def currentPaperLabels : List String := currentPaperEntries.map Entry.label

def currentPaperUnfinished : List Entry :=
  currentPaperEntries.filter fun entry => entry.evidence.isUnfinished

def currentPaperClosed : List Entry :=
  currentPaperEntries.filter fun entry => entry.evidence.isClosed

theorem currentPaper_count : currentPaperEntries.length = 10 := by decide

theorem currentPaper_labels_nodup : currentPaperLabels.Nodup := by decide

theorem currentPaper_no_unfinished : currentPaperUnfinished.length = 0 := by decide

theorem currentPaper_all_closed : currentPaperClosed.length = 10 := by decide

end BlackwellDilemma.CurrentPaperLedger
