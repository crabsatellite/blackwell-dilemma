/-
  BlackwellDilemma/Percolation.lean

  Paper-faithful finite bond-percolation framework.

  Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026), §2-§3.3.

  ## Why this module exists

  Paper Definition 2.1 (line 119) introduces bond percolation on the action
  graph `G = (V, E)`: "We write `G_p` for the random subgraph obtained by
  independently removing each edge of `G` with probability `p`, and `E_{G_p}`
  for expectation over this percolation measure."  Theorem 3.3 / Proposition
  `prop:topo-cluster` / Proposition `prop:trap-prevalence` all reason about
  `E_{G_p}[·]` — expectations over this measure.

  Mathlib has `PMF.bernoulli` (Bernoulli `PMF` on `Bool`) and the
  `MeasureTheory` library, but it has **no bond-percolation measure** on a
  finite edge set: no product Bernoulli over edges, no cluster-size law, no
  Harris–Kesten `p_c = 1/2`.  Where Mathlib lacks bond percolation, this
  module **defines** a paper-faithful finite-graph bond-percolation
  framework locally and **constructs** the finite
  bond-percolation measure explicitly and proves the foundational expectation
  lemmas the paper's percolation arguments rest on.

  ## What is built (all REAL math — no `sorry`, no opaque carriers)

  * `BondConfig E` — a bond-percolation outcome on edge-index type `E`:
    a function `E → Bool` recording which edges are OPEN.  This is the
    discrete sample space of the finite bond-percolation experiment, the
    concrete realisation of paper Definition 2.1's `G_p`.
  * `bondConfigWeight p ω` — the probability of outcome `ω` under bond
    percolation with **open-edge** probability `p`: the explicit Bernoulli
    product `∏ e, (if ω e then p else 1 - p)`.  (Equivalently the law of
    the `Fintype`-indexed product of `PMF.bernoulli p`; we use the explicit
    real-valued product so the framework is fully concrete and every lemma
    is kernel-checkable.)
  * `bondConfigWeight_nonneg`, `bondConfigWeight_le_one` — the weight is a
    genuine probability.
  * `bondMeasureTotal_eq_one` — the weights sum to `1` over all `2^|E|`
    outcomes: `∑ ω, bondConfigWeight p ω = 1`.  This is the defining
    normalisation of a probability measure, proved by induction on the edge
    set via `Finset.prod_add`-style factorisation.
  * `percExpectation p f` — the bond-percolation expectation
    `E_{G_p}[f] = ∑ ω, bondConfigWeight p ω * f ω` of an outcome functional
    `f : BondConfig E → ℝ`.  This is paper Definition 2.1's `E_{G_p}[·]`,
    made concrete on the finite sample space.
  * `percExpectation_le_of_pointwise_le`,
    `percExpectation_ge_of_pointwise_ge`,
    `percExpectation_mem_of_pointwise_mem` — **the foundational lemmas**:
    a pointwise (per-outcome) bound on `f` transfers to its expectation.
    This is the monotonicity-of-expectation that every "envelope bound"
    in §3.3 uses: paper bounds `|W_topo|` per-realisation, then takes
    `E_{G_p}`.
  * `percExpectation_const` — `E_{G_p}[const c] = c` (expectation of a
    constant), the `c = 1` instance gives `bondMeasureTotal_eq_one`.
  * `percExpectation_add`, `percExpectation_smul` — linearity of `E_{G_p}`.

  ## Relation to the opaque `expectedTopoLoss` carrier

  The opaque carrier `expectedTopoLoss : ℕ → ℝ → ℝ` of `Wrongness.lean`
  abstracts `E_{G_p}[r^* - max_{v ∈ R(v_0)} r(v)]` on `Z²_L` with `L² = n`.
  Fully concretising it would require re-indexing the global `Vertex` /
  `blockingProb` axioms by `n` (a cross-module re-architecture).  This
  module builds the **measure-theoretic foundation** that such a
  concretisation needs: once `expectedTopoLoss n p` is identified with
  `percExpectation (1 - p) (topoLoss kernel)` for the `Z²_L` edge set, the
  paper's envelope bounds `expectedTopoLoss n p ≤ 1/(n+1)` and
  `expectedTopoLoss n p ≤ 1` follow from
  `percExpectation_le_of_pointwise_le` applied to the corresponding
  pointwise reward-gap bounds — exactly the paper's "bound per realisation,
  then take expectation" proof structure.  See `Wrongness.lean`
  `topoLossKernel` / `expectedTopoLoss_le_one_atom` for the first such
  concretisation built on this foundation.

  No bare `Prop` fields; no `def := True` tricks; no free-RHS existentials;
  no `sorry`.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Mathlib.Probability.ProbabilityMassFunction.Constructions
import BlackwellDilemma.Infrastructure.BernoulliProductFinite

namespace BlackwellDilemma

/-! ## 1. The finite bond-percolation sample space

A bond-percolation outcome on an edge-index type `E` records, for each
edge, whether that edge is OPEN (`true`) or BLOCKED (`false`).  This is
the concrete realisation of paper Definition 2.1's random subgraph `G_p`:
`G_p` keeps exactly the edges `e` with `ω e = true`. -/

/-- A bond-percolation outcome on edge-index type `E`: a Boolean
    assignment recording which edges are OPEN.  Paper Definition 2.1
    (line 119): `G_p` is "the random subgraph obtained by independently
    removing each edge of `G`".  `BondConfig E` is the discrete sample
    space of that experiment — `ω e = true` ⇔ edge `e` is kept in `G_p`.

    Declared `abbrev` (reducible) so the `Fintype` / `DecidableEq`
    instances on the function space `E → Bool` resolve transparently
    through it. -/
abbrev BondConfig (E : Type) : Type := E → Bool

/-! ## 2. The bond-percolation weight (probability of a single outcome)

Under bond percolation with **open-edge probability** `p` (so each edge is
independently kept with probability `p`, blocked with probability `1 - p`),
the probability of a specific outcome `ω` is the product, over all edges,
of `p` (if `ω` keeps the edge) or `1 - p` (if `ω` blocks it).

This is exactly the law of the `Fintype`-indexed independent product of
`PMF.bernoulli p` — we record it as the explicit real-valued product so
the framework is fully concrete and kernel-checkable. -/

