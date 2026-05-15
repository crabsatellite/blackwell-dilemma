/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Topology.Algebra.Order.Field
import Mathlib.Order.Filter.Basic
import Mathlib.Topology.MetricSpace.Basic
import Mathlib.Tactic.Linarith

/-!
# Filter Tendsto arithmetic atoms (Cat 1)

This file provides **packaged Tendsto preservation atoms** for sums,
scalars, and limits, ergonomically convenient for paper-bridge work.

## Main results

* `Tendsto.add_const_real` — `f → L` ⇒ `f + c → L + c`.
* `Tendsto.const_smul_real` — `f → L` ⇒ `c · f → c · L`.
* `Tendsto.sub_const_real` — `f → L` ⇒ `f - c → L - c`.
* `Tendsto_const_real` — constant function tends to itself.

## Bridge to paper carriers

Paper's `mLimit p`, `W_bar_limit_infty`, `agentRewardKernel_greedy_limit`
are all "limit at infinity" carriers. The Tendsto atoms below provide
the algebraic bridge between concrete-function-with-explicit-Tendsto
and abstract-carrier-with-paper-stipulated-Tendsto.

## Cat 1 status

Built only from `Mathlib.Topology.Algebra.Order.Field`. No paper-novel
axioms, no `sorry`. The atoms are minor packagings of Mathlib's
`Tendsto.add`, `Tendsto.const_mul`, etc.

## Tags

Tendsto, Filter, limit, arithmetic atoms, Mathlib PR
-/

namespace BlackwellDilemma.Infrastructure

open Filter

/-! ### Tendsto arithmetic on real-valued functions -/

/-- **Tendsto + const**: `f → L` ⇒ `f + c → L + c`. -/
theorem Tendsto.add_const_real {α : Type*} {f : α → ℝ} {l : Filter α} {L : ℝ}
    (hf : Tendsto f l (nhds L)) (c : ℝ) :
    Tendsto (fun x => f x + c) l (nhds (L + c)) :=
  hf.add (tendsto_const_nhds)

/-- **Tendsto - const**: `f → L` ⇒ `f - c → L - c`. -/
theorem Tendsto.sub_const_real {α : Type*} {f : α → ℝ} {l : Filter α} {L : ℝ}
    (hf : Tendsto f l (nhds L)) (c : ℝ) :
    Tendsto (fun x => f x - c) l (nhds (L - c)) :=
  hf.sub (tendsto_const_nhds)

/-- **Tendsto · const**: `f → L` ⇒ `c · f → c · L`. -/
theorem Tendsto.const_smul_real {α : Type*} {f : α → ℝ} {l : Filter α} {L c : ℝ}
    (hf : Tendsto f l (nhds L)) :
    Tendsto (fun x => c * f x) l (nhds (c * L)) :=
  (tendsto_const_nhds).mul hf

/-- **Constant function tends to itself.** -/
theorem Tendsto.const_real {α : Type*} {l : Filter α} (c : ℝ) :
    Tendsto (fun _ : α => c) l (nhds c) := tendsto_const_nhds

/-- **Tendsto sum of two functions**. -/
theorem Tendsto.add_real {α : Type*} {f g : α → ℝ} {l : Filter α} {L M : ℝ}
    (hf : Tendsto f l (nhds L)) (hg : Tendsto g l (nhds M)) :
    Tendsto (fun x => f x + g x) l (nhds (L + M)) := hf.add hg

/-! ### Kernel-purity audit -/

#print axioms Tendsto.add_const_real
#print axioms Tendsto.const_smul_real

end BlackwellDilemma.Infrastructure
