/-
  BlackwellDilemma/UnifiedCognitiveFiveState.lean

  Exact finite experiment for the repaired five-state cognition claim.
  A structurally aware agent sees either the bridge state or an erasure.
  Higher cognitive depth raises the reveal probability, while reward-signal
  precision affects only the fixed open-bridge continuation problem.
-/

import BlackwellDilemma.UnifiedTwoRegime
import Mathlib.Analysis.SpecialFunctions.Pow.Asymptotics

namespace BlackwellDilemma.FiveStateCognition

open Filter
open FiveState
open FiveStateTwoRegime

/-- Probability that the topology experiment reveals the bridge state. -/
noncomputable def revealProbability (kappa : Real) : Real :=
  1 - (1 / 2 : Real) ^ kappa

theorem revealProbability_zero : revealProbability 0 = 0 := by
  norm_num [revealProbability]

theorem revealProbability_continuous : Continuous revealProbability := by
  unfold revealProbability
  exact continuous_const.sub (Real.continuous_const_rpow (by norm_num))

theorem revealProbability_mem_unitInterval {kappa : Real} (hkappa : 0 <= kappa) :
    0 <= revealProbability kappa /\ revealProbability kappa <= 1 := by
  have hPowPos : 0 < (1 / 2 : Real) ^ kappa :=
    Real.rpow_pos_of_pos (by norm_num) _
  have hPowLe : (1 / 2 : Real) ^ kappa <= 1 :=
    Real.rpow_le_one (by norm_num) (by norm_num) hkappa
  unfold revealProbability
  constructor <;> linarith

theorem revealProbability_mono : Monotone revealProbability := by
  intro kappaLow kappaHigh hle
  have hPow : (1 / 2 : Real) ^ kappaHigh <= (1 / 2 : Real) ^ kappaLow :=
    Real.rpow_le_rpow_of_exponent_ge (by norm_num) (by norm_num) hle
  unfold revealProbability
  linarith

theorem revealProbability_pos {kappa : Real} (hkappa : 0 < kappa) :
    0 < revealProbability kappa := by
  have hPowLt : (1 / 2 : Real) ^ kappa < (1 / 2 : Real) ^ (0 : Real) :=
    (Real.strictAnti_rpow_of_base_lt_one (by norm_num) (by norm_num)) hkappa
  norm_num [revealProbability] at hPowLt ⊢
  exact hPowLt

/-- Under the uniform-threshold coupling, every low-depth revelation is also
    a high-depth revelation. This is the finite Blackwell-order witness. -/
theorem revealEvent_nested {kappaLow kappaHigh u : Real}
    (hle : kappaLow <= kappaHigh)
    (hReveal : u < revealProbability kappaLow) :
    u < revealProbability kappaHigh :=
  lt_of_lt_of_le hReveal (revealProbability_mono hle)

/-- A lower-depth reveal-or-erasure experiment is a state-independent
    garbling of a higher-depth experiment. `retention` is the probability of
    keeping a high-depth revelation rather than replacing it by an erasure. -/
theorem exists_reveal_garbling {kappaLow kappaHigh : Real}
    (hLowNonneg : 0 <= kappaLow) (hle : kappaLow <= kappaHigh) :
    exists retention : Real,
      0 <= retention /\ retention <= 1 /\
      revealProbability kappaLow =
        revealProbability kappaHigh * retention /\
      1 - revealProbability kappaLow =
        (1 - revealProbability kappaHigh) +
          revealProbability kappaHigh * (1 - retention) := by
  have hHighNonneg : 0 <= kappaHigh := hLowNonneg.trans hle
  obtain ⟨hLowRhoNonneg, _hLowRhoLe⟩ :=
    revealProbability_mem_unitInterval hLowNonneg
  obtain ⟨hHighRhoNonneg, _hHighRhoLe⟩ :=
    revealProbability_mem_unitInterval hHighNonneg
  have hRhoLe := revealProbability_mono hle
  by_cases hHighZero : revealProbability kappaHigh = 0
  · have hLowZero : revealProbability kappaLow = 0 :=
      le_antisymm (hRhoLe.trans_eq hHighZero) hLowRhoNonneg
    refine ⟨0, le_rfl, zero_le_one, ?_, ?_⟩
    · simp [hLowZero, hHighZero]
    · simp [hLowZero, hHighZero]
  · have hHighPos : 0 < revealProbability kappaHigh :=
      lt_of_le_of_ne hHighRhoNonneg (Ne.symm hHighZero)
    let retention :=
      revealProbability kappaLow / revealProbability kappaHigh
    have hRetentionNonneg : 0 <= retention := by
      exact div_nonneg hLowRhoNonneg hHighRhoNonneg
    have hRetentionLe : retention <= 1 := by
      exact (div_le_one hHighPos).2 hRhoLe
    have hReveal : revealProbability kappaLow =
        revealProbability kappaHigh * retention := by
      dsimp [retention]
      field_simp
    refine ⟨retention, hRetentionNonneg, hRetentionLe, hReveal, ?_⟩
    rw [hReveal]
    ring

