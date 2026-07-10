/-
  BlackwellDilemma/UnifiedPhase.lean

  Reference-conditioned square-lattice connectivity regimes and their exact
  welfare translation. The external premise supplies the percolation profiles;
  the kernel proves every economic inequality and limit derived from them.
-/

import BlackwellDilemma.Infrastructure.BernoulliProductFinite
import BlackwellDilemma.UnifiedInformationDecay
import BlackwellDilemma.UnifiedTopoCluster

namespace BlackwellDilemma.LatticePhase

open Filter Topology

/-- The four incident edges around a square-lattice vertex are blocked. -/
def allBlockedFour : Fin 4 -> Bool := fun _ => false

/-- Under independent edge retention `1 - p`, the local all-blocked event has
    exact mass `p^4`. -/
theorem allBlockedFour_weight (p : Real) :
    Infrastructure.bernoulliWeight
        (1 - p) Finset.univ allBlockedFour = p ^ 4 := by
  norm_num [Infrastructure.bernoulliWeight,
    Infrastructure.bernoulliFactor, allBlockedFour]

/-- A finite-torus supercritical-open profile. The reference layer supplies
    positive giant membership and a uniform positive lower size fraction. -/
structure GiantRegimeProfile (_blocking : Real) where
  population : Nat -> Nat
  giantSize : Nat -> Nat
  sizeFractionLower : Real
  giantFraction : Real
  membershipProbability : Nat -> Real
  population_tendsto : Tendsto population atTop atTop
  sizeFractionLower_pos : 0 < sizeFractionLower
  giantFraction_pos : 0 < giantFraction
  giantSize_le : forall index, giantSize index <= population index
  giantSize_linear : forall index,
    sizeFractionLower * population index <= giantSize index
  membership_tendsto :
    Tendsto membershipProbability atTop (nhds giantFraction)

/-- A finite-torus subcritical-open profile. The local isolation field links
    the Bernoulli product event to the singleton atom of the same cluster law;
    the moment identity links that law to the Gaussian oracle environment. -/
structure FragmentedRegimeProfile (blocking : Real) where
  population : Nat -> Nat
  population_ge_three : forall index, 3 <= population index
  law : forall index, TopoCluster.ClusterSizeLaw (population index)
  membershipProbability : Nat -> Real
  membership_tendsto_zero :
    Tendsto membershipProbability atTop (nhds 0)
  network : Nat -> InformationDecay.NetworkOracleEnvironment.{0}
  selection : forall index beta,
    InformationDecay.GaussianNetworkSelection.{0}
      (network index) (InformationDecay.signalNoise beta)
  cardBound : Real
  cardBound_nonneg : 0 <= cardBound
  clusterMoment_le : forall index,
    (law index).expectedCard <= cardBound
  networkMoment_eq_cluster : forall index,
    (network index).expectedCard = (law index).expectedCard
  localIsolationIncluded : forall index,
    Infrastructure.bernoulliWeight
        (1 - blocking) Finset.univ allBlockedFour <=
      (law index).prob
        (TopoCluster.ClusterSizeLaw.oneIndex
          (population index) (le_trans (by omega) (population_ge_three index)))

def GiantRegimeConclusion {p : Real} (profile : GiantRegimeProfile p) : Prop :=
  Tendsto profile.membershipProbability atTop (nhds profile.giantFraction) /\
    Tendsto
      (fun index => TopoCluster.conditionalLoss
        (profile.population index) (profile.giantSize index))
      atTop (nhds 0)

def FragmentedRegimeConclusion {p : Real}
    (profile : FragmentedRegimeProfile p) : Prop :=
  Tendsto profile.membershipProbability atTop (nhds 0) /\
    (forall index,
      p ^ 4 / 4 <= (profile.law index).expectedLoss /\
        (profile.law index).expectedLoss <= 1) /\
    (forall index beta, 1 <= beta ->
      (profile.selection index beta).informationComponent <= 0 /\
      abs (profile.selection index beta).informationComponent <=
        (2 * profile.cardBound / Real.sqrt (2 * Real.pi)) *
          (2 : Real) ^ (-beta))

