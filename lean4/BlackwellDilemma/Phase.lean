/-
  BlackwellDilemma/Phase.lean

  §3.3–§3.4 Phase transition and trap prevalence.

  Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026).

  Contents:
   * Theorem 3.3 (`thm:phase`) — Phase Transition at `p_c = 1/2` on `Z²`.
   * Proposition (`prop:trap-prevalence`) — Generic Trap Prevalence on `Z²`.
   * Corollary (`cor:er-phase`) — Phase Transition on Erdős–Rényi.
   * Corollary (`cor:power-law`) — Power-Law Networks `2 < γ < 3`.
   * Definition (`def:value-functions`) — Static and Dynamic Value
     (encoded as opaque functions over Vertex / PercolationOutcome).

  Each statement is wired through paper-citation axioms or to the
  classical results in `ClassicalResults.lean` (Harris–Kesten, Grimmett,
  Bollobás, Cohen et al., Molloy–Reed).
-/

import BlackwellDilemma.Types
import BlackwellDilemma.ClassicalResults
import BlackwellDilemma.Wrongness

namespace BlackwellDilemma

/-! ## 1. Static and dynamic value (`def:value-functions`)

`V_static(v) = r(v)`; `V_dyn(v) = max_{w ∈ R(v | v')} r(w)` is the best
forward-reachable reward under the no-revisit rule. -/

/-- Static value of vertex `v`: just its immediate reward.
    paper source: Definition `def:value-functions`, line 442. -/
noncomputable def V_static (v : Vertex) : ℝ := reward v

/-- Dynamic value of vertex `v` given parent `v'` and percolation
    outcome `ω`: the best reward in the forward reachable set.
    paper source: Definition `def:value-functions`, line 443. -/
axiom V_dyn : Vertex → Finset Vertex → PercolationOutcome → ℝ

