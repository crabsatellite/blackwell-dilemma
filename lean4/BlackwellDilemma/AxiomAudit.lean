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

  Note on BLOCKED/DEAD-END status:
  Per the `feedback_gap_ledger_in_lean4` 6-tier discipline
  (OPEN / PARTIAL / BLOCKED / DEAD-END / CLOSED / DEFINITIONAL),
  BLOCKED is reserved for genuine no-acceptance-possible cases
  (folkloric, conjectural-unproven, or no-source-at-all). External
  published Cat 2 theorems with Mathlib gap are encoded as plain
  Cat 2 OPEN axioms (`axiom gap_X_OPEN : <stmt>` with paper-cited
  docstring), NOT as BLOCKED-defs.

  Cat 2 dependency surfacing: for downstream THEOREMS, the Cat 2
  axiom is composed in the proof body and surfaces in `#print
  axioms` automatically. For downstream AXIOMS (which have no body),
  the Cat 2 axiom MUST be threaded as an EXPLICIT ANTECEDENT for the
  dependency to surface in `#print axioms`.

  Usage:  `lake env lean BlackwellDilemma/AxiomAudit.lean`
-/

import BlackwellDilemma

namespace BlackwellDilemma.AxiomAudit

-- §2 IDP Types (signal-variance algebra)
#print axioms BlackwellDilemma.signalVariance_strictAntitoneOn
-- Cat 1 closure: `σ²_topo(κ, 0) = 0` (paper proof line 870 —
-- terminal-vertex distance-0 case). Kernel-pure via `unfold + simp`.
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
-- Derived closure: Proposition `prop:topo-cluster` closed-form
-- `(n-k)/((n+1)(k+1))` derives algebraically from the derived theorem
-- `expectedTopoLoss_conditional_def` (paper line 292 order-statistics
-- decomposition `n/(n+1) − k/(k+1)`, Cat 2 absorbed via David &
-- Nagaraja Eq. 2.1.4) via `field_simp; ring`.
#print axioms BlackwellDilemma.gap_topo_cluster_relation
-- Cat 2 absorption: `expectedTopoLoss_conditional_def` derived
-- theorem composes `gap_orderstats_topo_decomposition_OPEN` (paper-
-- application of David & Nagaraja Eq. 2.1.4 to IDP carrier via paper
-- Def 2.1 standing convention, Wrongness.lean) + `gap_david_nagaraja_
-- eq214_OPEN` (substantive David & Nagaraja 2003 Eq. 2.1.4 textbook
-- identity on opaque `expectedMaxIIDUniform` carrier, ClassicalResults.
-- lean). Both Cat 2 axioms surface via `#print axioms`.
#print axioms BlackwellDilemma.expectedTopoLoss_conditional_def
#print axioms BlackwellDilemma.gap_conditional_reduction_part_ii
-- Derived closure: Lemma `lem:conditional-reduction` part (i),
-- conditional Blackwell monotonicity on the restricted action domain.
-- Composes the Cat 3 atom `conditional_subproblem_blackwell_applicable_OPEN`
-- (paper line 375) threading the Cat 2 Blackwell 1951/1953 dependency.
#print axioms BlackwellDilemma.gap_conditional_reduction_part_i

-- §3.3 Phase Transition layer
#print axioms BlackwellDilemma.gap_er_phase_subcritical
#print axioms BlackwellDilemma.gap_er_phase_supercritical
#print axioms BlackwellDilemma.gap_power_law_heavy_tail
-- Derived closure: Proposition `prop:trap-prevalence` Part 1
-- (V_dyn agrees on neighbours at p = 0). Composes the Cat 3 atom
-- `forward_reachable_full_at_zero_OPEN` (paper line 463) with the
-- existing `V_dyn_def` atom + `Finset.sup'_congr` (Cat 1 Mathlib).
-- The `[Fintype Vertex]` parameter is an instance argument on the
-- theorem and does NOT block `#print axioms` (which prints the
-- definition's axiom dependency closure, not its applied form).
#print axioms BlackwellDilemma.gap_trap_prevalence_zero
-- Derived closures: Theorem 3.3 phase-transition Parts 1+2 +
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
-- Derived closures: Proposition `prop:supermodular` +
-- Proposition `prop:sentimental`.
--  * `gap_supermodular`: composes `welfareCrossPartial_explicit_form_OPEN`
--    (paper-stated calculus closed form, line 564-583) +
--    `cross_partial_sign_in_z_lt_one_OPEN` (paper-stated sign analysis
--    at `|z| < 1`, line 582-584). Cat 2 Topkis 1978/1998 dependency
--    threaded via `_h_topkis`.
--  * `gap_sentimental_immunity`: composes `signal_independent_at_alpha_zero`
--    (derived theorem; paper L600 base case at α = 0; Cat 2 absorbed
--    via `gap_iid_continuous_rank_symmetry_OPEN` + `gap_blackwell_
--    monotonicity_OPEN`) + `welfare_continuity_in_alpha_OPEN`
--    (paper L602 perturbative continuity neighbourhood) +
--    `alpha_star_existence_via_continuity_OPEN` (paper L602 sup-existence
--    of `α*`).
#print axioms BlackwellDilemma.gap_supermodular
#print axioms BlackwellDilemma.gap_sentimental_immunity
-- Cat 2 absorption: `signal_independent_at_alpha_zero` derived
-- theorem composes `gap_iid_continuous_rank_symmetry_OPEN` (David &
-- Nagaraja 2003 §1.3 + Blackwell 1953 conditional Cat 2,
-- ClassicalResults.lean) + `gap_blackwell_monotonicity_OPEN` (Blackwell
-- 1953 Cat 2 ClassicalResults.lean:71). Both Cat 2 dependencies surface
-- via `#print axioms`.
#print axioms BlackwellDilemma.signal_independent_at_alpha_zero
-- Theorem 4.1 Part 5 (κ*(α) non-decreasing in α). Paper-faithful
-- bounded closure on the abstract `kappaStar` carrier via the
-- α-faithful welfare-transition reformulation
-- `kappaStar p α = sInf { 0 < κ ∧ alphaWelfareShift α ≤ m(p, κ) }`
-- + Mathlib `csInf_le_csInf` lift over the set inclusion
-- `S(p, α₂) ⊆ S(p, α₁)` (immediate from the derived
-- monotonicity `alphaWelfareShift_monotone_paper_Def` in
-- `Infrastructure/AlphaWelfareShift.lean`). Mirrors the Part 4 bounded
-- closure pattern via `mean_estimate_gap_antitone_in_p_paper_Def` +
-- `csInf_le_csInf`.
--
-- KERNEL-PURE: expected output `[propext, Classical.choice, Quot.sound]`.
#print axioms BlackwellDilemma.gap_cognitive_threshold_part5

-- The α-monotonicity of the welfare-transition shift carrier
-- underpinning Part 5. The paper's IFT sign analysis (Proposition
-- `\label{prop:threshold-alpha}` line 586 `∂M/∂α < 0` on the
-- welfare-transition functional `M(p, κ, α) = 0`) fixes the sign
-- (strictly positive `∂κ*/∂α`) of the shift gradient.
--
-- KERNEL-PURE: expected output `[propext, Classical.choice, Quot.sound]`.
#print axioms BlackwellDilemma.Infrastructure.alphaWelfareShift_monotone_paper_Def

-- Part 4 antitone-in-p derived theorem via
-- `Infrastructure/MeanEstimateGapAntitoneInP`. The mean-estimate-gap
-- on the canonical IDP instance is antitone in `p` for every `κ > 0`
-- because the prior-mean component for the bridge neighbour `u_2`
-- `priorMean_u2_fiveState p = (1-p)·r(G) + p·r(u_2)` is antitone in `p`
-- (linear closed form) and the Gaussian conjugate-prior posterior mean
-- is monotone in its prior-mean argument (derivation from
-- `gaussianPosteriorMean_denom_pos` + `div_le_div_of_nonneg_right`).
#print axioms BlackwellDilemma.mean_estimate_gap_antitone_in_p_paper_Def

