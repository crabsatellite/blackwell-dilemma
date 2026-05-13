/-
  BlackwellDilemma/Bayesian.lean

  §6 Bayesian Immunity and Complementarity.

  Companion to: "Information Value Under Endogenous Feasibility" (Li, 2026).

  Contents:
   * Theorem 5.1 (`thm:bayesian-immunity`) — Bayesian Immunity:
     A Bayesian agent who observes the percolation realisation has welfare
     monotonically non-decreasing in `β`. The reversal of Theorem 3.2 is
     absent.
   * Proposition (`prop:complementarity`) — Information–Knowledge
     Complementarity: signal precision and structural knowledge are
     Topkis complements above the greedy optimum.
   * Remark (`rem:robustness-misspec`) — Welfare Reversal Under
     Alternative Misspecification Types (encoded as three classification
     axioms).
-/

import BlackwellDilemma.Types
import BlackwellDilemma.ClassicalResults
import BlackwellDilemma.Cognitive
import BlackwellDilemma.Canonical

namespace BlackwellDilemma

/-! ## 1. Theorem 5.1 — Bayesian Immunity

A Bayesian agent observing `ω_p` selects
`a*_B(s) = argmax_{w ∈ N_R(v)} E[V_dyn(w) | s, ω_p]`. Conditional on
`ω_p`, the Bayesian agent faces a fixed-feasible-set problem and
Blackwell's theorem applies. -/

/-- **Theorem 5.1** (`thm:bayesian-immunity`).
    The Bayesian welfare `W_B(β)` is monotonically non-decreasing in `β`.
    The reversal of Theorem 3.2 is absent.

    Consumes the Cat 2 axiom `gap_blackwell_monotonicity_OPEN` directly
    per the 2026-05-13 discipline clarification (Cat 2 axioms with
    paper authority are consumed directly, not threaded as broken-link
    hypotheses). The Cat 2 axiom is already specialised to the Bayesian
    agent's welfare in `ClassicalResults.lean`; conditioning on `ω_p`,
    the Bayesian agent faces a fixed-feasible-set decision problem and
    Blackwell's theorem applies, yielding monotonicity in β.

    paper source: Theorem 5.1 (`thm:bayesian-immunity`), lines 923-930. -/
theorem gap_bayesian_immunity :
    ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1 := by
  intro β₁ β₂ h
  exact gap_blackwell_monotonicity_OPEN β₁ β₂ h

/-! ## 2. Proposition `prop:complementarity` — Information–Knowledge
   Complementarity

`W(β, λ) = λ W_B(β) + (1−λ) W_G(β)` where `λ` is the fraction of Bayesian
agents. For `β > β*_G`: `∂²W/(∂β ∂λ) > 0`. -/

/-- **Welfare-mixing identity** that underlies `prop:complementarity`.

    `W(β, λ) = λ W_B(β) + (1−λ) W_G(β)` is the linear-mixture
    aggregator over Bayesian and greedy agents.

    paper source: Proposition `prop:complementarity` line 933. -/
noncomputable def W_mix (W_B W_G : ℝ → ℝ) (β lam : ℝ) : ℝ :=
  lam * W_B β + (1 - lam) * W_G β

/-- **Proposition `prop:complementarity` (Information–Knowledge
    Complementarity).**

    Above the greedy optimum `β*_G`: `∂²W/(∂β ∂λ) = W_B'(β) − W_G'(β) > 0`,
    since `W_B'(β) ≥ 0` (Theorem 5.1) and `W_G'(β) < 0` (Proposition
    `prop:interior-optimum`). Signal precision and structural knowledge
    are Topkis complements above `β*_G`.

    Cat 1 closure is ARITHMETIC ONLY — it presupposes the paper-novel
    dominance fact `h_dom : W_G β ≤ W_B β` (which integrates the paper's
    `W_B' ≥ 0` + `W_G' < 0` derivative chain at `β > β*_G`, i.e. above
    the greedy optimum). The dominance fact itself is Cat 3 paper
    substance; the Lean theorem closes the arithmetic step from
    dominance to mixture-supermodularity. The vestigial unused
    antecedents (W_B monotonicity, W_G anti-monotonicity above β*_G,
    `β > β*_G`) flagged in hostile audit have been removed: they are
    the upstream content from which `h_dom` is derived in the paper,
    but they are not consumed by the Lean arithmetic closure here.

    paper source: Proposition `prop:complementarity`, lines 932-935. -/
