/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.GaussianPosterior
import BlackwellDilemma.Infrastructure.FiveStateVDyn
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# `p`-dependent prior mean for the bridge neighbour `u_2` (Cat 1)

This module provides the kernel-pure p-dependent prior expectations
that enter the paper's mean-estimate-gap `m(p, κ)` on the five-state
canonical IDP.

## Paper anchor

Paper Theorem 4.1 Part 4 (line 555):
"On the canonical instance (Section §5.1), the bridge path is open
with probability `1-p`, so `E_p[V_dyn(u_2)]` is strictly decreasing
in `p` while `r(u_1)` is independent of `p`. For each fixed `κ > 0`,
the mean estimate gap `m(κ)` decreases as `p` increases (the prior
assigns lower continuation value to the bridge), shifting `κ*`
rightward."

Paper Proposition `prop:supermodular` footnote (line 600) makes the
formula explicit on a depth-1 subtree under topology noise:
`V_dyn(u | edge open) = r(w)` and `V_dyn(u | edge blocked) = r(u)`,
so the prior-expected dynamic value is the bond-percolation expectation
`E_p[V_dyn(u_2)] = (1-p)·r(w) + p·r(u_2)`.

For the five-state canonical instance (paper §5.1):
* trap `u_1 = A` is terminal: `E_p[V_dyn(u_1)] = r_A = 0.6` (p-independent)
* bridge `u_2 = B` leads to goal `G` (or self-blocks to `B`): the
  bond-percolation prior on the `B → G` edge gives
  `E_p[V_dyn(u_2)] = (1-p)·r_G + p·r_B = (1-p)·1.0 + p·0.4 = 1.0 - 0.6·p`

## Main definitions

* `priorMean_u1_fiveState` — `E_p[V_dyn(u_1)] = r_A = 0.6` (p-independent).
* `priorMean_u2_fiveState p` — `E_p[V_dyn(u_2)] = 1.0 - 0.6·p`
  (linear in p with strictly negative slope `-0.6 = -(r_G - r_B)`).
* `priorGap_fiveState p` — the prior-gap
  `priorMean_u2_fiveState p − priorMean_u1_fiveState = 0.4 − 0.6·p`.

## Main results

* `priorMean_u2_fiveState_antitone_in_p` — `E_p[V_dyn(u_2)]` is
  antitone in p (Mathlib `linarith`).
* `priorGap_fiveState_antitone_in_p` — the prior-gap is antitone in p
  (Mathlib arithmetic).

## Cat 1 status

Built from `FiveStateVDyn` + Mathlib arithmetic. Kernel-pure
(`#print axioms` shows only `[propext, Classical.choice, Quot.sound]`).
No paper-novel axioms, no `sorry`.

## Tags

bond-percolation prior, depth-1 subtree, V_dyn prior expectation,
mean-estimate-gap p-dependence, Cat 1
-/

namespace BlackwellDilemma.Infrastructure.MeanEstimateGap

open BlackwellDilemma.Infrastructure.FiveState

/-! ### `p`-dependent prior expectations on the five-state instance -/

/-- `E_p[V_dyn(u_1)] = r_A = 0.6` (p-independent, terminal trap). -/
noncomputable def priorMean_u1_fiveState : ℝ := r_A

/-- `E_p[V_dyn(u_2)] = (1-p)·r_G + p·r_B = 1.0 - 0.6·p` (p-dependent,
    bridge with depth-1 subtree to goal `G`). -/
noncomputable def priorMean_u2_fiveState (p : ℝ) : ℝ :=
  (1 - p) * (r_G : ℝ) + p * r_B

/-- The prior-gap at the five-state instance:
    `priorMean_u2 p - priorMean_u1 = 0.4 - 0.6·p`. -/
noncomputable def priorGap_fiveState (p : ℝ) : ℝ :=
  priorMean_u2_fiveState p - priorMean_u1_fiveState

/-! ### Explicit closed-form values (Cat 1 via `norm_num`) -/

/-- `priorMean_u1_fiveState = 0.6`. -/
theorem priorMean_u1_fiveState_eq :
    priorMean_u1_fiveState = (6 : ℝ) / 10 := by
  unfold priorMean_u1_fiveState r_A
  rfl

