/-
  BlackwellDilemma/PaperSemanticGate.lean

  Machine-readable gate for the distinction between:

  * the closed kernel theorem surface (no source axioms, no proof escapes), and
  * complete paper-semantic kernel-only closure.

  This file is imported by the root module, so `lake build BlackwellDilemma`
  checks the semantic ledger counts.  It intentionally keeps remaining
  paper-facing semantic targets visible instead of allowing the README or
  calibration matrix to overclaim complete paper-semantic closure.
-/

import BlackwellDilemma.Cognitive
import BlackwellDilemma.Canonical
import BlackwellDilemma.Phase

namespace BlackwellDilemma
namespace PaperSemanticGate

inductive SemanticStatus where
  | closed
  | open
  deriving DecidableEq, BEq, Repr

structure SemanticTarget where
  id : String
  paperLabel : String
  status : SemanticStatus
  shortReason : String
  closeRoute : String
  deriving Repr

/-- Semantic targets that must close before claiming complete paper-semantic
kernel-only proof of the full manuscript statements, not merely the current
kernel-clean theorem surface. -/
def semanticTargets : List SemanticTarget :=
  [ { id := "r10_two_regime_label_recalibration",
      paperLabel := "prop:two-regime-five-state",
      status := SemanticStatus.closed,
      shortReason :=
        "Paper R10 relabeling is now represented by gap_two_regime_* aliases.",
      closeRoute :=
        "Typed gate payload r10_two_regime_label_recalibration_payload over the Canonical.lean paper-facing aliases." },
    { id := "theorem_4_1_part4_lattice_p_monotonicity",
      paperLabel := "thm:cognitive-threshold Part 4",
      status := SemanticStatus.open,
      shortReason :=
        "The bounded abstract and constructive-instance p-monotonicity payload is gated, but the lattice/domain carrier bridge is still not a closed paper-faithful theorem.",
      closeRoute :=
        "Current typed frontier: part4_lattice_p_monotonicity_frontier_payload. To close: replace the abstract bounded route with an explicit lattice/domain carrier where kappaStar monotonicity follows from a proved graph/percolation monotone-coupling theorem." },
    { id := "r10_threshold_five_state_high_kappa_routing",
      paperLabel := "prop:threshold-five-state clause iii",
      status := SemanticStatus.closed,
      shortReason :=
        "The paper R10 high-kappa signal-conditional routing clause is now represented by a one-edge signal-conditional carrier achieving oracle 1 - 0.4p.",
      closeRoute :=
        "FiveState.highKappaOracleRoutingWelfare_eq_oracle; the neutral kappaAgent obstruction FiveState.not_current_kappaAgent_highKappa_oracle_at_p0 remains as diagnostic evidence for the retired carrier route." },
    { id := "theorem_4_1_part6_lattice_embedding",
      paperLabel := "thm:cognitive-threshold Part 6",
      status := SemanticStatus.open,
      shortReason :=
        "The current scaling-transfer payload and obstruction diagnostics are gated, but the full lattice embedding route remains a semantic carrier repair.",
      closeRoute :=
        "Current typed frontier: part6_lattice_embedding_frontier_payload. To close: connect trap-tree embeddings to a finite/infinite Z2 lattice percolation carrier with proved positive occurrence and domination." },
    { id := "topo_cluster_random_supercritical_z2",
      paperLabel := "prop:topo-cluster and thm:phase",
      status := SemanticStatus.open,
      shortReason :=
        "The current topo/phase payload is gated and kernel-clean, but it is still a diagnostic/flat finite carrier rather than the full random supercritical Z2_L giant-component theorem.",
      closeRoute :=
        "Current typed frontier: topo_cluster_random_supercritical_z2_frontier_payload. To close: replace the diagnostic/flat carrier with a random finite Z2_L giant-component/topological-loss lower-bound theorem." } ]

def openSemanticTargets : List SemanticTarget :=
  semanticTargets.filter (fun t => t.status == SemanticStatus.open)

