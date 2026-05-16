/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import BlackwellDilemma.Infrastructure.GaussianPosterior
import Mathlib.Topology.Order.Basic
import Mathlib.Order.Filter.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Topology.Algebra.Order.Field
import Mathlib.Algebra.Order.Field.Basic

/-!
# Gaussian conjugate-prior posterior asymptotic data dominance (Cat 1)

This module extends `GaussianPosterior.lean` with the **asymptotic
data dominance** result:

**As the effective sample size `n → ∞`, the Gaussian conjugate-prior
posterior mean converges to the data mean `ybar`** (the prior is
washed out by the accumulating data).

This is the canonical Bayesian asymptotic theory: with `μ_post =
(τ₀² · n · ȳ + τ² · μ₀) / (τ₀² · n + τ²)`, dividing numerator and
denominator by `τ₀² · n` gives `μ_post = (ȳ + (τ²/(τ₀²·n)) · μ₀) /
(1 + τ²/(τ₀²·n))`. As `n → ∞`, the `τ²/(τ₀²·n) → 0`, so `μ_post → ȳ`.

This is the foundational Cat 1 piece for paper's
`mean_estimate_gap_tendsto_mLimit` claim (paper Theorem 4.1 Part 3
line 505 `m(κ) → V_dyn(u_2) − V_dyn(u_1)` as κ → ∞).

## Main result

* `gaussianPosteriorMean_tendsto_data_mean_atTop_n` — as `n → ∞`
  with all other parameters fixed and `τ₀² > 0, τ² ≥ 0`, the posterior
  mean tends to the data mean `ybar`.

## Cat 1 status

Built only from `GaussianPosterior` + Mathlib. Kernel-pure
(`#print axioms` shows only `[propext, Classical.choice, Quot.sound]`).
No paper-novel axioms, no `sorry`. Generic on `ℝ`.

## Future Mathlib PR

Suggested namespace: `Mathlib.Probability.Bayesian.Gaussian` or
`Mathlib.Statistics.ConjugatePrior.Gaussian`. The data-dominance
asymptotic is a canonical Bayesian statistics result.

## Tags

Gaussian, conjugate prior, posterior mean, asymptotic, data dominance,
Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open Filter Topology

/-- **Asymptotic data dominance for Gaussian conjugate-prior posterior**:
    as the effective sample size `n → ∞` (with all other parameters
    fixed and `τ₀² > 0, τ² ≥ 0`), the posterior mean tends to the
    data mean `ybar`.

    Proof: rewrite `μ_post = ybar + τ² · (μ₀ - ybar) / (τ₀² · n + τ²)`.
    The second term has the form `c / (a · n + b)` where `a > 0`,
    so it tends to 0 as `n → ∞`. Hence `μ_post → ybar`.

    Cat 1: kernel-pure. -/
