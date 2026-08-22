/-
  Current-paper posterior experiment geometry.

  This module formalizes the exact finite posterior-splitting representation
  used in the proof of the current Theory and Decision manuscript's
  posterior-convexity frontier. A Blackwell refinement is represented by a
  coarse signal and, conditional on each coarse signal, a finite split into
  refined posteriors whose barycenter is the coarse posterior.
-/

import Mathlib.Analysis.Convex.Jensen
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Real.Basic

namespace BlackwellDilemma.CurrentPosterior

open scoped BigOperators

universe u v w

variable (Theta : Type u) [Fintype Theta]

/-- The finite probability simplex used by the current manuscript. -/
def posteriorSet : Set (Theta -> Real) :=
  {mu | (forall theta, 0 <= mu theta) /\ Finset.univ.sum mu = 1}

theorem posteriorSet_convex : Convex Real (posteriorSet Theta) := by
  intro mu hMu nu hNu a b hA hB hSum
  constructor
  · intro theta
    dsimp
    exact add_nonneg (mul_nonneg hA (hMu.1 theta))
      (mul_nonneg hB (hNu.1 theta))
  · simp_rw [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
    rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum,
      hMu.2, hNu.2, mul_one, mul_one]
    exact hSum

/-- A finite agent/objective decision problem with an explicit deterministic
    tie-broken response. The `response_optimal` field is precisely the
    argmax clause in Definition 1 of the current manuscript. -/
structure PosteriorDecisionModel
    (Action : Type v) [Fintype Action] [Nonempty Action] where
  subjectivePayoff : Action -> Theta -> Real
  objectivePayoff : Action -> Theta -> Real
  response : (Theta -> Real) -> Action
  response_optimal : forall mu, mu ∈ posteriorSet Theta -> forall action,
    Finset.univ.sum (fun theta =>
      mu theta * subjectivePayoff action theta) <=
    Finset.univ.sum (fun theta =>
      mu theta * subjectivePayoff (response mu) theta)

namespace PosteriorDecisionModel

variable {Theta : Type u} [Fintype Theta]
variable {Action : Type v} [Fintype Action] [Nonempty Action]

/-- Definition 1: objective welfare induced by the agent's tie-broken
    posterior response. -/
noncomputable def inducedPosteriorWelfare
    (M : PosteriorDecisionModel Theta Action) (mu : Theta -> Real) : Real :=
  Finset.univ.sum fun theta =>
    mu theta * M.objectivePayoff (M.response mu) theta

noncomputable def objectiveScore
    (M : PosteriorDecisionModel Theta Action)
    (mu : Theta -> Real) (action : Action) : Real :=
  Finset.univ.sum fun theta =>
    mu theta * M.objectivePayoff action theta

theorem inducedPosteriorWelfare_eq_objectiveScore
    (M : PosteriorDecisionModel Theta Action) (mu : Theta -> Real) :
    M.inducedPosteriorWelfare mu = M.objectiveScore mu (M.response mu) := rfl

/-- When the response criterion equals objective welfare, induced posterior
    welfare is convex. This is the fixed-feasibility step used by Theorem 7. -/
theorem inducedPosteriorWelfare_convex_of_aligned
    (M : PosteriorDecisionModel Theta Action)
    (hAligned : forall action theta,
      M.subjectivePayoff action theta = M.objectivePayoff action theta) :
    ConvexOn Real (posteriorSet Theta) M.inducedPosteriorWelfare := by
  refine ⟨posteriorSet_convex Theta, ?_⟩
  intro mu hMu nu hNu a b hA hB hSum
  let mixed : Theta -> Real := a • mu + b • nu
  let chosen : Action := M.response mixed
  have hMuOptimal := M.response_optimal mu hMu chosen
  have hNuOptimal := M.response_optimal nu hNu chosen
  simp_rw [hAligned] at hMuOptimal hNuOptimal
  change M.objectiveScore mixed chosen <=
    a * M.objectiveScore mu (M.response mu) +
      b * M.objectiveScore nu (M.response nu)
  have hMixedScore :
      M.objectiveScore mixed chosen =
        a * M.objectiveScore mu chosen + b * M.objectiveScore nu chosen := by
    simp only [objectiveScore, mixed, Pi.add_apply, Pi.smul_apply,
      smul_eq_mul, add_mul]
    rw [Finset.sum_add_distrib]
    simp_rw [mul_assoc]
    rw [← Finset.mul_sum, ← Finset.mul_sum]
  rw [hMixedScore]
  exact add_le_add (mul_le_mul_of_nonneg_left hMuOptimal hA)
    (mul_le_mul_of_nonneg_left hNuOptimal hB)

