/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Topology.Algebra.Order.Field
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Topology.ContinuousOn

/-!
# Gaussian conjugate-prior posterior mean (Cat 1)

This file provides the **explicit Gaussian conjugate-prior posterior
mean** formula and its continuity properties, which are the
foundational Cat 1 piece that paper's `mean_estimate_gap_continuous`
and `mean_estimate_gap_tendsto_mLimit` axioms reduce to once the
opaque `mean_estimate_gap` carrier is concretised as a function of
posterior moments.

## Main definitions

* `gaussianPosteriorMean mu0 tau0sq ybar n tausq` —
  posterior mean for prior `N(mu0, tau0sq)`, signal mean `ybar` from
  `n` observations with per-observation noise variance `tausq`:
    `mu_post = (tau0sq · n · ybar + tausq · mu0) / (tau0sq · n + tausq)`.

## Main results

* `gaussianPosteriorMean_at_zero_prior_offset` —
  with zero prior mean (`mu0 = 0`), simplification.
* `gaussianPosteriorMean_continuousOn_in_n` —
  continuity in `n > 0` for fixed `mu0, tau0sq, ybar, tausq`.
* `gaussianPosteriorMean_continuousOn_in_signal_variance` —
  continuity in `tausq > 0`.

## Bridge to paper carrier `mean_estimate_gap`

The paper's `mean_estimate_gap p κ` is constructed from the difference
between the posterior mean under the bayesian agent's signal model
(Gaussian conjugate-prior) and a benchmark mean. With `κ` typically
indexing signal precision / sample size, the paper claim reduces to
continuity of the posterior mean in `κ`, which is a direct consequence
of the rational-function form `(num)/(denom)` with `denom > 0`.

## Cat 1 status

Built only from `Mathlib.Topology.Algebra.Order.Field` +
`Mathlib.Analysis.SpecialFunctions.Pow.Real`. No paper-novel axioms,
no `sorry`. The posterior formula + continuity are
Mathlib-PR-contributable as a basic conjugate-prior infrastructure.

## Tags

Gaussian, conjugate prior, posterior mean, continuity, Bayesian,
mean_estimate_gap, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

/-! ### Gaussian conjugate-prior posterior mean -/

/-- **Gaussian conjugate-prior posterior mean.**
    For prior `N(mu0, tau0sq)` and `n` observations with mean `ybar`
    and per-observation noise variance `tausq`, the posterior mean is

      `mu_post = (tau0sq · n · ybar + tausq · mu0) / (tau0sq · n + tausq)`

    This is the standard conjugate-prior formula, derived by completing
    the square in the joint log-posterior. -/
noncomputable def gaussianPosteriorMean
    (mu0 tau0sq ybar n tausq : ℝ) : ℝ :=
  (tau0sq * n * ybar + tausq * mu0) / (tau0sq * n + tausq)

/-- **Posterior mean with zero prior mean.**
    With `mu0 = 0`, the posterior mean simplifies to
    `tau0sq · n · ybar / (tau0sq · n + tausq)`. -/
theorem gaussianPosteriorMean_at_zero_prior_offset
    (tau0sq ybar n tausq : ℝ) :
    gaussianPosteriorMean 0 tau0sq ybar n tausq =
      tau0sq * n * ybar / (tau0sq * n + tausq) := by
  unfold gaussianPosteriorMean
  ring

/-- **Denominator positivity.** With `tau0sq > 0`, `n > 0`, `tausq ≥ 0`,
    the denominator `tau0sq · n + tausq` is strictly positive. -/
theorem gaussianPosteriorMean_denom_pos
    (tau0sq n tausq : ℝ) (htau0sq : 0 < tau0sq) (hn : 0 < n)
    (htausq : 0 ≤ tausq) :
    0 < tau0sq * n + tausq := by
  have h_prod : 0 < tau0sq * n := mul_pos htau0sq hn
  linarith

/-! ### Continuity -/

/-- **Continuity in the sample-size parameter `n`** (for `n > 0`).
    The posterior mean is a rational function of `n` with positive
    denominator on `(0, ∞)`, hence continuous. -/
theorem gaussianPosteriorMean_continuousOn_in_n
    (mu0 tau0sq ybar tausq : ℝ) (htau0sq : 0 < tau0sq)
    (htausq : 0 ≤ tausq) :
    ContinuousOn (fun n : ℝ => gaussianPosteriorMean mu0 tau0sq ybar n tausq)
      (Set.Ioi 0) := by
  unfold gaussianPosteriorMean
  apply ContinuousOn.div
  · refine ContinuousOn.add ?_ continuousOn_const
    refine ContinuousOn.mul ?_ continuousOn_const
    refine ContinuousOn.mul continuousOn_const ?_
    exact continuousOn_id
  · refine ContinuousOn.add ?_ continuousOn_const
    exact ContinuousOn.mul continuousOn_const continuousOn_id
  · intro n hn
    have h_pos :=
      gaussianPosteriorMean_denom_pos tau0sq n tausq htau0sq hn htausq
    linarith

/-- **Continuity in the signal-variance parameter `tausq`** (for `tausq > 0`).
    The posterior mean is a rational function of `tausq` with positive
    denominator. -/
theorem gaussianPosteriorMean_continuousOn_in_signal_variance
    (mu0 tau0sq ybar n : ℝ) (htau0sq : 0 < tau0sq) (hn : 0 < n) :
    ContinuousOn (fun tausq : ℝ => gaussianPosteriorMean mu0 tau0sq ybar n tausq)
      (Set.Ioi 0) := by
  unfold gaussianPosteriorMean
  apply ContinuousOn.div
  · refine ContinuousOn.add continuousOn_const ?_
    exact ContinuousOn.mul continuousOn_id continuousOn_const
  · refine ContinuousOn.add continuousOn_const continuousOn_id
  · intro tausq htausq
    have h_pos :=
      gaussianPosteriorMean_denom_pos tau0sq n tausq htau0sq hn (le_of_lt htausq)
    linarith

/-! ### Kernel-purity audit

`#print axioms` on `gaussianPosteriorMean_continuousOn_in_n` surfaces
ONLY Mathlib kernel axioms (`propext, Classical.choice, Quot.sound`)
— no paper-novel `Types.lean` carriers, no broken-link `_OPEN` axioms,
no `sorry`. This provides the explicit Gaussian conjugate-prior
infrastructure that paper's opaque `mean_estimate_gap` carrier reduces
to once the bayesian agent's signal model is concretised. -/

#print axioms gaussianPosteriorMean_continuousOn_in_n

end BlackwellDilemma.Infrastructure