theorem giantRegimeConclusion_proved {p : Real}
    (profile : GiantRegimeProfile p) :
    GiantRegimeConclusion profile := by
  refine And.intro profile.membership_tendsto ?_
  have hEnvelope :
      Tendsto
        (fun index =>
          1 / (profile.sizeFractionLower *
            ((profile.population index : Nat) : Real) +
              profile.sizeFractionLower))
        atTop (nhds 0) := by
    have hBase :=
      (TopoCluster.linearEnvelope_tendsto_zero
        profile.sizeFractionLower profile.sizeFractionLower_pos).comp
          profile.population_tendsto
    simpa [Function.comp_def, mul_add] using hBase
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le
    tendsto_const_nhds
    hEnvelope
    (fun index => TopoCluster.conditionalLoss_nonneg
      (profile.giantSize_le index))
    (fun index => by
      simpa [mul_add] using TopoCluster.conditionalLoss_le_linear_envelope
        (profile.population index) (profile.giantSize index)
        profile.sizeFractionLower profile.sizeFractionLower_pos
        (profile.giantSize_le index) (profile.giantSize_linear index))

theorem fragmentedRegimeConclusion_proved {p : Real}
    (hpHalf : (1 : Real) / 2 < p)
    (profile : FragmentedRegimeProfile p) :
    FragmentedRegimeConclusion profile := by
  refine And.intro profile.membership_tendsto_zero ?_
  constructor
  · intro index
    have hnThree := profile.population_ge_three index
    have hnOne : 1 <= profile.population index := le_trans (by omega) hnThree
    have hMass :
        p ^ 4 <=
          (profile.law index).prob
            (TopoCluster.ClusterSizeLaw.oneIndex
              (profile.population index) hnOne) := by
      rw [<- allBlockedFour_weight p]
      exact profile.localIsolationIncluded index
    have hLower :=
      (profile.law index).expectedLoss_ge_of_singleton_mass
        hnOne (p ^ 4) hMass
    have hQuarter :=
      TopoCluster.ClusterSizeLaw.quarter_le_conditionalLoss_at_one hnThree
    have hpPos : 0 < p := by linarith
    have hpFourthNonneg : 0 <= p ^ 4 := (pow_pos hpPos 4).le
    constructor
    · calc
        p ^ 4 / 4 = p ^ 4 * ((1 : Real) / 4) := by ring
        _ <= p ^ 4 * TopoCluster.conditionalLoss
              (profile.population index) 1 :=
          mul_le_mul_of_nonneg_left hQuarter hpFourthNonneg
        _ <= (profile.law index).expectedLoss := hLower
    · exact (profile.law index).expectedLoss_le_one
  · have hCard : forall index,
        (profile.network index).expectedCard <= profile.cardBound := by
      intro index
      rw [profile.networkMoment_eq_cluster index]
      exact profile.clusterMoment_le index
    exact InformationDecay.uniform_information_decay
      profile.network profile.selection profile.cardBound
      profile.cardBound_nonneg hCard

/-- This is the exact external interface checked by the reference-evidence
    gate. It ranges over every fixed blocking probability strictly on either
    side of the square-lattice threshold and does not assert a critical-case
    welfare limit. -/
structure SquareLatticeReferenceData where
  below : forall p : Real, 0 < p -> p < (1 : Real) / 2 ->
    GiantRegimeProfile p
  above : forall p : Real, (1 : Real) / 2 < p -> p < 1 ->
    FragmentedRegimeProfile p

def SquareLatticePhaseConclusion
    (data : SquareLatticeReferenceData) : Prop :=
  (forall p hp0 hpHalf,
      GiantRegimeConclusion (data.below p hp0 hpHalf)) /\
    (forall p hpHalf hp1,
      FragmentedRegimeConclusion (data.above p hpHalf hp1))

theorem squareLatticePhaseConclusion_proved
    (data : SquareLatticeReferenceData) :
    SquareLatticePhaseConclusion data := by
  constructor
  · intro p hp0 hpHalf
    exact giantRegimeConclusion_proved (data.below p hp0 hpHalf)
  · intro p hpHalf hp1
    exact fragmentedRegimeConclusion_proved hpHalf
      (data.above p hpHalf hp1)

/-- Published percolation theorems supply an inhabitant of the reference data
    interface. Lean deliberately does not manufacture this premise. -/
def SquareLatticePercolationPremise : Prop :=
  Nonempty SquareLatticeReferenceData

def LatticePhaseClaim : Prop :=
  Exists fun data : SquareLatticeReferenceData =>
    SquareLatticePhaseConclusion data

theorem latticePhaseClaim_from_references :
    SquareLatticePercolationPremise -> LatticePhaseClaim := by
  rintro ⟨data⟩
  exact ⟨data, squareLatticePhaseConclusion_proved data⟩

end BlackwellDilemma.LatticePhase
