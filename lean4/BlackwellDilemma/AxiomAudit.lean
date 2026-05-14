/-
  BlackwellDilemma/AxiomAudit.lean

  Prints the axiom dependency list for every theorem (CLOSED entry)
  in the formalisation.

  Per `feedback_gap_ledger_in_lean4`: status `CLOSED` requires `theorem
  gap_X : <statement> := <proof>` with no `sorry`. The audit verifies
  this by checking #print axioms for each CLOSED entry.

  Expected axioms:
   * Lean 4 / Mathlib kernel: `propext`, `Classical.choice`, `Quot.sound`.
   * Paper-citation axioms (named `gap_<name>_OPEN`) — these stand for
     paper claims whose Lean version is a placeholder pending Mathlib
     port + substantive proof.
   * Opaque types and carriers declared in `Types.lean`,
     `ClassicalResults.lean`, etc. (`Vertex`, `IsEdge`, `Phi`, `phi`,
     `agentWelfare`, `kappaStar`, etc.).

  Any axiom outside the union of these three categories is a RED FLAG.

  Note on BLOCKED/DEAD-END status (post-R26 update):
  Per the `feedback_gap_ledger_in_lean4` 2026-05-13 discipline (6-tier
  status: OPEN / PARTIAL / BLOCKED / DEAD-END / CLOSED / DEFINITIONAL),
  BLOCKED is reserved for genuine no-acceptance-possible cases
  (folkloric, conjectural-unproven, or no-source-at-all). External
  published Cat 2 theorems with Mathlib gap are encoded as plain
  Cat 2 OPEN axioms (`axiom gap_X_OPEN : <stmt>` with paper-cited
  docstring), NOT as BLOCKED-defs. R26 retired the BLOCKED-def
  encoding pattern for this domain; the 8 prior BLOCKED entries (6
  Cat 2 + 2 Cat 3 edge cases) all converted to plain OPEN axioms.

  Cat 2 dependency surfacing (R28-A clarification): for downstream
  THEOREMS, the Cat 2 axiom is composed in the proof body and
  surfaces in `#print axioms` automatically. For downstream AXIOMS
  (which have no body), the Cat 2 axiom MUST be threaded as an
  EXPLICIT ANTECEDENT for the dependency to surface in `#print
  axioms`. The R28 broken-link discipline restoration distinguishes
  these two cases.

  Usage:  `lake env lean BlackwellDilemma/AxiomAudit.lean`
-/

import BlackwellDilemma

namespace BlackwellDilemma.AxiomAudit

-- §2 IDP Types (signal-variance algebra)
#print axioms BlackwellDilemma.signalVariance_strictAntitoneOn
-- R23-B Cat 1 closure: `σ²_topo(κ, 0) = 0` (paper proof line 870 —
-- terminal-vertex distance-0 case). Kernel-pure via `unfold + simp`.
-- See Ledger entry `entry_atom_topoSignalVariance_distance_zero`.
#print axioms BlackwellDilemma.topoSignalVariance_distance_zero

-- §3 Welfare Decomposition (CLOSED — kernel only)
#print axioms BlackwellDilemma.WelfareSetup.gap_welfare_decomposition
#print axioms BlackwellDilemma.SignalFamily.gap_W_topo_signal_immune
#print axioms BlackwellDilemma.SignalFamily.gap_W_topo_constant
#print axioms BlackwellDilemma.WelfareSetup.gap_physical_irreducibility
#print axioms BlackwellDilemma.WelfareSetup.gap_W_info_nonpos
#print axioms BlackwellDilemma.WelfareSetup.gap_oracle_W_info_zero
#print axioms BlackwellDilemma.WelfareSetup.gap_welfare_le_W_topo
#print axioms BlackwellDilemma.WelfareSetup.gap_oracle_welfare_eq_W_topo

-- §3.2 Welfare Reversal layer
#print axioms BlackwellDilemma.gap_dilemma
-- R23-C1 Cat 1 derived closure: Proposition `prop:topo-cluster`
-- closed-form `(n-k)/((n+1)(k+1))` derives Cat 1 algebraically from the
-- R66 derived theorem `expectedTopoLoss_conditional_def` (paper line 292
-- order-statistics decomposition `n/(n+1) − k/(k+1)`, Cat 2 absorbed via
-- David & Nagaraja Eq. 2.1.4) via `field_simp; ring`. See Ledger entry
-- `entry_prop_topo_cluster`.
#print axioms BlackwellDilemma.gap_topo_cluster_relation
-- R66 Cat 2 absorption: `expectedTopoLoss_conditional_def` derived
-- theorem composes `gap_orderstats_topo_decomposition_OPEN` (paper-
-- application of David & Nagaraja Eq. 2.1.4 to IDP carrier via paper
-- Def 2.1 standing convention, Wrongness.lean) + `gap_david_nagaraja_
-- eq214_OPEN` (substantive David & Nagaraja 2003 Eq. 2.1.4 textbook
-- identity on opaque `expectedMaxIIDUniform` carrier, ClassicalResults.
-- lean). Both Cat 2 axioms surface via `#print axioms`, providing audit-
-- chain visibility for the David & Nagaraja Cat 2 dependency previously
-- acknowledged only in docstrings.
#print axioms BlackwellDilemma.expectedTopoLoss_conditional_def
#print axioms BlackwellDilemma.gap_conditional_reduction_part_ii
-- R37 derived closure: Lemma `lem:conditional-reduction` part (i),
-- conditional Blackwell monotonicity on the restricted action domain.
-- Composes the new Cat 3 atom `conditional_subproblem_blackwell_applicable_OPEN`
-- (paper line 375) threading the Cat 2 Blackwell 1951/1953 dependency.
#print axioms BlackwellDilemma.gap_conditional_reduction_part_i