/-- Cat 3 paper-novel ATOMIC structural equation: the dynamic value of
    a vertex `v` (under parent set `H`, percolation outcome `ω`) is the
    paper-stated sup of rewards over the forward-reachable set
    `ForwardReachable v H ω`. Paper Definition 2.2 line 127 reads
    "`V_dyn(v_0) = max_{v ∈ R(v_0)} r(v)`" and Definition
    `def:value-functions` line 446 reads "`V_dyn(v) = max_{w ∈ R(v|v')}
    r(w)`"; both are realised here as a `Finset.sup'` over the
    forward-reachable carrier (using the trivial-path inclusion
    `ForwardReachable_self_member` from Types.lean to witness
    non-emptiness).

    Encoding choice: the paper's `max` is realised by `Finset.sup'`
    rather than `Finset.max'` because `Finset.sup'` interfaces directly
    with the order on `ℝ` for arbitrary non-empty `Finset`s. The
    membership-witness `ForwardReachable_self_member` provides the
    `Finset.Nonempty` argument by `⟨v, ForwardReachable_self_member v H ω⟩`.

    paper source: Definition 2.2 (`def:reachable`), line 127 (`V_dyn(v_0)
    = max_{v ∈ R(v_0)} r(v)`); Definition `def:value-functions`,
    line 446 (`V_dyn(v) = max_{w ∈ R(v|v')} r(w)`). -/
axiom V_dyn_def :
    ∀ (v : Vertex) (H : Finset Vertex) (ω : PercolationOutcome),
      V_dyn v H ω =
        (ForwardReachable v H ω).sup' ⟨v, ForwardReachable_self_member v H ω⟩ reward

/-! ## 2. Theorem 3.3 — Phase Transition at `p_c` on `Z²`

The phase transition is sharp: below `p_c = 1/2`, a positive fraction
`θ(1−p)` of agents inhabit the giant component where information
governs welfare; above `p_c`, this fraction is identically zero. -/

/-- **Theorem 3.3 (`thm:phase`) Part 1: Below threshold
    (`p < p_c = harrisKestenCriticalProb`).**
    Topological loss vanishes asymptotically; oracle Blackwell holds.
    Composes the Harris-Kesten Cat 2 axiom (Cat 2),
    `gap_percolation_probability_OPEN` (Cat 2 — Grimmett 1999),
    `gap_topo_cluster_relation_OPEN`, conditional Blackwell.

    Split from the original bundled axiom per `feedback_gap_ledger_in_lean4`
    Anti-pattern #2 (single bundled abstract axiom for many sub-gaps).

    The threshold antecedent literally consumes `harrisKestenCriticalProb`
    (defined in `ClassicalResults.lean`) rather than the literal `1/2`;
    the paper-stated value `p_c = 1/2` is recorded separately by the
    Cat 2 axiom `gap_harris_kesten_OPEN`. This anchors
    `harrisKestenCriticalProb` as a downstream-consumed carrier rather
    than an orphan declaration.

    Cat 2 dependency surfacing: per the audit-chain discipline (axioms
    have no body, so a downstream axiom cannot "compose" an upstream
    axiom by direct call), the Cat 2 axiom
    `gap_percolation_probability_OPEN` (Grimmett 1999 percolation-
    probability `θ(1−p) > 0 for p < 1/2`) is threaded as an EXPLICIT
    ANTECEDENT `(h_perc_prob : ∃ θ, ...)` so that `#print axioms` on
    any theorem consuming `gap_phase_transition_below_OPEN` surfaces
    the Grimmett dependency. The R26 drop of this antecedent was
    correct for downstream THEOREMS but WRONG for downstream AXIOMS;
    this R28-A restoration follows the broken-link discipline ladder
    for audit-chain visibility (`feedback_gap_ledger_in_lean4`
    2026-05-13 §12 with the R28 axiom-vs-theorem-consumer
    clarification). The relevant Cat 2 axiom lives at
    `ClassicalResults.lean :: gap_percolation_probability_OPEN`.

    Anti-pattern repair: the previous formulation introduced an
    auxiliary `∃ topo_loss_decay : ℕ → ℝ, ...` whose body was
    trivially satisfiable by junk constants (e.g. `fun _ => -1`),
    a vacuous-existential anti-pattern (`feedback_gap_ledger_in_lean4`
    Cat 3 reductionism, Pattern 4 `Tautological premise`). The decay
    assertion is now anchored directly to the substantive paper-cited
    opaque carrier `expectedTopoLoss n p` (declared in `Wrongness.lean`
    as `expectedTopoLoss : ℕ → ℝ → ℝ`, paper source: Proposition
    `prop:topo-cluster` line 286), eliminating the vacuous-witness
    satisfaction and binding the claim to the paper's actual quantity.

    paper source: Theorem 3.3 (`thm:phase`), lines 400-419;
    Grimmett 1999 _Percolation_ 2nd ed. cited as the Cat 2
    percolation-probability dependency. -/
axiom gap_phase_transition_below_OPEN :
    (∃ θ : ℝ → ℝ,
      (∀ p : ℝ, p < harrisKestenCriticalProb → 0 < θ (1 - p)) ∧
      (∀ p : ℝ, harrisKestenCriticalProb ≤ p → θ (1 - p) = 0)) →
    ∀ p : ℝ, 0 ≤ p → p < harrisKestenCriticalProb →
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∀ n, N ≤ n → expectedTopoLoss n p < ε

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    The information-to-topology ratio `|W_info(p, β)| / |W_topo(p)|`
    on `Z²` at blocking parameter `p` and signal precision `β`.

    paper source: Theorem 3.3 (`thm:phase`), part 2 (line 425). -/
axiom wInfoTopoRatio : ℝ → ℝ → ℝ

/-- **Theorem 3.3 (`thm:phase`) Part 2: Above threshold
    (`p > p_c = harrisKestenCriticalProb`).**
    `|W_topo| = Θ(1)`; `|W_info| / |W_topo| = O(2^{-β}) → 0`. Composes
    the Cat 2 axiom `gap_grimmett_exponential_decay_OPEN`,
    `gap_info_decay_OPEN`, the wrongness lemma at
    `prop:trap-prevalence`.

    Split from the original bundled axiom per `feedback_gap_ledger_in_lean4`
    Anti-pattern #2.

    The threshold antecedent consumes `harrisKestenCriticalProb` rather
    than the literal `1/2`; the paper-stated equality is recorded by
    the Cat 2 axiom `gap_harris_kesten_OPEN`.

    Cat 2 dependency surfacing: per the audit-chain discipline (axioms
    have no body, so a downstream axiom cannot "compose" an upstream
    axiom by direct call), the Cat 2 axiom
    `gap_grimmett_exponential_decay_OPEN` (Grimmett 1999 §6.75
    exponential cluster-size decay above `p_c`) is threaded as an
    EXPLICIT ANTECEDENT `(h_grimmett : ...)` so that `#print axioms`
    on any theorem consuming `gap_phase_transition_above_OPEN`
    surfaces the Grimmett dependency. The R26 drop of this antecedent
    was correct for downstream THEOREMS but WRONG for downstream
    AXIOMS; this R28-A restoration follows the broken-link discipline
    ladder for audit-chain visibility (`feedback_gap_ledger_in_lean4`
    2026-05-13 §12 with the R28 axiom-vs-theorem-consumer
    clarification). The relevant Cat 2 axiom lives at
    `ClassicalResults.lean :: gap_grimmett_exponential_decay_OPEN`.

    paper source: Theorem 3.3 (`thm:phase`), lines 420-431;
    Grimmett 1999 _Percolation_ 2nd ed. §6.75 cited as the Cat 2
    exponential-decay dependency. -/
axiom gap_phase_transition_above_OPEN :
    (∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))) →
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ β : ℝ, 0 < β →
          wInfoTopoRatio p β ≤ c * Real.rpow 2 (-β)