theorem revealProbability_tendsto_one :
    Tendsto revealProbability atTop (nhds 1) := by
  have hPow := tendsto_rpow_atTop_of_base_lt_one (1 / 2 : Real)
    (by norm_num) (by norm_num)
  have hOne : Tendsto (fun _ : Real => (1 : Real)) atTop (nhds 1) :=
    tendsto_const_nhds
  change Tendsto (fun kappa : Real => 1 - (1 / 2 : Real) ^ kappa)
    atTop (nhds 1)
  simpa only [sub_zero] using hOne.sub hPow

/-- On an erasure, the structurally aware agent takes the bridge exactly when
    its prior continuation value exceeds the safe payoff. Ties go safe. -/
noncomputable def priorBridgeWeight (p : Real) : Real :=
  if p < p_1 then 1 else 0

theorem priorBridgeWeight_mem_unitInterval (p : Real) :
    0 <= priorBridgeWeight p /\ priorBridgeWeight p <= 1 := by
  unfold priorBridgeWeight
  split <;> norm_num

/-- Probability of taking the bridge conditional on an open bridge. -/
noncomputable def routeBridgeOpen (kappa p : Real) : Real :=
  revealProbability kappa +
    (1 - revealProbability kappa) * priorBridgeWeight p

/-- Probability of taking the bridge conditional on a blocked bridge. -/
noncomputable def routeBridgeBlocked (kappa p : Real) : Real :=
  (1 - revealProbability kappa) * priorBridgeWeight p

theorem routeBridgeOpen_mem_unitInterval {kappa p : Real} (hkappa : 0 <= kappa) :
    0 <= routeBridgeOpen kappa p /\ routeBridgeOpen kappa p <= 1 := by
  obtain ⟨hRhoNonneg, hRhoLe⟩ := revealProbability_mem_unitInterval hkappa
  obtain ⟨hPriorNonneg, hPriorLe⟩ := priorBridgeWeight_mem_unitInterval p
  unfold routeBridgeOpen
  constructor
  · positivity
  · nlinarith [mul_nonneg (sub_nonneg.mpr hRhoLe) (sub_nonneg.mpr hPriorLe)]

theorem routeBridgeBlocked_mem_unitInterval {kappa p : Real}
    (hkappa : 0 <= kappa) :
    0 <= routeBridgeBlocked kappa p /\ routeBridgeBlocked kappa p <= 1 := by
  obtain ⟨hRhoNonneg, hRhoLe⟩ := revealProbability_mem_unitInterval hkappa
  obtain ⟨hPriorNonneg, hPriorLe⟩ := priorBridgeWeight_mem_unitInterval p
  unfold routeBridgeBlocked
  constructor
  · positivity
  · nlinarith [mul_nonneg hRhoNonneg hPriorNonneg,
      mul_nonneg (sub_nonneg.mpr hRhoLe) (sub_nonneg.mpr hPriorLe)]

theorem routeBridgeOpen_continuous (p : Real) :
    Continuous (fun kappa => routeBridgeOpen kappa p) := by
  have hOneMinus : Continuous (fun kappa : Real => 1 - revealProbability kappa) :=
    continuous_const.sub revealProbability_continuous
  exact revealProbability_continuous.add (hOneMinus.mul continuous_const)