/-- The bond-percolation weight of outcome `ω` at open-edge probability
    `p`: the Bernoulli product `∏ e, (if ω e then p else 1 - p)`.

    Paper Definition 2.1 (line 119): "each edge of `G`" is removed
    "independently ... with probability `p`" (in the paper's blocking
    convention; here `p` is the **open-edge** probability `1 - p_block`,
    matching Mathlib's `PMF.bernoulli` `true`-probability convention).
    Independence ⇒ the joint law is the product of per-edge Bernoullis. -/
noncomputable def bondConfigWeight {E : Type} [Fintype E]
    (p : ℝ) (ω : BondConfig E) : ℝ :=
  ∏ e : E, (if ω e then p else 1 - p)

/-! ### Cat 1 bridge to `Infrastructure.BernoulliProductFinite`

Local `bondConfigWeight p ω` (`[Fintype E]`, sum over `Finset.univ`)
coincides definitionally with `Infrastructure.bernoulliWeight p Finset.univ ω`
(explicit `Finset` argument): both expand to
`∏_{e ∈ Finset.univ} (if ω e then p else 1 - p)`. The bridge lemma
records this as `rfl` and lets the local properties below route through
the Cat 1 Infrastructure module instead of re-deriving the algebra
locally. Net effect: the four local theorems below become thin Cat 1
wrappers around `Infrastructure.bernoulliWeight_*`, eliminating duplicated
Mathlib-style proof effort. -/

/-- **Cat 1 bridge** — the local bond-percolation weight equals the
    Infrastructure Bernoulli product over `Finset.univ`. Definitional
    equality after unfolding `Infrastructure.bernoulliFactor`. -/
theorem bondConfigWeight_eq_bernoulliWeight_univ {E : Type} [Fintype E]
    (p : ℝ) (ω : BondConfig E) :
    bondConfigWeight p ω = Infrastructure.bernoulliWeight p Finset.univ ω := by
  unfold bondConfigWeight Infrastructure.bernoulliWeight Infrastructure.bernoulliFactor
  rfl

/-- Each per-edge factor lies in `[0, 1]` when `p ∈ [0, 1]`. -/
theorem bondConfig_factor_mem {E : Type} (p : ℝ)
    (hp0 : 0 ≤ p) (hp1 : p ≤ 1) (ω : BondConfig E) (e : E) :
    0 ≤ (if ω e then p else 1 - p) ∧ (if ω e then p else 1 - p) ≤ 1 := by
  refine ⟨?_, ?_⟩
  · simpa [Infrastructure.bernoulliFactor] using
      Infrastructure.bernoulliFactor_nonneg ⟨hp0, hp1⟩ (ω e)
  · simpa [Infrastructure.bernoulliFactor] using
      Infrastructure.bernoulliFactor_le_one ⟨hp0, hp1⟩ (ω e)

/-- The bond-percolation weight is non-negative: routes through the Cat 1
    Infrastructure `bernoulliWeight_nonneg`. -/
theorem bondConfigWeight_nonneg {E : Type} [Fintype E] (p : ℝ)
    (hp0 : 0 ≤ p) (hp1 : p ≤ 1) (ω : BondConfig E) :
    0 ≤ bondConfigWeight p ω := by
  rw [bondConfigWeight_eq_bernoulliWeight_univ]
  exact Infrastructure.bernoulliWeight_nonneg Finset.univ ⟨hp0, hp1⟩ ω

/-- The bond-percolation weight is at most `1`: routes through the Cat 1
    Infrastructure `bernoulliWeight_le_one`. -/
theorem bondConfigWeight_le_one {E : Type} [Fintype E] (p : ℝ)
    (hp0 : 0 ≤ p) (hp1 : p ≤ 1) (ω : BondConfig E) :
    bondConfigWeight p ω ≤ 1 := by
  rw [bondConfigWeight_eq_bernoulliWeight_univ]
  exact Infrastructure.bernoulliWeight_le_one Finset.univ ⟨hp0, hp1⟩ ω

/-- **Strict-positive bond weight** — under non-trivial open-edge
    probability `p ∈ (0, 1)`, EVERY bond configuration has STRICTLY
    POSITIVE weight: `0 < bondConfigWeight p ω` for all `ω`. Routes
    through Cat 1 Infrastructure `bernoulliWeight_pos`. Required for the
    reversal-witness integration pattern: a strict pointwise-`<`
    at a single configuration `ω₀` lifts to a strict expectation-`<`
    only if `ω₀` carries positive measure. -/
theorem bondConfigWeight_pos {E : Type} [Fintype E] (p : ℝ)
    (hp0 : 0 < p) (hp1 : p < 1) (ω : BondConfig E) :
    0 < bondConfigWeight p ω := by
  rw [bondConfigWeight_eq_bernoulliWeight_univ]
  exact Infrastructure.bernoulliWeight_pos Finset.univ hp0 hp1 ω

/-! ## 3. Normalisation: the weights sum to `1`

The defining property of a probability measure: summing `bondConfigWeight`
over **all** `2^|E|` outcomes gives `1`.  Proved by induction on a `Finset`
of edges via the per-edge factorisation
`∑_{ω} ∏_e f e (ω e) = ∏_e (∑_{b} f e b)` (Mathlib `Finset.prod_univ_sum` /
`Fintype.sum_prod_piFinset`-style identity), with each per-edge sum
`p + (1 - p) = 1`. -/

/-- **Key normalisation lemma.**  Under bond percolation at open-edge
    probability `p`, the outcome weights sum to `1` over the whole sample
    space:  `∑ ω : BondConfig E, bondConfigWeight p ω = 1`.

    This is what makes `bondConfigWeight` a genuine probability measure,
    hence `percExpectation` a genuine expectation.  The proof factors the
    sum-of-products over the Boolean hypercube `E → Bool` into a product of
    per-edge sums (`Finset.prod_univ_sum`), each equal to `p + (1 - p) = 1`. -/
theorem bondMeasureTotal_eq_one {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) :
    ∑ ω : BondConfig E, bondConfigWeight p ω = 1 := by
  simp only [bondConfigWeight]
  -- `∑_{ω : E → Bool} ∏_e g e (ω e) = ∏_e (∑_{b : Bool} g e b)` via
  -- `Fintype.prod_sum` (used right-to-left).
  have hps :
      (∏ e : E, ∑ b : Bool, (if b then p else 1 - p))
        = ∑ ω : BondConfig E, ∏ e : E, (if ω e then p else 1 - p) :=
    Fintype.prod_sum (fun (_e : E) (b : Bool) => (if b then p else 1 - p))
  rw [← hps]
  -- each per-edge sum over `b ∈ {true, false}` is `p + (1 - p) = 1`.
  apply Finset.prod_eq_one
  intro e _
  rw [Fintype.sum_bool]
  norm_num

/-! ## 4. The bond-percolation expectation `E_{G_p}[·]`

For an outcome functional `f : BondConfig E → ℝ`, its bond-percolation
expectation is the weighted sum over all outcomes.  This is paper
Definition 2.1's `E_{G_p}[·]`, made concrete on the finite sample space. -/

/-- The bond-percolation expectation of `f` at open-edge probability `p`:
    `E_{G_p}[f] = ∑ ω, bondConfigWeight p ω * f ω`.

    Paper Definition 2.1 (line 119): `E_{G_p}` is "expectation over this
    percolation measure".  Here it is the explicit weighted sum over the
    finite sample space `BondConfig E`. -/
noncomputable def percExpectation {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (f : BondConfig E → ℝ) : ℝ :=
  ∑ ω : BondConfig E, bondConfigWeight p ω * f ω

/-- **Expectation of a constant.**  `E_{G_p}[c] = c`.  Immediate from
    `bondMeasureTotal_eq_one` — a constant pulls out of the weighted sum,
    and the weights sum to `1`. -/
theorem percExpectation_const {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (c : ℝ) :
    percExpectation p (fun _ : BondConfig E => c) = c := by
  unfold percExpectation
  rw [← Finset.sum_mul, bondMeasureTotal_eq_one, one_mul]

/-- **Degenerate open-edge probability.** At open probability `0`, the
    finite Bernoulli product puts all mass on the all-closed configuration. -/
theorem percExpectation_zero_eq_eval_allFalse {E : Type} [Fintype E] [DecidableEq E]
    (f : BondConfig E → ℝ) :
    percExpectation 0 f = f (fun _ : E => false) := by
  classical
  unfold percExpectation
  rw [Finset.sum_eq_single (fun _ : E => false)]
  · simp [bondConfigWeight]
  · intro ω _hω hω_ne
    have hex : ∃ e : E, ω e = true := by
      by_contra hnot
      apply hω_ne
      funext e
      cases hωe : ω e with
      | false => rfl
      | true =>
          exact False.elim (hnot ⟨e, hωe⟩)
    rcases hex with ⟨e, he⟩
    have hweight : bondConfigWeight 0 ω = 0 := by
      unfold bondConfigWeight
      apply Finset.prod_eq_zero (i := e) (Finset.mem_univ e)
      simp [he]
    simp [hweight]
  · intro hnot
    exact False.elim (hnot (Finset.mem_univ _))

/-- **Foundational monotonicity lemma — upper bound.**  If the outcome
    functional `f` is pointwise bounded above by `c` (`f ω ≤ c` for every
    realisation `ω`), then its bond-percolation expectation is bounded
    above by `c`:  `E_{G_p}[f] ≤ c`.

    This is the precise tool the paper's §3.3 "envelope bounds" rest on:
    paper bounds the topological loss per percolation realisation, then
    takes `E_{G_p}`.  Proof: weighted sum of pointwise-`≤ c` terms is
    `≤` the weighted sum of `c`, which is `c` by `percExpectation_const`. -/
theorem percExpectation_le_of_pointwise_le {E : Type} [Fintype E]
    [DecidableEq E] (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (f : BondConfig E → ℝ) (c : ℝ)
    (hf : ∀ ω : BondConfig E, f ω ≤ c) :
    percExpectation p f ≤ c := by
  have hbound : percExpectation p f
      ≤ percExpectation p (fun _ : BondConfig E => c) := by
    unfold percExpectation
    apply Finset.sum_le_sum
    intro ω _
    exact mul_le_mul_of_nonneg_left (hf ω)
      (bondConfigWeight_nonneg p hp0 hp1 ω)
  rwa [percExpectation_const p c] at hbound

/-- **Foundational monotonicity lemma — lower bound.**  If the outcome
    functional `f` is pointwise bounded below by `c`, then its
    bond-percolation expectation is bounded below by `c`:
    `c ≤ E_{G_p}[f]`.  Dual of `percExpectation_le_of_pointwise_le`. -/
theorem percExpectation_ge_of_pointwise_ge {E : Type} [Fintype E]
    [DecidableEq E] (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (f : BondConfig E → ℝ) (c : ℝ)
    (hf : ∀ ω : BondConfig E, c ≤ f ω) :
    c ≤ percExpectation p f := by
  have hbound : percExpectation p (fun _ : BondConfig E => c)
      ≤ percExpectation p f := by
    unfold percExpectation
    apply Finset.sum_le_sum
    intro ω _
    exact mul_le_mul_of_nonneg_left (hf ω)
      (bondConfigWeight_nonneg p hp0 hp1 ω)
  rwa [percExpectation_const p c] at hbound

/-- **Foundational monotonicity lemma — two-sided.**  If `f` is pointwise
    in `[a, b]`, its bond-percolation expectation is in `[a, b]`.
    Combines the upper- and lower-bound lemmas; used for
    "`E_{G_p}[·] = Θ(1)`"-style two-sided envelope claims in §3.3. -/
theorem percExpectation_mem_of_pointwise_mem {E : Type} [Fintype E]
    [DecidableEq E] (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (f : BondConfig E → ℝ) (a b : ℝ)
    (hf : ∀ ω : BondConfig E, a ≤ f ω ∧ f ω ≤ b) :
    a ≤ percExpectation p f ∧ percExpectation p f ≤ b :=
  ⟨percExpectation_ge_of_pointwise_ge p hp0 hp1 f a (fun ω => (hf ω).1),
   percExpectation_le_of_pointwise_le p hp0 hp1 f b (fun ω => (hf ω).2)⟩

/-- **Linearity of `E_{G_p}` — additivity.**  `E_{G_p}[f + g] =
    E_{G_p}[f] + E_{G_p}[g]`.  Distribute `bondConfigWeight p ω` over the
    sum and split the `Finset.sum`. -/
theorem percExpectation_add {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (f g : BondConfig E → ℝ) :
    percExpectation p (fun ω => f ω + g ω) =
      percExpectation p f + percExpectation p g := by
  unfold percExpectation
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro ω _
  ring

/-- **Linearity of `E_{G_p}` — scalar multiplication.**  `E_{G_p}[a · f] =
    a · E_{G_p}[f]`.  Pull the scalar through the weighted sum. -/
theorem percExpectation_smul {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (a : ℝ) (f : BondConfig E → ℝ) :
    percExpectation p (fun ω => a * f ω) =
      a * percExpectation p f := by
  unfold percExpectation
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro ω _
  ring

/-- **Monotonicity of `E_{G_p}` in the integrand.**  If `f ω ≤ g ω`
    pointwise then `E_{G_p}[f] ≤ E_{G_p}[g]`.  The general
    integrand-monotonicity statement behind the one-sided envelope
    lemmas. -/
theorem percExpectation_mono {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) (f g : BondConfig E → ℝ)
    (hfg : ∀ ω : BondConfig E, f ω ≤ g ω) :
    percExpectation p f ≤ percExpectation p g := by
  unfold percExpectation
  apply Finset.sum_le_sum
  intro ω _
  exact mul_le_mul_of_nonneg_left (hfg ω)
    (bondConfigWeight_nonneg p hp0 hp1 ω)

/-- **Bridge to the finite Bernoulli-product expectation package.**
    The paper-facing finite bond-percolation expectation `percExpectation`
    is exactly the Infrastructure Bernoulli-product expectation over the
    same Boolean configuration space. -/
theorem percExpectation_eq_bernoulliProductExpectation
    {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (f : BondConfig E → ℝ) :
    percExpectation p f =
      Infrastructure.bernoulliProductExpectation p f := by
  unfold percExpectation Infrastructure.bernoulliProductExpectation
  apply Finset.sum_congr rfl
  intro ω _
  rw [bondConfigWeight_eq_bernoulliWeight_univ]

/-- **Finite bond-percolation expectation monotonicity in `p`.**
    For every coordinatewise monotone observable on finite bond
    configurations, `E_{G_p}[f]` is non-decreasing in the open-edge
    probability `p`. -/
theorem percExpectation_mono_in_p_of_BoolConfigMonotone
    {E : Type} [Fintype E] [DecidableEq E]
    {p_low p_high : ℝ}
    (h_low_nonneg : 0 ≤ p_low) (h_mono : p_low ≤ p_high)
    (h_high_le_one : p_high ≤ 1)
    (f : BondConfig E → ℝ)
    (hf : Infrastructure.BoolConfigMonotone f) :
    percExpectation p_low f ≤ percExpectation p_high f := by
  calc
    percExpectation p_low f
        = Infrastructure.bernoulliProductExpectation p_low f :=
          percExpectation_eq_bernoulliProductExpectation p_low f
    _ ≤ Infrastructure.bernoulliProductExpectation p_high f := by
          exact Infrastructure.bernoulliProductExpectation_mono_of_monotone
            (E := E) h_low_nonneg h_mono h_high_le_one f hf
    _ = percExpectation p_high f :=
          (percExpectation_eq_bernoulliProductExpectation p_high f).symm

/-- **ContinuousOn preservation by `E_{G_p}`** (Cat 1, kernel-pure).
    If for each percolation realisation `ω`, the integrand `f β ω` is
    continuous in `β` on `S ⊆ ℝ`, then the percolation expectation
    `percExpectation p (f β)` is also continuous on `S`.

    Cat 1 derivation via Mathlib's `ContinuousOn.finset_sum` over the
    finite `BondConfig E` carrier: per-term `bondConfigWeight p ω *
    f β ω` is `continuousOn` (constant times continuous), and finite-
    sum of `continuousOn` functions is `continuousOn`.

    Foundation lemma for closing `aboveThresholdWelfare_continuousOn`-
    style claims by lifting per-realisation kernel continuity to
    integrated welfare continuity. -/
theorem percExpectation_continuousOn_of_pointwise_continuousOn
    {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (f : ℝ → BondConfig E → ℝ) (S : Set ℝ)
    (h_ptwise : ∀ ω : BondConfig E,
      ContinuousOn (fun β => f β ω) S) :
    ContinuousOn (fun β => percExpectation p (f β)) S := by
  unfold percExpectation
  apply continuousOn_finsetSum
  intro ω _
  exact (h_ptwise ω).const_smul (bondConfigWeight p ω)

/-- **Filter.Tendsto preservation by `E_{G_p}`** — finite-sample
    bounded-convergence theorem on the bond-percolation expectation.
    If for each percolation realisation `ω`, the integrand sequence
    `f β ω` converges to `g ω` as `β` evolves along filter `l`, then
    the percolation expectation `percExpectation p (f β)` converges to
    `percExpectation p g` along the same filter.

    Cat 1 derivation via Mathlib's `tendsto_finsetSum` over the finite
    `BondConfig E` carrier: per-term `bondConfigWeight p ω * f β ω →
    bondConfigWeight p ω * g ω` (continuous-mult); finite-sum
    aggregation preserves the limit.

    Foundation lemma for the reversal-of-monotonicity convergence
    pattern — the strict-`<` analogue of `percExpectation_lt_of_pointwise_le_strict_at_one`
    converted to a Tendsto-preservation statement, enabling closure of
    Tendsto-style welfare-convergence atoms. -/
theorem percExpectation_tendsto_of_pointwise_tendsto
    {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (f : ℝ → BondConfig E → ℝ) (g : BondConfig E → ℝ)
    (l : Filter ℝ)
    (h_ptwise : ∀ ω : BondConfig E,
      Filter.Tendsto (fun β => f β ω) l (nhds (g ω))) :
    Filter.Tendsto (fun β => percExpectation p (f β)) l
      (nhds (percExpectation p g)) := by
  unfold percExpectation
  apply tendsto_finsetSum
  intro ω _
  exact (h_ptwise ω).const_mul (bondConfigWeight p ω)

/-- **STRICT monotonicity of `E_{G_p}` in the integrand** — the
    foundation lemma for the reversal-witness integration pattern.
    If `f ω ≤ g ω` pointwise AND `f ω₀ < g ω₀` strictly at some
    single `ω₀`, then under non-trivial open-edge probability
    `p ∈ (0, 1)` the strict pointwise inequality at `ω₀` lifts to a
    strict expectation inequality `E_{G_p}[f] < E_{G_p}[g]`.

    Why: the expectation is `∑ ω, w(ω) · h(ω)` with `h := g - f ≥ 0`
    pointwise and `h ω₀ > 0`; under `0 < p < 1` we have
    `0 < w(ω₀)` (`bondConfigWeight_pos`), so the `ω₀` term
    contributes a strict positive amount to the sum, while every
    other term is `≥ 0`.  This is the strict-`<` analogue of
    `percExpectation_mono` and is what every "reversal lifts
    pointwise → reversal lifts in expectation" argument needs.

    Mathlib lemma: `Finset.sum_lt_sum_of_nonempty` with a strict-at-
    one + everywhere-`≤` partition; we use the explicit `lt_iff_le_and_ne`
    decomposition (`≤` from `Finset.sum_le_sum`; `≠` from the strict
    contribution at `ω₀`). -/
theorem percExpectation_lt_of_pointwise_le_strict_at_one
    {E : Type} [Fintype E] [DecidableEq E]
    (p : ℝ) (hp0 : 0 < p) (hp1 : p < 1) (f g : BondConfig E → ℝ)
    (hfg : ∀ ω : BondConfig E, f ω ≤ g ω)
    (ω₀ : BondConfig E) (hω₀ : f ω₀ < g ω₀) :
    percExpectation p f < percExpectation p g := by
  unfold percExpectation
  -- Pointwise per-term inequality `w * f ≤ w * g`.
  have h_term_le : ∀ ω : BondConfig E,
      bondConfigWeight p ω * f ω ≤ bondConfigWeight p ω * g ω := by
    intro ω
    exact mul_le_mul_of_nonneg_left (hfg ω)
      (bondConfigWeight_nonneg p hp0.le hp1.le ω)
  -- Strict at ω₀: positive weight × strict pointwise gap.
  have hw₀ : 0 < bondConfigWeight p ω₀ := bondConfigWeight_pos p hp0 hp1 ω₀
  have h_term_strict :
      bondConfigWeight p ω₀ * f ω₀ < bondConfigWeight p ω₀ * g ω₀ :=
    mul_lt_mul_of_pos_left hω₀ hw₀
  -- Lift via Finset.sum_lt_sum_of_lt_of_le (everywhere `≤`, one strict `<`).
  exact Finset.sum_lt_sum (fun ω _ => h_term_le ω)
    ⟨ω₀, Finset.mem_univ _, h_term_strict⟩

/-! ## 5. Restricted (sub-event) expectation `E_{G_p}[· ; S]` and the
   cluster-size partition.

The §3.3 below-threshold envelope bounds are NOT unconditional: paper
Proposition `prop:topo-cluster` Part 1 / Theorem 3.3 Part 1 (lines
286, 404, 415-419) establish `E[|W_topo|] = O(1/n)` only *conditional
on the giant-component event* `|R(v_0)| = Θ(n)` — a single
small-cluster realisation has topological loss up to `1`, so the
`1/(n+1)` bound is FALSE pointwise and FALSE unconditionally
(the `1 - θ(1-p)` fraction of non-giant-component agents carry
`Θ(1)` loss).

To express the paper's genuine conditional claim, this section builds
the **sub-event expectation** `percRestrictedExpectation p S f`
(the weighted sum over an event `S : Finset (BondConfig E)`) and the
**cluster-size partition** of the full expectation into its
sub-event pieces, indexed by the value of a `ℕ`-valued functional
(`clusterSizeOf`) on the percolation realisation.  This is exactly
the "partition the sample space by `|R(v_0)| = k`" decomposition the
paper's proof opens with (line 292: "conditioning on `|R(v_0)| = k`").
-/

/-- The bond-percolation expectation of `f` **restricted to a
    sub-event** `S : Finset (BondConfig E)`:
    `E_{G_p}[f ; S] = ∑ ω ∈ S, bondConfigWeight p ω * f ω`.

    Paper Proposition `prop:topo-cluster` proof line 292 conditions
    `E[|W_topo|]` on the event `{|R(v_0)| = k}`; the unnormalised
    sub-event expectation `E_{G_p}[f ; S]` is the building block of
    that conditioning — `percExpectation p f` is `E_{G_p}[f ; univ]`,
    and the conditional expectation `E[f | S]` is
    `E_{G_p}[f ; S] / P(S)` where `P(S) = E_{G_p}[1 ; S]`.

    We work with the *unnormalised* sub-event expectation: the paper's
    below-threshold envelope claim `E[|W_topo|] ≤ 1/(n+1)` is, read
    faithfully, the bound on the giant-component sub-event expectation
    (the conditional bound `E[· | giant] ≤ 1/(n+1)` is recovered by
    dividing by `θ(1-p) > 0`, and the unnormalised form is the one
    that composes cleanly with the partition identity below). -/
noncomputable def percRestrictedExpectation {E : Type} [Fintype E]
    [DecidableEq E] (p : ℝ) (S : Finset (BondConfig E))
    (f : BondConfig E → ℝ) : ℝ :=
  ∑ ω ∈ S, bondConfigWeight p ω * f ω

/-- `E_{G_p}[f ; univ] = E_{G_p}[f]`: the sub-event expectation over
    the whole sample space is the ordinary expectation. -/
theorem percRestrictedExpectation_univ {E : Type} [Fintype E]
    [DecidableEq E] (p : ℝ) (f : BondConfig E → ℝ) :
    percRestrictedExpectation p Finset.univ f = percExpectation p f := by
  unfold percRestrictedExpectation percExpectation
  rfl

/-- Positive unnormalised event mass forces the finite event to contain an
    actual realisation.

    This is a kernel-pure finite-sum guardrail for paper-semantic bridges:
    whenever a bridge advertises positive `E_{G_p}[1 ; S]`, downstream gates
    may require an explicit `ω ∈ S` witness rather than treating the positive
    mass as a prose-only non-vacuity claim. -/
theorem percRestrictedExpectation_const_one_pos_event_nonempty {E : Type}
    [Fintype E] [DecidableEq E] (p : ℝ) (S : Finset (BondConfig E))
    (hpos : 0 < percRestrictedExpectation p S
      (fun _ : BondConfig E => (1 : ℝ))) :
    S.Nonempty := by
  unfold percRestrictedExpectation at hpos
  change 0 < S.sum
    (fun ω =>
      bondConfigWeight p ω *
        ((fun _ : BondConfig E => (1 : ℝ)) ω)) at hpos
  have hlt :
      S.sum (fun _ : BondConfig E => (0 : ℝ)) <
        S.sum
          (fun ω =>
            bondConfigWeight p ω *
              ((fun _ : BondConfig E => (1 : ℝ)) ω)) := by
    simpa using hpos
  rcases Finset.exists_lt_of_sum_lt hlt with ⟨ω, hω, _hterm⟩
  exact ⟨ω, hω⟩

/-- **Sub-event monotonicity — upper bound.**  If `f` is pointwise
    bounded above by a *non-negative* constant `c` **on the sub-event
    `S`** (`f ω ≤ c` for `ω ∈ S`), then the sub-event expectation is
    bounded above by `c`:  `E_{G_p}[f ; S] ≤ c`.

    The non-negativity hypothesis `0 ≤ c` is genuinely needed: the
    bound drops the (non-negative-weighted) terms outside `S`, so it
    only holds when the retained terms sum to `≤ c` — which follows
    from `∑ ω ∈ S, weight ≤ ∑ ω, weight = 1` (sub-event probability
    `≤ 1`) times `c ≥ 0`.  This is the precise tool for the paper's
    *conditional* envelope bound: paper bounds `|W_topo|` per
    realisation **on the giant-component event**, then sums the
    sub-event weights (which total the giant-component probability
    `θ(1-p) ≤ 1`). -/
theorem percRestrictedExpectation_le_of_pointwise_le_on {E : Type}
    [Fintype E] [DecidableEq E] (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (S : Finset (BondConfig E)) (f : BondConfig E → ℝ) (c : ℝ)
    (hc : 0 ≤ c) (hf : ∀ ω ∈ S, f ω ≤ c) :
    percRestrictedExpectation p S f ≤ c := by
  unfold percRestrictedExpectation
  -- `∑_{ω ∈ S} w ω * f ω ≤ ∑_{ω ∈ S} w ω * c` (pointwise on `S`)
  have hstep1 :
      (∑ ω ∈ S, bondConfigWeight p ω * f ω)
        ≤ ∑ ω ∈ S, bondConfigWeight p ω * c := by
    apply Finset.sum_le_sum
    intro ω hω
    exact mul_le_mul_of_nonneg_left (hf ω hω)
      (bondConfigWeight_nonneg p hp0 hp1 ω)
  -- `∑_{ω ∈ S} w ω * c = (∑_{ω ∈ S} w ω) * c ≤ (∑_{ω} w ω) * c = 1 * c = c`
  have hstep2 :
      (∑ ω ∈ S, bondConfigWeight p ω * c)
        ≤ (∑ ω : BondConfig E, bondConfigWeight p ω) * c := by
    rw [← Finset.sum_mul]
    apply mul_le_mul_of_nonneg_right _ hc
    apply Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ S)
    intro ω _ _
    exact bondConfigWeight_nonneg p hp0 hp1 ω
  calc ∑ ω ∈ S, bondConfigWeight p ω * f ω
      ≤ ∑ ω ∈ S, bondConfigWeight p ω * c := hstep1
    _ ≤ (∑ ω : BondConfig E, bondConfigWeight p ω) * c := hstep2
    _ = 1 * c := by rw [bondMeasureTotal_eq_one]
    _ = c := one_mul c

/-- **Sub-event monotonicity - lower bound.**  If `f` is pointwise
    bounded below by `c` on the sub-event `S`, then the restricted
    expectation of the constant `c` over `S` is below the restricted
    expectation of `f` over `S`.

    This preserves the event mass instead of normalising it away. -/
theorem percRestrictedExpectation_ge_of_pointwise_ge_on {E : Type}
    [Fintype E] [DecidableEq E] (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (S : Finset (BondConfig E)) (f : BondConfig E → ℝ) (c : ℝ)
    (hf : ∀ ω ∈ S, c ≤ f ω) :
    percRestrictedExpectation p S (fun _ : BondConfig E => c) ≤
      percRestrictedExpectation p S f := by
  unfold percRestrictedExpectation
  apply Finset.sum_le_sum
  intro ω hω
  exact mul_le_mul_of_nonneg_left (hf ω hω)
    (bondConfigWeight_nonneg p hp0 hp1 ω)

/-- **Linearity of restricted expectation - scalar multiplication.**
    `E_{G_p}[a * f ; S] = a * E_{G_p}[f ; S]`. -/
theorem percRestrictedExpectation_smul {E : Type}
    [Fintype E] [DecidableEq E] (p : ℝ)
    (S : Finset (BondConfig E)) (a : ℝ) (f : BondConfig E → ℝ) :
    percRestrictedExpectation p S (fun ω => a * f ω) =
      a * percRestrictedExpectation p S f := by
  unfold percRestrictedExpectation
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro ω _hω
  ring

/-- **Finite subadditivity of event mass.**  The unnormalised Bernoulli
    mass of a union of two finite events is at most the sum of their masses. -/
theorem percRestrictedExpectation_union_const_one_le {E : Type}
    [Fintype E] [DecidableEq E] (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (S T : Finset (BondConfig E)) :
    percRestrictedExpectation p (S ∪ T)
        (fun _ : BondConfig E => (1 : ℝ)) ≤
      percRestrictedExpectation p S (fun _ : BondConfig E => (1 : ℝ)) +
        percRestrictedExpectation p T (fun _ : BondConfig E => (1 : ℝ)) := by
  unfold percRestrictedExpectation
  have hsum := Finset.sum_union_inter
    (s₁ := S) (s₂ := T)
    (f := fun ω : BondConfig E => bondConfigWeight p ω * (1 : ℝ))
  have hinter_nonneg :
      0 ≤ ∑ ω ∈ S ∩ T, bondConfigWeight p ω * (1 : ℝ) := by
    apply Finset.sum_nonneg
    intro ω _hω
    exact mul_nonneg (bondConfigWeight_nonneg p hp0 hp1 ω) zero_le_one
  linarith

/-- **Finite union bound.**  The mass of a finite union of events is at most
    the sum of the individual event masses. -/
theorem percRestrictedExpectation_biUnion_const_one_le_sum
    {E α : Type} [Fintype E] [DecidableEq E] [DecidableEq α]
    (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (I : Finset α) (S : α → Finset (BondConfig E)) :
    percRestrictedExpectation p (I.biUnion S)
        (fun _ : BondConfig E => (1 : ℝ)) ≤
      ∑ i ∈ I,
        percRestrictedExpectation p (S i)
          (fun _ : BondConfig E => (1 : ℝ)) := by
  classical
  induction I using Finset.induction_on with
  | empty =>
      simp [percRestrictedExpectation]
  | insert a I ha ih =>
      have hunion :=
        percRestrictedExpectation_union_const_one_le
          p hp0 hp1 (S a) (I.biUnion S)
      calc
        percRestrictedExpectation p ((insert a I).biUnion S)
            (fun _ : BondConfig E => (1 : ℝ))
            =
          percRestrictedExpectation p (S a ∪ I.biUnion S)
            (fun _ : BondConfig E => (1 : ℝ)) := by
              simp
        _ ≤
          percRestrictedExpectation p (S a)
              (fun _ : BondConfig E => (1 : ℝ)) +
            percRestrictedExpectation p (I.biUnion S)
              (fun _ : BondConfig E => (1 : ℝ)) := hunion
        _ ≤
          percRestrictedExpectation p (S a)
              (fun _ : BondConfig E => (1 : ℝ)) +
            ∑ i ∈ I,
              percRestrictedExpectation p (S i)
                (fun _ : BondConfig E => (1 : ℝ)) := by
              exact add_le_add_right ih _
        _ =
          ∑ i ∈ insert a I,
            percRestrictedExpectation p (S i)
              (fun _ : BondConfig E => (1 : ℝ)) := by
              simp [ha]

/-- **Finite open-edge event mass.**  In a finite Bernoulli product over
    bond configurations, the unnormalised restricted expectation of the
    constant `1` on the event that every edge in a finite set `A` is open
    is exactly `p ^ A.card`.

    This packages the independence/marginalisation step for later path and
    rectangle events: fixing finitely many edge coordinates to `true`
    contributes one factor of `p` per fixed coordinate, while all remaining
    coordinates sum to `1`. -/
theorem percRestrictedExpectation_open_edgeSet_const_one {E : Type}
    [Fintype E] [DecidableEq E] (p : ℝ) (A : Finset E) :
    percRestrictedExpectation p
      (Finset.univ.filter (fun omega : BondConfig E =>
        ∀ e, Membership.mem A e -> omega e = true))
      (fun _ : BondConfig E => (1 : ℝ)) = p ^ A.card := by
  classical
  let g : E → Bool → ℝ := fun e b =>
    if Membership.mem A e then (if b then p else 0)
    else if b then p else 1 - p
  have hfactor :
      (Finset.univ.sum (fun omega : BondConfig E =>
        Finset.univ.prod (fun e : E => g e (omega e)))) =
        Finset.univ.sum (fun omega : BondConfig E =>
          if (∀ e, Membership.mem A e -> omega e = true)
          then bondConfigWeight p omega else 0) := by
    apply Finset.sum_congr rfl
    intro omega _homega
    by_cases hopen : ∀ e, Membership.mem A e -> omega e = true
    case pos =>
      rw [if_pos hopen]
      unfold bondConfigWeight
      apply Finset.prod_congr rfl
      intro e _he
      unfold g
      by_cases heA : Membership.mem A e
      case pos =>
        simp [heA, hopen e heA]
      case neg =>
        simp [heA]
    case neg =>
      have hex : ∃ e, Membership.mem A e ∧ Not (omega e = true) := by
        by_contra hno
        apply hopen
        intro e heA
        by_cases htrue : omega e = true
        case pos =>
          exact htrue
        case neg =>
          exfalso
          exact hno (Exists.intro e (And.intro heA htrue))
      cases hex with
      | intro e0 hexrest =>
          cases hexrest with
          | intro he0A hfalse =>
              rw [if_neg hopen]
              apply Finset.prod_eq_zero (i := e0) (Finset.mem_univ e0)
              unfold g
              simp [he0A, hfalse]
  have hprod_sum :
      (Finset.univ.prod
        (fun e : E => Finset.univ.sum (fun b : Bool => g e b))) =
        Finset.univ.sum (fun omega : BondConfig E =>
          Finset.univ.prod (fun e : E => g e (omega e))) := by
    simpa using (Fintype.prod_sum g)
  have hsum_edge : ∀ e : E,
      (Finset.univ.sum (fun b : Bool => g e b)) =
        (if Membership.mem A e then p else 1) := by
    intro e
    unfold g
    by_cases heA : Membership.mem A e
    case pos =>
      simp [heA]
    case neg =>
      simp [heA]
  have hprod_eval :
      (Finset.univ.prod
        (fun e : E => Finset.univ.sum (fun b : Bool => g e b))) =
        p ^ A.card := by
    let f : E → ℝ := fun e => if Membership.mem A e then p else 1
    have hsubset : A.prod f = Finset.univ.prod f := by
      apply Finset.prod_subset (Finset.subset_univ A)
      intro e _he_univ he_notA
      simp [he_notA]
    calc
      (Finset.univ.prod
          (fun e : E => Finset.univ.sum (fun b : Bool => g e b)))
          = Finset.univ.prod f := by
            apply Finset.prod_congr rfl
            intro e _he
            exact hsum_edge e
      _ = A.prod f := hsubset.symm
      _ = p ^ A.card := by
            simp [f]
  unfold percRestrictedExpectation
  rw [Finset.sum_filter]
  simp only [mul_one]
  calc
    Finset.univ.sum (fun omega : BondConfig E =>
        (if (∀ e, Membership.mem A e -> omega e = true)
          then bondConfigWeight p omega else 0)) =
        Finset.univ.sum (fun omega : BondConfig E =>
          Finset.univ.prod (fun e : E => g e (omega e))) := hfactor.symm
    _ =
        Finset.univ.prod
          (fun e : E => Finset.univ.sum (fun b : Bool => g e b)) :=
            hprod_sum.symm
    _ = p ^ A.card := hprod_eval

/-- **Finite closed-edge event mass.**  In a finite Bernoulli product over
    bond configurations, the unnormalised restricted expectation of the
    constant `1` on the event that every edge in a finite set `A` is closed
    is exactly `(1 - p) ^ A.card`.

    This is the closed-edge analogue of
    `percRestrictedExpectation_open_edgeSet_const_one`. -/
theorem percRestrictedExpectation_closed_edgeSet_const_one {E : Type}
    [Fintype E] [DecidableEq E] (p : ℝ) (A : Finset E) :
    percRestrictedExpectation p
      (Finset.univ.filter (fun omega : BondConfig E =>
        ∀ e, Membership.mem A e -> omega e = false))
      (fun _ : BondConfig E => (1 : ℝ)) = (1 - p) ^ A.card := by
  classical
  let g : E -> Bool -> ℝ := fun e b =>
    if Membership.mem A e then (if b then 0 else 1 - p)
    else if b then p else 1 - p
  have hfactor :
      (Finset.univ.sum (fun omega : BondConfig E =>
        Finset.univ.prod (fun e : E => g e (omega e)))) =
        Finset.univ.sum (fun omega : BondConfig E =>
          if (∀ e, Membership.mem A e -> omega e = false)
          then bondConfigWeight p omega else 0) := by
    apply Finset.sum_congr rfl
    intro omega _homega
    by_cases hclosed : ∀ e, Membership.mem A e -> omega e = false
    case pos =>
      rw [if_pos hclosed]
      unfold bondConfigWeight
      apply Finset.prod_congr rfl
      intro e _he
      unfold g
      by_cases heA : Membership.mem A e
      case pos =>
        simp [heA, hclosed e heA]
      case neg =>
        simp [heA]
    case neg =>
      have hex : ∃ e, Membership.mem A e ∧ Not (omega e = false) := by
        by_contra hno
        apply hclosed
        intro e heA
        by_cases hfalse : omega e = false
        case pos =>
          exact hfalse
        case neg =>
          exfalso
          exact hno (Exists.intro e (And.intro heA hfalse))
      cases hex with
      | intro e0 hexrest =>
          cases hexrest with
          | intro he0A hnotFalse =>
              rw [if_neg hclosed]
              apply Finset.prod_eq_zero (i := e0) (Finset.mem_univ e0)
              unfold g
              simp [he0A, hnotFalse]
  have hprod_sum :
      (Finset.univ.prod
        (fun e : E => Finset.univ.sum (fun b : Bool => g e b))) =
        Finset.univ.sum (fun omega : BondConfig E =>
          Finset.univ.prod (fun e : E => g e (omega e))) := by
    simpa using (Fintype.prod_sum g)
  have hsum_edge : ∀ e : E,
      (Finset.univ.sum (fun b : Bool => g e b)) =
        (if Membership.mem A e then 1 - p else 1) := by
    intro e
    unfold g
    by_cases heA : Membership.mem A e
    case pos =>
      simp [heA]
    case neg =>
      simp [heA]
  have hprod_eval :
      (Finset.univ.prod
        (fun e : E => Finset.univ.sum (fun b : Bool => g e b))) =
        (1 - p) ^ A.card := by
    let f : E -> ℝ := fun e => if Membership.mem A e then 1 - p else 1
    have hsubset : A.prod f = Finset.univ.prod f := by
      apply Finset.prod_subset (Finset.subset_univ A)
      intro e _he_univ he_notA
      simp [he_notA]
    calc
      (Finset.univ.prod
          (fun e : E => Finset.univ.sum (fun b : Bool => g e b)))
          = Finset.univ.prod f := by
            apply Finset.prod_congr rfl
            intro e _he
            exact hsum_edge e
      _ = A.prod f := hsubset.symm
      _ = (1 - p) ^ A.card := by
            simp [f]
  unfold percRestrictedExpectation
  rw [Finset.sum_filter]
  simp only [mul_one]
  calc
    Finset.univ.sum (fun omega : BondConfig E =>
        (if (∀ e, Membership.mem A e -> omega e = false)
          then bondConfigWeight p omega else 0)) =
        Finset.univ.sum (fun omega : BondConfig E =>
          Finset.univ.prod (fun e : E => g e (omega e))) := hfactor.symm
    _ =
        Finset.univ.prod
          (fun e : E => Finset.univ.sum (fun b : Bool => g e b)) :=
            hprod_sum.symm
    _ = (1 - p) ^ A.card := hprod_eval

/-- **Two-open-edge event mass.**  In a finite Bernoulli product over
    bond configurations, the unnormalised restricted expectation of the
    constant `1` on the event that two distinct edges are both open is
    exactly `p * p`.

    This is the finite-product independence calculation needed to turn a
    pointwise cluster lower bound on a two-edge local event into an explicit
    probabilistic lower bound. -/
theorem percRestrictedExpectation_two_open_edges_const_one {E : Type}
    [Fintype E] [DecidableEq E] (p : ℝ) {e1 e2 : E}
    (hne : Not (e1 = e2)) :
    percRestrictedExpectation p
      (Finset.univ.filter (fun omega : BondConfig E =>
        omega e1 = true /\ omega e2 = true))
      (fun _ : BondConfig E => (1 : ℝ)) = p * p := by
  have hne' : Not (e2 = e1) := by
    intro h
    exact hne h.symm
  have hmass :=
    percRestrictedExpectation_open_edgeSet_const_one
      p ({e1, e2} : Finset E)
  simpa [hne, hne', Finset.card_pair hne, pow_two] using hmass

/-- Event-mass monotonicity for finite Bernoulli products. -/
theorem percRestrictedExpectation_const_one_mono_event {E : Type}
    [Fintype E] [DecidableEq E] (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    {S T : Finset (BondConfig E)}
    (hST : ∀ omega, Membership.mem S omega -> Membership.mem T omega) :
    percRestrictedExpectation p S
        (fun _ : BondConfig E => (1 : ℝ)) ≤
      percRestrictedExpectation p T
        (fun _ : BondConfig E => (1 : ℝ)) := by
  unfold percRestrictedExpectation
  exact Finset.sum_le_sum_of_subset_of_nonneg hST (by
    intro omega _hT _hnotS
    exact mul_nonneg (bondConfigWeight_nonneg p hp0 hp1 omega) zero_le_one)

/-- The expectation of an event indicator is the restricted expectation of
    the constant `1` on that event. -/
theorem percExpectation_indicator_eq_restrictedExpectation_const_one
    {E : Type} [Fintype E] [DecidableEq E] (p : ℝ)
    (S : Finset (BondConfig E)) :
    percExpectation p
        (fun omega : BondConfig E =>
          if Membership.mem S omega then (1 : ℝ) else 0) =
      percRestrictedExpectation p S
        (fun _ : BondConfig E => (1 : ℝ)) := by
  classical
  unfold percExpectation percRestrictedExpectation
  calc
    (∑ omega : BondConfig E,
        bondConfigWeight p omega *
          (if Membership.mem S omega then (1 : ℝ) else 0))
        =
      ∑ omega : BondConfig E,
        if Membership.mem S omega then
          bondConfigWeight p omega * (1 : ℝ)
        else
          0 := by
            apply Finset.sum_congr rfl
            intro omega _homega
            by_cases hmem : Membership.mem S omega <;> simp [hmem]
    _ =
      (Finset.univ.filter
          (fun omega : BondConfig E => Membership.mem S omega)).sum
        (fun omega => bondConfigWeight p omega * (1 : ℝ)) := by
            rw [Finset.sum_filter]
    _ = ∑ omega ∈ S, bondConfigWeight p omega * (1 : ℝ) := by
            have hfilter :
                (Finset.univ.filter
                  (fun omega : BondConfig E => Membership.mem S omega)) = S := by
              ext omega
              simp
            rw [hfilter]

/-- The mass of an event plus the mass of its finite-sample-space complement
    is one.  This is the finite Bernoulli-product partition identity used to
    expose success/failure probability decompositions without introducing any
    measure-theoretic primitive beyond the kernel-defined finite sum. -/
theorem percRestrictedExpectation_const_one_add_compl
    {E : Type} [Fintype E] [DecidableEq E] (p : ℝ)
    (S : Finset (BondConfig E)) :
    percRestrictedExpectation p S
        (fun _ : BondConfig E => (1 : ℝ)) +
      percRestrictedExpectation p
        (Finset.univ.filter (fun omega : BondConfig E =>
          Not (Membership.mem S omega)))
        (fun _ : BondConfig E => (1 : ℝ)) = 1 := by
  classical
  let T := Finset.univ.filter (fun omega : BondConfig E =>
    Not (Membership.mem S omega))
  have hdisj : Disjoint S T := by
    rw [Finset.disjoint_left]
    intro omega hS hT
    simp [T, hS] at hT
  have hunion : S ∪ T = Finset.univ := by
    ext omega
    by_cases hS : Membership.mem S omega
    · simp [T, hS]
    · simp [T, hS]
  unfold percRestrictedExpectation
  rw [← Finset.sum_union hdisj]
  rw [hunion]
  calc
    (∑ omega : BondConfig E, bondConfigWeight p omega * (1 : ℝ)) =
        ∑ omega : BondConfig E, bondConfigWeight p omega := by
          apply Finset.sum_congr rfl
          intro omega _homega
          ring
    _ = 1 := bondMeasureTotal_eq_one p

/-- The mass of the finite-sample-space complement is `1` minus the event
    mass.  This is a restatement of
    `percRestrictedExpectation_const_one_add_compl` in the algebraic form used
    by success/failure event interfaces. -/
theorem percRestrictedExpectation_compl_const_one_eq_one_sub
    {E : Type} [Fintype E] [DecidableEq E] (p : ℝ)
    (S : Finset (BondConfig E)) :
    percRestrictedExpectation p
        (Finset.univ.filter (fun omega : BondConfig E =>
          Not (Membership.mem S omega)))
        (fun _ : BondConfig E => (1 : ℝ)) =
      1 -
        percRestrictedExpectation p S
          (fun _ : BondConfig E => (1 : ℝ)) := by
  have hpartition :=
    percRestrictedExpectation_const_one_add_compl (E := E) p S
  linarith

/-- The open-edge set of a finite bond configuration. -/
def bondOpenEdgeSet {E : Type} [Fintype E]
    (omega : BondConfig E) : Finset E :=
  Finset.univ.filter (fun e : E => omega e = true)

/-- A single edge has open probability `p` under the finite Bernoulli product. -/
theorem percExpectation_open_edge_indicator {E : Type}
    [Fintype E] [DecidableEq E] (p : ℝ) (e0 : E) :
    percExpectation p
      (fun omega : BondConfig E => if omega e0 then (1 : ℝ) else 0) = p := by
  classical
  have hmass := percRestrictedExpectation_open_edgeSet_const_one
    p ({e0} : Finset E)
  unfold percRestrictedExpectation at hmass
  unfold percExpectation
  rw [Finset.sum_filter] at hmass
  simp at hmass
  simpa using hmass

/-- First moment of the number of open edges in the finite Bernoulli product. -/
theorem percExpectation_openEdgeSet_card {E : Type}
    [Fintype E] [DecidableEq E] (p : ℝ) :
    percExpectation p
      (fun omega : BondConfig E => ((bondOpenEdgeSet omega).card : ℝ)) =
      p * (Fintype.card E : ℝ) := by
  classical
  unfold percExpectation
  calc
    (Finset.univ.sum fun omega : BondConfig E =>
        bondConfigWeight p omega * ((bondOpenEdgeSet omega).card : ℝ))
        =
      Finset.univ.sum fun omega : BondConfig E =>
        bondConfigWeight p omega *
          (Finset.univ.sum
            (fun e : E => if omega e then (1 : ℝ) else 0)) := by
          apply Finset.sum_congr rfl
          intro omega _homega
          simp [bondOpenEdgeSet]
    _ =
      Finset.univ.sum fun e : E =>
        Finset.univ.sum fun omega : BondConfig E =>
          bondConfigWeight p omega * (if omega e then (1 : ℝ) else 0) := by
          rw [Finset.sum_comm]
          apply Finset.sum_congr rfl
          intro omega _homega
          rw [Finset.mul_sum]
    _ = Finset.univ.sum fun _e : E => p := by
          apply Finset.sum_congr rfl
          intro e _he
          exact percExpectation_open_edge_indicator p e
    _ = p * (Fintype.card E : ℝ) := by
          rw [Finset.sum_const]
          rw [Fintype.card]
          norm_num
          ring

/-- **The cluster-size partition of the expectation.**  Given a
    `ℕ`-valued functional `κ : BondConfig E → ℕ` on the percolation
    realisation (paper: `κ ω = |R(v_0)|`, the reachable-set
    cardinality on realisation `ω`) **bounded by `N`**
    (`κ ω ≤ N` for all `ω`), the full expectation decomposes as the
    sum, over each possible value `k ∈ {0, …, N}`, of the sub-event
    expectation on the fiber `{ω | κ ω = k}`:
    `E_{G_p}[f] = ∑_{k=0}^{N} E_{G_p}[f ; {ω | κ ω = k}]`.

    This is paper Proposition `prop:topo-cluster` proof line 292's
    opening move — "partition the sample space by `|R(v_0)| = k`" —
    made an exact `Finset` identity via `Finset.sum_fiberwise_of_maps_to`.
    The hypothesis `hκ : ∀ ω, κ ω ≤ N` is the paper-graph fact that
    on `Z²_L` with `L² = n` the reachable set `R(v_0) ⊆ V` has
    `|R(v_0)| ≤ n` (so `N = n` works). -/
theorem percExpectation_eq_sum_clusterSizeFiber {E : Type} [Fintype E]
    [DecidableEq E] (p : ℝ) (f : BondConfig E → ℝ)
    (κ : BondConfig E → ℕ) (N : ℕ) (hκ : ∀ ω : BondConfig E, κ ω ≤ N) :
    percExpectation p f
      = ∑ k ∈ Finset.range (N + 1),
          percRestrictedExpectation p
            (Finset.univ.filter (fun ω => κ ω = k)) f := by
  unfold percExpectation percRestrictedExpectation
  -- `κ` maps `univ` into `range (N+1)` (since `κ ω ≤ N`).
  have hmaps : ∀ ω ∈ (Finset.univ : Finset (BondConfig E)),
      κ ω ∈ Finset.range (N + 1) := by
    intro ω _
    rw [Finset.mem_range]
    exact Nat.lt_succ_of_le (hκ ω)
  -- `Finset.sum_fiberwise_of_maps_to` gives
  --   `∑_{k ∈ range(N+1)} ∑_{ω ∈ univ, κ ω = k} g ω = ∑_{ω ∈ univ} g ω`.
  rw [← Finset.sum_fiberwise_of_maps_to hmaps
        (fun ω => bondConfigWeight p ω * f ω)]

/-- **Sub-event upper bound from the partition.**  If `f` is pointwise
    bounded above by a non-negative constant `c` **on a distinguished
    sub-event `S`**, the sub-event expectation `E_{G_p}[f ; S] ≤ c`.
    This is `percRestrictedExpectation_le_of_pointwise_le_on`
    re-exported as the operative envelope-bound tool — paper's
    "bound `|W_topo|` per realisation on the giant-component event,
    then take the sub-event expectation". -/
theorem percRestrictedExpectation_le_on {E : Type} [Fintype E]
    [DecidableEq E] (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (S : Finset (BondConfig E)) (f : BondConfig E → ℝ) (c : ℝ)
    (hc : 0 ≤ c) (hf : ∀ ω ∈ S, f ω ≤ c) :
    percRestrictedExpectation p S f ≤ c :=
  percRestrictedExpectation_le_of_pointwise_le_on p hp0 hp1 S f c hc hf

/-- **Sub-event expectation is dominated by the full expectation, for a
    pointwise-non-negative functional.**  If `f ω ≥ 0` for every
    realisation `ω`, then the bond-percolation expectation restricted to
    *any* sub-event `S` is at most the full (whole-sample-space)
    expectation:  `E_{G_p}[f ; S] ≤ E_{G_p}[f]`.

    This is the measure-theoretic "monotonicity in the integration
    domain" fact for a non-negative integrand: dropping the
    (non-negative-weighted, non-negative-valued) terms `ω ∉ S` only
    decreases the sum.  Proof: `∑_{ω ∈ S} w ω · f ω ≤ ∑_{ω ∈ univ} w ω
    · f ω` via `Finset.sum_le_sum_of_subset_of_nonneg` (`S ⊆ univ`, each
    dropped term `w ω · f ω ≥ 0` because `w ω ≥ 0` and `f ω ≥ 0`).

    This is the precise tool for an FKG-style "the probability of a
    sub-event is at most the probability of the containing event"
    lower-bound argument: paper `prop:trap-prevalence` proof line 473
    bounds the trap probability below by the probability of a *specific*
    local edge-and-reward configuration sub-event — that sub-event
    probability is `E_{G_p}[trap-indicator ; localConfigEvent]`, which by
    this lemma is `≤ E_{G_p}[trap-indicator] =` the full trap
    probability. -/
theorem percRestrictedExpectation_le_percExpectation_of_nonneg {E : Type}
    [Fintype E] [DecidableEq E] (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (S : Finset (BondConfig E)) (f : BondConfig E → ℝ)
    (hf : ∀ ω : BondConfig E, 0 ≤ f ω) :
    percRestrictedExpectation p S f ≤ percExpectation p f := by
  unfold percRestrictedExpectation percExpectation
  apply Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ S)
  intro ω _ _
  exact mul_nonneg (bondConfigWeight_nonneg p hp0 hp1 ω) (hf ω)

end BlackwellDilemma