/-! ## 3. Proposition `prop:trap-prevalence`

For `p > p_c` on `Z²`, the probability that a random vertex `v` has
neighbours `u_1, u_2` with `V_static(u_1) > V_static(u_2)` but
`V_dyn(u_1) < V_dyn(u_2)` is bounded below by a positive constant
depending on `p`. -/

/-- Cat 3 paper-novel ATOMIC structural equation: at `blockingProb = 0`,
    the forward-reachable set from any vertex `v` under EMPTY history
    equals the entire vertex carrier `Finset.univ`. Paper proof of
    Proposition `prop:trap-prevalence` Part 1 line 463 reads "When no
    edges are blocked, `R(v) = V` for all `v`": the entire vertex set is
    forward-reachable from any starting vertex when no edge is blocked.
    This atomic structural equation pins the paper-stated full-reachability
    fact at `p = 0` on the existing `ForwardReachable` carrier, scoped
    to the `H = ∅` base case that matches paper line 463 (the paper's
    `R(v)` is `ReachableSet` per Def 2.2, identified with
    `ForwardReachable v ∅ ω` via `ReachableSet_eq_ForwardReachable_empty`).
    Cat 1 reduction check: not Mathlib-derivable (depends on the paper's
    bond-percolation semantics that link `blockingProb = 0` to the
    all-edges-open realisation and the consequent connectivity claim).
    Cat 2 reduction check: paper-novel structural equation on the IDP
    primitives. Encoding choice: the `Fintype Vertex` instance is needed
    to express `Finset.univ`; declared as a Cat 3 atomic axiom alongside
    the existing `Vertex.decEq` because paper Definition 2.1 says the
    graph is on `n` nodes (finite).

    Scope discipline: the `H = ∅` restriction matches paper line 463
    exactly. For `H ∋ u` (e.g. `H = {v}` after visiting `v`), removing
    `v` from a connected graph could disconnect it, so
    `ForwardReachable u {v} ω ≠ Finset.univ` in general at `p = 0` (a
    formerly-overclaimed `∀ H` form would be SCOPE-INFLATED beyond the
    paper).

    paper source: Proposition `prop:trap-prevalence` Part 1 proof, line
    463 ("When no edges are blocked, `R(v) = V` for all `v`"). -/
axiom forward_reachable_full_at_zero_OPEN :
    ∀ [Fintype Vertex] (v : Vertex) (ω : PercolationOutcome),
      blockingProb = 0 → ForwardReachable v ∅ ω = Finset.univ

