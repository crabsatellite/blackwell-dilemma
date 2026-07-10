/-
  BlackwellDilemma/UnifiedTopoCluster.lean

  Exact finite topological-loss algebra, the linear-cluster conditional
  envelope, and an unconditional lower bound from persistent singleton mass.
  The external order-statistics reference supplies only the identification of
  the finite formula with iid Uniform[0,1] expected maxima.
-/

import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

namespace BlackwellDilemma.TopoCluster

open Filter Topology
open scoped BigOperators

/-- The iid-Uniform order-statistics loss after conditioning on a reachable
    set of size `k` inside a population of size `n`. -/
noncomputable def conditionalLoss (n k : Nat) : Real :=
  (n : Real) / (n + 1) - (k : Real) / (k + 1)

theorem conditionalLoss_eq_ratio (n k : Nat) :
    conditionalLoss n k =
      ((n : Real) - k) / ((n + 1) * (k + 1)) := by
  unfold conditionalLoss
  have hn : (n : Real) + 1 ≠ 0 := by positivity
  have hk : (k : Real) + 1 ≠ 0 := by positivity
  field_simp
  ring

theorem conditionalLoss_nonneg {n k : Nat} (hk : k <= n) :
    0 <= conditionalLoss n k := by
  rw [conditionalLoss_eq_ratio]
  exact div_nonneg
    (sub_nonneg.mpr (by exact_mod_cast hk))
    (mul_nonneg (by positivity) (by positivity))

theorem conditionalLoss_le_one {n k : Nat} :
    conditionalLoss n k <= 1 := by
  unfold conditionalLoss
  have hnDen : (0 : Real) < (n : Real) + 1 := by positivity
  have hnFrac : (n : Real) / (n + 1) <= 1 := by
    apply (div_le_one hnDen).2
    norm_num
  have hkFrac : 0 <= (k : Real) / (k + 1) := by positivity
  linarith

/-- A cluster containing at least a fixed fraction `c` of the population has
    conditional topological loss bounded by `1 / (c * (n + 1))`. -/
theorem conditionalLoss_le_linear_envelope
    (n k : Nat) (c : Real) (hc : 0 < c)
    (hkUpper : k <= n) (hkLower : c * n <= k) :
    conditionalLoss n k <= 1 / (c * ((n : Real) + 1)) := by
  rw [conditionalLoss_eq_ratio]
  have hn1 : (0 : Real) < (n : Real) + 1 := by positivity
  have hk1 : (0 : Real) < (k : Real) + 1 := by positivity
  have hLeftDen : (0 : Real) < ((n : Real) + 1) * ((k : Real) + 1) :=
    mul_pos hn1 hk1
  have hRightDen : (0 : Real) < c * ((n : Real) + 1) :=
    mul_pos hc hn1
  have hkUpperReal : (k : Real) <= n := by exact_mod_cast hkUpper
  have hCore : c * ((n : Real) - k) <= (k : Real) + 1 := by
    have hSub : (n : Real) - k <= n := by linarith
    have hScaled : c * ((n : Real) - k) <= c * n :=
      mul_le_mul_of_nonneg_left hSub hc.le
    linarith
  rw [div_le_div_iff₀ hLeftDen hRightDen]
  nlinarith

