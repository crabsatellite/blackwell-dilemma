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
      status := SemanticStatus.closed,
      shortReason :=
        "The bounded abstract, constructive-instance, and standard Z2 local-lattice p-monotonicity payload is now gated by a ranged bridge that derives mean-gap antitonicity from a Z2-adjacent local observable and the bridge's lattice monotone-coupling field.",
      closeRoute :=
        "Typed payload part4_lattice_p_monotonicity_frontier_payload: standardZ2RangedLatticePMonotonicityBridge_current plus gap_cognitive_threshold_part4_from_standard_z2_ranged_bridge_current; Part 6/topo remain responsible for the non-local random lattice semantics." },
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
        "The current global scaling-transfer payload, local-domination transfer, local feasible-set nonemptiness contract, unbounded-local nonempty alpha-domain projection, unbounded-local paper-support certificate with pointwise, existential, and full same-alpha domination/feasibility/divergence support, unbounded divergence, pointwise paper-domain certificate, feasible/divergence, full-witness, and full paper-closing support current obstructions, a unified unbounded current-obstruction certificate, closed-unit local transfer, closed-unit feasible-set nonemptiness, existential witness projection, same-alpha closed-unit feasible/divergence certificates, full same-alpha closed-unit domination/feasibility/divergence witness, closed-unit output-witness, full-witness, and full paper-closing support current obstructions, a combined Part 6 full paper-closing support obstruction, full-support-to-divergence-witness, bridge-route-to-divergence-witness, full-support-to-feasible/divergence-witness, bridge-route-to-feasible/divergence-witness, paired output-layer projections, full output-bundle projection, and the current output-layer/output-pair/full-output-bundle obstructions, repaired bridge-route-to-full-support projection theorems plus the current bridge-route obstruction, a unified bridge-route support certificate, a unified closed-unit current-obstruction certificate, and a unified Part 6 current-frontier certificate packaging the unbounded-route certificate, the scaling-candidate obstruction certificate, the closed-unit route certificate, the bridge-route support certificate, the paired/full-bundle output obstructions, the support obstruction, the bridge-route obstruction, and the bridge-level tail-reversal repair route, named candidate obstructions, generic positive-at-zero global-carrier obstruction, explicit near-p_c unbounded-alpha zero-branch witness and blocker theorem, current local-bridge impossibility theorem, explicit closed-unit alphaStar-threshold bridge certificate, the requirement that any alphaStar < 1 closed-unit repair expose a sentimental welfare reversal witness, a sufficient tail-reversal repair route that would force alphaStar < 1 and nonempty closed-unit alpha-domain plus its current-carrier obstruction, a unified closed-unit alpha-domain repair certificate, a bridge-level closed-unit tail-reversal route that converts into the standard closed-unit local bridge, Part 6 bridge-route surface, Part 6 full-support surface, a tail-reversal bridge output certificate projecting alphaStar < 1, closed-unit domain nonemptiness, closed-unit bridge nonemptiness, same-carrier closed-unit full paper-domain support, same-bridge paper-support plus sentimental-reversal, route/support, same-alpha divergence/feasible-divergence output pair, and full output bundle, plus a dedicated tail-reversal bridge nonclosure certificate packaging that output route with the alpha-domain repair obstruction, current nonempty obstruction, and Part 6 route/support/full-output refutations, a single closed-unit Part 6 paper-support certificate tying the Z2 graph, scaling divergence, nonempty alpha-domain, local domination, feasible-set nonemptiness, and same-alpha witness fields, a combined closed-unit paper-support plus sentimental-reversal bridge contract and exact current obstruction to that combined contract, exact closed-unit alpha-domain iff certificate, and alpha-domain degeneracy are gated, but the full lattice embedding route still needs a nondegenerate alpha-domain/feasible-set repair.",
      closeRoute :=
        "Current typed frontier: part6_lattice_embedding_frontier_payload. To close: replace the current unbounded-alpha local bridge with a paper-faithful, nonempty alpha-domain or explicit feasible-set/nonempty-domain certificate, repair the current alphaStar=1 degeneracy if the paper domain is alpha<=1 by proving alphaStar 0 p_c < 1 for the repaired carrier, for example via the gated bridge-level closed-unit tail-reversal route whose output certificate now projects the nonempty alpha-domain, closed-unit bridge, same-carrier closed-unit full paper-domain support, same-bridge paper-support plus sentimental-reversal, Part 6 route/support, same-alpha divergence/feasible-divergence output pair, and full output bundle, and whose nonclosure certificate gates that this repair surface is still uninhabited for the current carrier and does not close the Part 6 route/support/full-output bundle, and via the named Part6NondegenerateFeasibleRepairRouteCertificate that proves this exact alpha/feasible-set repair route is equivalent to full support, receives every bridge-route and tail-reversal projection, exposes paired/full output bundles, and is current-refuted, then instantiate it with a finite/infinite Z2 lattice percolation carrier and near-p_c domination theorem; the current unbounded-local, closed-unit, and bridge-level tail-reversal routes, output projections, support obstruction, and bridge-route obstruction are jointly packaged by one typed current-frontier certificate." },
    { id := "topo_cluster_random_supercritical_z2",
      paperLabel := "prop:topo-cluster and thm:phase",
      status := SemanticStatus.open,
      shortReason :=
        "The current topo/phase payload, all-open/complement boxed-torus witnesses, full-reach Z2 bridge, explicit non-diagnostic random-supercritical bridge contract with named supercritical probability, strict non-endpoint p < 1 parameter domain, family-level unit-interval topological-loss range, flat-sequence, giant-restricted, and giant-event-mass lower-bound packages at that same parameter, a contract-level obstruction showing that old random-supercritical bridge contract is inconsistent with the pointwise giant-loss envelope, and a repaired random-supercritical bridge surface that keeps the compatible flat lower-bound, giant-event-mass, probability-domain, unit-interval, non-diagnostic-tail, explicit giant-event membership, same-L combined support, same-L non-diagnostic support with a giant-event member, paper-support obligations, and a repaired-surface diagnostic obstruction certificate while dropping the refuted uniform giant-restricted lower-bound field are gated and kernel-clean. A finite first-edge Bernoulli witness now proves the repaired contract is nonempty/nonvacuous; a separate finite first-edge positive-regression certificate proves unit-interval loss, positive-mass full-cluster giant event, unit-compatible lower bound, and strictly positive giant-restricted expected loss at p=3/4, and is now paired with a kernel certificate showing that constant-family lifting of this finite witness cannot satisfy the repaired random-supercritical Z2_L bridge surface because it violates the pointwise giant-event envelope; the full-reach flat-only route now also has a gate-level cutset/boundary lower-bound certificate exposing the reusable pointwise p^B/2 and family-level lower-bound implications; the selected repaired-bridge event is calibrated to the boxed-torus base horizontal edge under the existing flattening map, implies reachability of that edge's target in the boxed-torus open-edge reachable set, is machine-calibrated to zero topological loss on its selected giant event, and cannot supply any positive uniform giant-restricted lower bound; the missing giant-loss field, the stronger full paper-closing support surface, the existential full paper-closing route, a sufficient pointwise-on-giant loss-floor route to full paper-closing support plus the current first-edge obstruction to that route, and the route-to-paper-support/support-surface-repair/support-surface-route/support-surface-output/giant-loss/combined-support/supported-nondiagnostic output projections plus their full bundled output gate are now named, directly projected from the old final contract, refuted for the current witness where appropriate, with the first-edge giant-loss, combined-support, supported-nondiagnostic, numeric bundled output, and paper-support-inclusive full bundled output obstructions named existentially, and generalized to rule out any first-edge-family p=3/4 route witness. The old-contract obstruction, repaired-surface diagnostic obstruction certificate, repaired first-edge compatibility/not-closing facts, finite positive-regression/not-liftable certificate, cutset lower-bound route certificate, pointwise-on-giant route certificate, route-level paper-support output, full-route support-surface repair route/output projections, boxed-torus finite-Z2_L route calibration certificate, both bundled output obstructions, and a full-support envelope obstruction proving that the current giant-loss/full-support/pointwise-on-giant/full-route/boxed-torus-finite-Z2_L route surface is generally uninhabitable under the theorem-core pointwise envelope are also packaged in the current-frontier gate surface. The non-contradictory repaired support surface that retains flat loss, giant-event mass, giant-event membership, unrestricted positive loss, and non-diagnostic tail support while removing the refuted giant-loss lower-bound field is now build-gated and inhabited, its route-output certificate projects repaired-bridge nonemptiness, repaired paper support, and same-tail non-diagnostic support output, and a dedicated nonclosure certificate packages that inhabited repair layer with the current first-edge repaired surface and the full-route/boxed-torus-route obstructions, while every full paper-closing route is now kernel-gated to factor back through that support-surface repair route/output; the full random supercritical Z2_L finite-lattice theorem remains open.",
      closeRoute :=
        "Current typed frontier: topo_cluster_random_supercritical_z2_frontier_payload. The support-surface repair is now explicit as RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceRepair and RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute, with RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRouteOutputCertificate projecting the route outputs and RandomSupercriticalZ2TopoClusterSupportSurfaceRepairNonClosureCertificate gating that the inhabited repair layer is still not the full paper-closing or boxed-torus finite-Z2_L route, and any full paper-closing route now kernel-projects back to that repaired support-surface repair route/output; RandomSupercriticalZ2TopoClusterSupportSurfaceClosingRouteCertificate also gates the repaired closing spine, its equivalence with full paper-closing support, the pointwise-on-giant projection into it, and its projections to the named full route and boxed-torus finite-Z2_L route; to close, instantiate that repaired surface with a genuine random finite Z2_L carrier carrying an explicit p_c < p < 1 parameter, family-level unit-interval range, valid flat/topo lower-bound theorem, giant-event-mass theorem, giant-event membership, unrestricted positive-loss realisation, non-diagnostic tail certificate, and the missing positive giant-restricted loss field. The positive first-edge regression certificate is finite and not a family-level Z2_L theorem, the first-edge cylinder witness is only a compatibility witness, the old giant-restricted full-support surface remains kernel-refuted, and the older RandomSupercriticalZ2TopoClusterBridgeData remains in the gate only as a kernel-refuted over-strong contract." } ]

def openSemanticTargets : List SemanticTarget :=
  semanticTargets.filter (fun t => t.status == SemanticStatus.open)

def closedSemanticTargets : List SemanticTarget :=
  semanticTargets.filter (fun t => t.status == SemanticStatus.closed)

def semanticTargetIds (targets : List SemanticTarget) : List String :=
  targets.map (fun t => t.id)

def openSemanticTargetIds : List String :=
  semanticTargetIds openSemanticTargets

def closedSemanticTargetIds : List String :=
  semanticTargetIds closedSemanticTargets

def paperSemanticOpenCount : Nat :=
  openSemanticTargets.length

def paperSemanticClosedCount : Nat :=
  closedSemanticTargets.length

/-- Named paper-semantic target proposition for Theorem 4.1 Part 6.

This is the exact alpha/feasible-set repair route that the current gate treats
as the remaining Part 6 closure obligation. -/
def Part6LatticeEmbeddingSemanticKernelTarget : Prop :=
  Part6NondegenerateFeasibleRepairRoute

/-- The Part 6 semantic target is definitionally the nondegenerate
alpha/feasible-set repair route. -/
theorem part6_lattice_embedding_semantic_kernel_target_iff_repair_route :
    Part6LatticeEmbeddingSemanticKernelTarget ↔
      Part6NondegenerateFeasibleRepairRoute :=
  Iff.rfl

/-- The Part 6 semantic target is equivalent to full Part 6 paper-closing
support. -/
theorem part6_lattice_embedding_semantic_kernel_target_iff_full_support :
    Part6LatticeEmbeddingSemanticKernelTarget ↔
      Part6FullPaperClosingSupport := by
  exact part6_nondegenerate_feasible_repair_route_iff_full_paper_closing_support

/-- The current Part 6 semantic target is still refuted by the kernel-gated
alpha/feasible-set obstruction. -/
theorem part6_lattice_embedding_semantic_kernel_target_notYet :
    Not Part6LatticeEmbeddingSemanticKernelTarget := by
  exact not_part6_nondegenerate_feasible_repair_route_current

/-- Named paper-semantic target proposition for the random-supercritical
`Z2_L` topo/phase claim.

This is the exact full paper-closing route with the repaired support surface
and the missing giant-restricted loss field. -/
def TopoClusterRandomSupercriticalZ2SemanticKernelTarget : Prop :=
  RandomSupercriticalZ2TopoClusterFullPaperClosingRoute

/-- The topo semantic target is definitionally the named full paper-closing
route. -/
theorem topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_full_route :
    TopoClusterRandomSupercriticalZ2SemanticKernelTarget ↔
      RandomSupercriticalZ2TopoClusterFullPaperClosingRoute :=
  Iff.rfl

/-- The topo semantic target is equivalent to the boxed-torus finite-`Z2_L`
calibrated route. -/
theorem topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_boxed_torus_finite_z2L_route :
    TopoClusterRandomSupercriticalZ2SemanticKernelTarget ↔
      RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute := by
  exact randomSupercriticalZ2TopoClusterFullPaperClosingRoute_iff_boxed_torus_finite_z2L_route

/-- The current topo semantic target is still refuted by the kernel-gated
full-support envelope obstruction. -/
theorem topo_cluster_random_supercritical_z2_semantic_kernel_target_notYet :
    Not TopoClusterRandomSupercriticalZ2SemanticKernelTarget := by
  exact not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute

/-- Machine-facing roster entry tying an open semantic ledger id to its exact
Lean target proposition and its current kernel obstruction. -/
structure OpenSemanticTargetKernelSurface where
  id : String
  paperLabel : String
  target : Prop
  currentObstruction : Not target
  frontierCertificate : Prop
  frontierCertificateProof : frontierCertificate

/-- The two current open semantic targets with their exact Lean propositions
their current refutations, and their complete current frontier certificates. -/
def openSemanticTargetKernelSurfaces : List OpenSemanticTargetKernelSurface :=
  [ { id := "theorem_4_1_part6_lattice_embedding",
      paperLabel := "thm:cognitive-threshold Part 6",
      target := Part6LatticeEmbeddingSemanticKernelTarget,
      currentObstruction :=
        part6_lattice_embedding_semantic_kernel_target_notYet,
      frontierCertificate := Part6CurrentFrontierCertificate,
      frontierCertificateProof := part6_current_frontier_certificate },
    { id := "topo_cluster_random_supercritical_z2",
      paperLabel := "prop:topo-cluster and thm:phase",
      target := TopoClusterRandomSupercriticalZ2SemanticKernelTarget,
      currentObstruction :=
        topo_cluster_random_supercritical_z2_semantic_kernel_target_notYet,
      frontierCertificate :=
        RandomSupercriticalZ2TopoClusterCurrentFrontierCertificate,
      frontierCertificateProof :=
        random_supercritical_z2_topo_cluster_current_frontier_certificate } ]

def openSemanticTargetKernelSurfaceIds : List String :=
  openSemanticTargetKernelSurfaces.map (fun surface => surface.id)

/-- Build gate: the machine-facing open target roster has exactly the same ids
as the semantic ledger. -/
theorem openSemanticTargetKernelSurfaceIds_current :
    openSemanticTargetKernelSurfaceIds = openSemanticTargetIds := rfl

/-- Build gate: the machine-facing open target roster has the same cardinality
as the semantic ledger's open target count. -/
theorem openSemanticTargetKernelSurfaceCount_current :
    openSemanticTargetKernelSurfaces.length = paperSemanticOpenCount := rfl

/-- Every machine-facing roster entry carries its current kernel obstruction. -/
theorem openSemanticTargetKernelSurface_current_obstruction
    (surface : OpenSemanticTargetKernelSurface) :
    Not surface.target :=
  surface.currentObstruction

/-- Every machine-facing roster entry carries its complete current frontier
certificate. -/
theorem openSemanticTargetKernelSurface_frontier_certificate
    (surface : OpenSemanticTargetKernelSurface) :
    surface.frontierCertificate :=
  surface.frontierCertificateProof

/-- Typed payload for the closed Theorem 4.1 Part 4 lattice p-monotonicity
target.  This machine-checks the bounded kernel theorem, the constructive
five-state instance, and the standard `Z2` ranged local-lattice bridge that
derives mean-gap antitonicity from a lattice-coupled finite observable. -/
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
  finite_bond_percolation_expectation_monotone_from_lattice_coupling :
    forall d : Nat,
      forall _coupling :
        BlackwellDilemma.Infrastructure.BondPercolationLattice.LatticeMonotoneCouplingData
          d,
      forall (E : Type) [Fintype E] [DecidableEq E],
        forall p_low p_high : Real, 0 <= p_low -> p_low <= p_high -> p_high <= 1 ->
          forall f : BlackwellDilemma.BondConfig E -> Real,
            BlackwellDilemma.Infrastructure.BoolConfigMonotone f ->
              BlackwellDilemma.percExpectation p_low f <=
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
  ranged_lattice_local_edges_adjacent :
    forall bridge : RangedLatticePMonotonicityBridgeData,
      forall e : bridge.localEdge,
        bridge.graph.Adj (bridge.local_edge_source e) (bridge.local_edge_target e)
  ranged_lattice_prior_mean_from_observable :
    forall _bridge : RangedLatticePMonotonicityBridgeData,
      forall p1 p2 : Real, 0 <= p1 -> p1 <= p2 -> p2 <= 1 ->
        BlackwellDilemma.Infrastructure.MeanEstimateGap.priorMean_u2_fiveState p2 <=
          BlackwellDilemma.Infrastructure.MeanEstimateGap.priorMean_u2_fiveState p1
  ranged_lattice_mean_gap_from_observable :
    forall _bridge : RangedLatticePMonotonicityBridgeData,
      forall p1 p2 kappa : Real, 0 <= p1 -> p1 <= p2 -> p2 <= 1 ->
        0 < kappa -> mean_estimate_gap p2 kappa <= mean_estimate_gap p1 kappa
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

/-- Build gate: the Part 4 lattice target is calibrated against the current
closed kernel payload and the standard `Z2` ranged local-lattice bridge.
Non-local random lattice semantics remain tracked by the Part 6 and topo
semantic targets. -/
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
  finite_bond_percolation_expectation_monotone_from_lattice_coupling := by
    intro d coupling E _instF _instD p_low p_high h_low_nonneg h_mono h_high_le_one f hf
    exact percExpectation_mono_in_p_of_lattice_monotone_coupling
      (d := d) coupling h_low_nonneg h_mono h_high_le_one f hf
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
  ranged_lattice_local_edges_adjacent := by
    intro bridge e
    exact bridge.local_edge_adjacent e
  ranged_lattice_prior_mean_from_observable :=
    priorMean_u2_fiveState_antitone_in_p_from_ranged_lattice_observable
  ranged_lattice_mean_gap_from_observable :=
    mean_estimate_gap_antitone_in_p_from_ranged_lattice_observable
  standard_z2_ranged_bridge_transfer :=
    gap_cognitive_threshold_part4_from_standard_z2_ranged_bridge_current
  constructive_five_state_bounded_monotone :=
    FiveState.gap_p_monotonicity_bounded