theorem routeBridgeBlocked_continuous (p : Real) :
    Continuous (fun kappa => routeBridgeBlocked kappa p) := by
  have hOneMinus : Continuous (fun kappa : Real => 1 - revealProbability kappa) :=
    continuous_const.sub revealProbability_continuous
  exact hOneMinus.mul continuous_const

/-- Expected reward after taking an open bridge: choose between the goal and
    distractor using the Gaussian reward signal. -/
noncomputable def openBridgeReward (beta : Real) : Real :=
  (1 / 10 : Real) + (9 / 10 : Real) * Phi_B beta

theorem openBridgeReward_mono {betaLow betaHigh : Real}
    (hBetaLow : 0 < betaLow) (hle : betaLow <= betaHigh) :
    openBridgeReward betaLow <= openBridgeReward betaHigh := by
  have hPhi := Phi_B_monotone hBetaLow hle
  unfold openBridgeReward
  nlinarith

theorem openBridgeReward_tendsto_one :
    Tendsto openBridgeReward atTop (nhds 1) := by
  have hBase : Tendsto (fun _ : Real => (1 / 10 : Real))
      atTop (nhds (1 / 10 : Real)) := tendsto_const_nhds
  have hScaled := Phi_B_tendsto_one_atTop.const_mul (9 / 10 : Real)
  change Tendsto (fun beta : Real =>
    (1 / 10 : Real) + (9 / 10 : Real) * Phi_B beta) atTop (nhds 1)
  convert hBase.add hScaled using 1
  norm_num

/-- Welfare of the finite reveal-or-erasure experiment. Routing at the start
    is independent of reward precision; `beta` matters only after an open
    bridge has been selected. -/
noncomputable def cognitiveWelfare (beta kappa p : Real) : Real :=
  (1 - p) *
      (routeBridgeOpen kappa p * openBridgeReward beta +
        (1 - routeBridgeOpen kappa p) * r_A) +
    p *
      (routeBridgeBlocked kappa p * (1 / 10 : Real) +
        (1 - routeBridgeBlocked kappa p) * r_A)

theorem cognitiveWelfare_continuous_in_kappa (beta p : Real) :
    Continuous (fun kappa => cognitiveWelfare beta kappa p) := by
  have hOpen := routeBridgeOpen_continuous p
  have hBlocked := routeBridgeBlocked_continuous p
  have hOpenBranch : Continuous (fun kappa : Real =>
      routeBridgeOpen kappa p * openBridgeReward beta +
        (1 - routeBridgeOpen kappa p) * r_A) :=
    (hOpen.mul continuous_const).add
      ((continuous_const.sub hOpen).mul continuous_const)
  have hBlockedBranch : Continuous (fun kappa : Real =>
      routeBridgeBlocked kappa p * (1 / 10 : Real) +
        (1 - routeBridgeBlocked kappa p) * r_A) :=
    (hBlocked.mul continuous_const).add
      ((continuous_const.sub hBlocked).mul continuous_const)
  exact (continuous_const.mul hOpenBranch).add
    (continuous_const.mul hBlockedBranch)

/-- For every structurally aware depth, reward precision weakly improves
    welfare because start-node routing is held fixed. -/
theorem cognitiveWelfare_mono_in_beta {betaLow betaHigh kappa p : Real}
    (hBetaLow : 0 < betaLow) (hBeta : betaLow <= betaHigh)
    (hKappa : 0 <= kappa) (_hPNonneg : 0 <= p) (hPLe : p <= 1) :
    cognitiveWelfare betaLow kappa p <= cognitiveWelfare betaHigh kappa p := by
  have hReward := openBridgeReward_mono hBetaLow hBeta
  have hRoute := (routeBridgeOpen_mem_unitInterval (p := p) hKappa).1
  have hOneP : 0 <= 1 - p := sub_nonneg.mpr hPLe
  have hProduct :
      0 <= (1 - p) * routeBridgeOpen kappa p *
        (openBridgeReward betaHigh - openBridgeReward betaLow) := by
    positivity
  unfold cognitiveWelfare
  nlinarith