theorem gaussianPosteriorMean_tendsto_data_mean_atTop_n
    (mu0 tau0sq ybar tausq : ℝ) (htau0sq : 0 < tau0sq) (htausq : 0 ≤ tausq) :
    Filter.Tendsto (fun n : ℝ => gaussianPosteriorMean mu0 tau0sq ybar n tausq)
      Filter.atTop (nhds ybar) := by
  -- Rewrite μ_post as ybar + correction(n) where correction(n) → 0.
  -- gaussianPosteriorMean mu0 tau0sq ybar n tausq
  --   = (tau0sq · n · ybar + tausq · mu0) / (tau0sq · n + tausq)
  --   = ybar + tausq · (mu0 - ybar) / (tau0sq · n + tausq)
  -- because: ybar = ybar · (tau0sq · n + tausq) / (tau0sq · n + tausq)
  --   = (tau0sq · n · ybar + tausq · ybar) / (tau0sq · n + tausq)
  --   so (post mean) - ybar = (tausq · mu0 - tausq · ybar) / (denom)
  --   = tausq · (mu0 - ybar) / denom.
  -- As n → ∞, denom → ∞, so correction → 0 (provided tau0sq > 0).
  have h_eq : ∀ n : ℝ, 0 < n →
      gaussianPosteriorMean mu0 tau0sq ybar n tausq =
        ybar + tausq * (mu0 - ybar) / (tau0sq * n + tausq) := by
    intro n hn
    unfold gaussianPosteriorMean
    have h_denom_pos : 0 < tau0sq * n + tausq :=
      gaussianPosteriorMean_denom_pos tau0sq n tausq htau0sq hn htausq
    have h_denom_ne : tau0sq * n + tausq ≠ 0 := ne_of_gt h_denom_pos
    field_simp
    ring
  -- Use the eventually form of the equality (eventually n > 0 in atTop).
  have h_eventually : ∀ᶠ n in Filter.atTop,
      gaussianPosteriorMean mu0 tau0sq ybar n tausq =
        ybar + tausq * (mu0 - ybar) / (tau0sq * n + tausq) := by
    filter_upwards [Filter.eventually_gt_atTop (0 : ℝ)] with n hn
    exact h_eq n hn
  -- It suffices to show the rewritten form tends to ybar.
  rw [Filter.tendsto_congr' h_eventually]
  -- Show ybar + correction(n) → ybar by showing correction(n) → 0.
  -- ybar = ybar + 0; lift via Tendsto.add with const + correction-→-0.
  have h_correction_tendsto : Filter.Tendsto
      (fun n : ℝ => tausq * (mu0 - ybar) / (tau0sq * n + tausq))
      Filter.atTop (nhds 0) := by
    have h_denom_tendsto : Filter.Tendsto (fun n : ℝ => tau0sq * n + tausq)
        Filter.atTop Filter.atTop := by
      have h_mul_tendsto : Filter.Tendsto (fun n : ℝ => tau0sq * n)
          Filter.atTop Filter.atTop :=
        Filter.Tendsto.const_mul_atTop htau0sq Filter.tendsto_id
      exact Filter.Tendsto.atTop_add h_mul_tendsto tendsto_const_nhds
    have h_inv_tendsto : Filter.Tendsto
        (fun n : ℝ => (tau0sq * n + tausq)⁻¹)
        Filter.atTop (nhds 0) := tendsto_inv_atTop_zero.comp h_denom_tendsto
    have h_eq : (fun n : ℝ => tausq * (mu0 - ybar) / (tau0sq * n + tausq))
        = fun n => tausq * (mu0 - ybar) * (tau0sq * n + tausq)⁻¹ := by
      funext n
      ring
    rw [h_eq]
    have h_zero_eq : (0 : ℝ) = tausq * (mu0 - ybar) * 0 := by ring
    rw [h_zero_eq]
    exact Filter.Tendsto.const_mul _ h_inv_tendsto
  -- Now: ybar + correction(n) → ybar + 0 = ybar
  have h_target_tendsto : Filter.Tendsto
      (fun n : ℝ => ybar + tausq * (mu0 - ybar) / (tau0sq * n + tausq))
      Filter.atTop (nhds (ybar + 0)) :=
    Filter.Tendsto.add tendsto_const_nhds h_correction_tendsto
  -- ybar + 0 = ybar
  have h_simp : ybar + (0 : ℝ) = ybar := by ring
  rw [h_simp] at h_target_tendsto
  exact h_target_tendsto

/-! ### Kernel-purity audit

`#print axioms` on `gaussianPosteriorMean_tendsto_data_mean_atTop_n`
surfaces ONLY Mathlib kernel axioms (`propext, Classical.choice,
Quot.sound`) — no paper-novel `Types.lean` carriers, no broken-link
`_OPEN` axioms, no `sorry`. This is the foundational Cat 1 piece for
the asymptotic data dominance of Gaussian conjugate-prior posterior
means, providing what paper's `mean_estimate_gap_tendsto_mLimit` claim
reduces to once the opaque carrier is bridged via a paper-Def atom. -/

#print axioms gaussianPosteriorMean_tendsto_data_mean_atTop_n

end BlackwellDilemma.Infrastructure