def closedSemanticTargets : List SemanticTarget :=
  semanticTargets.filter (fun t => t.status == SemanticStatus.closed)

def paperSemanticOpenCount : Nat :=
  openSemanticTargets.length

def paperSemanticClosedCount : Nat :=
  closedSemanticTargets.length

/-- Typed frontier for the open Theorem 4.1 Part 4 lattice p-monotonicity
target.  This does not close the lattice semantic target: it machine-checks
the already closed kernel payload that the final lattice carrier must refine.
The remaining gap is the lattice/domain carrier bridge, not the bounded
`kappaStar` monotonicity calculus. -/
structure Part4LatticePMonotonicityFrontierPayload where
  mean_gap_antitone :
    ∀ p₁ p₂ : ℝ, p₁ ≤ p₂ →
      ∀ κ : ℝ, 0 < κ →
        mean_estimate_gap p₂ κ ≤ mean_estimate_gap p₁ κ
  generic_antitone_transfer :
    (∀ p₁ p₂ : ℝ, p₁ ≤ p₂ →
      ∀ κ : ℝ, 0 < κ →
        mean_estimate_gap p₂ κ ≤ mean_estimate_gap p₁ κ) →
    ∀ α p₁ p₂ : ℝ, p₁ ≤ p₂ →
      (∃ κ : ℝ, 0 < κ ∧
        BlackwellDilemma.Infrastructure.alphaWelfareShift α ≤
          mean_estimate_gap p₂ κ) →
      kappaStar p₁ α ≤ kappaStar p₂ α
  abstract_bounded_kappaStar_monotone :
    ∀ α p₁ p₂ : ℝ, p₁ ≤ p₂ →
      (∃ κ : ℝ, 0 < κ ∧
        BlackwellDilemma.Infrastructure.alphaWelfareShift α ≤
          mean_estimate_gap p₂ κ) →
      kappaStar p₁ α ≤ kappaStar p₂ α
  standard_bernoulli_edge_coupling :
    ∀ p_low p_high : ℝ, 0 ≤ p_low -> p_low ≤ p_high -> p_high ≤ 1 ->
      BlackwellDilemma.Infrastructure.BernoulliMonotoneCouplingData
        p_low p_high
  standard_finite_product_coupling :
    ∀ (E : Type) [Fintype E] [DecidableEq E],
      ∀ p_low p_high : ℝ, 0 ≤ p_low -> p_low ≤ p_high -> p_high ≤ 1 ->
        BlackwellDilemma.Infrastructure.BernoulliProductMonotoneCouplingMarginalData
          (E := E) p_low p_high
  finite_product_expectation_monotone :
    ∀ (E : Type) [Fintype E] [DecidableEq E],
      ∀ p_low p_high : ℝ, 0 ≤ p_low -> p_low ≤ p_high -> p_high ≤ 1 ->
        ∀ f : (E -> Bool) -> ℝ,
          BlackwellDilemma.Infrastructure.BoolConfigMonotone f ->
            BlackwellDilemma.Infrastructure.bernoulliProductExpectation
              p_low f ≤
            BlackwellDilemma.Infrastructure.bernoulliProductExpectation
              p_high f
  finite_bond_percolation_expectation_monotone :
    ∀ (E : Type) [Fintype E] [DecidableEq E],
      ∀ p_low p_high : ℝ, 0 ≤ p_low -> p_low ≤ p_high -> p_high ≤ 1 ->
        ∀ f : BlackwellDilemma.BondConfig E -> ℝ,
          BlackwellDilemma.Infrastructure.BoolConfigMonotone f ->
            BlackwellDilemma.percExpectation p_low f ≤
              BlackwellDilemma.percExpectation p_high f
  bridge_prior_reward_observable_mono :
    BlackwellDilemma.Infrastructure.BoolConfigMonotone
      BlackwellDilemma.Infrastructure.MeanEstimateGap.bridgePriorRewardObservable
  bridge_prior_reward_observable_eq_prior_mean :
    ∀ p : ℝ,
      BlackwellDilemma.percExpectation (1 - p)
        BlackwellDilemma.Infrastructure.MeanEstimateGap.bridgePriorRewardObservable =
          BlackwellDilemma.Infrastructure.MeanEstimateGap.priorMean_u2_fiveState p
  bridge_prior_mean_antitone_from_percExpectation :
    ∀ p₁ p₂ : ℝ, 0 ≤ p₁ -> p₁ ≤ p₂ -> p₂ ≤ 1 ->
      BlackwellDilemma.Infrastructure.MeanEstimateGap.priorMean_u2_fiveState p₂ ≤
        BlackwellDilemma.Infrastructure.MeanEstimateGap.priorMean_u2_fiveState p₁
  mean_gap_antitone_from_percExpectation :
    ∀ p₁ p₂ κ : ℝ, 0 ≤ p₁ -> p₁ ≤ p₂ -> p₂ ≤ 1 -> 0 < κ ->
      mean_estimate_gap p₂ κ ≤ mean_estimate_gap p₁ κ
  kappaStar_monotone_from_percExpectation :
    ∀ α p₁ p₂ : ℝ, 0 ≤ p₁ -> p₁ ≤ p₂ -> p₂ ≤ 1 ->
      (∃ κ : ℝ, 0 < κ ∧
        BlackwellDilemma.Infrastructure.alphaWelfareShift α ≤
          mean_estimate_gap p₂ κ) →
      kappaStar p₁ α ≤ kappaStar p₂ α
  standard_z2_lattice_monotone_coupling :
    BlackwellDilemma.Infrastructure.BondPercolationLattice.LatticeMonotoneCouplingData
      2
  lattice_bridge_transfer :
    ∀ _bridge : LatticePMonotonicityBridgeData,
      ∀ α p₁ p₂ : ℝ, p₁ ≤ p₂ →
        (∃ κ : ℝ, 0 < κ ∧
          BlackwellDilemma.Infrastructure.alphaWelfareShift α ≤
            mean_estimate_gap p₂ κ) →
        kappaStar p₁ α ≤ kappaStar p₂ α
  standard_z2_bridge_skeleton_current :
    LatticePMonotonicityBridgeData
  standard_z2_bridge_skeleton_transfer :
    ∀ α p₁ p₂ : ℝ, p₁ ≤ p₂ →
      (∃ κ : ℝ, 0 < κ ∧
        BlackwellDilemma.Infrastructure.alphaWelfareShift α ≤
          mean_estimate_gap p₂ κ) →
      kappaStar p₁ α ≤ kappaStar p₂ α
  ranged_lattice_bridge_transfer :
    forall _bridge : RangedLatticePMonotonicityBridgeData,
      forall alpha p1 p2 : Real, 0 <= p1 -> p1 <= p2 -> p2 <= 1 ->
        (Exists (fun kappa : Real =>
          0 < kappa /\
            BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
              mean_estimate_gap p2 kappa)) ->
        kappaStar p1 alpha <= kappaStar p2 alpha
  standard_z2_ranged_bridge_current :
    RangedLatticePMonotonicityBridgeData
  standard_z2_ranged_bridge_transfer :
    forall alpha p1 p2 : Real, 0 <= p1 -> p1 <= p2 -> p2 <= 1 ->
      (Exists (fun kappa : Real =>
        0 < kappa /\
          BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
            mean_estimate_gap p2 kappa)) ->
      kappaStar p1 alpha <= kappaStar p2 alpha
  constructive_five_state_bounded_monotone :
    ∀ p₁ p₂ : ℝ, p₁ ≤ p₂ → p₂ < 1 →
      FiveState.kappaStar_fiveState p₁ ≤
        FiveState.kappaStar_fiveState p₂

