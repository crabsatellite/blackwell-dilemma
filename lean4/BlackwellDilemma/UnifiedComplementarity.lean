/-
  BlackwellDilemma/UnifiedComplementarity.lean

  Exact calculus for the manuscript's Bayesian-greedy population mixture.
  The greedy derivative sign is kernel proved on the concrete five-state
  carrier. The Bayesian monotonicity input remains the explicit Blackwell
  1953 reference premise from UnifiedBayesianImmunity.
-/

import BlackwellDilemma.UnifiedBayesianImmunity
import BlackwellDilemma.UnifiedInterior

namespace BlackwellDilemma.Complementarity

open BayesianImmunity
open FiveStateRouting

universe u v w x

/-- Welfare for a population share `lambda` of Bayesian agents and a
    complementary share of greedy agents. -/
noncomputable def populationWelfare
    (bayesianWelfare greedyWelfare : Real -> Real)
    (beta lambda : Real) : Real :=
  lambda * bayesianWelfare beta + (1 - lambda) * greedyWelfare beta

theorem populationWelfare_hasDerivAt_beta
    {bayesianWelfare greedyWelfare : Real -> Real}
    {beta dBayesian dGreedy : Real}
    (hBayesian : HasDerivAt bayesianWelfare dBayesian beta)
    (hGreedy : HasDerivAt greedyWelfare dGreedy beta)
    (lambda : Real) :
    HasDerivAt
      (fun beta' =>
        populationWelfare bayesianWelfare greedyWelfare beta' lambda)
      (lambda * dBayesian + (1 - lambda) * dGreedy) beta := by
  simpa [populationWelfare] using
    (hBayesian.const_mul lambda).add (hGreedy.const_mul (1 - lambda))

/-- The derivative in population composition of the marginal precision
    effect equals the difference between the two agent-level derivatives. -/
theorem populationWelfare_hasMixedDerivAt
    {bayesianWelfare greedyWelfare : Real -> Real}
    {beta dBayesian dGreedy : Real}
    (hBayesian : HasDerivAt bayesianWelfare dBayesian beta)
    (hGreedy : HasDerivAt greedyWelfare dGreedy beta)
    (lambda : Real) :
    HasDerivAt
      (fun lambda' =>
        deriv
          (fun beta' =>
            populationWelfare bayesianWelfare greedyWelfare beta' lambda')
          beta)
      (dBayesian - dGreedy) lambda := by
  have hDerivativeCarrier :
      (fun lambda' =>
        deriv
          (fun beta' =>
            populationWelfare bayesianWelfare greedyWelfare beta' lambda')
          beta) =
        (fun lambda' =>
          lambda' * dBayesian + (1 - lambda') * dGreedy) := by
    funext lambda'
    exact (populationWelfare_hasDerivAt_beta
      hBayesian hGreedy lambda').deriv
  rw [hDerivativeCarrier]
  convert
    ((hasDerivAt_id lambda).mul_const dBayesian).add
      (((hasDerivAt_const lambda (1 : Real)).sub (hasDerivAt_id lambda)).mul_const
        dGreedy) using 1
  all_goals ring

theorem populationWelfare_mixedDerivative_positive
    {bayesianWelfare greedyWelfare : Real -> Real}
    {beta dBayesian dGreedy : Real}
    (hBayesianMonotone : Monotone bayesianWelfare)
    (hBayesian : HasDerivAt bayesianWelfare dBayesian beta)
    (hGreedy : HasDerivAt greedyWelfare dGreedy beta)
    (hGreedyNegative : dGreedy < 0)
    (lambda : Real) :
    HasDerivAt
      (fun lambda' =>
        deriv
          (fun beta' =>
            populationWelfare bayesianWelfare greedyWelfare beta' lambda')
          beta)
      (dBayesian - dGreedy) lambda /\
        0 < dBayesian - dGreedy := by
  refine ⟨populationWelfare_hasMixedDerivAt
    hBayesian hGreedy lambda, ?_⟩
  have hBayesianNonnegative : 0 <= dBayesian := by
    rw [← hBayesian.deriv]
    exact hBayesianMonotone.deriv_nonneg
  linarith

def ComplementarityBundle
    {Omega : Type u} {V : Type v} {Signal : Type w} {Experiment : Type x}
    [Fintype Omega] [DecidableEq Omega]
    [Fintype V] [DecidableEq V]
    (F : BayesianIDPFamily Omega V Signal Experiment) : Prop :=
  exists betaStar : Real,
    0 < betaStar /\
      forall beta, betaStar < beta ->
        forall (lambda dBayesian : Real),
          HasDerivAt F.aggregateWelfare dBayesian beta ->
            exists dGreedy : Real,
              HasDerivAt
                _root_.BlackwellDilemma.FiveStateRouting.greedyWelfare
                dGreedy beta /\
                HasDerivAt
                  (fun lambda' =>
                    deriv
                      (fun beta' => populationWelfare
                        F.aggregateWelfare
                        _root_.BlackwellDilemma.FiveStateRouting.greedyWelfare
                        beta' lambda')
                      beta)
                  (dBayesian - dGreedy) lambda /\
                0 < dBayesian - dGreedy

theorem complementarityBundle_of_blackwell
    {Omega : Type u} {V : Type v} {Signal : Type w} {Experiment : Type x}
    [Fintype Omega] [DecidableEq Omega]
    [Fintype V] [DecidableEq V]
    (F : BayesianIDPFamily Omega V Signal Experiment)
    (hBlackwell : F.BlackwellConditionalPremise) :
    ComplementarityBundle F := by
  rcases
      _root_.BlackwellDilemma.FiveStateRouting.greedyWelfare_hasDerivAt_negative_after_uniqueMinimum with
    ⟨betaStar, hBetaStar, hGreedyAfter⟩
  refine ⟨betaStar, hBetaStar, ?_⟩
  intro beta hAfter lambda dBayesian hBayesian
  rcases hGreedyAfter beta hAfter with
    ⟨dGreedy, hGreedy, hGreedyNegative⟩
  have hBayesianMonotone : Monotone F.aggregateWelfare :=
    F.aggregateWelfare_mono_of_blackwell hBlackwell
  rcases populationWelfare_mixedDerivative_positive
      hBayesianMonotone hBayesian hGreedy hGreedyNegative lambda with
    ⟨hMixed, hMixedPositive⟩
  exact ⟨dGreedy, hGreedy, hMixed, hMixedPositive⟩

/-- Publication statement for the actual Bayesian aggregate and concrete
    five-state greedy welfare. Differentiability of the Bayesian value at the
    evaluated precision is explicit because monotone functions need not be
    differentiable everywhere. -/
def ComplementarityClaim : Prop :=
  forall (Omega V Signal Experiment : Type)
    [Fintype Omega] [DecidableEq Omega]
    [Fintype V] [DecidableEq V]
    (F : BayesianIDPFamily Omega V Signal Experiment),
      ComplementarityBundle F

theorem complementarityClaim_from_blackwell :
    Blackwell1953FixedFeasiblePremise -> ComplementarityClaim := by
  intro hBlackwell Omega V Signal Experiment _ _ _ _ F
  exact complementarityBundle_of_blackwell F
    (hBlackwell Omega V Signal Experiment F)

end BlackwellDilemma.Complementarity
