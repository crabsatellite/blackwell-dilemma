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
    `FiveState.gap_bayesian_naive_reversal_absent` (R41 derived theorem
    composing Cat 3 atom
    `bayesian_naive_below_threshold_blackwell_recovery_atom_OPEN`).

    paper source: Remark `rem:robustness-misspec` (i), line 941;
    quantitative content in Proposition `prop:bayesian-naive-five-state`. -/
theorem gap_robustness_bayesian_naive :
    ∀ p_hat : ℝ, 0.4 + 0.6 * (1 - p_hat) > 0.6 ↔ p_hat < (2 : ℝ) / 3 :=
  FiveState.gap_bayesian_naive_routing_threshold

/-- Welfare of a `k`-step lookahead myopic agent at precision `β` on a
    depth-`d` trap-tree instance.
    Substantive paper claim — opaque carrier required (Mathlib gap). -/
axiom myopicKWelfare : ℕ → ℕ → ℝ → ℝ

/-- R68 §3.4.3 reclassification (was R57 closure-path-A
    workingAssumption): paper Remark `rem:robustness-misspec` (ii) line
    942 STIPULATES the defining behavior of the `myopicKWelfare` carrier
    at horizon `k ≥ d` (divergence depth): "the agent's planning horizon
    is wide enough to compare the full trap and bridge subtree values"
    — paper-defining commitment that, at this horizon regime, myopic-k
    truncated backward induction coincides with the unrestricted
    Bayesian backward induction.

    The carrier `myopicKWelfare : ℕ → ℕ → ℝ → ℝ` was introduced
    explicitly to host paper Remark (ii)'s welfare claim; paper Remark
    (ii) at line 942 STATES the carrier's defining equation at k ≥ d
    (horizon spans full divergence depth → coincides with Bayesian).
    Paper does NOT separately derive this; it is paper's commitment to
    what "myopic-k at horizon ≥ d" MEANS — analogous to paper Def
    `def:greedy-path` line 984 STIPULATING V_g(u) = r(u) at terminal
    vertex (carrier-defining equation at boundary regime).

    Mirrors `V_g_def_terminal` (R23-C1 carrier-defining equation at
    boundary regime per paper Def `def:greedy-path` line 984): paper
    introduces the V_g carrier AND stipulates its base-case equation
    at terminal vertex; here paper introduces myopicKWelfare AND
    stipulates its boundary-equation at horizon-spans-divergence-depth.

    Cat 3 sub-type: structuralEquation (paper-Remark-stipulated
    carrier-defining equation on the opaque `myopicKWelfare` carrier
    at horizon `k ≥ d` per paper Remark `rem:robustness-misspec` (ii)
    line 942; 永不 close per discipline §3.4.3 — paper's commitment to
    what `myopicKWelfare k d β` MEANS at k ≥ d).

    paper source: Remark `rem:robustness-misspec` (ii), line 942
    (k-step lookahead horizon spans full divergence depth d ⇒
    paper-stipulated coincidence with Bayesian estimate; carrier-
    defining equation at the paper-named regime k ≥ d). -/
axiom myopic_k_eq_bayesian_above_divergence_depth_OPEN :
    ∀ k d : ℕ, k ≥ d →
      ∀ β : ℝ,
        myopicKWelfare k d β = agentWelfare AgentType.bayesian β 0 1

/-- **Remark `rem:robustness-misspec` (ii): Myopic-`k`** (derived theorem,
    R57 closure-path-A).
    A `k`-step lookahead agent experiences the reversal for `k = 0`
    (greedy) but not for `k ≥ d`, where `d` is the divergence depth of
    trap and bridge paths.

    R57 closure path A: derived theorem composing
      (i) Cat 3 atomic stipulation
          `myopic_k_eq_bayesian_above_divergence_depth_OPEN`
          (paper line 942 — myopic equals Bayesian when planning
          horizon `k ≥ d`); plus
      (ii) Cat 2 Blackwell 1951/1953 monotonicity threaded as an
          explicit `h_blackwell` antecedent per `feedback_gap_ledger_in_lean4`
          §10 (paper-APPLICATION-of-Cat-2-to-opaque-carrier is Cat 3 with
          explicit Cat 2 dependency chain). The Cat 2 axiom lives at
          `ClassicalResults.lean :: gap_blackwell_monotonicity_OPEN`.

    Proof composition:
      myopicKWelfare k d β₁ = bayesian β₁                (atom)
                            ≤ bayesian β₂                (h_blackwell)
                            = myopicKWelfare k d β₂      (atom symm).

    Net effect: original ` myopic_k_lookahead_recursion_OPEN ` (a
    bundled `∀ β₁ β₂, β₁ ≤ β₂ → myopic ≤ myopic` workingAssumption)
    is replaced by a more atomic equality stipulation + Cat 2
    Blackwell. The atomic stipulation is genuinely smaller (just
    horizon-suffices structural equality, no monotonicity built in).

    paper source: Remark `rem:robustness-misspec` (ii), line 942. -/
