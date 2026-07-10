/-
  BlackwellDilemma/UnifiedBayesianNaiveFiveState.lean

  Exact strict-prior-only Bayesian-naive policy on the five-state benchmark.
  The routing threshold is 4/9, not the historical 2/3 bridge value. Above
  the threshold the policy is locked into the trap and welfare is constant in
  reward precision; at equality behavior is explicitly tie-break dependent.
-/

import BlackwellDilemma.UnifiedInterior

namespace BlackwellDilemma.BayesianNaiveFiveState

open FiveState

inductive TieBreak where
  | bridge
  | trap
  deriving DecidableEq

noncomputable def priorBridgeValue (pHat : Real) : Real :=
  (1 / 10 : Real) + (9 / 10 : Real) * (1 - pHat)

noncomputable def trapWelfare : Real :=
  6 / 10

noncomputable def routingThreshold : Real :=
  4 / 9

def RoutesBridge (pHat : Real) (tieBreak : TieBreak) : Prop :=
  pHat < routingThreshold ∨
    (pHat = routingThreshold /\ tieBreak = .bridge)

/-- Welfare conditional on prior-driven routing to the bridge. On an open
    realization (probability `1-p`) the reward signal chooses between the
    goal and distractor; a blocked realization ends at the distractor. -/
noncomputable def bridgeWelfare (p beta : Real) : Real :=
  (1 / 10 : Real) +
    (9 / 10 : Real) * (1 - p) * Phi_B beta

noncomputable def naiveWelfare
    (p pHat beta : Real) (tieBreak : TieBreak) : Real := by
  classical
  exact if RoutesBridge pHat tieBreak then bridgeWelfare p beta else trapWelfare

noncomputable def oracleWelfare (p : Real) : Real :=
  1 - (4 / 10 : Real) * p

theorem priorBridgeValue_gt_trap_iff (pHat : Real) :
    priorBridgeValue pHat > trapWelfare ↔ pHat < routingThreshold := by
  unfold priorBridgeValue trapWelfare routingThreshold
  constructor <;> intro h <;> nlinarith

theorem priorBridgeValue_eq_trap_iff (pHat : Real) :
    priorBridgeValue pHat = trapWelfare ↔ pHat = routingThreshold := by
  unfold priorBridgeValue trapWelfare routingThreshold
  constructor <;> intro h <;> nlinarith

theorem priorBridgeValue_lt_trap_iff (pHat : Real) :
    priorBridgeValue pHat < trapWelfare ↔ routingThreshold < pHat := by
  unfold priorBridgeValue trapWelfare routingThreshold
  constructor <;> intro h <;> nlinarith

theorem routesBridge_of_lt
    {pHat : Real} (h : pHat < routingThreshold) (tieBreak : TieBreak) :
    RoutesBridge pHat tieBreak := by
  exact Or.inl h

theorem not_routesBridge_of_gt
    {pHat : Real} (h : routingThreshold < pHat) (tieBreak : TieBreak) :
    ¬ RoutesBridge pHat tieBreak := by
  intro hRoute
  rcases hRoute with hBelow | hBoundary
  · linarith
  · linarith [hBoundary.1]

theorem routesBridge_at_threshold_bridge :
    RoutesBridge routingThreshold .bridge := by
  exact Or.inr ⟨rfl, rfl⟩

theorem not_routesBridge_at_threshold_trap :
    ¬ RoutesBridge routingThreshold .trap := by
  intro hRoute
  rcases hRoute with hBelow | hBoundary
  · exact (lt_irrefl routingThreshold) hBelow
  · cases hBoundary.2

theorem naiveWelfare_eq_bridge_of_lt
    (p beta : Real) {pHat : Real} (h : pHat < routingThreshold)
    (tieBreak : TieBreak) :
    naiveWelfare p pHat beta tieBreak = bridgeWelfare p beta := by
  simp [naiveWelfare, routesBridge_of_lt h tieBreak]

theorem naiveWelfare_eq_trap_of_gt
    (p beta : Real) {pHat : Real} (h : routingThreshold < pHat)
    (tieBreak : TieBreak) :
    naiveWelfare p pHat beta tieBreak = trapWelfare := by
  simp [naiveWelfare, not_routesBridge_of_gt h tieBreak]

theorem naiveWelfare_at_threshold_bridge (p beta : Real) :
    naiveWelfare p routingThreshold beta .bridge = bridgeWelfare p beta := by
  simp [naiveWelfare, routesBridge_at_threshold_bridge]

theorem naiveWelfare_at_threshold_trap (p beta : Real) :
    naiveWelfare p routingThreshold beta .trap = trapWelfare := by
  simp [naiveWelfare, not_routesBridge_at_threshold_trap]