/-- Continuous extension of the positive-depth family to zero cognition:
    the experiment always erases and the agent uses the prior action. -/
noncomputable def priorAwareWelfare (beta p : Real) : Real :=
  if p < p_1 then
    (1 - p) * openBridgeReward beta + p * (1 / 10 : Real)
  else r_A

theorem cognitiveWelfare_zero (beta p : Real) :
    cognitiveWelfare beta 0 p = priorAwareWelfare beta p := by
  by_cases hp : p < p_1
  · simp [cognitiveWelfare, routeBridgeOpen, routeBridgeBlocked,
      revealProbability_zero, priorBridgeWeight, priorAwareWelfare, hp]
  · simp [cognitiveWelfare, routeBridgeOpen, routeBridgeBlocked,
      revealProbability_zero, priorBridgeWeight, priorAwareWelfare, hp]
    ring

theorem cognitiveWelfare_tendsto_priorAware (beta p : Real) :
    Tendsto (fun kappa => cognitiveWelfare beta kappa p)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds (priorAwareWelfare beta p)) := by
  have hAtZero : Tendsto (fun kappa => cognitiveWelfare beta kappa p)
      (nhds 0) (nhds (cognitiveWelfare beta 0 p)) :=
    (cognitiveWelfare_continuous_in_kappa beta p).continuousAt
  have hRight : Tendsto (fun kappa => cognitiveWelfare beta kappa p)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds (cognitiveWelfare beta 0 p)) :=
    hAtZero.mono_left inf_le_left
  rw [cognitiveWelfare_zero beta p] at hRight
  exact hRight

/-- Perfect topology information still leaves the finite-precision reward
    decision on an open bridge. -/
noncomputable def perfectTopologyFiniteReward (beta p : Real) : Real :=
  (1 - p) * openBridgeReward beta + p * r_A

theorem routeBridgeOpen_tendsto_one (p : Real) :
    Tendsto (fun kappa => routeBridgeOpen kappa p) atTop (nhds 1) := by
  have hRho := revealProbability_tendsto_one
  have hOne : Tendsto (fun _ : Real => (1 : Real)) atTop (nhds 1) :=
    tendsto_const_nhds
  have hOneMinus : Tendsto (fun kappa => 1 - revealProbability kappa)
      atTop (nhds 0) := by
    simpa using hOne.sub hRho
  have hPrior : Tendsto (fun _ : Real => priorBridgeWeight p)
      atTop (nhds (priorBridgeWeight p)) := tendsto_const_nhds
  have hProduct := hOneMinus.mul hPrior
  have hSum := hRho.add hProduct
  simpa [routeBridgeOpen] using hSum

theorem routeBridgeBlocked_tendsto_zero (p : Real) :
    Tendsto (fun kappa => routeBridgeBlocked kappa p) atTop (nhds 0) := by
  have hOne : Tendsto (fun _ : Real => (1 : Real)) atTop (nhds 1) :=
    tendsto_const_nhds
  have hOneMinus : Tendsto (fun kappa => 1 - revealProbability kappa)
      atTop (nhds 0) := by
    simpa using hOne.sub revealProbability_tendsto_one
  have hPrior : Tendsto (fun _ : Real => priorBridgeWeight p)
      atTop (nhds (priorBridgeWeight p)) := tendsto_const_nhds
  simpa [routeBridgeBlocked] using hOneMinus.mul hPrior