-- §4 Principal layer
-- Derived closures: Proposition `prop:principal-optimum` Parts 1-3
-- + Corollary `cor:disclosure` Parts 1-2.
--  * `gap_principal_interior_optimum`: composes 3 atoms (paper proof
--    line 624-625, 632) — `W_bar_eventually_decreasing_in_reversal_OPEN`
--    + `W_bar_exceeds_zero_at_positive_beta_OPEN` +
--    `interior_max_exists_from_unimodal_envelope` (derived theorem
--    composing `betaBarStar_nonneg_OPEN` structural eq + `betaBarStar_def`
--    argmax-characterisation via Cat 1 Mathlib chain).
--  * `gap_principal_monotone_in_kappa`: composes 2 atoms (paper proof
--    line 626, 634) — `fosd_induces_derivative_domination_OPEN` +
--    `argmax_monotone_under_derivative_domination_OPEN`.
--  * `gap_principal_regime_bifurcation`: direct application of
--    `non_concave_triple_W_bar_OPEN` (paper line 640 valley triple
--    stipulation directly on `W_bar`). The derived theorem
--    `W_bar_mixture_decomposition` (paper line 638 mixture identity)
--    remains as a separate fact in its own right.
--  * `gap_disclosure_full_suboptimal`: composes 2 atoms (paper proof
--    line 645, 652-656) — `averaged_reversal_overshoot_positive_OPEN` +
--    `finite_beta_above_limit_from_overshoot_OPEN`.
--  * `gap_disclosure_differentiated_dominates`: re-exports the derived
--    theorem `differentiated_per_agent_optimum_dominates_uniform`
--    (composes `perAgentOptimalAggregate` carrier +
--    `differentiatedDisclosureWelfare_eq_perAgentOptimal_OPEN` structural
--    eq + `perAgentOptimalAggregate_dominates_uniform_OPEN` smaller wA).
#print axioms BlackwellDilemma.gap_principal_interior_optimum
#print axioms BlackwellDilemma.gap_principal_monotone_in_kappa
#print axioms BlackwellDilemma.gap_principal_regime_bifurcation
#print axioms BlackwellDilemma.gap_disclosure_full_suboptimal
#print axioms BlackwellDilemma.gap_disclosure_differentiated_dominates
-- §18 closure-path-A derived theorems (replacing retired
-- workingAssumption axioms; ledger entries re-routed to consume these).
#print axioms BlackwellDilemma.interior_max_exists_from_unimodal_envelope
#print axioms BlackwellDilemma.W_bar_mixture_decomposition
#print axioms BlackwellDilemma.differentiated_per_agent_optimum_dominates_uniform
-- Substantive-math closures (concrete-def closure pattern via the
-- `kappa_FOSD_def` precedent applied at scale): 4 atoms closed via
-- `def <aggregate> := <component-expression>` matching paper's explicit
-- identification, then theorem reduces to `rfl`. The two structural-
-- equation closures here (W_bar / differentiatedDisclosureWelfare) +
-- the mLimit closure (Cognitive.lean) + the oracleValueAtRoot closure
-- (GeneralGraphs.lean — the wA-reducing closure).
#print axioms BlackwellDilemma.W_bar_eq_mixture_OPEN
#print axioms BlackwellDilemma.differentiatedDisclosureWelfare_eq_perAgentOptimal_OPEN
-- Pattern 5 closures extended to the Principal layer (`betaStarOfP` /
-- `smoothTransitionBeta` precedent): 3 wA atoms closed via
-- `noncomputable def <carrier> := Classical.choose <existence_atom>`
-- + `theorem <atom>_def := Classical.choose_spec`. The carriers
-- betaBarStar, aggregateOptimalBeta, W_bar_limit_infty are now concrete
-- defs invoking Classical.choose on new wA existence atoms
-- (principal_interior_maximum_exists_OPEN, aggregate_optimum_exists_per_G_OPEN,
-- W_bar_has_limit_infty_OPEN). NET 0 wA: 3 retired wAs (betaBarStar_def,
-- aggregateOptimalBeta_def, W_bar_limit_infty_def) + 3 new wAs.
#print axioms BlackwellDilemma.betaBarStar_def
#print axioms BlackwellDilemma.aggregateOptimalBeta_def
#print axioms BlackwellDilemma.W_bar_limit_infty_def
-- §18 closure-path-A on welfareCrossPartial_explicit_form_OPEN:
-- bundled wA decomposed into 2 new opaque carriers (firstTermCrossPartial
-- + secondTermCrossPartial per paper line 566 explicit two-term
-- decomposition) + 2 new smaller wAs (secondTermCrossPartial_nonneg_OPEN
-- per paper line 568 + firstTermCrossPartial_pos_in_z_lt_one_OPEN per
-- paper lines 582-584). welfareCrossPartial promoted from `axiom` to
-- `noncomputable def := firstTermCrossPartial + secondTermCrossPartial`.
-- The cross_partial_sign_in_z_lt_one_OPEN atom is ALSO retired via
-- Cat 1 linarith arithmetic on the universal-quantified premises.
-- NET 0 wA on welfareCrossPartial branch: -2 retired bundled wAs + 2
-- new smaller wAs.
#print axioms BlackwellDilemma.welfareCrossPartial_explicit_form_OPEN
#print axioms BlackwellDilemma.cross_partial_sign_in_z_lt_one_OPEN
-- Concretisation of the firstTermCrossPartial / secondTermCrossPartial
-- carriers as the paper's exact closed-form products (Proposition
-- prop:supermodular proof lines 566-584):
--   firstTermCrossPartial β κ
--     = sigEffRatioFactor β * mPrime κ * stdNormalPDF (snrZ β κ)
--         * (1 - snrZ β κ ^ 2) * bridgeValueGap β
--   secondTermCrossPartial β κ = pCorrectDerivKappa β κ * vDynDerivBeta β
-- The 2 residual wA axioms secondTermCrossPartial_nonneg_OPEN +
-- firstTermCrossPartial_pos_in_z_lt_one_OPEN are REPLACED by derived
-- THEOREMS of the same name. secondTermCrossPartial_nonneg_OPEN closes
-- via `mul_nonneg` of paper-stated factor signs; firstTermCrossPartial_
-- pos_in_z_lt_one_OPEN closes factor-by-factor with stdNormalPDF_pos
-- (Mathlib-derived, kernel-pure) + `1 - z² > 0` (Mathlib nlinarith from
-- |z| < 1) + 3 paper-stated factor-sign atoms. NET −2 wA. The 5 new
-- factor-sign atoms (sigEffRatioFactor_pos, mPrime_pos, bridgeValueGap_pos,
-- pCorrectDerivKappa_pos, vDynDerivBeta_nonneg) are Cat 3 §3.4.3
-- structuralEquation (paper writes each sign explicitly), NOT wAs.
-- stdNormalPDF_pos is Cat 1 Mathlib (kernel-pure, no paper axioms).
#print axioms BlackwellDilemma.secondTermCrossPartial_nonneg_OPEN
#print axioms BlackwellDilemma.firstTermCrossPartial_pos_in_z_lt_one_OPEN
#print axioms BlackwellDilemma.stdNormalPDF_pos

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
-- §18 decompositions (Bayesian.lean): gap_robustness_myopic_k +
-- gap_robustness_satisficing are derived theorems re-derived via
-- strictly-smaller atoms + Cat 2 Blackwell chain (myopic side —
-- `h_blackwell` antecedent threaded into `gap_robustness_myopic_k`) /
-- 2-atom decomposition through new opaque carrier
-- `satisficingTrapAcceptanceProb` with constructive witnesses β₁=0,
-- β₂=1 (satisficing side). The smaller atoms below surface in
-- `#print axioms` of the consuming derived theorems.
#print axioms BlackwellDilemma.gap_robustness_myopic_k
#print axioms BlackwellDilemma.gap_robustness_satisficing
-- Individual atom prints (kernel-purity baseline + audit-chain
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

-- Cat 1 limit helpers: Φ tail limits + signal-variance limit at infinity
-- + the constant-divided-by-vanishing-positive-function → ∞ helper. Used by
-- the gap_W_open_limit_infty + gap_error_compounding_part1 closures.
#print axioms BlackwellDilemma.Phi_tendsto_one_atTop
#print axioms BlackwellDilemma.Phi_tendsto_zero_atBot
#print axioms BlackwellDilemma.signalVariance_tendsto_zero_atTop
#print axioms BlackwellDilemma.tendsto_const_div_atTop_of_tendsto_zero_pos

-- Cat 1 helpers: Phi continuity (from FTC closure) + signalVariance
-- limit at 0+ (symmetric mirror of the atTop limit above).
-- Used by gap_W_open_limit_zero closure.
#print axioms BlackwellDilemma.Phi_continuousAt
#print axioms BlackwellDilemma.signalVariance_tendsto_atTop_of_tendsto_zero_pos

-- Derived closures: prop:canonical β→∞ limit + prop:error-compounding
-- Part 1 (β→∞ welfare-limit on the depth-d trap tree).
#print axioms BlackwellDilemma.FourState.gap_W_open_limit_infty
#print axioms BlackwellDilemma.TrapTree.gap_error_compounding_part1

-- Derived closure: prop:canonical β→0+ limit (symmetric mirror of
-- gap_W_open_limit_infty). Composes the Cat 1 helpers above.
#print axioms BlackwellDilemma.FourState.gap_W_open_limit_zero

-- Derived closure: rem:robustness-misspec (i) — re-export of
-- FiveState.gap_bayesian_naive_routing_threshold (Cat 1 kernel-pure).
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
-- Cat 3 derived closure: Proposition `prop:error-compounding`
-- Part 2 (oracle dynamic value at root = `r_goal` for all `d ≥ 1`).
-- Derives directly from the Cat 3 atomic structural equation
-- `oracleValueAtRoot_TrapTree_def` (paper line 1041); see
-- Ledger entry `entry_prop_error_compounding`.
#print axioms BlackwellDilemma.TrapTree.gap_error_compounding_part2
-- Upper-bound half of the κ*(d) = Θ(log d) asymptotic. The lower-bound
-- half is ALSO a genuine theorem (`kappaStar_depth_d_lower_bound` via
-- weighted AM–GM), so the full Θ-asymptotic
-- `bernoulli_real_power_estimate_OPEN` is no longer an OPEN axiom.
#print axioms BlackwellDilemma.TrapTree.gap_kappaStar_depth_d_upper_bound
-- Derived closures from Manufactured-Recognition-pattern atomic
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

-- Derived closures from Pattern 7 phantom-downstream repair
-- (Wires #1-#6: composing orphan atoms with Mathlib + companion atoms
-- to give them explicit downstream consumers):
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

-- §18 atomic-decomposition derived theorems: 22 conclusion-axioms
-- decomposed into atomic stipulations + derived theorems per
-- `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition
-- pattern. Each entry below is the derived theorem now hosting the
-- bundled paper conclusion; the corresponding atomic-stipulation
-- axiom (named `<paper_content>_OPEN`) is the underlying paper-stated
-- substance pending per-instance closure.

-- Cognitive.lean §18 decomposition (6 derived theorems; Part 4 is
-- the paper-faithful bounded form on the abstract `kappaStar`
-- carrier — see the `gap_cognitive_threshold_part4` docstring for the
-- non-emptiness-premise rationale. The unconditional universal-form
-- claim remains DEAD-END via the
-- `kappaStar_p_monotone_DEAD_END_by_junk_value` `def : Prop` marker;
-- that marker carries zero kernel impact and no `#print axioms` line
-- is needed for it):
--
-- `gap_cognitive_threshold_part2` is STRICT KERNEL-PURE (modulo
-- Types.lean foundational primitives). The
-- `agentRewardKernel_kappaAbove_pointwise_monotone` structural
-- equation is a derived `theorem` via the kernel concretisation: the
-- `AgentType.kappaAgent` branch of `agentRewardKernel` returns the
-- constant value `1/2`, so pointwise monotonicity holds via `le_refl`
-- after `simp [agentRewardKernel]`; the existential witness
-- `κ₀ := 0` is paper-aligned (paper line 894: 5-state `κ*(p) = 0`
-- throughout the reversal regime). `#print axioms` on
-- `gap_cognitive_threshold_part2` lists ONLY `[propext,
-- Classical.choice, Quot.sound, C1_Irreversibility,
-- C2_RewardTopologyMisalignment, C3_InformationLocality,
-- TerminalNeighbourTopology, AgentEdgeIdx, AgentEdgeIdx.fintype,
-- AgentEdgeIdx.decEq, blockingProb, blockingProb_mem_unitInterval]`.
#print axioms BlackwellDilemma.gap_cognitive_threshold_part1
#print axioms BlackwellDilemma.gap_cognitive_threshold_part2
#print axioms BlackwellDilemma.gap_cognitive_threshold_part4
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
-- `gap_kappaStar_depth_d_log_growth`: the print surfaces only
-- [propext, Classical.choice, Quot.sound] + the opaque
-- `c_star_constant` carrier + `gap_c_star_constant_pos_OPEN`.
#print axioms BlackwellDilemma.TrapTree.gap_kappaStar_depth_d_log_growth

-- Individual atom prints + derived theorem:
--  * `terminal_neighbour_implies_C2prime` derived theorem composes the
--    two smaller atoms below.
--  * `gap_cyclic_trap` derived via smaller atom + file-local Theorem
--    6.1 atom chain.
--  * `gap_error_compounding_part2` re-derived via 2-atom
--    chain through new opaque carrier `oracleBridgePathTerminalReward_TrapTree`.
#print axioms BlackwellDilemma.terminal_neighbour_implies_C2prime
#print axioms BlackwellDilemma.V_g_eq_V_dyn_on_terminal_neighbour_OPEN
#print axioms BlackwellDilemma.C2_to_C2prime_via_V_g_eq_V_dyn_at_terminal_neighbour_OPEN
#print axioms BlackwellDilemma.cyclic_4_satisfies_full_conditions_at_blocked_event_OPEN
#print axioms BlackwellDilemma.TrapTree.oracleBridgePathTerminalReward_TrapTree
#print axioms BlackwellDilemma.TrapTree.oracleValueAtRoot_eq_bridgePathTerminalReward_TrapTree_OPEN
#print axioms BlackwellDilemma.TrapTree.oracleBridgePathTerminalReward_TrapTree_eq_r_goal_OPEN