/-- **Proposition `prop:trap-prevalence` Part 1** — Cat 3 derived
    closure. At `blockingProb = 0`, all vertices have the same dynamic
    value `V_dyn = sSup r` because every vertex's forward-reachable set
    (under EMPTY history, matching paper Def 2.2 `R(v)`) coincides with
    the full vertex carrier `Finset.univ`. Hence the Vstatic/Vdyn rankings
    agree on all neighbours.

    Refactored from the prior `gap_trap_prevalence_zero_OPEN` per
    `feedback_gap_ledger_in_lean4` 2026-05-13 anti-pattern repair, then
    restated per the SCOPE-INFLATION audit: the prior axiom form
    (`V_dyn u {v} ω = V_dyn v ∅ ω`) and the prior `∀ H` atom form were
    SCOPE-INFLATED beyond paper line 463 — paper's `R(v) = V` is the
    `H = ∅` (i.e. `ReachableSet`) statement. The refactored statement
    encodes the paper's actual conclusion (`V_dyn` is constant over the
    `H = ∅` family at `p = 0`) and is derived from the H=∅-scoped
    Cat 3 atomic structural equation `forward_reachable_full_at_zero_OPEN`
    plus the existing `V_dyn_def` atom — the equality follows because
    both sides reduce to a `sup'` over the SAME carrier `Finset.univ`
    (with both witnesses providing the same non-emptiness data).

    paper source: Proposition `prop:trap-prevalence` Part 1, line 457
    + line 463 proof. -/
theorem gap_trap_prevalence_zero
    [Fintype Vertex]
    (v : Vertex) (ω : PercolationOutcome)
    (h_p_zero : blockingProb = 0) :
    ∀ u : Vertex, IsEdge v u →
      V_dyn u ∅ ω = V_dyn v ∅ ω := by
  intro u _h_edge
  have h_eq_u : ForwardReachable u ∅ ω = Finset.univ :=
    forward_reachable_full_at_zero_OPEN u ω h_p_zero
  have h_eq_v : ForwardReachable v ∅ ω = Finset.univ :=
    forward_reachable_full_at_zero_OPEN v ω h_p_zero
  rw [V_dyn_def u ∅ ω, V_dyn_def v ∅ ω]
  -- Both sides equal `Finset.univ.sup' _ reward` via `Finset.sup'_congr`
  -- (Mathlib `Data/Finset/Lattice/Fold.lean:587`). Bring both sides to
  -- this normal form, then close by `rfl` (sup' is independent of the
  -- proof witness — the proof argument is propext-style irrelevant in
  -- the conclusion of `sup'_congr`).
  rw [Finset.sup'_congr ⟨u, ForwardReachable_self_member u ∅ ω⟩ h_eq_u
        (fun _ _ => rfl),
      Finset.sup'_congr ⟨v, ForwardReachable_self_member v ∅ ω⟩ h_eq_v
        (fun _ _ => rfl)]

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    Probability that a uniformly chosen vertex on `Z²` exhibits the
    (V_static, V_dyn) misalignment under bond percolation at parameter
    `p`. The paper-classical constant is zero at and below `p_c = 1/2`,
    strictly positive above.
    paper source: Proposition `prop:trap-prevalence` Part 2. -/
axiom trapMisalignmentProbability : ℝ → ℝ

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    **Proposition `prop:trap-prevalence` Part 2.**
    For `p > p_c = harrisKestenCriticalProb` on `Z²`, the trap
    configuration has positive lower-bounded probability. The
    hypothesis consumes `harrisKestenCriticalProb` rather than the
    literal `1/2`; the paper-stated equality is recorded by the
    Cat 2 axiom `gap_harris_kesten_OPEN` (R26 retired the BLOCKED-def
    encoding pattern; Cat 2 axioms with paper authority are now
    encoded as plain OPEN axioms with paper-cited docstrings).

    paper source: Proposition `prop:trap-prevalence` Part 2, lines 458-473. -/
axiom gap_trap_prevalence_above_threshold_OPEN :
    ∀ p : ℝ, harrisKestenCriticalProb < p → 0 < trapMisalignmentProbability p

