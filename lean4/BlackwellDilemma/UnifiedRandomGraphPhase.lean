/-
  BlackwellDilemma/UnifiedRandomGraphPhase.lean

  Conditional transfers from reference-gated random-graph component profiles
  to the paper's exact finite topological-loss formula. No random graph or
  giant component is defined by the conclusion it is meant to satisfy.
-/

import BlackwellDilemma.UnifiedTopoCluster

namespace BlackwellDilemma.RandomGraphPhase

open Filter Topology
open BlackwellDilemma.TopoCluster

structure LocalFragmentationProfile where
  law : forall n, ClusterSizeLaw n
  rho : Real
  start : Nat
  rho_pos : 0 < rho
  singleton_mass : forall n, start <= n -> forall hn : 1 <= n,
    rho <= (law n).prob (ClusterSizeLaw.oneIndex n hn)

structure LinearGiantProfile where
  size : Nat -> Nat
  fraction : Real
  start : Nat
  fraction_pos : 0 < fraction
  fraction_le_one : fraction <= 1
  size_le : forall n, size n <= n
  linear_lower : forall n, start <= n -> fraction * n <= size n

theorem localFragmentation_expectedLoss_constantOrder
    (profile : LocalFragmentationProfile) :
    forall n, max 3 profile.start <= n ->
      profile.rho / 4 <= (profile.law n).expectedLoss /\
      (profile.law n).expectedLoss <= 1 := by
  intro n hn
  have hnThree : 3 <= n := le_trans (Nat.le_max_left 3 profile.start) hn
  have hnStart : profile.start <= n :=
    le_trans (Nat.le_max_right 3 profile.start) hn
  have hnOne : 1 <= n := le_trans (by norm_num) hnThree
  have hLower := (profile.law n).expectedLoss_ge_of_singleton_mass
    hnOne profile.rho (profile.singleton_mass n hnStart hnOne)
  have hQuarter := ClusterSizeLaw.quarter_le_conditionalLoss_at_one hnThree
  constructor
  · calc
      profile.rho / 4 = profile.rho * ((1 : Real) / 4) := by ring
      _ <= profile.rho * conditionalLoss n 1 :=
        mul_le_mul_of_nonneg_left hQuarter profile.rho_pos.le
      _ <= (profile.law n).expectedLoss := hLower
  · exact (profile.law n).expectedLoss_le_one

noncomputable def LinearGiantProfile.adjustedSize
    (profile : LinearGiantProfile) (n : Nat) : Nat :=
  if profile.start <= n then profile.size n else n

theorem LinearGiantProfile.adjustedSize_le
    (profile : LinearGiantProfile) (n : Nat) :
    profile.adjustedSize n <= n := by
  by_cases hn : profile.start <= n
  · simp [LinearGiantProfile.adjustedSize, hn, profile.size_le n]
  · simp [LinearGiantProfile.adjustedSize, hn]

theorem LinearGiantProfile.linear_lower_adjusted
    (profile : LinearGiantProfile) (n : Nat) :
    profile.fraction * n <= profile.adjustedSize n := by
  by_cases hn : profile.start <= n
  · simpa [LinearGiantProfile.adjustedSize, hn] using
      profile.linear_lower n hn
  · simp [LinearGiantProfile.adjustedSize, hn]
    have hnReal : 0 <= (n : Real) := by positivity
    nlinarith [mul_le_mul_of_nonneg_right profile.fraction_le_one hnReal]

theorem LinearGiantProfile.conditionalLoss_tendsto_zero
    (profile : LinearGiantProfile) :
    Tendsto (fun n => conditionalLoss n (profile.size n))
      atTop (nhds 0) := by
  have hAdjusted :
      Tendsto (fun n => conditionalLoss n (profile.adjustedSize n))
        atTop (nhds 0) :=
    conditionalLoss_tendsto_zero_of_linear_size
      profile.adjustedSize profile.fraction profile.fraction_pos
      profile.adjustedSize_le profile.linear_lower_adjusted
  apply hAdjusted.congr'
  filter_upwards [eventually_ge_atTop profile.start] with n hn
  simp [LinearGiantProfile.adjustedSize, hn]

noncomputable def blockingThreshold (firstMoment factorialMoment : Real) : Real :=
  1 - firstMoment / factorialMoment

theorem effectiveMean_supercritical_iff
    {meanDegree : Real} (hMean : 0 < meanDegree) (blocking : Real) :
    1 < meanDegree * (1 - blocking) <->
      blocking < 1 - 1 / meanDegree := by
  have hRatio : 1 / meanDegree < 1 - blocking <->
      1 < (1 - blocking) * meanDegree :=
    div_lt_iff₀ hMean
  constructor
  · intro h
    have : 1 / meanDegree < 1 - blocking := by
      apply hRatio.mpr
      nlinarith
    linarith
  · intro h
    have hDiv : 1 / meanDegree < 1 - blocking := by linarith
    have := hRatio.mp hDiv
    nlinarith