/-- Definition 1: objective value of a finite posterior experiment. -/
noncomputable def experimentObjectiveValue
    (M : PosteriorDecisionModel Theta Action)
    {Signal : Type w} [Fintype Signal]
    (weight : Signal -> Real) (posterior : Signal -> Theta -> Real) : Real :=
  Finset.univ.sum fun signal =>
    weight signal * M.inducedPosteriorWelfare (posterior signal)

end PosteriorDecisionModel

/-- Posterior representation of a finite Blackwell refinement. `kernel c f`
    is the conditional probability of refined signal `f` given coarse signal
    `c`; `barycenter` is the coordinatewise Bayes/iterated-expectations
    identity used in the paper proof. -/
structure FiniteBlackwellRefinement
    (Coarse : Type v) (Fine : Type w)
    [Fintype Coarse] [Fintype Fine] where
  coarseWeight : Coarse -> Real
  coarseWeight_nonneg : forall coarse, 0 <= coarseWeight coarse
  coarseWeight_sum_one : Finset.univ.sum coarseWeight = 1
  kernel : Coarse -> Fine -> Real
  kernel_nonneg : forall coarse fine, 0 <= kernel coarse fine
  kernel_sum_one : forall coarse, Finset.univ.sum (kernel coarse) = 1
  finePosterior : Coarse -> Fine -> Theta -> Real
  finePosterior_mem : forall coarse fine,
    finePosterior coarse fine ∈ posteriorSet Theta
  coarsePosterior : Coarse -> Theta -> Real
  coarsePosterior_mem : forall coarse,
    coarsePosterior coarse ∈ posteriorSet Theta
  barycenter : forall coarse,
    coarsePosterior coarse =
      Finset.univ.sum fun fine => kernel coarse fine • finePosterior coarse fine

namespace FiniteBlackwellRefinement

variable {Theta : Type u} [Fintype Theta]
variable {Coarse : Type v} {Fine : Type w}
variable [Fintype Coarse] [Fintype Fine]

noncomputable def coarseValue
    (R : FiniteBlackwellRefinement Theta Coarse Fine)
    (g : (Theta -> Real) -> Real) : Real :=
  Finset.univ.sum fun coarse =>
    R.coarseWeight coarse * g (R.coarsePosterior coarse)

noncomputable def refinedValue
    (R : FiniteBlackwellRefinement Theta Coarse Fine)
    (g : (Theta -> Real) -> Real) : Real :=
  Finset.univ.sum fun coarse =>
    R.coarseWeight coarse *
      Finset.univ.sum (fun fine =>
        R.kernel coarse fine * g (R.finePosterior coarse fine))

theorem value_mono_of_convex
    (R : FiniteBlackwellRefinement Theta Coarse Fine)
    {g : (Theta -> Real) -> Real}
    (hConvex : ConvexOn Real (posteriorSet Theta) g) :
    R.coarseValue g <= R.refinedValue g := by
  unfold coarseValue refinedValue
  apply Finset.sum_le_sum
  intro coarse _hCoarse
  apply mul_le_mul_of_nonneg_left _ (R.coarseWeight_nonneg coarse)
  rw [R.barycenter coarse]
  simpa only [smul_eq_mul] using
    hConvex.map_sum_le
      (fun fine _hFine => R.kernel_nonneg coarse fine)
      (by simpa using R.kernel_sum_one coarse)
      (fun fine _hFine => R.finePosterior_mem coarse fine)

