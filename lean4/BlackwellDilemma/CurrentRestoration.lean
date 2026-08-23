/- Exact finite-IDP carrier for restoration under observed feasibility. -/

import BlackwellDilemma.CurrentPosterior
import BlackwellDilemma.UnifiedIDP

namespace BlackwellDilemma.CurrentRestoration

open BlackwellDilemma.CurrentPosterior

universe u v w x y

/-- The literal action carrier in Theorem 7: terminal vertices attainable
    under the common no-revisit transition and stopping rules. -/
def AttainableTerminal
    {V : Type u} [Fintype V] [DecidableEq V]
    (M : IDPModel V) (s : IDPState V) : Type u :=
  {v : V // v ∈ M.attainableStops s}

noncomputable instance attainableTerminalFintype
    {V : Type u} [Fintype V] [DecidableEq V]
    (M : IDPModel V) (s : IDPState V) :
    Fintype (AttainableTerminal M s) := by
  classical
  exact
    { elems := (M.attainableStops s).attach
      complete := by
        intro x
        exact Finset.mem_attach _ x }

noncomputable instance attainableTerminalNonempty
    {V : Type u} [Fintype V] [DecidableEq V]
    (M : IDPModel V) (s : IDPState V) :
    Nonempty (AttainableTerminal M s) := by
  rcases M.attainableStops_nonempty s with ⟨v, hv⟩
  exact ⟨⟨v, hv⟩⟩

/-- Theorem 7 with all paper inputs exposed.  Feasibility realizations are
    finite, the action type at each realization is exactly its attainable
    terminal set, the response and objective payoff are aligned, and each
    `refinement omega` is the posterior representation of `pi' >=_B pi`. -/
theorem restorationUnderObservedFiniteFeasibility
    {V : Type u} [Fintype V] [DecidableEq V]
    {Omega : Type v} [Fintype Omega]
    {Theta : Type w} [Fintype Theta]
    {Coarse : Type x} {Fine : Type y}
    [Fintype Coarse] [Fintype Fine]
    (X : FiniteExAnteIDP V Omega)
    (decision : (omega : Omega) ->
      PosteriorDecisionModel Theta
        (AttainableTerminal (X.realized omega) (X.initialState omega)))
    (hAligned : forall omega action theta,
      (decision omega).subjectivePayoff action theta =
        (decision omega).objectivePayoff action theta)
    (refinement : (omega : Omega) ->
      FiniteBlackwellRefinement Theta Coarse Fine) :
    finiteExpectation X.weight (fun omega =>
      (refinement omega).coarseValue
        (decision omega).inducedPosteriorWelfare) <=
    finiteExpectation X.weight (fun omega =>
      (refinement omega).refinedValue
        (decision omega).inducedPosteriorWelfare) := by
  apply finiteExpectation_mono X.weight_nonneg
  intro omega
  exact (refinement omega).value_mono_of_convex
    ((decision omega).inducedPosteriorWelfare_convex_of_aligned
      (hAligned omega))

end BlackwellDilemma.CurrentRestoration