/-- Build gate: the open Part 4 lattice target is calibrated against the
current closed kernel payload.  The semantic target remains open until this
frontier is refined to a genuine lattice/domain carrier theorem. -/
noncomputable def part4_lattice_p_monotonicity_frontier_payload :
    Part4LatticePMonotonicityFrontierPayload where
  mean_gap_antitone :=
    mean_estimate_gap_antitone_in_p_paper_Def
  generic_antitone_transfer :=
    kappaStar_p_monotone_of_mean_gap_antitone
  abstract_bounded_kappaStar_monotone :=
    gap_cognitive_threshold_part4
  standard_bernoulli_edge_coupling :=
    BlackwellDilemma.Infrastructure.standardBernoulliMonotoneCouplingData
  standard_finite_product_coupling := by
    intro E _instF _instD p_low p_high h_low_nonneg h_mono h_high_le_one
    exact BlackwellDilemma.Infrastructure.standardBernoulliProductMonotoneCouplingMarginalData
      (E := E) p_low p_high h_low_nonneg h_mono h_high_le_one
  finite_product_expectation_monotone := by
    intro E _instF _instD p_low p_high h_low_nonneg h_mono h_high_le_one f hf
    exact BlackwellDilemma.Infrastructure.bernoulliProductExpectation_mono_of_monotone
      (E := E) h_low_nonneg h_mono h_high_le_one f hf
  finite_bond_percolation_expectation_monotone := by
    intro E _instF _instD p_low p_high h_low_nonneg h_mono h_high_le_one f hf
    exact BlackwellDilemma.percExpectation_mono_in_p_of_BoolConfigMonotone
      (E := E) h_low_nonneg h_mono h_high_le_one f hf
  bridge_prior_reward_observable_mono :=
    BlackwellDilemma.Infrastructure.MeanEstimateGap.bridgePriorRewardObservable_mono
  bridge_prior_reward_observable_eq_prior_mean :=
    BlackwellDilemma.Infrastructure.MeanEstimateGap.bridgePriorRewardObservable_expectation_eq_priorMean_u2
  bridge_prior_mean_antitone_from_percExpectation := by
    intro p₁ p₂ hp₁_nonneg hp_mono hp₂_le_one
    exact BlackwellDilemma.Infrastructure.MeanEstimateGap.priorMean_u2_fiveState_antitone_in_p_from_percExpectation
      hp₁_nonneg hp_mono hp₂_le_one
  mean_gap_antitone_from_percExpectation := by
    intro p₁ p₂ κ hp₁_nonneg hp_mono hp₂_le_one hκ
    exact mean_estimate_gap_antitone_in_p_from_percExpectation
      hp₁_nonneg hp_mono hp₂_le_one hκ
  kappaStar_monotone_from_percExpectation := by
    intro α p₁ p₂ hp₁_nonneg hp_mono hp₂_le_one h_nonempty
    exact gap_cognitive_threshold_part4_from_percExpectation
      α p₁ p₂ hp₁_nonneg hp_mono hp₂_le_one h_nonempty
  standard_z2_lattice_monotone_coupling :=
    BlackwellDilemma.Infrastructure.BondPercolationLattice.standardLatticeMonotoneCouplingData
      2
  lattice_bridge_transfer :=
    gap_cognitive_threshold_part4_from_lattice_bridge
  standard_z2_bridge_skeleton_current :=
    standardZ2LatticePMonotonicityBridgeSkeleton_current
  standard_z2_bridge_skeleton_transfer :=
    gap_cognitive_threshold_part4_from_standard_z2_bridge_skeleton_current
  ranged_lattice_bridge_transfer :=
    gap_cognitive_threshold_part4_from_ranged_lattice_bridge
  standard_z2_ranged_bridge_current :=
    standardZ2RangedLatticePMonotonicityBridge_current
  standard_z2_ranged_bridge_transfer :=
    gap_cognitive_threshold_part4_from_standard_z2_ranged_bridge_current
  constructive_five_state_bounded_monotone :=
    FiveState.gap_p_monotonicity_bounded