-- §3.3 Phase Transition layer
#print axioms BlackwellDilemma.gap_er_phase_subcritical
#print axioms BlackwellDilemma.gap_er_phase_supercritical
#print axioms BlackwellDilemma.gap_power_law_heavy_tail
-- R23-C2 derived closure: Proposition `prop:trap-prevalence` Part 1
-- (V_dyn agrees on neighbours at p = 0). Composes the Cat 3 atom
-- `forward_reachable_full_at_zero_OPEN` (paper line 463) with the
-- existing `V_dyn_def` atom + `Finset.sup'_congr` (Cat 1 Mathlib).
-- The `[Fintype Vertex]` parameter is an instance argument on the
-- theorem and does NOT block `#print axioms` (which prints the
-- definition's axiom dependency closure, not its applied form).
#print axioms BlackwellDilemma.gap_trap_prevalence_zero
-- R37 derived closures: Theorem 3.3 phase-transition Parts 1+2 +
-- Proposition `prop:trap-prevalence` Part 2.
--  * `gap_phase_transition_below`: composes
--    `topo_loss_decay_below_pc_OPEN` (decay envelope existence,
--    paper line 415-417) + `topo_loss_decay_arbitrary_threshold_OPEN`
--    (arbitrary-ε convergence, paper line 417). Cat 2 Grimmett
--    percolation-probability dependency threaded via `h_perc_prob`.
--  * `gap_phase_transition_above`: composes
--    `wInfoTopoRatio_const_exists_OPEN` (positive constant existence,
--    paper line 421-427) + `wInfoTopoRatio_bound_OPEN` (quantitative
--    ratio bound, paper line 427). Cat 2 Grimmett §6.75 exponential-
--    decay dependency threaded via `h_grimmett`.
--  * `gap_trap_prevalence_above_threshold`: re-exports
--    `trap_config_local_positive_OPEN` (paper-stated local FKG
--    estimate, paper line 473).
#print axioms BlackwellDilemma.gap_phase_transition_below
#print axioms BlackwellDilemma.gap_phase_transition_above
#print axioms BlackwellDilemma.gap_trap_prevalence_above_threshold

-- Hodge-style paper-citation closures: def IS the paper's stated
-- closed form (per CLOSED def "paper-grade proof referenced + ported"
-- clause). Substantive derivations cited but not Lean-encoded.
-- The 4 limit-of-process entries (W_open_limit_{infty,zero},
-- error_compounding_part{1,2}) were reverted to honest OPEN axioms
-- because Hodge-style def-rfl is not appropriate for limits-of-process
-- (the def discards the limit content); they now appear as
-- `gap_*_OPEN` Filter.Tendsto axioms in their respective files.
#print axioms BlackwellDilemma.gap_order_statistics_max
#print axioms BlackwellDilemma.gap_er_bond_percolation_threshold
#print axioms BlackwellDilemma.gap_power_law_thin_tail

-- §3.3 ClassicalResults consumer chain for Harris-Kesten anchor
#print axioms BlackwellDilemma.gap_harris_kesten_squared

-- Gaussian PDF/CDF derivative closures: phi + Phi are concrete defs;
-- derivatives proved via Mathlib's HasDerivAt + FTC. Kernel-pure.
#print axioms BlackwellDilemma.gap_phi_derivative
#print axioms BlackwellDilemma.gap_Phi_derivative
-- Mills' tail bound: proved via Mathlib improper-integral machinery
-- (integral_gaussian_Ioi + monotoneOn_of_deriv_nonneg). Kernel-pure.
#print axioms BlackwellDilemma.gap_phi_tail_bound

-- §4 Cognitive layer
#print axioms BlackwellDilemma.gap_cognitive_threshold_characterisation
#print axioms BlackwellDilemma.gap_policy_complementarity
#print axioms BlackwellDilemma.gap_threshold_alpha_monotone
-- R37 derived closures: Proposition `prop:supermodular` +
-- Proposition `prop:sentimental`.
--  * `gap_supermodular`: composes `welfareCrossPartial_explicit_form_OPEN`
--    (paper-stated calculus closed form, line 564-583) +
--    `cross_partial_sign_in_z_lt_one_OPEN` (paper-stated sign analysis
--    at `|z| < 1`, line 582-584). Cat 2 Topkis 1978/1998 dependency
--    threaded via `_h_topkis` for audit-chain visibility.
--  * `gap_sentimental_immunity`: composes `signal_independent_at_alpha_zero`
--    (R65 derived theorem; paper L600 base case at α = 0; Cat 2 absorbed
--    via `gap_iid_continuous_rank_symmetry_OPEN` + `gap_blackwell_
--    monotonicity_OPEN` per R65) + `welfare_continuity_in_alpha_OPEN`
--    (paper L602 perturbative continuity neighbourhood) +
--    `alpha_star_existence_via_continuity_OPEN` (paper L602 sup-existence
--    of `α*`).
#print axioms BlackwellDilemma.gap_supermodular
#print axioms BlackwellDilemma.gap_sentimental_immunity
-- R65 Cat 2 absorption: `signal_independent_at_alpha_zero` derived
-- theorem composes `gap_iid_continuous_rank_symmetry_OPEN` (David &
-- Nagaraja 2003 §1.3 + Blackwell 1953 conditional Cat 2,
-- ClassicalResults.lean) + `gap_blackwell_monotonicity_OPEN` (Blackwell
-- 1953 Cat 2 ClassicalResults.lean:71). Both Cat 2 dependencies surface
-- via `#print axioms`.
#print axioms BlackwellDilemma.signal_independent_at_alpha_zero
-- R38 §18 decomposition: Theorem 4.1 Part 5 (κ*(α) non-decreasing
-- in α). Decomposed into atomic stipulation
-- `welfare_transition_alpha_monotone_OPEN` + derived theorem
-- `gap_cognitive_threshold_part5`. Cat 3 atomic-stipulation re-flips
-- the prior R24-B reversion: the atom is the paper-stated welfare-
-- transition characterisation (Prop:threshold-alpha proof line 540),
-- independent of `kappaStar_def`'s α-erasing inf-formula.
#print axioms BlackwellDilemma.gap_cognitive_threshold_part5

-- §4 Principal layer
-- R37 derived closures: Proposition `prop:principal-optimum` Parts 1-3
-- + Corollary `cor:disclosure` Parts 1-2.
--  * `gap_principal_interior_optimum`: composes 3 atoms (paper proof
--    line 624-625, 632) — `W_bar_eventually_decreasing_in_reversal_OPEN`
--    + `W_bar_exceeds_zero_at_positive_beta_OPEN` +
--    `interior_max_exists_from_unimodal_envelope` (R63 derived theorem,
--    composes `betaBarStar_nonneg_OPEN` structural eq + `betaBarStar_def`
--    argmax-characterisation via Cat 1 Mathlib chain).
--  * `gap_principal_monotone_in_kappa`: composes 2 atoms (paper proof
--    line 626, 634) — `fosd_induces_derivative_domination_OPEN` +
--    `argmax_monotone_under_derivative_domination_OPEN`.
--  * `gap_principal_regime_bifurcation`: composes 2 sub-claims (paper
--    proof line 627, 636-640) — `W_bar_mixture_decomposition` (R63
--    derived theorem composing `aboveThresholdWelfare` +
--    `belowThresholdWelfare` carriers + `W_bar_eq_mixture_OPEN` structural
--    eq + `aboveThresholdWelfare_monotone_OPEN` smaller wA +
--    `belowThresholdWelfare_eventually_decreasing_OPEN` smaller wA) +
--    `non_concave_triple_from_mixture_OPEN`.
--  * `gap_disclosure_full_suboptimal`: composes 2 atoms (paper proof
--    line 645, 652-656) — `averaged_reversal_overshoot_positive_OPEN` +
--    `finite_beta_above_limit_from_overshoot_OPEN`.
--  * `gap_disclosure_differentiated_dominates`: re-exports R63 derived
--    theorem `differentiated_per_agent_optimum_dominates_uniform`
--    (composes `perAgentOptimalAggregate` carrier +
--    `differentiatedDisclosureWelfare_eq_perAgentOptimal_OPEN` structural
--    eq + `perAgentOptimalAggregate_dominates_uniform_OPEN` smaller wA).
#print axioms BlackwellDilemma.gap_principal_interior_optimum
#print axioms BlackwellDilemma.gap_principal_monotone_in_kappa
#print axioms BlackwellDilemma.gap_principal_regime_bifurcation
#print axioms BlackwellDilemma.gap_disclosure_full_suboptimal
#print axioms BlackwellDilemma.gap_disclosure_differentiated_dominates
-- R63 §18 closure-path-A derived theorems (replacing retired
-- workingAssumption axioms; ledger entries re-routed to consume these).
#print axioms BlackwellDilemma.interior_max_exists_from_unimodal_envelope
#print axioms BlackwellDilemma.W_bar_mixture_decomposition
#print axioms BlackwellDilemma.differentiated_per_agent_optimum_dominates_uniform

-- §5 Constructive instances
#print axioms BlackwellDilemma.FiveState.gap_kappaStar_at_two_thirds
#print axioms BlackwellDilemma.FiveState.gap_bayesian_naive_routing_threshold
#print axioms BlackwellDilemma.FiveState.gap_threshold_fiveState_greedy_has_interior_optimum
#print axioms BlackwellDilemma.gap_fiveState_policy_mapping
#print axioms BlackwellDilemma.FiveState.gap_three_regime_sufficient_cognition_kappaStar_pos
-- p-monotonicity bounded version (the unconditional axiom is provably
-- false under Lean's junk-value semantics; bounded version restores
-- paper's intended domain p ∈ [0, 1)).
#print axioms BlackwellDilemma.FiveState.gap_p_monotonicity_bounded

-- §6 Bayesian + complementarity
#print axioms BlackwellDilemma.gap_bayesian_immunity
#print axioms BlackwellDilemma.gap_information_knowledge_complementarity
-- R38 §18 decompositions (Bayesian.lean): gap_robustness_myopic_k +
-- gap_robustness_satisficing now derived theorems composing
-- atomic-stipulation atoms `myopic_k_lookahead_recursion_OPEN` and
-- `satisficing_threshold_trap_OPEN`.
-- R57 closure-path-A: both derived theorems re-derived via strictly-
-- smaller atoms + Cat 2 Blackwell chain (myopic side — `h_blackwell`
-- antecedent threaded into `gap_robustness_myopic_k`) / 2-atom
-- decomposition through new opaque carrier `satisficingTrapAcceptanceProb`
-- with constructive witnesses β₁=0, β₂=1 (satisficing side). The new
-- smaller atoms below surface in `#print axioms` of the consuming
-- derived theorems.
#print axioms BlackwellDilemma.gap_robustness_myopic_k
#print axioms BlackwellDilemma.gap_robustness_satisficing
-- R57 individual atom prints (kernel-purity baseline + audit-chain
-- visibility):
#print axioms BlackwellDilemma.myopic_k_eq_bayesian_above_divergence_depth_OPEN
#print axioms BlackwellDilemma.satisficing_trap_acceptance_strictMono_in_beta_OPEN
#print axioms BlackwellDilemma.satisficing_welfare_antitone_in_trap_acceptance_OPEN
#print axioms BlackwellDilemma.satisficingTrapAcceptanceProb
-- §5 Three-regime arithmetic split (Cat 1 promotion)
#print axioms BlackwellDilemma.FiveState.gap_three_regime_cognitive_augmentation_arithmetic_part

-- §5 Three-regime β-monotonicity (Cat 1 promotions): β-monotonicity of
-- L(β, p) on Regime (ii) [p_1, p_2] and Regime (iii) (p_2, 1) closed via
-- `Phi_strictMono` + `Phi_le_one` + `Phi_nonneg` + `signalVariance_strictAntitoneOn`
-- + algebraic decomposition of L₂ - L₁ into two non-positive contributions.
#print axioms BlackwellDilemma.FiveState.gap_three_regime_cognitive_augmentation_monotonicity
#print axioms BlackwellDilemma.FiveState.gap_three_regime_sufficient_cognition

-- Phi monotonicity / non-negativity / upper-bound helpers (Cat 1 closures
-- supporting the three-regime β-monotonicity theorems).
#print axioms BlackwellDilemma.Phi_strictMono
#print axioms BlackwellDilemma.Phi_monotone
#print axioms BlackwellDilemma.Phi_zero
#print axioms BlackwellDilemma.Phi_le_one
#print axioms BlackwellDilemma.Phi_nonneg

-- R30 Cat 1 limit helpers: Φ tail limits + signal-variance limit at infinity
-- + the constant-divided-by-vanishing-positive-function → ∞ helper. Used by
-- the R30 gap_W_open_limit_infty + gap_error_compounding_part1 promotions.
#print axioms BlackwellDilemma.Phi_tendsto_one_atTop
#print axioms BlackwellDilemma.Phi_tendsto_zero_atBot
#print axioms BlackwellDilemma.signalVariance_tendsto_zero_atTop
#print axioms BlackwellDilemma.tendsto_const_div_atTop_of_tendsto_zero_pos

-- R35-B Wave 1.1 Cat 1 helpers: Phi continuity (from FTC closure) +
-- signalVariance limit at 0+ (symmetric mirror of R30's atTop limit).
-- Used by gap_W_open_limit_zero closure.
#print axioms BlackwellDilemma.Phi_continuousAt
#print axioms BlackwellDilemma.signalVariance_tendsto_atTop_of_tendsto_zero_pos

-- R30 derived closures: prop:canonical β→∞ limit + prop:error-compounding
-- Part 1 (β→∞ welfare-limit on the depth-d trap tree).
#print axioms BlackwellDilemma.FourState.gap_W_open_limit_infty
#print axioms BlackwellDilemma.TrapTree.gap_error_compounding_part1

-- R35-B Wave 1.1 derived closure: prop:canonical β→0+ limit (symmetric
-- mirror of R30 gap_W_open_limit_infty). Composes the new Cat 1 helpers
-- above.
#print axioms BlackwellDilemma.FourState.gap_W_open_limit_zero

-- R35-B Wave 1.2 derived closure: rem:robustness-misspec (i) — re-export
-- of FiveState.gap_bayesian_naive_routing_threshold (Cat 1 kernel-pure).
#print axioms BlackwellDilemma.gap_robustness_bayesian_naive

-- §5 Three-regime reversal six-way decomposition: paper line 814 has six
-- sub-claims — existence, uniqueness, non-monotonicity, overshoot
-- strictly decreasing in p, overshoot continuous in p on [0, p_1), and
-- overshoot vanishing at p_1 — split per `feedback_lean_axiom_decomposition`
-- Anti-pattern #2. Each sub-axiom is a Cat 3 paper-novel OPEN claim with
-- explicit single-clause encoding; the continuity + vanishing-at-p_1
-- sub-axioms are stated against the opaque carrier `betaStarOfP` (whose
-- own dependencies appear under each consuming axiom). Only the existence
-- sub-axiom is currently consumed by downstream `gap_fiveState_policy_mapping`.
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_existence
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_uniqueness
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_nonmonotone
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_overshoot_decreasing
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_overshoot_continuous
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_overshoot_vanishes_at_p1

-- §7 General graphs + trap tree
#print axioms BlackwellDilemma.TrapTree.gap_welfare_gain_decay
-- R23-C1 Cat 3 derived closure: Proposition `prop:error-compounding`
-- Part 2 (oracle dynamic value at root = `r_goal` for all `d ≥ 1`).
-- Refactored to derive directly from the Cat 3 atomic structural
-- equation `oracleValueAtRoot_TrapTree_def` (paper line 1041); see
-- Ledger entry `entry_prop_error_compounding`.
#print axioms BlackwellDilemma.TrapTree.gap_error_compounding_part2
-- Upper-bound half of the κ*(d) = Θ(log d) asymptotic (lower-bound half
-- remains an OPEN axiom pending tighter c_star_constant control).
#print axioms BlackwellDilemma.TrapTree.gap_kappaStar_depth_d_upper_bound
-- R23-C2 derived closures from Manufactured-Recognition-pattern atomic
-- decomposition:
--  * `gap_V_g_le_V_dyn`: composes the Cat 3 atom
--    `V_g_terminal_in_ForwardReachable_OPEN` (paper line 984 + Def 2.5)
--    with `V_dyn_def` + Mathlib `Finset.le_sup'` (Cat 1).
--  * `dilemma_subsumed_by_gap_general_tree`: composes the Cat 3 atom
--    `terminal_neighbour_implies_C2prime_atom_OPEN` (paper line 1019
--    structural implication on hypothesis predicates) with the trivial
--    conjunction-rebuilding step on `Conditions_C1_C2_C3` /
--    `Conditions_C1_C2prime_C3`.
#print axioms BlackwellDilemma.gap_V_g_le_V_dyn
#print axioms BlackwellDilemma.dilemma_subsumed_by_gap_general_tree

-- R24-C derived closures from R23-D Pattern 7 phantom-downstream repair
-- (Wires #1-#6: composing previously-orphan R23 atoms with Mathlib +
-- companion atoms to give them explicit downstream consumers):
--  * `ReachableSet_self_member`: refactored from atomic axiom to derived
--    theorem via `ReachableSet_eq_ForwardReachable_empty` (Def 2.5
--    line 193) + `ForwardReachable_self_member` (Def 2.5 length-0 path).
--  * `realisedUtility_mem_unitInterval`: composes `intrinsicPref_mem_unitInterval`
--    (Def 2.1 line 114) + `reward_mem_unitInterval` (Def 2.1 line 113)
--    via convex-combination Cat 1 arithmetic.
--  * `kappaAgentWelfareSNR_mem_unitInterval`: composes `kappaAgentWelfareSNR_def`
--    (`prop:supermodular` line 565) + `agentWelfare_mem_unitInterval`
--    (§2.5 lines 204-208 + Def 2.1 line 113).
--  * `betaStarOfP_loss_below_limit`: composes `betaStarOfP_def`
--    (`prop:three-regime-five-state` Regime (i) line 814 argmin) +
--    `gap_three_regime_reversal_existence_OPEN` (existence sub-axiom)
--    via transitivity, binding the existential witness to the canonical
--    `betaStarOfP` carrier.
--  * `V_g_terminal_mem_unitInterval`: composes `V_g_def_terminal`
--    (`def:greedy-path` lines 982-985 terminal-base) + `reward_mem_unitInterval`
--    (Def 2.1 line 113), bounding `V_g` in the terminal-vertex case.
--  * `W_bar_limit_infty_le_W_bar_betaBarStar`: composes `W_bar_limit_infty_def`
--    (`cor:disclosure` Part 1 line 652 Tendsto limit) + `betaBarStar_def`
--    (`prop:principal-optimum` line 622 argmax) via Mathlib's
--    `le_of_tendsto'` (limit-of-bounded-function lemma).
#print axioms BlackwellDilemma.ReachableSet_self_member
#print axioms BlackwellDilemma.realisedUtility_mem_unitInterval
#print axioms BlackwellDilemma.kappaAgentWelfareSNR_mem_unitInterval
#print axioms BlackwellDilemma.FiveState.betaStarOfP_loss_below_limit
#print axioms BlackwellDilemma.V_g_terminal_mem_unitInterval
#print axioms BlackwellDilemma.W_bar_limit_infty_le_W_bar_betaBarStar

-- R38 §18 atomic-decomposition derived theorems (R38, 2026-05-14):
-- 22 conclusion-axioms decomposed into atomic stipulations + derived
-- theorems per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
-- pattern. Each entry below is the derived theorem now hosting the
-- bundled paper conclusion; the corresponding atomic-stipulation
-- axiom (named `<paper_content>_OPEN`) is the underlying paper-stated
-- substance pending per-instance closure.

-- Cognitive.lean §18 decomposition (5 derived theorems; Part 4
-- universal-form is encoded as DEAD-END `def : Prop`
-- `gap_cognitive_threshold_part4_DEAD_END_by_junk_value` per R65 §15
-- — the universal claim is mathematically false under Lean's
-- junk-value semantics, mirroring the R9 / `gap_p_monotonicity_DEAD_
-- END_by_junk_value` precedent at Canonical.lean:1035; not consumed
-- by any downstream theorem so no `#print axioms` line is needed):
#print axioms BlackwellDilemma.gap_cognitive_threshold_part1
#print axioms BlackwellDilemma.gap_cognitive_threshold_part2
#print axioms BlackwellDilemma.gap_cognitive_threshold_part6
#print axioms BlackwellDilemma.gap_kappaWelfare_cross_partial_link

-- Wrongness.lean §18 decomposition (1 derived theorem):
#print axioms BlackwellDilemma.gap_wrongness

-- Canonical.lean §18 decomposition (8 derived theorems):
#print axioms BlackwellDilemma.FiveState.gap_interior_optimum
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_existence
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_uniqueness
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_nonmonotone
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_overshoot_decreasing
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_overshoot_continuous
#print axioms BlackwellDilemma.FiveState.gap_three_regime_reversal_overshoot_vanishes_at_p1
#print axioms BlackwellDilemma.FiveState.gap_threshold_fiveState_kappa_above_kstar
#print axioms BlackwellDilemma.FiveState.gap_threshold_fiveState_smooth_transition
#print axioms BlackwellDilemma.FiveState.gap_bayesian_naive_reversal_present

-- GeneralGraphs.lean §18 decomposition (3 derived theorems):
#print axioms BlackwellDilemma.gap_general_tree
#print axioms BlackwellDilemma.gap_cyclic_trap
#print axioms BlackwellDilemma.TrapTree.gap_kappaStar_depth_d_log_growth

-- R58 closure-path-A/B individual atom prints + new derived theorem
-- (kernel-purity baseline + audit-chain visibility):
--  * `terminal_neighbour_implies_C2prime` (R58 path-B derived theorem)
--    composes the two smaller atoms below in place of the retired
--    `terminal_neighbour_implies_C2prime_atom_OPEN`.
--  * `gap_cyclic_trap` (R58 path-A) re-derived via smaller atom +
--    file-local Theorem 6.1 atom chain.
--  * `gap_error_compounding_part2` (R58 path-B) re-derived via 2-atom
--    chain through new opaque carrier `oracleBridgePathTerminalReward_TrapTree`.
#print axioms BlackwellDilemma.terminal_neighbour_implies_C2prime
#print axioms BlackwellDilemma.V_g_eq_V_dyn_on_terminal_neighbour_OPEN
#print axioms BlackwellDilemma.C2_to_C2prime_via_V_g_eq_V_dyn_at_terminal_neighbour_OPEN
#print axioms BlackwellDilemma.cyclic_4_satisfies_full_conditions_at_blocked_event_OPEN
#print axioms BlackwellDilemma.TrapTree.oracleBridgePathTerminalReward_TrapTree
#print axioms BlackwellDilemma.TrapTree.oracleValueAtRoot_eq_bridgePathTerminalReward_TrapTree_OPEN
#print axioms BlackwellDilemma.TrapTree.oracleBridgePathTerminalReward_TrapTree_eq_r_goal_OPEN

-- R41 §18 decompositions (3 new derived theorems closing the final
-- workingAssumption residue from R40), with R42 Pattern-1 fix:
--  * `gap_topo_loss_below_threshold` (Wrongness.lean): composes Cat 3
--    workingAssumption atom `topo_loss_below_envelope_exists_atom_OPEN`
--    (paper line 286 envelope existence) + Cat 1 theorem
--    `topo_loss_below_eps_from_envelope` (R42 Mathlib-discharge from
--    `Filter.Tendsto`) with explicit Cat 2 Grimmett `h_perc_prob`
--    antecedent.
--  * `gap_topo_loss_above_threshold` (Wrongness.lean): composes Cat 3
--    workingAssumption atoms `topo_loss_above_lower_bound_atom_OPEN` +
--    `topo_loss_above_upper_bound_atom_OPEN` with explicit Cat 2
--    Grimmett `h_grimmett` antecedent. Common-N step uses `max N₁ N₂`.
--  * `gap_bayesian_naive_reversal_absent` (Canonical.lean): single-atom
--    derived theorem composing
--    `bayesian_naive_below_threshold_blackwell_recovery_atom_OPEN` with
--    explicit Cat 2 Blackwell `h_blackwell` antecedent.
-- R42 also adds the new Cat 1 theorem itself:
--  * `topo_loss_below_eps_from_envelope` (Wrongness.lean): Cat 1 Mathlib
--    derivation from `Filter.Tendsto` neighborhood unfolding + transitivity
--    through envelope upper bound. Discharges R41 Pattern-1 violation.
#print axioms BlackwellDilemma.gap_topo_loss_below_threshold
#print axioms BlackwellDilemma.gap_topo_loss_above_threshold
#print axioms BlackwellDilemma.FiveState.gap_bayesian_naive_reversal_absent
#print axioms BlackwellDilemma.topo_loss_below_eps_from_envelope

-- R44 Pattern-1 fix (Phase.lean sibling of R42 Wrongness fix):
--  * `topo_loss_decay_arbitrary_threshold` (Phase.lean): Cat 1 theorem
--    derivation from `Filter.Tendsto` neighborhood unfolding + transitivity
--    through envelope upper bound. Discharges R37 Pattern-1 violation
--    (former axiom topo_loss_decay_arbitrary_threshold_OPEN was acknowledged
--    in R37 attackHistory as Mathlib-derivable but retained as Cat 3 axiom;
--    R43 audit caught it; R44 fix ports R42's proof verbatim).
#print axioms BlackwellDilemma.topo_loss_decay_arbitrary_threshold

-- R59 §18 closure wave on Phase.lean — 5 retired workingAssumption atoms
-- decomposed into 6 smaller atoms + 1 new carrier:
--  * `topo_loss_decay_below_pc` (R59 derived theorem): composes new
--    smaller atom `expectedTopoLoss_below_pc_one_over_n_envelope_OPEN`
--    (paper line 417 polynomial bound) + Cat 1 Mathlib
--    `tendsto_one_div_add_atTop_nhds_zero_nat`. Replaces retired
--    `topo_loss_decay_below_pc_OPEN`.
--  * `gap_phase_transition_above` (R59 re-derivation): instantiates
--    existential with new carrier `wInfoTopoRatioMillsConst p` and
--    composes two new smaller atoms `wInfoTopoRatioMillsConst_pos_above_pc_OPEN`
--    + `wInfoTopoRatio_le_MillsConst_decay_OPEN`. Replaces retired
--    `wInfoTopoRatio_const_exists_OPEN` + `wInfoTopoRatio_bound_OPEN`.
--  * `forward_reachable_full_at_zero` (R59 derived theorem): composes
--    two new smaller atoms `all_edges_open_at_zero_blocking_OPEN`
--    (Def 2.1 line 119 percolation semantics) +
--    `forward_reachable_empty_full_at_all_open_OPEN` (Def 2.1
--    connectivity + Def 2.5 forward-reachable). Replaces retired
--    `forward_reachable_full_at_zero_OPEN`.
--  * `gap_trap_prevalence_above_threshold` (R59 re-derivation, with
--    paper-faithful `p < 1` antecedent): composes Hodge-style def
--    `trapConfigLocalProb` + new smaller atom
--    `trapConfigLocalProb_le_misalignmentProb_OPEN` (FKG binding) +
--    Cat 1 theorem `trapConfigLocalProb_pos` (arithmetic positivity).
--    Replaces retired `trap_config_local_positive_OPEN`.
#print axioms BlackwellDilemma.topo_loss_decay_below_pc
#print axioms BlackwellDilemma.expectedTopoLoss_below_pc_one_over_n_envelope_OPEN
#print axioms BlackwellDilemma.wInfoTopoRatioMillsConst
#print axioms BlackwellDilemma.wInfoTopoRatioMillsConst_pos_above_pc_OPEN
#print axioms BlackwellDilemma.wInfoTopoRatio_le_MillsConst_decay_OPEN
#print axioms BlackwellDilemma.forward_reachable_full_at_zero
#print axioms BlackwellDilemma.all_edges_open_at_zero_blocking_OPEN
#print axioms BlackwellDilemma.forward_reachable_empty_full_at_all_open_OPEN
#print axioms BlackwellDilemma.trapConfigLocalProb
#print axioms BlackwellDilemma.trapConfigLocalProb_le_misalignmentProb_OPEN
#print axioms BlackwellDilemma.trapConfigLocalProb_pos

-- R60 closure wave on Wrongness.lean (5 retired bundled atoms → 6
-- new smaller atoms + 1 new opaque carrier). New derived theorems +
-- new smaller atoms + new carrier surface here for kernel-purity
-- baseline + audit-chain visibility:
--  * `gap_wrongness` (R60 re-derivation): composes the new smaller
--    atoms `wrongness_high_beta_welfare_floor_atom_OPEN` (paper stage 1
--    V_dyn-dominance + greedy concentration) +
--    `wrongness_misalignment_reversal_atom_OPEN` (paper stage 2 reversal
--    witness) via the welfare-floor existential. Replaces retired
--    `topology_blind_wrongness_atom_OPEN` (R44 MOST EGREGIOUS). Already
--    printed at line 352 above.
--  * `topo_loss_below_envelope_exists` (R60 derived theorem): new Cat 1
--    derivation composing the smaller atom
--    `topo_loss_below_one_over_n_envelope_atom_OPEN` (paper line 294
--    polynomial bound) + Cat 1 Mathlib `tendsto_one_div_add_atTop_nhds_zero_nat`.
--    Replaces retired `topo_loss_below_envelope_exists_atom_OPEN`.
--  * `gap_topo_loss_above_threshold` (R60 re-derivation): instantiates
--    existential with new carrier `expectedTopoLossAboveLowerConst p`
--    and `max(c₁, 1)` upper-bound witness; composes 3 new smaller atoms
--    (`expectedTopoLossAboveLowerConst_pos_above_pc_OPEN`,
--    `expectedTopoLoss_ge_AboveLowerConst_eventually_OPEN`,
--    `expectedTopoLoss_le_one_atom_OPEN`). Replaces retired
--    `topo_loss_above_lower_bound_atom_OPEN` +
--    `topo_loss_above_upper_bound_atom_OPEN`. Already printed at
--    line 409 above.
#print axioms BlackwellDilemma.wrongness_high_beta_welfare_floor_atom_OPEN
#print axioms BlackwellDilemma.wrongness_misalignment_reversal_atom_OPEN
#print axioms BlackwellDilemma.topo_loss_below_envelope_exists
#print axioms BlackwellDilemma.topo_loss_below_one_over_n_envelope_atom_OPEN
#print axioms BlackwellDilemma.expectedTopoLossAboveLowerConst
#print axioms BlackwellDilemma.expectedTopoLossAboveLowerConst_pos_above_pc_OPEN
#print axioms BlackwellDilemma.expectedTopoLoss_ge_AboveLowerConst_eventually_OPEN
#print axioms BlackwellDilemma.expectedTopoLoss_le_one_atom_OPEN

-- R61 closure wave on Cognitive.lean (2 retired bundled atoms → 4
-- new smaller atoms + 1 new opaque carrier + 2 new derived theorems).
-- New derived theorems + new smaller atoms + new carrier surface
-- here for kernel-purity baseline + audit-chain visibility:
--  * `mLimit_pos` (R61 derived theorem): composes the new
--    structural-equation atom `mLimit_eq_mLimitDifference_OPEN`
--    (paper line 505 identification of κ → ∞ limit value with
--    `V_dyn`-difference) + new smaller workingAssumption atom
--    `mLimitDifference_pos_OPEN` (paper-stated C2-derived strict
--    positivity). Replaces retired `mLimit_pos_OPEN`. Cat 1 chain
--    via `rw + exact`.
--  * `alpha_star_existence_via_continuity` (R61 derived theorem):
--    composes the existing `alphaStar_def` (R23-C1 atom) + Cat 1
--    Mathlib `le_csSup` / `csSup_le` + new smaller workingAssumption
--    atom `alpha_below_alpha_star_implies_monotonicity_OPEN` (paper
--    line 602 implicit downward-closure of monotonicity-set). Replaces
--    retired `alpha_star_existence_via_continuity_OPEN`. Cat 3 derived
--    theorem (consumed by `gap_sentimental_immunity`).
#print axioms BlackwellDilemma.mLimit_pos
#print axioms BlackwellDilemma.mLimitDifference
#print axioms BlackwellDilemma.mLimit_eq_mLimitDifference_OPEN
#print axioms BlackwellDilemma.mLimitDifference_pos_OPEN
#print axioms BlackwellDilemma.alpha_star_existence_via_continuity
#print axioms BlackwellDilemma.alpha_below_alpha_star_implies_monotonicity_OPEN

-- R62 closure wave on Canonical.lean (2 retired bundled atoms → 3
-- new smaller atoms + 2 new derived theorems). New derived theorems
-- + new smaller atoms surface here for kernel-purity baseline +
-- audit-chain visibility:
--  * `inflection_at_kstar` (R62 derived theorem): composes the new
--    structural-equation atom
--    `smoothTransitionBeta_corresponds_to_interior_optimum_OPEN`
--    (paper line 863 explicit `corresponding to β*` identification
--    of the inflection point with the prop:interior-optimum line 774
--    witness) + the existing `interior_minimiser_existence_OPEN`
--    witness's positivity clause `0 < β_star`. Replaces retired
--    `inflection_at_kstar_OPEN`. Net: −1 wA, +1 structuralEq.
--    Downstream `gap_threshold_fiveState_smooth_transition` re-routed
--    (no signature change at consumer level).
--  * `betaStarOfP_def` (R62 derived theorem, replaces axiom): composes
--    the new structural-equation atom
--    `betaStarOfP_eq_minimiser_witness_OPEN` (paper line 814 explicit
--    `β*(p)` notation as carrier identification) + new smaller
--    workingAssumption atom `L_minimum_exists_in_regime_i_OPEN`
--    (existence of interior minimum of L(·, p) on Regime (i)'s
--    domain). Replaces retired `betaStarOfP_def` axiom. Net: 0 wA
--    (best-round-style closure mirroring R61 mLimit_pos pattern).
--    Downstream `betaStarOfP_loss_below_limit` consumes the derived
--    theorem at identical call signature.
#print axioms BlackwellDilemma.FiveState.inflection_at_kstar
#print axioms BlackwellDilemma.FiveState.smoothTransitionBeta_corresponds_to_interior_optimum_OPEN
#print axioms BlackwellDilemma.FiveState.betaStarOfP_def
#print axioms BlackwellDilemma.FiveState.betaStarOfP_eq_minimiser_witness_OPEN
#print axioms BlackwellDilemma.FiveState.L_minimum_exists_in_regime_i_OPEN

end BlackwellDilemma.AxiomAudit