/-- Typed frontier for the open Theorem 4.1 Part 6 lattice-embedding target.
This does not close the semantic target: it machine-checks the current
kernel-solid transfer layer, the named candidate obstructions, and the generic
positive-at-zero scaling-carrier obstruction that force a replacement
lattice/percolation carrier or a repaired domination domain. -/
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
  local_transfer_interface :
    ∀ s : ℝ → ℝ,
      BlackwellDilemma.Infrastructure.DivergesAtBelowAtTop
        s harrisKestenCriticalProb →
      (∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb ≤ α →
        ∃ δ : ℝ, 0 < δ ∧
          ∀ p : ℝ, harrisKestenCriticalProb - δ < p →
            p < harrisKestenCriticalProb →
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
  positive_at_zero_domination_obstruction :
    ∀ s : ℝ → ℝ, 0 < s 0 →
      ¬ ∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb ≤ α →
        ∀ p : ℝ, p < harrisKestenCriticalProb →
          s p ≤ kappaStar p α
  current_unbounded_alpha_zero_branch_near_pc :
    ∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb ≤ α ∧
      ∀ ε : ℝ, 0 < ε →
        ∃ p : ℝ,
          harrisKestenCriticalProb - ε < p ∧
          p < harrisKestenCriticalProb ∧
          0 ≤ p ∧
          kappaStar p α = 0
  current_unbounded_alpha_zero_branch_blocks_local_bridge :
    (∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb ≤ α ∧
      ∀ ε : ℝ, 0 < ε →
        ∃ p : ℝ,
          harrisKestenCriticalProb - ε < p ∧
          p < harrisKestenCriticalProb ∧
          0 ≤ p ∧
          kappaStar p α = 0) →
      Not (Nonempty Z2LatticeEmbeddingLocalBridgeData)
  mean_estimate_gap_lt_one_current :
    ∀ p κ : ℝ, 0 ≤ p → 0 < κ →
      mean_estimate_gap p κ < 1
  current_unbounded_alpha_gt_one_zero_branch :
    ∀ p α : ℝ, 0 ≤ p → 1 < α → kappaStar p α = 0
  unbounded_divergence_witness_current_obstruction :
    ¬ ∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α ∧
      ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
        ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
          p < harrisKestenCriticalProb →
            M < kappaStar p α
  unbounded_pointwise_paper_domain_certificate_current_obstruction :
    ¬ forall alpha : Real, alphaStar 0 harrisKestenCriticalProb < alpha ->
      (Exists fun delta : Real =>
        0 < delta /\
          forall p : Real, harrisKestenCriticalProb - delta < p ->
            p < harrisKestenCriticalProb ->
              Exists fun kappa : Real =>
                0 < kappa /\
                  BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                    mean_estimate_gap p kappa) /\
      (forall M : Real, Exists fun epsilon : Real =>
        0 < epsilon /\
          forall p : Real, harrisKestenCriticalProb - epsilon < p ->
            p < harrisKestenCriticalProb ->
              M < kappaStar p alpha)
  unbounded_feasible_divergence_witness_current_obstruction :
    ¬ ∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α ∧
      (∃ δ : ℝ, 0 < δ ∧
        ∀ p : ℝ, harrisKestenCriticalProb - δ < p →
          p < harrisKestenCriticalProb →
            ∃ κ : ℝ, 0 < κ ∧
              BlackwellDilemma.Infrastructure.alphaWelfareShift α <=
                mean_estimate_gap p κ) ∧
      (∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
        ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
          p < harrisKestenCriticalProb →
            M < kappaStar p α)
  unbounded_full_paper_domain_witness_current_obstruction :
    ∀ scalingCarrier : ℝ → ℝ,
      ¬ ∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α ∧
        (∃ δ : ℝ, 0 < δ ∧
          ∀ p : ℝ, harrisKestenCriticalProb - δ < p →
            p < harrisKestenCriticalProb →
              scalingCarrier p ≤ kappaStar p α) ∧
        (∃ δ : ℝ, 0 < δ ∧
          ∀ p : ℝ, harrisKestenCriticalProb - δ < p →
            p < harrisKestenCriticalProb →
              ∃ κ : ℝ, 0 < κ ∧
                BlackwellDilemma.Infrastructure.alphaWelfareShift α <=
                  mean_estimate_gap p κ) ∧
        (∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
          ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
            p < harrisKestenCriticalProb →
              M < kappaStar p α)
  unbounded_full_paper_closing_support_current_obstruction :
    Not (Exists fun scalingCarrier : ℝ → ℝ =>
      UnboundedPart6FullPaperClosingSupport scalingCarrier)
  unbounded_current_obstruction_certificate :
    UnboundedPart6CurrentObstructionCertificate
  part6_scaling_candidate_current_obstruction_certificate :
    Part6ScalingCandidateCurrentObstructionCertificate
  hyperbolic_positive_at_zero :
    0 < criticalHyperbolicScaling 0
  lower_envelope_bridge_obstruction :
    ¬ ∃ bridge : Z2LatticeEmbeddingBridgeData,
      bridge.scalingCarrier = harrisKestenScalingFunction
  hyperbolic_bridge_obstruction :
    ¬ ∃ bridge : Z2LatticeEmbeddingBridgeData,
      bridge.scalingCarrier = criticalHyperbolicScaling
  positive_at_zero_bridge_obstruction :
    ∀ s : ℝ → ℝ, 0 < s 0 →
      ¬ ∃ bridge : Z2LatticeEmbeddingBridgeData,
        bridge.scalingCarrier = s
  local_bridge_current_obstruction :
    Not (Nonempty Z2LatticeEmbeddingLocalBridgeData)
  closed_unit_local_bridge_current_obstruction :
    Not (Nonempty Z2LatticeEmbeddingClosedUnitLocalBridgeData)
  closed_unit_paper_support_with_sentimental_reversal_current_obstruction :
    ¬ ∃ bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      Z2LatticeEmbeddingClosedUnitLocalBridgePaperSupportWithSentimentalReversal
        bridge
  alphaStar_current_eq_one_at_pc :
    alphaStar 0 harrisKestenCriticalProb = 1
  alphaStar_full_unit_sentimental_monotone_forces_endpoint :
    ∀ κ p : ℝ,
      (∀ α : ℝ, 0 ≤ α → α ≤ 1 →
        ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
          agentWelfare AgentType.sentimental β₁ κ α ≤
            agentWelfare AgentType.sentimental β₂ κ α) →
        alphaStar κ p = 1
  closed_unit_alphaStar_lt_one_current_obstruction :
    ¬ alphaStar 0 harrisKestenCriticalProb < 1
  closed_unit_alphaStar_lt_one_requires_sentimental_welfare_reversal :
    alphaStar 0 harrisKestenCriticalProb < 1 →
      Exists fun α : ℝ =>
        Exists fun β₁ : ℝ =>
          Exists fun β₂ : ℝ =>
            0 ≤ α ∧ α ≤ 1 ∧ β₁ ≤ β₂ ∧
              agentWelfare AgentType.sentimental β₂ 0 α <
                agentWelfare AgentType.sentimental β₁ 0 α
  closed_unit_alpha_domain_nonempty_iff_alphaStar_lt_one :
    (Exists fun α : ℝ =>
      alphaStar 0 harrisKestenCriticalProb < α ∧ α ≤ 1) ↔
      alphaStar 0 harrisKestenCriticalProb < 1
  closed_unit_tail_reversal_repair_route_alphaStar_lt_one :
    ClosedUnitAlphaStarTailReversalRepairRoute
      0 harrisKestenCriticalProb ->
        alphaStar 0 harrisKestenCriticalProb < 1
  closed_unit_tail_reversal_repair_route_alpha_domain_nonempty :
    ClosedUnitAlphaStarTailReversalRepairRoute
      0 harrisKestenCriticalProb ->
        ∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α ∧ α ≤ 1
  closed_unit_tail_reversal_repair_route_current_obstruction :
    Not (ClosedUnitAlphaStarTailReversalRepairRoute
      0 harrisKestenCriticalProb)
  closed_unit_alpha_domain_repair_certificate :
    ClosedUnitAlphaDomainRepairCertificate
  closed_unit_tail_reversal_bridge_to_closed_unit_bridge :
    Z2LatticeEmbeddingClosedUnitTailReversalBridgeData ->
      Z2LatticeEmbeddingClosedUnitLocalBridgeData
  closed_unit_tail_reversal_bridge_full_paper_domain_witness :
    forall bridge : Z2LatticeEmbeddingClosedUnitTailReversalBridgeData,
      ClosedUnitPart6FullPaperClosingSupport bridge.scalingCarrier
  closed_unit_tail_reversal_bridge_full_paper_closing_support_nonempty :
    Nonempty Z2LatticeEmbeddingClosedUnitTailReversalBridgeData ->
      Exists fun scalingCarrier : ℝ → ℝ =>
        ClosedUnitPart6FullPaperClosingSupport scalingCarrier
  closed_unit_tail_reversal_bridge_to_part6_bridge_route :
    Nonempty Z2LatticeEmbeddingClosedUnitTailReversalBridgeData ->
      Part6FullPaperClosingBridgeRoute
  closed_unit_tail_reversal_bridge_to_part6_support :
    Nonempty Z2LatticeEmbeddingClosedUnitTailReversalBridgeData ->
      Part6FullPaperClosingSupport
  closed_unit_tail_reversal_bridge_to_part6_divergence_witness :
    forall _bridge : Z2LatticeEmbeddingClosedUnitTailReversalBridgeData,
      Part6FullPaperClosingDivergenceWitness
  closed_unit_tail_reversal_bridge_to_part6_feasible_divergence_witness :
    forall _bridge : Z2LatticeEmbeddingClosedUnitTailReversalBridgeData,
      Part6FullPaperClosingFeasibleDivergenceWitness
  closed_unit_tail_reversal_bridge_to_part6_output_pair :
    forall _bridge : Z2LatticeEmbeddingClosedUnitTailReversalBridgeData,
      Part6FullPaperClosingDivergenceWitness /\
        Part6FullPaperClosingFeasibleDivergenceWitness
  closed_unit_tail_reversal_bridge_to_part6_output_pair_nonempty :
    Nonempty Z2LatticeEmbeddingClosedUnitTailReversalBridgeData ->
      Part6FullPaperClosingDivergenceWitness /\
        Part6FullPaperClosingFeasibleDivergenceWitness
  closed_unit_tail_reversal_bridge_paper_support_with_sentimental_reversal :
    forall bridge : Z2LatticeEmbeddingClosedUnitTailReversalBridgeData,
      Z2LatticeEmbeddingClosedUnitLocalBridgePaperSupportWithSentimentalReversal
        (z2LatticeEmbeddingClosedUnitLocalBridgeData_of_tail_reversal_bridge
          bridge)
  closed_unit_tail_reversal_bridge_paper_support_with_sentimental_reversal_nonempty :
    Nonempty Z2LatticeEmbeddingClosedUnitTailReversalBridgeData ->
      Exists fun bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData =>
        Z2LatticeEmbeddingClosedUnitLocalBridgePaperSupportWithSentimentalReversal
          bridge
  closed_unit_tail_reversal_bridge_output_certificate :
    Z2LatticeEmbeddingClosedUnitTailReversalBridgeOutputCertificate
  closed_unit_tail_reversal_bridge_nonclosure_certificate :
    Z2LatticeEmbeddingClosedUnitTailReversalBridgeNonClosureCertificate
  closed_unit_tail_reversal_bridge_current_obstruction :
    Not (Nonempty Z2LatticeEmbeddingClosedUnitTailReversalBridgeData)
  closed_unit_alpha_domain_empty_current :
    ¬ ∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α ∧ α ≤ 1
  closed_unit_divergence_witness_current_obstruction :
    ¬ ∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α ∧
      α ≤ 1 ∧
        ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
          ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
            p < harrisKestenCriticalProb →
              M < kappaStar p α
  closed_unit_feasible_divergence_witness_current_obstruction :
    ¬ ∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α ∧
      α ≤ 1 ∧
      (∃ δ : ℝ, 0 < δ ∧
        ∀ p : ℝ, harrisKestenCriticalProb - δ < p →
          p < harrisKestenCriticalProb →
            ∃ κ : ℝ, 0 < κ ∧
              BlackwellDilemma.Infrastructure.alphaWelfareShift α <=
                mean_estimate_gap p κ) ∧
      (∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
        ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
          p < harrisKestenCriticalProb →
            M < kappaStar p α)
  closed_unit_full_paper_domain_witness_current_obstruction :
    ∀ scalingCarrier : ℝ → ℝ,
      ¬ ∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α ∧
        α ≤ 1 ∧
        (∃ δ : ℝ, 0 < δ ∧
          ∀ p : ℝ, harrisKestenCriticalProb - δ < p →
            p < harrisKestenCriticalProb →
              scalingCarrier p ≤ kappaStar p α) ∧
        (∃ δ : ℝ, 0 < δ ∧
          ∀ p : ℝ, harrisKestenCriticalProb - δ < p →
            p < harrisKestenCriticalProb →
              ∃ κ : ℝ, 0 < κ ∧
                BlackwellDilemma.Infrastructure.alphaWelfareShift α <=
                  mean_estimate_gap p κ) ∧
        (∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
          ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
            p < harrisKestenCriticalProb →
              M < kappaStar p α)
  closed_unit_full_paper_closing_support_current_obstruction :
    Not (Exists fun scalingCarrier : ℝ → ℝ =>
      ClosedUnitPart6FullPaperClosingSupport scalingCarrier)
  closed_unit_current_obstruction_certificate :
    alphaStar 0 harrisKestenCriticalProb = 1 ∧
      ¬ alphaStar 0 harrisKestenCriticalProb < 1 ∧
      (¬ ∃ α : ℝ,
        alphaStar 0 harrisKestenCriticalProb < α ∧ α ≤ 1) ∧
      ClosedUnitAlphaDomainRepairCertificate ∧
      (∀ scalingCarrier : ℝ → ℝ,
        ¬ ∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α ∧
          α ≤ 1 ∧
          (∃ δ : ℝ, 0 < δ ∧
            ∀ p : ℝ, harrisKestenCriticalProb - δ < p →
              p < harrisKestenCriticalProb →
                scalingCarrier p ≤ kappaStar p α) ∧
          (∃ δ : ℝ, 0 < δ ∧
            ∀ p : ℝ, harrisKestenCriticalProb - δ < p →
              p < harrisKestenCriticalProb →
                ∃ κ : ℝ, 0 < κ ∧
                  BlackwellDilemma.Infrastructure.alphaWelfareShift α <=
                    mean_estimate_gap p κ) ∧
          (∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
            ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
              p < harrisKestenCriticalProb →
                M < kappaStar p α)) ∧
      Not (Nonempty Z2LatticeEmbeddingClosedUnitLocalBridgeData)
  current_bridge_routes_obstruction_certificate :
    Not (Nonempty Z2LatticeEmbeddingLocalBridgeData) /\
      Not (Nonempty Z2LatticeEmbeddingClosedUnitLocalBridgeData)
  part6_bridge_route_support_certificate :
    Part6BridgeRouteSupportCertificate
  part6_full_paper_closing_output_layer_certificate :
    Part6FullPaperClosingOutputLayerCertificate
  part6_nondegenerate_feasible_repair_route_certificate :
    Part6NondegenerateFeasibleRepairRouteCertificate
  part6_lattice_embedding_semantic_kernel_target_iff_repair_route :
    Part6LatticeEmbeddingSemanticKernelTarget ↔
      Part6NondegenerateFeasibleRepairRoute
  part6_lattice_embedding_semantic_kernel_target_iff_full_support :
    Part6LatticeEmbeddingSemanticKernelTarget ↔
      Part6FullPaperClosingSupport
  part6_lattice_embedding_semantic_kernel_target_current_obstruction :
    Not Part6LatticeEmbeddingSemanticKernelTarget
  part6_nondegenerate_feasible_repair_route_iff_full_support :
    Part6NondegenerateFeasibleRepairRoute ↔ Part6FullPaperClosingSupport
  part6_nondegenerate_feasible_repair_route_of_bridge_route :
    Part6FullPaperClosingBridgeRoute ->
      Part6NondegenerateFeasibleRepairRoute
  part6_nondegenerate_feasible_repair_route_of_closed_unit_tail_reversal_bridge :
    forall _bridge : Z2LatticeEmbeddingClosedUnitTailReversalBridgeData,
      Part6NondegenerateFeasibleRepairRoute
  part6_nondegenerate_feasible_repair_route_of_closed_unit_tail_reversal_bridge_nonempty :
    Nonempty Z2LatticeEmbeddingClosedUnitTailReversalBridgeData ->
      Part6NondegenerateFeasibleRepairRoute
  part6_nondegenerate_feasible_repair_route_divergence_witness :
    Part6NondegenerateFeasibleRepairRoute ->
      Part6FullPaperClosingDivergenceWitness
  part6_nondegenerate_feasible_repair_route_feasible_divergence_witness :
    Part6NondegenerateFeasibleRepairRoute ->
      Part6FullPaperClosingFeasibleDivergenceWitness
  part6_nondegenerate_feasible_repair_route_output_pair :
    Part6NondegenerateFeasibleRepairRoute ->
      Part6FullPaperClosingDivergenceWitness /\
        Part6FullPaperClosingFeasibleDivergenceWitness
  part6_nondegenerate_feasible_repair_route_full_output_bundle :
    Part6NondegenerateFeasibleRepairRoute ->
      Part6FullPaperClosingFullOutputBundle
  part6_nondegenerate_feasible_repair_route_current_obstruction_via_divergence_witness :
    Not Part6NondegenerateFeasibleRepairRoute
  part6_nondegenerate_feasible_repair_route_current_obstruction_via_feasible_divergence_witness :
    Not Part6NondegenerateFeasibleRepairRoute
  part6_nondegenerate_feasible_repair_route_current_obstruction_via_output_pair :
    Not Part6NondegenerateFeasibleRepairRoute
  part6_nondegenerate_feasible_repair_route_current_obstruction_via_full_output_bundle :
    Not Part6NondegenerateFeasibleRepairRoute
  part6_current_frontier_certificate :
    Part6CurrentFrontierCertificate
  part6_full_paper_closing_support_current_obstruction :
    Not Part6FullPaperClosingSupport
  part6_full_paper_closing_support_divergence_witness :
    Part6FullPaperClosingSupport ->
      Part6FullPaperClosingDivergenceWitness
  part6_full_paper_closing_bridge_route_divergence_witness :
    Part6FullPaperClosingBridgeRoute ->
      Part6FullPaperClosingDivergenceWitness
  part6_full_paper_closing_divergence_witness_current_obstruction :
    Not Part6FullPaperClosingDivergenceWitness
  part6_full_paper_closing_support_current_obstruction_via_divergence_witness :
    Not Part6FullPaperClosingSupport
  part6_full_paper_closing_bridge_route_current_obstruction_via_divergence_witness :
    Not Part6FullPaperClosingBridgeRoute
  part6_full_paper_closing_support_feasible_divergence_witness :
    Part6FullPaperClosingSupport ->
      Part6FullPaperClosingFeasibleDivergenceWitness
  part6_full_paper_closing_bridge_route_feasible_divergence_witness :
    Part6FullPaperClosingBridgeRoute ->
      Part6FullPaperClosingFeasibleDivergenceWitness
  part6_full_paper_closing_support_output_pair :
    Part6FullPaperClosingSupport ->
      Part6FullPaperClosingDivergenceWitness /\
        Part6FullPaperClosingFeasibleDivergenceWitness
  part6_full_paper_closing_bridge_route_output_pair :
    Part6FullPaperClosingBridgeRoute ->
      Part6FullPaperClosingDivergenceWitness /\
        Part6FullPaperClosingFeasibleDivergenceWitness
  part6_full_paper_closing_support_full_output_bundle :
    Part6FullPaperClosingSupport ->
      Part6FullPaperClosingFullOutputBundle
  part6_full_paper_closing_bridge_route_full_output_bundle :
    Part6FullPaperClosingBridgeRoute ->
      Part6FullPaperClosingFullOutputBundle
  part6_full_paper_closing_feasible_divergence_witness_current_obstruction :
    Not Part6FullPaperClosingFeasibleDivergenceWitness
  part6_full_paper_closing_output_pair_current_obstruction :
    Not (Part6FullPaperClosingDivergenceWitness /\
      Part6FullPaperClosingFeasibleDivergenceWitness)
  part6_full_paper_closing_full_output_bundle_current_obstruction :
    Not Part6FullPaperClosingFullOutputBundle
  part6_full_paper_closing_support_current_obstruction_via_feasible_divergence_witness :
    Not Part6FullPaperClosingSupport
  part6_full_paper_closing_bridge_route_current_obstruction_via_feasible_divergence_witness :
    Not Part6FullPaperClosingBridgeRoute
  part6_full_paper_closing_support_current_obstruction_via_output_pair :
    Not Part6FullPaperClosingSupport
  part6_full_paper_closing_bridge_route_current_obstruction_via_output_pair :
    Not Part6FullPaperClosingBridgeRoute
  part6_full_paper_closing_support_current_obstruction_via_full_output_bundle :
    Not Part6FullPaperClosingSupport
  part6_full_paper_closing_bridge_route_current_obstruction_via_full_output_bundle :
    Not Part6FullPaperClosingBridgeRoute
  part6_full_paper_closing_support_of_local_bridge :
    ∀ _bridge : Z2LatticeEmbeddingLocalBridgeData,
      Part6FullPaperClosingSupport
  part6_full_paper_closing_support_of_closed_unit_bridge :
    ∀ _bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      Part6FullPaperClosingSupport
  part6_full_paper_closing_support_of_bridge_route :
    Part6FullPaperClosingBridgeRoute -> Part6FullPaperClosingSupport
  part6_full_paper_closing_bridge_route_current_obstruction :
    Not Part6FullPaperClosingBridgeRoute
  z2_lattice_embedding_bridge_transfer :
    ∀ _bridge : Z2LatticeEmbeddingBridgeData,
      ∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α →
        ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
          ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
            p < harrisKestenCriticalProb →
              M < kappaStar p α
  z2_lattice_embedding_local_bridge_transfer :
    ∀ _bridge : Z2LatticeEmbeddingLocalBridgeData,
      ∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α →
        ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
          ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
            p < harrisKestenCriticalProb →
              M < kappaStar p α
  z2_lattice_embedding_local_bridge_near_pc_feasible_nonempty :
    forall _bridge : Z2LatticeEmbeddingLocalBridgeData,
      forall alpha : Real, alphaStar 0 harrisKestenCriticalProb <= alpha ->
        Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                Exists fun kappa : Real =>
                  0 < kappa /\
                    BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                      mean_estimate_gap p kappa
  z2_lattice_embedding_local_bridge_nonempty_alpha_domain :
    forall _bridge : Z2LatticeEmbeddingLocalBridgeData,
      Exists fun alpha : Real =>
        alphaStar 0 harrisKestenCriticalProb < alpha
  z2_lattice_embedding_local_bridge_paper_support_certificate :
    forall bridge : Z2LatticeEmbeddingLocalBridgeData,
      bridge.graph = SimpleGraph.Z2LatticeGraph /\
      BlackwellDilemma.Infrastructure.DivergesAtBelowAtTop
        bridge.scalingCarrier harrisKestenCriticalProb /\
      (forall alpha : Real, alphaStar 0 harrisKestenCriticalProb <= alpha ->
        Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                bridge.scalingCarrier p <= kappaStar p alpha) /\
      (forall alpha : Real, alphaStar 0 harrisKestenCriticalProb <= alpha ->
        Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                Exists fun kappa : Real =>
                  0 < kappa /\
                    BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                      mean_estimate_gap p kappa) /\
      (forall alpha : Real, alphaStar 0 harrisKestenCriticalProb < alpha ->
        forall M : Real, Exists fun epsilon : Real =>
          0 < epsilon /\
            forall p : Real, harrisKestenCriticalProb - epsilon < p ->
              p < harrisKestenCriticalProb ->
                M < kappaStar p alpha) /\
      (forall alpha : Real, alphaStar 0 harrisKestenCriticalProb < alpha ->
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                Exists fun kappa : Real =>
                  0 < kappa /\
                    BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                      mean_estimate_gap p kappa) /\
        (forall M : Real, Exists fun epsilon : Real =>
          0 < epsilon /\
            forall p : Real, harrisKestenCriticalProb - epsilon < p ->
              p < harrisKestenCriticalProb ->
                M < kappaStar p alpha)) /\
      (Exists fun alpha : Real =>
        alphaStar 0 harrisKestenCriticalProb < alpha /\
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                Exists fun kappa : Real =>
                  0 < kappa /\
                    BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                      mean_estimate_gap p kappa) /\
        (forall M : Real, Exists fun epsilon : Real =>
          0 < epsilon /\
            forall p : Real, harrisKestenCriticalProb - epsilon < p ->
              p < harrisKestenCriticalProb ->
                M < kappaStar p alpha)) /\
      Exists fun alpha : Real =>
        alphaStar 0 harrisKestenCriticalProb < alpha /\
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                bridge.scalingCarrier p <= kappaStar p alpha) /\
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                Exists fun kappa : Real =>
                  0 < kappa /\
                    BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                      mean_estimate_gap p kappa) /\
        (forall M : Real, Exists fun epsilon : Real =>
          0 < epsilon /\
            forall p : Real, harrisKestenCriticalProb - epsilon < p ->
              p < harrisKestenCriticalProb ->
                M < kappaStar p alpha)
  z2_lattice_embedding_local_bridge_pointwise_paper_domain_certificate :
    forall _bridge : Z2LatticeEmbeddingLocalBridgeData,
      forall alpha : Real, alphaStar 0 harrisKestenCriticalProb < alpha ->
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                Exists fun kappa : Real =>
                  0 < kappa /\
                    BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                      mean_estimate_gap p kappa) /\
        (forall M : Real, Exists fun epsilon : Real =>
          0 < epsilon /\
            forall p : Real, harrisKestenCriticalProb - epsilon < p ->
              p < harrisKestenCriticalProb ->
                M < kappaStar p alpha)
  z2_lattice_embedding_local_bridge_feasible_divergence_witness :
    forall _bridge : Z2LatticeEmbeddingLocalBridgeData,
      Exists fun alpha : Real =>
        alphaStar 0 harrisKestenCriticalProb < alpha /\
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                Exists fun kappa : Real =>
                  0 < kappa /\
                    BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                      mean_estimate_gap p kappa) /\
        (forall M : Real, Exists fun epsilon : Real =>
          0 < epsilon /\
            forall p : Real, harrisKestenCriticalProb - epsilon < p ->
              p < harrisKestenCriticalProb ->
                M < kappaStar p alpha)
  z2_lattice_embedding_local_bridge_full_paper_domain_witness :
    forall bridge : Z2LatticeEmbeddingLocalBridgeData,
      Exists fun alpha : Real =>
        alphaStar 0 harrisKestenCriticalProb < alpha /\
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                bridge.scalingCarrier p <= kappaStar p alpha) /\
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                Exists fun kappa : Real =>
                  0 < kappa /\
                    BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                      mean_estimate_gap p kappa) /\
        (forall M : Real, Exists fun epsilon : Real =>
          0 < epsilon /\
            forall p : Real, harrisKestenCriticalProb - epsilon < p ->
              p < harrisKestenCriticalProb ->
                M < kappaStar p alpha)
  z2_lattice_embedding_closed_unit_local_bridge_transfer :
    ∀ _bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      ∀ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α →
        α ≤ 1 →
          ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
            ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
              p < harrisKestenCriticalProb →
                M < kappaStar p α
  z2_lattice_embedding_closed_unit_local_bridge_alphaStar_lt_one :
    ∀ _bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      alphaStar 0 harrisKestenCriticalProb < 1
  z2_lattice_embedding_closed_unit_local_bridge_sentimental_welfare_reversal_required :
    ∀ _bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      Exists fun α : ℝ =>
        Exists fun β₁ : ℝ =>
          Exists fun β₂ : ℝ =>
            0 ≤ α ∧ α ≤ 1 ∧ β₁ ≤ β₂ ∧
              agentWelfare AgentType.sentimental β₂ 0 α <
                agentWelfare AgentType.sentimental β₁ 0 α
  z2_lattice_embedding_closed_unit_local_bridge_nonempty_alpha_domain :
    ∀ _bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      ∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α ∧ α ≤ 1
  z2_lattice_embedding_closed_unit_local_bridge_near_pc_feasible_nonempty :
    forall _bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      forall alpha : Real, alphaStar 0 harrisKestenCriticalProb < alpha ->
        alpha <= 1 ->
          Exists fun delta : Real =>
            0 < delta /\
              forall p : Real, harrisKestenCriticalProb - delta < p ->
                p < harrisKestenCriticalProb ->
                  Exists fun kappa : Real =>
                    0 < kappa /\
                      BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                        mean_estimate_gap p kappa
  z2_lattice_embedding_closed_unit_local_bridge_witness :
    ∀ _bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      ∃ α : ℝ, alphaStar 0 harrisKestenCriticalProb < α ∧
        α ≤ 1 ∧
          ∀ M : ℝ, ∃ ε : ℝ, 0 < ε ∧
            ∀ p : ℝ, harrisKestenCriticalProb - ε < p →
              p < harrisKestenCriticalProb →
                M < kappaStar p α
  z2_lattice_embedding_closed_unit_local_bridge_paper_support_certificate :
    forall bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      bridge.graph = SimpleGraph.Z2LatticeGraph /\
      BlackwellDilemma.Infrastructure.DivergesAtBelowAtTop
        bridge.scalingCarrier harrisKestenCriticalProb /\
      alphaStar 0 harrisKestenCriticalProb < 1 /\
      (forall alpha : Real,
        alphaStar 0 harrisKestenCriticalProb < alpha -> alpha <= 1 ->
          Exists fun delta : Real =>
            0 < delta /\
              forall p : Real, harrisKestenCriticalProb - delta < p ->
                p < harrisKestenCriticalProb ->
                  bridge.scalingCarrier p <= kappaStar p alpha) /\
      (forall alpha : Real,
        alphaStar 0 harrisKestenCriticalProb < alpha -> alpha <= 1 ->
          Exists fun delta : Real =>
            0 < delta /\
              forall p : Real, harrisKestenCriticalProb - delta < p ->
                p < harrisKestenCriticalProb ->
                  Exists fun kappa : Real =>
                    0 < kappa /\
                      BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                        mean_estimate_gap p kappa) /\
      (Exists fun alpha : Real =>
        alphaStar 0 harrisKestenCriticalProb < alpha /\
        alpha <= 1 /\
          forall M : Real, Exists fun epsilon : Real =>
            0 < epsilon /\
              forall p : Real, harrisKestenCriticalProb - epsilon < p ->
                p < harrisKestenCriticalProb ->
                  M < kappaStar p alpha) /\
      (Exists fun alpha : Real =>
        alphaStar 0 harrisKestenCriticalProb < alpha /\
        alpha <= 1 /\
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                Exists fun kappa : Real =>
                  0 < kappa /\
                    BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                      mean_estimate_gap p kappa) /\
        (forall M : Real, Exists fun epsilon : Real =>
          0 < epsilon /\
            forall p : Real, harrisKestenCriticalProb - epsilon < p ->
              p < harrisKestenCriticalProb ->
                M < kappaStar p alpha)) /\
      Exists fun alpha : Real =>
        alphaStar 0 harrisKestenCriticalProb < alpha /\
        alpha <= 1 /\
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                bridge.scalingCarrier p <= kappaStar p alpha) /\
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                Exists fun kappa : Real =>
                  0 < kappa /\
                    BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                      mean_estimate_gap p kappa) /\
        (forall M : Real, Exists fun epsilon : Real =>
          0 < epsilon /\
            forall p : Real, harrisKestenCriticalProb - epsilon < p ->
              p < harrisKestenCriticalProb ->
                M < kappaStar p alpha)
  z2_lattice_embedding_closed_unit_local_bridge_paper_support_with_sentimental_reversal :
    forall bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      Z2LatticeEmbeddingClosedUnitLocalBridgePaperSupportWithSentimentalReversal
        bridge
  z2_lattice_embedding_closed_unit_local_bridge_pointwise_paper_domain_certificate :
    forall _bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      forall alpha : Real, alphaStar 0 harrisKestenCriticalProb < alpha ->
        alpha <= 1 ->
          (Exists fun delta : Real =>
            0 < delta /\
              forall p : Real, harrisKestenCriticalProb - delta < p ->
                p < harrisKestenCriticalProb ->
                  Exists fun kappa : Real =>
                    0 < kappa /\
                      BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                        mean_estimate_gap p kappa) /\
          (forall M : Real, Exists fun epsilon : Real =>
            0 < epsilon /\
              forall p : Real, harrisKestenCriticalProb - epsilon < p ->
                p < harrisKestenCriticalProb ->
                  M < kappaStar p alpha)
  z2_lattice_embedding_closed_unit_local_bridge_feasible_divergence_witness :
    forall _bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      Exists fun alpha : Real =>
        alphaStar 0 harrisKestenCriticalProb < alpha /\
        alpha <= 1 /\
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                Exists fun kappa : Real =>
                  0 < kappa /\
                    BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                      mean_estimate_gap p kappa) /\
        (forall M : Real, Exists fun epsilon : Real =>
          0 < epsilon /\
            forall p : Real, harrisKestenCriticalProb - epsilon < p ->
              p < harrisKestenCriticalProb ->
                M < kappaStar p alpha)
  z2_lattice_embedding_closed_unit_local_bridge_full_paper_domain_witness :
    forall bridge : Z2LatticeEmbeddingClosedUnitLocalBridgeData,
      Exists fun alpha : Real =>
        alphaStar 0 harrisKestenCriticalProb < alpha /\
        alpha <= 1 /\
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                bridge.scalingCarrier p <= kappaStar p alpha) /\
        (Exists fun delta : Real =>
          0 < delta /\
            forall p : Real, harrisKestenCriticalProb - delta < p ->
              p < harrisKestenCriticalProb ->
                Exists fun kappa : Real =>
                  0 < kappa /\
                    BlackwellDilemma.Infrastructure.alphaWelfareShift alpha <=
                      mean_estimate_gap p kappa) /\
        (forall M : Real, Exists fun epsilon : Real =>
          0 < epsilon /\
            forall p : Real, harrisKestenCriticalProb - epsilon < p ->
              p < harrisKestenCriticalProb ->
                M < kappaStar p alpha)