theorem cognitiveWelfare_tendsto_perfectTopology (beta p : Real) :
    Tendsto (fun kappa => cognitiveWelfare beta kappa p)
      atTop (nhds (perfectTopologyFiniteReward beta p)) := by
  have hOpen := routeBridgeOpen_tendsto_one p
  have hBlocked := routeBridgeBlocked_tendsto_zero p
  have hOne : Tendsto (fun _ : Real => (1 : Real)) atTop (nhds 1) :=
    tendsto_const_nhds
  have hOpenReward : Tendsto (fun _ : Real => openBridgeReward beta)
      atTop (nhds (openBridgeReward beta)) := tendsto_const_nhds
  have hSafe : Tendsto (fun _ : Real => r_A) atTop (nhds r_A) :=
    tendsto_const_nhds
  have hBlockedReward : Tendsto (fun _ : Real => (1 / 10 : Real))
      atTop (nhds (1 / 10 : Real)) := tendsto_const_nhds
  have hOneP : Tendsto (fun _ : Real => 1 - p) atTop (nhds (1 - p)) :=
    tendsto_const_nhds
  have hP : Tendsto (fun _ : Real => p) atTop (nhds p) :=
    tendsto_const_nhds
  have hOpenBranch := (hOpen.mul hOpenReward).add ((hOne.sub hOpen).mul hSafe)
  have hBlockedBranch :=
    (hBlocked.mul hBlockedReward).add ((hOne.sub hBlocked).mul hSafe)
  have hTotal := (hOneP.mul hOpenBranch).add (hP.mul hBlockedBranch)
  simpa [cognitiveWelfare, perfectTopologyFiniteReward] using hTotal

theorem perfectTopologyFiniteReward_tendsto_oracle (p : Real) :
    Tendsto (fun beta => perfectTopologyFiniteReward beta p)
      atTop (nhds (expectedPerfectTopologyReward p)) := by
  have hOneP : Tendsto (fun _ : Real => 1 - p) atTop (nhds (1 - p)) :=
    tendsto_const_nhds
  have hP : Tendsto (fun _ : Real => p) atTop (nhds p) :=
    tendsto_const_nhds
  have hSafe : Tendsto (fun _ : Real => r_A) atTop (nhds r_A) :=
    tendsto_const_nhds
  have h := (hOneP.mul openBridgeReward_tendsto_one).add (hP.mul hSafe)
  rw [expectedPerfectTopologyReward_formula]
  unfold perfectTopologyFiniteReward r_A
  convert h using 1
  all_goals
    norm_num [r_A]
    ring

/-- High cognition alone does not reach the oracle at finite reward precision. -/
theorem perfectTopologyFiniteReward_lt_oracle (beta p : Real) (hp : p < 1) :
    perfectTopologyFiniteReward beta p < expectedPerfectTopologyReward p := by
  have hPhi : Phi_B beta < 1 := by
    unfold Phi_B
    exact Phi_lt_one _
  have hOpen : openBridgeReward beta < 1 := by
    unfold openBridgeReward
    nlinarith
  rw [expectedPerfectTopologyReward_formula]
  unfold perfectTopologyFiniteReward r_A
  nlinarith [mul_pos (sub_pos.mpr hp) (sub_pos.mpr hOpen)]

/-- Cognitive depth is not an unconditional welfare improvement. In the
    topology-dominated prior regime, revealing an open bridge can induce a
    low-precision continuation whose value is below the safe payoff. -/
theorem topologyRegime_cognition_can_lower_welfare
    {beta kappa p : Real} (hPriorSafe : p_1 <= p) (hPLt : p < 1)
    (hKappa : 0 < kappa) (hOpenLow : openBridgeReward beta < r_A) :
    cognitiveWelfare beta kappa p < cognitiveWelfare beta 0 p := by
  have hNotPriorBridge : ¬p < p_1 := not_lt_of_ge hPriorSafe
  have hRhoPos := revealProbability_pos hKappa
  have hProductNeg :
      (1 - p) * revealProbability kappa *
          (openBridgeReward beta - r_A) < 0 := by
    exact mul_neg_of_pos_of_neg
      (mul_pos (sub_pos.mpr hPLt) hRhoPos) (sub_neg.mpr hOpenLow)
  simp [cognitiveWelfare, routeBridgeOpen, routeBridgeBlocked,
    priorBridgeWeight, hNotPriorBridge, revealProbability_zero]
  nlinarith

/-- Positive depths that restore reward-precision monotonicity. The greedy
    endpoint is deliberately absent from this set. -/