theorem linearEnvelope_tendsto_zero (c : Real) (hc : 0 < c) :
    Tendsto (fun n : Nat => 1 / (c * ((n : Real) + 1)))
      atTop (nhds 0) := by
  have hBase :
      Tendsto (fun n : Nat => 1 / ((n : Real) + 1)) atTop (nhds 0) :=
    tendsto_one_div_add_atTop_nhds_zero_nat
  have hConst :
      Tendsto (fun _ : Nat => (1 / c : Real)) atTop (nhds (1 / c)) :=
    tendsto_const_nhds
  have hScaled :
      Tendsto (fun n : Nat => (1 / c) * (1 / ((n : Real) + 1)))
        atTop (nhds ((1 / c) * 0)) :=
    hConst.mul hBase
  have hFunction :
      (fun n : Nat => 1 / (c * ((n : Real) + 1))) =
        fun n : Nat => (1 / c) * (1 / ((n : Real) + 1)) := by
    funext n
    field_simp [hc.ne']
  rw [hFunction]
  simpa using hScaled

theorem conditionalLoss_tendsto_zero_of_linear_size
    (k : Nat -> Nat) (c : Real) (hc : 0 < c)
    (hkUpper : forall n, k n <= n)
    (hkLower : forall n, c * n <= k n) :
    Tendsto (fun n => conditionalLoss n (k n)) atTop (nhds 0) := by
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le
    tendsto_const_nhds
    (linearEnvelope_tendsto_zero c hc)
    (fun n => conditionalLoss_nonneg (hkUpper n))
    (fun n => conditionalLoss_le_linear_envelope
      n (k n) c hc (hkUpper n) (hkLower n))

/-- A finite law for reachable-set cardinality. Index `j : Fin (n+1)`
    represents cardinality `j`; a real root-cluster law puts zero mass at 0,
    but the bounds below do not need that extra restriction. -/
structure ClusterSizeLaw (n : Nat) where
  prob : Fin (n + 1) -> Real
  prob_nonneg : forall j, 0 <= prob j
  prob_sum_one : Finset.univ.sum prob = 1

namespace ClusterSizeLaw

def oneIndex (n : Nat) (hn : 1 <= n) : Fin (n + 1) :=
  ⟨1, by omega⟩

noncomputable def expectedLoss {n : Nat} (law : ClusterSizeLaw n) : Real :=
  Finset.univ.sum (fun j => law.prob j * conditionalLoss n j)

theorem expectedLoss_nonneg {n : Nat} (law : ClusterSizeLaw n) :
    0 <= law.expectedLoss := by
  unfold expectedLoss
  exact Finset.sum_nonneg (fun j _ =>
    mul_nonneg (law.prob_nonneg j)
      (conditionalLoss_nonneg (Nat.lt_succ_iff.mp j.isLt)))

theorem expectedLoss_le_one {n : Nat} (law : ClusterSizeLaw n) :
    law.expectedLoss <= 1 := by
  unfold expectedLoss
  calc
    Finset.univ.sum (fun j => law.prob j * conditionalLoss n j) <=
        Finset.univ.sum law.prob := by
      apply Finset.sum_le_sum
      intro j _
      simpa using mul_le_mul_of_nonneg_left
        conditionalLoss_le_one
        (law.prob_nonneg j)
    _ = 1 := law.prob_sum_one

theorem expectedLoss_ge_singleton_term
    {n : Nat} (law : ClusterSizeLaw n) (hn : 1 <= n) :
    law.prob (oneIndex n hn) * conditionalLoss n 1 <= law.expectedLoss := by
  unfold expectedLoss
  exact Finset.single_le_sum
    (fun j _ => mul_nonneg (law.prob_nonneg j)
      (conditionalLoss_nonneg (Nat.lt_succ_iff.mp j.isLt)))
    (Finset.mem_univ (oneIndex n hn))

theorem conditionalLoss_at_one (n : Nat) :
    conditionalLoss n 1 = ((n : Real) - 1) / (2 * ((n : Real) + 1)) := by
  rw [conditionalLoss_eq_ratio]
  ring

theorem quarter_le_conditionalLoss_at_one
    {n : Nat} (hn : 3 <= n) :
    (1 : Real) / 4 <= conditionalLoss n 1 := by
  rw [conditionalLoss_at_one]
  have hnReal : (3 : Real) <= n := by exact_mod_cast hn
  have hDen : (0 : Real) < 2 * ((n : Real) + 1) := by positivity
  rw [div_le_div_iff₀ (by norm_num : (0 : Real) < 4) hDen]
  nlinarith

theorem expectedLoss_ge_of_singleton_mass
    {n : Nat} (law : ClusterSizeLaw n) (hn : 1 <= n)
    (rho : Real)
    (hMass : rho <= law.prob (oneIndex n hn)) :
    rho * conditionalLoss n 1 <= law.expectedLoss := by
  calc
    rho * conditionalLoss n 1 <=
        law.prob (oneIndex n hn) * conditionalLoss n 1 :=
      mul_le_mul_of_nonneg_right hMass
        (conditionalLoss_nonneg hn)
    _ <= law.expectedLoss := law.expectedLoss_ge_singleton_term hn

/-- A persistent positive mass on singleton reachable sets keeps the
    unconditional expected topological loss bounded away from zero. Together
    with the unit upper bound, this is the exact constant-order statement. -/
theorem expectedLoss_constant_order_of_singleton_mass
    (law : forall n, ClusterSizeLaw n)
    (rho : Real) (hrho : 0 < rho)
    (hMass : forall n (hn : 1 <= n),
      rho <= (law n).prob (oneIndex n hn)) :
    forall n, 3 <= n ->
      rho / 4 <= (law n).expectedLoss /\ (law n).expectedLoss <= 1 := by
  intro n hn
  have hnOne : 1 <= n := le_trans (by norm_num) hn
  have hLower := (law n).expectedLoss_ge_of_singleton_mass
    hnOne rho (hMass n hnOne)
  have hQuarter := quarter_le_conditionalLoss_at_one hn
  constructor
  · calc
      rho / 4 = rho * ((1 : Real) / 4) := by ring
      _ <= rho * conditionalLoss n 1 :=
        mul_le_mul_of_nonneg_left hQuarter hrho.le
      _ <= (law n).expectedLoss := hLower
  · exact (law n).expectedLoss_le_one

end ClusterSizeLaw

def TopoClusterClaim : Prop :=
  (forall n k : Nat, conditionalLoss n k =
      ((n : Real) - k) / ((n + 1) * (k + 1))) /\
  (forall (k : Nat -> Nat) (c : Real), 0 < c ->
      (forall n, k n <= n) ->
      (forall n, c * n <= k n) ->
      Tendsto (fun n => conditionalLoss n (k n)) atTop (nhds 0)) /\
  (forall (law : forall n, ClusterSizeLaw n) (rho : Real), 0 < rho ->
      (forall n (hn : 1 <= n),
        rho <= (law n).prob (ClusterSizeLaw.oneIndex n hn)) ->
      forall n, 3 <= n ->
        rho / 4 <= (law n).expectedLoss /\ (law n).expectedLoss <= 1)

theorem topoClusterClaim_proved : TopoClusterClaim := by
  exact
    ⟨conditionalLoss_eq_ratio,
      conditionalLoss_tendsto_zero_of_linear_size,
      ClusterSizeLaw.expectedLoss_constant_order_of_singleton_mass⟩

end BlackwellDilemma.TopoCluster