end FiniteBlackwellRefinement

/-- Clause (i) of the posterior-convexity frontier, expressed in the finite
    posterior representation of Blackwell refinements. -/
def RespectsFiniteBlackwellRefinements
    (g : (Theta -> Real) -> Real) : Prop :=
  forall (Coarse : Type) (Fine : Type)
    [Fintype Coarse] [Fintype Fine],
    forall R : FiniteBlackwellRefinement Theta Coarse Fine,
      R.coarseValue g <= R.refinedValue g

/-- Theorem 2 (posterior-convexity frontier): objective welfare respects every
    finite Blackwell refinement if and only if the induced posterior-welfare
    function is convex on the simplex. -/
theorem posteriorConvexityFrontier
    (g : (Theta -> Real) -> Real) :
    RespectsFiniteBlackwellRefinements Theta g <->
      ConvexOn Real (posteriorSet Theta) g := by
  constructor
  · intro hSafe
    refine ⟨posteriorSet_convex Theta, ?_⟩
    intro mu hMu nu hNu a b hA hB hSum
    let R : FiniteBlackwellRefinement Theta PUnit Bool :=
      { coarseWeight := fun _ => 1
        coarseWeight_nonneg := by intro; norm_num
        coarseWeight_sum_one := by simp
        kernel := fun _ fine => if fine then a else b
        kernel_nonneg := by
          intro _ fine
          cases fine <;> simp [hA, hB]
        kernel_sum_one := by
          intro _
          simp [hSum]
        finePosterior := fun _ fine => if fine then mu else nu
        finePosterior_mem := by
          intro _ fine
          cases fine <;> simp [hMu, hNu]
        coarsePosterior := fun _ => a • mu + b • nu
        coarsePosterior_mem := by
          intro _
          exact (posteriorSet_convex Theta) hMu hNu hA hB hSum
        barycenter := by
          intro _
          funext theta
          simp }
    have hValue := hSafe PUnit Bool R
    simpa [R, FiniteBlackwellRefinement.coarseValue,
      FiniteBlackwellRefinement.refinedValue] using hValue
  · intro hConvex Coarse Fine _ _ R
    exact R.value_mono_of_convex hConvex

/-- Theorem 7's decision-theoretic core: after conditioning on a feasibility
    realization, an agent who maximizes the same terminal objective respects
    every finite Blackwell refinement. -/
theorem alignedObjective_respectsFiniteBlackwellRefinements
    {Action : Type v} [Fintype Action] [Nonempty Action]
    (M : PosteriorDecisionModel Theta Action)
    (hAligned : forall action theta,
      M.subjectivePayoff action theta = M.objectivePayoff action theta) :
    RespectsFiniteBlackwellRefinements Theta M.inducedPosteriorWelfare := by
  exact (posteriorConvexityFrontier Theta M.inducedPosteriorWelfare).2
    (M.inducedPosteriorWelfare_convex_of_aligned hAligned)

/-- The explicit binary witness in Theorem 2: failure of convexity supplies
    two posteriors and a strict welfare-lowering binary refinement of their
    barycenter. -/
theorem not_convex_exists_binary_witness
    {g : (Theta -> Real) -> Real}
    (hNotConvex : Not (ConvexOn Real (posteriorSet Theta) g)) :
    exists mu nu : Theta -> Real, mu ∈ posteriorSet Theta /\
      nu ∈ posteriorSet Theta /\
      exists a b : Real, 0 <= a /\ 0 <= b /\ a + b = 1 /\
        a * g mu + b * g nu < g (a • mu + b • nu) := by
  rw [ConvexOn] at hNotConvex
  simp only [posteriorSet_convex Theta, true_and, not_forall,
    not_le] at hNotConvex
  rcases hNotConvex with
    ⟨mu, hMu, nu, hNu, a, b, hA, hB, hSum, hStrict⟩
  exact ⟨mu, nu, hMu, hNu, a, b, hA, hB, hSum, by simpa using hStrict⟩

end BlackwellDilemma.CurrentPosterior