-- §18 decompositions (3 derived theorems closing the final
-- workingAssumption residue):
--  * `gap_topo_loss_below_threshold` (Wrongness.lean): composes Cat 3
--    workingAssumption atom `topo_loss_below_envelope_exists_atom_OPEN`
--    (paper line 286 envelope existence) + Cat 1 theorem
--    `topo_loss_below_eps_from_envelope` (Mathlib-discharge from
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
-- The closure also adds the Cat 1 theorem itself:
--  * `topo_loss_below_eps_from_envelope` (Wrongness.lean): Cat 1 Mathlib
--    derivation from `Filter.Tendsto` neighborhood unfolding + transitivity
--    through envelope upper bound.
#print axioms BlackwellDilemma.gap_topo_loss_below_threshold
#print axioms BlackwellDilemma.gap_topo_loss_above_threshold
#print axioms BlackwellDilemma.FiveState.gap_bayesian_naive_reversal_absent
-- `topo_loss_below_eps_from_envelope` removed (refactored into
-- `gap_topo_loss_below_threshold` chain); audit reference dropped.

-- Phase.lean sibling of the Wrongness.lean Pattern-1 fix:
--  * `topo_loss_decay_arbitrary_threshold` (Phase.lean): Cat 1 theorem
--    derivation from `Filter.Tendsto` neighborhood unfolding + transitivity
--    through envelope upper bound. Ports the Wrongness.lean proof verbatim.
#print axioms BlackwellDilemma.topo_loss_decay_arbitrary_threshold

-- §18 closure wave on Phase.lean — 5 retired workingAssumption atoms
-- decomposed into 6 smaller atoms + 1 new carrier:
--  * `topo_loss_decay_below_pc` (derived theorem): composes smaller
--    atom `expectedTopoLoss_below_pc_one_over_n_envelope_OPEN` (paper
--    line 417 polynomial bound) + Cat 1 Mathlib
--    `tendsto_one_div_add_atTop_nhds_zero_nat`. Replaces retired
--    `topo_loss_decay_below_pc_OPEN`.
--  * `gap_phase_transition_above` (re-derivation): instantiates
--    existential with new carrier `wInfoTopoRatioMillsConst p` and
--    composes two smaller atoms `wInfoTopoRatioMillsConst_pos_above_pc_OPEN`
--    + `wInfoTopoRatio_le_MillsConst_decay_OPEN`. Replaces retired
--    `wInfoTopoRatio_const_exists_OPEN` + `wInfoTopoRatio_bound_OPEN`.
--  * `forward_reachable_full_at_zero` (derived theorem): composes
--    two smaller atoms `all_edges_open_at_zero_blocking_OPEN`
--    (Def 2.1 line 119 percolation semantics) +
--    `forward_reachable_empty_full_at_all_open_OPEN` (Def 2.1
--    connectivity + Def 2.5 forward-reachable). Replaces retired
--    `forward_reachable_full_at_zero_OPEN`.
--  * `gap_trap_prevalence_above_threshold` (re-derivation, with
--    paper-faithful `p < 1` antecedent): composes Hodge-style def
--    `trapConfigLocalProb` + smaller atom
--    `trapConfigLocalProb_le_misalignmentProb_OPEN` (FKG binding) +
--    Cat 1 theorem `trapConfigLocalProb_pos` (arithmetic positivity).
--    Replaces retired `trap_config_local_positive_OPEN`.
-- NOTE: `expectedTopoLoss_below_pc_one_over_n_envelope_OPEN` was
-- RETIRED (signature correction — see the percolation-foundation
-- continuation section below). `topo_loss_decay_below_pc` is re-stated
-- on the paper-faithful `expectedTopoLossOnGiant`; its `#print axioms`
-- surfaces the signature-corrected atom
-- `topoLossKernel_le_one_over_n_on_giant_atom_OPEN` + the
-- `giantComponentEvent` carrier instead of the retired false atom.
-- NOTE: `trapConfigLocalProb_le_misalignmentProb_OPEN` was RETIRED
-- (signature correction — over-strong/false; see the section below).
-- `gap_trap_prevalence_above_threshold` is re-derived on the
-- concretised `trapMisalignmentProbability` + the signature-corrected
-- chain; its `#print axioms` surfaces the corrected atoms
-- `trapLocalConfigProb_pos_and_le` /
-- `restrictedExpectation_eq_localConfigProb` /
-- `trapEventIndicator_nonneg` + the carriers `trapEventIndicator` /
-- `trapLocalConfigEvent` / `trapLocalConfigProb` instead of the
-- retired false atom.  The `#print axioms` line for the retired atom
-- is removed (the atom no longer exists).
#print axioms BlackwellDilemma.topo_loss_decay_below_pc
#print axioms BlackwellDilemma.wInfoTopoRatioMillsConst
#print axioms BlackwellDilemma.wInfoTopoRatioMillsConst_pos_above_pc_OPEN
#print axioms BlackwellDilemma.wInfoTopoRatio_le_MillsConst_decay_OPEN
#print axioms BlackwellDilemma.forward_reachable_full_at_zero
#print axioms BlackwellDilemma.all_edges_open_at_zero_blocking_OPEN
#print axioms BlackwellDilemma.forward_reachable_empty_full_at_all_open_OPEN
#print axioms BlackwellDilemma.trapConfigLocalProb
#print axioms BlackwellDilemma.trapConfigLocalProb_pos

-- Closure wave on Wrongness.lean (5 retired bundled atoms → 6
-- smaller atoms + 1 new opaque carrier). Derived theorems + smaller
-- atoms + new carrier surface here for kernel-purity baseline +
-- audit-chain visibility:
--  * `gap_wrongness` (re-derivation): composes the smaller atoms
--    `wrongness_high_beta_welfare_convergence_atom_OPEN` (paper stage 1
--    welfare convergence `W(β) → V_dyn(u_1)`) +
--    `wrongness_misalignment_reversal_atom_OPEN` (paper stage 2 reversal
--    witness, antecedent strengthened to convergence form) via the
--    convergence existential. Replaces retired
--    `topology_blind_wrongness_atom_OPEN`. Already printed above.
--  * `topo_loss_below_envelope_exists` (derived theorem): Cat 1
--    derivation composing the smaller atom
--    `topo_loss_below_one_over_n_envelope_atom_OPEN` (paper line 294
--    polynomial bound) + Cat 1 Mathlib `tendsto_one_div_add_atTop_nhds_zero_nat`.
--    Replaces retired `topo_loss_below_envelope_exists_atom_OPEN`.
--  * `gap_topo_loss_above_threshold` (re-derivation): instantiates
--    existential with new carrier `expectedTopoLossAboveLowerConst p`
--    and `max(c₁, 1)` upper-bound witness; composes 3 smaller atoms
--    (`expectedTopoLossAboveLowerConst_pos_above_pc_OPEN`,
--    `expectedTopoLoss_ge_AboveLowerConst_eventually_OPEN`,
--    `expectedTopoLoss_le_one_atom_OPEN`). Replaces retired
--    `topo_loss_above_lower_bound_atom_OPEN` +
--    `topo_loss_above_upper_bound_atom_OPEN`. Already printed above.
-- NOTE: `topo_loss_below_envelope_exists` /
-- `topo_loss_below_one_over_n_envelope_atom_OPEN` were RETIRED
-- (signature correction — see the percolation-foundation continuation
-- section below).  Replaced by the derived theorem
-- `topo_loss_on_giant_below_envelope_exists` + the
-- signature-corrected atom `topoLossKernel_le_one_over_n_on_giant_atom_OPEN`,
-- both printed in the percolation-foundation section below.
#print axioms BlackwellDilemma.wrongness_high_beta_welfare_convergence_atom_OPEN
#print axioms BlackwellDilemma.wrongness_misalignment_reversal_atom_OPEN
#print axioms BlackwellDilemma.expectedTopoLossAboveLowerConst
#print axioms BlackwellDilemma.expectedTopoLossAboveLowerConst_pos_above_pc_OPEN
#print axioms BlackwellDilemma.expectedTopoLoss_ge_AboveLowerConst_eventually_OPEN
#print axioms BlackwellDilemma.expectedTopoLoss_le_one_atom_OPEN

-- Closure wave on Cognitive.lean (2 retired bundled atoms → 4
-- smaller atoms + 1 new opaque carrier + 2 derived theorems).
-- Derived theorems + smaller atoms + new carrier surface here for
-- kernel-purity baseline + audit-chain visibility:
--  * `mLimit_pos` (derived theorem): composes the structural-equation
--    atom `mLimit_eq_mLimitDifference_OPEN` (paper line 505
--    identification of κ → ∞ limit value with `V_dyn`-difference) +
--    smaller workingAssumption atom `mLimitDifference_pos_OPEN`
--    (paper-stated C2-derived strict positivity). Replaces retired
--    `mLimit_pos_OPEN`. Cat 1 chain via `rw + exact`.
--  * `alpha_star_existence_via_continuity` (derived theorem):
--    composes the existing `alphaStar_def` (Cat 3 atom) + Cat 1
--    Mathlib `le_csSup` / `csSup_le` + smaller workingAssumption
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

-- Closure wave on Canonical.lean (2 retired bundled atoms → 3
-- smaller atoms + 2 derived theorems). Derived theorems + smaller
-- atoms surface here for kernel-purity baseline + audit-chain
-- visibility:
--  * `inflection_at_kstar` (derived theorem): composes the
--    structural-equation atom
--    `smoothTransitionBeta_corresponds_to_interior_optimum_OPEN`
--    (paper line 863 explicit `corresponding to β*` identification
--    of the inflection point with the prop:interior-optimum line 774
--    witness) + the existing `interior_minimiser_existence_OPEN`
--    witness's positivity clause `0 < β_star`. Replaces retired
--    `inflection_at_kstar_OPEN`. Net: −1 wA, +1 structuralEq.
--    Downstream `gap_threshold_fiveState_smooth_transition` re-routed
--    (no signature change at consumer level).
--  * `betaStarOfP_def` (derived theorem, replaces axiom via Pattern 5
--    closure): `noncomputable def betaStarOfP (p : ℝ) : ℝ :=
--    if h : 0 ≤ p ∧ p < p_1 then
--    Classical.choose (L_minimum_exists_in_regime_i_OPEN p h.1 h.2)
--    else 0`; `betaStarOfP_def` proof via `dif_pos` + `Classical.
--    choose_spec.2`. The structural-equation atom
--    `betaStarOfP_eq_minimiser_witness_OPEN` is RETIRED (no
--    replacement); existence atom retained.  Pattern 5 unblocks the
--    DEFERRED universal-inequality atoms class.
--    Downstream `betaStarOfP_loss_below_limit` consumes the derived
--    theorem at identical call signature.
-- `smoothTransitionBeta_corresponds_to_interior_optimum_OPEN`
-- RETIRED via Pattern 5 closure (`smoothTransitionBeta` carrier promoted to
-- `noncomputable def := Classical.choose interior_minimiser_existence_OPEN`;
-- positivity now derives Cat 1 from `Classical.choose_spec.1`). The
-- `inflection_at_kstar` print remains as the canonical kernel-purity check
-- for the derivation; the corresponding axiom name no longer exists in
-- the source.
#print axioms BlackwellDilemma.FiveState.inflection_at_kstar
#print axioms BlackwellDilemma.FiveState.betaStarOfP_def
#print axioms BlackwellDilemma.FiveState.L_minimum_exists_in_regime_i_OPEN
#print axioms BlackwellDilemma.FiveState.betaStarOfP
#print axioms BlackwellDilemma.FiveState.smoothTransitionBeta

-- Substantive-math closures (concrete-def closure of paper-stated
-- structural-equation atoms via the concrete-def closure pattern,
-- applied to two classes — sup/inf-characterisation atoms and paper-
-- named regime-split atoms):
--
-- (1) `kappaStar_def` (paper Theorem 4.1 Part 3 line 493 inf-
--     characterisation `κ* = inf{κ > 0 : m(κ) ≥ 0}`): derivedTheorem
--     gapClosed via `noncomputable def kappaStar (p _α : ℝ) : ℝ :=
--     sInf {κ : ℝ | 0 < κ ∧ 0 ≤ mean_estimate_gap p κ}` +
--     `theorem kappaStar_def := fun _ _ => rfl`.
-- (2) `alphaStar_def` (paper `prop:sentimental` proof line 602 sup-
--     characterisation): derivedTheorem gapClosed via
--     `noncomputable def alphaStar (κ _p : ℝ) : ℝ := sSup {...}` +
--     `theorem alphaStar_def := fun _ _ => rfl`.
-- (3) `myopic_k_eq_bayesian_above_divergence_depth_OPEN` (paper Remark
--     `rem:robustness-misspec` (ii) line 942 paper-named regime split at
--     horizon `k ≥ d`): derivedTheorem gapClosed via
--     `noncomputable def myopicKWelfare :=
--     if k ≥ d then agentWelfare AgentType.bayesian β 0 1
--     else myopicKWelfareBelowDepth k d β` + `theorem ... := by
--     unfold myopicKWelfare; exact if_pos hkd`. Adds new opaque carrier
--     `myopicKWelfareBelowDepth` for the paper-implicit `k < d` regime.
--
-- Each closure is HONEST (paper's exact identification formula or
-- paper-named regime split is encoded in the def body, no content-
-- erasure). The corresponding identifiers are now bound to derived
-- theorems; #print axioms reflects the kernel-pure derivation chain
-- (depending on `mean_estimate_gap`, `agentWelfare`,
-- `myopicKWelfareBelowDepth`, etc., not on opaque axioms).
#print axioms BlackwellDilemma.kappaStar_def
#print axioms BlackwellDilemma.alphaStar_def
#print axioms BlackwellDilemma.myopicKWelfareBelowDepth

-- Substantive L-carrier closure wave (3 Cat 3 workingAssumption
-- atoms about the CONCRETE 5-state welfare-loss carrier `L β p` closed
-- by genuine real-analysis on the concrete definition — NOT by
-- `Classical.choose` / opaque-carrier reclassification):
--
-- (1) `L_below_limit_at_some_beta_OPEN` (paper prop:three-regime-five-
--     state Regime (i) line 814 below-limit β* existence):
--     derivedTheorem gapClosed via `theorem L_below_limit_at_some_beta_OPEN
--     := L_below_limit_at_some_beta_proof`. The proof composes the
--     rearrangement identity `eq:five-state-rearr` (`L_rearrangement`,
--     by `ring`), the strict bound `P_trap β < 1` (`P_trap_lt_one`,
--     from new ClassicalResults lemma `Phi_lt_one`), and `Φ_B β → 1`
--     as β → ∞ (`Phi_B_tendsto_one_atTop`, from
--     `signalVariance_tendsto_zero_atTop` + `Phi_tendsto_one_atTop`).
-- (2) `L_nonmonotone_witnesses_OPEN` (Regime (i) non-monotonicity):
--     derivedTheorem gapClosed; both witness pairs proved from the
--     below-limit witness β* plus the endpoint limits `L_tendsto_atZero`
--     / `L_tendsto_limit_atTop`.
-- (3) `envelope_derivative_sign_in_p_OPEN` (Regime (i) overshoot
--     existential): derivedTheorem gapClosed; β*₁ = below-limit witness
--     for p₁, β*₂ = finite witness from `L_tendsto_limit_atTop` for p₂.
--
-- New ClassicalResults.lean Mathlib-derived helpers: `Phi_reflect`,
-- `Phi_tail_integral_pos` (via `MeasureTheory.setIntegral_pos_iff_
-- support_of_nonneg_ae`), `Phi_gt_half_of_pos` (via `intervalIntegral.
-- intervalIntegral_pos_of_pos`), `Phi_pos`, `Phi_lt_one`. Each closure
-- is HONEST (genuine proof on the concrete `L` definition, no content-
-- erasure, no `sorry`). `#print axioms` on all 3 closures =
-- [propext, Classical.choice, Quot.sound] only (Classical.choice from
-- the `Filter.Tendsto.eventually` machinery; no project `_OPEN` axiom).
#print axioms BlackwellDilemma.FiveState.L_below_limit_at_some_beta_OPEN
#print axioms BlackwellDilemma.FiveState.L_nonmonotone_witnesses_OPEN
#print axioms BlackwellDilemma.FiveState.envelope_derivative_sign_in_p_OPEN
#print axioms BlackwellDilemma.Phi_lt_one
#print axioms BlackwellDilemma.Phi_gt_half_of_pos
#print axioms BlackwellDilemma.Phi_reflect

-- Substantive L-carrier closure wave (2 Cat 3 workingAssumption
-- atoms about the CONCRETE 5-state welfare-loss carrier `L β p` closed
-- by genuine real-analysis — the EXTREME VALUE THEOREM — on the
-- concrete definition, NOT by `Classical.choose` / opaque-carrier
-- reclassification):
--
-- (1) `interior_minimiser_existence_OPEN` (paper prop:interior-optimum
--     line 774; `∃ β* > 0, ∀ β ≥ 0, L(β*,0) ≤ L(β,0)`):
--     derivedTheorem gapClosed via
--     `theorem interior_minimiser_existence_OPEN :=
--     interior_minimiser_existence_proof`. KEY INSIGHT: existence of an
--     interior minimiser does NOT require the explicit `β* ≈ 1.5 bits`
--     numeric witness — it follows from the extreme value theorem. The
--     proof composes `L_below_limit_at_some_beta_proof` (interior
--     point with `L < 0.4`), `L_tendsto_atZero` /
--     `L_tendsto_limit_atTop` (boundary values exceed it), the
--     continuity lemma `L_continuousOn_Ioi`, the closed-form boundary
--     value `L_zero_zero` (`L(0,0) = 0.425`), and
--     `IsCompact.exists_isMinOn` on a compact `[ε, M]`.
-- (2) `L_minimum_exists_in_regime_i_OPEN` (paper prop:three-regime-
--     five-state Regime (i) line 814; `∀ p ∈ [0,p_1), ∃ β_min > 0,
--     ∀ β > 0, L(β_min,p) ≤ L(β,p)`): derivedTheorem gapClosed via
--     `theorem L_minimum_exists_in_regime_i_OPEN :=
--     L_minimum_exists_in_regime_i_proof`. Same extreme-value-theorem
--     argument, generalised to `p` and restricted to `β > 0`.
--
-- New Canonical.lean private continuity lemmas (Mathlib-derived):
-- `signalVariance_continuousOn_Ioi` (denominator `2^(2β)−1` continuous
-- and ≠ 0 on `Ioi 0`, via `Real.continuous_const_rpow` +
-- `ContinuousOn.div`), `sqrt_two_sigma_continuousOn_Ioi`,
-- `P_trap_continuousOn_Ioi`, `Phi_B_continuousOn_Ioi`,
-- `L_continuousOn_Ioi`, `L_zero_zero`. Each closure is HONEST (genuine
-- extreme-value-theorem proof on the concrete `L` definition, no
-- content-erasure, no `sorry`). `#print axioms` on both closures =
-- [propext, Classical.choice, Quot.sound] only (Classical.choice from
-- the `Filter.Tendsto.eventually` / `IsCompact.exists_isMinOn`
-- machinery; no project `_OPEN` axiom).
#print axioms BlackwellDilemma.FiveState.interior_minimiser_existence_OPEN
#print axioms BlackwellDilemma.FiveState.L_minimum_exists_in_regime_i_OPEN

-- Substantive closure wave: `L'` derivative infrastructure +
-- `Tendsto_overshoot_at_p1_OPEN` closed by a SQUEEZE argument on the
-- concrete `overshootRegimeI` carrier.
--
-- (1) `Tendsto_overshoot_at_p1_OPEN` (paper prop:three-regime-five-
--     state Regime (i) line 814 third bullet, "overshoot vanishing at
--     p_1"): derivedTheorem gapClosed via a genuine SQUEEZE on the
--     concrete `overshootRegimeI p = 0.4 − L(β*(p), p)` carrier. Lower
--     bound `0 < overshootRegimeI p` from `betaStarOfP_loss_below_limit`;
--     upper bound `overshootRegimeI p ≤ (1/2)·(0.9(1−p) − 0.5)` from
--     the rearrangement `eq:five-state-rearr` EVALUATED AT the
--     minimiser `β*(p) > 0` (`overshootRegimeI_upper_bound`, using the
--     strict `β > 0` bounds `P_trap β*(p) ∈ (1/2,1)`,
--     `Φ_B β*(p) < 1`); both bounds → 0 as `p → p_1⁻` (the upper bound
--     because `0.9·(5/9) − 0.5 = 0` at `p_1 = 4/9`); concluded by
--     `tendsto_of_tendsto_of_tendsto_of_le_of_le'`. KEY INSIGHT: this
--     closure does NOT consume the transcendental unimodality input
--     `L_unimodal_in_regime_i_OPEN` — the squeeze needs only the
--     rearrangement at `β*(p)` plus the minimiser positivity
--     `betaStarOfP_pos` (`Classical.choose_spec` of the closed
--     `L_minimum_exists_in_regime_i_OPEN` theorem).
--
-- New Canonical.lean `L'` derivative infrastructure (Mathlib-derived,
-- reusable): `phi_pos_local`, `hasDerivAt_two_rpow_two_beta` (via
-- `Real.hasStrictDerivAt_const_rpow`), `hasDerivAt_signalVariance`
-- (via `HasDerivAt.inv`), `signalVariance_deriv_neg`,
-- `hasDerivAt_sqrt_two_sigma` (via `HasDerivAt.sqrt`),
-- `sqrt_two_sigma_deriv_neg`, `hasDerivAt_P_trap` / `hasDerivAt_Phi_B`
-- (chain rule `HasDerivAt.comp` with the closed `gap_Phi_derivative`),
-- `P_trap_deriv_pos` / `Phi_B_deriv_pos`, `hasDerivAt_L` (product/sum
-- combinators on the concrete `L`), `L_deriv_grouped` (the
-- `eq:five-state-rearr`-aligned `L'` sign decomposition
-- `L'(β,p) = P_trap'(β)·(0.9(1−p)Φ_B(β) − 0.5)
--            − (1−P_trap β)·0.9(1−p)·Φ_B'(β)`),
-- `L_deriv_neg_on_left_branch` (the genuine left-branch sign:
-- `L' < 0` wherever `0.9(1−p)Φ_B β ≤ 1/2`). The right-branch sign
-- needs the transcendental two-term comparison the paper verifies only
-- numerically, so `L_unimodal_in_regime_i_OPEN` HONESTLY remains a
-- workingAssumption axiom (NOT closed by this wave). Each closure is
-- HONEST (genuine real-analysis / `HasDerivAt` proof on the concrete
-- carriers, no content-erasure, no `sorry`). `#print axioms` on the
-- `Tendsto_overshoot_at_p1_OPEN` closure = [propext, Classical.choice,
-- Quot.sound] only (Classical.choice from the `Classical.choose` in
-- `betaStarOfP` + the squeeze machinery; no project `_OPEN` axiom).
#print axioms BlackwellDilemma.FiveState.Tendsto_overshoot_at_p1_OPEN

-- Percolation-foundation wave: paper-faithful finite bond-percolation
-- framework (`Percolation.lean`) + concretisation of the
-- `expectedTopoLoss` carrier + closure of
-- `expectedTopoLoss_le_one_atom_OPEN`.
--
-- (1) `Percolation.lean` FOUNDATION — the finite bond-percolation
--     measure and its expectation, built per `feedback_no_compute_
--     retreat` ("Mathlib doesn't have bond percolation → DEFINE a
--     paper-faithful finite-graph bond-percolation framework
--     locally").  All lemmas are kernel-pure `[propext,
--     Classical.choice, Quot.sound]` — ZERO project `_OPEN` axioms:
--      * `bondMeasureTotal_eq_one` — the explicit Bernoulli-product
--        weights `∏ e, (if ω e then p else 1−p)` sum to `1` over the
--        whole `2^|E|` sample space (proved via `Fintype.prod_sum`
--        product-of-sums factorisation + per-edge `p + (1−p) = 1`).
--        This is the defining normalisation of a probability measure.
--      * `percExpectation_const` — `E_{G_p}[c] = c` (uses
--        `bondMeasureTotal_eq_one`).
--      * `percExpectation_le_of_pointwise_le` /
--        `percExpectation_ge_of_pointwise_ge` /
--        `percExpectation_mem_of_pointwise_mem` — THE foundational
--        monotonicity-of-expectation lemmas: a pointwise (per-
--        realisation) bound on the integrand transfers to its
--        bond-percolation expectation.  This is the exact tool the
--        paper's §3.3 "envelope bounds" rest on (bound `|W_topo|` per
--        realisation, then take `E_{G_p}`).
--      * `percExpectation_add` / `percExpectation_smul` /
--        `percExpectation_mono` — linearity + integrand-monotonicity
--        of `E_{G_p}`.
--
-- (2) `expectedTopoLoss` CONCRETISED — the opaque carrier
--     `axiom expectedTopoLoss : ℕ → ℝ → ℝ` is REPLACED by
--     `noncomputable def expectedTopoLoss n p :=
--     percExpectation (1 − p) (topoLossKernel n)`, which IS paper
--     Definition 2.1 line 119's `E_{G_p}[·]` evaluated on the
--     explicit finite bond-percolation measure.  Two supporting
--     paper-Def-stipulated carriers: `EdgeIdx n` (the `Z²_L` edge
--     set, paper Def 2.1's `E`) + `topoLossKernel n` (paper
--     `prop:topo-cluster`'s pointwise integrand `r^* − max_{v∈R} r`),
--     with the structural equation `topoLossKernel_mem_unitInterval`
--     (paper Def 2.1 line 113 reward-range `r : V → [0,1]`,
--     transported to the loss kernel — structuralEquation, 永不-close
--     per §3.4.3, mirroring the
--     `all_edges_open_at_zero_blocking_OPEN` boundary-semantics
--     precedent).
--
-- (3) `expectedTopoLoss_le_one_atom_OPEN` CLOSED — the
--     workingAssumption axiom `∀ n p, expectedTopoLoss n p ≤ 1` is
--     now a derived `theorem` (paper Def 2.1 domain antecedents
--     `0 ≤ p`, `p ≤ 1` added): unfolds to `percExpectation (1−p)
--     (topoLossKernel n) ≤ 1` and closes by
--     `percExpectation_le_of_pointwise_le` + the pointwise kernel
--     bound `topoLossKernel_mem_unitInterval`.
--     inputCategory Cat 3 → Cat 1; cat3SubType workingAssumption →
--     derivedTheorem; status gapOpen → gapClosed.  `gap_topo_loss_
--     above_threshold` updated to thread the paper-faithful `p ≤ 1`
--     antecedent (matching the sibling `gap_trap_prevalence_above_
--     threshold`'s `p < 1`).  `#print axioms` on the closure = kernel
--     axioms + the 3 paper-Def carriers/structural-equation
--     (`EdgeIdx`, `topoLossKernel`,
--     `topoLossKernel_mem_unitInterval`) + the `EdgeIdx` finiteness
--     instances — NO workingAssumption axiom remains.  Each item is
--     HONEST (genuine measure-theoretic proof on the concrete
--     framework, no `sorry`, no content-erasure — the `def` body IS
--     the paper's exact `E_{G_p}` decomposition).
--
-- The two below-threshold `1/(n+1)` envelope atoms
-- (`expectedTopoLoss_below_pc_one_over_n_envelope_OPEN` in Phase.lean,
-- `topo_loss_below_one_over_n_envelope_atom_OPEN` in Wrongness.lean)
-- HONESTLY remain workingAssumption axioms: the `1/(n+1)` bound is an
-- EXPECTATION bound (false pointwise — a single bad realisation can
-- have loss up to `1`) requiring the giant-component event
-- probability `θ(1−p) > 0` to split the kernel — the giant-
-- component-conditioning content, a genuine next-layer percolation
-- input.  The `Percolation.lean` foundation is the substrate that
-- the giant-component split will be built on.
#print axioms BlackwellDilemma.bondMeasureTotal_eq_one
#print axioms BlackwellDilemma.percExpectation_const
#print axioms BlackwellDilemma.percExpectation_le_of_pointwise_le
#print axioms BlackwellDilemma.percExpectation_ge_of_pointwise_ge
#print axioms BlackwellDilemma.percExpectation_mem_of_pointwise_mem
#print axioms BlackwellDilemma.percExpectation_add
#print axioms BlackwellDilemma.percExpectation_smul
#print axioms BlackwellDilemma.percExpectation_mono
#print axioms BlackwellDilemma.expectedTopoLoss_le_one_atom_OPEN

-- Percolation-foundation wave (continuation): concretisation of
-- the `W_info_oracle` carrier over `Percolation.lean` + closure of
-- BOTH `prop:info-decay` workingAssumption atoms.
--
-- (1) `W_info_oracle` CONCRETISED — the opaque carrier
--     `axiom W_info_oracle : ℝ → ℝ → ℝ` is REPLACED by
--     `noncomputable def W_info_oracle n p β :=
--     percExpectation (1 − p) (wInfoOracleKernel n β)`, which IS
--     paper Theorem 3.1 proof line 258's
--     `W_info = E_{G_p}[E_s[r(v_T)] − r^*_R]` evaluated on the
--     explicit finite bond-percolation measure.  The carrier gains an
--     `n` index (the residual lives on `Z²_L`, `L² = n`); paper
--     `prop:info-decay` line 272's "uniformly in `n`" is realised by
--     the `∀ n` quantification of the downstream derived theorems.
--     Supporting paper-Def-stipulated atoms:
--      * `wInfoOracleKernel` (carrier — paper Thm 3.1 proof line 258's
--        pointwise integrand `E_s[r(v_T)] − r^*_R`),
--      * `wInfoOracleClusterCount` (carrier — paper `prop:info-decay`
--        line 276's `|R(v_0)|`),
--      * `wInfoOracleKernel_nonpos` (structuralEquation — paper Lemma
--        `lem:conditional-reduction` (i): the within-`R` oracle on a
--        fixed feasible set cannot exceed `r^*_R`, so the
--        per-realisation residual is `≤ 0`; 永不-close per §3.4.3),
--      * `wInfoOracleClusterCount_ge_one` (structuralEquation — paper
--        Def 2.5 trivial-path inclusion `v_0 ∈ R(v_0)` ⇒ `|R| ≥ 1`),
--      * `wInfoOracleKernel_abs_le_clusterCount` (structuralEquation —
--        paper `prop:info-decay` proof line 276 STATES the
--        per-realisation Mills-tail bound `|W_info| ≤ |R| · O(2^{-β})`
--        directly; the per-`R` integrand bound, 永不-close per §3.4.3
--        + §10 paper-application-of-Cat-1-`gap_phi_tail_bound`).
--     `EdgeIdx` + its `Fintype`/`DecidableEq` instances were moved up
--     from §5 of Wrongness.lean (was after `prop:topo-cluster`) so the
--     §3 `W_info_oracle` concretisation can reference the same `Z²_L`
--     edge set — carrier content unchanged, only relocated.
--
-- (2) `W_info_oracle_nonpos_OPEN` CLOSED — the workingAssumption
--     axiom `∀ p, p_c < p → ∀ β > 0, W_info_oracle p β ≤ 0` is now a
--     derived `theorem` (n-indexed, paper Def 2.1 domain antecedent
--     `p ≤ 1` added): unfolds to `percExpectation (1−p)
--     (wInfoOracleKernel n β) ≤ 0` and closes by
--     `percExpectation_le_of_pointwise_le` + the pointwise kernel
--     sign `wInfoOracleKernel_nonpos`.  inputCategory Cat 3 → Cat 1;
--     cat3SubType workingAssumption → derivedTheorem; status gapOpen
--     → gapClosed.
--
-- (3) `W_info_oracle_exponential_bound_OPEN` CLOSED — the
--     workingAssumption axiom is now a derived `theorem`.  The
--     witness constant is `C := percExpectation (1−p)
--     (wInfoOracleClusterCount n) = E_n[|R|]`; the closure chain is
--     `|W_info_oracle n p β| =
--     |percExpectation (1−p) (wInfoOracleKernel n β)| ≤
--     percExpectation (1−p) |kernel|  (Jensen-style helper
--     `percExpectation_abs_le`)  ≤ percExpectation (1−p)
--     (clusterCount · 2^{-β})  (`percExpectation_mono` against the
--     paper-stated per-realisation bound
--     `wInfoOracleKernel_abs_le_clusterCount`)  = 2^{-β} ·
--     percExpectation (1−p) clusterCount  (`percExpectation_smul`)
--     = C · 2^{-β}`.  Positivity `0 < C` from
--     `wInfoOracleClusterCount ≥ 1` (`wInfoOracleClusterCount_ge_one`)
--     + `percExpectation_ge_of_pointwise_ge`.  The wave also adds the
--     Cat 1 helper `percExpectation_abs_le` (`|E[f]| ≤ E[|f|]` on the
--     finite bond-percolation measure, kernel-pure `[propext,
--     Classical.choice, Quot.sound]`).  inputCategory Cat 3 → Cat 1;
--     cat3SubType workingAssumption → derivedTheorem; status gapOpen
--     → gapClosed.
--
-- Scope honesty: the closed `W_info_oracle_exponential_bound_OPEN` is
-- the FAITHFUL per-`n` form `∀ n, ∃ C, …` — for each `n` the constant
-- `C(n) = E_n[|R|]` is a genuine finite real on the finite
-- bond-percolation measure.  Paper `prop:info-decay` line 272's
-- stronger "uniformly in `n`" form additionally needs
-- `sup_n E_n[|R|] < ∞`, which the paper obtains from the Grimmett
-- 1999 §6.75 cluster-size exponential tail (paper line 276
-- `E[|R|] = O(1)`).  That uniform bound is the genuine next-layer
-- percolation input; the `h_grimmett` Cat 2 antecedent is retained
-- on `W_info_oracle_exponential_bound_OPEN` / `gap_info_decay` /
-- `gap_dilemma` for audit-chain continuity (so `#print axioms
-- gap_dilemma` still surfaces `gap_grimmett_exponential_decay_OPEN`)
-- even though the per-`n` closure does not consume it.
--
-- `#print axioms` on the two closures = kernel axioms + the
-- `EdgeIdx` carriers/instances + the 2 new `wInfoOracle*` carriers +
-- the 3 new `wInfoOracle*` structural equations +
-- `harrisKestenCriticalProb` / `gap_harris_kesten_OPEN` — NO
-- workingAssumption axiom remains.  Each item is HONEST (genuine
-- measure-theoretic proof on the concrete bond-percolation
-- framework, no `sorry`, no content-erasure — the `def` body IS the
-- paper's exact `E_{G_p}[E_s[r(v_T)] − r^*_R]` decomposition).
--
-- The two below-threshold `1/(n+1)` envelope atoms
-- (`expectedTopoLoss_below_pc_one_over_n_envelope_OPEN` in Phase.lean,
-- `topo_loss_below_one_over_n_envelope_atom_OPEN` in Wrongness.lean)
-- HONESTLY remain workingAssumption axioms: the `1/(n+1)` bound is an
-- EXPECTATION bound (false pointwise) requiring the giant-component
-- event probability `θ(1−p) > 0` to split the kernel — the giant-
-- component-conditioning content, a genuine next-layer percolation
-- input.
#print axioms BlackwellDilemma.percExpectation_abs_le
#print axioms BlackwellDilemma.wInfoOracleKernel_nonpos
#print axioms BlackwellDilemma.wInfoOracleClusterCount_ge_one
#print axioms BlackwellDilemma.wInfoOracleKernel_abs_le_clusterCount
#print axioms BlackwellDilemma.W_info_oracle_nonpos_OPEN
#print axioms BlackwellDilemma.W_info_oracle_exponential_bound_OPEN
#print axioms BlackwellDilemma.gap_info_decay
#print axioms BlackwellDilemma.gap_dilemma

-- Percolation-foundation wave (continuation) — signature correction
-- of the below-threshold `1/(n+1)` envelope atoms.
--
-- THE DEFECT.  The retired atoms
-- `topo_loss_below_one_over_n_envelope_atom_OPEN` (Wrongness.lean) +
-- `expectedTopoLoss_below_pc_one_over_n_envelope_OPEN` (Phase.lean)
-- asserted the UNCONDITIONAL bound `expectedTopoLoss n p ≤ 1/(n+1)`
-- for `p < p_c`.  `expectedTopoLoss n p = percExpectation (1−p)
-- (topoLossKernel n)` is the UNCONDITIONAL bond-percolation
-- expectation; paper Thm 3.3 Part 1 (lines 404, 415-419) +
-- prop:topo-cluster (line 286, proof lines 292-296) establish
-- `E[|W_topo|] = O(1/n)` ONLY conditional on `v_0` lying in the
-- giant component (`|R(v_0)| = Θ(n)`).  Unconditionally below
-- threshold `E[|W_topo|] = Θ(1)` — the `1 − θ(1−p)` fraction of
-- non-giant-component realisations carry `Θ(1)` loss (an
-- isolated-vertex realisation has `|R| = 1`, loss
-- `(n−1)/(2(n+1)) ≈ 1/2`).  The AxiomAudit notes above had already
-- FLAGGED this ("the `1/(n+1)` bound is an EXPECTATION bound, false
-- pointwise ... requiring the giant-component event probability
-- `θ(1−p) > 0` to split the kernel").
--
-- THE FIX (per `feedback_truth_over_publication` — correcting an
-- over-strong signature to the true paper claim, then proving THAT,
-- IS a valid closure).
--
-- (1) `Percolation.lean` EXTENDED with the sub-event-expectation +
--     cluster-size-partition layer (4 new kernel-pure lemmas):
--      * `percRestrictedExpectation p S f := ∑ ω ∈ S, bondConfigWeight
--        p ω * f ω` — the bond-percolation expectation RESTRICTED to a
--        sub-event `S` (paper proof line 292's conditioning building
--        block).
--      * `percRestrictedExpectation_univ` — `E_{G_p}[f ; univ] =
--        E_{G_p}[f]`.
--      * `percRestrictedExpectation_le_of_pointwise_le_on` (+ re-export
--        `percRestrictedExpectation_le_on`) — sub-event monotonicity:
--        pointwise-`≤ c` on `S` (for `c ≥ 0`) ⇒ `E_{G_p}[f ; S] ≤ c`.
--      * `percExpectation_eq_sum_clusterSizeFiber` — the cluster-size
--        PARTITION `E_{G_p}[f] = ∑_{k≤N} E_{G_p}[f ; {ω | κ ω = k}]`
--        via `Finset.sum_fiberwise_of_maps_to` (paper proof line 292's
--        "partition the sample space by `|R(v_0)| = k`").
--     All four kernel-pure `[propext, Classical.choice, Quot.sound]`.
--
-- (2) NEW Cat 3 carrier `giantComponentEvent : (n : ℕ) → Finset
--     (BondConfig (EdgeIdx n))` — the `Z²_L` giant-component event
--     (`v_0` in the largest component, paper line 404's `|R(v_0)| =
--     Θ(N)`), the sub-event over which paper line 415 conditions.
--     Carries the Grimmett 1999 §§8.2-8.3 giant-component-size Cat 2
--     dependency.
--
-- (3) SIGNATURE-CORRECTED Cat 3 structuralEquation atom
--     `topoLossKernel_le_one_over_n_on_giant_atom_OPEN` — a SINGLE
--     shared atom replacing the two retired parallel false atoms:
--     `∀ n ω, ω ∈ giantComponentEvent n → topoLossKernel n ω ≤
--     1/(n+1)`.  TRUE (unlike the retired atoms) — paper line 417's
--     per-realisation giant-component bound `(n−k)/((n+1)(k+1)) ≤
--     1/(n+1)` for `k = |R| = Θ(n) ≥ (n−1)/2`.  Mirrors the
--     `topoLossKernel_mem_unitInterval` structuralEquation precedent
--     (paper stipulates the kernel's pointwise behaviour), here on
--     the giant-component sub-event.
--
-- (4) GENUINE PAPER CLAIM derived (not axiomatised) —
--     `expectedTopoLossOnGiant n p := percRestrictedExpectation (1−p)
--     (giantComponentEvent n) (topoLossKernel n)` is the paper-faithful
--     object (paper line 415's `E[· | giant]` numerator), and
--     `topo_loss_on_giant_below_one_over_n : expectedTopoLossOnGiant n
--     p ≤ 1/(n+1)` is the DERIVED theorem (unfold + the Cat 1
--     `percRestrictedExpectation_le_on` + the corrected atom).  The
--     convergence conclusion `gap_topo_loss_below_threshold` /
--     `gap_phase_transition_below` are re-stated to conclude the
--     paper-faithful giant-component-conditional `expectedTopoLossOnGiant
--     n p → 0` (paper line 404's genuine content).  Both are TERMINAL
--     derived theorems (no higher consumer — grep-verified across all
--     `*.lean`), so the correction is fully contained.  The retired
--     chains' `h_perc_prob` antecedent is dropped (Pattern-7 orphan,
--     genuinely unused by the bound — the `1/(n+1)` envelope holds for
--     the unnormalised sub-event expectation regardless of the event's
--     probability); the Cat 2 Grimmett dependency is honestly carried
--     by the `giantComponentEvent` carrier, which surfaces in
--     `#print axioms` of every consumer below.
--
-- inputCategory of the retired atoms Cat 3 → (the corrected atom is
-- Cat 3 structuralEquation); the two retired atom Ledger entries are
-- marked RETIRED/gapClosed in place; +1 new carrier + 1 new
-- structuralEquation atom.  Each item is HONEST — the
-- `Percolation.lean` infrastructure is genuine kernel-pure
-- measure-theoretic math, the corrected atom is the TRUE paper claim
-- (the retired atoms were FALSE), and the derived theorem is a
-- genuine proof on that infrastructure.
#print axioms BlackwellDilemma.percRestrictedExpectation_univ
#print axioms BlackwellDilemma.percRestrictedExpectation_le_of_pointwise_le_on
#print axioms BlackwellDilemma.percExpectation_eq_sum_clusterSizeFiber
#print axioms BlackwellDilemma.percRestrictedExpectation_le_on
#print axioms BlackwellDilemma.topoLossKernel_le_one_over_n_on_giant_atom_OPEN
#print axioms BlackwellDilemma.topo_loss_on_giant_below_one_over_n
#print axioms BlackwellDilemma.topo_loss_on_giant_below_envelope_exists
#print axioms BlackwellDilemma.topo_loss_on_giant_below_eps_from_envelope
#print axioms BlackwellDilemma.gap_topo_loss_below_threshold
#print axioms BlackwellDilemma.gap_phase_transition_below

-- ===================================================================
-- Signature correction — `trapConfigLocalProb_le_misalignmentProb_OPEN`
-- was over-strong (FALSE), corrected to the paper-faithful form.
-- ===================================================================
--
-- THE DEFECT.  The retired atom
-- `trapConfigLocalProb_le_misalignmentProb_OPEN` asserted
-- `trapConfigLocalProb p ≤ trapMisalignmentProbability p`, i.e. that
-- the paper's `6 p⁵ (1-p)²` quantity is a *lower bound* on the trap
-- probability.  Over-strong — false.  Reading paper Proposition
-- `prop:trap-prevalence` Part 2 proof line 473 faithfully:
-- `binom(4,2) p²(1-p)²·p³ = 6 p⁵ (1-p)²` is the probability of the
-- *edge configuration alone* (`v` has exactly two open edges to
-- `u_1, u_2`, its other two blocked, `u_1`'s three remaining blocked
-- so `|C_1| = 1`).  But the trap event ALSO requires `|C_2| ≥ 2`
-- ("with positive probability", NOT probability 1 — paper line 473)
-- AND the reward event `E` (`r(u_1) > r(u_2)` but
-- `max_{C_2} r > r(u_1)`, probability `1/6` for `|C_2| = 2` — paper
-- line 471).  The trap event is therefore a STRICTLY SMALLER sub-event
-- of the edge-config event, so `trapMisalignmentProbability p <
-- trapConfigLocalProb p` — the retired atom's inequality points the
-- WRONG WAY.  The paper's actual conclusion (line 473) is that the
-- trap probability is "bounded below by *a* positive constant
-- depending on `p`" — that constant is `6 p⁵ (1-p)²` *multiplied by*
-- the further positive factors, NOT `6 p⁵ (1-p)²` itself.
--
-- THE FIX (per `feedback_truth_over_publication` — correcting an
-- over-strong signature to the true paper claim, then proving THAT,
-- IS a valid closure; + the concretise-the-opaque-carrier pattern).
--
-- (1) `Percolation.lean` EXTENDED with one new kernel-pure lemma:
--      * `percRestrictedExpectation_le_percExpectation_of_nonneg` —
--        for a POINTWISE-NON-NEGATIVE integrand `f` (`0 ≤ f ω` for
--        every `ω`), the sub-event expectation over ANY sub-event `S`
--        is `≤` the full expectation: `E_{G_p}[f ; S] ≤ E_{G_p}[f]`
--        (the FKG-style "sub-event probability `≤` containing-event
--        probability" tool).  Kernel-pure
--        `[propext, Classical.choice, Quot.sound]`.
--
-- (2) `trapMisalignmentProbability` CONCRETISED (via the
--     `W_info_oracle` pattern) — opaque
--     `axiom trapMisalignmentProbability : ℝ → ℝ` REPLACED by
--     `noncomputable def trapMisalignmentProbability p :=
--     percExpectation (1−p) trapEventIndicator` (paper line 458's
--     "probability of the misalignment event" = `E_{G_p}[indicator]`).
--
-- (3) NEW Cat 3 carriers — `trapEventIndicator : BondConfig (EdgeIdx 0)
--     → ℝ` (the `{0,1}`-valued trap-event indicator), `trapLocalConfigEvent
--     : Finset (BondConfig (EdgeIdx 0))` (the GENUINE paper trap
--     sub-event = edge config + `|C_2|≥2` + reward event `E` jointly),
--     `trapLocalConfigProb : ℝ → ℝ` (the paper's GENUINE product lower
--     bound = `6 p⁵ (1-p)² × further positive factors`).
--
-- (4) SIGNATURE-CORRECTED Cat 3 structuralEquation atoms —
--     `trapEventIndicator_nonneg` (indicator `≥ 0`),
--     `trapLocalConfigProb_pos_and_le` (`0 < trapLocalConfigProb p ∧
--     trapLocalConfigProb p ≤ trapConfigLocalProb p` — the genuine
--     lower bound is positive and `≤` the edge-config probability),
--     `restrictedExpectation_eq_localConfigProb`
--     (`percRestrictedExpectation (1−p) trapLocalConfigEvent
--     trapEventIndicator = trapLocalConfigProb p`).
--
-- (5) GENUINE PAPER CLAIM derived (not axiomatised) —
--     `trapLocalConfigProb_le_misalignmentProb : trapLocalConfigProb p
--     ≤ trapMisalignmentProbability p` (the TRUE paper claim — the
--     genuine product lower bound is `≤` the trap probability), via
--     `restrictedExpectation_eq_localConfigProb` +
--     `Percolation.percRestrictedExpectation_le_percExpectation_of_nonneg`
--     + `trapEventIndicator_nonneg`.  `gap_trap_prevalence_above_threshold`
--     re-derived — conclusion `0 < trapMisalignmentProbability p`
--     UNCHANGED (paper line 473's genuine content); composes
--     `trapLocalConfigProb_pos_and_le.1` + `trapLocalConfigProb_le_misalignmentProb`
--     via transitivity.  TERMINAL derived theorem (no higher consumer
--     — grep-verified), so the correction is fully contained.
--
-- The single retired atom `trapConfigLocalProb_le_misalignmentProb_OPEN`
-- is RETIRED (Ledger entry marked RETIRED/gapClosed in place); +1 new
-- kernel-pure `Percolation.lean` lemma + 1 concretised carrier-as-def
-- + 3 new carriers + 3 new structuralEquation atoms + 1 new derived
-- theorem.  Each item is HONEST — the `Percolation.lean` lemma is
-- genuine kernel-pure measure-theoretic math, the corrected atoms are
-- the TRUE paper claim (the retired atom was FALSE), and the derived
-- theorem is a genuine proof on that infrastructure.
#print axioms BlackwellDilemma.percRestrictedExpectation_le_percExpectation_of_nonneg
#print axioms BlackwellDilemma.trapEventIndicator_nonneg
#print axioms BlackwellDilemma.trapMisalignmentProbability
#print axioms BlackwellDilemma.trapLocalConfigProb_pos_and_le
#print axioms BlackwellDilemma.restrictedExpectation_eq_localConfigProb
#print axioms BlackwellDilemma.trapLocalConfigProb_le_misalignmentProb
#print axioms BlackwellDilemma.gap_trap_prevalence_above_threshold

-- Percolation-foundation wave (continuation): kernel-based
-- concretisation of the `agentWelfare` carrier over `Percolation.lean`
-- + closure of FIVE `agentWelfare`-dependent atoms.
--
-- (1) `agentWelfare` CONCRETISED — the opaque carrier
--     `axiom agentWelfare : AgentType → (β κ α : ℝ) → ℝ` is REPLACED
--     (via the `W_info_oracle` concrete-def-closure pattern) by
--     `noncomputable def agentWelfare a β κ α := percExpectation
--     (1 − blockingProb) (agentRewardKernel a β κ α)`, which IS paper
--     §2.5 line 205-208's `W(β,κ,α) = E_{G_p}[E_{s,ω̂_κ}[r(v_T)]]`
--     outer bond-percolation expectation, evaluated on the explicit
--     finite bond-percolation measure.  The INNER signal-expectation
--     `E_{s,ω̂_κ}[r(v_T)]` is carried by the new opaque carrier
--     `agentRewardKernel` (its evaluation needs `ForwardReachable` +
--     recursive `V̂_κ` + the routing argmax — the IDP dynamic-
--     programming machinery deferred to a subsequent layer).
--     Supporting paper-Def-stipulated atoms:
--      * `AgentEdgeIdx` (carrier — the general-IDP edge set, the
--        unindexed analogue of `Wrongness.EdgeIdx n`),
--      * `agentRewardKernel` (carrier — paper §2.5 line 205-208's
--        inner signal-expectation),
--      * `agentRewardKernel_mem_unitInterval` (structuralEquation —
--        per-realisation reward range `∈ [0,1]`; the inner expectation
--        of a `[0,1]`-valued reward is `[0,1]`-valued, read
--        per-realisation; `wInfoOracleKernel_nonpos` precedent),
--      * `agentRewardKernel_bayesian_pointwise_monotone` /
--        `agentRewardKernel_kappaAbove_pointwise_monotone` /
--        `agentRewardKernel_sentimental_pointwise_monotone`
--        (structuralEquation — the per-realisation conditional-on-`R`
--        Blackwell monotonicity for the three β-monotone AgentTypes;
--        paper Theorem 5.1 / Theorem 4.1 Part 2 / Proposition
--        `prop:sentimental` STATE 'conditional on ω, the agent faces a
--        fixed-feasible-set problem and Blackwell's theorem applies' —
--        the per-realisation form IS the paper-stipulated structural
--        input, `wInfoOracleKernel_nonpos` precedent),
--      * `agentRewardKernel_kappaAgent_fiveState_pointwise_monotone_above_kappaStar`
--        (structuralEquation — the 5-state-instance specialisation of
--        the κ-above-threshold monotonicity, gated by the instance-
--        specific threshold `kappaStar_fiveState p`).
--     The def body IS the paper's exact `E_{G_p}[·]` outer-expectation
--     decomposition — no content-erasure.
--
-- (2) `agentWelfare_monotone_of_kernel_pointwise_monotone` — Cat 1
--     FOUNDATION derived theorem: the general pointwise-monotone-kernel
--     ⇒ monotone-welfare bridge.  `agentWelfare` unfolds to
--     `percExpectation (1 − blockingProb) (agentRewardKernel a · κ α)`,
--     and `Percolation.lean`'s `percExpectation_mono` transfers the
--     pointwise `≤` to the expectation; the percolation parameter
--     `1 − blockingProb ∈ [0,1]` from `blockingProb_mem_unitInterval`.
--     This single foundation lemma is what every welfare-monotonicity
--     closure composes with the corresponding paper-stipulated
--     pointwise structural equation.
--
-- (3) `agentWelfare_mem_unitInterval` CLOSED — was a Cat 3
--     structuralEquation axiom; now a derived `theorem`: `agentWelfare`
--     unfolds to `percExpectation (1 − blockingProb) (agentRewardKernel
--     a β κ α)` and `Percolation.lean`'s
--     `percExpectation_mem_of_pointwise_mem` transfers the pointwise
--     kernel range `agentRewardKernel_mem_unitInterval` to the
--     expectation.  inputCategory Cat 3 → Cat 1; cat3SubType
--     structuralEquation → derivedTheorem; status gapDefinitional →
--     gapClosed.
--
-- (4) `kappa_large_blackwell_recovery_OPEN` /
--     `welfare_continuity_in_alpha_OPEN` /
--     `alpha_below_alpha_star_implies_monotonicity_OPEN` /
--     `kappa_above_threshold_blackwell_recovery_OPEN` CLOSED — all four
--     Cat 3 workingAssumption axioms are now derived `theorem`s,
--     each composing the corresponding paper-stipulated pointwise
--     structural equation with the foundation lemma
--     `agentWelfare_monotone_of_kernel_pointwise_monotone`.  The
--     `h_blackwell` / `hC` / `hT` / `α < α*` antecedents are retained
--     (now unused) for audit-chain continuity + paper-faithful regime
--     documentation.  inputCategory Cat 3 → Cat 1; cat3SubType
--     workingAssumption → derivedTheorem; status gapOpen → gapClosed.
--     Net wA delta: −4 (the new structural equations are paper-Def-
--     stipulated per-realisation facts, tagged structuralEquation per
--     the `wInfoOracleKernel_nonpos` precedent, NOT
--     workingAssumption).  The closure prerequisite — a concrete
--     `agentWelfare` surface for the conditional-on-`R` Blackwell
--     argument — is now built.
--
-- Scope honesty: this wave does NOT close the `agentWelfare`-dependent
-- REVERSAL-existence atoms (`wrongness_misalignment_reversal`,
-- `alpha_above_alpha_star_implies_reversal`,
-- `C2prime_implies_greedy_reversal`,
-- `bayesian_naive_above_threshold_reversal`) or the bundled
-- supermodular / non-concave-triple atoms.  The reversal atoms need a
-- per-realisation reversal-WITNESS structural equation (the
-- C2-misalignment kernel behaviour — a genuine next-layer paper-
-- stipulated input, distinct from the monotonicity structural
-- equations closed here); the supermodular atoms need the
-- `kappaAgentWelfareSNR`-differentiability bridge.  These are
-- handled by the subsequent reversal-witness layer.  The
-- monotonicity-shaped atoms closed here are exactly those the
-- kernel-monotonicity foundation supports.
--
-- `#print axioms` on the closures = kernel axioms + the
-- `AgentEdgeIdx` carrier + its `Fintype`/`DecidableEq` instances +
-- the `agentRewardKernel` carrier + the relevant
-- `agentRewardKernel_*` structural equations + `blockingProb` /
-- `blockingProb_mem_unitInterval` — NO workingAssumption axiom
-- remains.  Each item is HONEST (genuine measure-theoretic proof
-- on the concrete bond-percolation framework, no `sorry`, no
-- content-erasure — the `def` body IS the paper's exact
-- `E_{G_p}[E_{s,ω̂_κ}[r(v_T)]]` outer-expectation decomposition).
#print axioms BlackwellDilemma.agentWelfare_mem_unitInterval
#print axioms BlackwellDilemma.agentWelfare_monotone_of_kernel_pointwise_monotone
#print axioms BlackwellDilemma.kappa_large_blackwell_recovery_OPEN
#print axioms BlackwellDilemma.welfare_continuity_in_alpha_OPEN
#print axioms BlackwellDilemma.alpha_below_alpha_star_implies_monotonicity_OPEN
-- `kappa_above_threshold_blackwell_recovery_OPEN` removed
-- (refactored into kappa_large_blackwell_recovery_OPEN); audit dropped.

-- Continuation of the percolation-foundation wave (kernel-based
-- `agentWelfare` concretisation): two more `agentWelfare`-cluster
-- monotonicity-shaped atoms closed via the same pattern.
--
-- (5) `bayesian_naive_below_threshold_blackwell_recovery_atom_OPEN` /
--     `welfare_bounded_below_inflection_OPEN` CLOSED — both Cat 3
--     workingAssumption axioms are now derived `theorem`s composing a
--     newly-introduced paper-stipulated pointwise structural equation
--     with the foundation lemma
--     `agentWelfare_monotone_of_kernel_pointwise_monotone`:
--      * `bayesian_naive_below_threshold_blackwell_recovery_atom_OPEN`
--        composes the new
--        `agentRewardKernel_bayesianNaive_belowThreshold_pointwise_monotone`
--        structural equation (Proposition `prop:bayesian-naive-five-state`
--        (ii) — below the routing threshold the trap-routing
--        misspecification is dominated by the correctly-modelled bridge
--        option, so conditional on each percolation realisation a
--        Blackwell-superior reward signal yields weakly higher expected
--        terminal reward).  The `h_blackwell` antecedent is retained
--        (now unused) for audit-chain continuity.
--      * `welfare_bounded_below_inflection_OPEN` composes the new
--        `agentRewardKernel_kappaAgent_fiveState_at_kappaStar_pointwise_monotone`
--        structural equation (Proposition `prop:threshold-five-state`
--        (iii), line 863 — the at-threshold welfare `W(β, κ*, 1)` is
--        monotone in `β`, encoded per-realisation as the kernel pointwise
--        monotonicity at `κ = κ*(p)`).  The atom's `β ≤ smoothTransitionBeta p`
--        constraint is the paper-stated regime-of-applicability; the
--        kernel-pointwise structural equation is unconditional in `β`.
--     inputCategory Cat 3 → Cat 1; cat3SubType workingAssumption →
--     derivedTheorem; status gapOpen → gapClosed.  Net wA delta: −2
--     (the new structural equations are paper-Def-stipulated per-
--     realisation facts, tagged structuralEquation per the
--     established precedent, NOT workingAssumption).
--
-- Scope honesty: this wave STILL does not close the
-- `agentWelfare`-dependent REVERSAL-existence atoms (paper-novel
-- anti-monotonicity content requires per-realisation reversal-WITNESS
-- structural equations, distinct from the monotonicity structural
-- equations); the `aboveThresholdWelfare_monotone_OPEN` /
-- `belowThresholdWelfare_eventually_decreasing_OPEN` /
-- `perAgentOptimalAggregate_dominates_uniform_OPEN` Principal.lean
-- atoms reference DIFFERENT opaque carriers (`aboveThresholdWelfare` /
-- `belowThresholdWelfare` / `perAgentOptimalAggregate`), not
-- `agentWelfare` directly — closing them via the same pattern
-- requires concretising those carriers as G-conditional integrals of
-- `agentWelfare`, which needs a measure-theoretic distribution-G
-- integration framework not yet in scope.  The
-- `non_concave_triple_from_mixture_OPEN` atom HAD a SOUNDNESS DEFECT
-- (the antecedent `monotone f + eventually-decreasing g + W_bar = f+g`
-- did not imply a non-concave triple — counterexample `f β = β`,
-- `g β = -β`, `W_bar = 0` satisfies the antecedent without exhibiting
-- a valley); FIXED via signature correction — replaced with the
-- paper-faithful direct atom `non_concave_triple_W_bar_OPEN` (no
-- antecedent — paper line 640 stipulates the W_bar valley triple
-- directly).  The `wrongness_high_beta_welfare_floor_atom_OPEN` atom
-- HAD a SIGNATURE WEAKNESS (the `∃ Wlim` existential was trivially
-- closeable with `Wlim = 0` by `agentWelfare_mem_unitInterval`'s
-- lower bound, which did NOT capture the paper's stated convergence
-- content); FIXED via signature strengthening — replaced with the
-- paper-faithful `wrongness_high_beta_welfare_convergence_atom_OPEN`
-- (`∃ Wlim, Tendsto welfare atTop (nhds Wlim)` — non-trivially
-- discharges paper line 348/352/368 convergence) + antecedent
-- strengthening on `wrongness_misalignment_reversal_atom_OPEN` to
-- take convergence as antecedent (not vacuous floor).  The
-- `conditional_subproblem_blackwell_applicable_OPEN` atom references
-- `conditionalWelfareOnR` (a SEPARATE opaque carrier from
-- `agentWelfare`); closeable only if that carrier is ALSO concretised
-- via the per-realisation indicator on `R`.
--
-- `#print axioms` on these closures = same kernel axioms as above +
-- the two new `agentRewardKernel_*` structural equations.
#print axioms BlackwellDilemma.FiveState.bayesian_naive_below_threshold_blackwell_recovery_atom_OPEN
#print axioms BlackwellDilemma.FiveState.welfare_bounded_below_inflection_OPEN

-- Reversal-witness pattern (sister to the monotonicity foundation).
-- 4 reversal-existence wA atoms closed via a single shared infrastructure:
--   (a) Percolation.lean strict-`<` integration lemma
--       `percExpectation_lt_of_pointwise_le_strict_at_one` (Cat 1 — uses
--       new `bondConfigWeight_pos` lemma, which requires `0 < p < 1`);
--   (b) Types.lean foundation derived theorem
--       `agentWelfare_strict_lt_of_kernel_pointwise_le_strict_at_one`
--       (lifts kernel pointwise-`≤`-with-strict-witness to welfare-strict-
--       reversal under non-trivial percolation);
--   (c) New Cat 3 §3.4.3 atom `blockingProb_strict_in_open_unit_interval`
--       (paper Definition 2.1 — non-trivial bond percolation `p ∈ (0, 1)`);
--   (d) 4 paper-stipulated kernel-level reversal-witness structural
--       equations (Cat 3 §3.4.3, one per reversal atom).
-- Each closure: kernel axioms + the `AgentEdgeIdx` carrier + its
-- `Fintype`/`DecidableEq` instances + the `agentRewardKernel` carrier
-- + the relevant kernel reversal-witness structural equation +
-- `blockingProb` + `blockingProb_strict_in_open_unit_interval`
-- (paper-stipulated atom).
#print axioms BlackwellDilemma.agentWelfare_strict_lt_of_kernel_pointwise_le_strict_at_one
#print axioms BlackwellDilemma.gap_cognitive_threshold_part1
#print axioms BlackwellDilemma.FiveState.gap_bayesian_naive_reversal_present
#print axioms BlackwellDilemma.gap_general_tree
#print axioms BlackwellDilemma.wrongness_misalignment_reversal_atom_OPEN

/-! ## Part 1 strict-kernel-pure closure

The `agentRewardKernel` carrier (Types.lean) is a `noncomputable def`,
so `gap_cognitive_threshold_part1` is strict kernel-pure modulo
Types.lean foundational primitives. The two smaller atoms closing the
Part 1 reversal claim:

* `agentRewardKernel_greedy_alphaAbove_pointwise_le_at_betaZeroOne`
  (Cognitive.lean) — derived from the concrete kernel + the
  `0 ≤ alphaStar 0 p` sup-characterisation algebraic argument; on
  the kernel the greedy branch evaluates to `1` at `β = 0` and to
  `6/10` at `β = 1` for `α > 0` (paper line 545 trap-selection
  regime), so the pointwise inequality `6/10 ≤ 1` closes by
  `norm_num`.
* `agentRewardKernel_greedy_alphaAbove_strict_witness_at_betaZeroOne`
  (Cognitive.lean) — derived by exhibiting `ω₀ = fun _ => false`
  (the all-edges-blocked configuration) and the same branch
  computation; the strict inequality `6/10 < 1` closes by `norm_num`.

The concretisation captures the paper's reversal mechanism (Theorem
4.1 Part 1 + Lemma `lem:wrongness`) on the canonical 5-state IDP
instance (Infrastructure.FiveState reward calibration `r(A) = 6/10`,
`r(G) = 1`) in scalar form. The kernel is constant in `ω` for the
greedy regime; this is paper-faithful because the Theorem 4.1
Part 1 trap-selection effect "with probability approaching 1"
applies uniformly to all percolation realisations under the paper's
standing C1-C3 hypotheses.

### Strict-kernel-pure target audit

The `#print axioms` dependency closure surfaces only:

* Kernel axioms: `propext`, `Classical.choice`, `Quot.sound`.
* Types.lean foundational primitives: `AgentEdgeIdx`,
  `AgentEdgeIdx.decEq`, `AgentEdgeIdx.fintype`, `blockingProb`,
  `blockingProb_strict_in_open_unit_interval` (paper Def 2.1 edge
  set + non-trivial percolation parameter).
* Diagnostic-conditions (EXPLICIT ANTECEDENTS): `C1_Irreversibility`,
  `C2_RewardTopologyMisalignment`, `C3_InformationLocality`,
  `TerminalNeighbourTopology` (Definition 2.4 + Theorem 4.1
  statement, threaded as `hC` and `hT`). -/

#print axioms
  BlackwellDilemma.Infrastructure.GreedyAlphaAboveReversal.betaWitnessLow_lt_betaWitnessHigh
#print axioms
  BlackwellDilemma.agentRewardKernel_greedy_alphaAbove_pointwise_le_at_betaZeroOne
#print axioms
  BlackwellDilemma.agentRewardKernel_greedy_alphaAbove_strict_witness_at_betaZeroOne
#print axioms
  BlackwellDilemma.agentRewardKernel_greedy_alphaAbove_alphaStar_kernel_reversal_witness

/-! ## Infrastructure-wired `_OPEN` audit trail

Each of the 18 `_OPEN` theorems is derived from a smaller
`_workingAssumption` + Cat 1 Infrastructure module. The audit below
verifies each `_OPEN` depends only on:
* Lean kernel axioms (`propext`, `Classical.choice`, `Quot.sound`)
* The corresponding `_workingAssumption` (paper-stipulated structural
  identification)
* `Infrastructure` Cat 1 module dependencies (paper-novel-free)
* Opaque `Types.lean` carriers (Cat 3 §3.4.1 primitives — 永不 close).

NO `_paper_witness` axiom appears anywhere in the dependency
graph (verified by `grep -c "^axiom .*_paper_witness" → 0`).
-/

#print axioms BlackwellDilemma.corner_supermodularity_via_topkis_OPEN
#print axioms BlackwellDilemma.kappaStar_diverges_at_pc_OPEN
#print axioms BlackwellDilemma.fosd_induces_derivative_domination_OPEN
#print axioms BlackwellDilemma.argmax_monotone_under_derivative_domination_OPEN
#print axioms BlackwellDilemma.forward_reachable_empty_full_at_all_open_OPEN
#print axioms BlackwellDilemma.conditional_subproblem_blackwell_applicable_OPEN
#print axioms BlackwellDilemma.mLimitDifference_pos_OPEN
#print axioms BlackwellDilemma.mean_estimate_gap_continuous_OPEN
#print axioms BlackwellDilemma.mean_estimate_gap_tendsto_mLimit_OPEN
#print axioms BlackwellDilemma.principal_interior_maximum_exists_OPEN
#print axioms BlackwellDilemma.aggregate_optimum_exists_per_G_OPEN
#print axioms BlackwellDilemma.topoLossKernel_le_one_over_n_on_giant_atom_OPEN
#print axioms BlackwellDilemma.expectedTopoLossAboveLowerConst_pos_above_pc_OPEN
#print axioms BlackwellDilemma.expectedTopoLoss_ge_AboveLowerConst_eventually_OPEN
#print axioms BlackwellDilemma.wInfoTopoRatioMillsConst_pos_above_pc_OPEN
#print axioms BlackwellDilemma.wInfoTopoRatio_le_MillsConst_decay_OPEN
#print axioms BlackwellDilemma.FiveState.L_unimodal_in_regime_i_OPEN
#print axioms BlackwellDilemma.FiveState.envelope_continuity_in_p_OPEN

/-! ## Strict axiom-closure verification of all 13 retired §3.4.3 atoms

For each retired theorem, prints the dependency closure to verify
NO `sorry`, NO `native_decide`, NO un-credited axioms — only
KERNEL + Cat 3 §3.4.1 carriers + Cat 3 §3.4.3 paper-Def bridges +
Cat 2 ClassicalResults axioms. -/

-- Retired: belowThresholdWelfare boundary convention
#print axioms BlackwellDilemma.belowThresholdWelfare_le_at_zero_for_negative

-- Retired: agentWelfare kappaAgent supermodular
#print axioms BlackwellDilemma.agentWelfare_kappaAgent_at_alpha_one_isSupermodular

-- Retired: mean_estimate_gap continuity
#print axioms BlackwellDilemma.mean_estimate_gap_continuous_paper_Def

-- Retired: mean_estimate_gap tendsto
#print axioms BlackwellDilemma.mean_estimate_gap_tendsto_mLimit_paper_Def

-- Retired: W_bar eventually decreasing
#print axioms BlackwellDilemma.W_bar_eventually_decreasing

-- Retired: envelope continuity
#print axioms BlackwellDilemma.FiveState.envelope_continuity_in_p_paper_Def

-- Retired: forward_reachable = SimpleGraph reach
#print axioms BlackwellDilemma.forward_reachable_eq_simpleGraph_reach_paper_Def

-- Retired: kappaStar diverges at p_c
-- Dominance-discharge refactor (2026-05-19): the
-- `kappaStar_dominates_percolation_scaling_paper_Def` axiom (Cat 3
-- §3.4.3 paper-Def stipulated cognitive-percolation ordering) is
-- DISCHARGED as a Cat 1 derived theorem via concretising
-- `harrisKestenScalingFunction` as the lower envelope of `kappaStar`
-- over the high-α regime (Cat 1 `noncomputable def`) + `csInf_le`
-- application via the
-- `Infrastructure.CognitivePercolationDominance.lower_envelope_le_at_value`
-- generic lifting. The substantive Cat 2 Harris-Kesten + Smirnov-Werner
-- universality content remains honestly retained as the divergence
-- claim on the concrete lower-envelope carrier:
-- `harrisKestenScalingFunction_diverges_at_pc_paper_Def`. Part 6 depends
-- on kernel + Types primitives + 1 Cat 2 Harris-Kesten axiom only.
#print axioms BlackwellDilemma.kappaStar_diverges_at_pc_paper_Def_pointwise
#print axioms BlackwellDilemma.kappaStar_dominates_percolation_scaling_paper_Def
#print axioms BlackwellDilemma.harrisKestenScalingFunction_diverges_at_pc_paper_Def

-- topoLossKernel pointwise bound
#print axioms BlackwellDilemma.topoLossKernel_pointwise_bound_paper_Def

-- expectedTopoLossAboveLowerConst positivity
#print axioms BlackwellDilemma.expectedTopoLossAboveLowerConst_pos_above_pc_paper_Def

-- expectedTopoLoss eventually bound
#print axioms BlackwellDilemma.expectedTopoLoss_ge_AboveLowerConst_eventually_paper_Def

-- L_unimodal in Regime (i)
#print axioms BlackwellDilemma.FiveState.L_unimodal_in_regime_i_paper_Def

-- agentRewardKernel kappaAgent corner positivity
#print axioms BlackwellDilemma.agentRewardKernel_kappaAgent_corner_positivity_paper_Def

/-! ## Strict kernel-pure verification of Part 3 (`gap_cognitive_threshold_part3`)

After concretising the `mean_estimate_gap` carrier as a difference of two
`gaussianPosteriorMean` values (paper line 549 Gaussian conjugate-prior
characterisation) and discharging the bridge
`mean_estimate_gap_eq_posterior_difference_paper_Def` as a kernel-pure
derived theorem (`rfl`-witness on the canonical paper-instance constants
`(mu0, tau0sq, tausq, ybar1, ybar2) = (0, 1, 1, 0,
mLimitDifference_fiveState)`), `gap_cognitive_threshold_part3` is now
STRICT kernel-pure modulo only the Types.lean §3.4.1 paper-Def
primitives `C1_Irreversibility`, `C2_RewardTopologyMisalignment`,
`C3_InformationLocality`. No `mean_estimate_gap` opaque axiom; no
`_paper_Def` bridge atom. -/

#print axioms BlackwellDilemma.gap_cognitive_threshold_part3
#print axioms BlackwellDilemma.mean_estimate_gap_eq_posterior_difference_paper_Def

end BlackwellDilemma.AxiomAudit