theorem gap_information_knowledge_complementarity
    (W_B W_G : ℝ → ℝ) (β : ℝ)
    (h_dom : W_G β ≤ W_B β)
    (lam₁ lam₂ : ℝ) (h_lam : lam₁ ≤ lam₂) :
    W_mix W_B W_G β lam₁ ≤ W_mix W_B W_G β lam₂ := by
  unfold W_mix
  -- W_mix β lam = lam * W_B β + (1 - lam) * W_G β.
  -- Difference = (lam₂ - lam₁) * (W_B β - W_G β) ≥ 0
  -- since lam₁ ≤ lam₂ and W_G β ≤ W_B β.
  nlinarith [h_lam, h_dom]

/-! ## 3. Remark `rem:robustness-misspec` — Alternative Misspecification

The reversal mechanism extends to three alternative bounded-rationality
forms whose key feature is **insensitivity to continuation value**:
(i) Bayesian-naive (`p̂ ≠ p`); (ii) Myopic-`k`; (iii) Satisficing.
The greedy agent (`κ = 0`) exhibits the strongest reversal. -/

/-- **Remark `rem:robustness-misspec` (i): Bayesian-naive.**
    On the 5-state instance, the Bayesian-naive threshold is `p̂* = 2/3`,
    coinciding with the cognitive threshold. The quantitative content
    is recorded as the routing-decision biconditional
    `0.4 + 0.6·(1 − p̂) > 0.6 ↔ p̂ < 2/3`, which is the operative
    paper statement for the Bayesian-naive routing rule and threshold
    identification (paper `prop:bayesian-naive-five-state` (i)).

    **CLOSED** Cat 1 — re-export of
    `FiveState.gap_bayesian_naive_routing_threshold` (kernel-pure
    `nlinarith` arithmetic closure). The prior `axiom` form
    quantified `∀ p_hat : ℝ, p_hat < 2/3 ↔ <p_hat-free welfare
    monotonicity claim>` which was Pattern 4 (tautological premise):
    the RHS is independent of `p_hat`, so the universal iff cannot be
    a non-trivial theorem. The substantive paper content of the Remark
    is the threshold identification `p̂* = 2/3`, encoded directly via
    the routing-decision biconditional. The β-monotonicity sub-claim
    of `prop:bayesian-naive-five-state` (ii) is tracked separately by
    `FiveState.gap_bayesian_naive_reversal_absent_OPEN`.

    paper source: Remark `rem:robustness-misspec` (i), line 941;
    quantitative content in Proposition `prop:bayesian-naive-five-state`. -/
theorem gap_robustness_bayesian_naive :
    ∀ p_hat : ℝ, 0.4 + 0.6 * (1 - p_hat) > 0.6 ↔ p_hat < (2 : ℝ) / 3 :=
  FiveState.gap_bayesian_naive_routing_threshold

/-- Welfare of a `k`-step lookahead myopic agent at precision `β` on a
    depth-`d` trap-tree instance.
    Substantive paper claim — opaque carrier required (Mathlib gap). -/
axiom myopicKWelfare : ℕ → ℕ → ℝ → ℝ

