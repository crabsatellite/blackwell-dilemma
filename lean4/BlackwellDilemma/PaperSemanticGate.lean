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
        "Canonical.lean paper-facing aliases over the closed theorem payload." },
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