theorem bridgeWelfare_mono_in_beta
    {p betaLow betaHigh : Real}
    (hp : p <= 1) (hBetaLow : 0 < betaLow) (hBeta : betaLow <= betaHigh) :
    bridgeWelfare p betaLow <= bridgeWelfare p betaHigh := by
  have hPhi : Phi_B betaLow <= Phi_B betaHigh :=
    Phi_B_monotone hBetaLow hBeta
  have hCoefficient : 0 <= (9 / 10 : Real) * (1 - p) :=
    mul_nonneg (by norm_num) (by linarith)
  unfold bridgeWelfare
  simpa [add_comm] using
    add_le_add_left
      (mul_le_mul_of_nonneg_left hPhi hCoefficient) (1 / 10 : Real)

theorem naiveWelfare_mono_below_threshold
    {p pHat betaLow betaHigh : Real} (tieBreak : TieBreak)
    (hp : p <= 1) (hBelow : pHat < routingThreshold)
    (hBetaLow : 0 < betaLow) (hBeta : betaLow <= betaHigh) :
    naiveWelfare p pHat betaLow tieBreak <=
      naiveWelfare p pHat betaHigh tieBreak := by
  rw [naiveWelfare_eq_bridge_of_lt p betaLow hBelow tieBreak,
    naiveWelfare_eq_bridge_of_lt p betaHigh hBelow tieBreak]
  exact bridgeWelfare_mono_in_beta hp hBetaLow hBeta

theorem naiveWelfare_constant_above_threshold
    {p pHat : Real} (hAbove : routingThreshold < pHat)
    (tieBreak : TieBreak) :
    forall beta : Real, naiveWelfare p pHat beta tieBreak = trapWelfare := by
  intro beta
  exact naiveWelfare_eq_trap_of_gt p beta hAbove tieBreak

theorem oracleGap_above_threshold
    {p pHat beta : Real} (hAbove : routingThreshold < pHat)
    (tieBreak : TieBreak) :
    oracleWelfare p - naiveWelfare p pHat beta tieBreak =
      (4 / 10 : Real) * (1 - p) := by
  rw [naiveWelfare_eq_trap_of_gt p beta hAbove tieBreak]
  unfold oracleWelfare trapWelfare
  ring

def BayesianNaiveFiveStateClaim : Prop :=
  (forall pHat : Real,
    priorBridgeValue pHat > trapWelfare ↔ pHat < routingThreshold) /\
  (forall pHat : Real,
    priorBridgeValue pHat = trapWelfare ↔ pHat = routingThreshold) /\
  (forall (p pHat beta : Real) (tieBreak : TieBreak),
    pHat < routingThreshold ->
      naiveWelfare p pHat beta tieBreak = bridgeWelfare p beta) /\
  (forall (p pHat beta : Real) (tieBreak : TieBreak),
    routingThreshold < pHat ->
      naiveWelfare p pHat beta tieBreak = trapWelfare) /\
  (forall (p pHat betaLow betaHigh : Real) (tieBreak : TieBreak),
    p <= 1 -> pHat < routingThreshold -> 0 < betaLow -> betaLow <= betaHigh ->
      naiveWelfare p pHat betaLow tieBreak <=
        naiveWelfare p pHat betaHigh tieBreak) /\
  (forall (p pHat beta : Real) (tieBreak : TieBreak),
    routingThreshold < pHat ->
      oracleWelfare p - naiveWelfare p pHat beta tieBreak =
        (4 / 10 : Real) * (1 - p)) /\
  (forall p beta : Real,
    naiveWelfare p routingThreshold beta .bridge = bridgeWelfare p beta /\
      naiveWelfare p routingThreshold beta .trap = trapWelfare)

theorem bayesianNaiveFiveStateClaim_proved : BayesianNaiveFiveStateClaim := by
  refine ⟨priorBridgeValue_gt_trap_iff, priorBridgeValue_eq_trap_iff,
    ?_, ?_, ?_, ?_, ?_⟩
  · intro p pHat beta tieBreak hBelow
    exact naiveWelfare_eq_bridge_of_lt p beta hBelow tieBreak
  · intro p pHat beta tieBreak hAbove
    exact naiveWelfare_eq_trap_of_gt p beta hAbove tieBreak
  · intro p pHat betaLow betaHigh tieBreak hp hBelow hBetaLow hBeta
    exact naiveWelfare_mono_below_threshold
      tieBreak hp hBelow hBetaLow hBeta
  · intro p pHat beta tieBreak hAbove
    exact oracleGap_above_threshold hAbove tieBreak
  · intro p beta
    exact ⟨naiveWelfare_at_threshold_bridge p beta,
      naiveWelfare_at_threshold_trap p beta⟩

end BlackwellDilemma.BayesianNaiveFiveState