/-! ## 4. Corollary `cor:er-phase` — Erdős–Rényi

On `G(n, c/n)`: if `c < 1`, all components are `O(log n)` and topology
dominates. If `c > 1`, the giant component has size `Θ(n)` for a
positive `ζ(c)` fraction of agents and information governs welfare. -/

/-- **Corollary `cor:er-phase` Part 1: subcritical ER.**
    `c < 1` gives `O(log n)` components and `|W_topo| = Θ(1)`.

    Consumes the Cat 2 axiom `gap_er_subcritical_OPEN` directly per the
    2026-05-13 discipline clarification (Cat 2 axioms with paper
    authority are consumed directly, not threaded as broken-link
    hypotheses).

    paper source: Corollary `cor:er-phase` Part 1, lines 1075-1077. -/
theorem gap_er_phase_subcritical
    (c : ℝ) (hc : c < 1) :
    ∃ K : ℝ, 0 < K ∧
      ∀ n : ℕ, 1 ≤ n → giantComponentSize_ER n c ≤ K * Real.log (n + 1) :=
  gap_er_subcritical_OPEN c hc

/-- **Corollary `cor:er-phase` Part 2: supercritical ER.**
    `c > 1` gives a giant component of size `Θ(n)` for a positive
    fraction `ζ(c) = poissonSurvival c > 0` of agents.

    Consumes the Cat 2 axiom `gap_er_supercritical_OPEN` directly per
    the 2026-05-13 discipline clarification (Cat 2 axioms with paper
    authority are consumed directly, not threaded as broken-link
    hypotheses).

    paper source: Corollary `cor:er-phase` Part 2, lines 1078-1080. -/
theorem gap_er_phase_supercritical
    (c : ℝ) (hc : 1 < c) : 0 < poissonSurvival c :=
  gap_er_supercritical_OPEN c hc

/-- Bond-percolation critical threshold for `G(n, c/n)`, encoded as
    its closed-form value `1 - 1/c` per the paper's stated formula
    (line 1080). Hodge-style paper-citation encoding: the def IS the
    paper's authority-cited closed form (Newman 2001 §IIIA generating-
    function derivation); the substantive Newman 2001 derivation
    remains a Mathlib gap, but the formula's correctness is taken
    on paper authority. -/
noncomputable def bondPercolationCriticalER (c : ℝ) : ℝ := 1 - 1 / c

/-- **Bond-percolation thinning of ER**: `p_c = 1 − 1/c`, with positivity
    `0 < p_c` for `c > 1`.

    The def `bondPercolationCriticalER c := 1 − 1/c` IS the paper's
    stated closed form (paper `\label{cor:er-phase}`). The theorem
    records both the consistency between the def and the paper formula
    AND the positivity assertion (which uses the `1 < c` hypothesis
    via `1 - 1/c > 0 ⟺ 1/c < 1 ⟺ 1 < c`). Pattern matches
    `gap_power_law_thin_tail`, which similarly bundles equality with
    positivity discharged from the hypothesis.

    paper source: Corollary `cor:er-phase` (`\citep{newman2001}` rigorous
    derivation; positivity from heavy-tail `c > 1` requirement). -/
theorem gap_er_bond_percolation_threshold :
    ∀ c : ℝ, 1 < c →
      bondPercolationCriticalER c = 1 - 1 / c
      ∧ 0 < bondPercolationCriticalER c := by
  intros c hc
  refine ⟨rfl, ?_⟩
  unfold bondPercolationCriticalER
  -- 0 < 1 - 1/c iff 1/c < 1 iff 1 < c (using 0 < c from 1 < c)
  have hc_pos : 0 < c := lt_trans zero_lt_one hc
  have h_inv_lt_one : 1 / c < 1 := by
    rw [div_lt_one hc_pos]; exact hc
  linarith

/-! ## 5. Corollary `cor:power-law` — Power-law networks

For configuration model with `Pr(D = k) ∝ k^{-γ}`:
* `2 < γ < 3` → `p_c = 1` (no non-trivial transition; topology vanishes
  at any `p < 1`).