theorem gap_robustness_myopic_k
    (h_blackwell : ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) :
    ∀ k d : ℕ, k ≥ d →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        myopicKWelfare k d β₁ ≤ myopicKWelfare k d β₂ := by
  intro k d hkd β₁ β₂ hβ
  have h₁ := myopic_k_eq_bayesian_above_divergence_depth_OPEN k d hkd β₁
  have h₂ := myopic_k_eq_bayesian_above_divergence_depth_OPEN k d hkd β₂
  rw [h₁, h₂]
  exact h_blackwell β₁ β₂ hβ

/-- Welfare of a satisficing agent with threshold `r̄` at precision `β`.
    Substantive paper claim — opaque carrier required (Mathlib gap). -/
axiom satisficingWelfare : ℝ → ℝ → ℝ

/-- Acceptance probability of the trap option `A` (immediate reward
    `r(A) = 0.6`) by a satisficing agent with threshold `r̄` at
    signal precision `β`. The agent accepts the FIRST option whose
    realised signal exceeds `r̄`; with `r̄ < r(A)`, increased signal
    precision concentrates the signal `s_A` near `r(A) > r̄`,
    monotonically increasing the trap-acceptance event probability.
    Substantive paper claim — opaque carrier required (Mathlib gap). -/
axiom satisficingTrapAcceptanceProb : ℝ → ℝ → ℝ

/-- R69 §3.4.3 reclassification (was R57 closure-path-A
    workingAssumption): paper Remark `rem:robustness-misspec` (iii) line
    945 STIPULATES the defining behavior of the
    `satisficingTrapAcceptanceProb` carrier in the signal-precision
    parameter β: "Better signals make the agent more confident that A
    exceeds the threshold" — paper-defining commitment that, under the
    satisficing decision rule with threshold `r̄ < r(A)`, the carrier
    `satisficingTrapAcceptanceProb r̄ β` is strictly increasing in β.

    The carrier `satisficingTrapAcceptanceProb : ℝ → ℝ → ℝ` was
    introduced by R57 explicitly to host paper Remark (iii)'s claim;
    paper Remark (iii) at line 945 STATES the carrier's defining
    behavior under the named regime `r̄ < r(A)` (better signals →
    more confidence-in-A → increased trap acceptance). Paper does NOT
    separately derive this; it is paper's commitment to what
    "satisficing trap-acceptance probability with `r̄ < r(A)`" MEANS
    as β increases — analogous to paper Remark (ii) line 942
    STIPULATING the myopic-k carrier's defining behavior at horizon
    `k ≥ d` (R68 closure 4 precedent).

    Mirrors `myopic_k_eq_bayesian_above_divergence_depth_OPEN` (R68
    §3.4.3 closure 4 precedent): paper introduces the carrier AND
    stipulates its base-case/named-regime behavior in the same
    Remark; the equation/monotonicity at the paper-named regime is
    the carrier's defining content, not a derivation.

    Cat 3 sub-type: structuralEquation (paper-Remark-stipulated
    carrier-defining monotonicity behavior on the opaque
    `satisficingTrapAcceptanceProb` carrier under the paper-named
    regime `r̄ < r(A)` per paper Remark `rem:robustness-misspec` (iii)
    line 945; 永不 close per discipline §3.4.3 — paper's commitment to
    what `satisficingTrapAcceptanceProb r̄ β` MEANS as β grows under
    `r̄ < r(A)`).

    paper source: Remark `rem:robustness-misspec` (iii), line 945
    ("Better signals make the agent more confident that A exceeds the
    threshold"; carrier-defining monotonicity behavior at the
    paper-named regime `r̄ < r(A)`). -/
axiom satisficing_trap_acceptance_strictMono_in_beta_OPEN :
    ∀ rBar : ℝ, rBar < FiveState.r_A →
      ∀ β₁ β₂ : ℝ, β₁ < β₂ →
        satisficingTrapAcceptanceProb rBar β₁ <
          satisficingTrapAcceptanceProb rBar β₂

