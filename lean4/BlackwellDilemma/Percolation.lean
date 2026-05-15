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
  Harris–Kesten `p_c = 1/2`.  Per `feedback_no_compute_retreat` ("Mathlib
  doesn't have bond percolation → DEFINE a paper-faithful finite-graph
  bond-percolation framework locally"), this module **constructs** the finite
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

/-- Each per-edge factor lies in `[0, 1]` when `p ∈ [0, 1]`. -/
theorem bondConfig_factor_mem {E : Type} (p : ℝ)
    (hp0 : 0 ≤ p) (hp1 : p ≤ 1) (ω : BondConfig E) (e : E) :
    0 ≤ (if ω e then p else 1 - p) ∧ (if ω e then p else 1 - p) ≤ 1 := by
  by_cases h : ω e
  · simp [h]; exact ⟨hp0, hp1⟩
  · simp [h]; constructor <;> linarith

/-- The bond-percolation weight is non-negative: it is a product of
    non-negative per-edge factors. -/
theorem bondConfigWeight_nonneg {E : Type} [Fintype E] (p : ℝ)
    (hp0 : 0 ≤ p) (hp1 : p ≤ 1) (ω : BondConfig E) :
    0 ≤ bondConfigWeight p ω := by
  unfold bondConfigWeight
  apply Finset.prod_nonneg
  intro e _
  exact (bondConfig_factor_mem p hp0 hp1 ω e).1

/-- The bond-percolation weight is at most `1`: it is a product of
    per-edge factors each in `[0, 1]`. -/
theorem bondConfigWeight_le_one {E : Type} [Fintype E] (p : ℝ)
    (hp0 : 0 ≤ p) (hp1 : p ≤ 1) (ω : BondConfig E) :
    bondConfigWeight p ω ≤ 1 := by
  unfold bondConfigWeight
  calc ∏ e : E, (if ω e then p else 1 - p)
      ≤ ∏ _e : E, (1 : ℝ) := by
        apply Finset.prod_le_prod
        · intro e _; exact (bondConfig_factor_mem p hp0 hp1 ω e).1
        · intro e _; exact (bondConfig_factor_mem p hp0 hp1 ω e).2
    _ = 1 := by simp

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

end BlackwellDilemma