* `γ > 3` → `p_c = 1 − E[D]/E[D(D−1)] > 0` by Molloy–Reed. -/

/-- **Corollary `cor:power-law` Part 1: heavy-tailed (`2 < γ ≤ 3`).**
    Giant component survives at any `p < 1`, hence `|W_topo| = O(1/n)`
    everywhere except at `p = 1`. Boundary `γ ≤ 3` matches Cohen et al.
    2000 (paper says α ≤ 3 closed boundary).

    Consumes the Cat 2 axiom `gap_cohen_powerlaw_OPEN` directly per the
    2026-05-13 discipline clarification (Cat 2 axioms with paper
    authority are consumed directly, not threaded as broken-link
    hypotheses).

    paper source: Corollary `cor:power-law` Part 1, lines 1090-1093. -/
theorem gap_power_law_heavy_tail
    (γ : ℝ) (hγ : 2 < γ ∧ γ ≤ 3) :
    ∀ p : ℝ, 0 ≤ p → p < 1 →
      ∃ E_D E_D_DSub1 : ℝ, 0 < E_D ∧
        HasGiantComponent (E_D * (1 - p)) (E_D_DSub1 * (1 - p)^2) :=
  gap_cohen_powerlaw_OPEN γ hγ

/-- Bond-percolation critical threshold for the configuration model
    with given degree-distribution moments, encoded as its closed-form
    value `1 - E_D / E_D_DSub1` per the paper's stated formula (line
    1092). Hodge-style paper-citation encoding. -/
noncomputable def bondPercolationCritical_ConfigModel
    (E_D E_D_DSub1 : ℝ) : ℝ := 1 - E_D / E_D_DSub1

/-- **Corollary `cor:power-law` Part 2: thin-tailed (`γ > 3`).**
    `p_c = 1 − E[D]/E[D(D−1)] > 0` by Molloy-Reed criterion specialised
    to bond-thinning. Statement includes both the equality (encoded by
    the def) AND the `> 0` positivity assertion (proved from `0 < E_D`
    and `E_D < E_D_DSub1`, which the paper derives from `γ > 3` since
    `E[D(D-1)] > E[D]` for heavy-tailed distributions).

    The def IS the paper's stated closed form (line 1092 +
    `\citep{molloy1995,cohen2000,newman2001}`). Equality clause is
    `rfl`; positivity clause is proved from the hypotheses.

    Cat 2 dependency on Molloy-Reed 1995 is consumed implicitly through
    the axiom system per the 2026-05-13 discipline clarification (Cat 2
    axioms with paper authority are consumed directly, not threaded as
    broken-link hypotheses). The relevant Cat 2 axiom lives at
    `ClassicalResults.lean :: gap_molloy_reed_OPEN` (paper line 1092
    derives the closed form `p_c = 1 - E[D]/E[D(D−1)]` BY the
    Molloy-Reed criterion).

    paper source: Corollary `cor:power-law` Part 2, lines 1093-1094. -/
theorem gap_power_law_thin_tail :
    ∀ γ : ℝ, 3 < γ →
      ∀ E_D E_D_DSub1 : ℝ, 0 < E_D → E_D < E_D_DSub1 →
        bondPercolationCritical_ConfigModel E_D E_D_DSub1 = 1 - E_D / E_D_DSub1
        ∧ 0 < bondPercolationCritical_ConfigModel E_D E_D_DSub1 := by
  intros _ _ E_D E_D_DSub1 hE_D hE_lt
  refine ⟨rfl, ?_⟩
  unfold bondPercolationCritical_ConfigModel
  -- 0 < 1 - E_D / E_D_DSub1 iff E_D / E_D_DSub1 < 1 iff E_D < E_D_DSub1
  have hE_DSub1_pos : 0 < E_D_DSub1 := lt_trans hE_D hE_lt
  have h_div_lt_one : E_D / E_D_DSub1 < 1 := by
    rw [div_lt_one hE_DSub1_pos]; exact hE_lt
  linarith

end BlackwellDilemma