/-- Typed frontier for the open Theorem 4.1 Part 6 lattice-embedding target.
This does not close the semantic target: it machine-checks the current
kernel-solid transfer layer and the two obstruction diagnostics that force a
replacement lattice/percolation carrier. -/
structure Part6LatticeEmbeddingFrontierPayload where
  z2_lattice_graph_standard :
    SimpleGraph.Z2LatticeGraph = SimpleGraph.integerLatticeGraph 2
  prototype_diverges :
    BlackwellDilemma.Infrastructure.DivergesAtBelowAtTop
      criticalHyperbolicScaling harrisKestenCriticalProb
  lower_envelope_dominates :
    ∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb ≤ α →
      ∀ p : ℝ, p < harrisKestenCriticalProb →
        harrisKestenScalingFunction p ≤ kappaStar p α
  transfer_interface :
    ∀ s : ℝ → ℝ,
      BlackwellDilemma.Infrastructure.DivergesAtBelowAtTop
        s harrisKestenCriticalProb →
      (∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb ≤ α →
        ∀ p : ℝ, p < harrisKestenCriticalProb →
          s p ≤ kappaStar p α) →
      ∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α →
        ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
          ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
            p < harrisKestenCriticalProb →
              M < kappaStar p α
  lower_envelope_divergence_obstruction :
    ¬ BlackwellDilemma.Infrastructure.DivergesAtBelowAtTop
      harrisKestenScalingFunction harrisKestenCriticalProb
  hyperbolic_domination_obstruction :
    ¬ ∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb ≤ α →
      ∀ p : ℝ, p < harrisKestenCriticalProb →
        criticalHyperbolicScaling p ≤ kappaStar p α
  lower_envelope_bridge_obstruction :
    ¬ ∃ bridge : Z2LatticeEmbeddingBridgeData,
      bridge.scalingCarrier = harrisKestenScalingFunction
  hyperbolic_bridge_obstruction :
    ¬ ∃ bridge : Z2LatticeEmbeddingBridgeData,
      bridge.scalingCarrier = criticalHyperbolicScaling
  z2_lattice_embedding_bridge_transfer :
    ∀ _bridge : Z2LatticeEmbeddingBridgeData,
      ∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α →
        ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
          ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
            p < harrisKestenCriticalProb →
              M < kappaStar p α