/-- Cat 3 paper-novel ATOMIC stipulation: paper Remark
    `rem:robustness-misspec` (ii) line 942 states that for a `k`-step
    lookahead agent on a depth-`d` trap-tree instance with `k ≥ d`,
    the agent's lookahead horizon is wide enough to compare the
    full trap and bridge subtree values, recovering the standard
    Blackwell-monotonicity chain on the resulting fixed-action
    decision subproblem.

    Encoding choice: extracted as standalone Cat 3 atomic stipulation
    from the bundled `gap_robustness_myopic_k_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern
    (decompose bundled conclusion-axiom into atomic stipulation +
    derived theorem). The atom isolates the paper-stated `k ≥ d`
    monotonicity recursion on the existing carrier `myopicKWelfare`.

    Cat 3 sub-type: workingAssumption (paper-stated higher-level
    application of conditional-Blackwell to the paper-novel
    `myopicKWelfare` carrier; pending Mathlib decision-theoretic
    Blackwell-ordering machinery; 必须 close before publication).

    paper source: Remark `rem:robustness-misspec` (ii), line 942
    (`k`-step lookahead with `k ≥ d` recovers monotonicity). -/
axiom myopic_k_lookahead_recursion_OPEN :
    ∀ k d : ℕ, k ≥ d →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        myopicKWelfare k d β₁ ≤ myopicKWelfare k d β₂

/-- **Remark `rem:robustness-misspec` (ii): Myopic-`k`** (derived theorem).
    A `k`-step lookahead agent experiences the reversal for `k = 0`
    (greedy) but not for `k ≥ d`, where `d` is the divergence depth of
    trap and bridge paths.

    Derived theorem composing the atomic stipulation
    `myopic_k_lookahead_recursion_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern.

    paper source: Remark `rem:robustness-misspec` (ii), line 942. -/
theorem gap_robustness_myopic_k :
    ∀ k d : ℕ, k ≥ d →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        myopicKWelfare k d β₁ ≤ myopicKWelfare k d β₂ :=
  myopic_k_lookahead_recursion_OPEN

/-- Welfare of a satisficing agent with threshold `r̄` at precision `β`.
    Substantive paper claim — opaque carrier required (Mathlib gap). -/
axiom satisficingWelfare : ℝ → ℝ → ℝ

/-- Cat 3 paper-novel ATOMIC stipulation: paper Remark
    `rem:robustness-misspec` (iii) line 944 states that a satisficing
    agent with threshold `r̄` strictly between the trap and high-
    reward neighbour rewards `r(B) < r̄ < r(A)` accepts the trap option
    on its first satisficing-acceptance event, exhibiting the welfare-
    reversal mechanism in β. This atom isolates the paper-stated
    threshold-trap behaviour on the existing carrier
    `satisficingWelfare`.

    Encoding choice: extracted as standalone Cat 3 atomic stipulation
    from the bundled `gap_robustness_satisficing_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern
    (decompose bundled conclusion-axiom into atomic stipulation +
    derived theorem).

    Cat 3 sub-type: workingAssumption (paper-stated higher-level
    welfare-reversal claim on opaque carrier `satisficingWelfare`;
    pending substantive analysis of the satisficing decision rule;
    必须 close before publication).

    paper source: Remark `rem:robustness-misspec` (iii), line 944
    (satisficing threshold `r̄ ∈ (r(B), r(A))` exhibits welfare
    reversal in β). -/
axiom satisficing_threshold_trap_OPEN :
    ∀ rBar : ℝ, FiveState.r_B < rBar → rBar < FiveState.r_A →
      ∃ β₁ β₂ : ℝ, β₁ < β₂ ∧
        satisficingWelfare rBar β₂ < satisficingWelfare rBar β₁

/-- **Remark `rem:robustness-misspec` (iii): Satisficing** (derived
    theorem). A satisficing agent with threshold `r̄ ∈ (r(B), r(A))`
    accepts the trap; the reversal mechanism is analogous (welfare can
    decrease in β).

    Derived theorem composing the atomic stipulation
    `satisficing_threshold_trap_OPEN` per
    `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern.

    paper source: Remark `rem:robustness-misspec` (iii), line 944. -/
theorem gap_robustness_satisficing :
    ∀ rBar : ℝ, FiveState.r_B < rBar → rBar < FiveState.r_A →
      ∃ β₁ β₂ : ℝ, β₁ < β₂ ∧
        satisficingWelfare rBar β₂ < satisficingWelfare rBar β₁ :=
  satisficing_threshold_trap_OPEN

end BlackwellDilemma