/-- Build gate: the open Part 6 lattice-embedding target is calibrated
against the current transfer layer, local-domination transfer layers, and
current-carrier obstructions.  The semantic target remains open until the
local bridge's unbounded-`α` domain or the closed-unit bridge's explicit
nonempty-domain obstruction is repaired with a paper-faithful
`α`/feasibility certificate and then instantiated by a genuine
lattice/percolation carrier with divergence and near-`p_c` domination; if the
unbounded route is repaired, the payload now checks the exact near-`p_c`
zero branch at `α = 2` that must be excluded and the theorem showing that
this zero branch blocks the present local bridge shape, plus an explicit
`mean_estimate_gap < 1` guard, the resulting `α > 1` zero branch, the current
unbounded divergence, pointwise paper-domain certificate, and same-alpha
feasible/divergence output-witness obstructions, the corresponding current
obstruction to the full same-alpha domination/feasibility/divergence witness
for any scaling carrier, an explicit
near-`p_c` feasible-set nonemptiness field, an unbounded paper-domain
nonemptiness projection, and a single unbounded-local paper-support
certificate that includes pointwise and existential same-alpha feasible/
divergence support plus a full same-alpha domination/feasibility/divergence
witness;
if the closed-unit
route is repaired, the payload now also checks that it yields an
actual paper-domain divergence witness rather than only a pointwise transfer
surface, that the bridge explicitly carries `alphaStar 0 p_c < 1`, that the
alphaStar certificate forces a sentimental welfare reversal witness, that the
closed-unit domain witness is derived from that certificate, that the current
carrier cannot satisfy the closed-unit divergence or same-alpha
feasible/divergence output witnesses while that domain is empty, that
near-`p_c` feasible-set nonemptiness is explicit inside the closed-unit paper
domain, that same-alpha feasible/divergence certificates tie feasible-set
nonemptiness to the exact alpha used by the divergence transfer, that a full
same-alpha closed-unit witness ties domination, feasible-set nonemptiness, and
divergence together, that the current carrier also refutes that full witness
for any scaling carrier, that all
closed-unit bridge fields are tied by one paper-support certificate,
that the bridge-level tail-reversal route exposes full paper-domain support
for its own scaling carrier and directly exposes the same-alpha divergence and
feasible/divergence output pair, and that alpha-domain nonemptiness is exactly
the same threshold certificate.  The payload also gates a Part 6 full output bundle tying
support, divergence, and same-alpha feasible/divergence witnesses together,
plus the current obstruction to that bundle. -/
def part6_lattice_embedding_frontier_payload :
    Part6LatticeEmbeddingFrontierPayload where
  z2_lattice_graph_standard := rfl
  prototype_diverges :=
    criticalHyperbolicScaling_diverges_at_pc
  lower_envelope_dominates :=
    kappaStar_dominates_percolation_scaling_paper_Def
  transfer_interface :=
    gap_cognitive_threshold_part6
  local_transfer_interface :=
    gap_cognitive_threshold_part6_local
  lower_envelope_divergence_obstruction :=
    not_harrisKestenScalingFunction_diverges_at_pc_paper_Def
  hyperbolic_domination_obstruction :=
    not_criticalHyperbolicScaling_dominates_kappaStar_current
  positive_at_zero_domination_obstruction :=
    not_positive_at_zero_scaling_dominates_kappaStar_current
  current_unbounded_alpha_zero_branch_near_pc :=
    current_part6_unbounded_alpha_zero_branch_near_pc
  current_unbounded_alpha_zero_branch_blocks_local_bridge :=
    current_part6_unbounded_alpha_zero_branch_blocks_local_bridge
  mean_estimate_gap_lt_one_current :=
    fun p kappa hp hkappa =>
      mean_estimate_gap_lt_one_of_nonneg_p_of_pos_kappa
        (p := p) (κ := kappa) hp hkappa
  current_unbounded_alpha_gt_one_zero_branch :=
    fun p alpha hp halpha =>
      kappaStar_eq_zero_of_one_lt_alpha_of_nonneg_p
        (p := p) (α := alpha) hp halpha
  unbounded_divergence_witness_current_obstruction :=
    not_unbounded_part6_divergence_witness_current
  unbounded_pointwise_paper_domain_certificate_current_obstruction :=
    not_unbounded_part6_pointwise_paper_domain_certificate_current
  unbounded_feasible_divergence_witness_current_obstruction :=
    not_unbounded_part6_feasible_divergence_witness_current
  unbounded_full_paper_domain_witness_current_obstruction :=
    not_unbounded_part6_full_paper_domain_witness_current
  unbounded_full_paper_closing_support_current_obstruction :=
    not_unbounded_part6_full_paper_closing_support_current
  unbounded_current_obstruction_certificate :=
    unbounded_part6_current_obstruction_certificate
  part6_scaling_candidate_current_obstruction_certificate :=
    part6_scaling_candidate_current_obstruction_certificate
  hyperbolic_positive_at_zero :=
    criticalHyperbolicScaling_pos_at_zero
  lower_envelope_bridge_obstruction :=
    not_z2_lattice_embedding_bridge_with_harrisKestenScalingFunction
  hyperbolic_bridge_obstruction :=
    not_z2_lattice_embedding_bridge_with_criticalHyperbolicScaling
  positive_at_zero_bridge_obstruction :=
    not_z2_lattice_embedding_bridge_with_positive_at_zero_scalingCarrier
  local_bridge_current_obstruction :=
    not_z2_lattice_embedding_local_bridge_current
  closed_unit_local_bridge_current_obstruction :=
    not_z2_lattice_embedding_closed_unit_local_bridge_current
  closed_unit_paper_support_with_sentimental_reversal_current_obstruction :=
    not_z2_lattice_embedding_closed_unit_local_bridge_paper_support_with_sentimental_reversal_current
  alphaStar_current_eq_one_at_pc :=
    alphaStar_eq_one_current 0 harrisKestenCriticalProb
  alphaStar_full_unit_sentimental_monotone_forces_endpoint :=
    alphaStar_eq_one_of_sentimental_welfare_monotone_on_unit
  closed_unit_alphaStar_lt_one_current_obstruction :=
    not_closed_unit_alphaStar_lt_one_current
  closed_unit_alphaStar_lt_one_requires_sentimental_welfare_reversal :=
    alphaStar_lt_one_requires_sentimental_welfare_reversal_witness
  closed_unit_alpha_domain_nonempty_iff_alphaStar_lt_one :=
    closed_unit_alpha_domain_nonempty_iff_alphaStar_lt_one
  closed_unit_tail_reversal_repair_route_alphaStar_lt_one :=
    fun hroute =>
      alphaStar_lt_one_of_closed_unit_tail_reversal_repair_route
        (κ := 0) (p := harrisKestenCriticalProb) (by norm_num) hroute
  closed_unit_tail_reversal_repair_route_alpha_domain_nonempty :=
    closed_unit_alpha_domain_nonempty_of_tail_reversal_repair_route
  closed_unit_tail_reversal_repair_route_current_obstruction :=
    not_closed_unit_alphaStar_tail_reversal_repair_route_current
  closed_unit_alpha_domain_repair_certificate :=
    closed_unit_alpha_domain_repair_certificate
  closed_unit_tail_reversal_bridge_to_closed_unit_bridge :=
    z2LatticeEmbeddingClosedUnitLocalBridgeData_of_tail_reversal_bridge
  closed_unit_tail_reversal_bridge_full_paper_domain_witness :=
    z2_lattice_embedding_closed_unit_tail_reversal_bridge_full_paper_domain_witness
  closed_unit_tail_reversal_bridge_full_paper_closing_support_nonempty :=
    z2_lattice_embedding_closed_unit_tail_reversal_bridge_full_paper_closing_support_nonempty
  closed_unit_tail_reversal_bridge_to_part6_bridge_route :=
    part6_full_paper_closing_bridge_route_of_closed_unit_tail_reversal_bridge_nonempty
  closed_unit_tail_reversal_bridge_to_part6_support :=
    part6_full_paper_closing_support_of_closed_unit_tail_reversal_bridge_nonempty
  closed_unit_tail_reversal_bridge_to_part6_divergence_witness :=
    part6_full_paper_closing_divergence_witness_of_closed_unit_tail_reversal_bridge
  closed_unit_tail_reversal_bridge_to_part6_feasible_divergence_witness :=
    part6_full_paper_closing_feasible_divergence_witness_of_closed_unit_tail_reversal_bridge
  closed_unit_tail_reversal_bridge_to_part6_output_pair :=
    part6_full_paper_closing_output_pair_of_closed_unit_tail_reversal_bridge
  closed_unit_tail_reversal_bridge_to_part6_output_pair_nonempty :=
    part6_full_paper_closing_output_pair_of_closed_unit_tail_reversal_bridge_nonempty
  closed_unit_tail_reversal_bridge_paper_support_with_sentimental_reversal :=
    z2_lattice_embedding_closed_unit_tail_reversal_bridge_paper_support_with_sentimental_reversal
  closed_unit_tail_reversal_bridge_paper_support_with_sentimental_reversal_nonempty :=
    z2_lattice_embedding_closed_unit_tail_reversal_bridge_paper_support_with_sentimental_reversal_nonempty
  closed_unit_tail_reversal_bridge_output_certificate :=
    z2_lattice_embedding_closed_unit_tail_reversal_bridge_output_certificate
  closed_unit_tail_reversal_bridge_nonclosure_certificate :=
    z2_lattice_embedding_closed_unit_tail_reversal_bridge_nonclosure_certificate
  closed_unit_tail_reversal_bridge_current_obstruction :=
    not_z2_lattice_embedding_closed_unit_tail_reversal_bridge_current
  closed_unit_alpha_domain_empty_current :=
    not_closed_unit_alpha_above_alphaStar_current
  closed_unit_divergence_witness_current_obstruction :=
    not_closed_unit_part6_divergence_witness_current
  closed_unit_feasible_divergence_witness_current_obstruction :=
    not_closed_unit_part6_feasible_divergence_witness_current
  closed_unit_full_paper_domain_witness_current_obstruction :=
    not_closed_unit_part6_full_paper_domain_witness_current
  closed_unit_full_paper_closing_support_current_obstruction :=
    not_closed_unit_part6_full_paper_closing_support_current
  closed_unit_current_obstruction_certificate :=
    closed_unit_part6_current_obstruction_certificate
  current_bridge_routes_obstruction_certificate :=
    part6_current_bridge_routes_obstruction_certificate
  part6_bridge_route_support_certificate :=
    part6_bridge_route_support_certificate
  part6_full_paper_closing_output_layer_certificate :=
    part6_full_paper_closing_output_layer_certificate
  part6_nondegenerate_feasible_repair_route_certificate :=
    part6_nondegenerate_feasible_repair_route_certificate
  part6_lattice_embedding_semantic_kernel_target_iff_repair_route :=
    part6_lattice_embedding_semantic_kernel_target_iff_repair_route
  part6_lattice_embedding_semantic_kernel_target_iff_full_support :=
    part6_lattice_embedding_semantic_kernel_target_iff_full_support
  part6_lattice_embedding_semantic_kernel_target_current_obstruction :=
    part6_lattice_embedding_semantic_kernel_target_notYet
  part6_nondegenerate_feasible_repair_route_iff_full_support :=
    part6_nondegenerate_feasible_repair_route_iff_full_paper_closing_support
  part6_nondegenerate_feasible_repair_route_of_bridge_route :=
    part6_nondegenerate_feasible_repair_route_of_bridge_route
  part6_nondegenerate_feasible_repair_route_of_closed_unit_tail_reversal_bridge :=
    part6_nondegenerate_feasible_repair_route_of_closed_unit_tail_reversal_bridge
  part6_nondegenerate_feasible_repair_route_of_closed_unit_tail_reversal_bridge_nonempty :=
    part6_nondegenerate_feasible_repair_route_of_closed_unit_tail_reversal_bridge_nonempty
  part6_nondegenerate_feasible_repair_route_divergence_witness :=
    part6_nondegenerate_feasible_repair_route_divergence_witness
  part6_nondegenerate_feasible_repair_route_feasible_divergence_witness :=
    part6_nondegenerate_feasible_repair_route_feasible_divergence_witness
  part6_nondegenerate_feasible_repair_route_output_pair :=
    part6_nondegenerate_feasible_repair_route_output_pair
  part6_nondegenerate_feasible_repair_route_full_output_bundle :=
    part6_nondegenerate_feasible_repair_route_full_output_bundle
  part6_nondegenerate_feasible_repair_route_current_obstruction_via_divergence_witness :=
    not_part6_nondegenerate_feasible_repair_route_current_via_divergence_witness
  part6_nondegenerate_feasible_repair_route_current_obstruction_via_feasible_divergence_witness :=
    not_part6_nondegenerate_feasible_repair_route_current_via_feasible_divergence_witness
  part6_nondegenerate_feasible_repair_route_current_obstruction_via_output_pair :=
    not_part6_nondegenerate_feasible_repair_route_current_via_output_pair
  part6_nondegenerate_feasible_repair_route_current_obstruction_via_full_output_bundle :=
    not_part6_nondegenerate_feasible_repair_route_current_via_full_output_bundle
  part6_current_frontier_certificate :=
    part6_current_frontier_certificate
  part6_full_paper_closing_support_current_obstruction :=
    not_part6_full_paper_closing_support_current
  part6_full_paper_closing_support_divergence_witness :=
    part6_full_paper_closing_support_divergence_witness
  part6_full_paper_closing_bridge_route_divergence_witness :=
    part6_full_paper_closing_bridge_route_divergence_witness
  part6_full_paper_closing_divergence_witness_current_obstruction :=
    not_Part6FullPaperClosingDivergenceWitness_current
  part6_full_paper_closing_support_current_obstruction_via_divergence_witness :=
    not_part6_full_paper_closing_support_current_via_divergence_witness
  part6_full_paper_closing_bridge_route_current_obstruction_via_divergence_witness :=
    not_part6_full_paper_closing_bridge_route_current_via_divergence_witness
  part6_full_paper_closing_support_feasible_divergence_witness :=
    part6_full_paper_closing_support_feasible_divergence_witness
  part6_full_paper_closing_bridge_route_feasible_divergence_witness :=
    part6_full_paper_closing_bridge_route_feasible_divergence_witness
  part6_full_paper_closing_support_output_pair :=
    part6_full_paper_closing_support_output_pair
  part6_full_paper_closing_bridge_route_output_pair :=
    part6_full_paper_closing_bridge_route_output_pair
  part6_full_paper_closing_support_full_output_bundle :=
    part6_full_paper_closing_support_full_output_bundle
  part6_full_paper_closing_bridge_route_full_output_bundle :=
    part6_full_paper_closing_bridge_route_full_output_bundle
  part6_full_paper_closing_feasible_divergence_witness_current_obstruction :=
    not_Part6FullPaperClosingFeasibleDivergenceWitness_current
  part6_full_paper_closing_output_pair_current_obstruction :=
    not_part6_full_paper_closing_output_pair_current
  part6_full_paper_closing_full_output_bundle_current_obstruction :=
    not_part6_full_paper_closing_full_output_bundle_current
  part6_full_paper_closing_support_current_obstruction_via_feasible_divergence_witness :=
    not_part6_full_paper_closing_support_current_via_feasible_divergence_witness
  part6_full_paper_closing_bridge_route_current_obstruction_via_feasible_divergence_witness :=
    not_part6_full_paper_closing_bridge_route_current_via_feasible_divergence_witness
  part6_full_paper_closing_support_current_obstruction_via_output_pair :=
    not_part6_full_paper_closing_support_current_via_output_pair
  part6_full_paper_closing_bridge_route_current_obstruction_via_output_pair :=
    not_part6_full_paper_closing_bridge_route_current_via_output_pair
  part6_full_paper_closing_support_current_obstruction_via_full_output_bundle :=
    not_part6_full_paper_closing_support_current_via_full_output_bundle
  part6_full_paper_closing_bridge_route_current_obstruction_via_full_output_bundle :=
    not_part6_full_paper_closing_bridge_route_current_via_full_output_bundle
  part6_full_paper_closing_support_of_local_bridge :=
    part6_full_paper_closing_support_of_z2_lattice_embedding_local_bridge
  part6_full_paper_closing_support_of_closed_unit_bridge :=
    part6_full_paper_closing_support_of_z2_lattice_embedding_closed_unit_local_bridge
  part6_full_paper_closing_support_of_bridge_route :=
    part6_full_paper_closing_support_of_bridge_route
  part6_full_paper_closing_bridge_route_current_obstruction :=
    not_part6_full_paper_closing_bridge_route_current
  z2_lattice_embedding_bridge_transfer :=
    gap_cognitive_threshold_part6_from_z2_lattice_embedding_bridge
  z2_lattice_embedding_local_bridge_transfer :=
    gap_cognitive_threshold_part6_from_z2_lattice_embedding_local_bridge
  z2_lattice_embedding_local_bridge_near_pc_feasible_nonempty :=
    z2LatticeEmbeddingLocalBridgeData_near_pc_feasible_nonempty
  z2_lattice_embedding_local_bridge_nonempty_alpha_domain :=
    z2LatticeEmbeddingLocalBridgeData_nonempty_unbounded_alpha_domain
  z2_lattice_embedding_local_bridge_paper_support_certificate :=
    z2LatticeEmbeddingLocalBridgeData_paper_support_certificate
  z2_lattice_embedding_local_bridge_pointwise_paper_domain_certificate :=
    z2LatticeEmbeddingLocalBridgeData_pointwise_paper_domain_certificate
  z2_lattice_embedding_local_bridge_feasible_divergence_witness :=
    z2LatticeEmbeddingLocalBridgeData_feasible_divergence_witness
  z2_lattice_embedding_local_bridge_full_paper_domain_witness :=
    z2LatticeEmbeddingLocalBridgeData_full_paper_domain_witness
  z2_lattice_embedding_closed_unit_local_bridge_transfer :=
    gap_cognitive_threshold_part6_from_z2_lattice_embedding_closed_unit_local_bridge
  z2_lattice_embedding_closed_unit_local_bridge_alphaStar_lt_one :=
    fun bridge => bridge.closed_unit_alphaStar_lt_one
  z2_lattice_embedding_closed_unit_local_bridge_sentimental_welfare_reversal_required :=
    z2LatticeEmbeddingClosedUnitLocalBridgeData_sentimental_welfare_reversal_required
  z2_lattice_embedding_closed_unit_local_bridge_nonempty_alpha_domain :=
    z2LatticeEmbeddingClosedUnitLocalBridgeData_nonempty_closed_unit_alpha_domain
  z2_lattice_embedding_closed_unit_local_bridge_near_pc_feasible_nonempty :=
    z2LatticeEmbeddingClosedUnitLocalBridgeData_near_pc_feasible_nonempty
  z2_lattice_embedding_closed_unit_local_bridge_witness :=
    gap_cognitive_threshold_part6_from_z2_lattice_embedding_closed_unit_local_bridge_witness
  z2_lattice_embedding_closed_unit_local_bridge_paper_support_certificate :=
    z2LatticeEmbeddingClosedUnitLocalBridgeData_paper_support_certificate
  z2_lattice_embedding_closed_unit_local_bridge_paper_support_with_sentimental_reversal :=
    z2LatticeEmbeddingClosedUnitLocalBridgeData_paper_support_with_sentimental_reversal
  z2_lattice_embedding_closed_unit_local_bridge_pointwise_paper_domain_certificate :=
    z2LatticeEmbeddingClosedUnitLocalBridgeData_pointwise_paper_domain_certificate
  z2_lattice_embedding_closed_unit_local_bridge_feasible_divergence_witness :=
    z2LatticeEmbeddingClosedUnitLocalBridgeData_feasible_divergence_witness
  z2_lattice_embedding_closed_unit_local_bridge_full_paper_domain_witness :=
    z2LatticeEmbeddingClosedUnitLocalBridgeData_full_paper_domain_witness