/-- Build gate: the open Part 6 lattice-embedding target is calibrated
against the current transfer layer and current-carrier obstructions.  The
semantic target remains open until a genuine lattice/percolation carrier
supplies both divergence and domination without the documented obstructions. -/
def part6_lattice_embedding_frontier_payload :
    Part6LatticeEmbeddingFrontierPayload where
  z2_lattice_graph_standard := rfl
  prototype_diverges :=
    criticalHyperbolicScaling_diverges_at_pc
  lower_envelope_dominates :=
    kappaStar_dominates_percolation_scaling_paper_Def
  transfer_interface :=
    gap_cognitive_threshold_part6
  lower_envelope_divergence_obstruction :=
    not_harrisKestenScalingFunction_diverges_at_pc_paper_Def
  hyperbolic_domination_obstruction :=
    not_criticalHyperbolicScaling_dominates_kappaStar_current
  lower_envelope_bridge_obstruction :=
    not_z2_lattice_embedding_bridge_with_harrisKestenScalingFunction
  hyperbolic_bridge_obstruction :=
    not_z2_lattice_embedding_bridge_with_criticalHyperbolicScaling
  z2_lattice_embedding_bridge_transfer :=
    gap_cognitive_threshold_part6_from_z2_lattice_embedding_bridge

/-- Typed frontier for the open random supercritical `Z2_L`
topological-cluster/phase target.  This does not close the semantic target:
it machine-checks the current closed theorem surface and the obstruction
evidence showing why the remaining paper claim still needs a real random
finite-lattice giant-component/topological-loss carrier. -/
structure TopoClusterRandomSupercriticalZ2FrontierPayload where
  conditional_expectation_def :
    ∀ n k : ℕ, 1 ≤ k → k ≤ n →
      expectedTopoLoss_conditional n k =
        (n : ℝ) / (n + 1) - (k : ℝ) / (k + 1)
  conditional_expectation_closed_form :
    ∀ n k : ℕ, 1 ≤ k → k ≤ n →
      expectedTopoLoss_conditional n k =
        ((n : ℝ) - k) / ((n + 1) * (k + 1))
  below_threshold_topo_loss_on_giant :
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∀ n : ℕ, N ≤ n → expectedTopoLossOnGiant n p < ε
  below_threshold_phase :
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∀ n : ℕ, N ≤ n → expectedTopoLossOnGiant n p < ε
  above_threshold_phase_current :
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ β : ℝ, 0 < β →
          wInfoTopoRatio p β ≤ c * Real.rpow 2 (-β)
  z2_lattice_graph_standard :
    SimpleGraph.Z2LatticeGraph = SimpleGraph.integerLatticeGraph 2
  z2_topo_cluster_bridge_core :
    ∀ bridge : Z2TopoClusterBridgeData,
      BoxedTorusFlatFamilyCoreConclusion bridge.family
  z2_topo_cluster_bridge_lower_bound :
    ∀ bridge : Z2TopoClusterBridgeData,
      BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion
        bridge.family
  boxed_torus_flat_lower_bound_current :
    BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion
      boxedTorusFullReachFlatOnlyComplementTopoLossData
  boxed_torus_family_core_current :
    BoxedTorusFlatFamilyCoreConclusion
      boxedTorusFullReachFlatOnlyComplementTopoLossData
  boxed_torus_flat_only_diagnostic_current :
    (∀ L n : ℕ, ∀ p : ℝ, n ≠ boxedTorusFlatGraphN L →
      expectedTopoLossOnData
        (boxedTorusFullReachFlatOnlyComplementTopoLossData L) n p = 0) ∧
    (∀ L n : ℕ, ∀ p : ℝ,
      expectedTopoLossOnGiantOn
        (boxedTorusFullReachFlatOnlyComplementTopoLossData L) n p = 0)
  boxed_torus_flat_only_not_all_n_lower_bound :
    ∀ L : ℕ,
      ¬ UnitCompatibleAboveThresholdLowerBoundConclusion
        (boxedTorusFullReachFlatOnlyComplementTopoLossData L)
  current_mills_identifier_obstruction :
    ¬
      ((∀ p : ℝ, harrisKestenCriticalProb < p →
          ∃ c : ℝ, 0 < c ∧
            ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
        ∀ p : ℝ, harrisKestenCriticalProb < p →
          ∃ c : ℝ, 0 < c ∧
            expectedTopoLossAboveLowerConst p = 1 / (1 - Real.exp (-c)))
  mills_inverse_unit_bound_route_obstruction :
    topoLossKernel_mem_unitInterval →
      ((∀ p : ℝ, harrisKestenCriticalProb < p →
        ∃ c : ℝ, 0 < c ∧
          ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
      ∀ p : ℝ, harrisKestenCriticalProb < p →
        ∃ c : ℝ, 0 < c ∧
          expectedTopoLossAboveLowerConst p = 1 / (1 - Real.exp (-c))) →
      ((∀ p : ℝ, harrisKestenCriticalProb < p →
        ∃ c : ℝ, 0 < c ∧
          ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
      ∀ p : ℝ, harrisKestenCriticalProb < p →
        ∀ c : ℝ, 0 < c →
          expectedTopoLossAboveLowerConst p = 1 / (1 - Real.exp (-c)) →
          ∃ N₁ : ℕ, ∀ n : ℕ, N₁ ≤ n →
            1 / (1 - Real.exp (-c)) ≤ expectedTopoLoss n p) →
      (∀ p : ℝ, harrisKestenCriticalProb < p →
        ∃ c : ℝ, 0 < c ∧
          ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
      ∀ p : ℝ, harrisKestenCriticalProb < p → p ≤ 1 → False

/-- Build gate: the open topo/phase semantic target is calibrated against
the current theorem surface.  The semantic target remains open until these
finite diagnostic/flat-carrier witnesses are refined to a genuine random
supercritical finite `Z2_L` theorem. -/
def topo_cluster_random_supercritical_z2_frontier_payload :
    TopoClusterRandomSupercriticalZ2FrontierPayload where
  conditional_expectation_def :=
    expectedTopoLoss_conditional_def
  conditional_expectation_closed_form :=
    gap_topo_cluster_relation
  below_threshold_topo_loss_on_giant :=
    gap_topo_loss_below_threshold
  below_threshold_phase :=
    gap_phase_transition_below
  above_threshold_phase_current :=
    gap_phase_transition_above
  z2_lattice_graph_standard := rfl
  z2_topo_cluster_bridge_core :=
    BoxedTorusFlatFamilyCoreConclusion_from_z2_topo_cluster_bridge
  z2_topo_cluster_bridge_lower_bound :=
    BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_from_z2_topo_cluster_bridge
  boxed_torus_flat_lower_bound_current :=
    BoxedTorusFullReachFlatOnlyLowerBoundConclusion_current
  boxed_torus_family_core_current :=
    boxedTorusFullReachFlatOnlyComplementTopoLossData_flatFamilyCoreConclusion
  boxed_torus_flat_only_diagnostic_current :=
    boxedTorusFullReachFlatOnlyComplementTopoLossData_flatOnlyDiagnostic
  boxed_torus_flat_only_not_all_n_lower_bound :=
    not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusFullReachFlatOnly
  current_mills_identifier_obstruction :=
    not_expectedTopoLossAboveLowerConst_eq_mills_inverse_current
  mills_inverse_unit_bound_route_obstruction :=
    not_mills_inverse_above_threshold_route_with_unit_bound

/-- Typed payload required by the closed R10 two-regime relabeling target.
This is intentionally a record of theorem surfaces, not a string reference:
`PaperSemanticGate.lean` only builds if the public `gap_two_regime_*` aliases
exist with the expected paper-facing statements. -/
structure TwoRegimeRelabelingPayload where
  reversal_existence :
    ∀ p : ℝ, 0 ≤ p → p < FiveState.p_1 →
      ∃ β_star_p, 0 < β_star_p ∧ FiveState.L β_star_p p < 4 / 10
  reversal_uniqueness :
    ∀ p : ℝ, 0 ≤ p → p < FiveState.p_1 →
      ∃ β_star_p,
        0 < β_star_p ∧
          ∀ β' : ℝ,
            0 < β' → FiveState.L β' p ≤ FiveState.L β_star_p p →
              β' = β_star_p
  reversal_nonmonotone :
    ∀ p : ℝ, 0 ≤ p → p < FiveState.p_1 →
      (∃ β_low β_high,
        0 < β_low ∧ β_low < β_high ∧
          FiveState.L β_high p < FiveState.L β_low p) ∧
        ∃ β_a β_b,
          0 < β_a ∧ β_a < β_b ∧
            FiveState.L β_a p < FiveState.L β_b p
  reversal_overshoot_decreasing :
    ∀ p₁ p₂ : ℝ, 0 ≤ p₁ → p₁ < p₂ → p₂ < FiveState.p_1 →
      ∃ β_star₁ β_star₂,
        0 < β_star₁ ∧ 0 < β_star₂ ∧
          FiveState.L β_star₁ p₁ < FiveState.L β_star₂ p₂
  reversal_overshoot_continuous :
    ContinuousOn FiveState.overshootRegimeI (Set.Ico 0 FiveState.p_1)
  reversal_overshoot_vanishes_at_p1 :
    Filter.Tendsto FiveState.overshootRegimeI
      (nhdsWithin FiveState.p_1 (Set.Iio FiveState.p_1)) (nhds 0)
  cognitive_augmentation_arithmetic_part :
    ∀ p : ℝ, FiveState.p_1 ≤ p → p ≤ FiveState.p_2 →
      4 / 10 * (1 - p) ≤ 4 / 10 - FiveState.W_topo_p p
  cognitive_augmentation_monotonicity :
    ∀ p : ℝ, FiveState.p_1 ≤ p → p ≤ FiveState.p_2 →
      ∀ β₁ β₂ : ℝ, 0 < β₁ → β₁ ≤ β₂ →
        FiveState.L β₂ p ≤ FiveState.L β₁ p
  sufficient_cognition :
    ∀ p : ℝ, FiveState.p_2 < p → p < 1 →
      ∀ β₁ β₂ : ℝ, 0 < β₁ → β₁ ≤ β₂ →
        FiveState.L β₂ p ≤ FiveState.L β₁ p
  sufficient_cognition_kappaStar_pos :
    ∀ p : ℝ, FiveState.p_2 < p → p < 1 →
      0 < FiveState.kappaStar_fiveState p

/-- Build gate: the closed R10 relabeling target is backed by all public
paper-facing `gap_two_regime_*` aliases with their expected theorem types. -/
def r10_two_regime_label_recalibration_payload :
    TwoRegimeRelabelingPayload where
  reversal_existence :=
    FiveState.gap_two_regime_reversal_existence
  reversal_uniqueness :=
    FiveState.gap_two_regime_reversal_uniqueness
  reversal_nonmonotone :=
    FiveState.gap_two_regime_reversal_nonmonotone
  reversal_overshoot_decreasing :=
    FiveState.gap_two_regime_reversal_overshoot_decreasing
  reversal_overshoot_continuous :=
    FiveState.gap_two_regime_reversal_overshoot_continuous
  reversal_overshoot_vanishes_at_p1 :=
    FiveState.gap_two_regime_reversal_overshoot_vanishes_at_p1
  cognitive_augmentation_arithmetic_part :=
    FiveState.gap_two_regime_cognitive_augmentation_arithmetic_part
  cognitive_augmentation_monotonicity :=
    FiveState.gap_two_regime_cognitive_augmentation_monotonicity
  sufficient_cognition :=
    FiveState.gap_two_regime_sufficient_cognition
  sufficient_cognition_kappaStar_pos :=
    FiveState.gap_two_regime_sufficient_cognition_kappaStar_pos

/-- Build gate: current paper-semantic closure has exactly the listed open
targets.  If a target is closed or added, this theorem must be updated with the
same patch that updates the machine-readable target list. -/
theorem paperSemanticOpenCount_current : paperSemanticOpenCount = 3 := rfl

/-- Build gate: the R10 relabeling and high-κ oracle-routing calibrations
are now closed. -/
theorem paperSemanticClosedCount_current : paperSemanticClosedCount = 2 := rfl

/-- Build gate: the closed R10 high-κ semantic target is backed by the
paper-facing one-edge signal-conditional routing theorem. -/
theorem r10_threshold_five_state_high_kappa_routing_payload (p : ℝ) :
    FiveState.highKappaOracleRoutingWelfare p =
      FiveState.fiveStateOracleWelfare p :=
  FiveState.highKappaOracleRoutingWelfare_eq_oracle p

/-- Complete paper-semantic kernel-only status is not yet claimable while the
open semantic target count is nonzero. -/
theorem completePaperSemanticKernelOnly_notYet :
    paperSemanticOpenCount ≠ 0 := by
  decide

#eval s!"Blackwell-Dilemma paper-semantic gate: closed={paperSemanticClosedCount} open={paperSemanticOpenCount}"

end PaperSemanticGate
end BlackwellDilemma