/-- R69 §3.4.3 reclassification (was R57 closure-path-A
    workingAssumption): paper Remark `rem:robustness-misspec` (iii) line
    946 STIPULATES the structural binding between trap-acceptance
    probability and satisficing welfare under the paper-named regime
    `r̄ ∈ (r(B), r(A))`: "reinforcing the trap" — paper-defining
    commitment that, with the satisficing rule accepting `A` (the trap)
    on its first acceptance event, increased trap-acceptance probability
    yields strictly worse welfare because the bridge alternative `B → G`
    is foregone.

    The carriers `satisficingTrapAcceptanceProb` and `satisficingWelfare`
    were introduced by R57 explicitly to host paper Remark (iii)'s
    claims; paper Remark (iii) at line 946 ("reinforcing the trap")
    STATES the structural binding between the two carriers at the
    paper-named regime `r̄ ∈ (r(B), r(A))`. Paper does NOT separately
    derive this; it is paper's commitment to how the two carriers
    relate at the named regime — `satisficingWelfare` is paper-defined
    AS the welfare under the satisficing rule, and the rule's binding
    to acceptance events is paper-stipulated by paper text "satisficing
    acceptance of A forecloses bridge B → G".

    Mirrors `myopic_k_eq_bayesian_above_divergence_depth_OPEN` (R68
    §3.4.3 closure 4 precedent) and the companion atom #1 above
    (R69 closure 1): paper Remark (iii) introduces both carriers AND
    stipulates their inter-carrier binding at the paper-named regime;
    this binding IS the carriers' defining inter-relationship at the
    regime, not a derivation.

    Cat 3 sub-type: structuralEquation (paper-Remark-stipulated
    inter-carrier binding between `satisficingTrapAcceptanceProb` and
    `satisficingWelfare` at the paper-named regime `r̄ ∈ (r(B), r(A))`
    per paper Remark `rem:robustness-misspec` (iii) line 946; 永不
    close per discipline §3.4.3 — paper's commitment to how the two
    carriers relate at the regime).

    paper source: Remark `rem:robustness-misspec` (iii), line 946
    ("reinforcing the trap"; satisficing acceptance of A forecloses
    bridge B → G; paper-stipulated inter-carrier binding at the
    paper-named regime `r̄ ∈ (r(B), r(A))`). -/
axiom satisficing_welfare_antitone_in_trap_acceptance_OPEN :
    ∀ rBar : ℝ, FiveState.r_B < rBar → rBar < FiveState.r_A →
      ∀ β₁ β₂ : ℝ,
        satisficingTrapAcceptanceProb rBar β₁ <
          satisficingTrapAcceptanceProb rBar β₂ →
          satisficingWelfare rBar β₂ < satisficingWelfare rBar β₁

/-- **Remark `rem:robustness-misspec` (iii): Satisficing** (derived
    theorem, R57 closure-path-A). A satisficing agent with threshold
    `r̄ ∈ (r(B), r(A))` accepts the trap; the reversal mechanism is
    analogous (welfare strictly decreases in β).

    R57 closure path A: derived theorem composing the two paper-stated
    atomic stipulations
      (i) `satisficing_trap_acceptance_strictMono_in_beta_OPEN`
          (paper line 945, "Better signals make the agent more
           confident that A exceeds the threshold"); plus
      (ii) `satisficing_welfare_antitone_in_trap_acceptance_OPEN`
          (paper line 946, "reinforcing the trap" — increased trap
           acceptance forecloses the bridge `B → G` and strictly
           reduces welfare).

    Each atomic stipulation is strictly smaller than the original
    bundled `satisficing_threshold_trap_OPEN` (which packaged the
    threshold-strict-betweenness, monotonicity-of-acceptance, AND
    welfare-antitonicity into one axiom).

    Witness construction: take `β₁ = 0`, `β₂ = 1`. The atomic
    stipulations supply (i) `acceptance(0) < acceptance(1)` and
    (ii) `acceptance(0) < acceptance(1) → welfare(1) < welfare(0)`.
    Composition gives `welfare(1) < welfare(0)` and `0 < 1`.

    paper source: Remark `rem:robustness-misspec` (iii), line 944. -/
theorem gap_robustness_satisficing :
    ∀ rBar : ℝ, FiveState.r_B < rBar → rBar < FiveState.r_A →
      ∃ β₁ β₂ : ℝ, β₁ < β₂ ∧
        satisficingWelfare rBar β₂ < satisficingWelfare rBar β₁ := by
  intro rBar hB hA
  refine ⟨0, 1, by norm_num, ?_⟩
  have h_acc :
      satisficingTrapAcceptanceProb rBar 0 <
        satisficingTrapAcceptanceProb rBar 1 :=
    satisficing_trap_acceptance_strictMono_in_beta_OPEN rBar hA 0 1 (by norm_num)
  exact satisficing_welfare_antitone_in_trap_acceptance_OPEN rBar hB hA 0 1 h_acc

end BlackwellDilemma
