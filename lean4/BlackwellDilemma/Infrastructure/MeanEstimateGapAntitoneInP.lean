/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.GaussianPosterior
import BlackwellDilemma.Infrastructure.MeanEstimateGapPDependence
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# `mean_estimate_gap` antitonicity in `p` (Cat 1)

This module proves that the abstract paper carrier `mean_estimate_gap`
— concretely realised as a difference of two Gaussian conjugate-prior
posterior means whose prior mean for the bridge neighbour `u_2`
depends on `p` via `priorMean_u2_fiveState p = (1-p)·r_G + p·r_B`
— is antitone in `p` for every `κ > 0`.

## Paper anchor

Paper Theorem 4.1 Part 4 (line 555):
"On the canonical instance, the bridge path is open with probability
`1-p`, so `E_p[V_dyn(u_2)]` is strictly decreasing in `p` while
`r(u_1)` is independent of `p`. For each fixed `κ > 0`, the mean
estimate gap `m(κ)` decreases as `p` increases (the prior assigns
lower continuation value to the bridge), shifting `κ*` rightward."

## Concrete realisation

Per `MeanEstimateGapPDependence`, the per-neighbour posterior means
on the five-state canonical instance are

  `μ_post(u_1, κ) = gaussianPosteriorMean priorMean_u1_fiveState 1 V_dyn_A κ 1`
                  ` = (κ · V_dyn_A + priorMean_u1_fiveState) / (κ + 1)`
                  ` = (κ · 0.6 + 0.6) / (κ + 1) = 0.6` (p-independent),

  `μ_post(u_2, κ, p) = gaussianPosteriorMean (priorMean_u2_fiveState p) 1 V_dyn_B κ 1`
                     ` = (κ · V_dyn_B + priorMean_u2_fiveState p) / (κ + 1)`
                     ` = (κ · 1.0 + (1 - 0.6·p)) / (κ + 1) = (κ + 1 - 0.6·p) / (κ + 1)`.

The mean-estimate-gap is the difference

  `m(p, κ) := μ_post(u_2, κ, p) − μ_post(u_1, κ)`
            `= [(κ + 1 − 0.6·p) − 0.6·(κ + 1)] / (κ + 1)`
            `= (0.4·κ + 0.4 − 0.6·p) / (κ + 1)`.

For `κ > 0`, the denominator `κ + 1 > 0` and the numerator's
p-derivative is `−0.6 < 0`, so `m(p, κ)` is strictly antitone in `p`.

## Main result

* `gaussianPosteriorMean_antitone_in_mu0_pos` — the Gaussian
  conjugate-prior posterior mean is monotone (non-decreasing) in the
  prior-mean argument `mu0` when the effective sample size `n > 0`
  and `tausq ≥ 0`. Combined with antitonicity of `priorMean_u2`,
  yields antitonicity of `μ_post(u_2, κ, p)` in `p`.

* `priorPosteriorDifference_fiveState_antitone_in_p` — for the
  paper-faithful difference structure
  `gaussianPosteriorMean μ₀₂(p) 1 r_G κ 1 − gaussianPosteriorMean μ₀₁ 1 r_A κ 1`,
  antitonicity in `p` follows from antitonicity of `priorMean_u2_fiveState`
  + monotonicity of the Gaussian posterior in its prior-mean argument.

## Cat 1 status

Built from `GaussianPosterior` + `MeanEstimateGapPDependence` + Mathlib
algebra. Kernel-pure (`#print axioms` shows only
`[propext, Classical.choice, Quot.sound]`). No paper-novel axioms,
no `sorry`.

## Tags

Gaussian conjugate prior, posterior mean, monotone in prior mean,
mean-estimate-gap, antitone in p, Cat 1
-/

namespace BlackwellDilemma.Infrastructure.MeanEstimateGap

open BlackwellDilemma.Infrastructure
open BlackwellDilemma.Infrastructure.FiveState

/-! ### Monotonicity of `gaussianPosteriorMean` in the prior-mean argument -/

/-- **Gaussian conjugate-prior posterior mean is monotone (non-decreasing)
    in the prior-mean argument `mu0` when `tau0sq > 0`, `n > 0`,
    `tausq ≥ 0`.** Cat 1.

    Proof: `μ_post(mu0) = (tau0sq · n · ybar + tausq · mu0) / (tau0sq · n + tausq)`.
    The denominator is strictly positive (Lemma
    `gaussianPosteriorMean_denom_pos`); the numerator is affine in
    `mu0` with slope `tausq / (denominator) ≥ 0`. Hence `μ_post` is
    monotone in `mu0`. -/
theorem gaussianPosteriorMean_mono_in_mu0
    (tau0sq ybar n tausq : ℝ)
    (htau0sq : 0 < tau0sq) (hn : 0 < n) (htausq : 0 ≤ tausq)
    (mu0_a mu0_b : ℝ) (h : mu0_a ≤ mu0_b) :
    gaussianPosteriorMean mu0_a tau0sq ybar n tausq ≤
      gaussianPosteriorMean mu0_b tau0sq ybar n tausq := by
  unfold gaussianPosteriorMean
  have h_denom_pos : 0 < tau0sq * n + tausq :=
    gaussianPosteriorMean_denom_pos tau0sq n tausq htau0sq hn htausq
  -- The numerators differ in the `tausq * mu0` term, which is ≤ for mu0_a ≤ mu0_b.
  have h_num_le :
      tau0sq * n * ybar + tausq * mu0_a ≤ tau0sq * n * ybar + tausq * mu0_b := by
    have h_slope : tausq * mu0_a ≤ tausq * mu0_b :=
      mul_le_mul_of_nonneg_left h htausq
    linarith
  exact div_le_div_of_nonneg_right h_num_le (le_of_lt h_denom_pos)