theorem blockingThreshold_mem_openUnit
    {firstMoment factorialMoment : Real}
    (hFirst : 0 < firstMoment)
    (hMoments : firstMoment < factorialMoment) :
    0 < blockingThreshold firstMoment factorialMoment /\
      blockingThreshold firstMoment factorialMoment < 1 := by
  have hFactorial : 0 < factorialMoment := lt_trans hFirst hMoments
  have hRatioPos : 0 < firstMoment / factorialMoment :=
    div_pos hFirst hFactorial
  have hRatioLtOne : firstMoment / factorialMoment < 1 :=
    (div_lt_one hFactorial).2 hMoments
  unfold blockingThreshold
  constructor <;> linarith

theorem retainedMoment_supercritical_iff
    {firstMoment factorialMoment : Real}
    (hFirst : 0 < firstMoment)
    (hMoments : firstMoment < factorialMoment)
    (blocking : Real) :
    firstMoment < (1 - blocking) * factorialMoment <->
      blocking < blockingThreshold firstMoment factorialMoment := by
  have hFactorial : 0 < factorialMoment := lt_trans hFirst hMoments
  have hRatio : firstMoment / factorialMoment < 1 - blocking <->
      firstMoment < (1 - blocking) * factorialMoment :=
    div_lt_iff₀ hFactorial
  unfold blockingThreshold
  constructor
  · intro h
    have hDiv := hRatio.mpr h
    linarith
  · intro h
    apply hRatio.mp
    linarith

def ERReferencePremise : Prop :=
  (forall c : Real, 0 < c -> c < 1 ->
    Nonempty LocalFragmentationProfile) /\
  (forall c : Real, 1 < c ->
    Nonempty LinearGiantProfile)

def ERPhaseClaim : Prop :=
  (forall c : Real, 0 < c -> c < 1 ->
    exists profile : LocalFragmentationProfile,
      forall n, max 3 profile.start <= n ->
        profile.rho / 4 <= (profile.law n).expectedLoss /\
        (profile.law n).expectedLoss <= 1) /\
  (forall c : Real, 1 < c ->
    exists profile : LinearGiantProfile,
      Tendsto (fun n => conditionalLoss n (profile.size n))
        atTop (nhds 0)) /\
  (forall c p : Real, 0 < c ->
    (1 < c * (1 - p) <-> p < 1 - 1 / c))

theorem erPhaseClaim_from_references
    (hReference : ERReferencePremise) : ERPhaseClaim := by
  constructor
  · intro c hCPositive hCSubcritical
    obtain ⟨profile⟩ := hReference.1 c hCPositive hCSubcritical
    exact ⟨profile, localFragmentation_expectedLoss_constantOrder profile⟩
  · constructor
    · intro c hCSupercritical
      obtain ⟨profile⟩ := hReference.2 c hCSupercritical
      exact ⟨profile, profile.conditionalLoss_tendsto_zero⟩
    · intro c p hCPositive
      exact effectiveMean_supercritical_iff hCPositive p

def PowerLawReferencePremise : Prop :=
  (forall gamma blocking : Real,
    2 < gamma -> gamma < 3 -> 0 <= blocking -> blocking < 1 ->
      Nonempty LinearGiantProfile) /\
  (forall firstMoment factorialMoment blocking : Real,
    0 < firstMoment -> firstMoment < factorialMoment ->
    blocking < blockingThreshold firstMoment factorialMoment ->
      Nonempty LinearGiantProfile)

def PowerLawPhaseClaim : Prop :=
  (forall gamma blocking : Real,
    2 < gamma -> gamma < 3 -> 0 <= blocking -> blocking < 1 ->
      exists profile : LinearGiantProfile,
        Tendsto (fun n => conditionalLoss n (profile.size n))
          atTop (nhds 0)) /\
  (forall firstMoment factorialMoment : Real,
    0 < firstMoment -> firstMoment < factorialMoment ->
      0 < blockingThreshold firstMoment factorialMoment /\
      blockingThreshold firstMoment factorialMoment < 1 /\
      (forall blocking : Real,
        (firstMoment < (1 - blocking) * factorialMoment <->
          blocking < blockingThreshold firstMoment factorialMoment)) /\
      (forall blocking : Real,
        blocking < blockingThreshold firstMoment factorialMoment ->
          exists profile : LinearGiantProfile,
            Tendsto (fun n => conditionalLoss n (profile.size n))
              atTop (nhds 0)))

theorem powerLawPhaseClaim_from_references
    (hReference : PowerLawReferencePremise) : PowerLawPhaseClaim := by
  constructor
  · intro gamma blocking hGammaLow hGammaHigh hBlockingNonnegative hBlocking
    obtain ⟨profile⟩ := hReference.1 gamma blocking
      hGammaLow hGammaHigh hBlockingNonnegative hBlocking
    exact ⟨profile, profile.conditionalLoss_tendsto_zero⟩
  · intro firstMoment factorialMoment hFirst hMoments
    obtain ⟨hThresholdPositive, hThresholdBelowOne⟩ :=
      blockingThreshold_mem_openUnit hFirst hMoments
    refine ⟨hThresholdPositive, hThresholdBelowOne, ?_, ?_⟩
    · intro blocking
      exact retainedMoment_supercritical_iff hFirst hMoments blocking
    · intro blocking hBlocking
      obtain ⟨profile⟩ := hReference.2
        firstMoment factorialMoment blocking hFirst hMoments hBlocking
      exact ⟨profile, profile.conditionalLoss_tendsto_zero⟩

end BlackwellDilemma.RandomGraphPhase
