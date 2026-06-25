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

import BlackwellDilemma.Canonical

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
        "The lattice-specific p-monotonicity statement is still not a closed paper-faithful theorem.",
      closeRoute :=
        "Build a lattice/domain carrier where kappaStar monotonicity follows from a proved graph/percolation monotone-coupling theorem." },
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
        "The current scaling transfer is kernel-clean, but the full lattice embedding route remains a semantic carrier repair.",
      closeRoute :=
        "Connect trap-tree embeddings to a finite/infinite Z2 lattice percolation carrier with proved positive occurrence and domination." },
    { id := "topo_cluster_random_supercritical_z2",
      paperLabel := "prop:topo-cluster and thm:phase",
      status := SemanticStatus.open,
      shortReason :=
        "The current finite graph-local route is kernel-clean but not the full random supercritical Z2_L giant-component theorem.",
      closeRoute :=
        "Replace the diagnostic/flat carrier with a random finite Z2_L giant-component/topological-loss lower-bound theorem." } ]

def openSemanticTargets : List SemanticTarget :=
  semanticTargets.filter (fun t => t.status == SemanticStatus.open)

def closedSemanticTargets : List SemanticTarget :=
  semanticTargets.filter (fun t => t.status == SemanticStatus.closed)

def paperSemanticOpenCount : Nat :=
  openSemanticTargets.length

def paperSemanticClosedCount : Nat :=
  closedSemanticTargets.length

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