/-- Typed frontier for the open random supercritical `Z2_L`
topological-cluster/phase target.  This does not close the semantic target:
it machine-checks the current closed theorem surface, all-open/complement and
full-reach boxed-torus finite witnesses, the current `Z²` bridge witnesses,
the flat-sequence lower-bound package, a concrete first-edge Bernoulli witness
showing that the repaired bridge contract is nonempty, the boxed-torus
base-horizontal-edge flattening/reachability/zero-loss/no-positive-giant-loss
calibration for that
witness, and the obstruction evidence showing
why the remaining paper claim still needs a semantic identification with the
random finite-lattice giant-component/topological-loss carrier. -/
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
  random_supercritical_z2_bridge_to_z2_bridge :
    RandomSupercriticalZ2TopoClusterBridgeData → Z2TopoClusterBridgeData
  random_supercritical_z2_bridge_core :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      BoxedTorusFlatFamilyCoreConclusion bridge.family
  random_supercritical_z2_bridge_lower_bound :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion
        bridge.family
  random_supercritical_z2_repaired_bridge_to_z2_bridge :
    RandomSupercriticalZ2TopoClusterRepairedBridgeData → Z2TopoClusterBridgeData
  random_supercritical_z2_repaired_bridge_core :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      BoxedTorusFlatFamilyCoreConclusion bridge.family
  random_supercritical_z2_repaired_bridge_lower_bound :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion
        bridge.family
  random_supercritical_z2_repaired_bridge_probability_domain :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      harrisKestenCriticalProb < bridge.supercriticalProbability ∧
        0 ≤ bridge.supercriticalProbability ∧
          bridge.supercriticalProbability ≤ 1
  random_supercritical_z2_repaired_bridge_strict_probability_domain :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      harrisKestenCriticalProb < bridge.supercriticalProbability ∧
        0 ≤ bridge.supercriticalProbability ∧
          bridge.supercriticalProbability < 1
  random_supercritical_z2_repaired_bridge_topoLossKernel_mem_unitInterval :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      ∀ L : ℕ,
        ∀ n : ℕ,
          ∀ omega : BondConfig (EdgeIdx n),
            0 ≤ (bridge.family L).topoLossKernel n omega ∧
              (bridge.family L).topoLossKernel n omega ≤ 1
  random_supercritical_z2_repaired_bridge_named_flat_lower_bound :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
          c ≤
            expectedTopoLossOnData (bridge.family L)
              (boxedTorusFlatGraphN L) bridge.supercriticalProbability
  random_supercritical_z2_repaired_bridge_giant_event_mass_lower_bound :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
          c ≤
            percRestrictedExpectation (1 - bridge.supercriticalProbability)
              ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
              (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                (1 : Real))
  random_supercritical_z2_repaired_bridge_eventually_uniform_flat_event_mass_lower_bound_and_loss_realisation :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
          c ≤
            expectedTopoLossOnData (bridge.family L)
              (boxedTorusFlatGraphN L) bridge.supercriticalProbability ∧
          c ≤
            percRestrictedExpectation (1 - bridge.supercriticalProbability)
              ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
              (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                (1 : Real)) ∧
          ∃ omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
            0 < (bridge.family L).topoLossKernel
              (boxedTorusFlatGraphN L) omega
  random_supercritical_z2_repaired_bridge_eventually_giant_event_member :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
        ∃ omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
          Membership.mem
            ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
            omega
  random_supercritical_z2_repaired_bridge_eventually_uniform_flat_event_mass_member_and_loss_realisation :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
          c ≤
            expectedTopoLossOnData (bridge.family L)
              (boxedTorusFlatGraphN L) bridge.supercriticalProbability ∧
          c ≤
            percRestrictedExpectation (1 - bridge.supercriticalProbability)
              ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
              (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                (1 : Real)) ∧
          (∃ omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
            Membership.mem
              ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
              omega) ∧
          ∃ omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
            0 < (bridge.family L).topoLossKernel
              (boxedTorusFlatGraphN L) omega
  random_supercritical_z2_repaired_bridge_eventually_uniform_supported_extended_non_diagnostic_member :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∀ L0 : ℕ,
          ∃ L : ℕ,
            L0 ≤ L ∧
            c ≤
              expectedTopoLossOnData (bridge.family L)
                (boxedTorusFlatGraphN L) bridge.supercriticalProbability ∧
            c ≤
              percRestrictedExpectation (1 - bridge.supercriticalProbability)
                ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
                (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                  (1 : Real)) ∧
            (∃ omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
              0 < (bridge.family L).topoLossKernel
                (boxedTorusFlatGraphN L) omega) ∧
            bridge.family L ≠ boxedTorusFullReachComplementTopoLossData L ∧
            bridge.family L ≠
              boxedTorusFullReachFlatOnlyComplementTopoLossData L ∧
            bridge.family L ≠ boxedTorusAllOpenComplementTopoLossData L ∧
            bridge.family L ≠ boxedTorusAllOpenGiantTopoLossData L ∧
            bridge.family L ≠ boxedTorusAllOpenPositiveTopoLossData L
  random_supercritical_z2_repaired_bridge_eventually_uniform_supported_extended_non_diagnostic_member_with_giant_member :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∀ L0 : ℕ,
          ∃ L : ℕ,
            L0 ≤ L ∧
            c ≤
              expectedTopoLossOnData (bridge.family L)
                (boxedTorusFlatGraphN L) bridge.supercriticalProbability ∧
            c ≤
              percRestrictedExpectation (1 - bridge.supercriticalProbability)
                ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
                (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                  (1 : Real)) ∧
            (∃ omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
              Membership.mem
                ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
                omega) ∧
            (∃ omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
              0 < (bridge.family L).topoLossKernel
                (boxedTorusFlatGraphN L) omega) ∧
            bridge.family L ≠ boxedTorusFullReachComplementTopoLossData L ∧
            bridge.family L ≠
              boxedTorusFullReachFlatOnlyComplementTopoLossData L ∧
            bridge.family L ≠ boxedTorusAllOpenComplementTopoLossData L ∧
            bridge.family L ≠ boxedTorusAllOpenGiantTopoLossData L ∧
            bridge.family L ≠ boxedTorusAllOpenPositiveTopoLossData L
  random_supercritical_z2_repaired_bridge_paper_support :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      RandomSupercriticalZ2TopoClusterRepairedBridgePaperSupport bridge
  random_supercritical_z2_repaired_bridge_support_surface_repair :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceRepair
        bridge
  random_supercritical_z2_support_surface_repair_route :
    RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute
  random_supercritical_z2_support_surface_repair_certificate :
    RandomSupercriticalZ2TopoClusterSupportSurfaceRepairCertificate
  random_supercritical_z2_support_surface_repair_route_output_certificate :
    RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRouteOutputCertificate
  random_supercritical_z2_support_surface_repair_nonclosure_certificate :
    RandomSupercriticalZ2TopoClusterSupportSurfaceRepairNonClosureCertificate
  random_supercritical_z2_support_surface_closing_route_certificate :
    RandomSupercriticalZ2TopoClusterSupportSurfaceClosingRouteCertificate
  random_supercritical_z2_support_surface_closing_route_iff_full_support :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceClosingRoute
        bridge ↔
        RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport
          bridge
  random_supercritical_z2_repaired_bridge_diagnostic_obstruction_certificate :
    RandomSupercriticalZ2TopoClusterRepairedBridgeDiagnosticObstructionCertificate
  first_edge_giant_stochastic_positive_regression :
    FirstEdgeGiantStochasticTopoLossPositiveRegressionCertificate
  first_edge_giant_stochastic_not_random_supercritical_z2_bridge :
    FirstEdgeGiantStochasticTopoLossNotRandomSupercriticalZ2BridgeCertificate
  boxed_torus_full_reach_flat_only_lower_bound_cutset_route :
    BoxedTorusFullReachFlatOnlyLowerBoundCutsetRouteCertificate
  random_supercritical_z2_repaired_bridge_current_witness :
    Nonempty RandomSupercriticalZ2TopoClusterRepairedBridgeData
  random_supercritical_z2_repaired_bridge_current_family :
    firstEdgeOpenGiantClosedTopoLossRepairedBridge_current.family =
      firstEdgeOpenGiantClosedTopoLossFamily
  random_supercritical_z2_repaired_bridge_current_base_horizontal_edge_slot :
    forall L : Nat,
      boxedTorusFlattenEdgeIdx L (boxedTorusBaseHorizontalEdge L) =
        firstEdgeIdx (boxedTorusFlatGraphN L)
  random_supercritical_z2_repaired_bridge_current_giant_event_base_horizontal_edge :
    forall L : Nat,
      forall omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
        omega ∈
            (firstEdgeOpenGiantClosedTopoLossFamily L).giantComponentEvent
              (boxedTorusFlatGraphN L) ↔
          omega (boxedTorusFlattenEdgeIdx L
            (boxedTorusBaseHorizontalEdge L)) = true
  random_supercritical_z2_repaired_bridge_current_giant_event_reaches_base_horizontal_target :
    forall L : Nat,
      forall omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
        omega ∈
            (firstEdgeOpenGiantClosedTopoLossFamily L).giantComponentEvent
              (boxedTorusFlatGraphN L) ->
          Membership.mem
            (oracleFiniteBondGraphReachableSet
              (boxedTorusOracleFiniteBondGraphData L)
              (boxedTorusFlatGraphN L) omega)
            (boxedTorusFlattenMainVertex L (boxedTorusBaseHorizontalTarget L))
  random_supercritical_z2_repaired_bridge_current_topoLossKernel_zero_on_giant_event :
    forall L : Nat,
      forall omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
        omega ∈
            (firstEdgeOpenGiantClosedTopoLossFamily L).giantComponentEvent
              (boxedTorusFlatGraphN L) ->
          (firstEdgeOpenGiantClosedTopoLossFamily L).topoLossKernel
            (boxedTorusFlatGraphN L) omega = 0
  random_supercritical_z2_repaired_bridge_current_expectedTopoLossOnGiantOn_eq_zero :
    forall L : Nat,
      expectedTopoLossOnGiantOn
        (firstEdgeOpenGiantClosedTopoLossFamily L)
        (boxedTorusFlatGraphN L) ((3 : Real) / 4) = 0
  random_supercritical_z2_repaired_bridge_current_support_surface_repair :
    RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceRepair
      firstEdgeOpenGiantClosedTopoLossRepairedBridge_current
  random_supercritical_z2_repaired_bridge_current_not_positive_giant_loss_lower_bound :
    Not (Exists fun c : Real =>
      0 < c /\ c <= 1 /\
        Exists fun L0 : Nat =>
          forall L : Nat, L0 <= L ->
            c <=
              expectedTopoLossOnGiantOn
                (firstEdgeOpenGiantClosedTopoLossFamily L)
                (boxedTorusFlatGraphN L) ((3 : Real) / 4))
  random_supercritical_z2_bridge_to_repaired_giant_loss_paper_closing :
    forall bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
        (RandomSupercriticalZ2TopoClusterRepairedBridgeData_from_current_contract
          bridge)
  random_supercritical_z2_repaired_bridge_current_not_giant_loss_paper_closing :
    Not
      (RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
        firstEdgeOpenGiantClosedTopoLossRepairedBridge_current)
  random_supercritical_z2_bridge_to_repaired_full_paper_closing_support :
    forall bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport
        (RandomSupercriticalZ2TopoClusterRepairedBridgeData_from_current_contract
          bridge)
  random_supercritical_z2_repaired_bridge_current_not_full_paper_closing_support :
    Not
      (RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport
        firstEdgeOpenGiantClosedTopoLossRepairedBridge_current)
  random_supercritical_z2_repaired_bridge_first_edge_three_quarters_not_giant_loss_paper_closing :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      (∀ L : ℕ,
        bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) ->
      bridge.supercriticalProbability = ((3 : Real) / 4) ->
        Not
          (RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
            bridge)
  random_supercritical_z2_full_paper_closing_route_first_edge_three_quarters_giant_loss_output_obstruction :
    Not (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
      (∀ L : ℕ,
        bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) /\
      bridge.supercriticalProbability = ((3 : Real) / 4) /\
      RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
        bridge)
  random_supercritical_z2_full_paper_closing_route_first_edge_three_quarters_combined_support_output_obstruction :
    Not (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
      (∀ L : ℕ,
        bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) /\
      bridge.supercriticalProbability = ((3 : Real) / 4) /\
      Exists fun c : Real =>
        0 < c /\ c <= 1 /\
          Exists fun L0 : Nat =>
            ∀ L : Nat, L0 <= L ->
              c <=
                expectedTopoLossOnData (bridge.family L)
                  (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
              c <=
                expectedTopoLossOnGiantOn (bridge.family L)
                  (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
              c <=
                percRestrictedExpectation (1 - bridge.supercriticalProbability)
                  ((bridge.family L).giantComponentEvent
                    (boxedTorusFlatGraphN L))
                  (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    (1 : Real)) /\
              Exists fun omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                Membership.mem
                  ((bridge.family L).giantComponentEvent
                    (boxedTorusFlatGraphN L)) omega /\
                0 <
                  (bridge.family L).topoLossKernel
                    (boxedTorusFlatGraphN L) omega)
  random_supercritical_z2_full_paper_closing_route_first_edge_three_quarters_supported_extended_non_diagnostic_output_obstruction :
    Not (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
      (∀ L : ℕ,
        bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) /\
      bridge.supercriticalProbability = ((3 : Real) / 4) /\
      Exists fun c : Real =>
        0 < c /\ c <= 1 /\
          ∀ L0 : Nat,
            Exists fun L : Nat =>
              L0 <= L /\
              c <=
                expectedTopoLossOnData (bridge.family L)
                  (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
              c <=
                expectedTopoLossOnGiantOn (bridge.family L)
                  (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
              c <=
                percRestrictedExpectation (1 - bridge.supercriticalProbability)
                  ((bridge.family L).giantComponentEvent
                    (boxedTorusFlatGraphN L))
                  (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    (1 : Real)) /\
              (Exists fun omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                Membership.mem
                  ((bridge.family L).giantComponentEvent
                    (boxedTorusFlatGraphN L)) omega /\
                0 <
                  (bridge.family L).topoLossKernel
                    (boxedTorusFlatGraphN L) omega) /\
              Not (bridge.family L = boxedTorusFullReachComplementTopoLossData L) /\
              Not (bridge.family L =
                boxedTorusFullReachFlatOnlyComplementTopoLossData L) /\
              Not (bridge.family L = boxedTorusAllOpenComplementTopoLossData L) /\
              Not (bridge.family L = boxedTorusAllOpenGiantTopoLossData L) /\
              Not (bridge.family L = boxedTorusAllOpenPositiveTopoLossData L))
  random_supercritical_z2_full_paper_closing_route_first_edge_three_quarters_output_bundle_obstruction :
    Not (
      let GiantLossOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          (forall L : Nat,
            bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) /\
          bridge.supercriticalProbability = ((3 : Real) / 4) /\
          RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
            bridge);
      let CombinedSupportOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          (forall L : Nat,
            bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) /\
          bridge.supercriticalProbability = ((3 : Real) / 4) /\
          Exists fun c : Real =>
            0 < c /\ c <= 1 /\
              Exists fun L0 : Nat =>
                forall L : Nat, L0 <= L ->
                  c <=
                    expectedTopoLossOnData (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    expectedTopoLossOnGiantOn (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    percRestrictedExpectation (1 - bridge.supercriticalProbability)
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L))
                      (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                        (1 : Real)) /\
                  Exists fun omega :
                      BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    Membership.mem
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L)) omega /\
                    0 <
                      (bridge.family L).topoLossKernel
                        (boxedTorusFlatGraphN L) omega);
      let SupportedNonDiagnosticOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          (forall L : Nat,
            bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) /\
          bridge.supercriticalProbability = ((3 : Real) / 4) /\
          Exists fun c : Real =>
            0 < c /\ c <= 1 /\
              forall L0 : Nat,
                Exists fun L : Nat =>
                  L0 <= L /\
                  c <=
                    expectedTopoLossOnData (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    expectedTopoLossOnGiantOn (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    percRestrictedExpectation (1 - bridge.supercriticalProbability)
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L))
                      (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                        (1 : Real)) /\
                  (Exists fun omega :
                      BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    Membership.mem
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L)) omega /\
                    0 <
                      (bridge.family L).topoLossKernel
                        (boxedTorusFlatGraphN L) omega) /\
                  Not (bridge.family L =
                    boxedTorusFullReachComplementTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusFullReachFlatOnlyComplementTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusAllOpenComplementTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusAllOpenGiantTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusAllOpenPositiveTopoLossData L));
      GiantLossOutput /\ CombinedSupportOutput /\
        SupportedNonDiagnosticOutput)
  random_supercritical_z2_full_paper_closing_route_first_edge_three_quarters_full_output_bundle_obstruction :
    Not (
      let PaperSupportOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          (forall L : Nat,
            bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) /\
          bridge.supercriticalProbability = ((3 : Real) / 4) /\
          RandomSupercriticalZ2TopoClusterRepairedBridgePaperSupport bridge);
      let GiantLossOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          (forall L : Nat,
            bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) /\
          bridge.supercriticalProbability = ((3 : Real) / 4) /\
          RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
            bridge);
      let CombinedSupportOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          (forall L : Nat,
            bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) /\
          bridge.supercriticalProbability = ((3 : Real) / 4) /\
          Exists fun c : Real =>
            0 < c /\ c <= 1 /\
              Exists fun L0 : Nat =>
                forall L : Nat, L0 <= L ->
                  c <=
                    expectedTopoLossOnData (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    expectedTopoLossOnGiantOn (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    percRestrictedExpectation (1 - bridge.supercriticalProbability)
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L))
                      (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                        (1 : Real)) /\
                  Exists fun omega :
                      BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    Membership.mem
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L)) omega /\
                    0 <
                      (bridge.family L).topoLossKernel
                        (boxedTorusFlatGraphN L) omega);
      let SupportedNonDiagnosticOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          (forall L : Nat,
            bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) /\
          bridge.supercriticalProbability = ((3 : Real) / 4) /\
          Exists fun c : Real =>
            0 < c /\ c <= 1 /\
              forall L0 : Nat,
                Exists fun L : Nat =>
                  L0 <= L /\
                  c <=
                    expectedTopoLossOnData (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    expectedTopoLossOnGiantOn (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    percRestrictedExpectation (1 - bridge.supercriticalProbability)
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L))
                      (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                        (1 : Real)) /\
                  (Exists fun omega :
                      BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    Membership.mem
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L)) omega /\
                    0 <
                      (bridge.family L).topoLossKernel
                        (boxedTorusFlatGraphN L) omega) /\
                  Not (bridge.family L =
                    boxedTorusFullReachComplementTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusFullReachFlatOnlyComplementTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusAllOpenComplementTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusAllOpenGiantTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusAllOpenPositiveTopoLossData L));
      PaperSupportOutput /\ GiantLossOutput /\ CombinedSupportOutput /\
        SupportedNonDiagnosticOutput)
  random_supercritical_z2_repaired_bridge_first_edge_three_quarters_not_full_paper_closing_support :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      (∀ L : ℕ,
        bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) ->
      bridge.supercriticalProbability = ((3 : Real) / 4) ->
        Not
          (RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport
            bridge)
  random_supercritical_z2_repaired_bridge_giant_pointwise_loss_route_to_giant_loss :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      RandomSupercriticalZ2TopoClusterRepairedBridgeGiantPointwiseLossRoute
        bridge ->
        RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
          bridge
  random_supercritical_z2_repaired_bridge_giant_pointwise_loss_route_to_full_support :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      RandomSupercriticalZ2TopoClusterRepairedBridgeGiantPointwiseLossRoute
        bridge ->
        RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport
          bridge
  random_supercritical_z2_repaired_bridge_support_surface_closing_route_of_giant_pointwise_loss_route :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      RandomSupercriticalZ2TopoClusterRepairedBridgeGiantPointwiseLossRoute
        bridge ->
        RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceClosingRoute
          bridge
  random_supercritical_z2_full_paper_closing_route_of_giant_pointwise_loss_route :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      RandomSupercriticalZ2TopoClusterRepairedBridgeGiantPointwiseLossRoute
        bridge ->
        RandomSupercriticalZ2TopoClusterFullPaperClosingRoute
  random_supercritical_z2_boxed_torus_finite_z2L_route_of_giant_pointwise_loss_route :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      RandomSupercriticalZ2TopoClusterRepairedBridgeGiantPointwiseLossRoute
        bridge ->
        RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute
  random_supercritical_z2_repaired_bridge_current_not_giant_pointwise_loss_route :
    Not
      (RandomSupercriticalZ2TopoClusterRepairedBridgeGiantPointwiseLossRoute
        firstEdgeOpenGiantClosedTopoLossRepairedBridge_current)
  random_supercritical_z2_giant_pointwise_loss_route_certificate :
    RandomSupercriticalZ2TopoClusterGiantPointwiseLossRouteCertificate
  random_supercritical_z2_full_paper_closing_route_output_certificate :
    RandomSupercriticalZ2TopoClusterFullPaperClosingRouteOutputCertificate
  random_supercritical_z2_boxed_torus_finite_z2L_route_certificate :
    RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LRouteCertificate
  random_supercritical_z2_semantic_kernel_target_iff_full_route :
    TopoClusterRandomSupercriticalZ2SemanticKernelTarget ↔
      RandomSupercriticalZ2TopoClusterFullPaperClosingRoute
  random_supercritical_z2_semantic_kernel_target_iff_boxed_torus_finite_z2L_route :
    TopoClusterRandomSupercriticalZ2SemanticKernelTarget ↔
      RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute
  random_supercritical_z2_semantic_kernel_target_current_obstruction :
    Not TopoClusterRandomSupercriticalZ2SemanticKernelTarget
  random_supercritical_z2_full_paper_closing_route_iff_boxed_torus_finite_z2L_route :
    RandomSupercriticalZ2TopoClusterFullPaperClosingRoute ↔
      RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute
  random_supercritical_z2_full_support_envelope_obstruction_certificate :
    RandomSupercriticalZ2TopoClusterFullSupportEnvelopeObstructionCertificate
  random_supercritical_z2_repaired_bridge_giant_loss_general_obstruction :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      Not
        (RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
          bridge)
  random_supercritical_z2_repaired_bridge_full_support_general_obstruction :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      Not
        (RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport
          bridge)
  random_supercritical_z2_repaired_bridge_giant_pointwise_loss_route_general_obstruction :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      Not
        (RandomSupercriticalZ2TopoClusterRepairedBridgeGiantPointwiseLossRoute
          bridge)
  random_supercritical_z2_full_paper_closing_route_general_obstruction :
    Not RandomSupercriticalZ2TopoClusterFullPaperClosingRoute
  random_supercritical_z2_boxed_torus_finite_z2L_route_general_obstruction :
    Not RandomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute
  random_supercritical_z2_full_paper_closing_route_first_edge_three_quarters_witness_obstruction :
    Not (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
      (∀ L : ℕ,
        bridge.family L = firstEdgeOpenGiantClosedTopoLossFamily L) /\
      bridge.supercriticalProbability = ((3 : Real) / 4) /\
      RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport
        bridge)
  random_supercritical_z2_full_paper_closing_route_of_repaired_bridge :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport
        bridge ->
        RandomSupercriticalZ2TopoClusterFullPaperClosingRoute
  random_supercritical_z2_full_paper_closing_route_repaired_bridge_nonempty :
    RandomSupercriticalZ2TopoClusterFullPaperClosingRoute ->
      Nonempty RandomSupercriticalZ2TopoClusterRepairedBridgeData
  random_supercritical_z2_full_paper_closing_route_support_witness :
    RandomSupercriticalZ2TopoClusterFullPaperClosingRoute ->
      Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
        RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport
          bridge
  random_supercritical_z2_full_paper_closing_route_paper_support_output :
    RandomSupercriticalZ2TopoClusterFullPaperClosingRoute ->
      Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
        RandomSupercriticalZ2TopoClusterRepairedBridgePaperSupport bridge
  random_supercritical_z2_full_paper_closing_route_support_surface_repair_output :
    RandomSupercriticalZ2TopoClusterFullPaperClosingRoute ->
      Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
        RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceRepair
          bridge
  random_supercritical_z2_full_paper_closing_route_support_surface_repair_route :
    RandomSupercriticalZ2TopoClusterFullPaperClosingRoute ->
      RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute
  random_supercritical_z2_full_paper_closing_route_support_surface_repair_output_certificate :
    RandomSupercriticalZ2TopoClusterFullPaperClosingRoute ->
      RandomSupercriticalZ2TopoClusterSupportSurfaceRepairOutput
  random_supercritical_z2_full_paper_closing_route_giant_loss_output :
    RandomSupercriticalZ2TopoClusterFullPaperClosingRoute ->
      Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
        RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
          bridge
  random_supercritical_z2_full_paper_closing_route_combined_support_output :
    RandomSupercriticalZ2TopoClusterFullPaperClosingRoute ->
      Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
        Exists fun c : Real =>
          0 < c /\ c <= 1 /\
            Exists fun L0 : Nat =>
              forall L : Nat, L0 <= L ->
                c <=
                  expectedTopoLossOnData (bridge.family L)
                    (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                c <=
                  expectedTopoLossOnGiantOn (bridge.family L)
                    (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                c <=
                  percRestrictedExpectation (1 - bridge.supercriticalProbability)
                    ((bridge.family L).giantComponentEvent
                      (boxedTorusFlatGraphN L))
                    (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                      (1 : Real)) /\
                Exists fun omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                  Membership.mem
                    ((bridge.family L).giantComponentEvent
                      (boxedTorusFlatGraphN L)) omega /\
                  0 <
                    (bridge.family L).topoLossKernel
                      (boxedTorusFlatGraphN L) omega
  random_supercritical_z2_full_paper_closing_route_supported_extended_non_diagnostic_output :
    RandomSupercriticalZ2TopoClusterFullPaperClosingRoute ->
      Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
        Exists fun c : Real =>
          0 < c /\ c <= 1 /\
            forall L0 : Nat,
              Exists fun L : Nat =>
                L0 <= L /\
                c <=
                  expectedTopoLossOnData (bridge.family L)
                    (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                c <=
                  expectedTopoLossOnGiantOn (bridge.family L)
                    (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                c <=
                  percRestrictedExpectation (1 - bridge.supercriticalProbability)
                    ((bridge.family L).giantComponentEvent
                      (boxedTorusFlatGraphN L))
                    (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                      (1 : Real)) /\
                (Exists fun omega : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                  Membership.mem
                    ((bridge.family L).giantComponentEvent
                      (boxedTorusFlatGraphN L)) omega /\
                  0 <
                    (bridge.family L).topoLossKernel
                      (boxedTorusFlatGraphN L) omega) /\
                Not (bridge.family L = boxedTorusFullReachComplementTopoLossData L) /\
                Not (bridge.family L =
                  boxedTorusFullReachFlatOnlyComplementTopoLossData L) /\
                Not (bridge.family L = boxedTorusAllOpenComplementTopoLossData L) /\
                Not (bridge.family L = boxedTorusAllOpenGiantTopoLossData L) /\
                Not (bridge.family L = boxedTorusAllOpenPositiveTopoLossData L)
  random_supercritical_z2_full_paper_closing_route_output_bundle :
    forall _hroute : RandomSupercriticalZ2TopoClusterFullPaperClosingRoute,
      let GiantLossOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
            bridge);
      let CombinedSupportOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          Exists fun c : Real =>
            0 < c /\ c <= 1 /\
              Exists fun L0 : Nat =>
                forall L : Nat, L0 <= L ->
                  c <=
                    expectedTopoLossOnData (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    expectedTopoLossOnGiantOn (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    percRestrictedExpectation (1 - bridge.supercriticalProbability)
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L))
                      (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                        (1 : Real)) /\
                  Exists fun omega :
                      BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    Membership.mem
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L)) omega /\
                    0 <
                      (bridge.family L).topoLossKernel
                        (boxedTorusFlatGraphN L) omega);
      let SupportedNonDiagnosticOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          Exists fun c : Real =>
            0 < c /\ c <= 1 /\
              forall L0 : Nat,
                Exists fun L : Nat =>
                  L0 <= L /\
                  c <=
                    expectedTopoLossOnData (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    expectedTopoLossOnGiantOn (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    percRestrictedExpectation (1 - bridge.supercriticalProbability)
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L))
                      (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                        (1 : Real)) /\
                  (Exists fun omega :
                      BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    Membership.mem
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L)) omega /\
                    0 <
                      (bridge.family L).topoLossKernel
                        (boxedTorusFlatGraphN L) omega) /\
                  Not (bridge.family L =
                    boxedTorusFullReachComplementTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusFullReachFlatOnlyComplementTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusAllOpenComplementTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusAllOpenGiantTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusAllOpenPositiveTopoLossData L));
      GiantLossOutput /\ CombinedSupportOutput /\
        SupportedNonDiagnosticOutput
  random_supercritical_z2_full_paper_closing_route_full_output_bundle :
    forall _hroute : RandomSupercriticalZ2TopoClusterFullPaperClosingRoute,
      let PaperSupportOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          RandomSupercriticalZ2TopoClusterRepairedBridgePaperSupport bridge);
      let GiantLossOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
            bridge);
      let CombinedSupportOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          Exists fun c : Real =>
            0 < c /\ c <= 1 /\
              Exists fun L0 : Nat =>
                forall L : Nat, L0 <= L ->
                  c <=
                    expectedTopoLossOnData (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    expectedTopoLossOnGiantOn (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    percRestrictedExpectation (1 - bridge.supercriticalProbability)
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L))
                      (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                        (1 : Real)) /\
                  Exists fun omega :
                      BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    Membership.mem
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L)) omega /\
                    0 <
                      (bridge.family L).topoLossKernel
                        (boxedTorusFlatGraphN L) omega);
      let SupportedNonDiagnosticOutput : Prop :=
        (Exists fun bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          Exists fun c : Real =>
            0 < c /\ c <= 1 /\
              forall L0 : Nat,
                Exists fun L : Nat =>
                  L0 <= L /\
                  c <=
                    expectedTopoLossOnData (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    expectedTopoLossOnGiantOn (bridge.family L)
                      (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
                  c <=
                    percRestrictedExpectation (1 - bridge.supercriticalProbability)
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L))
                      (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                        (1 : Real)) /\
                  (Exists fun omega :
                      BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    Membership.mem
                      ((bridge.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L)) omega /\
                    0 <
                      (bridge.family L).topoLossKernel
                        (boxedTorusFlatGraphN L) omega) /\
                  Not (bridge.family L =
                    boxedTorusFullReachComplementTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusFullReachFlatOnlyComplementTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusAllOpenComplementTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusAllOpenGiantTopoLossData L) /\
                  Not (bridge.family L =
                    boxedTorusAllOpenPositiveTopoLossData L));
      PaperSupportOutput /\ GiantLossOutput /\ CombinedSupportOutput /\
        SupportedNonDiagnosticOutput
  random_supercritical_z2_bridge_to_full_paper_closing_route :
    ∀ _bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      RandomSupercriticalZ2TopoClusterFullPaperClosingRoute
  random_supercritical_z2_bridge_to_full_paper_closing_route_paper_support_output :
    ∀ _bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      Exists fun repaired : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
        RandomSupercriticalZ2TopoClusterRepairedBridgePaperSupport repaired
  random_supercritical_z2_bridge_to_full_paper_closing_route_giant_loss_output :
    ∀ _bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      Exists fun repaired : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
        RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
          repaired
  random_supercritical_z2_bridge_to_full_paper_closing_route_combined_support_output :
    ∀ _bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      Exists fun repaired : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
        Exists fun c : Real =>
          0 < c /\ c <= 1 /\
            Exists fun L0 : Nat =>
              ∀ L : Nat, L0 <= L ->
                c <=
                  expectedTopoLossOnData (repaired.family L)
                    (boxedTorusFlatGraphN L) repaired.supercriticalProbability /\
                c <=
                  expectedTopoLossOnGiantOn (repaired.family L)
                    (boxedTorusFlatGraphN L) repaired.supercriticalProbability /\
                c <=
                  percRestrictedExpectation
                    (1 - repaired.supercriticalProbability)
                    ((repaired.family L).giantComponentEvent
                      (boxedTorusFlatGraphN L))
                    (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                      (1 : Real)) /\
                Exists fun omega :
                    BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                  Membership.mem
                    ((repaired.family L).giantComponentEvent
                      (boxedTorusFlatGraphN L)) omega /\
                  0 <
                    (repaired.family L).topoLossKernel
                      (boxedTorusFlatGraphN L) omega
  random_supercritical_z2_bridge_to_full_paper_closing_route_supported_extended_non_diagnostic_output :
    ∀ _bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      Exists fun repaired : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
        Exists fun c : Real =>
          0 < c /\ c <= 1 /\
            ∀ L0 : Nat,
              Exists fun L : Nat =>
                L0 <= L /\
                c <=
                  expectedTopoLossOnData (repaired.family L)
                    (boxedTorusFlatGraphN L) repaired.supercriticalProbability /\
                c <=
                  expectedTopoLossOnGiantOn (repaired.family L)
                    (boxedTorusFlatGraphN L) repaired.supercriticalProbability /\
                c <=
                  percRestrictedExpectation
                    (1 - repaired.supercriticalProbability)
                    ((repaired.family L).giantComponentEvent
                      (boxedTorusFlatGraphN L))
                    (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                      (1 : Real)) /\
                (Exists fun omega :
                    BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                  Membership.mem
                    ((repaired.family L).giantComponentEvent
                      (boxedTorusFlatGraphN L)) omega /\
                  0 <
                    (repaired.family L).topoLossKernel
                      (boxedTorusFlatGraphN L) omega) /\
                Not (repaired.family L =
                  boxedTorusFullReachComplementTopoLossData L) /\
                Not (repaired.family L =
                  boxedTorusFullReachFlatOnlyComplementTopoLossData L) /\
                Not (repaired.family L =
                  boxedTorusAllOpenComplementTopoLossData L) /\
                Not (repaired.family L =
                  boxedTorusAllOpenGiantTopoLossData L) /\
                Not (repaired.family L =
                  boxedTorusAllOpenPositiveTopoLossData L)
  random_supercritical_z2_bridge_to_full_paper_closing_route_output_bundle :
    forall _bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      let GiantLossOutput : Prop :=
        (Exists fun repaired : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
            repaired);
      let CombinedSupportOutput : Prop :=
        (Exists fun repaired : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          Exists fun c : Real =>
            0 < c /\ c <= 1 /\
              Exists fun L0 : Nat =>
                forall L : Nat, L0 <= L ->
                  c <=
                    expectedTopoLossOnData (repaired.family L)
                      (boxedTorusFlatGraphN L) repaired.supercriticalProbability /\
                  c <=
                    expectedTopoLossOnGiantOn (repaired.family L)
                      (boxedTorusFlatGraphN L) repaired.supercriticalProbability /\
                  c <=
                    percRestrictedExpectation
                      (1 - repaired.supercriticalProbability)
                      ((repaired.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L))
                      (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                        (1 : Real)) /\
                  Exists fun omega :
                      BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    Membership.mem
                      ((repaired.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L)) omega /\
                    0 <
                      (repaired.family L).topoLossKernel
                        (boxedTorusFlatGraphN L) omega);
      let SupportedNonDiagnosticOutput : Prop :=
        (Exists fun repaired : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          Exists fun c : Real =>
            0 < c /\ c <= 1 /\
              forall L0 : Nat,
                Exists fun L : Nat =>
                  L0 <= L /\
                  c <=
                    expectedTopoLossOnData (repaired.family L)
                      (boxedTorusFlatGraphN L) repaired.supercriticalProbability /\
                  c <=
                    expectedTopoLossOnGiantOn (repaired.family L)
                      (boxedTorusFlatGraphN L) repaired.supercriticalProbability /\
                  c <=
                    percRestrictedExpectation
                      (1 - repaired.supercriticalProbability)
                      ((repaired.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L))
                      (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                        (1 : Real)) /\
                  (Exists fun omega :
                      BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    Membership.mem
                      ((repaired.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L)) omega /\
                    0 <
                      (repaired.family L).topoLossKernel
                        (boxedTorusFlatGraphN L) omega) /\
                  Not (repaired.family L =
                    boxedTorusFullReachComplementTopoLossData L) /\
                  Not (repaired.family L =
                    boxedTorusFullReachFlatOnlyComplementTopoLossData L) /\
                  Not (repaired.family L =
                    boxedTorusAllOpenComplementTopoLossData L) /\
                  Not (repaired.family L =
                    boxedTorusAllOpenGiantTopoLossData L) /\
                  Not (repaired.family L =
                    boxedTorusAllOpenPositiveTopoLossData L));
      GiantLossOutput /\ CombinedSupportOutput /\
        SupportedNonDiagnosticOutput
  random_supercritical_z2_bridge_to_full_paper_closing_route_full_output_bundle :
    forall _bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      let PaperSupportOutput : Prop :=
        (Exists fun repaired : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          RandomSupercriticalZ2TopoClusterRepairedBridgePaperSupport repaired);
      let GiantLossOutput : Prop :=
        (Exists fun repaired : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          RandomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing
            repaired);
      let CombinedSupportOutput : Prop :=
        (Exists fun repaired : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          Exists fun c : Real =>
            0 < c /\ c <= 1 /\
              Exists fun L0 : Nat =>
                forall L : Nat, L0 <= L ->
                  c <=
                    expectedTopoLossOnData (repaired.family L)
                      (boxedTorusFlatGraphN L) repaired.supercriticalProbability /\
                  c <=
                    expectedTopoLossOnGiantOn (repaired.family L)
                      (boxedTorusFlatGraphN L) repaired.supercriticalProbability /\
                  c <=
                    percRestrictedExpectation
                      (1 - repaired.supercriticalProbability)
                      ((repaired.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L))
                      (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                        (1 : Real)) /\
                  Exists fun omega :
                      BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    Membership.mem
                      ((repaired.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L)) omega /\
                    0 <
                      (repaired.family L).topoLossKernel
                        (boxedTorusFlatGraphN L) omega);
      let SupportedNonDiagnosticOutput : Prop :=
        (Exists fun repaired : RandomSupercriticalZ2TopoClusterRepairedBridgeData =>
          Exists fun c : Real =>
            0 < c /\ c <= 1 /\
              forall L0 : Nat,
                Exists fun L : Nat =>
                  L0 <= L /\
                  c <=
                    expectedTopoLossOnData (repaired.family L)
                      (boxedTorusFlatGraphN L) repaired.supercriticalProbability /\
                  c <=
                    expectedTopoLossOnGiantOn (repaired.family L)
                      (boxedTorusFlatGraphN L) repaired.supercriticalProbability /\
                  c <=
                    percRestrictedExpectation
                      (1 - repaired.supercriticalProbability)
                      ((repaired.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L))
                      (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                        (1 : Real)) /\
                  (Exists fun omega :
                      BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    Membership.mem
                      ((repaired.family L).giantComponentEvent
                        (boxedTorusFlatGraphN L)) omega /\
                    0 <
                      (repaired.family L).topoLossKernel
                        (boxedTorusFlatGraphN L) omega) /\
                  Not (repaired.family L =
                    boxedTorusFullReachComplementTopoLossData L) /\
                  Not (repaired.family L =
                    boxedTorusFullReachFlatOnlyComplementTopoLossData L) /\
                  Not (repaired.family L =
                    boxedTorusAllOpenComplementTopoLossData L) /\
                  Not (repaired.family L =
                    boxedTorusAllOpenGiantTopoLossData L) /\
                  Not (repaired.family L =
                    boxedTorusAllOpenPositiveTopoLossData L));
      PaperSupportOutput /\ GiantLossOutput /\ CombinedSupportOutput /\
        SupportedNonDiagnosticOutput
  random_supercritical_z2_repaired_bridge_current_flat_lower_bound :
    Exists fun c : Real =>
      0 < c /\ c <= 1 /\
        Exists fun L0 : Nat =>
          forall L : Nat, L0 <= L ->
            c <=
              expectedTopoLossOnData (firstEdgeOpenGiantClosedTopoLossFamily L)
                (boxedTorusFlatGraphN L) ((3 : Real) / 4)
  random_supercritical_z2_repaired_bridge_current_giant_event_mass_lower_bound :
    Exists fun c : Real =>
      0 < c /\ c <= 1 /\
        Exists fun L0 : Nat =>
          forall L : Nat, L0 <= L ->
            c <=
              percRestrictedExpectation (1 - ((3 : Real) / 4))
                ((firstEdgeOpenGiantClosedTopoLossFamily L).giantComponentEvent
                  (boxedTorusFlatGraphN L))
                (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                  (1 : Real))
  random_supercritical_z2_repaired_bridge_current_paper_support :
    RandomSupercriticalZ2TopoClusterRepairedBridgePaperSupport
      firstEdgeOpenGiantClosedTopoLossRepairedBridge_current
  random_supercritical_z2_repaired_bridge_current_compatibility_certificate :
    FirstEdgeOpenGiantClosedTopoLossRepairedBridgeCurrentCompatibilityCertificate
  random_supercritical_z2_bridge_current_contract_forgets_to_repaired :
    RandomSupercriticalZ2TopoClusterBridgeData →
      RandomSupercriticalZ2TopoClusterRepairedBridgeData
  random_supercritical_z2_bridge_probability_domain :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      harrisKestenCriticalProb < bridge.supercriticalProbability ∧
        0 ≤ bridge.supercriticalProbability ∧
          bridge.supercriticalProbability ≤ 1
  random_supercritical_z2_bridge_strict_probability_domain :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      harrisKestenCriticalProb < bridge.supercriticalProbability ∧
        0 ≤ bridge.supercriticalProbability ∧
          bridge.supercriticalProbability < 1
  random_supercritical_z2_bridge_topoLossKernel_mem_unitInterval :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∀ L : ℕ,
        ∀ n : ℕ,
          ∀ omega : BondConfig (EdgeIdx n),
            0 ≤ (bridge.family L).topoLossKernel n omega ∧
              (bridge.family L).topoLossKernel n omega ≤ 1
  random_supercritical_z2_bridge_named_lower_bound :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
          c ≤
            expectedTopoLossOnData (bridge.family L)
              (boxedTorusFlatGraphN L) bridge.supercriticalProbability
  random_supercritical_z2_bridge_giant_lower_bound :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
          c ≤
            expectedTopoLossOnGiantOn (bridge.family L)
              (boxedTorusFlatGraphN L) bridge.supercriticalProbability
  random_supercritical_z2_bridge_giant_event_mass_lower_bound :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
          c ≤
            percRestrictedExpectation (1 - bridge.supercriticalProbability)
              ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
              (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                (1 : Real))
  random_supercritical_z2_bridge_positive_flat_loss_witness :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ L : ℕ,
        0 <
          expectedTopoLossOnData (bridge.family L)
            (boxedTorusFlatGraphN L) bridge.supercriticalProbability
  random_supercritical_z2_bridge_eventually_positive_flat_loss :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
        0 <
          expectedTopoLossOnData (bridge.family L)
            (boxedTorusFlatGraphN L) bridge.supercriticalProbability
  random_supercritical_z2_bridge_eventually_positive_giant_loss :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
        0 <
          expectedTopoLossOnGiantOn (bridge.family L)
            (boxedTorusFlatGraphN L) bridge.supercriticalProbability
  random_supercritical_z2_bridge_eventually_positive_giant_event_mass :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
        0 <
          percRestrictedExpectation (1 - bridge.supercriticalProbability)
            ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
            (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
              (1 : Real))
  random_supercritical_z2_bridge_positive_loss_realisation_witness :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ L : ℕ, ∃ ω : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
        0 < (bridge.family L).topoLossKernel (boxedTorusFlatGraphN L) ω
  random_supercritical_z2_bridge_eventually_positive_loss_realisation_witness :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
        ∃ ω : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
          0 < (bridge.family L).topoLossKernel (boxedTorusFlatGraphN L) ω
  random_supercritical_z2_bridge_eventually_positive_giant_loss_realisation_witness :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
        ∃ ω : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
          Membership.mem
              ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
              ω ∧
            0 < (bridge.family L).topoLossKernel (boxedTorusFlatGraphN L) ω
  random_supercritical_z2_bridge_eventually_uniform_lower_bound_and_loss_realisation :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
          c ≤
            expectedTopoLossOnData (bridge.family L)
              (boxedTorusFlatGraphN L) bridge.supercriticalProbability ∧
          ∃ ω : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
            0 < (bridge.family L).topoLossKernel (boxedTorusFlatGraphN L) ω
  random_supercritical_z2_bridge_eventually_uniform_giant_lower_bound_and_loss_realisation :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
          c ≤
            expectedTopoLossOnGiantOn (bridge.family L)
              (boxedTorusFlatGraphN L) bridge.supercriticalProbability ∧
          ∃ ω : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
            Membership.mem
                ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
                ω ∧
              0 < (bridge.family L).topoLossKernel (boxedTorusFlatGraphN L) ω
  random_supercritical_z2_bridge_eventually_uniform_flat_giant_lower_bound_and_loss_realisation :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
          c ≤
            expectedTopoLossOnData (bridge.family L)
              (boxedTorusFlatGraphN L) bridge.supercriticalProbability ∧
          c ≤
            expectedTopoLossOnGiantOn (bridge.family L)
              (boxedTorusFlatGraphN L) bridge.supercriticalProbability ∧
          ∃ ω : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
            Membership.mem
                ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
                ω ∧
              0 < (bridge.family L).topoLossKernel (boxedTorusFlatGraphN L) ω
  random_supercritical_z2_bridge_eventually_uniform_flat_giant_event_mass_lower_bound_and_loss_realisation :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∃ L0 : ℕ, ∀ L : ℕ, L0 ≤ L →
          c ≤
            expectedTopoLossOnData (bridge.family L)
              (boxedTorusFlatGraphN L) bridge.supercriticalProbability ∧
          c ≤
            expectedTopoLossOnGiantOn (bridge.family L)
              (boxedTorusFlatGraphN L) bridge.supercriticalProbability ∧
          c ≤
            percRestrictedExpectation (1 - bridge.supercriticalProbability)
              ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
              (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                (1 : Real)) ∧
          ∃ ω : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
            Membership.mem
                ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
                ω ∧
              0 < (bridge.family L).topoLossKernel (boxedTorusFlatGraphN L) ω
  random_supercritical_z2_bridge_eventually_uniform_supported_extended_non_diagnostic_member :
    ∀ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ c : ℝ, 0 < c ∧ c ≤ 1 ∧
        ∀ L0 : ℕ,
          ∃ L : ℕ,
            L0 ≤ L ∧
            c ≤
              expectedTopoLossOnData (bridge.family L)
                (boxedTorusFlatGraphN L) bridge.supercriticalProbability ∧
            c ≤
              expectedTopoLossOnGiantOn (bridge.family L)
                (boxedTorusFlatGraphN L) bridge.supercriticalProbability ∧
            c ≤
              percRestrictedExpectation (1 - bridge.supercriticalProbability)
                ((bridge.family L).giantComponentEvent (boxedTorusFlatGraphN L))
                (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                  (1 : Real)) ∧
            (∃ ω : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)),
              Membership.mem
                  ((bridge.family L).giantComponentEvent
                    (boxedTorusFlatGraphN L)) ω ∧
                0 <
                  (bridge.family L).topoLossKernel
                    (boxedTorusFlatGraphN L) ω) ∧
            bridge.family L ≠ boxedTorusFullReachComplementTopoLossData L ∧
            bridge.family L ≠ boxedTorusFullReachFlatOnlyComplementTopoLossData L ∧
            bridge.family L ≠ boxedTorusAllOpenComplementTopoLossData L ∧
            bridge.family L ≠ boxedTorusAllOpenGiantTopoLossData L ∧
            bridge.family L ≠ boxedTorusAllOpenPositiveTopoLossData L
  random_supercritical_z2_bridge_paper_support_certificate :
    forall bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      bridge.graph = SimpleGraph.Z2LatticeGraph /\
      (forall L : Nat,
        boxedTorusFlatGraphN L + 1 = Fintype.card (BoxedTorusVertex L)) /\
      (forall L : Nat,
        Fintype.card (BoxedTorusEdgeIdx L) =
          2 * (boxedTorusFlatGraphN L + 1)) /\
      harrisKestenCriticalProb < bridge.supercriticalProbability /\
      0 <= bridge.supercriticalProbability /\
      bridge.supercriticalProbability <= 1 /\
      bridge.supercriticalProbability < 1 /\
      (forall L : Nat,
        forall n : Nat,
          forall omega : BondConfig (EdgeIdx n),
            0 <= (bridge.family L).topoLossKernel n omega /\
              (bridge.family L).topoLossKernel n omega <= 1) /\
      (Exists fun c : Real =>
        0 < c /\ c <= 1 /\
          Exists fun L0 : Nat =>
            forall L : Nat, L0 <= L ->
              c <=
                expectedTopoLossOnData (bridge.family L)
                  (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
              c <=
                expectedTopoLossOnGiantOn (bridge.family L)
                  (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
              c <=
                percRestrictedExpectation (1 - bridge.supercriticalProbability)
                  ((bridge.family L).giantComponentEvent
                    (boxedTorusFlatGraphN L))
                  (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    (1 : Real)) /\
              Exists fun omega :
                  BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                Membership.mem
                    ((bridge.family L).giantComponentEvent
                      (boxedTorusFlatGraphN L)) omega /\
                  0 <
                    (bridge.family L).topoLossKernel
                      (boxedTorusFlatGraphN L) omega) /\
      Not (forall L : Nat,
        bridge.family L = boxedTorusFullReachComplementTopoLossData L) /\
      Not (forall L : Nat,
        bridge.family L = boxedTorusFullReachFlatOnlyComplementTopoLossData L) /\
      Not (forall L : Nat,
        bridge.family L = boxedTorusAllOpenComplementTopoLossData L) /\
      Not (forall L : Nat,
        bridge.family L = boxedTorusAllOpenGiantTopoLossData L) /\
      Not (forall L : Nat,
        bridge.family L = boxedTorusAllOpenPositiveTopoLossData L) /\
      Not (forall L : Nat,
        bridge.family L = boxedTorusFullReachComplementTopoLossData L \/
          bridge.family L = boxedTorusFullReachFlatOnlyComplementTopoLossData L \/
          bridge.family L = boxedTorusAllOpenComplementTopoLossData L) /\
      Not (Exists fun L0 : Nat =>
        forall L : Nat, L0 <= L ->
          bridge.family L = boxedTorusFullReachComplementTopoLossData L \/
            bridge.family L = boxedTorusFullReachFlatOnlyComplementTopoLossData L \/
            bridge.family L = boxedTorusAllOpenComplementTopoLossData L) /\
      Not (Exists fun L0 : Nat =>
        forall L : Nat, L0 <= L ->
          bridge.family L = boxedTorusFullReachComplementTopoLossData L \/
            bridge.family L = boxedTorusFullReachFlatOnlyComplementTopoLossData L \/
            bridge.family L = boxedTorusAllOpenComplementTopoLossData L \/
            bridge.family L = boxedTorusAllOpenGiantTopoLossData L \/
            bridge.family L = boxedTorusAllOpenPositiveTopoLossData L) /\
      (forall L0 : Nat,
        Exists fun L : Nat =>
          L0 <= L /\
          bridge.family L ≠ boxedTorusFullReachComplementTopoLossData L /\
          bridge.family L ≠ boxedTorusFullReachFlatOnlyComplementTopoLossData L /\
          bridge.family L ≠ boxedTorusAllOpenComplementTopoLossData L /\
          bridge.family L ≠ boxedTorusAllOpenGiantTopoLossData L /\
          bridge.family L ≠ boxedTorusAllOpenPositiveTopoLossData L) /\
      Exists fun c : Real =>
        0 < c /\ c <= 1 /\
          forall L0 : Nat,
            Exists fun L : Nat =>
              L0 <= L /\
              c <=
                expectedTopoLossOnData (bridge.family L)
                  (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
              c <=
                expectedTopoLossOnGiantOn (bridge.family L)
                  (boxedTorusFlatGraphN L) bridge.supercriticalProbability /\
              c <=
                percRestrictedExpectation (1 - bridge.supercriticalProbability)
                  ((bridge.family L).giantComponentEvent
                    (boxedTorusFlatGraphN L))
                  (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                    (1 : Real)) /\
              (Exists fun omega :
                  BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) =>
                Membership.mem
                    ((bridge.family L).giantComponentEvent
                      (boxedTorusFlatGraphN L)) omega /\
                  0 <
                    (bridge.family L).topoLossKernel
                      (boxedTorusFlatGraphN L) omega) /\
              bridge.family L ≠ boxedTorusFullReachComplementTopoLossData L /\
              bridge.family L ≠
                boxedTorusFullReachFlatOnlyComplementTopoLossData L /\
              bridge.family L ≠ boxedTorusAllOpenComplementTopoLossData L /\
              bridge.family L ≠ boxedTorusAllOpenGiantTopoLossData L /\
              bridge.family L ≠ boxedTorusAllOpenPositiveTopoLossData L
  random_supercritical_z2_bridge_contract_current_obstruction :
    Not (Nonempty RandomSupercriticalZ2TopoClusterBridgeData)
  random_supercritical_z2_current_frontier_certificate :
    RandomSupercriticalZ2TopoClusterCurrentFrontierCertificate
  random_supercritical_z2_current_frontier_full_support_envelope_obstruction :
    RandomSupercriticalZ2TopoClusterFullSupportEnvelopeObstructionCertificate
  random_supercritical_z2_current_frontier_support_surface_repair_certificate :
    RandomSupercriticalZ2TopoClusterSupportSurfaceRepairCertificate
  random_supercritical_z2_current_frontier_support_surface_repair_route :
    RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute
  random_supercritical_z2_current_frontier_support_surface_repair_route_output_certificate :
    RandomSupercriticalZ2TopoClusterSupportSurfaceRepairRouteOutputCertificate
  random_supercritical_z2_current_frontier_support_surface_repair_nonclosure_certificate :
    RandomSupercriticalZ2TopoClusterSupportSurfaceRepairNonClosureCertificate
  random_supercritical_z2_current_frontier_support_surface_closing_route_certificate :
    RandomSupercriticalZ2TopoClusterSupportSurfaceClosingRouteCertificate
  random_supercritical_z2_current_frontier_support_surface_closing_route_iff_full_support :
    ∀ bridge : RandomSupercriticalZ2TopoClusterRepairedBridgeData,
      RandomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceClosingRoute
        bridge ↔
        RandomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport
          bridge
  random_supercritical_z2_bridge_not_full_reach_diagnostic :
    ¬ (∃ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∀ L : Nat, bridge.family L =
        boxedTorusFullReachComplementTopoLossData L)
  random_supercritical_z2_bridge_not_flat_only_diagnostic :
    ¬ (∃ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∀ L : Nat, bridge.family L =
        boxedTorusFullReachFlatOnlyComplementTopoLossData L)
  random_supercritical_z2_bridge_not_all_open_complement_diagnostic :
    ¬ (∃ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∀ L : Nat, bridge.family L =
        boxedTorusAllOpenComplementTopoLossData L)
  random_supercritical_z2_bridge_not_all_open_giant_diagnostic :
    ¬ (∃ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∀ L : Nat, bridge.family L =
        boxedTorusAllOpenGiantTopoLossData L)
  random_supercritical_z2_bridge_not_all_open_positive_diagnostic :
    ¬ (∃ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∀ L : Nat, bridge.family L =
        boxedTorusAllOpenPositiveTopoLossData L)
  random_supercritical_z2_bridge_not_pointwise_diagnostic_combo :
    ¬ (∃ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∀ L : Nat,
        bridge.family L = boxedTorusFullReachComplementTopoLossData L ∨
        bridge.family L = boxedTorusFullReachFlatOnlyComplementTopoLossData L ∨
        bridge.family L = boxedTorusAllOpenComplementTopoLossData L)
  random_supercritical_z2_bridge_not_eventually_pointwise_diagnostic_combo :
    ¬ (∃ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ L0 : Nat, ∀ L : Nat, L0 ≤ L →
        bridge.family L = boxedTorusFullReachComplementTopoLossData L ∨
        bridge.family L = boxedTorusFullReachFlatOnlyComplementTopoLossData L ∨
        bridge.family L = boxedTorusAllOpenComplementTopoLossData L)
  random_supercritical_z2_bridge_not_eventually_pointwise_extended_diagnostic_combo :
    ¬ (∃ bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      ∃ L0 : Nat, ∀ L : Nat, L0 ≤ L →
        bridge.family L = boxedTorusFullReachComplementTopoLossData L ∨
        bridge.family L = boxedTorusFullReachFlatOnlyComplementTopoLossData L ∨
        bridge.family L = boxedTorusAllOpenComplementTopoLossData L ∨
        bridge.family L = boxedTorusAllOpenGiantTopoLossData L ∨
        bridge.family L = boxedTorusAllOpenPositiveTopoLossData L)
  random_supercritical_z2_bridge_exists_non_diagnostic_member :
    forall bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      Exists fun L : Nat =>
        bridge.family L ≠ boxedTorusFullReachComplementTopoLossData L /\
        bridge.family L ≠ boxedTorusFullReachFlatOnlyComplementTopoLossData L /\
        bridge.family L ≠ boxedTorusAllOpenComplementTopoLossData L
  random_supercritical_z2_bridge_arbitrarily_large_non_diagnostic_member :
    forall bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      forall L0 : Nat,
        Exists fun L : Nat =>
          L0 <= L /\
          bridge.family L ≠ boxedTorusFullReachComplementTopoLossData L /\
          bridge.family L ≠ boxedTorusFullReachFlatOnlyComplementTopoLossData L /\
          bridge.family L ≠ boxedTorusAllOpenComplementTopoLossData L
  random_supercritical_z2_bridge_arbitrarily_large_extended_non_diagnostic_member :
    forall bridge : RandomSupercriticalZ2TopoClusterBridgeData,
      forall L0 : Nat,
        Exists fun L : Nat =>
          L0 <= L /\
          bridge.family L ≠ boxedTorusFullReachComplementTopoLossData L /\
          bridge.family L ≠ boxedTorusFullReachFlatOnlyComplementTopoLossData L /\
          bridge.family L ≠ boxedTorusAllOpenComplementTopoLossData L /\
          bridge.family L ≠ boxedTorusAllOpenGiantTopoLossData L /\
          bridge.family L ≠ boxedTorusAllOpenPositiveTopoLossData L
  boxed_torus_z2_bridge_current :
    Z2TopoClusterBridgeData
  boxed_torus_z2_bridge_family_is_flat_only :
    boxed_torus_z2_bridge_current.family =
      boxedTorusFullReachFlatOnlyComplementTopoLossData
  boxed_torus_z2_bridge_core_current :
    BoxedTorusFlatFamilyCoreConclusion
      boxed_torus_z2_bridge_current.family
  boxed_torus_z2_bridge_lower_bound_current :
    BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion
      boxed_torus_z2_bridge_current.family
  boxed_torus_z2_bridge_not_all_n_lower_bound :
    forall L : Nat,
      Not (UnitCompatibleAboveThresholdLowerBoundConclusion
        (boxed_torus_z2_bridge_current.family L))
  boxed_torus_full_reach_z2_bridge_current :
    Z2TopoClusterBridgeData
  boxed_torus_full_reach_z2_bridge_family :
    boxed_torus_full_reach_z2_bridge_current.family =
      boxedTorusFullReachComplementTopoLossData
  boxed_torus_full_reach_z2_bridge_core_current :
    BoxedTorusFlatFamilyCoreConclusion
      boxed_torus_full_reach_z2_bridge_current.family
  boxed_torus_full_reach_z2_bridge_lower_bound_current :
    BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion
      boxed_torus_full_reach_z2_bridge_current.family
  boxed_torus_full_reach_z2_bridge_unit_compatible :
    forall L : Nat,
      UnitCompatibleAboveThresholdLowerBoundConclusion
        (boxed_torus_full_reach_z2_bridge_current.family L)
  boxed_torus_full_reach_not_flat_only_diagnostic :
    ¬
      ((∀ L n : Nat, ∀ p : Real, n ≠ boxedTorusFlatGraphN L →
        expectedTopoLossOnData
          (boxedTorusFullReachComplementTopoLossData L) n p = 0) ∧
      (∀ L n : Nat, ∀ p : Real,
        expectedTopoLossOnGiantOn
          (boxedTorusFullReachComplementTopoLossData L) n p = 0))
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
  boxed_torus_flat_only_giant_loss_zero_current :
    ∀ L n : ℕ, ∀ p : ℝ,
      expectedTopoLossOnGiantOn
        (boxedTorusFullReachFlatOnlyComplementTopoLossData L) n p = 0
  boxed_torus_flat_only_flat_loss_failure_mass_current :
    ∀ L : ℕ, ∀ p : ℝ,
      expectedTopoLossOnData
        (boxedTorusFullReachFlatOnlyComplementTopoLossData L)
        (boxedTorusFlatGraphN L) p =
      ((1 : ℝ) / 2) *
        percRestrictedExpectation (1 - p)
          (boxedTorusFullReachFailureEvent L)
          (fun _ : BondConfig (EdgeIdx (boxedTorusFlatGraphN L)) => (1 : ℝ))
  boxed_torus_all_open_giant_full_cluster :
    ∀ L : ℕ,
      GiantComponentEventFullClusterConclusion
        (boxedTorusAllOpenGiantTopoLossData L)
  boxed_torus_all_open_giant_envelope :
    ∀ L : ℕ,
      ExpectedTopoLossOnGiantEnvelopeConclusion
        (boxedTorusAllOpenGiantTopoLossData L)
  boxed_torus_all_open_positive_giant_flat_pos :
    ∀ L : ℕ, ∀ p : ℝ, p < 1 →
      0 <
        expectedTopoLossOnGiantOn
          (boxedTorusAllOpenPositiveTopoLossData L)
          (boxedTorusFlatGraphN L) p
  boxed_torus_all_open_complement_flat_lower_bound :
    BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion
      boxedTorusAllOpenComplementTopoLossData
  boxed_torus_all_open_complement_unit_compatible :
    ∀ L : ℕ,
      UnitCompatibleAboveThresholdLowerBoundConclusion
        (boxedTorusAllOpenComplementTopoLossData L)
  boxed_torus_all_open_complement_giant_full_cluster :
    ∀ L : ℕ,
      GiantComponentEventFullClusterConclusion
        (boxedTorusAllOpenComplementTopoLossData L)
  boxed_torus_all_open_complement_giant_envelope :
    ∀ L : ℕ,
      ExpectedTopoLossOnGiantEnvelopeConclusion
        (boxedTorusAllOpenComplementTopoLossData L)
  boxed_torus_all_open_complement_flat_loss_ge_eighth :
    ∀ L : ℕ,
      (1 : ℝ) / 8 ≤
        expectedTopoLossOnData
          (boxedTorusAllOpenComplementTopoLossData L)
          (boxedTorusFlatGraphN L) ((3 : ℝ) / 4)
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
the current theorem surface.  The semantic target remains open until the
explicit `RandomSupercriticalZ2TopoClusterRepairedBridgeData` contract is instantiated
by a genuine random supercritical finite `Z2_L` theorem carrying a named
`p_c < p < 1` parameter, a family-level unit-interval topological-loss range
theorem, flat and giant-event-mass lower-bound theorems at
that same parameter, a single eventual constant and threshold supporting both
lower bounds, a single certificate tying those facts to the standard
`Z²` graph, finite boxed-torus indexing, the loss range, and the named
strict non-endpoint `p_c < p < 1`
domain, explicit giant-event members, and a same-index certificate combining
the flat lower bound, giant-event mass, giant-event membership, and pointwise
positive loss realisation,
not by the first-edge Bernoulli compatibility witness,
not by the boxed-torus base-edge reachability calibration of that witness,
not by a pointwise or eventual-tail selection among the current diagnostic
families and not by the finite all-open/full-reach/
flat-sequence diagnostic carriers or by the current full-reach
failure-complement support mechanism. -/
noncomputable def topo_cluster_random_supercritical_z2_frontier_payload :
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
  random_supercritical_z2_bridge_to_z2_bridge :=
    Z2TopoClusterBridgeData_from_random_supercritical_z2_topo_cluster_bridge
  random_supercritical_z2_bridge_core :=
    BoxedTorusFlatFamilyCoreConclusion_from_random_supercritical_z2_topo_cluster_bridge
  random_supercritical_z2_bridge_lower_bound :=
    BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_from_random_supercritical_z2_topo_cluster_bridge
  random_supercritical_z2_repaired_bridge_to_z2_bridge :=
    Z2TopoClusterBridgeData_from_random_supercritical_z2_topo_cluster_repaired_bridge
  random_supercritical_z2_repaired_bridge_core :=
    BoxedTorusFlatFamilyCoreConclusion_from_random_supercritical_z2_topo_cluster_repaired_bridge
  random_supercritical_z2_repaired_bridge_lower_bound :=
    BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_from_random_supercritical_z2_topo_cluster_repaired_bridge
  random_supercritical_z2_repaired_bridge_probability_domain :=
    randomSupercriticalZ2TopoClusterRepairedBridgeData_supercriticalProbability_domain
  random_supercritical_z2_repaired_bridge_strict_probability_domain :=
    randomSupercriticalZ2TopoClusterRepairedBridgeData_supercriticalProbability_strict_domain
  random_supercritical_z2_repaired_bridge_topoLossKernel_mem_unitInterval :=
    randomSupercriticalZ2TopoClusterRepairedBridgeData_family_topoLossKernel_mem_unitInterval
  random_supercritical_z2_repaired_bridge_named_flat_lower_bound :=
    randomSupercriticalZ2TopoClusterRepairedBridgeData_supercritical_flat_lower_bound
  random_supercritical_z2_repaired_bridge_giant_event_mass_lower_bound :=
    randomSupercriticalZ2TopoClusterRepairedBridgeData_supercritical_giant_event_mass_lower_bound
  random_supercritical_z2_repaired_bridge_eventually_uniform_flat_event_mass_lower_bound_and_loss_realisation :=
    randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_flat_event_mass_lower_bound_and_loss_realisation
  random_supercritical_z2_repaired_bridge_eventually_giant_event_member :=
    randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_giant_event_member
  random_supercritical_z2_repaired_bridge_eventually_uniform_flat_event_mass_member_and_loss_realisation :=
    randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_flat_event_mass_member_and_loss_realisation
  random_supercritical_z2_repaired_bridge_eventually_uniform_supported_extended_non_diagnostic_member :=
    randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_supported_extended_non_diagnostic_member
  random_supercritical_z2_repaired_bridge_eventually_uniform_supported_extended_non_diagnostic_member_with_giant_member :=
    randomSupercriticalZ2TopoClusterRepairedBridgeData_eventually_uniform_supported_extended_non_diagnostic_member_with_giant_member
  random_supercritical_z2_repaired_bridge_paper_support :=
    randomSupercriticalZ2TopoClusterRepairedBridgeData_paper_support
  random_supercritical_z2_repaired_bridge_support_surface_repair :=
    randomSupercriticalZ2TopoClusterRepairedBridge_support_surface_repair
  random_supercritical_z2_support_surface_repair_route :=
    randomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute_current
  random_supercritical_z2_support_surface_repair_certificate :=
    random_supercritical_z2_topo_cluster_support_surface_repair_certificate
  random_supercritical_z2_support_surface_repair_route_output_certificate :=
    random_supercritical_z2_topo_cluster_support_surface_repair_route_output_certificate
  random_supercritical_z2_support_surface_repair_nonclosure_certificate :=
    random_supercritical_z2_topo_cluster_support_surface_repair_nonclosure_certificate
  random_supercritical_z2_support_surface_closing_route_certificate :=
    random_supercritical_z2_topo_cluster_support_surface_closing_route_certificate
  random_supercritical_z2_support_surface_closing_route_iff_full_support :=
    randomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceClosingRoute_iff_full_paper_closing_support
  random_supercritical_z2_repaired_bridge_diagnostic_obstruction_certificate :=
    random_supercritical_z2_topo_cluster_repaired_bridge_diagnostic_obstruction_certificate
  first_edge_giant_stochastic_positive_regression :=
    firstEdgeGiantStochasticTopoLossData_positive_regression_certificate
  first_edge_giant_stochastic_not_random_supercritical_z2_bridge :=
    firstEdgeGiantStochasticTopoLossData_not_random_supercritical_z2_bridge_certificate
  boxed_torus_full_reach_flat_only_lower_bound_cutset_route :=
    boxedTorusFullReachFlatOnlyLowerBound_cutset_route_certificate
  random_supercritical_z2_repaired_bridge_current_witness :=
    exists_firstEdgeOpenGiantClosedTopoLossRepairedBridge_current
  random_supercritical_z2_repaired_bridge_current_family := rfl
  random_supercritical_z2_repaired_bridge_current_base_horizontal_edge_slot :=
    boxedTorusFlattenBaseHorizontalEdge_eq_firstEdgeIdx
  random_supercritical_z2_repaired_bridge_current_giant_event_base_horizontal_edge :=
    firstEdgeOpenGiantClosedTopoLossFamily_giant_event_boxedTorusBaseHorizontal_mem_iff
  random_supercritical_z2_repaired_bridge_current_giant_event_reaches_base_horizontal_target :=
    firstEdgeOpenGiantClosedTopoLossFamily_giant_event_baseHorizontalTarget_reachable
  random_supercritical_z2_repaired_bridge_current_topoLossKernel_zero_on_giant_event :=
    firstEdgeOpenGiantClosedTopoLossFamily_topoLossKernel_zero_on_giant
  random_supercritical_z2_repaired_bridge_current_expectedTopoLossOnGiantOn_eq_zero :=
    firstEdgeOpenGiantClosedTopoLossFamily_expectedTopoLossOnGiantOn_boxedTorus_eq_zero
  random_supercritical_z2_repaired_bridge_current_support_surface_repair :=
    firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_support_surface_repair
  random_supercritical_z2_repaired_bridge_current_not_positive_giant_loss_lower_bound :=
    firstEdgeOpenGiantClosedTopoLossFamily_not_positive_giant_loss_lower_bound_at_three_quarters
  random_supercritical_z2_bridge_to_repaired_giant_loss_paper_closing :=
    randomSupercriticalZ2TopoClusterBridgeData_repaired_giant_loss_paper_closing
  random_supercritical_z2_repaired_bridge_current_not_giant_loss_paper_closing :=
    firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_giant_loss_paper_closing
  random_supercritical_z2_bridge_to_repaired_full_paper_closing_support :=
    randomSupercriticalZ2TopoClusterBridgeData_repaired_full_paper_closing_support
  random_supercritical_z2_repaired_bridge_current_not_full_paper_closing_support :=
    firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_full_paper_closing_support
  random_supercritical_z2_repaired_bridge_first_edge_three_quarters_not_giant_loss_paper_closing :=
    not_randomSupercriticalZ2TopoClusterRepairedBridge_firstEdge_three_quarters_giant_loss_paper_closing
  random_supercritical_z2_full_paper_closing_route_first_edge_three_quarters_giant_loss_output_obstruction :=
    not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_giant_loss_output
  random_supercritical_z2_full_paper_closing_route_first_edge_three_quarters_combined_support_output_obstruction :=
    not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_combined_support_output
  random_supercritical_z2_full_paper_closing_route_first_edge_three_quarters_supported_extended_non_diagnostic_output_obstruction :=
    not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_supported_extended_non_diagnostic_output
  random_supercritical_z2_full_paper_closing_route_first_edge_three_quarters_output_bundle_obstruction :=
    not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_output_bundle
  random_supercritical_z2_full_paper_closing_route_first_edge_three_quarters_full_output_bundle_obstruction :=
    not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_full_output_bundle
  random_supercritical_z2_repaired_bridge_first_edge_three_quarters_not_full_paper_closing_support :=
    not_randomSupercriticalZ2TopoClusterRepairedBridge_firstEdge_three_quarters_full_paper_closing_support
  random_supercritical_z2_repaired_bridge_giant_pointwise_loss_route_to_giant_loss :=
    randomSupercriticalZ2TopoClusterRepairedBridgeGiantLossPaperClosing_of_giant_pointwise_loss_route
  random_supercritical_z2_repaired_bridge_giant_pointwise_loss_route_to_full_support :=
    randomSupercriticalZ2TopoClusterRepairedBridgeFullPaperClosingSupport_of_giant_pointwise_loss_route
  random_supercritical_z2_repaired_bridge_support_surface_closing_route_of_giant_pointwise_loss_route :=
    randomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceClosingRoute_of_giant_pointwise_loss_route
  random_supercritical_z2_full_paper_closing_route_of_giant_pointwise_loss_route :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_of_giant_pointwise_loss_route
  random_supercritical_z2_boxed_torus_finite_z2L_route_of_giant_pointwise_loss_route :=
    randomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute_of_giant_pointwise_loss_route
  random_supercritical_z2_repaired_bridge_current_not_giant_pointwise_loss_route :=
    firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_not_giant_pointwise_loss_route
  random_supercritical_z2_giant_pointwise_loss_route_certificate :=
    random_supercritical_z2_topo_cluster_giant_pointwise_loss_route_certificate
  random_supercritical_z2_full_paper_closing_route_output_certificate :=
    random_supercritical_z2_topo_cluster_full_paper_closing_route_output_certificate
  random_supercritical_z2_boxed_torus_finite_z2L_route_certificate :=
    random_supercritical_z2_topo_cluster_boxed_torus_finite_z2L_route_certificate
  random_supercritical_z2_semantic_kernel_target_iff_full_route :=
    topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_full_route
  random_supercritical_z2_semantic_kernel_target_iff_boxed_torus_finite_z2L_route :=
    topo_cluster_random_supercritical_z2_semantic_kernel_target_iff_boxed_torus_finite_z2L_route
  random_supercritical_z2_semantic_kernel_target_current_obstruction :=
    topo_cluster_random_supercritical_z2_semantic_kernel_target_notYet
  random_supercritical_z2_full_paper_closing_route_iff_boxed_torus_finite_z2L_route :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_iff_boxed_torus_finite_z2L_route
  random_supercritical_z2_full_support_envelope_obstruction_certificate :=
    random_supercritical_z2_topo_cluster_full_support_envelope_obstruction_certificate
  random_supercritical_z2_repaired_bridge_giant_loss_general_obstruction :=
    not_randomSupercriticalZ2TopoClusterRepairedBridge_giant_loss_paper_closing
  random_supercritical_z2_repaired_bridge_full_support_general_obstruction :=
    not_randomSupercriticalZ2TopoClusterRepairedBridge_full_paper_closing_support
  random_supercritical_z2_repaired_bridge_giant_pointwise_loss_route_general_obstruction :=
    not_randomSupercriticalZ2TopoClusterRepairedBridge_giant_pointwise_loss_route
  random_supercritical_z2_full_paper_closing_route_general_obstruction :=
    not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute
  random_supercritical_z2_boxed_torus_finite_z2L_route_general_obstruction :=
    not_randomSupercriticalZ2TopoClusterBoxedTorusFiniteZ2LClosingRoute
  random_supercritical_z2_full_paper_closing_route_first_edge_three_quarters_witness_obstruction :=
    not_randomSupercriticalZ2TopoClusterFullPaperClosingRoute_firstEdge_three_quarters_witness
  random_supercritical_z2_full_paper_closing_route_of_repaired_bridge :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_of_repaired_bridge
  random_supercritical_z2_full_paper_closing_route_repaired_bridge_nonempty :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_repaired_bridge_nonempty
  random_supercritical_z2_full_paper_closing_route_support_witness :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_witness
  random_supercritical_z2_full_paper_closing_route_paper_support_output :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_paper_support_output
  random_supercritical_z2_full_paper_closing_route_support_surface_repair_output :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_output
  random_supercritical_z2_full_paper_closing_route_support_surface_repair_route :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_route
  random_supercritical_z2_full_paper_closing_route_support_surface_repair_output_certificate :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_support_surface_repair_output_certificate
  random_supercritical_z2_full_paper_closing_route_giant_loss_output :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_giant_loss_output
  random_supercritical_z2_full_paper_closing_route_combined_support_output :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_combined_support_output
  random_supercritical_z2_full_paper_closing_route_supported_extended_non_diagnostic_output :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_supported_extended_non_diagnostic_output
  random_supercritical_z2_full_paper_closing_route_output_bundle :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_output_bundle
  random_supercritical_z2_full_paper_closing_route_full_output_bundle :=
    randomSupercriticalZ2TopoClusterFullPaperClosingRoute_full_output_bundle
  random_supercritical_z2_bridge_to_full_paper_closing_route :=
    randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route
  random_supercritical_z2_bridge_to_full_paper_closing_route_paper_support_output :=
    randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_paper_support_output
  random_supercritical_z2_bridge_to_full_paper_closing_route_giant_loss_output :=
    randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_giant_loss_output
  random_supercritical_z2_bridge_to_full_paper_closing_route_combined_support_output :=
    randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_combined_support_output
  random_supercritical_z2_bridge_to_full_paper_closing_route_supported_extended_non_diagnostic_output :=
    randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_supported_extended_non_diagnostic_output
  random_supercritical_z2_bridge_to_full_paper_closing_route_output_bundle :=
    randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_output_bundle
  random_supercritical_z2_bridge_to_full_paper_closing_route_full_output_bundle :=
    randomSupercriticalZ2TopoClusterBridgeData_full_paper_closing_route_full_output_bundle
  random_supercritical_z2_repaired_bridge_current_flat_lower_bound :=
    firstEdgeOpenGiantClosedTopoLossFamily_flat_lower_bound_at_three_quarters
  random_supercritical_z2_repaired_bridge_current_giant_event_mass_lower_bound :=
    firstEdgeOpenGiantClosedTopoLossFamily_giant_event_mass_lower_bound_at_three_quarters
  random_supercritical_z2_repaired_bridge_current_paper_support :=
    firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_paper_support
  random_supercritical_z2_repaired_bridge_current_compatibility_certificate :=
    firstEdgeOpenGiantClosedTopoLossRepairedBridge_current_compatibility_certificate
  random_supercritical_z2_bridge_current_contract_forgets_to_repaired :=
    RandomSupercriticalZ2TopoClusterRepairedBridgeData_from_current_contract
  random_supercritical_z2_bridge_probability_domain :=
    randomSupercriticalZ2TopoClusterBridgeData_supercriticalProbability_domain
  random_supercritical_z2_bridge_strict_probability_domain :=
    randomSupercriticalZ2TopoClusterBridgeData_supercriticalProbability_strict_domain
  random_supercritical_z2_bridge_topoLossKernel_mem_unitInterval :=
    randomSupercriticalZ2TopoClusterBridgeData_family_topoLossKernel_mem_unitInterval
  random_supercritical_z2_bridge_named_lower_bound :=
    randomSupercriticalZ2TopoClusterBridgeData_supercritical_flat_lower_bound
  random_supercritical_z2_bridge_giant_lower_bound :=
    randomSupercriticalZ2TopoClusterBridgeData_supercritical_giant_lower_bound
  random_supercritical_z2_bridge_giant_event_mass_lower_bound :=
    randomSupercriticalZ2TopoClusterBridgeData_supercritical_giant_event_mass_lower_bound
  random_supercritical_z2_bridge_positive_flat_loss_witness :=
    randomSupercriticalZ2TopoClusterBridgeData_positive_flat_loss_witness
  random_supercritical_z2_bridge_eventually_positive_flat_loss :=
    randomSupercriticalZ2TopoClusterBridgeData_eventually_positive_flat_loss
  random_supercritical_z2_bridge_eventually_positive_giant_loss :=
    randomSupercriticalZ2TopoClusterBridgeData_eventually_positive_giant_loss
  random_supercritical_z2_bridge_eventually_positive_giant_event_mass :=
    randomSupercriticalZ2TopoClusterBridgeData_eventually_positive_giant_event_mass
  random_supercritical_z2_bridge_positive_loss_realisation_witness :=
    randomSupercriticalZ2TopoClusterBridgeData_positive_loss_realisation_witness
  random_supercritical_z2_bridge_eventually_positive_loss_realisation_witness :=
    randomSupercriticalZ2TopoClusterBridgeData_eventually_positive_loss_realisation_witness
  random_supercritical_z2_bridge_eventually_positive_giant_loss_realisation_witness :=
    randomSupercriticalZ2TopoClusterBridgeData_eventually_positive_giant_loss_realisation_witness
  random_supercritical_z2_bridge_eventually_uniform_lower_bound_and_loss_realisation :=
    randomSupercriticalZ2TopoClusterBridgeData_eventually_uniform_lower_bound_and_loss_realisation
  random_supercritical_z2_bridge_eventually_uniform_giant_lower_bound_and_loss_realisation :=
    randomSupercriticalZ2TopoClusterBridgeData_eventually_uniform_giant_lower_bound_and_loss_realisation
  random_supercritical_z2_bridge_eventually_uniform_flat_giant_lower_bound_and_loss_realisation :=
    randomSupercriticalZ2TopoClusterBridgeData_eventually_uniform_flat_giant_lower_bound_and_loss_realisation
  random_supercritical_z2_bridge_eventually_uniform_flat_giant_event_mass_lower_bound_and_loss_realisation :=
    randomSupercriticalZ2TopoClusterBridgeData_eventually_uniform_flat_giant_event_mass_lower_bound_and_loss_realisation
  random_supercritical_z2_bridge_eventually_uniform_supported_extended_non_diagnostic_member :=
    randomSupercriticalZ2TopoClusterBridgeData_eventually_uniform_supported_extended_non_diagnostic_member
  random_supercritical_z2_bridge_paper_support_certificate :=
    randomSupercriticalZ2TopoClusterBridgeData_paper_support_certificate
  random_supercritical_z2_bridge_contract_current_obstruction :=
    not_random_supercritical_z2_topo_cluster_bridge_contract_current
  random_supercritical_z2_current_frontier_certificate :=
    random_supercritical_z2_topo_cluster_current_frontier_certificate
  random_supercritical_z2_current_frontier_full_support_envelope_obstruction :=
    random_supercritical_z2_topo_cluster_full_support_envelope_obstruction_certificate
  random_supercritical_z2_current_frontier_support_surface_repair_certificate :=
    random_supercritical_z2_topo_cluster_support_surface_repair_certificate
  random_supercritical_z2_current_frontier_support_surface_repair_route :=
    randomSupercriticalZ2TopoClusterSupportSurfaceRepairRoute_current
  random_supercritical_z2_current_frontier_support_surface_repair_route_output_certificate :=
    random_supercritical_z2_topo_cluster_support_surface_repair_route_output_certificate
  random_supercritical_z2_current_frontier_support_surface_repair_nonclosure_certificate :=
    random_supercritical_z2_topo_cluster_support_surface_repair_nonclosure_certificate
  random_supercritical_z2_current_frontier_support_surface_closing_route_certificate :=
    random_supercritical_z2_topo_cluster_support_surface_closing_route_certificate
  random_supercritical_z2_current_frontier_support_surface_closing_route_iff_full_support :=
    randomSupercriticalZ2TopoClusterRepairedBridgeSupportSurfaceClosingRoute_iff_full_paper_closing_support
  random_supercritical_z2_bridge_not_full_reach_diagnostic :=
    not_random_supercritical_z2_topo_cluster_bridge_full_reach_diagnostic
  random_supercritical_z2_bridge_not_flat_only_diagnostic :=
    not_random_supercritical_z2_topo_cluster_bridge_flat_only_diagnostic
  random_supercritical_z2_bridge_not_all_open_complement_diagnostic :=
    not_random_supercritical_z2_topo_cluster_bridge_all_open_complement_diagnostic
  random_supercritical_z2_bridge_not_all_open_giant_diagnostic :=
    not_random_supercritical_z2_topo_cluster_bridge_all_open_giant_diagnostic
  random_supercritical_z2_bridge_not_all_open_positive_diagnostic :=
    not_random_supercritical_z2_topo_cluster_bridge_all_open_positive_diagnostic
  random_supercritical_z2_bridge_not_pointwise_diagnostic_combo :=
    not_random_supercritical_z2_topo_cluster_bridge_pointwise_diagnostic_combo
  random_supercritical_z2_bridge_not_eventually_pointwise_diagnostic_combo :=
    not_random_supercritical_z2_topo_cluster_bridge_eventual_pointwise_diagnostic_combo
  random_supercritical_z2_bridge_not_eventually_pointwise_extended_diagnostic_combo :=
    not_random_supercritical_z2_topo_cluster_bridge_eventual_pointwise_extended_diagnostic_combo
  random_supercritical_z2_bridge_exists_non_diagnostic_member :=
    randomSupercriticalZ2TopoClusterBridgeData_exists_non_diagnostic_member
  random_supercritical_z2_bridge_arbitrarily_large_non_diagnostic_member :=
    randomSupercriticalZ2TopoClusterBridgeData_arbitrarily_large_non_diagnostic_member
  random_supercritical_z2_bridge_arbitrarily_large_extended_non_diagnostic_member :=
    randomSupercriticalZ2TopoClusterBridgeData_arbitrarily_large_extended_non_diagnostic_member
  boxed_torus_z2_bridge_current :=
    boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current
  boxed_torus_z2_bridge_family_is_flat_only :=
    boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current_family
  boxed_torus_z2_bridge_core_current :=
    boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current_core
  boxed_torus_z2_bridge_lower_bound_current :=
    boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current_lower_bound
  boxed_torus_z2_bridge_not_all_n_lower_bound :=
    not_UnitCompatibleAboveThresholdLowerBoundConclusion_boxedTorusFullReachFlatOnlyZ2TopoClusterBridge_current
  boxed_torus_full_reach_z2_bridge_current :=
    boxedTorusFullReachZ2TopoClusterBridge_current
  boxed_torus_full_reach_z2_bridge_family :=
    boxedTorusFullReachZ2TopoClusterBridge_current_family
  boxed_torus_full_reach_z2_bridge_core_current :=
    boxedTorusFullReachZ2TopoClusterBridge_current_core
  boxed_torus_full_reach_z2_bridge_lower_bound_current :=
    boxedTorusFullReachZ2TopoClusterBridge_current_lower_bound
  boxed_torus_full_reach_z2_bridge_unit_compatible :=
    boxedTorusFullReachZ2TopoClusterBridge_current_unit_compatible
  boxed_torus_full_reach_not_flat_only_diagnostic :=
    not_boxedTorusFullReachComplementTopoLossData_flatOnlyDiagnostic
  boxed_torus_flat_lower_bound_current :=
    BoxedTorusFullReachFlatOnlyLowerBoundConclusion_current
  boxed_torus_family_core_current :=
    boxedTorusFullReachFlatOnlyComplementTopoLossData_flatFamilyCoreConclusion
  boxed_torus_flat_only_diagnostic_current :=
    boxedTorusFullReachFlatOnlyComplementTopoLossData_flatOnlyDiagnostic
  boxed_torus_flat_only_giant_loss_zero_current :=
    boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnGiantOn_eq_zero
  boxed_torus_flat_only_flat_loss_failure_mass_current :=
    boxedTorusFullReachFlatOnlyComplementTopoLossData_expectedTopoLossOnData_flat_eq_failureMass
  boxed_torus_all_open_giant_full_cluster :=
    boxedTorusAllOpenGiantTopoLossData_giantEventFullClusterConclusion
  boxed_torus_all_open_giant_envelope :=
    boxedTorusAllOpenGiantTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
  boxed_torus_all_open_positive_giant_flat_pos :=
    fun L p hp =>
      boxedTorusAllOpenPositiveTopoLossData_expectedTopoLossOnGiant_flat_pos
        L (p := p) hp
  boxed_torus_all_open_complement_flat_lower_bound :=
    BoxedTorusFlatUnitCompatibleAboveThresholdLowerBoundConclusion_current
  boxed_torus_all_open_complement_unit_compatible :=
    boxedTorusAllOpenComplementTopoLossData_unitCompatibleAboveThresholdLowerBoundConclusion
  boxed_torus_all_open_complement_giant_full_cluster :=
    boxedTorusAllOpenComplementTopoLossData_giantEventFullClusterConclusion
  boxed_torus_all_open_complement_giant_envelope :=
    boxedTorusAllOpenComplementTopoLossData_expectedTopoLossOnGiantEnvelopeConclusion
  boxed_torus_all_open_complement_flat_loss_ge_eighth :=
    boxedTorusAllOpenComplementTopoLossData_expectedTopoLossOnData_flat_ge_eighth
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
theorem paperSemanticOpenCount_current : paperSemanticOpenCount = 2 := rfl

/-- Build gate: the R10 relabeling, Part 4 lattice p-monotonicity, and high-κ
oracle-routing calibrations are now closed. -/
theorem paperSemanticClosedCount_current : paperSemanticClosedCount = 3 := rfl

/-- Build gate: the open semantic-frontier identities are fixed, not merely the
count.  Closing or adding a target must update this theorem in the same patch as
the semantic ledger. -/
theorem openSemanticTargetIds_current :
    openSemanticTargetIds =
      ["theorem_4_1_part6_lattice_embedding",
       "topo_cluster_random_supercritical_z2"] := rfl

/-- Build gate: the closed semantic-frontier identities are fixed, not merely
the count. -/
theorem closedSemanticTargetIds_current :
    closedSemanticTargetIds =
      ["r10_two_regime_label_recalibration",
       "theorem_4_1_part4_lattice_p_monotonicity",
       "r10_threshold_five_state_high_kappa_routing"] := rfl

/-- Build gate: the closed R10 high-κ semantic target is backed by the
paper-facing one-edge signal-conditional routing theorem. -/
theorem r10_threshold_five_state_high_kappa_routing_payload (p : ℝ) :
    FiveState.highKappaOracleRoutingWelfare p =
      FiveState.fiveStateOracleWelfare p :=
  FiveState.highKappaOracleRoutingWelfare_eq_oracle p

/-- Named target proposition for the full paper-semantic kernel-only gate. -/
def CompletePaperSemanticKernelOnly : Prop :=
  paperSemanticOpenCount = 0

/-- The named full paper-semantic kernel-only gate is definitionally the
absence of open semantic targets. -/
theorem completePaperSemanticKernelOnly_iff_no_open_targets :
    CompletePaperSemanticKernelOnly ↔ paperSemanticOpenCount = 0 :=
  Iff.rfl

/-- Complete paper-semantic kernel-only status is not yet claimable while the
open semantic target count is nonzero. -/
theorem completePaperSemanticKernelOnly_notYet :
    Not CompletePaperSemanticKernelOnly := by
  intro hcomplete
  exact (by decide : paperSemanticOpenCount ≠ 0) hcomplete

#eval s!"Blackwell-Dilemma paper-semantic gate: closed={paperSemanticClosedCount} open={paperSemanticOpenCount}"

end PaperSemanticGate
end BlackwellDilemma
