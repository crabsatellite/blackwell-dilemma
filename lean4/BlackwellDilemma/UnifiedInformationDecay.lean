/-
  BlackwellDilemma/UnifiedInformationDecay.lean

  Finite pairwise-Gaussian oracle regret bound and its uniform-in-network
  aggregation. External sources connect independent Gaussian noisy argmax to
  the pairwise-selection interface and supply the uniform first-moment bound.
-/

import BlackwellDilemma.ClassicalResults
import BlackwellDilemma.UnifiedConditionalReduction
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

namespace BlackwellDilemma.InformationDecay

open scoped BigOperators

universe u

private theorem sqrt_two_pi_pos :
    0 < Real.sqrt (2 * Real.pi) :=
  Real.sqrt_pos.mpr (mul_pos (by norm_num) Real.pi_pos)

/-- Mills' bound in the exact payoff-gap form used by the oracle regret
    calculation. -/
theorem gap_mul_Phi_neg_div_le_noise
    (gap noise : Real) (hGap : 0 <= gap) (hNoise : 0 < noise) :
    gap * Phi (-(gap / noise)) <= noise / Real.sqrt (2 * Real.pi) := by
  by_cases hGapZero : gap = 0
  · subst gap
    have hNonneg := div_nonneg hNoise.le sqrt_two_pi_pos.le
    simpa using hNonneg
  have hGapPos : 0 < gap := lt_of_le_of_ne hGap (Ne.symm hGapZero)
  have hXPos : 0 < gap / noise := div_pos hGapPos hNoise
  have hTail := gap_phi_tail_bound (gap / noise) hXPos
  have hExpLe :
      Real.exp (-((gap / noise) ^ 2 / 2)) <= 1 := by
    rw [show (1 : Real) = Real.exp 0 from Real.exp_zero.symm]
    apply Real.exp_monotone
    have hSq : 0 <= (gap / noise) ^ 2 := sq_nonneg _
    linarith
  calc
    gap * Phi (-(gap / noise)) <=
        gap * ((1 / ((gap / noise) * Real.sqrt (2 * Real.pi))) *
          Real.exp (-((gap / noise) ^ 2 / 2))) :=
      mul_le_mul_of_nonneg_left hTail hGap
    _ = (noise / Real.sqrt (2 * Real.pi)) *
          Real.exp (-((gap / noise) ^ 2 / 2)) := by
      field_simp [hGapPos.ne', hNoise.ne', sqrt_two_pi_pos.ne']
    _ <= noise / Real.sqrt (2 * Real.pi) := by
      simpa using mul_le_mul_of_nonneg_left hExpLe
        (div_nonneg hNoise.le sqrt_two_pi_pos.le)

/-- A finite reachable-set oracle problem. -/
structure FiniteOracleEnvironment where
  Action : Type u
  actionFintype : Fintype Action
  actionDecidableEq : DecidableEq Action
  reward : Action -> Real
  best : Action
  best_is_max : forall action, reward action <= reward best

namespace FiniteOracleEnvironment

instance (E : FiniteOracleEnvironment) : Fintype E.Action :=
  E.actionFintype

instance (E : FiniteOracleEnvironment) : DecidableEq E.Action :=
  E.actionDecidableEq

def gap (E : FiniteOracleEnvironment) (action : E.Action) : Real :=
  E.reward E.best - E.reward action

theorem gap_nonneg (E : FiniteOracleEnvironment) (action : E.Action) :
    0 <= E.gap action :=
  sub_nonneg.mpr (E.best_is_max action)

@[simp]
theorem gap_best (E : FiniteOracleEnvironment) : E.gap E.best = 0 := by
  simp [gap]

def card (E : FiniteOracleEnvironment) : Nat :=
  Fintype.card E.Action

end FiniteOracleEnvironment

/-- Selection probabilities on one fixed reachable action set, with the exact
    pairwise-Gaussian bound needed by the regret proof. This is an explicit
    model interface; construction from independent Gaussian random variables
    is reference-gated rather than hidden in the structure name. -/
structure GaussianSelection (E : FiniteOracleEnvironment) (noise : Real) where
  prob : E.Action -> Real
  prob_nonneg : forall action, 0 <= prob action
  prob_sum_one : Finset.univ.sum prob = 1
  prob_le_pairwise : forall action, Not (action = E.best) ->
    prob action <= Phi (-(E.gap action / noise))

namespace GaussianSelection

variable {E : FiniteOracleEnvironment} {noise : Real}

noncomputable def expectedReward (S : GaussianSelection E noise) : Real :=
  Finset.univ.sum (fun action => S.prob action * E.reward action)

noncomputable def regret (S : GaussianSelection E noise) : Real :=
  E.reward E.best - S.expectedReward

theorem regret_eq_sum_gap (S : GaussianSelection E noise) :
    S.regret = Finset.univ.sum (fun action => S.prob action * E.gap action) := by
  have hBest :
      E.reward E.best =
        Finset.univ.sum (fun action => S.prob action * E.reward E.best) := by
    rw [<- Finset.sum_mul, S.prob_sum_one, one_mul]
  unfold regret expectedReward
  rw [hBest, <- Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro action _
  unfold FiniteOracleEnvironment.gap
  ring

theorem regret_nonneg (S : GaussianSelection E noise) : 0 <= S.regret := by
  rw [S.regret_eq_sum_gap]
  exact Finset.sum_nonneg (fun action _ =>
    mul_nonneg (S.prob_nonneg action) (E.gap_nonneg action))

theorem regret_le_card_mul_noise
    (S : GaussianSelection E noise) (hNoise : 0 < noise) :
    S.regret <= (E.card : Real) * (noise / Real.sqrt (2 * Real.pi)) := by
  rw [S.regret_eq_sum_gap]
  calc
    Finset.univ.sum (fun action => S.prob action * E.gap action) <=
        Finset.univ.sum (fun _action : E.Action =>
          noise / Real.sqrt (2 * Real.pi)) := by
      apply Finset.sum_le_sum
      intro action _
      by_cases hBest : action = E.best
      · subst action
        have hNonneg := div_nonneg hNoise.le sqrt_two_pi_pos.le
        simpa using hNonneg
      · have hProb := S.prob_le_pairwise action hBest
        have hGap := E.gap_nonneg action
        calc
          S.prob action * E.gap action <=
              Phi (-(E.gap action / noise)) * E.gap action :=
            mul_le_mul_of_nonneg_right hProb hGap
          _ = E.gap action * Phi (-(E.gap action / noise)) := by ring
          _ <= noise / Real.sqrt (2 * Real.pi) :=
            gap_mul_Phi_neg_div_le_noise (E.gap action) noise hGap hNoise
    _ = (E.card : Real) * (noise / Real.sqrt (2 * Real.pi)) := by
      simp [FiniteOracleEnvironment.card]

end GaussianSelection

/-- Percolation realizations and their finite reachable-set oracle problems for
    one network size. -/
structure NetworkOracleEnvironment where
  Outcome : Type u
  outcomeFintype : Fintype Outcome
  distribution :
    @ConditionalReduction.FiniteDistribution Outcome outcomeFintype
  oracle : Outcome -> FiniteOracleEnvironment

namespace NetworkOracleEnvironment

instance (N : NetworkOracleEnvironment) : Fintype N.Outcome :=
  N.outcomeFintype

noncomputable def expectedCard (N : NetworkOracleEnvironment) : Real :=
  Finset.univ.sum (fun outcome =>
    N.distribution.prob outcome * (N.oracle outcome).card)

end NetworkOracleEnvironment

/-- Gaussian oracle selections on every reachable-set realization of one
    network. -/
structure GaussianNetworkSelection
    (N : NetworkOracleEnvironment) (noise : Real) where
  selection : forall outcome, GaussianSelection (N.oracle outcome) noise

namespace GaussianNetworkSelection

variable {N : NetworkOracleEnvironment} {noise : Real}

noncomputable def expectedRegret (S : GaussianNetworkSelection N noise) : Real :=
  Finset.univ.sum (fun outcome =>
    N.distribution.prob outcome * (S.selection outcome).regret)

noncomputable def informationComponent
    (S : GaussianNetworkSelection N noise) : Real :=
  -S.expectedRegret

theorem expectedRegret_nonneg (S : GaussianNetworkSelection N noise) :
    0 <= S.expectedRegret := by
  unfold expectedRegret
  exact Finset.sum_nonneg (fun outcome _ =>
    mul_nonneg (N.distribution.prob_nonneg outcome)
      (S.selection outcome).regret_nonneg)

theorem informationComponent_nonpos (S : GaussianNetworkSelection N noise) :
    S.informationComponent <= 0 := by
  unfold informationComponent
  exact neg_nonpos.mpr S.expectedRegret_nonneg

theorem abs_informationComponent_eq_expectedRegret
    (S : GaussianNetworkSelection N noise) :
    abs S.informationComponent = S.expectedRegret := by
  rw [abs_of_nonpos S.informationComponent_nonpos]
  simp [informationComponent]

theorem expectedRegret_le_expectedCard_mul_noise
    (S : GaussianNetworkSelection N noise) (hNoise : 0 < noise) :
    S.expectedRegret <=
      N.expectedCard * (noise / Real.sqrt (2 * Real.pi)) := by
  unfold expectedRegret NetworkOracleEnvironment.expectedCard
  calc
    Finset.univ.sum (fun outcome =>
        N.distribution.prob outcome * (S.selection outcome).regret) <=
        Finset.univ.sum (fun outcome =>
          N.distribution.prob outcome *
            ((N.oracle outcome).card *
              (noise / Real.sqrt (2 * Real.pi)))) := by
      apply Finset.sum_le_sum
      intro outcome _
      exact mul_le_mul_of_nonneg_left
        ((S.selection outcome).regret_le_card_mul_noise hNoise)
        (N.distribution.prob_nonneg outcome)
    _ = (Finset.univ.sum (fun outcome =>
          N.distribution.prob outcome * (N.oracle outcome).card)) *
            (noise / Real.sqrt (2 * Real.pi)) := by
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro outcome _
      ring

end GaussianNetworkSelection

/-- Standard deviation of the difference between two independent reward
    signals under the manuscript variance normalization. -/
noncomputable def signalNoise (beta : Real) : Real :=
  Real.sqrt (2 * signalVariance beta)

theorem signalNoise_pos {beta : Real} (hBeta : 0 < beta) :
    0 < signalNoise beta := by
  unfold signalNoise signalVariance
  have hPow : (1 : Real) < (2 : Real) ^ (2 * beta) :=
    Real.one_lt_rpow (by norm_num) (by linarith)
  exact Real.sqrt_pos.mpr (mul_pos (by norm_num) (one_div_pos.mpr (by linarith)))

/-- Explicit version of `signalNoise beta = O(2^(-beta))`. -/
theorem signalNoise_le_two_mul_rpow_neg
    {beta : Real} (hBeta : 1 <= beta) :
    signalNoise beta <= 2 * (2 : Real) ^ (-beta) := by
  let a : Real := (2 : Real) ^ (2 * beta)
  have hApos : 0 < a := by
    dsimp [a]
    positivity
  have hA_ge_four : 4 <= a := by
    have hExp : (2 : Real) <= 2 * beta := by linarith
    have h := Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : Real) <= 2) hExp
    norm_num [Real.rpow_natCast] at h
    exact h
  have hDenomPos : 0 < a - 1 := by linarith
  have hVarianceBound : 2 / (a - 1) <= 4 / a := by
    apply (div_le_div_iff₀ hDenomPos hApos).2
    nlinarith
  have hAPow : a = ((2 : Real) ^ beta) ^ 2 := by
    dsimp [a]
    calc
      (2 : Real) ^ (2 * beta) = (2 : Real) ^ (beta * 2) := by
        congr 1
        ring
      _ = ((2 : Real) ^ beta) ^ (2 : Real) :=
        Real.rpow_mul (by norm_num) beta 2
      _ = ((2 : Real) ^ beta) ^ 2 := Real.rpow_two _
  have hUpperSq :
      (2 * (2 : Real) ^ (-beta)) ^ 2 = 4 / a := by
    rw [Real.rpow_neg (by norm_num : (0 : Real) <= 2)]
    rw [mul_pow, inv_pow, <- hAPow]
    field_simp [hApos.ne']
    norm_num
  have hUpperNonneg : 0 <= 2 * (2 : Real) ^ (-beta) := by positivity
  apply (Real.sqrt_le_left hUpperNonneg).2
  rw [hUpperSq]
  simpa [signalNoise, signalVariance, a] using hVarianceBound

/-- Uniform-in-network oracle information-decay theorem. The hypothesis
    `expectedCard <= C` is exactly the first-moment consequence supplied by
    the cited subcritical cluster-tail theorem when `p > p_c`. -/
theorem uniform_information_decay
    (network : Nat -> NetworkOracleEnvironment)
    (selection : forall n beta,
      GaussianNetworkSelection (network n) (signalNoise beta))
    (C : Real) (hC : 0 <= C)
    (hCard : forall n, (network n).expectedCard <= C) :
    forall n beta, 1 <= beta ->
      (selection n beta).informationComponent <= 0 /\
      abs (selection n beta).informationComponent <=
        (2 * C / Real.sqrt (2 * Real.pi)) * (2 : Real) ^ (-beta) := by
  intro n beta hBeta
  have hBetaPos : 0 < beta := lt_of_lt_of_le (by norm_num) hBeta
  have hNoisePos := signalNoise_pos hBetaPos
  refine ⟨(selection n beta).informationComponent_nonpos, ?_⟩
  rw [(selection n beta).abs_informationComponent_eq_expectedRegret]
  calc
    (selection n beta).expectedRegret <=
        (network n).expectedCard *
          (signalNoise beta / Real.sqrt (2 * Real.pi)) :=
      (selection n beta).expectedRegret_le_expectedCard_mul_noise hNoisePos
    _ <= C * (signalNoise beta / Real.sqrt (2 * Real.pi)) := by
      exact mul_le_mul_of_nonneg_right (hCard n)
        (div_nonneg hNoisePos.le sqrt_two_pi_pos.le)
    _ <= C * ((2 * (2 : Real) ^ (-beta)) /
          Real.sqrt (2 * Real.pi)) := by
      exact mul_le_mul_of_nonneg_left
        (div_le_div_of_nonneg_right
          (signalNoise_le_two_mul_rpow_neg hBeta) sqrt_two_pi_pos.le) hC
    _ = (2 * C / Real.sqrt (2 * Real.pi)) * (2 : Real) ^ (-beta) := by
      ring

def InformationDecayClaim : Prop :=
  forall
    (network : Nat -> NetworkOracleEnvironment.{0})
    (selection : forall n beta,
      GaussianNetworkSelection.{0} (network n) (signalNoise beta))
    (C : Real),
    0 <= C ->
    (forall n, (network n).expectedCard <= C) ->
    forall n beta, 1 <= beta ->
      (selection n beta).informationComponent <= 0 /\
      abs (selection n beta).informationComponent <=
        (2 * C / Real.sqrt (2 * Real.pi)) * (2 : Real) ^ (-beta)

theorem informationDecayClaim_proved : InformationDecayClaim :=
  uniform_information_decay

end BlackwellDilemma.InformationDecay