def RestoringDepths (p : Real) : Set Real :=
  {kappa | 0 < kappa /\
    forall betaLow betaHigh : Real,
      0 < betaLow -> betaLow <= betaHigh ->
      cognitiveWelfare betaLow kappa p <= cognitiveWelfare betaHigh kappa p}

theorem restoringDepths_eq_Ioi {p : Real} (hPNonneg : 0 <= p) (hPLe : p <= 1) :
    RestoringDepths p = Set.Ioi 0 := by
  ext kappa
  constructor
  · intro h
    exact h.1
  · intro h
    exact ⟨h, fun betaLow betaHigh hBetaLow hBeta =>
      cognitiveWelfare_mono_in_beta hBetaLow hBeta h.le hPNonneg hPLe⟩

theorem restoringDepths_sInf_zero {p : Real} (hPNonneg : 0 <= p)
    (hPLe : p <= 1) : sInf (RestoringDepths p) = 0 := by
  rw [restoringDepths_eq_Ioi hPNonneg hPLe]
  simp

theorem zero_not_mem_restoringDepths (p : Real) : 0 ∉ RestoringDepths p := by
  simp [RestoringDepths]

structure CognitiveExperimentBundle (p : Real) : Prop where
  blockingProbability : 0 <= p /\ p < 1
  revealAtZero : revealProbability 0 = 0
  revealBounds : forall kappa : Real, 0 <= kappa ->
    0 <= revealProbability kappa /\ revealProbability kappa <= 1
  revealNested : forall kappaLow kappaHigh u : Real,
    kappaLow <= kappaHigh -> u < revealProbability kappaLow ->
      u < revealProbability kappaHigh
  revealGarbling : forall kappaLow kappaHigh : Real,
    0 <= kappaLow -> kappaLow <= kappaHigh ->
      exists retention : Real,
        0 <= retention /\ retention <= 1 /\
        revealProbability kappaLow =
          revealProbability kappaHigh * retention /\
        1 - revealProbability kappaLow =
          (1 - revealProbability kappaHigh) +
            revealProbability kappaHigh * (1 - retention)
  revealAtTop : Tendsto revealProbability atTop (nhds 1)
  betaMonotone : forall betaLow betaHigh kappa : Real,
    0 < betaLow -> betaLow <= betaHigh -> 0 <= kappa ->
      cognitiveWelfare betaLow kappa p <= cognitiveWelfare betaHigh kappa p
  priorEndpoint : forall beta : Real,
    cognitiveWelfare beta 0 p = priorAwareWelfare beta p
  priorLimit : forall beta : Real,
    Tendsto (fun kappa => cognitiveWelfare beta kappa p)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds (priorAwareWelfare beta p))
  topologyEndpoint : forall beta : Real,
    Tendsto (fun kappa => cognitiveWelfare beta kappa p)
      atTop (nhds (perfectTopologyFiniteReward beta p))
  oracleEndpoint : Tendsto (fun beta => perfectTopologyFiniteReward beta p)
    atTop (nhds (expectedPerfectTopologyReward p))
  finitePrecisionGap : forall beta : Real,
    perfectTopologyFiniteReward beta p < expectedPerfectTopologyReward p
  cognitionCanLowerWelfare : forall beta kappa : Real,
    p_1 <= p -> 0 < kappa -> openBridgeReward beta < r_A ->
      cognitiveWelfare beta kappa p < cognitiveWelfare beta 0 p
  restoringInfimum : sInf (RestoringDepths p) = 0