/-- `priorMean_u2_fiveState p = 1 - (6/10)·p` (closed form). -/
theorem priorMean_u2_fiveState_eq (p : ℝ) :
    priorMean_u2_fiveState p = 1 - (6 : ℝ) / 10 * p := by
  unfold priorMean_u2_fiveState r_G r_B
  ring

/-- `priorGap_fiveState p = (4/10) - (6/10)·p` (closed form). -/
theorem priorGap_fiveState_eq (p : ℝ) :
    priorGap_fiveState p = (4 : ℝ) / 10 - (6 : ℝ) / 10 * p := by
  unfold priorGap_fiveState
  rw [priorMean_u2_fiveState_eq p, priorMean_u1_fiveState_eq]
  ring

/-! ### Antitonicity in `p` -/

/-- **`E_p[V_dyn(u_2)]` is antitone in `p`** — Cat 1 via linear
    closed-form. The slope is `-(r_G - r_B) = -0.6 < 0`. -/
theorem priorMean_u2_fiveState_antitone_in_p
    (p₁ p₂ : ℝ) (h : p₁ ≤ p₂) :
    priorMean_u2_fiveState p₂ ≤ priorMean_u2_fiveState p₁ := by
  rw [priorMean_u2_fiveState_eq, priorMean_u2_fiveState_eq]
  linarith

/-- **`priorMean_u1_fiveState` is constant in `p`** — Cat 1
    immediate. The terminal trap has no continuation. -/
theorem priorMean_u1_fiveState_const_in_p (p₁ p₂ : ℝ) :
    priorMean_u1_fiveState = priorMean_u1_fiveState := rfl

/-- **`priorGap_fiveState` is antitone in `p`** — Cat 1 via
    linear closed-form. -/
theorem priorGap_fiveState_antitone_in_p
    (p₁ p₂ : ℝ) (h : p₁ ≤ p₂) :
    priorGap_fiveState p₂ ≤ priorGap_fiveState p₁ := by
  rw [priorGap_fiveState_eq, priorGap_fiveState_eq]
  linarith

/-! ### Gaussian-posterior application

The κ-agent's estimate `V̂_κ(u_i) = E[V_dyn(u_i) | ω̂_κ]` is the
Gaussian conjugate-prior posterior mean under prior `N(μ₀, τ₀²)` (the
bond-percolation prior on edge states) and Gaussian topology noise
with variance `σ_topo²(κ, d)` (the effective per-observation noise,
which decreases as κ increases — paper line 549). On the five-state
instance with `μ₀ = E_p[V_dyn(u_i)]`, `τ₀² = 1`, signal data mean
`ybar = V_dyn(u_i)` (the truth observable as κ → ∞), and
per-observation noise `τ² = 1`, the conjugate-prior formula gives

  `μ_post(u_i, κ) = (1·κ·V_dyn(u_i) + 1·E_p[V_dyn(u_i)]) / (1·κ + 1)`
                  ` = (κ · V_dyn(u_i) + E_p[V_dyn(u_i)]) / (κ + 1)`.

For the trap `u_1 = A` (terminal): `V_dyn(u_1) = r_A = 0.6` and
`E_p[V_dyn(u_1)] = r_A = 0.6`, so `μ_post(u_1, κ) = 0.6` (constant in
κ and p — the prior and the data mean agree because the trap has no
continuation).

For the bridge `u_2 = B`: `V_dyn(u_2) = r_G = 1.0` (observable truth
at κ → ∞) and `E_p[V_dyn(u_2)] = 1 - 0.6·p` (prior at κ → 0+), so
`μ_post(u_2, κ) = (κ + 1 - 0.6·p) / (κ + 1)`.

This module's lemmas plug into `GaussianPosterior.gaussianPosteriorMean`
(per-term constants `(mu0, tau0sq, tausq, ybar)` chosen per `u_i`)
to derive the paper-faithful `m(p, κ) = E[V̂_κ(u_2)] − E[V̂_κ(u_1)]`
with genuine p-dependence routed through `priorMean_u2_fiveState`. -/

/-! ### Kernel-purity audit -/

#print axioms priorMean_u2_fiveState_antitone_in_p
#print axioms priorGap_fiveState_antitone_in_p

end BlackwellDilemma.Infrastructure.MeanEstimateGap