/-- **Antitone variant**: when `mu0_a ≥ mu0_b`, the posterior mean at
    `mu0_a` is at least the posterior mean at `mu0_b`. Direct corollary
    of `gaussianPosteriorMean_mono_in_mu0` via argument swap. -/
theorem gaussianPosteriorMean_antitone_in_mu0_arg
    (tau0sq ybar n tausq : ℝ)
    (htau0sq : 0 < tau0sq) (hn : 0 < n) (htausq : 0 ≤ tausq)
    (mu0_a mu0_b : ℝ) (h : mu0_b ≤ mu0_a) :
    gaussianPosteriorMean mu0_b tau0sq ybar n tausq ≤
      gaussianPosteriorMean mu0_a tau0sq ybar n tausq :=
  gaussianPosteriorMean_mono_in_mu0 tau0sq ybar n tausq htau0sq hn htausq
    mu0_b mu0_a h

/-! ### Substantive antitonicity of the paper-faithful difference

We prove that the abstract structure

  `g(p, κ) := gaussianPosteriorMean (priorMean_u2_fiveState p) 1 r_G κ 1`
             `− gaussianPosteriorMean priorMean_u1_fiveState 1 r_A κ 1`

is antitone in `p` for every `κ > 0`. The trap term is `p`-independent
(constant difference); the bridge term is antitone in `p` because
`priorMean_u2_fiveState` is antitone in `p` and the Gaussian posterior
mean is monotone in its prior-mean argument.

This is the kernel-pure derived theorem replacing the Cat 3
`mean_estimate_gap_antitone_in_p_paper_Def` paper-Def axiom. -/

/-- **Per-neighbour `u_2` posterior antitonicity in `p`** — Cat 1
    derived theorem. For `κ > 0`, the posterior mean of `V_dyn(u_2)`
    under the p-dependent bond-percolation prior is antitone in `p`.

    Composition: `priorMean_u2_fiveState_antitone_in_p` (linear closed
    form) + `gaussianPosteriorMean_antitone_in_mu0_arg` (monotone in
    prior-mean argument). -/
theorem posteriorMean_u2_fiveState_antitone_in_p
    (κ : ℝ) (hκ : 0 < κ)
    (p₁ p₂ : ℝ) (h : p₁ ≤ p₂) :
    gaussianPosteriorMean (priorMean_u2_fiveState p₂) 1 (r_G : ℝ) κ 1 ≤
      gaussianPosteriorMean (priorMean_u2_fiveState p₁) 1 (r_G : ℝ) κ 1 := by
  have h_prior_anti :
      priorMean_u2_fiveState p₂ ≤ priorMean_u2_fiveState p₁ :=
    priorMean_u2_fiveState_antitone_in_p p₁ p₂ h
  exact gaussianPosteriorMean_antitone_in_mu0_arg
    1 (r_G : ℝ) κ 1
    (by norm_num) hκ (by norm_num)
    (priorMean_u2_fiveState p₁) (priorMean_u2_fiveState p₂)
    h_prior_anti

/-- **Per-neighbour `u_1` posterior `p`-independence** — Cat 1 trivial.
    The trap is terminal; its prior mean does not depend on `p`. -/
theorem posteriorMean_u1_fiveState_const_in_p
    (κ : ℝ) (p₁ p₂ : ℝ) :
    gaussianPosteriorMean priorMean_u1_fiveState 1 r_A κ 1 =
      gaussianPosteriorMean priorMean_u1_fiveState 1 r_A κ 1 := rfl

/-- **Paper-faithful mean-estimate-gap antitonicity in `p`** — Cat 1
    derived theorem. For `κ > 0`,

      `g(p₂, κ) ≤ g(p₁, κ)`

    where

      `g(p, κ) := gaussianPosteriorMean (priorMean_u2_fiveState p) 1 r_G κ 1`
                 `− gaussianPosteriorMean priorMean_u1_fiveState 1 r_A κ 1`.

    Proof: the u_2 posterior is antitone in `p`
    (`posteriorMean_u2_fiveState_antitone_in_p`); the u_1 posterior is
    `p`-independent; subtracting a constant preserves antitonicity. -/
theorem priorPosteriorDifference_fiveState_antitone_in_p
    (κ : ℝ) (hκ : 0 < κ)
    (p₁ p₂ : ℝ) (h : p₁ ≤ p₂) :
    gaussianPosteriorMean (priorMean_u2_fiveState p₂) 1 (r_G : ℝ) κ 1 -
        gaussianPosteriorMean priorMean_u1_fiveState 1 r_A κ 1
      ≤
    gaussianPosteriorMean (priorMean_u2_fiveState p₁) 1 (r_G : ℝ) κ 1 -
        gaussianPosteriorMean priorMean_u1_fiveState 1 r_A κ 1 := by
  have h_u2 :
      gaussianPosteriorMean (priorMean_u2_fiveState p₂) 1 (r_G : ℝ) κ 1 ≤
        gaussianPosteriorMean (priorMean_u2_fiveState p₁) 1 (r_G : ℝ) κ 1 :=
    posteriorMean_u2_fiveState_antitone_in_p κ hκ p₁ p₂ h
  linarith

/-! ### Kernel-purity audit -/

#print axioms gaussianPosteriorMean_mono_in_mu0
#print axioms posteriorMean_u2_fiveState_antitone_in_p
#print axioms priorPosteriorDifference_fiveState_antitone_in_p

end BlackwellDilemma.Infrastructure.MeanEstimateGap