theorem cognitiveExperimentBundle (p : Real) (hPNonneg : 0 <= p) (hPLt : p < 1) :
    CognitiveExperimentBundle p where
  blockingProbability := ⟨hPNonneg, hPLt⟩
  revealAtZero := revealProbability_zero
  revealBounds := fun _ hKappa => revealProbability_mem_unitInterval hKappa
  revealNested := fun _ _ _ hle hReveal => revealEvent_nested hle hReveal
  revealGarbling := fun _ _ hLow hle => exists_reveal_garbling hLow hle
  revealAtTop := revealProbability_tendsto_one
  betaMonotone := fun _ _ _ hBetaLow hBeta hKappa =>
    cognitiveWelfare_mono_in_beta hBetaLow hBeta hKappa hPNonneg hPLt.le
  priorEndpoint := fun beta => cognitiveWelfare_zero beta p
  priorLimit := fun beta => cognitiveWelfare_tendsto_priorAware beta p
  topologyEndpoint := fun beta => cognitiveWelfare_tendsto_perfectTopology beta p
  oracleEndpoint := perfectTopologyFiniteReward_tendsto_oracle p
  finitePrecisionGap := fun beta => perfectTopologyFiniteReward_lt_oracle beta p hPLt
  cognitionCanLowerWelfare := fun _ _ hPrior hKappa hOpen =>
    topologyRegime_cognition_can_lower_welfare hPrior hPLt hKappa hOpen
  restoringInfimum := restoringDepths_sInf_zero hPNonneg hPLt.le

/-- Exact machine target for the repaired manuscript Proposition
    `prop:threshold-five-state`. -/
def CognitiveFiveStateClaim : Prop :=
  TwoRegimeClaim /\
    forall p : Real, 0 <= p -> p < 1 -> CognitiveExperimentBundle p

theorem cognitiveFiveStateClaim_proved : CognitiveFiveStateClaim :=
  ⟨twoRegimeClaim_proved, cognitiveExperimentBundle⟩

/-- The exact sub-bundle stated separately as manuscript Proposition
    `prop:p-monotonicity-five-state`. -/
structure RewardPrecisionMonotonicityBundle (p : Real) : Prop where
  blockingProbability : 0 <= p /\ p < 1
  betaMonotone : forall betaLow betaHigh kappa : Real,
    0 < betaLow -> betaLow <= betaHigh -> 0 < kappa ->
      cognitiveWelfare betaLow kappa p <= cognitiveWelfare betaHigh kappa p
  restoringSet : RestoringDepths p = Set.Ioi 0
  restoringInfimum : sInf (RestoringDepths p) = 0
  greedyExcluded : 0 ∉ RestoringDepths p
  priorLimit : forall beta : Real,
    Tendsto (fun kappa => cognitiveWelfare beta kappa p)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds (priorAwareWelfare beta p))
  topologyEndpoint : forall beta : Real,
    Tendsto (fun kappa => cognitiveWelfare beta kappa p)
      atTop (nhds (perfectTopologyFiniteReward beta p))
  finitePrecisionGap : forall beta : Real,
    perfectTopologyFiniteReward beta p < expectedPerfectTopologyReward p
  oracleEndpoint : Tendsto (fun beta => perfectTopologyFiniteReward beta p)
    atTop (nhds (expectedPerfectTopologyReward p))

theorem rewardPrecisionMonotonicityBundle (p : Real)
    (hPNonneg : 0 <= p) (hPLt : p < 1) :
    RewardPrecisionMonotonicityBundle p where
  blockingProbability := ⟨hPNonneg, hPLt⟩
  betaMonotone := fun _ _ _ hBetaLow hBeta hKappa =>
    cognitiveWelfare_mono_in_beta hBetaLow hBeta hKappa.le hPNonneg hPLt.le
  restoringSet := restoringDepths_eq_Ioi hPNonneg hPLt.le
  restoringInfimum := restoringDepths_sInf_zero hPNonneg hPLt.le
  greedyExcluded := zero_not_mem_restoringDepths p
  priorLimit := fun beta => cognitiveWelfare_tendsto_priorAware beta p
  topologyEndpoint := fun beta => cognitiveWelfare_tendsto_perfectTopology beta p
  finitePrecisionGap := fun beta => perfectTopologyFiniteReward_lt_oracle beta p hPLt
  oracleEndpoint := perfectTopologyFiniteReward_tendsto_oracle p

def RewardPrecisionMonotonicityClaim : Prop :=
  forall p : Real, 0 <= p -> p < 1 -> RewardPrecisionMonotonicityBundle p

theorem rewardPrecisionMonotonicityClaim_proved :
    RewardPrecisionMonotonicityClaim :=
  rewardPrecisionMonotonicityBundle

end BlackwellDilemma.FiveStateCognition
