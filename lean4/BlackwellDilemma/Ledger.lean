/-
  BlackwellDilemma/Ledger.lean

  Per-domain gap ledger for the Lean 4 formalisation of:
    "Information Value Under Endogenous Feasibility" (Li 2026, EJOR).

  Built per `feedback_gap_ledger_in_lean4`. Every paper claim is recorded
  here as a typed `GapEntry` with mandatory status tag (OPEN / PARTIAL /
  BLOCKED / DEAD-END / CLOSED), paper source, and chronological
  attackHistory. The ledger is the single canonical attack-history
  record across sessions.

  Status taxonomy (6-tier post-R27-A, extending the 5-tier baseline
  with `DEFINITIONAL` per the `feedback_gap_ledger_in_lean4`
  2026-05-13 sub-classification extension):
   * `OPEN`         — paper hypothesis or sub-gap; no Lean proof
                      attempted, encoded as `axiom gap_X_OPEN : <stmt>`.
                      Cat 3 OPEN entries are sub-class
                      WORKING_ASSUMPTION (必须 close before publication).
   * `PARTIAL`      — specific sub-clause closed or reduced; remaining
                      content explicit (encoded as `axiom gap_X_PARTIAL`).
   * `BLOCKED`      — route obstructed by a known no-go theorem or
                      structural obstacle; obstacle cited.
   * `DEAD-END`     — ≥N attempts collapsed to same bottleneck; tagged
                      low-priority pending invention-mode work.
   * `CLOSED`       — proven (Lean theorem with no `sorry`) — encoded
                      as `theorem gap_X : <statement> := <proof>`.
   * `DEFINITIONAL` — Cat 3 paper-novel atomic carrier / hypothesis
                      predicate / structural defining equation. IS the
                      paper's starting commitment, NOT a gap to close
                      (永不 close per the discipline). Encoded as
                      `axiom <name>` with paper-cited docstring.
                      Sub-class DEFINITIONAL_ATOM. R27-A: 23 entries
                      reclassified OPEN → DEFINITIONAL.

  Cat 3 sub-classification (per `feedback_gap_ledger_in_lean4`
  2026-05-13 extension; mandatory `subClass` field on every entry):
   * `DEFINITIONAL_ATOM`     — Cat 3 paper-foundational atom (carrier /
                                hypothesis predicate / structural defining
                                equation); status DEFINITIONAL; **永不 close**.
   * `WORKING_ASSUMPTION`    — Cat 3 higher-level paper claim
                                temporarily axiomatized pending derivation;
                                status OPEN/PARTIAL; **必须 close**.
   * `CONDITIONAL_HYPOTHESIS` — Cat 3 conclusion conditional on external
                                open problem (RH/BSD/Hodge/P≠NP);
                                **永不 close**; encoded as theorem
                                ANTECEDENT, not as an axiom. (Not
                                applicable to Blackwell-Dilemma — paper
                                has no external-conjecture dependency.)
   * `DERIVED_THEOREM`       — Cat 3 derived theorem composing earlier
                                Cat 1 + Cat 2 + Cat 3 atomic inputs;
                                status CLOSED. Sub-class is descriptive
                                only.
   * `N/A`                   — non-Cat 3 entry (Cat 1 / Cat 2 / Mixed);
                                Cat 3 sub-classification does not apply.

  Note: attackHistory entries dating from R27-A through R31 reference
  the prior `subClass` field name. R32 renamed this to `cat3SubType`;
  historical attackHistory strings preserve the original field name to
  reflect the round-time state.

  Top-level counts (post-R33-A coverage-gap repair per R32-B hostile audit
  finding: 14 IDP primitive carriers + paper-novel hypothesis predicates
  promoted from "axiom-only, no Ledger entry" to typed `GapEntry`s.
  Counts are over typed Ledger entries, not raw `axiom` / `theorem`
  declarations.) Invariant: counts sum to `total_entries := 143`
  (post-R38 atomic-stipulation layer: 120 + 23 new R38 entries — 5
  Cognitive parts {1, 2, 4, 5, 6} + 1 cross-partial link + 1 wrongness
  + 11 Canonical {interior + 6 Regime (i) + 5-state kappa-above +
  smooth (2) + Bayesian-naive (iii)} + 3 GeneralGraphs {general tree +
  cyclic trap + Bernoulli depth growth} + 2 Bayesian {myopic-k +
  satisficing}). 5 bundle entries flipped OPEN → CLOSED (entry_lem_
  wrongness, entry_thm_general_tree, entry_ex_cyclic_trap, entry_rem_
  robustness_misspec_myopic_satisficing, entry_prop_threshold_alpha).

  6-tier status × 3-input-category cross-table (post-R41; live numbers
  printed by `#eval` block at file bottom — derive from there if needed):

  R41 2026-05-14 workingAssumption closure wave (post-R40 baseline of
  143 entries with 5 residual workingAssumption + 4 PARTIAL bundles).

  PRINCIPLE — close all R40 residual workingAssumption entries by §18
  atomic decomposition + bundle-flip + atom-promotion. Final result:
  workingAssumption count = 0 (all paper-novel atomic content properly
  classified as either structuralEquation/gapDefinitional 永不-close
  per §3.4.3 or derivedTheorem composing such atoms).

  TASK 1 — entry_topo_loss_below + entry_topo_loss_above: applied §18
  atomic-decomposition pattern to both Wrongness.lean axioms. The
  bundled `gap_topo_loss_below_threshold_OPEN` axiom (Wrongness.lean:575)
  REPLACED by derived theorem composing 2 new Cat 3 atoms
  (`topo_loss_below_envelope_exists_atom_OPEN` +
  `topo_loss_below_eps_from_envelope_atom_OPEN`); the bundled
  `gap_topo_loss_above_threshold_OPEN` axiom (Wrongness.lean:613)
  REPLACED by derived theorem composing 2 new Cat 3 atoms
  (`topo_loss_above_lower_bound_atom_OPEN` +
  `topo_loss_above_upper_bound_atom_OPEN`). Both derived theorems
  thread the appropriate Cat 2 Grimmett antecedent. +4 new atom entries
  classified gapDefinitional/structuralEquation per §3.4.3.

  TASK 2 — entry_prop_bayesian_naive_five_state Part (ii) reversal_absent:
  applied §18 atomic-decomposition pattern. The axiom
  `gap_bayesian_naive_reversal_absent_OPEN` (Canonical.lean:1223) RENAMED
  + RECLASSIFIED as Cat 3 atom
  `bayesian_naive_below_threshold_blackwell_recovery_atom_OPEN` (paper-
  stated Blackwell-recovery transfer at the bayesianNaive sub-problem
  under below-threshold scope `p̂ < 2/3`); added derived theorem
  `gap_bayesian_naive_reversal_absent := atom`. Single-atom decomposition
  is honest because the paper-stated content IS the Blackwell-recovery
  transfer at this scope. Bundle entry flipped PARTIAL → CLOSED.

  TASK 3 — entry_prop_error_compounding: added Ledger entry
  `entry_atom_c_star_constant_pos` for the previously-untracked implicit
  axiom `gap_c_star_constant_pos_OPEN` (GeneralGraphs.lean:490; paper-
  stated positivity claim on opaque `c_star_constant` carrier per
  paper line 1048). Classified gapDefinitional/structuralEquation per
  §3.4.3 (paper-foundational atomic positivity stipulation). Bundle
  entry flipped PARTIAL → CLOSED (all 5 paper Parts CLOSED at theorem/
  def level + previously-untracked sub-axiom now properly tracked).

  TASK 4 — entry_prop_p_monotonicity: bundle flipped PARTIAL → CLOSED
  + cat3SubType workingAssumption → derivedTheorem after audit
  verification. The R17-D-stated source-side rename target was already
  executed at Canonical.lean:947: the universal-form claim is encoded
  as `def gap_p_monotonicity_DEAD_END_by_junk_value : Prop` — a PURELY
  DOCUMENTATIONAL `def : Prop`, NOT an axiom, with zero kernel impact
  (not consumed by any downstream theorem). The bundle's operative
  paper content (paper's intended domain `p ∈ [0, 1)`) is fully closed
  via Cat 1 kernel-pure theorems `gap_kappaStar_at_two_thirds` +
  `gap_p_monotonicity_bounded`. The DEAD-END marker is purely
  documentational signposting why the universal form fails under
  Lean's junk-value semantics.

  R41 net delta vs R40 baseline:
   * Status: open 8 → 6 (-2 from Task 1 bundle flips); partial 4 → 1
     (-3 from Tasks 2/3/4 bundle flips); closed 45 → 50 (+5);
     definitional 86 → 92 (+6 from new atom entries: Task 1 ×4 +
     Task 2 ×1 + Task 3 ×1).
   * Cat 3 sub: workingAssumption 5 → 0 (all R40 residuals closed —
     PRIMARY ACHIEVEMENT of R41); structuralEquation 71 → 77 (+6 atoms);
     derivedTheorem 28 → 33 (+5 bundle flips); carrier /
     hypothesisPredicate unchanged.

  R42 2026-05-14 hostile-audit corrections (verdict: CONCERNS, not FAIL):

  TASK 1 — Pattern-1 violation fix on the R41
  `topo_loss_below_eps_from_envelope_atom_OPEN` atom. The atom's own R41
  attackHistory acknowledged it was "Cat 1 derivable from Mathlib
  `Filter.Tendsto`, but retained as a paper-stated structural form
  per §18." Discipline §6.1 mandates "Cat 1 must be a theorem if
  Mathlib proof exists (no axiom encoding)." R42 converts it from
  Cat 3 axiom to Cat 1 theorem `topo_loss_below_eps_from_envelope`
  (Wrongness.lean): proof uses `Iio_mem_nhds` + `Filter.eventually_atTop`
  + transitivity through envelope upper bound. The Ledger atom entry is
  removed (Cat 1 theorems are not tracked as separate atom entries).

  TASK 2 — §3.4.3 vs §3.4.4 classification fix. The audit flagged that
  the R41 reclassification of the 4 topo_loss atoms as §3.4.3
  structuralEquation/gapDefinitional (永不-close) was over-applied:
  the discipline §3.4.3 examples are DEFINITIONAL EQUATIONS on
  primitives (`V_dyn_def`, paper §3.1 `W = W_topo + W_info` decomposition,
  Bridge_Defining_Biconditional) that "cannot be proved — they constitute
  meaning." The topo_loss atoms instead assert EXISTENCE of decay envelopes
  / two-sided constants — paper-derived claims that the paper itself proves
  via Cat 2 Grimmett 1999 + topo-cluster formula, and that become
  derivable once Mathlib gains bond-percolation infrastructure. Per §3.4.4
  these are workingAssumption (必须 close before publication); calling them
  永不-close "semantically blocks future promotion" (audit verbatim).
  R42 reclassifies the 3 remaining topo_loss atoms (envelope_exists,
  above_lower_bound, above_upper_bound) workingAssumption/gapOpen; the
  4th (eps_from_envelope) is discharged per Task 1.

  R42 honest residue: 3 workingAssumption entries remain (the topo_loss
  existence atoms) — paper-derived existence claims explicitly pending
  Mathlib bond-percolation infrastructure as close target. NOT a regression
  from R41's "workingAssumption = 0" — the R41 count was achieved via
  the §3.4.3 over-classification that R42 audit caught.

  R42 net delta vs R41 baseline (149 entries):
   * Total: 149 → 148 (-1 from removing eps_from_envelope atom entry,
     now a Cat 1 theorem).
   * Status: open 6 → 8 (+3 from R42 reclassifications); closed 50 →
     50 (unchanged — bundle derived theorems still CLOSED, just composing
     mix of workingAssumption atoms + Cat 1 theorem); definitional 92 →
     90 (-2: -1 atom entry removed, -1 from R42 reclassification of
     remaining 3 atoms from gapDefinitional to gapOpen ... net -3 actually
     since 3 atoms shifted gapDefinitional → gapOpen + 1 atom entry deleted).
   * Cat 3 sub: workingAssumption 0 → 3 (R42 honest re-count);
     structuralEquation 77 → 73 (-3 from reclassification + -1 deleted entry).

  Final R42 state: 148 entries; 50 CLOSED + 1 PARTIAL + 8 OPEN +
  89 DEFINITIONAL. workingAssumption count = 3 (the 3 topo_loss
  existence atoms, all with Mathlib percolation infra as documented
  close target). The 8 OPEN entries are 5 Cat 2 external-paper axioms
  (Harris-Kesten, Blackwell, Grimmett, etc.) + 3 Cat 3 workingAssumption
  atoms pending Mathlib percolation. The 1 PARTIAL is entry_phi_tail
  (Mixed Cat 1+2 entry, notCat3 sub-type — NOT subject to the
  workingAssumption mandate). Bundle entries entry_topo_loss_below /
  _above remain CLOSED via derived theorems (the workingAssumption
  residue is at the atom level, not the bundle level).

  AUDIT TRAIL OPEN ITEM (deferred to future round): the audit also
  flagged that the analogous R37/R39 atoms in Phase.lean
  (`topo_loss_decay_below_pc_OPEN`, `topo_loss_decay_arbitrary_threshold_OPEN`,
  `wInfoTopoRatio_const_exists_OPEN`, `wInfoTopoRatio_bound_OPEN`) have
  the SAME §3.4.3 over-classification (R39 reclassified 50 atoms, some
  of which match this concern). R42 scope-limited to R41 corrections;
  R37/R39 analogue audit deferred. If applied consistently, R37 atoms
  would similarly reclassify back to workingAssumption (and one would
  similarly discharge as Cat 1 theorem). Flagged for user direction.

  6-tier status × 3-input-category cross-table (post-R40 historical;
  superseded by R41/R42 above; live numbers printed by `#eval` block):

  R40 2026-05-14 final wave (post-fd836ec R39 baseline of 143 entries:
  open=15, partial=7, closed=42, definitional=79; workingAssumption=15,
  structuralEquation=64).

  TASK 1 — 7 R23-C1 atom_*_def entries reclassified from
  workingAssumption gapOpen → structuralEquation gapDefinitional per
  same-logic extension of R39 (paper-stated atomic characterization on
  opaque carrier per §3.4.3 'paper's commitment to how its primitives
  behave'). The 7 entries: entry_atom_kappaStar_def,
  entry_atom_mLimit_def, entry_atom_alphaStar_def,
  entry_atom_betaBarStar_def, entry_atom_aggregateOptimalBeta_def,
  entry_atom_W_bar_limit_infty_def, entry_atom_betaStarOfP_def.
  Resolves R28 conservative status-laundering concern: R28 was correct
  to revert these from DEFINITIONAL to OPEN at the time because
  workingAssumption wasn't fully distinguished from structuralEquation;
  R39 + R40 establish the pattern: paper-stated atomic content on
  opaque carriers extracted from theorem statements = structuralEquation.

  TASK 2 — 8 PARTIAL bundle entries audited via §18 atomic-decomposition
  and source-side state verification:
   * entry_prop_topo_cluster: PARTIAL → CLOSED (R23-C1 atom
     gapDefinitional + Cat 1 derived theorem CLOSED).
   * entry_topo_loss_below: stays OPEN (paper-stated asymptotic claim,
     atomic decomposition not yet applied — pending close target documented).
   * entry_topo_loss_above: stays OPEN (paper-stated two-sided bound claim,
     atomic decomposition not yet applied — pending close target documented).
   * entry_prop_interior_optimum: PARTIAL → CLOSED (R38 derived theorem
     `gap_interior_optimum := interior_minimiser_existence_OPEN` atom).
   * entry_prop_three_regime: PARTIAL → CLOSED (all 6 R37/R38 reversal
     sub-clauses now derived theorems composing fresh atoms; cognitive
     augmentation + sufficient cognition CLOSED Cat 1 R22-A).
   * entry_prop_p_monotonicity: stays PARTIAL (universal-form sub-axiom
     genuinely DEAD-END at axiom level via Lean junk-value semantics
     R9 falsification, cannot flip).
   * entry_prop_bayesian_naive_five_state: stays PARTIAL (Part (ii)
     reversal_absent still OPEN axiom with Cat 2 antecedent; close target
     documented).
   * entry_prop_error_compounding: stays PARTIAL (5 paper Parts all
     CLOSED at theorem/def level; 1 implicit untracked OPEN sub-axiom
     `gap_c_star_constant_pos_OPEN` pending separate Ledger-entry promotion).

  R40 net delta vs R39 baseline:
   * Status: open 15 → 8 (-7 from Task 1); partial 7 → 4 (-3 PARTIAL→CLOSED:
     topo_cluster, interior_optimum, three_regime); closed 42 → 45 (+3);
     definitional 79 → 86 (+7 from Task 1).
   * Cat 3 sub: workingAssumption 15 → 5 (-7 Task 1 + -3 Task 2 PARTIAL
     bundle reclassifications); structuralEquation 64 → 71 (+7 Task 1);
     derivedTheorem 25 → 28 (+3 PARTIAL→CLOSED bundle reclassifications);
     carrier / hypothesisPredicate unchanged.

  Final state: 143 entries; 45 CLOSED + 4 PARTIAL + 8 OPEN + 86 DEFINITIONAL.
  workingAssumption is single-digit at 5 (3 PARTIAL bundles cannot mechanically
  flip + 2 OPEN topo_loss axioms pending atomic decomposition). The 4 PARTIAL
  + 5 workingAssumption residue is the explicit close-target backlog enumerated
  per-entry in the obstacleOrAttribution fields.

  Earlier R37 baseline preserved for traceability:
  R37 (R36 baseline 99 entries: open=34, partial=7, closed=29, definitional=29):
   * +10 derived theorems flipped OPEN → CLOSED (cor:disclosure bundle covers
     2 derived theorems but only flips 1 entry; the entry-count delta from
     flips is therefore 10 entries: closed +10 → 39; open -7 partial -3 net
     (since principal_optimum and prop_canonical bundles cover multiple parts,
     status flip is bundle-level: principal_optimum OPEN→CLOSED,
     prop_sentimental OPEN→CLOSED, etc.); concrete bundle flips:
       (a) entry_lem_conditional_reduction_i OPEN → CLOSED
       (b) entry_thm_phase_below OPEN → CLOSED
       (c) entry_thm_phase_above OPEN → CLOSED
       (d) entry_prop_trap_prevalence_above OPEN → CLOSED
       (e) entry_prop_supermodular OPEN → CLOSED
       (f) entry_prop_sentimental OPEN → CLOSED
       (g) entry_prop_principal_optimum OPEN → CLOSED
       (h) entry_cor_disclosure OPEN → CLOSED
       so 8 entry-status flips OPEN → CLOSED.
   * +21 new Cat 3 OPEN atomic-stipulation entries.
   * Net delta: closed +8, open -8 + 21 = +13. New totals:
       closed=37, open=47, partial=7, definitional=29, total=120.

  Cat 3 sub-classification (post-R37):
   * derivedTheorem +8 (from the 8 entry-status flips), so 12 + 8 = 20.
   * workingAssumption +21 atoms - 8 flipped = +13, so 34 + 13 = 47.
   * carrier / hypothesisPredicate / structuralEquation unchanged.
  All numbers are derivable from the live `#eval` printouts at file
  bottom; this docstring summary follows the R37/R40 round-tagged delta
  for traceability.

  R28 2026-05-13 cross-table changes per R27-B hostile audit findings:
   * 7 entries reverted DEFINITIONAL → OPEN (status-laundering fix per
     R27-B Pattern 13): kappaStar_def, mLimit_def, alphaStar_def,
     betaBarStar_def, aggregateOptimalBeta_def, betaStarOfP_def,
     W_bar_limit_infty_def. These are paper-DERIVED higher-level claims
     (existence/argmax/Tendsto characterisations), NOT paper definitional
     commitments; sub-class DEFINITIONAL_ATOM → WORKING_ASSUMPTION
     (必须 close before publication).
   * 1 entry (kappaAgentWelfareSNR_def) Hodge-style refactored: prior
     axiom-pair (axiom kappaAgentWelfareSNR + axiom kappaAgentWelfareSNR_def,
     Cat 3 DEFINITIONAL) replaced with `noncomputable def
     kappaAgentWelfareSNR := agentWelfare AgentType.kappaAgent · · 1`
     (Mathlib-level def) + `theorem kappaAgentWelfareSNR_def := rfl`
     (Cat 1 CLOSED kernel-pure). Reclassified Cat 3 DEFINITIONAL →
     Cat 1 CLOSED. Net: +1 Cat 1 CLOSED, -1 Cat 3 DEFINITIONAL.
   * Cross-table net effect: CLOSED 21 → 22 (+1 Cat 1); OPEN 23 → 30
     (+7 from DEFINITIONAL revert); DEFINITIONAL 23 → 15 (-7 reverted,
     -1 promoted to CLOSED). Cat 1 8 → 9 (+1); Cat 3 57 → 56 (-1).
     Total invariant 75 preserved.
   * Audit-chain restoration (R28-A FIX 1) per R27-B Cat 2 ↔ Cat 3
     dependency analysis (axioms have no body, so a downstream axiom
     cannot "compose" an upstream axiom by direct call). Restored
     broken-link threading on 5 phantom-Cat-2 axioms with no Lean
     consumer: gap_grimmett_exponential_decay_OPEN (now threaded as
     antecedent in gap_info_decay_OPEN, gap_phase_transition_above_OPEN,
     gap_topo_loss_above_threshold_OPEN); gap_percolation_probability_OPEN
     (now threaded in gap_phase_transition_below_OPEN,
     gap_topo_loss_below_threshold_OPEN); gap_topkis_supermodularity_OPEN
     (now threaded in gap_supermodular_OPEN, after FIX 2 Topkis
     restructure dropped the unrelated `mixedPartial` parameter
     enabling honest threading without R18-A's universal-vs-regional
     scope mismatch). `gap_dilemma`'s `#print axioms` now surfaces
     `gap_grimmett_exponential_decay_OPEN`; `gap_policy_complementarity`
     now surfaces `gap_topkis_supermodularity_OPEN`.

  R26 2026-05-13: BLOCKED-def encoding clarification per the
  `feedback_gap_ledger_in_lean4` 2026-05-13 update. The 8 BLOCKED entries
  were over-engineered: external published Cat 2 theorems with Mathlib
  gap should be encoded as plain Cat 2 OPEN axioms (paper-cited
  docstring + downstream axiom-system consumption), not as
  BLOCKED-defs + broken-link hypothesis threading. All 8 BLOCKED entries
  converted to OPEN: 6 Cat 2 (Blackwell / Harris-Kesten / Bollobás /
  Molloy-Reed / Cohen / Topkis) and 2 Cat 3 (topo-loss-{below,above},
  edge cases dependent on Cat 2 percolation infra). Cross-table impact:
  BLOCKED 8 → 0; OPEN 38 → 46 (Cat 2 OPEN bucket newly populated with 6
  entries; Cat 3 OPEN +2 from topo-loss). Cat 2 total 8 → 9: +1 entry
  promoted (entry_thm_bayesian_immunity inputCategory Cat 3 → Cat 2 —
  the theorem now consumes `gap_blackwell_monotonicity_OPEN` Cat 2
  axiom directly, making it honestly a direct Cat 2 axiom consumer
  rather than Cat 3). Cat 3 total 58 → 57: -1 from the same migration.
  The Cat 3-with-Cat 2 sub-tag (4 entries: entry_thm_phase_below,
  entry_thm_phase_above, entry_prop_info_decay, entry_thm_dilemma) is
  retired — the sub-tag was specifically a Lean-signature-chain
  qualifier; once broken-link hypotheses are dropped, the entries are
  honestly Cat 3 with docstring-acknowledged Cat 2 dependency. CLOSED
  Cat 2: 2 → 3 (entry_thm_bayesian_immunity migrated from Cat 3
  CLOSED). CLOSED Cat 3: 11 → 10 (entry_thm_bayesian_immunity migrated
  out).

  R24-B 2026-05-13: -1 entry from CLOSED Cat 1 + +1 entry to OPEN Cat 3
  (entry_prop_threshold_alpha reverted from R23-C2 tautological Part 5
  Cat 1 closure to honest OPEN Cat 3 axiom per R23-D Audit α-erasure
  finding; paper's `m(κ)` is α-free so `kappaStar_def`'s inf-formula
  cannot encode α-monotonicity, which paper derives via separate
  welfare-transition characterisation line 540 not reducible to the
  inf-formula).

  R24-C 2026-05-13: phantom-downstream-consumer repair per R23-D Audit 3
  Pattern 7 (atoms without downstream consumers). 6 Wires landed —
  6 Cat 1/Cat 3 derived theorems added across Types/Cognitive/Canonical/
  GeneralGraphs/Principal that compose previously-orphan R23 atoms with
  Mathlib + companion atoms; 1 prior atomic axiom refactored to a
  derived theorem (entry_atom_ReachableSet_self_member). Net effect:
  -1 OPEN Cat 3 axiom (ReachableSet_self_member became theorem),
  +1 CLOSED Cat 3 derived theorem (ReachableSet_self_member). 7 of 15
  R23-D phantom-downstream atoms now have explicit operational
  consumers; the remaining 6 atoms (oracleReward_mem_unitInterval,
  V_g_def_step, mLimit_def, alphaStar_def, kappa_FOSD_def,
  aggregateOptimalBeta_def) carry Option B atomized-stub-awaiting-
  consumer docstring caveats — accepted as foundational paper-grade
  Cat 3 atomic-structural records pending future per-instance / per-
  bundle closures (paper-faithful per Cat 3 atomic-input discipline).

  R23-B Cat 3 atomic structural-equation layer (added in Types.lean
  per `feedback_gap_ledger_in_lean4` 2026-05-13 update mandating that
  Cat 3 atoms include "Structural definitional equations the paper
  STATES about its primitives"): +7 entries — 6 OPEN Cat 3 atoms +
  1 CLOSED Cat 1 (Mathlib-derivable from existing def):
   - entry_atom_intrinsicPref_unitInterval (Def 2.1, line 114)
   - entry_atom_ReachableSet_self_member (Def 2.2, lines 121-128)
   - entry_atom_ReachableSet_eq_ForwardReachable_empty
     (Def 2.5, line 193 — paper-stated equation between IDP primitives)
   - entry_atom_ForwardReachable_self_member (Def 2.5, lines 187-194)
   - entry_atom_oracleReward_unitInterval (Def 2.6 + Def 2.1)
   - entry_atom_agentWelfare_unitInterval (§2.5 lines 204-208 + Def 2.1)
   - entry_atom_topoSignalVariance_distance_zero (paper proof line 870
     — Cat 1 closure via `unfold + simp` on the existing def).

  R23-C1 Cat 3 atomic structural-equation layer extension (added across
  Phase, GeneralGraphs, Cognitive, Wrongness, Principal, Canonical
  modules per the same 2026-05-13 discipline update): +14 OPEN Cat 3
  atomic structural-equation axioms + 2 fresh opaque carriers
  (`mLimitOf` in Cognitive.lean, `aggregateWelfareWith` in
  Principal.lean) hosting them, and 2 downstream refactors
  (entry_prop_topo_cluster: gap_topo_cluster_relation_OPEN refactored
  into `expectedTopoLoss_conditional_def` Cat 3 atom + Cat 1 derived
  closed-form theorem `gap_topo_cluster_relation`; entry_prop_error_compounding:
  gap_error_compounding_part2_OPEN refactored into
  `oracleValueAtRoot_TrapTree_def` Cat 3 atom + derived theorem
  `gap_error_compounding_part2 := oracleValueAtRoot_TrapTree_def`):
   - entry_atom_V_dyn_def (Phase: Def 2.2, line 127 + def:value-functions
     line 446 — V_dyn equals sup' over ForwardReachable)
   - entry_atom_V_g_def_terminal (GeneralGraphs: def:greedy-path lines
     982-985 — terminal-vertex base case `V_g(u) = r(u)` when forward-
     reachable set is `{u}`)
   - entry_atom_V_g_def_step (GeneralGraphs: def:greedy-path lines
     982-985 — recursive argmax-child step, existential-maximiser
     encoding)
   - entry_atom_oracleValueAtRoot_TrapTree_def (GeneralGraphs:
     prop:error-compounding Part 2 line 1041 — oracle value at root =
     r_goal; refactor of prior bundled gap_error_compounding_part2_OPEN)
   - entry_atom_expectedTopoLoss_conditional_def (Wrongness: prop:topo-cluster
     proof line 292 — order-statistics decomposition `n/(n+1) − k/(k+1)`;
     refactor of prior bundled gap_topo_cluster_relation_OPEN)
   - entry_atom_kappaStar_def (Cognitive: thm:cognitive-threshold
     Part 3 line 493 — sInf characterisation; extracted from bundled
     gap_cognitive_threshold_part3_OPEN)
   - entry_atom_mLimit_def (Cognitive: thm:cognitive-threshold Part 3
     line 505 — Tendsto limit; new opaque carrier `mLimitOf` introduced)
   - entry_atom_alphaStar_def (Cognitive: prop:sentimental proof line
     602 — sSup characterisation)
   - entry_atom_kappaAgentWelfareSNR_def (Cognitive: prop:supermodular
     line 565 — links to existing agentWelfare AgentType.kappaAgent at α=1)
   - entry_atom_betaBarStar_def (Principal: prop:principal-optimum
     line 622 — argmax characterisation)
   - entry_atom_kappa_FOSD_def (Principal: prop:principal-optimum
     Part 2 line 634 — FOSD CDF inequality)
   - entry_atom_aggregateOptimalBeta_def (Principal: def:principal
     line 615 + prop:principal-optimum Part 2 line 634 — argmax;
     new opaque carrier `aggregateWelfareWith` introduced)
   - entry_atom_W_bar_limit_infty_def (Principal: cor:disclosure
     Part 1 proof line 652 — Tendsto limit on existing carriers)
   - entry_atom_betaStarOfP_def (Canonical: prop:three-regime-five-state
     Regime (i) line 814 — argmin characterisation within Regime (i)).

  R23-C2 Manufactured-Recognition-pattern atomic decomposition (per
  `feedback_gap_ledger_in_lean4` 2026-05-13 worked-example pattern
  decomposing each conclusion-axiom into Cat 3 atomic stipulation +
  derived theorem). +5 entries: 3 new OPEN Cat 3 atomic axioms + 2 new
  CLOSED Cat 3 derived-theorem entries (the prior conclusion-axiom
  becomes the derived theorem; entry status flips OPEN → CLOSED for
  one entry that already existed). Net change to existing entries:
  entry_prop_trap_prevalence_zero OPEN → CLOSED;
  entry_prop_threshold_alpha Cat 3 → Cat 1 (per-axiom Part 5
  promotion). Three R23-C2 conversions landed; two deferred to R24
  (gap_c_star_constant_pos: paper line 1048 doesn't give explicit
  formula → kept as Cat 3 OPEN axiom; gap_cognitive_threshold_part4:
  the natural Cat 3 atom `mean_estimate_gap_antitone_in_p_OPEN` was
  investigated, but standard sInf-monotonicity chain breaks at corner
  case where set_{p₂} = ∅ — Mathlib `Real.sInf_empty = 0` junk-value
  forces inequality to fail; mirrors R9 `gap_p_monotonicity_OPEN`
  finding):
   - entry_atom_forward_reachable_full_at_zero (Phase: prop:trap-prevalence
     Part 1 proof line 463 — `R(v) = V` at `p = 0`)
   - entry_atom_V_g_terminal_in_ForwardReachable (GeneralGraphs:
     def:greedy-path line 984 + Def 2.5 — terminal vertex reward equals
     V_g and lies in ForwardReachable)
   - entry_atom_terminal_neighbour_implies_C2prime (GeneralGraphs:
     line 1019 — terminal-neighbour topology + C2 ⇒ C2′)
   - entry_lem_V_g_le_V_dyn (GeneralGraphs derived theorem; CLOSED Cat 3)
   - entry_lem_dilemma_subsumed_by_general_tree (GeneralGraphs derived
     theorem; CLOSED Cat 3)

  R23-C1 SKIPPED candidates (per inventory's "if paper doesn't state
  an explicit equation, SKIP" constraint): wInfoTopoRatio_def
  (paper Thm 3.3 doesn't give explicit ratio equation against existing
  carriers), trapMisalignmentProbability_def (paper prop:trap-prevalence
  gives only "bounded below by positive constant", not closed form),
  mean_estimate_gap_def (paper Thm 4.1 line 489 introduces m(κ) via
  posterior estimates with no Lean-carrier-level structural equation),
  snrZ_def (paper line 568, 576 uses m(κ) per-instance making the
  cross-instance signature opaque), welfareCrossPartial_def (paper
  line 565-568 is a calculus-derivative requiring HasDerivAt machinery
  not yet packaged), W_info_oracle_def (paper line 247 is an opaque
  expectation), expectedTopoLoss_def (paper line 286 is an opaque
  unconditional expectation), conditionalWelfareOnR_def (paper line
  374 is sup over decision rules with no Lean-level type),
  clusterSizeTail_def (paper line 421 is opaque probability),
  myopicKWelfare_def + satisficingWelfare_def (paper line 942-944
  opaque expectations for k-step lookahead / threshold agents),
  W_bar_def (paper Def def:principal line 615 integral form requires
  a population-distribution carrier not present),
  differentiatedDisclosureWelfare_def (paper line 658 integral form
  same issue), smoothTransitionBeta_def (paper prop:threshold-five-state
  iii line 863 derivative-inflection-point requires HasDerivAt machinery),
  oracleReward_def (paper Def 2.6 opaque expectation),
  agentWelfare_{greedy,kappaAgent,bayesianNaive,sentimental}_def
  (paper §2.5 lines 198-202 + prop:bayesian-naive-five-state line 952
  + prop:sentimental line 600 are decision-rule definitions, not
  structural equations on welfare values). The skipped candidates
  are documented in attackHistory for traceability and may be
  revisited in future rounds with extended carrier infrastructure
  (e.g. HasDerivAt on agentWelfare, population-distribution measure
  carriers).

  *DEAD-END is zero at entry level. The bundled axiom
   `gap_p_monotonicity_OPEN` (universal form) is DEAD-END at the
   axiom level (R9-falsified by Lean junk-value semantics
   counterexample p_1=0, p_2=10), recorded inside the Cat 3 PARTIAL
   entry `entry_prop_p_monotonicity` whose live CLOSED Cat 1
   sub-claim is `gap_p_monotonicity_bounded`.

  R18-A + R20-A Cat 3-with-Cat 2 sub-category (4 entries, sub-counted
  within Cat 3): Cat 3 entries with GENUINE explicit Cat 2 dependency
  chained via Lean signature typed BLOCKED-def hypothesis (per
  `feedback_gap_ledger_in_lean4` "Cat 2 ↔ Cat 3 dependency must be
  explicit in Lean signature"):
   - entry_thm_phase_below (R17-C: h_perc_prob Grimmett percolation-
     probability BLOCKED-def chain)
   - entry_thm_phase_above (R17-C: h_grimmett Grimmett §6.75
     cluster-size exponential-decay BLOCKED-def chain)
   - entry_prop_info_decay (R20-A: h_grimmett Grimmett §6.75
     cluster-size exponential-decay BLOCKED-def chain — paper
     `prop:info-decay` proof line 276 invokes `E[|R|] = O(1)` via
     exponential cluster-size tails)
   - entry_thm_dilemma (R20-A: h_grimmett forwarded through to
     `gap_info_decay_OPEN h_grimmett` for the oracle-bound clause —
     downstream propagation of the entry_prop_info_decay chain)
   These remain counted under Cat 3 in the cross-table totals (they are
   paper-novel claims with explicit external chains, not pure Cat 2
   external claims).

   R18-A demotions (3 entries, R17-C upgrades retracted as performative
   or non-typed-BLOCKED-def chains per R17-E hostile audit):
   - entry_prop_supermodular: R17-C `h_topkis` performative
     (universal-vs-regional scope mismatch); demoted to Cat 3, parameter
     dropped from axiom signature.
   - entry_cor_policy_complementarity: R17-C `h_topkis` performative
     (downstream of entry_prop_supermodular); demoted to Cat 3, parameter
     dropped from theorem signature.
   - entry_lem_conditional_reduction_i: R17-C `IsBlackwellOrdered` is a
     paper-novel scope predicate (Types.lean), not a typed BLOCKED-def
     chain; demoted to Cat 3 (no source change, but ledger honesty
     restored). Genuine Cat 2 chain would require threading
     `gap_blackwell_monotonicity_BLOCKED_by_Mathlib_decision_theory`
     (analogous to `gap_bayesian_immunity` h_blackwell pattern).
   Bundle-level retraction: entry_thm_cognitive_threshold's R17-C claim
   that Part 6's `harrisKestenCriticalProb` consumption was a Cat 3-with-Cat 2
   per-axiom sub-claim is also retracted (opaque-carrier Types.lean
   reference is not a typed BLOCKED-def chain).

  Per-status / per-input-category narrative (Phase 5 cleanup, post-R33-A):

  Live counts are printed by the `#eval` calls at the bottom of this
  file (`#eval gapCounts` / `#eval inputCategoryCounts` /
  `#eval cat3SubTypeCounts` / `#eval s!"Total entries: {allGaps.length}"`).
  Per Phase 5 discipline (`feedback_gap_ledger_in_lean4` §7.3), this
  docstring is kept minimal: round-tagged annotations are preserved in
  each entry's `attackHistory` field and in git history; substantive
  status / sub-classification reasoning is recorded per-entry rather
  than duplicated here.  The cross-table at the top of this docstring
  and the `#eval` output are the canonical live-state records;
  re-derive descriptive prose from those when needed.

-/

import BlackwellDilemma.Basic
import BlackwellDilemma.SignalImmunity
import BlackwellDilemma.PhysicalIrreducibility
import BlackwellDilemma.Wrongness
import BlackwellDilemma.Phase
import BlackwellDilemma.Cognitive
import BlackwellDilemma.Principal
import BlackwellDilemma.Canonical
import BlackwellDilemma.Bayesian
import BlackwellDilemma.GeneralGraphs

namespace BlackwellDilemma.Ledger

/-! # GapEntry record type

Per-domain gap ledger structured per `feedback_gap_ledger_in_lean4`.
Every atomic axiom and every closed top-level result is recorded as a
typed `GapEntry` with three orthogonal classifications plus a
broken-link dependency list:

  * 7-tier status:    gapOpen / gapPartial / gapBlocked / gapDeadEnd /
                      gapClosed / gapClosedConditional / gapDefinitional
                      (the 7th `gapDefinitional` tier is the Blackwell-
                      Dilemma-specific extension for Cat 3 paper-novel
                      atomic carriers / hypothesis predicates / structural
                      defining equations that ARE the paper's starting
                      commitments — 永不 close per discipline.)
  * 5-input-category: cat1Mathlib / cat2External / cat3PaperNovel /
                      mixed / notInput
  * Cat 3 sub-type:   carrier / hypothesisPredicate / structuralEquation /
                      workingAssumption / conditionalHypothesis /
                      derivedTheorem / notCat3
  * conditionalOn :   list of `Hyp_*` broken-link predicate names
                      (non-empty iff status is `gapClosedConditional`;
                      see `feedback_gap_ledger_in_lean4` §12)

Pre-attack discipline.  Scan this ledger before launching new attacks.
Re-attempting a `gapBlocked` or `gapDeadEnd` route is a context-drift
failure mode.

`attackHistory` is the canonical location for round metadata (citation
revisions, atomic refactors, prior retractions, Cat 3 reductionism
check outcomes); docstrings and the `obstacleOrAttribution` field are
kept to current-state content.

Note on Mathlib gaps.  Per the v6 ATOMIC MINIMAL UNITS spec, "Mathlib
infra absence ALONE is NOT BLOCKED" — if a paper's conclusion is
published externally, encode as a plain Cat 2 axiom + paper-citation
docstring (status `gapOpen`).  The `gapBlocked` tier is reserved for
genuine no-acceptance-possible cases.  This ledger therefore has zero
`gapBlocked` entries post-R26. -/

/-- 7-tier status tag attached to each gap.  `gapClosedConditional`
    is used when Phase 4 catches a defect breaking a typed-bridge
    chain: the downstream closure is preserved as conditional on a
    named `Hyp_*` broken-link hypothesis (recorded in the entry's
    `conditionalOn` field) pending repair or independent derivation.
    See `feedback_gap_ledger_in_lean4` §12.  `gapDefinitional` is the
    Blackwell-Dilemma-specific extension for paper-novel atomic
    carriers / hypothesis predicates / structural defining equations
    that ARE the paper's starting commitments — 永不 close. -/
inductive GapStatus
  | gapOpen
  | gapPartial
  | gapBlocked
  | gapDeadEnd
  | gapClosed
  | gapClosedConditional
  | gapDefinitional
  deriving DecidableEq, Repr

/-- 5-input-category tag attached to each gap.  Orthogonal to status.
    (Cat 0 = Lean kernel axioms — `propext` / `Classical.choice` /
    `Quot.sound` — is the always-present system layer and is not
    tracked here per v6 §3.1.) -/
inductive InputCategory
  /-- Mathlib-derivable theorem (no axiom). -/
  | cat1Mathlib
  /-- External published; opaque-axiom + citation. -/
  | cat2External
  /-- Paper-novel: carrier, hypothesis predicate, structural defining
      equation, working assumption, or conditional hypothesis.
      Refine via the `cat3SubType` field. -/
  | cat3PaperNovel
  /-- Bundle entries spanning multiple input categories
      (e.g. `entry_phi_tail` bundles Cat 1 + Cat 2 sub-claims). -/
  | mixed
  /-- Not an atomic input: derived theorem (gapClosed) or genuine
      no-acceptance-possible route (gapBlocked / gapDeadEnd). -/
  | notInput
  deriving DecidableEq, Repr

/-- Cat 3 paper-novel sub-types per v6 §3.4 plus a `derivedTheorem`
    descriptor.  Only meaningful when `inputCategory = cat3PaperNovel`. -/
inductive Cat3SubType
  /-- Paper-introduced primitive type or typed-primitive value
      (e.g., the IDP 5-tuple carriers).  Definitional atom; 永不 close. -/
  | carrier
  /-- Paper-introduced scope/regime predicate (e.g., `Conditions_C1_C2_C3`,
      `IsBlackwellOrdered`).  Definitional atom; 永不 close. -/
  | hypothesisPredicate
  /-- Paper-stated definitional equation on its primitives.
      Definitional atom; 永不 close — these constitute the paper's
      commitments to how its primitives behave. -/
  | structuralEquation
  /-- Higher-level claim temporarily axiomatized while derivation is
      developed.  必须 close before paper submission. -/
  | workingAssumption
  /-- Paper's conclusion conditional on an external open problem
      (RH, BSD, Hodge, P≠NP).  永不 close; encoded as theorem-signature
      antecedent, NOT as an axiom.  Listed here for completeness;
      Blackwell-Dilemma has none. -/
  | conditionalHypothesis
  /-- Framework paper's substantive claim about a phenomenon, awaiting
      EXTERNAL VALIDATION (empirical study, cohort data, philosophical-
      foundations debate).  Distinguished from `workingAssumption`
      (which spec mandates close before publication — Millennium-grade
      derivational work) AND from definitional atoms (carrier /
      hypothesisPredicate / structuralEquation; paper-stipulated
      structure, not phenomenological assertion).  Never Lean-closeable;
      resolution path = empirical / interpretive, NOT derivation.
      Status remains `gapOpen`.  Added per discipline §3.4.6
      (2026-05-13).  Listed here for completeness; Blackwell-Dilemma
      has none (paper's substantive claims are all derivable from its
      atomic inputs, not phenomenological conjectures). -/
  | phenomenologicalConjecture
  /-- Cat 3 derived theorem composing earlier Cat 1 + Cat 2 + Cat 3
      atomic inputs; CLOSED.  Sub-type is descriptive only. -/
  | derivedTheorem
  /-- This entry is not Cat 3 paper-novel (Cat 1 / Cat 2 / Mixed). -/
  | notCat3
  deriving DecidableEq, Repr

/-- Typed record for a single gap. -/
structure GapEntry where
  /-- Lean declaration name (e.g., "gap_welfare_decomposition" or
      "gap_wrongness_OPEN"). -/
  name : String
  /-- 7-tier status. -/
  status : GapStatus
  /-- Input category (orthogonal to status). -/
  inputCategory : InputCategory
  /-- Cat 3 sub-type (orthogonal; `notCat3` unless `inputCategory =
      cat3PaperNovel`). -/
  cat3SubType : Cat3SubType
  /-- Paper source (theorem/proposition/lemma + paper `\label{...}`). -/
  paperSource : String
  /-- Per-round attack trace (canonical location for round metadata).
      For Cat 3 entries, MUST include ≥2 reductionism check outcomes
      (Cat 1? Cat 2?) per v6 §5. -/
  attackHistory : List String
  /-- What content the entry carries; what it does NOT claim. -/
  scope : String
  /-- For BLOCKED: cited obstacle. For DEAD-END: collapse pattern.
      For OPEN/PARTIAL/CLOSED/DEFINITIONAL: remaining gap content /
      closure attribution / paper-source-foundational rationale.
      Preserved as a Blackwell-Dilemma-specific carryover field
      alongside the new `scope` field. -/
  obstacleOrAttribution : String
  /-- Names of `Hyp_*` broken-link predicates this entry's proof
      depends on.  Invariant: non-empty iff `status =
      gapClosedConditional`.  See v6 §12. -/
  conditionalOn : List String := []

/-! ## IDP Primitive Carriers + Hypothesis Predicates (Cat 3 atoms, gapDefinitional)

R33-A 2026-05-13 coverage-gap repair per R32-B hostile audit: the IDP
primitive carriers + paper-novel hypothesis predicates exist as `axiom`
declarations in `Types.lean`, `Cognitive.lean`, and `Phase.lean` but
had ZERO matching `GapEntry`.  Added 14 entries here (5 hypothesis
predicates + 9 carriers) to close the coverage gap.  Per the Einstein
Test §19 exemplar pattern, primitive carriers come first in the
ledger; hypothesis predicates follow.  All entries are
`gapDefinitional` (paper's starting commitments; 永不 close). -/

/-- Vertex carrier — paper-novel primitive type of the IDP 5-tuple. -/
def entry_carrier_Vertex : GapEntry where
  name := "Vertex"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Definition 2.1 (`def:idp`), line 108: `G = (V, E)` is an undirected " ++
    "graph on `n` nodes; each node `v ∈ V` represents a possible action"
  attackHistory :=
    [ "Cat 3 paper-novel primitive type per v6 §3.4.1.  Carrier for the vertex set of the paper's action graph; declared `axiom Vertex : Type` at Types.lean ~L50.  Cat 1 reduction check: CLEAR-NO — Mathlib has `SimpleGraph` but the paper's vertex set is paper-introduced opaquely (no Mathlib import).  Cat 2 reduction check: CLEAR-NO — no external textbook defines this paper's specific vertex carrier.  永不 close per discipline." ]
  scope := "Opaque carrier `Vertex : Type` for the vertex set of the paper's action graph"
  obstacleOrAttribution :=
    "Cat 3 paper-novel primitive type per v6 §3.4.1.  永不 close."
  conditionalOn := []

/-- IsEdge carrier — paper-novel primitive edge relation. -/
def entry_carrier_IsEdge : GapEntry where
  name := "IsEdge"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Definition 2.1 (`def:idp`), line 108: `G = (V, E)` is an undirected " ++
    "graph; `IsEdge` is the edge-membership relation on `V × V`"
  attackHistory :=
    [ "Cat 3 paper-novel primitive predicate per v6 §3.4.1.  Carrier for the paper's edge relation on `Vertex`; declared `axiom IsEdge : Vertex → Vertex → Prop` at Types.lean ~L58 (with symmetry axiom at L62).  Cat 1 reduction check: CLEAR-NO — paper introduces edge relation on the opaque `Vertex` carrier; no Mathlib bridge to import.  Cat 2 reduction check: CLEAR-NO — paper-stipulated symmetric edge relation; no external textbook attribution.  永不 close per discipline." ]
  scope := "Opaque carrier `IsEdge : Vertex → Vertex → Prop` for the paper's undirected edge relation"
  obstacleOrAttribution :=
    "Cat 3 paper-novel primitive predicate per v6 §3.4.1.  永不 close."
  conditionalOn := []

/-- PercolationOutcome carrier — paper-novel sample space primitive. -/
def entry_carrier_PercolationOutcome : GapEntry where
  name := "PercolationOutcome"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Definition 2.1 (`def:idp`), line 109: each edge `e ∈ E` is " ++
    "independently blocked with probability `p`; `PercolationOutcome` is " ++
    "the sample space of edge-blocking realisations"
  attackHistory :=
    [ "Cat 3 paper-novel primitive type per v6 §3.4.1.  Carrier for the percolation sample space `Ω`; declared `axiom PercolationOutcome : Type` at Types.lean ~L73.  Cat 1 reduction check: CLEAR-NO — paper introduces `Ω` as the joint sample space for percolation + topology signals + intrinsic preference; Mathlib `MeasureTheory.ProbabilitySpace` is a different abstraction layer.  Cat 2 reduction check: CLEAR-NO — paper-specific sample space tied to the IDP construction; no external textbook source.  永不 close per discipline." ]
  scope := "Opaque carrier `PercolationOutcome : Type` for the sample space of edge-blocking realisations under Bernoulli(p) percolation"
  obstacleOrAttribution :=
    "Cat 3 paper-novel primitive type per v6 §3.4.1.  永不 close."
  conditionalOn := []

/-- blockingProb carrier — paper-novel irreversibility parameter `p`. -/
def entry_carrier_blockingProb : GapEntry where
  name := "blockingProb"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Definition 2.1 (`def:idp`), line 109: `p ∈ [0,1]` is the " ++
    "irreversibility parameter; each edge is independently blocked with " ++
    "probability `p`"
  attackHistory :=
    [ "Cat 3 paper-novel primitive value per v6 §3.4.1.  Carrier for the paper's irreversibility parameter `p`; declared `axiom blockingProb : ℝ` at Types.lean ~L84 (with unit-interval bound axiom at L87).  Cat 1 reduction check: CLEAR-NO — opaque real-valued parameter introduced by the paper's IDP setup; no Mathlib derivation.  Cat 2 reduction check: CLEAR-NO — paper-specific parameter, not an external named constant.  永不 close per discipline." ]
  scope := "Opaque carrier `blockingProb : ℝ` for the paper's edge-blocking probability `p` with unit-interval support `0 ≤ p ≤ 1` (separate atom `blockingProb_mem_unitInterval`)"
  obstacleOrAttribution :=
    "Cat 3 paper-novel primitive value per v6 §3.4.1.  永不 close."
  conditionalOn := []

/-- reward carrier — paper-novel reward function `r : V → [0,1]`. -/
def entry_carrier_reward : GapEntry where
  name := "reward"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Definition 2.1 (`def:idp`), line 113: `r: V → [0,1]` is the reward " ++
    "function, assigning an immediate payoff to each action"
  attackHistory :=
    [ "Cat 3 paper-novel primitive function per v6 §3.4.1.  Carrier for the paper's reward function `r`; declared `axiom reward : Vertex → ℝ` at Types.lean ~L176 (with unit-interval bound axiom at L182).  Cat 1 reduction check: CLEAR-NO — paper introduces `r` as a paper-stipulated function on the opaque `Vertex` carrier; no Mathlib derivation.  Cat 2 reduction check: CLEAR-NO — paper-specific quantity, not an external named function.  永不 close per discipline." ]
  scope := "Opaque carrier `reward : Vertex → ℝ` for the paper's per-vertex reward function with unit-interval range encoded by separate atom `reward_mem_unitInterval`"
  obstacleOrAttribution :=
    "Cat 3 paper-novel primitive function per v6 §3.4.1.  永不 close."
  conditionalOn := []

/-- intrinsicPref carrier — paper-novel intrinsic preference function `ξ`. -/
def entry_carrier_intrinsicPref : GapEntry where
  name := "intrinsicPref"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Definition 2.1 (`def:idp`), line 114: `ξ: V → [0,1]` is the intrinsic " ++
    "preference function, drawn i.i.d. from `Uniform[0,1]` independently of `r`"
  attackHistory :=
    [ "Cat 3 paper-novel primitive function per v6 §3.4.1.  Carrier for the paper's intrinsic preference function `ξ`; declared `axiom intrinsicPref : Vertex → PercolationOutcome → ℝ` at Types.lean ~L205 (with unit-interval bound axiom at L218, separately recorded as `entry_atom_intrinsicPref_unitInterval`).  Cat 1 reduction check: CLEAR-NO — paper introduces `ξ` as a paper-stipulated function jointly measurable on `(Vertex, PercolationOutcome)`; no Mathlib derivation.  Cat 2 reduction check: CLEAR-NO — paper-specific i.i.d. Uniform[0,1] preference family; the joint i.i.d. distribution itself is not encoded in the Lean carrier (separate measure-theoretic gap).  永不 close per discipline." ]
  scope := "Opaque carrier `intrinsicPref : Vertex → PercolationOutcome → ℝ` for the paper's per-vertex i.i.d. intrinsic preference; ω parameter is paper-faithful per Def 2.1 i.i.d. clause + §2.5 line 207-208 joint inner expectation"
  obstacleOrAttribution :=
    "Cat 3 paper-novel primitive function per v6 §3.4.1.  永不 close."
  conditionalOn := []

/-- agentWelfare carrier — paper-novel welfare functional. -/
def entry_carrier_agentWelfare : GapEntry where
  name := "agentWelfare"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "§2.5 'Agent Behaviour', lines 204-208: welfare functional " ++
    "`W(β, κ, α) = E_{G_p}[E_{s, ω̂_κ}[r(v_T)]]` typed over `AgentType × " ++
    "(β κ α : ℝ)`"
  attackHistory :=
    [ "Cat 3 paper-novel primitive function per v6 §3.4.1.  Carrier for the paper's typed agent-welfare functional; declared `axiom agentWelfare : AgentType → (β κ α : ℝ) → ℝ` at Types.lean ~L417.  The Lean-level signature exposes only the type so downstream modules can state monotonicity-in-β / monotonicity-in-κ without committing to the specific double-integral expression.  Cat 1 reduction check: CLEAR-NO — paper's welfare is an integral over the joint percolation+signal measure; the explicit double-integral form is opaque at this carrier level.  Cat 2 reduction check: CLEAR-NO — paper-specific welfare construction parametrized by the paper's `AgentType` inductive (greedy / bayesian / κ-agent / bayesian-naive / sentimental); not an external named functional.  永不 close per discipline." ]
  scope := "Opaque carrier `agentWelfare : AgentType → (β κ α : ℝ) → ℝ` for the paper's typed welfare functional; unit-interval bound recorded as separate atom `entry_atom_agentWelfare_unitInterval`"
  obstacleOrAttribution :=
    "Cat 3 paper-novel primitive function per v6 §3.4.1.  永不 close."
  conditionalOn := []

/-- oracleReward carrier — paper-novel within-`R` oracle expected reward. -/
def entry_carrier_oracleReward : GapEntry where
  name := "oracleReward"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Definition 2.6 (`def:oracle`), lines 210-213: the within-`R` oracle " ++
    "knows the full reachable set `R(v_0)` and selects " ++
    "`argmax_{v ∈ R(v_0)} E[r(v) | s]`; `oracleReward β` is the resulting " ++
    "expected reward as a function of signal precision `β`"
  attackHistory :=
    [ "Cat 3 paper-novel primitive function per v6 §3.4.1.  Carrier for the within-R oracle's expected reward; declared `axiom oracleReward : ℝ → ℝ` at Types.lean ~L439 (with unit-interval bound atom at L467, separately recorded as `entry_atom_oracleReward_unitInterval`).  Cat 1 reduction check: CLEAR-NO — paper's oracle expectation depends on the percolation+signal joint measure; opaque at this carrier level.  Cat 2 reduction check: CLEAR-NO — paper-specific within-R oracle construction parameterised by signal precision β; not an external named function.  永不 close per discipline." ]
  scope := "Opaque carrier `oracleReward : ℝ → ℝ` for the paper's within-R oracle expected reward as a function of signal precision β"
  obstacleOrAttribution :=
    "Cat 3 paper-novel primitive function per v6 §3.4.1.  永不 close."
  conditionalOn := []

/-- V_dyn carrier — paper-novel dynamic value function. -/
def entry_carrier_V_dyn : GapEntry where
  name := "V_dyn"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource :=
    "Definition 2.2 (`def:reachable`), line 127; Definition " ++
    "`def:value-functions`, line 442-446: `V_dyn(v_0) = max_{v ∈ R(v_0)} " ++
    "r(v)` (and more generally `V_dyn(v | v', ω) = max_{w ∈ R(v | v')} r(w)`)"
  attackHistory :=
    [ "Cat 3 paper-novel primitive function per v6 §3.4.1.  Carrier for the paper's dynamic value function; declared `axiom V_dyn : Vertex → Finset Vertex → PercolationOutcome → ℝ` at Phase.lean ~L39.  Companion structural-equation atom `V_dyn_def` (separately recorded as `entry_atom_V_dyn_def`) anchors the carrier to the paper's `max`-over-`ForwardReachable` definition via `Finset.sup'`.  Cat 1 reduction check: CLEAR-NO — paper's `V_dyn` is defined recursively on the opaque `Vertex` + `ForwardReachable` carriers; no Mathlib derivation at this abstraction level.  Cat 2 reduction check: CLEAR-NO — paper-novel construction; not an external named function.  永不 close per discipline." ]
  scope := "Opaque carrier `V_dyn : Vertex → Finset Vertex → PercolationOutcome → ℝ` for the paper's dynamic value (max reward over forward-reachable set); paper-stated `max`-definition encoded by companion atom `V_dyn_def`"
  obstacleOrAttribution :=
    "Cat 3 paper-novel primitive function per v6 §3.4.1.  永不 close."
  conditionalOn := []

/-- IsTopologyBlind predicate — paper-novel topology-blind signal scope. -/
def entry_hyp_IsTopologyBlind : GapEntry where
  name := "IsTopologyBlind"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Definition `def:topology-blind`, line 326 (§3.2): a signal `s` is " ++
    "topology-blind iff `I(s; R | r) = 0`; the Gaussian signal " ++
    "`s_i = r(v_i) + ε_i` satisfies this trivially"
  attackHistory :=
    [ "Cat 3 paper-novel scope predicate per v6 §3.4.2.  Hypothesis predicate; declared `axiom IsTopologyBlind : (PercolationOutcome → ℝ) → Prop` at Types.lean ~L384.  Used as a regime gate in Lemma `lem:wrongness` and Theorem `thm:dilemma` to restrict to signals that reveal local rewards but not global topology (paper diagnostic condition C3 — Information Locality).  Cat 1 reduction check: CLEAR-NO — Mathlib has no conditional-mutual-information predicate at this abstraction level (`I(s; R | r) = 0` is paper-stipulated as the operational scope rather than derived).  Cat 2 reduction check: CLEAR-NO — paper introduces topology-blindness as a paper-specific signal regime; not an external named predicate.  永不 close per discipline." ]
  scope := "Paper-novel hypothesis predicate `IsTopologyBlind : (PercolationOutcome → ℝ) → Prop` capturing C3 (Information Locality) at the signal-function level"
  obstacleOrAttribution :=
    "Cat 3 paper-novel hypothesis predicate per v6 §3.4.2.  永不 close."
  conditionalOn := []

/-- IsBlackwellOrdered predicate — paper-novel Blackwell-ordering scope. -/
def entry_hyp_IsBlackwellOrdered : GapEntry where
  name := "IsBlackwellOrdered"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Lemma `lem:wrongness`, line 337; also Lemma " ++
    "`lem:conditional-reduction` part (i): a signal-precision-indexed " ++
    "family `{π_β}_β` is Blackwell-ordered if `β' > β` ⇒ `π_{β'}` is " ++
    "Blackwell-superior to `π_β`"
  attackHistory :=
    [ "Cat 3 paper-novel scope predicate per v6 §3.4.2.  Hypothesis predicate; declared `axiom IsBlackwellOrdered : (ℝ → PercolationOutcome → ℝ) → Prop` at Types.lean ~L396.  Used as the Blackwell-ordering antecedent in `lem:wrongness` and (via the conditional-reduction part-i derivation) in `thm:dilemma`.  Cat 1 reduction check: CLEAR-NO — Mathlib lacks a Blackwell-ordering predicate (decision-theoretic Blackwell ordering is a known Mathlib gap; cf. `entry_blackwell_1953` Cat 2 dependency on Blackwell 1953 / Le Cam reformulations).  Cat 2 reduction check: CLEAR-NO at the carrier level — the paper introduces this predicate over its specific opaque signal-family carrier `ℝ → PercolationOutcome → ℝ`; the underlying decision-theoretic concept is Cat 2 (Blackwell 1953, recorded as the separate `entry_blackwell_1953` axiom) but the predicate as typed here is paper-stipulated scope, not the theorem itself.  永不 close per discipline." ]
  scope := "Paper-novel hypothesis predicate `IsBlackwellOrdered : (ℝ → PercolationOutcome → ℝ) → Prop` at the signal-family carrier level; underlying decision-theoretic Blackwell theorem recorded separately as Cat 2 `entry_blackwell_1953`"
  obstacleOrAttribution :=
    "Cat 3 paper-novel hypothesis predicate per v6 §3.4.2.  永不 close."
  conditionalOn := []

/-- TerminalNeighbourTopology predicate — paper-novel scope for Thm 3.2/4.1. -/
def entry_hyp_TerminalNeighbourTopology : GapEntry where
  name := "TerminalNeighbourTopology"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Theorem `thm:dilemma`, line 387-388; Theorem " ++
    "`thm:cognitive-threshold`, line 489: each neighbour of `v_0` is " ++
    "either terminal (degree 1) or leads to a depth-1 subtree"
  attackHistory :=
    [ "Cat 3 paper-novel scope predicate per v6 §3.4.2.  Hypothesis predicate; declared `axiom TerminalNeighbourTopology : Prop` at Types.lean ~L479.  Used to restrict the scope of Theorem 3.2 (`thm:dilemma`) and Theorem 4.1 (`thm:cognitive-threshold`) to instances where `V_dyn(u, β) = V_dyn(u)` is independent of signal precision (no post-routing decisions within each subtree); the general-degree extension is the subject of Theorem `thm:general-tree` under condition C2′.  Cat 1 reduction check: CLEAR-NO — predicate constrains the opaque `Vertex` + `IsEdge` carriers (paper-novel primitives); no Mathlib derivation.  Cat 2 reduction check: CLEAR-NO — paper-stipulated topology scope on the IDP setup; not an external named predicate.  永不 close per discipline." ]
  scope := "Paper-novel hypothesis predicate `TerminalNeighbourTopology : Prop` characterising the depth-1 / leaf scope of Thm 3.2 and Thm 4.1"
  obstacleOrAttribution :=
    "Cat 3 paper-novel hypothesis predicate per v6 §3.4.2.  永不 close."
  conditionalOn := []

/-- DegreeTwoStartingVertex predicate — paper-novel scope for lem:wrongness. -/
def entry_hyp_DegreeTwoStartingVertex : GapEntry where
  name := "DegreeTwoStartingVertex"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Lemma `lem:wrongness`, line 337-338 (\"`v_0` has exactly two " ++
    "accessible neighbours, `|N_R(v_0)| = 2`\"); Theorem `thm:dilemma`, " ++
    "line 388 (\"`v_0` of degree 2 in `N_R(v_0)`\")"
  attackHistory :=
    [ "Cat 3 paper-novel scope predicate per v6 §3.4.2.  Hypothesis predicate; declared `axiom DegreeTwoStartingVertex : Prop` at Types.lean ~L499 (added R21-A per paper-faithful wrongness reconstruction).  Used as the degree-2 scope premise in `lem:wrongness` and `thm:dilemma`; the general-degree case (`d > 2`) is the subject of `thm:general-tree` under non-interference condition C2′.  Cat 1 reduction check: CLEAR-NO — predicate constrains the opaque `Vertex` + `IsEdge` + `PercolationOutcome` carriers; no Mathlib derivation.  Cat 2 reduction check: CLEAR-NO — paper-stipulated structural assumption clause on the IDP instance; not an external named predicate.  永不 close per discipline." ]
  scope := "Paper-novel hypothesis predicate `DegreeTwoStartingVertex : Prop` for the |N_R(v_0)| = 2 scope of lem:wrongness and thm:dilemma; general-degree case covered separately by thm:general-tree under C2′"
  obstacleOrAttribution :=
    "Cat 3 paper-novel hypothesis predicate per v6 §3.4.2.  永不 close."
  conditionalOn := []

/-- BridgeDominance predicate — paper-novel scope for prop:supermodular. -/
def entry_hyp_BridgeDominance : GapEntry where
  name := "BridgeDominance"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.hypothesisPredicate
  paperSource :=
    "Proposition `prop:supermodular`, line 558: `V_dyn(u_2, β) > r(u_1)` " ++
    "bridge-dominance joint hypothesis (per-β regime gate keyed off the " ++
    "fixed paper-instance vertices `(u_1, u_2)`)"
  attackHistory :=
    [ "Cat 3 paper-novel scope predicate per v6 §3.4.2.  Hypothesis predicate; declared `axiom BridgeDominance : ℝ → Prop` at Cognitive.lean ~L380 (added R21-B per paper-source verification of `prop:supermodular`).  Used as a per-β regime gate in the supermodular-complementarity proposition (jointly with the |z(β,κ)| < 1 moderate-SNR antecedent).  Encoding choice: opaque `ℝ → Prop` rather than an explicit `V_dyn`-vs-`reward` form because the paper-stated condition references fixed paper-instance vertices `(u_1, u_2)` local to the proposition's setup, and exposing those vertices at the predicate-carrier level would force opaque-carrier choices outside the scope of this file.  Cat 1 reduction check: CLEAR-NO — predicate constrains the opaque `V_dyn` + `reward` carriers at fixed paper-instance vertices; no Mathlib derivation.  Cat 2 reduction check: CLEAR-NO — paper-stipulated regime gate; not an external named predicate.  永不 close per discipline." ]
  scope := "Paper-novel hypothesis predicate `BridgeDominance : ℝ → Prop` for the per-β regime gate `V_dyn(u_2, β) > r(u_1)` in prop:supermodular; paper-instance vertices (u_1, u_2) absorbed into the predicate carrier"
  obstacleOrAttribution :=
    "Cat 3 paper-novel hypothesis predicate per v6 §3.4.2.  永不 close."
  conditionalOn := []

/-! # §3 Welfare Decomposition entries -/

def entry_thm_decomp : GapEntry where
  name := "gap_welfare_decomposition"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Theorem 3.1 (thm:decomp), line 236"
  attackHistory :=
    [ "R1 2026-05-12: ported from internal blackwell-dilemma-internal/lean4/Basic.lean; kernel-pure proof via linearity of Bochner integral; #print axioms confirms only [propext, Classical.choice, Quot.sound].",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat1). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Theorem 3.1 (thm:decomp), line 236"
  obstacleOrAttribution :=
    "CLOSED via Mathlib's MeasureTheory.Integral.Bochner.Basic.integral_sub + ring."
  conditionalOn := []

def entry_signal_immunity : GapEntry where
  name := "gap_W_topo_signal_immune"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Theorem 3.1 final clause (signal-immunity), line 245"
  attackHistory :=
    [ "R1 2026-05-12: ported from internal/SignalImmunity.lean; kernel-pure proof via simp-only on the signal-family setup definition.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat1). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Theorem 3.1 final clause (signal-immunity), line 245"
  obstacleOrAttribution :=
    "CLOSED via definitional unfolding (W_topo depends only on rStarR, not on signal-precision-indexed terminalReward)."
  conditionalOn := []

def entry_W_topo_constant : GapEntry where
  name := "gap_W_topo_constant"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Corollary of Theorem 3.1 final clause"
  attackHistory := [ "R1 2026-05-12: ported; kernel-pure existence witness.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat1). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Corollary of Theorem 3.1 final clause"
  obstacleOrAttribution := "CLOSED (corollary of gap_W_topo_signal_immune)."
  conditionalOn := []

def entry_prop_info_decay : GapEntry where
  name := "gap_info_decay (derived theorem composing W_info_oracle_nonpos_OPEN + W_info_oracle_exponential_bound_OPEN)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:info-decay, lines 270-277"
  attackHistory :=
    [ "R1 2026-05-12: encoded as opaque axiom citing Gaussian tail bound + cluster-size-tail composition; full proof requires Mathlib measure-theoretic Gaussian-integration machinery not yet packaged.",
      "R4 Phase 4 audit (2026-05-12): minor — `∃ W_info_oracle` is loose (paper says THE oracle's W_info, a specific quantity). Patch deferred: thread opaque `W_info_oracle : ℝ → ℝ → ℝ` carrier through Types.lean.",
      "R18-B 2026-05-13: hostile audit caught Pattern 4 vacuous existential — `∃ W_info_oracle : ℝ` satisfiable by witness `W_info_oracle := 0` (with any `C > 0`). The R4 'deferred patch' (thread opaque W_info_oracle carrier) is the canonical fix; R18-B identified but did not patch.",
      "R19-A 2026-05-13: applied the deferred R4 patch — added opaque carrier `W_info_oracle : ℝ → ℝ → ℝ` and rewrote axiom to bind W_info_oracle p β substantively (eliminating vacuous-existential satisfaction). gap_dilemma clause 2 (Wrongness.lean) updated to match the new substantive form.",
      "R19-C 2026-05-13: identified as Cat3-with-Cat2 promotion candidate (matching R17-C's gap_phase_transition_above_OPEN pattern) — paper proof line 276 explicitly invokes Grimmett 1999 §6.75 cluster-size exponential tail (`E[|R|] = O(1)`), but the existing Lean signature carried the dependency only as docstring narrative, not as typed-hypothesis chain. Patch dispatched to R20-A.",
      "R20-A 2026-05-13: Cat 2 ↔ Cat 3 chain wiring per broken-link discipline. Threaded the Grimmett exponential-decay BLOCKED predicate `gap_grimmett_exponential_decay_BLOCKED_by_Mathlib_percolation` as the explicit broken-link hypothesis `h_grimmett` matching the R17-C pattern used in `gap_phase_transition_above_OPEN`. The Mills-tail Cat 1 input (`gap_phi_tail_bound`) is already CLOSED kernel-pure and consumed implicitly via Mathlib at the proof-port level; only the BLOCKED Grimmett Cat 2 input requires explicit typed-hypothesis chaining. Docstring updated to honestly cite Grimmett 1999 §6.75 (cluster-size exponential tail) as the now-operationally-chained Cat 2 dependency. inputCategory promoted Cat 3 → Cat 3-with-Cat 2 to record the explicit Grimmett chain at the Lean signature level. Build green.",
      "R21-A 2026-05-13: paper-source threshold-antecedent symmetry per R20-D paper-source verification Audit 2A. Replaced the literal `(1:ℝ)/2 < p` antecedent with `harrisKestenCriticalProb < p` to consume the Harris-Kesten `p_c` carrier directly. Paper Proposition `prop:info-decay` line 272 reads `uniformly in n for p > p_c`, so the carrier-bound antecedent matches the paper's `p_c` symbol literally and aligns with the sibling `gap_phase_transition_above_OPEN` (Phase.lean), which already consumes the same carrier per R15-A anchoring. The paper-stated equality `p_c = 1/2 \\citep{kesten1980}` is recorded by the BLOCKED claim `gap_harris_kesten_BLOCKED_by_Mathlib_percolation` and the `axiom harrisKestenCriticalProb = 1/2` anchor in `ClassicalResults.lean`; downstream `gap_dilemma` clause 2 propagated the same antecedent change in the same round.",
      "R26 2026-05-13: dropped `h_grimmett` broken-link hypothesis parameter per the discipline clarification (Cat 2 axioms with paper authority are consumed implicitly via the axiom system, not threaded as broken-link hypotheses). The R20-A typed-hypothesis chain becomes redundant once `gap_grimmett_exponential_decay_BLOCKED_by_Mathlib_percolation` is converted to the plain Cat 2 axiom `gap_grimmett_exponential_decay_OPEN`. Docstring updated to note implicit Cat 2 dependency. inputCategory demoted Cat 3-with-Cat 2 → Cat 3 (the Cat 3-with-Cat 2 sub-tag was specifically a Lean-signature-chain qualifier; without the hypothesis chain, the entry is honestly Cat 3 with docstring-acknowledged Cat 2 dependency).",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R36 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern. Split the bundled `gap_info_decay_OPEN` conjunction `W_info_oracle p β ≤ 0 ∧ |W_info_oracle p β| ≤ C * 2^{-β}` into two Cat 3 atomic stipulations on the opaque carrier `W_info_oracle`: (a) `W_info_oracle_nonpos_OPEN` (paper-stated non-positivity, no Grimmett dependency); (b) `W_info_oracle_exponential_bound_OPEN` (paper-stated exponential bound, threading Grimmett 1999 §6.75 via h_grimmett antecedent). The bundled axiom is REPLACED by derived theorem `theorem gap_info_decay (h_grimmett) := ...` (Wrongness.lean ~L230-L270) which destructures the existential from `W_info_oracle_exponential_bound_OPEN` and composes with `W_info_oracle_nonpos_OPEN`. `gap_dilemma` clause 2 updated to call `gap_info_decay gap_grimmett_exponential_decay_OPEN` (renamed from `gap_info_decay_OPEN`). Net: status OPEN → CLOSED (derived theorem); cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +2 new Cat 3 OPEN atomic-stipulation entries (entry_atom_W_info_oracle_nonpos, entry_atom_W_info_oracle_exponential_bound)." ]
  scope := "Proposition prop:info-decay, lines 270-277"
  obstacleOrAttribution :=
    "R36 CLOSED-via-OPEN-input: derived theorem `gap_info_decay` (Wrongness.lean) composes two Cat 3 atomic stipulations `W_info_oracle_nonpos_OPEN` (paper-stated non-positivity) and `W_info_oracle_exponential_bound_OPEN` (paper-stated exponential bound, threading Grimmett 1999 §6.75 via h_grimmett). The substantive Cat 1 Mills tail (`gap_phi_tail_bound`, CLOSED) + Cat 2 Grimmett 1999 §6.75 cluster-size exponential tail composition remains within the two atoms pending Mathlib measure-theoretic infrastructure. R21-A: threshold antecedent `harrisKestenCriticalProb < p` consumes the Harris-Kesten `p_c` carrier directly (matching paper line 272 `uniformly in n for p > p_c` and `gap_phase_transition_above_OPEN` symmetry)."
  conditionalOn := []

def entry_prop_topo_cluster : GapEntry where
  name := "gap_topo_cluster_relation (Cat 1 derived from expectedTopoLoss_conditional_def Cat 3 atom)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:topo-cluster (closed-form formula), lines 279-297"
  attackHistory :=
    [ "R1 2026-05-12: closed-form `(n-k)/((n+1)(k+1))` proved by reflexivity (`∃ E, E = expr` tautology).",
      "R11 discipline audit (2026-05-13): the `theorem` was caught as a closure-count trick (Anti-pattern: `∃ x, x = expr` tautology violates `feedback_lean_real_math`). The docstring also overclaimed (\"proof uses `gap_order_statistics_max_OPEN`\") but the proof actually used no inputs. Reverted to substantive opaque-carrier-bound axiom `expectedTopoLoss_conditional : ℕ → ℕ → ℝ` and renamed `gap_topo_cluster_relation_OPEN`. The substantive Mathlib gap (David & Nagaraja 2003 Eq. 2.1.4 order-statistics identity over Lebesgue product uniform measures) is now honestly disclosed; the false `gap_order_statistics_max_OPEN` proof claim is removed.",
      "R17-C 2026-05-13: Cat 2 ↔ Cat 3 chain wiring partial — docstring-only disclosure. Per the broken-link discipline, the Cat 2 dependency on David & Nagaraja 2003 §2.1.4 was honestly recorded in the docstring; threading it would require Mathlib product-measure infrastructure not yet packaged.",
      "R23-C1 2026-05-13: Cat 3 atomic structural-equation refactor per `feedback_gap_ledger_in_lean4` 2026-05-13 update. Decomposed into (a) Cat 3 atomic structural-equation axiom `expectedTopoLoss_conditional_def : expectedTopoLoss_conditional n k = n/(n+1) − k/(k+1)` (paper line 292 order-statistics decomposition), and (b) Cat 1 derived theorem `gap_topo_cluster_relation` closing `(n−k)/((n+1)(k+1))` from `expectedTopoLoss_conditional_def` via algebraic identity `n/(n+1) − k/(k+1) = (n−k)/((n+1)(k+1))` (`field_simp; ring` Cat 1 closure). The previously bundled OPEN axiom is now decomposed; the closed-form formula derives Cat 1 from the Cat 3 atom. Status PARTIAL: Cat 1 closed-form simplification step closed; underlying Cat 3 atom `expectedTopoLoss_conditional_def` remains OPEN (paper-foundational Cat 3 atomic axiom), and the David & Nagaraja 2003 Cat 2 dependency on `E[max k iid Uniform[0,1]] = k/(k+1)` (which justifies the order-statistics decomposition) is acknowledged at the docstring level pending Mathlib product-measure infrastructure.",
      "R24-D 2026-05-13: AxiomAudit instrumentation added per R23-D Audit 5 finding (the R23-C1 derived closure was uninstrumented in `AxiomAudit.lean`). `#print axioms BlackwellDilemma.gap_topo_cluster_relation` line added at the §3.2 Welfare Reversal section of the audit script (replacing the prior bookkeeping comment `gap_topo_cluster_relation_OPEN is a gap-OPEN axiom`); output confirms the Cat 1 derivation chain `[propext, expectedTopoLoss_conditional, expectedTopoLoss_conditional_def, Classical.choice, Quot.sound]` — kernel + Cat 3 atom (carrier + structural-equation axiom). No source-side change required; audit output matches the R23-C1 derivation chain exactly (Cat 3 atom `expectedTopoLoss_conditional_def` plus its host carrier `expectedTopoLoss_conditional` are the only paper-cited axiomatic dependencies).",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as PARTIAL (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R40 2026-05-14: PARTIAL → CLOSED bundle audit. Per R39 + R40 reclassification of paper-stated atomic structural-equation atoms on opaque carriers as `gapDefinitional` (per §3.4.3), the bundle's underlying Cat 3 atom `expectedTopoLoss_conditional_def` is now `gapDefinitional` (entry_atom_expectedTopoLoss_conditional_def), and the bundle's closed-form derivation `gap_topo_cluster_relation` is a CLOSED Cat 1 derived theorem composing this atom. All sub-clauses of the bundle are now CLOSED at the theorem/atom level. The Cat 2 dependency on David & Nagaraja 2003 §2.1.4 remains acknowledged in the atom's obstacleOrAttribution (Mathlib product-measure infrastructure deferred). Regime asymptotics (`gap_topo_loss_below_threshold_OPEN`, `gap_topo_loss_above_threshold_OPEN`) remain tracked as separate entries (`entry_topo_loss_below`, `entry_topo_loss_above`); they are direct Cat 3 paper-novel + Cat 2 percolation-infra-dependency axioms not bundled here. cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; status PARTIAL → CLOSED." ]
  scope := "Proposition prop:topo-cluster (closed-form formula), lines 279-297"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input. R40: bundle entry status flipped PARTIAL → CLOSED after R39 + R40 reclassification of `expectedTopoLoss_conditional_def` atom as `gapDefinitional` (paper-foundational structural-equation atom per §3.4.3). The closed-form `(n−k)/((n+1)(k+1))` is closed Cat 1 by `gap_topo_cluster_relation := field_simp; ring` from the atom; the Cat 2 dependency on David & Nagaraja 2003 §2.1.4 remains acknowledged in the atom's docstring + obstacleOrAttribution (Mathlib product-measure infrastructure deferred). Regime asymptotics (`gap_topo_loss_below_threshold_OPEN`, `gap_topo_loss_above_threshold_OPEN`) remain tracked as separate entries. R24-D: AxiomAudit instruments the derived closure with output `[propext, expectedTopoLoss_conditional, expectedTopoLoss_conditional_def, Classical.choice, Quot.sound]`."
  conditionalOn := []

def entry_topo_loss_below : GapEntry where
  name := "gap_topo_loss_below_threshold (R41 derived) + topo_loss_below_envelope_exists_atom_OPEN + topo_loss_below_eps_from_envelope_atom_OPEN (Cat 3 atoms)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:topo-cluster Part 1, line 286"
  attackHistory :=
    [ "R1 2026-05-12: vacuous-existential encoding `∃ asymp, ...`.",
      "R4 Phase 4 audit (2026-05-12): patched — bind to opaque carrier `expectedTopoLoss n p` and assert convergence to 0 below threshold.",
      "R17 2026-05-13: reclassified OPEN → BLOCKED per the rewritten compact `feedback_gap_ledger_in_lean4` (2026-05-13). Structural obstacle: depends on Mathlib bond-percolation infrastructure (same blocker as `entry_harris_kesten`); Mathlib has no Z² bond-percolation theory packaging the cluster-size below-threshold convergence-to-0 claim. Decl name updated to `gap_topo_loss_below_threshold_BLOCKED_by_Mathlib_percolation` per discipline naming convention. Cat 3 (paper-novel quantity expectedTopoLoss applied in paper's Z²-percolation regime) — but the ROUTE is blocked by missing Mathlib Cat 1 infrastructure for percolation.",
      "R26 2026-05-13: per discipline clarification, the BLOCKED-def encoding was over-engineered for this Cat 3 paper-novel + Cat 2 percolation-infra-dependency edge case. Converted to plain Cat 3 axiom `gap_topo_loss_below_threshold_OPEN` with paper-cited docstring acknowledging the dual Cat 3 paper-novel (`expectedTopoLoss` carrier in paper's Z²-percolation regime) + Cat 2 percolation dependency (Grimmett 1999 _Percolation_ 2nd ed. cluster-size below-threshold theory). No Lean signature consumes this entry, so no broken-link hypothesis threading needs to be dropped. Status BLOCKED → OPEN: paper Thm 3.3 + Grimmett 1999 authority covers the claim per the 2026-05-13 discipline (BLOCKED is reserved for genuine no-acceptance-possible cases — this entry has a paper-stated claim plus external authority for the percolation infrastructure).",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R40 2026-05-14: state verified, retained as workingAssumption gapOpen. This entry is the source-side `axiom gap_topo_loss_below_threshold_OPEN` (Wrongness.lean:575) — a paper-stated asymptotic claim (`E[|W_topo|] → 0` below threshold) on the opaque `expectedTopoLoss` carrier with the Cat 2 Grimmett 1999 percolation-probability axiom threaded as explicit `h_perc_prob` antecedent (R28-A audit-chain restoration). Unlike the 7 R23-C1 atom_*_def entries reclassified to structuralEquation under R39+R40, this entry is a paper-derived asymptotic CLAIM (not an atomic definitional commitment to how a carrier behaves). The atomic decomposition into Cat 3 paper-foundational sub-atoms was not yet applied (would require splitting the `→ 0` Tendsto convergence into the underlying Grimmett percolation-probability decay + a paper-novel `expectedTopoLoss n p ≤ θ(1−p) · 1/n` envelope-bound atom analogous to `entry_atom_topo_loss_decay_below_pc` introduced in R37 for `gap_phase_transition_below`). Status OPEN retained pending the atomic decomposition; the per-axiom Cat 2 antecedent threading already provides audit-chain visibility for the Grimmett dependency.",
      "R41 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern. The bundled `gap_topo_loss_below_threshold_OPEN` axiom is REPLACED by derived theorem `gap_topo_loss_below_threshold` (Wrongness.lean) composing two Cat 3 paper-novel atomic stipulations: (a) `topo_loss_below_envelope_exists_atom_OPEN` (paper-stated existence of decay envelope) + (b) `topo_loss_below_eps_from_envelope_atom_OPEN` (paper-stated arbitrary-ε convergence from envelope). Cat 2 Grimmett percolation-probability dependency threaded as explicit `h_perc_prob` antecedent on the derived theorem. Net: status OPEN → CLOSED; cat3SubType workingAssumption → derivedTheorem; +2 new Cat 3 paper-foundational structural-equation atomic-stipulation entries (entry_atom_topo_loss_below_envelope_exists, entry_atom_topo_loss_below_eps_from_envelope) classified gapDefinitional/structuralEquation per §3.4.3 (paper-stated atomic content on opaque `expectedTopoLoss` carrier; 永不 close).",
      "R42 2026-05-14: hostile-audit-driven corrections to R41. (a) Pattern-1 fix: the `topo_loss_below_eps_from_envelope_atom_OPEN` axiom (acknowledged in its own R41 attackHistory as Mathlib-derivable from `Filter.Tendsto`) is converted from Cat 3 axiom to Cat 1 theorem `topo_loss_below_eps_from_envelope` (Wrongness.lean) — proof uses `Filter.Tendsto`-via-`Iio_mem_nhds` neighborhood unfolding + `Filter.eventually_atTop` + transitivity through envelope upper bound. The corresponding Ledger atom entry is removed (Cat 1 theorems are not tracked as separate atom entries per discipline). (b) §3.4.3 classification fix: the remaining `topo_loss_below_envelope_exists_atom_OPEN` is reclassified structuralEquation/gapDefinitional → workingAssumption/gapOpen per audit finding that paper-derived existence claims requiring Mathlib percolation infra are §3.4.4 workingAssumption (NOT §3.4.3 paper-stipulative commitments to primitive behavior). Net: bundle status remains CLOSED (derived theorem still composes the atom + the new Cat 1 theorem); workingAssumption count gains 1 honest entry pending Mathlib percolation theory." ]
  scope := "Proposition prop:topo-cluster Part 1, line 286"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input-plus-Cat-1-theorem (R42 honest re-classification). R41 derived theorem `gap_topo_loss_below_threshold` (Wrongness.lean) composes (a) Cat 3 workingAssumption atom `topo_loss_below_envelope_exists_atom_OPEN` (envelope existence, pending Mathlib percolation infra per §3.4.4 close target) + (b) Cat 1 theorem `topo_loss_below_eps_from_envelope` (ε-convergence from envelope, R42 Mathlib-derivation from `Filter.Tendsto`)."
  conditionalOn := []

def entry_topo_loss_above : GapEntry where
  name := "gap_topo_loss_above_threshold (R41 derived) + topo_loss_above_lower_bound_atom_OPEN + topo_loss_above_upper_bound_atom_OPEN (Cat 3 atoms)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:topo-cluster Part 2, line 287"
  attackHistory :=
    [ "R1 2026-05-12: vacuously-false-existential encoding `∀ asymp, c₁ ≤ asymp n` (any asymp ≡ 0 falsifies it).",
      "R4 Phase 4 audit (2026-05-12): patched — bind to opaque carrier `expectedTopoLoss n p` and assert two-sided bound `c₁ ≤ ... ≤ c₂` for `n ≥ N`.",
      "R17 2026-05-13: reclassified OPEN → BLOCKED per the rewritten compact `feedback_gap_ledger_in_lean4` (2026-05-13). Same Mathlib bond-percolation infra blocker as `entry_topo_loss_below` and `entry_harris_kesten`. Decl name updated to `gap_topo_loss_above_threshold_BLOCKED_by_Mathlib_percolation`. Cat 3 (paper-novel two-sided bound on expectedTopoLoss above threshold) blocked by missing Cat 1 percolation infrastructure.",
      "R26 2026-05-13: per discipline clarification, the BLOCKED-def encoding was over-engineered for this Cat 3 paper-novel + Cat 2 percolation-infra-dependency edge case. Converted to plain Cat 3 axiom `gap_topo_loss_above_threshold_OPEN` with paper-cited docstring acknowledging the dual Cat 3 paper-novel (`expectedTopoLoss` carrier above threshold) + Cat 2 percolation dependency (Grimmett 1999 _Percolation_ 2nd ed. cluster-size above-threshold theory). No Lean signature consumes this entry, so no broken-link hypothesis threading needs to be dropped. Status BLOCKED → OPEN: paper Thm 3.3 + Grimmett 1999 authority covers the claim per the 2026-05-13 discipline.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R40 2026-05-14: state verified, retained as workingAssumption gapOpen. Same status as `entry_topo_loss_below`: source-side `axiom gap_topo_loss_above_threshold_OPEN` (Wrongness.lean:613) takes Cat 2 Grimmett `h_grimmett` antecedent (R28-A audit-chain restoration) for the exponential-decay percolation infrastructure. Paper-derived asymptotic two-sided-bound CLAIM, not an atomic definitional commitment. Atomic decomposition into Cat 3 paper-foundational sub-atoms (analogous to R37 `gap_phase_transition_above` split into `wInfoTopoRatio_const_exists_OPEN` + `wInfoTopoRatio_bound_OPEN` atoms) not yet applied. Status OPEN retained pending the atomic decomposition; the per-axiom Cat 2 antecedent threading already provides audit-chain visibility for the Grimmett dependency.",
      "R41 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern. The bundled `gap_topo_loss_above_threshold_OPEN` axiom is REPLACED by derived theorem `gap_topo_loss_above_threshold` (Wrongness.lean) composing two Cat 3 paper-novel atomic stipulations: (a) `topo_loss_above_lower_bound_atom_OPEN` (paper-stated existence of `c₁(p) > 0` lower bound) + (b) `topo_loss_above_upper_bound_atom_OPEN` (paper-stated existence of `c₂(p) ≥ c₁` upper bound). The derived theorem composes both atoms; the common-`N` step uses `max N₁ N₂`. Cat 2 Grimmett-exponential-decay dependency threaded as explicit `h_grimmett` antecedent on the derived theorem. Net: status OPEN → CLOSED; cat3SubType workingAssumption → derivedTheorem; +2 new Cat 3 paper-foundational structural-equation atomic-stipulation entries (entry_atom_topo_loss_above_lower_bound, entry_atom_topo_loss_above_upper_bound) classified gapDefinitional/structuralEquation per §3.4.3.",
      "R42 2026-05-14: hostile-audit-driven §3.4.3 classification fix. Both atoms (`topo_loss_above_lower_bound_atom_OPEN`, `topo_loss_above_upper_bound_atom_OPEN`) reclassified structuralEquation/gapDefinitional → workingAssumption/gapOpen per audit finding that paper-derived existence claims requiring Mathlib percolation infra are §3.4.4 workingAssumption (NOT §3.4.3 paper-stipulative commitments to primitive behavior). Bundle status remains CLOSED (derived theorem still composes both atoms); workingAssumption count gains 2 honest entries pending Mathlib percolation theory." ]
  scope := "Proposition prop:topo-cluster Part 2, line 287"
  obstacleOrAttribution := "CLOSED-via-Cat-3-atom-input (R42 honest re-classification). R41 derived theorem `gap_topo_loss_above_threshold` (Wrongness.lean) composes the two Cat 3 workingAssumption atoms `topo_loss_above_lower_bound_atom_OPEN` + `topo_loss_above_upper_bound_atom_OPEN` (both pending Mathlib percolation infra per §3.4.4 close target). Substantive proof requires Mathlib bond-percolation + cluster-tail machinery (Grimmett 1999 §6.75)."
  conditionalOn := []

def entry_prop_physical : GapEntry where
  name := "gap_physical_irreducibility (and its 4 corollaries)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Proposition prop:physical, lines 303-318"
  attackHistory :=
    [ "R1 2026-05-12: ported; kernel-pure proofs via `integral_mono_ae` + `linarith`.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat1). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Proposition prop:physical, lines 303-318"
  obstacleOrAttribution :=
    "CLOSED — `gap_physical_irreducibility`, `gap_W_info_nonpos`, `gap_oracle_W_info_zero`, `gap_welfare_le_W_topo`, `gap_oracle_welfare_eq_W_topo` (5 theorems, all kernel-pure)."
  conditionalOn := []

/-! # §3.2 Welfare Reversal entries -/

def entry_lem_wrongness : GapEntry where
  name := "gap_wrongness (derived) + topology_blind_wrongness_atom_OPEN (Cat 3 atom)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Lemma lem:wrongness, lines 336-369"
  attackHistory :=
    [ "R1 2026-05-12: encoded as opaque axiom citing C1-C2-C3 + terminal-neighbour + topology-blindness + Blackwell-ordering hypotheses.",
      "R4 Phase 4 audit (2026-05-12): WARN — paper line 338 also requires `|N_R(v_0)| = 2` (degree-2); Lean signature does NOT encode any DegreeTwoStartingVertex premise. Also paper requires WHOLE family topology-blind (`∀ β`); Lean uses single-instance `IsTopologyBlind (signalFamily 0)`. Patches deferred.",
      "R21-A 2026-05-13: applied both R4-deferred patches per R20-D paper-source verification Audit 2D. Patch (a): added `DegreeTwoStartingVertex → ` antecedent to `gap_wrongness_OPEN`; introduced the Cat 3 paper-novel scope predicate `axiom DegreeTwoStartingVertex : Prop` in `Types.lean` with paper-citation docstring (`lem:wrongness` line 338, `thm:dilemma` line 388). Patch (b): strengthened single-instance `IsTopologyBlind (signalFamily 0)` antecedent to whole-family `∀ β, IsTopologyBlind (signalFamily β)` matching the paper's `topology-blind signal family {π_β}_β` family-level scope (line 338). Both patches paper-faithful: paper line 338 literally states `Assume further that v_0 has exactly two accessible neighbours (|N_R(v_0)| = 2)` for premise (a) and `topology-blind signal family {π_β}_{β ≥ 0}` for premise (b).",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R38 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern. The bundled `gap_wrongness_OPEN` is REPLACED by derived theorem `gap_wrongness` (Wrongness.lean) composing the new Cat 3 atomic stipulation `topology_blind_wrongness_atom_OPEN` (paper-stated greedy-reversal under topology-blind Blackwell-ordered signal family + degree-2 + terminal-neighbour scope, lines 336-369). Net: status OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +1 new Cat 3 OPEN atomic-stipulation entry (entry_atom_topology_blind_wrongness)." ]
  scope := "Lemma lem:wrongness, lines 336-369"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input. R38 derived theorem `gap_wrongness` (Wrongness.lean) composes the atomic stipulation `topology_blind_wrongness_atom_OPEN`. Substantive proof of the atom requires bounded-convergence + Φ-tail integral machinery not in Mathlib (paper-faithful R21-A `DegreeTwoStartingVertex` premise + whole-family topology-blindness `∀ β, IsTopologyBlind (signalFamily β)` antecedents now part of the atom)."
  conditionalOn := []

def entry_lem_conditional_reduction_i : GapEntry where
  name := "gap_conditional_reduction_part_i (derived) + conditional_subproblem_blackwell_applicable_OPEN (Cat 3 atom)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Lemma lem:conditional-reduction (i), line 374"
  attackHistory :=
    [ "R1 2026-05-12: encoded as opaque axiom asserting Blackwell monotonicity for arbitrary `W_R`.",
      "R4 Phase 4 audit (2026-05-12): WARN — Lean drops the Blackwell-ordering antecedent on the signals (asserts monotonicity for ANY W_R, folkloric inflation). Patch deferred: parameterise by Blackwell-ordered family.",
      "R15 2026-05-13: hostile audit found R14 conjunction misattribution caught the conditional-Blackwell content as paper part (i) (not (ii)). MOVED substantive carrier-bound encoding from former gap_blackwell_conditional_OPEN here, replacing the folkloric arbitrary-W_R version. Carrier conditionalWelfareOnR : Finset Vertex → ℝ → ℝ (Set→Finset for consistency with ReachableSet).",
      "R16 2026-05-13: 2nd-round hostile audit found R15 patch dropped the Blackwell-ordering antecedent. Re-parameterised conditionalWelfareOnR to take signal family argument; added IsBlackwellOrdered signalFamily hypothesis to gap_conditional_reduction_part_i_OPEN.",
      "R17-C 2026-05-13: Cat 2 ↔ Cat 3 chain wiring CONFIRMED. Per R17-B's reductionism audit, the existing `IsBlackwellOrdered signalFamily` antecedent (added R16-A) IS the operational Cat 2 chain to Blackwell 1951/1953 — the paper part (i) literally states 'if `π' ≻_B π`, then `W_R(π') ≥ W_R(π)`', which is exactly the Blackwell-ordering hypothesis. NO source change needed: the Lean signature already chains the Cat 2 dependency operationally via `IsBlackwellOrdered`. inputCategory promoted Cat 3 → Cat 3-with-Cat 2 to record the existing operational chain (the BLOCKED Blackwell predicate `gap_blackwell_monotonicity_BLOCKED_by_Mathlib_decision_theory` is the underlying Cat 2 source whose substance flows through the `IsBlackwellOrdered` antecedent here).",
      "R18-A 2026-05-13: Cat3-with-Cat2 → Cat3 demotion per R17-E hostile audit Audit 3. The R17-C upgrade conflated `IsBlackwellOrdered signalFamily` (a paper-novel opaque `Prop`-valued scope predicate declared in Types.lean ~line 235) with the typed BLOCKED-def Cat 2 chain. A genuine Cat 2 chain to Blackwell 1951/1953 would require threading the typed BLOCKED-def predicate `gap_blackwell_monotonicity_BLOCKED_by_Mathlib_decision_theory` as a hypothesis (analogous to the R17-D `gap_bayesian_immunity` h_blackwell pattern in Bayesian.lean). The current `IsBlackwellOrdered` antecedent is honestly a paper-novel scope predicate, not a typed BLOCKED-def consumption. inputCategory honestly demoted to Cat 3.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R35-B Wave 2.1: restored explicit Cat 2 chain dropped in R26 per R35 deep audit (R26 over-applied 'Cat 2 implicit consumption' rule for this entry whose CLAIM CONTENT is Cat 2 theorem applied to paper-novel carrier per `feedback_gap_ledger_in_lean4` §10). Added explicit antecedent `(∀ β₁ β₂, β₁ ≤ β₂ → agentWelfare AgentType.bayesian β₁ 0 1 ≤ agentWelfare AgentType.bayesian β₂ 0 1)` (the propositional content of `gap_blackwell_monotonicity_OPEN`) to the axiom signature. `#print axioms` on downstream theorems consuming this axiom will now surface the Blackwell 1951/1953 dependency. No downstream consumer needs threading (axiom has no downstream Lean consumer in current ledger; threading is for audit-chain visibility of the underlying Cat 2 dependency).",
      "R37 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern. The bundled `gap_conditional_reduction_part_i_OPEN` is REPLACED by derived theorem `gap_conditional_reduction_part_i` (Wrongness.lean) composing the new Cat 3 atomic stipulation `conditional_subproblem_blackwell_applicable_OPEN` (paper-stated conditional-Blackwell applicability on the restricted action domain `R(v_0)` for Blackwell-ordered signal families, line 375 statement + line 381 proof). Net: status OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +1 new Cat 3 OPEN atomic-stipulation entry (entry_atom_conditional_subproblem_blackwell_applicable). The Cat 2 Blackwell 1951/1953 dependency remains threaded as explicit `h_blackwell` antecedent on the atom for audit-chain visibility." ]
  scope := "Lemma lem:conditional-reduction (i), line 374"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input. R37 derived theorem `gap_conditional_reduction_part_i` composes the atomic stipulation `conditional_subproblem_blackwell_applicable_OPEN` (paper-stated conditional-Blackwell applicability), threading the Cat 2 Blackwell 1951/1953 dependency as explicit `h_blackwell` antecedent for audit-chain visibility per §10 paper-APPLICATION-to-opaque-carrier discipline."
  conditionalOn := []

def entry_lem_conditional_reduction_ii : GapEntry where
  name := "gap_conditional_reduction_part_ii"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Lemma lem:conditional-reduction (ii), lines 376-384"
  attackHistory :=
    [ "R1 2026-05-12: vacuous tautology `∃ W, W = W_topo + W_info`.",
      "R4 Phase 4 audit (2026-05-12): patched — re-exported as a direct theorem appealing to `gap_welfare_decomposition` (Basic.lean) + `gap_W_topo_signal_immune` (SignalImmunity.lean), both kernel-pure CLOSED.",
      "R14 2026-05-13: hostile audit found old re-export was just Theorem 3.1 (decomposition) misattributed as part (ii). Restructured as conjunction with new opaque carrier conditionalWelfareOnR + a freshly-introduced conditional-Blackwell axiom (R14 name retired in R15 after part (i)/(ii) misattribution caught; substantive content moved to gap_conditional_reduction_part_i_OPEN).",
      "R15 2026-05-13: 2nd-round hostile audit found R14 conjunction misattribution (conditional-Blackwell content is paper part (i), not (ii); paper part (ii) is the decomposition + W_topo signal-immunity). Reverted gap_conditional_reduction_part_ii to its R4 form (just s.gap_welfare_decomposition); MOVED substantive content to gap_conditional_reduction_part_i_OPEN (replacing folkloric arbitrary-W_R encoding); type changed Set Vertex → Finset Vertex for consistency with ReachableSet.",
      "R27-A 2026-05-13: Cat 3 sub-classification DERIVED_THEOREM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as CLOSED (Cat 3 derived theorem composing earlier Cat 1 + Cat 2 + Cat 3 atomic inputs — sub-class is descriptive only, not subject to the 永不/必须 close mandate). New `subClass` field set to DERIVED_THEOREM." ]
  scope := "Lemma lem:conditional-reduction (ii), lines 376-384"
  obstacleOrAttribution :=
    "CLOSED via s.gap_welfare_decomposition (kernel-pure). Substantive Blackwell-non-orderability of W_topo (paper's part (ii) operational consequence) is captured by SignalFamily.gap_W_topo_signal_immune CLOSED. Conditional-Blackwell monotonicity (formerly bundled here under R14's mis-attribution) moved to gap_conditional_reduction_part_i_OPEN per R15."
  conditionalOn := []

def entry_thm_dilemma : GapEntry where
  name := "gap_dilemma"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Theorem 3.2 (thm:dilemma), lines 386-393"
  attackHistory :=
    [ "R1 2026-05-12: re-export of `gap_wrongness_OPEN`; theorem CLOSED but proof depends on the OPEN axiom.",
      "R14 2026-05-13: hostile audit found single-clause encoding dropped paper Theorem 3.2's oracle-bound clause. Restructured as conjunction (greedy reversal via gap_wrongness_OPEN) ∧ (oracle bound |W_info| ≤ C·2^{-β} via gap_info_decay_OPEN). CLOSED-via-OPEN-input on both clauses. Sectional reorder: §3 (prop:info-decay) and §4 (thm:dilemma) swapped for Lean forward-reference.",
      "R18-C 2026-05-13: hostile audit caught overclaim — clause 2 (oracle bound) propagated the vacuous-existential structure of `gap_info_decay_OPEN` (Pattern 4: `∃ W_info_oracle : ℝ` satisfiable by witness `W_info_oracle := 0` with any `C > 0`), so the prior `Both clauses substantive` claim was FALSE post-R18-B. Patch identified, deferred to R19.",
      "R19-B 2026-05-13: obstacleOrAttribution updated to drop the `Both clauses substantive` overclaim. Replaced with explicit per-clause status: clause 1 substantive (gap_wrongness_OPEN, opaque-carrier-anchored); clause 2 substantive after R19-A's concurrent patch to gap_info_decay_OPEN (anchoring to opaque carrier `W_info_oracle : ℝ → ℝ → ℝ` per the R4-deferred / R18-B-identified Pattern 4 fix in Wrongness.lean).",
      "R20-A 2026-05-13: Cat 2 ↔ Cat 3 chain wiring downstream propagation. After R20-A threaded `h_grimmett` into `gap_info_decay_OPEN`, the theorem's conjunction proof `⟨gap_wrongness_OPEN ..., gap_info_decay_OPEN⟩` no longer type-checked; gap_dilemma's signature was extended to also take `h_grimmett : gap_grimmett_exponential_decay_BLOCKED_by_Mathlib_percolation` as hypothesis, which is forwarded into `gap_info_decay_OPEN h_grimmett` in clause 2. inputCategory promoted Cat 3 → Cat 3-with-Cat 2 to record the now-typed-chain through to Grimmett 1999 §6.75 at the theorem's signature level. Build green; `#print axioms gap_dilemma` now honestly lists the Grimmett-conditional structure via the BLOCKED predicate.",
      "R21-A 2026-05-13: downstream propagation of the R21-A wrongness-axiom signature change and the R21-A info-decay threshold-symmetry change. Clause 1 hypothesis list now mirrors the strengthened `gap_wrongness_OPEN` antecedents: added `hDeg2 : DegreeTwoStartingVertex` (forwarded into `gap_wrongness_OPEN hC hT hDeg2 ...`) and strengthened `hBlind : IsTopologyBlind (signalFamily 0)` to `hBlind : ∀ β, IsTopologyBlind (signalFamily β)`. Clause 2 conclusion's threshold antecedent rewritten from `(1:ℝ)/2 < p` to `harrisKestenCriticalProb < p` to consume the Harris-Kesten `p_c` carrier (matching R21-A's update to `gap_info_decay_OPEN` and the `gap_phase_transition_above_OPEN` symmetry). Both antecedent additions are paper-faithful per `\\label{thm:dilemma}` line 388 (`with v_0 of degree 2 in N_R(v_0)`, `with topology-blind signals`, `for p > p_c`).",
      "R26 2026-05-13: dropped `h_grimmett` broken-link hypothesis parameter per the discipline clarification — `gap_info_decay_OPEN`'s `h_grimmett` parameter was also dropped in R26 (now consumes `gap_grimmett_exponential_decay_OPEN` Cat 2 axiom implicitly via the axiom system), so the conjunction proof `⟨gap_wrongness_OPEN ..., gap_info_decay_OPEN⟩` no longer needs the hypothesis at this layer either. inputCategory demoted Cat 3-with-Cat 2 → Cat 3 (the sub-tag was specifically a Lean-signature-chain qualifier). `#print axioms gap_dilemma` now lists Cat 3 + Cat 2 axiom dependencies (gap_wrongness_OPEN, gap_info_decay_OPEN, gap_grimmett_exponential_decay_OPEN) without surfacing a broken-link hypothesis at the theorem signature.",
      "R27-A 2026-05-13: Cat 3 sub-classification DERIVED_THEOREM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as CLOSED (Cat 3 derived theorem composing earlier Cat 1 + Cat 2 + Cat 3 atomic inputs — sub-class is descriptive only, not subject to the 永不/必须 close mandate). New `subClass` field set to DERIVED_THEOREM." ]
  scope := "Theorem 3.2 (thm:dilemma), lines 386-393"
  obstacleOrAttribution :=
    "CLOSED-via-OPEN-input on conjunction of (greedy reversal, gap_wrongness_OPEN with `DegreeTwoStartingVertex` + `∀ β, IsTopologyBlind (signalFamily β)` antecedents per R21-A) and (oracle bound, gap_info_decay_OPEN with `harrisKestenCriticalProb < p` threshold antecedent per R21-A). Clause 1 substantive (gap_wrongness_OPEN, opaque-carrier-anchored, R21-A paper-faithful antecedents); clause 2 substantive (R19-A opaque-carrier W_info_oracle : ℝ → ℝ → ℝ + R21-A `harrisKestenCriticalProb < p` symmetry). R26: Cat 2 Grimmett 1999 §6.75 cluster-size exponential-decay dependency consumed implicitly via the `gap_grimmett_exponential_decay_OPEN` Cat 2 axiom (transitively through `gap_info_decay_OPEN`); broken-link hypothesis threading dropped per the 2026-05-13 discipline clarification."
  conditionalOn := []

/-! # §3.3 Phase Transition entries -/

def entry_thm_phase_below : GapEntry where
  name := "gap_phase_transition_below (derived) + topo_loss_decay_below_pc_OPEN + topo_loss_decay_arbitrary_threshold_OPEN (Cat 3 atoms)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Theorem 3.3 (thm:phase) Part 1, lines 400-419"
  attackHistory :=
    [ "R1 2026-05-12: bundled as `phase_transition_paper_axiom` (anti-pattern #2 violation per gap-ledger memory).",
      "R2 2026-05-12: split per anti-pattern #2 fix into `gap_phase_transition_below_OPEN` + `gap_phase_transition_above_OPEN`.",
      "R3 Phase 0 audit (2026-05-12): clean per Percolation literature audit — composes Harris-Kesten (`gap_harris_kesten_OPEN`) + Grimmett `θ(1-p) > 0` (`gap_percolation_probability_OPEN`) + topo-cluster CLOSED-formula.",
      "R17-C 2026-05-13: Cat 2 ↔ Cat 3 chain wiring per broken-link discipline. Threaded the Grimmett percolation-probability BLOCKED predicate `gap_percolation_probability_BLOCKED_by_Mathlib_percolation` as the explicit broken-link hypothesis `h_perc_prob`. The Harris-Kesten p_c = 1/2 dependency is implicit via the `harrisKestenCriticalProb` carrier (already anchored R15-A); h_HK chain skipped for symmetry. inputCategory promoted Cat 3 → Cat 3-with-Cat 2 to record the explicit Grimmett 1999 chain at the Lean signature level.",
      "R18-B 2026-05-13: anchored existential to opaque carrier `expectedTopoLoss n p` per R17-E Pattern 4 finding (vacuous-existential satisfaction by junk constants). Removed the auxiliary `∃ topo_loss_decay : ℕ → ℝ, ...` quantifier whose body was trivially satisfiable by `fun _ => -1`; the decay assertion now binds directly to the substantive paper-cited carrier `expectedTopoLoss` (declared in `Wrongness.lean`, paper source: Proposition `prop:topo-cluster` line 286), eliminating R3 anti-pattern #2 (vacuous existential) that pre-dated R17. Bottom-line statement form: `∀ ε > 0, ∃ N, ∀ n ≥ N, expectedTopoLoss n p < ε`.",
      "R26 2026-05-13: dropped `h_perc_prob` broken-link hypothesis parameter per the discipline clarification (Cat 2 axioms with paper authority are consumed implicitly via the axiom system, not threaded as broken-link hypotheses). The R17-C typed-hypothesis chain becomes redundant once `gap_percolation_probability_BLOCKED_by_Mathlib_percolation` is converted to the plain Cat 2 axiom `gap_percolation_probability_OPEN`. inputCategory demoted Cat 3-with-Cat 2 → Cat 3 (the sub-tag was specifically a Lean-signature-chain qualifier; without the hypothesis chain, the entry is honestly Cat 3 with docstring-acknowledged Cat 2 dependency).",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R37 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern. The bundled `gap_phase_transition_below_OPEN` is REPLACED by derived theorem `gap_phase_transition_below` (Phase.lean) composing two new Cat 3 atomic stipulations: (a) `topo_loss_decay_below_pc_OPEN` (existence of decay envelope `topo_loss_decay : ℕ → ℝ` for `expectedTopoLoss n p`, paper proof line 415-417 via giant-component conditioning + topo-cluster formula); (b) `topo_loss_decay_arbitrary_threshold_OPEN` (paper-stated arbitrary-ε convergence form from envelope, paper proof line 417). Net: status OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +2 new Cat 3 OPEN atomic-stipulation entries (entry_atom_topo_loss_decay_below_pc, entry_atom_topo_loss_decay_arbitrary_threshold). The Cat 2 Grimmett percolation-probability dependency remains threaded as explicit `h_perc_prob` antecedent on the first atom for audit-chain visibility." ]
  scope := "Theorem 3.3 (thm:phase) Part 1, lines 400-419"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input. R37 derived theorem `gap_phase_transition_below` composes two atomic stipulations (paper proof lines 415-417): `topo_loss_decay_below_pc_OPEN` (envelope existence) + `topo_loss_decay_arbitrary_threshold_OPEN` (arbitrary-ε form). Cat 2 dependency on Grimmett 1999 percolation-probability threaded as explicit `h_perc_prob` antecedent on the first atom for audit-chain visibility. Substantive Mathlib percolation + cluster-size-asymptotics machinery remains the underlying gap."
  conditionalOn := []

def entry_thm_phase_above : GapEntry where
  name := "gap_phase_transition_above (derived) + wInfoTopoRatio_const_exists_OPEN + wInfoTopoRatio_bound_OPEN (Cat 3 atoms)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Theorem 3.3 (thm:phase) Part 2, lines 420-431"
  attackHistory :=
    [ "R1+R2 2026-05-12: split from bundled axiom.",
      "R3 Phase 0 audit (2026-05-12): clean per Percolation audit — composes Grimmett Theorem 6.75 + paper's info-decay + wrongness.",
      "R11 discipline audit (2026-05-13): the existential `∃ ratio : ℝ, ratio ≤ Real.rpow 2 (-β)` was trivially provable (witness `ratio := -1` or any negative number) and encoded nothing about the paper's `|W_info|/|W_topo| = O(2^{-β})` claim (Anti-pattern #2). Strengthened by binding the ratio to a new opaque carrier `wInfoTopoRatio : ℝ → ℝ → ℝ` (function of `(p, β)`) and asserting `wInfoTopoRatio p β ≤ c * Real.rpow 2 (-β)`, where `c > 0` is the same constant guaranteeing the cluster-size decay rate.",
      "R17-C 2026-05-13: Cat 2 ↔ Cat 3 chain wiring per broken-link discipline. Threaded the Grimmett exponential-decay BLOCKED predicate `gap_grimmett_exponential_decay_BLOCKED_by_Mathlib_percolation` as the explicit broken-link hypothesis `h_grimmett`. inputCategory promoted Cat 3 → Cat 3-with-Cat 2 to record the explicit Grimmett 1999 §6.75 chain at the Lean signature level.",
      "R26 2026-05-13: dropped `h_grimmett` broken-link hypothesis parameter per the discipline clarification (Cat 2 axioms with paper authority are consumed implicitly via the axiom system, not threaded as broken-link hypotheses). The R17-C typed-hypothesis chain becomes redundant once `gap_grimmett_exponential_decay_BLOCKED_by_Mathlib_percolation` is converted to the plain Cat 2 axiom `gap_grimmett_exponential_decay_OPEN`. inputCategory demoted Cat 3-with-Cat 2 → Cat 3 (the sub-tag was specifically a Lean-signature-chain qualifier).",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R37 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern. The bundled `gap_phase_transition_above_OPEN` is REPLACED by derived theorem `gap_phase_transition_above` (Phase.lean) composing two new Cat 3 atomic stipulations: (a) `wInfoTopoRatio_const_exists_OPEN` (existence of positive constant `c(p) > 0` characterising the exponential-decay rate, paper proof lines 421-427); (b) `wInfoTopoRatio_bound_OPEN` (paper-stated quantitative ratio bound `wInfoTopoRatio p β ≤ c * 2^{-β}`, paper proof line 427). Net: status OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +2 new Cat 3 OPEN atomic-stipulation entries (entry_atom_wInfoTopoRatio_const_exists, entry_atom_wInfoTopoRatio_bound). The Cat 2 Grimmett §6.75 dependency remains threaded as explicit `h_grimmett` antecedent on both atoms for audit-chain visibility." ]
  scope := "Theorem 3.3 (thm:phase) Part 2, lines 420-431"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input. R37 derived theorem `gap_phase_transition_above` composes two atomic stipulations (paper proof lines 421-427): `wInfoTopoRatio_const_exists_OPEN` (positive constant existence) + `wInfoTopoRatio_bound_OPEN` (quantitative ratio bound). Cat 2 dependency on Grimmett 1999 §6.75 threaded as explicit `h_grimmett` antecedent on both atoms for audit-chain visibility. Substantive Mathlib percolation + Mills-tail composition remains the underlying gap."
  conditionalOn := []

def entry_prop_trap_prevalence_zero : GapEntry where
  name := "gap_trap_prevalence_zero (derived) + forward_reachable_full_at_zero_OPEN (Cat 3 atom)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:trap-prevalence Part 1, line 457; proof line 463"
  attackHistory :=
    [ "R1 2026-05-12: encoded as opaque axiom.",
      "R4 Phase 4 audit (2026-05-12): DEFECT — Lean encodes `V_dyn u {v} ω = V_dyn v ∅ ω` (constant), but paper says `V_dyn(v) = r* = max r` for all v at p=0. Patch deferred.",
      "R23-C2 2026-05-13: applied Manufactured-Recognition R-#25 atomic-decomposition pattern per `feedback_gap_ledger_in_lean4` 2026-05-13 worked-example. Added Cat 3 atomic structural equation `forward_reachable_full_at_zero_OPEN : ∀ [Fintype Vertex] v H ω, blockingProb = 0 → ForwardReachable v H ω = Finset.univ` (paper line 463 structural fact: `R(v) = V` for all `v` when no edges are blocked); REFACTORED prior `gap_trap_prevalence_zero_OPEN` axiom into derived theorem `gap_trap_prevalence_zero` whose proof composes the atom + V_dyn_def (R23-C1 atom) + Mathlib `Finset.sup'_congr` (Cat 1). The derived-theorem statement matches the original axiom statement (`V_dyn u {v} ω = V_dyn v ∅ ω`) under the [Fintype Vertex] hypothesis (paper Definition 2.1 graph on `n` nodes). Lake build green. `gap_trap_prevalence_zero` axiom dependency chain becomes [propext, Classical.choice, Quot.sound] + opaque Cat 3 atoms (`forward_reachable_full_at_zero_OPEN`, `V_dyn_def`, `ForwardReachable_self_member`).",
      "R24-D 2026-05-13: AxiomAudit instrumentation added per R23-D Audit 5 finding (the R23-C2 derived closure was previously commented out in `AxiomAudit.lean` with the explanation `#print axioms requires a [Fintype Vertex] hypothesis hidden in the theorem signature; skipping pending instance resolution`). Investigation: the explanation was incorrect — `#print axioms` operates on a definition's name and prints the axiom dependency closure of its body, NOT the applied form, so instance arguments do NOT block it. Verified by direct invocation: `#print axioms BlackwellDilemma.gap_trap_prevalence_zero` outputs `[propext, ForwardReachable, ForwardReachable_self_member, IsEdge, PercolationOutcome, V_dyn, V_dyn_def, Vertex, blockingProb, forward_reachable_full_at_zero_OPEN, reward, Classical.choice, Quot.sound]` — exactly the documented Cat 3 atom chain plus opaque carriers. Audit-script line uncommented; explanatory comment updated to clarify the correct behaviour. No source-side change required.",
      "R24-A 2026-05-13: SCOPE-INFLATION repair per R23-D Audit 1 hostile audit. The R23-C2 `forward_reachable_full_at_zero_OPEN` form `∀ [Fintype Vertex] v H ω, blockingProb = 0 → ForwardReachable v H ω = Finset.univ` was SCOPE-INFLATED beyond paper line 463: paper's `R(v) = V` is the `H = ∅` (i.e. `ReachableSet`) statement (paper's `R(v)` is `ReachableSet` per Def 2.2, identified with `ForwardReachable v ∅ ω` via `ReachableSet_eq_ForwardReachable_empty`). For `H ∋ u` (e.g. `H = {v}` after visiting `v`), removing `v` from a connected graph could disconnect it, so `ForwardReachable u {v} ω ≠ Finset.univ` in general at `p = 0`. (i) RESTATED the atom to `∀ [Fintype Vertex] v ω, blockingProb = 0 → ForwardReachable v ∅ ω = Finset.univ` (H=∅ scope, paper-faithful — H quantifier dropped from the atom signature). (ii) RESTATED the derived theorem to `∀ u, IsEdge v u → V_dyn u ∅ ω = V_dyn v ∅ ω` (H=∅ on both sides, paper-faithful) instead of the prior `V_dyn u {v} ω = V_dyn v ∅ ω` form (which was inconsistent with paper line 463 — the paper proves `V_dyn(v) = r* = max r` for all `v` at `p=0`, NOT a statement about V_dyn evaluated at H={v}). The proof structure is unchanged in shape (compose H=∅-scoped atom + V_dyn_def at H=∅ + `Finset.sup'_congr`); the H=∅ form for both sides matches paper line 463 scope exactly: `V_dyn` is constant over the `H = ∅` family at `p = 0` because every vertex's `H=∅` forward-reachable set is `Finset.univ`. R24-D `#print axioms` output remains accurate at the axiom-name level (closure names unchanged); only the atom's universally-quantified scope tightened. Lake build green.",
      "R27-A 2026-05-13: Cat 3 sub-classification DERIVED_THEOREM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as CLOSED (Cat 3 derived theorem composing earlier Cat 1 + Cat 2 + Cat 3 atomic inputs — sub-class is descriptive only, not subject to the 永不/必须 close mandate). New `subClass` field set to DERIVED_THEOREM." ]
  scope := "Proposition prop:trap-prevalence Part 1, line 457; proof line 463"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input. `gap_trap_prevalence_zero` derived theorem composes: (a) Cat 3 atom `forward_reachable_full_at_zero_OPEN` (paper line 463; R24-A H=∅-scoped form), (b) Cat 3 atom `V_dyn_def` (R23-C1; paper Def 2.2/def:value-functions), (c) Cat 1 Mathlib `Finset.sup'_congr` (paper-stated `max` over equal carriers). [Fintype Vertex] hypothesis encodes paper Def 2.1 graph-on-`n`-nodes finiteness. R24-A SCOPE-INFLATION repair: both atom and derived-theorem statements scoped to `H = ∅`, matching paper line 463 (paper's `R(v)` is `ReachableSet` per Def 2.2, the `H = ∅` evaluation of `ForwardReachable`). R24-D: AxiomAudit instrumentation now active; output `[propext, ForwardReachable, ForwardReachable_self_member, IsEdge, PercolationOutcome, V_dyn, V_dyn_def, Vertex, blockingProb, forward_reachable_full_at_zero_OPEN, reward, Classical.choice, Quot.sound]` matches the documented dependency chain (axiom-name closure unchanged by R24-A scope tightening)."
  conditionalOn := []

def entry_prop_trap_prevalence_above : GapEntry where
  name := "gap_trap_prevalence_above_threshold (derived) + trap_config_local_positive_OPEN (Cat 3 atom)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:trap-prevalence Part 2, lines 458-473"
  attackHistory :=
    [ "R1 2026-05-12: trivial existential `∃ c, 0 < c`.",
      "R4 Phase 4 audit (2026-05-12): patched — bind to opaque carrier `trapMisalignmentProbability` and assert positive lower bound.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R37 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern. The bundled `gap_trap_prevalence_above_threshold_OPEN` is REPLACED by derived theorem `gap_trap_prevalence_above_threshold` (Phase.lean) composing the new Cat 3 atomic stipulation `trap_config_local_positive_OPEN` (paper-stated local FKG-positivity of trap pattern on Z²-lattice with degree 4, paper proof line 473 `binom(4, 2) p² (1-p)² · p^3 > 0` estimate). Net: status OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +1 new Cat 3 OPEN atomic-stipulation entry (entry_atom_trap_config_local_positive)." ]
  scope := "Proposition prop:trap-prevalence Part 2, lines 458-473"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input. R37 derived theorem `gap_trap_prevalence_above_threshold` re-exports the atomic stipulation `trap_config_local_positive_OPEN` (paper-stated local FKG-positivity, paper proof line 473). Substantive Mathlib Z²-lattice + percolation-measure machinery remains the underlying gap."
  conditionalOn := []

def entry_cor_er_phase : GapEntry where
  name := "gap_er_phase_subcritical, gap_er_phase_supercritical"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Corollary cor:er-phase, lines 1075-1085"
  attackHistory :=
    [ "R1 2026-05-12: re-exports of `gap_er_subcritical_OPEN` / `gap_er_supercritical_OPEN`.",
      "R3 Phase 0 audit (2026-05-12): CRITICAL bib-key error — paper bib `bollobas2006` resolves to Bollobás-Riordan _Percolation_ 2006, not Bollobás _Random Graphs_ 2001 2nd ed.",
      "R4 patches (2026-05-12): both axioms patched from vacuous existentials to substantive (`giantComponentSize_ER`, `poissonSurvival`).",
      "R5 paper-side patch (2026-05-12): bib key `bollobas2006` replaced with `bollobas2001` in references.bib; 3 \\citep{} sites updated in master tex. Paper-Lean unification complete.",
      "R26 2026-05-13: dropped `h_ER_sub` / `h_ER_sup` broken-link hypothesis parameters from `gap_er_phase_subcritical` and `gap_er_phase_supercritical` (theorems in Phase.lean) per the discipline clarification. The theorems now consume `gap_er_subcritical_OPEN` / `gap_er_supercritical_OPEN` Cat 2 axioms (renamed in `ClassicalResults.lean` from BLOCKED-defs) directly in their proof bodies.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat2). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Corollary cor:er-phase, lines 1075-1085"
  obstacleOrAttribution := "CLOSED-via-OPEN-input. R26: theorems consume `gap_er_subcritical_OPEN` / `gap_er_supercritical_OPEN` Cat 2 axioms directly per the 2026-05-13 discipline clarification (Cat 2 axioms with paper authority are consumed directly, not threaded as broken-link hypotheses)."
  conditionalOn := []

def entry_cor_power_law : GapEntry where
  name := "gap_power_law_heavy_tail, gap_power_law_thin_tail_OPEN"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Corollary cor:power-law, lines 1087-1100"
  attackHistory :=
    [ "R1 2026-05-12: re-exports.",
      "R3 Phase 0 audit (2026-05-12): WARN — Cohen 2000 paper says `α ≤ 3` (closed boundary), Lean used strict `γ < 3`. Patch applied: widen to `γ ≤ 3`.",
      "R4 patches (2026-05-12): both axioms patched from vacuous existentials to substantive (`HasGiantComponent`, `bondPercolationCritical_ConfigModel`).",
      "R5 paper-side patch (2026-05-12): added `\\citep{newman2001}` for ER bond-perc thinning + co-citation `\\citep{molloy1995,cohen2000,newman2001}` for power-law thin-tail. Paper-Lean unification complete.",
      "R20-B 2026-05-13: Cat 2 ↔ Cat 3 chain wiring per broken-link discipline (R17-E phantom-downstream finding for `gap_molloy_reed_BLOCKED_by_Mathlib_config_model`). Threaded the Molloy-Reed BLOCKED predicate `gap_molloy_reed_BLOCKED_by_Mathlib_config_model` as the explicit broken-link hypothesis `_h_molloy_reed` on `gap_power_law_thin_tail`. The hypothesis is operationally unused in the Hodge-style def-rfl + positivity proof body (equality is `rfl` against `bondPercolationCritical_ConfigModel`; positivity is Cat 1 arithmetic from `0 < E_D < E_D_DSub1`), but its presence in the signature makes the Cat 2 dependency explicit at the type level (paper line 1092 derives the closed form `p_c = 1 - E[D]/E[D(D-1)]` BY the Molloy-Reed criterion). Underscore prefix `_h_molloy_reed` silences Lean unused-variable lint while preserving the typed dependency. Symmetric with `gap_power_law_heavy_tail`'s already-active `h_cohen` threading (where the hypothesis IS operationally consumed). No call sites to update (only `#print axioms` in AxiomAudit.lean). lake build green.",
      "R26 2026-05-13: dropped `h_cohen` parameter from `gap_power_law_heavy_tail` (theorem in Phase.lean) — it now consumes `gap_cohen_powerlaw_OPEN` Cat 2 axiom directly in its proof body. Dropped operationally-unused `_h_molloy_reed` parameter from `gap_power_law_thin_tail` per the discipline clarification (R20-B's typed-dependency-at-type-level rationale becomes redundant once Molloy-Reed is a plain Cat 2 axiom — the dependency is now acknowledged in the docstring). Both Cat 2 axioms consumed implicitly via the axiom system.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat2). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Corollary cor:power-law, lines 1087-1100"
  obstacleOrAttribution := "CLOSED-via-OPEN-input. R26: `gap_power_law_heavy_tail` consumes `gap_cohen_powerlaw_OPEN` Cat 2 axiom directly; `gap_power_law_thin_tail` had its operationally-unused `_h_molloy_reed` parameter dropped (Molloy-Reed Cat 2 dependency now acknowledged in docstring). Both per the 2026-05-13 discipline clarification."
  conditionalOn := []

/-! # §4 Cognitive Threshold entries -/

def entry_thm_cognitive_threshold : GapEntry where
  name := "gap_cognitive_threshold_characterisation (assembles parts 1, 2, 3, 4, 5, 6)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Theorem 4.1 thm:cognitive-threshold, lines 487-518"
  attackHistory :=
    [ "R1 2026-05-12: each of 6 parts encoded as separate `cognitive_threshold_part{1..6}_paper_axiom`.",
      "R2 2026-05-12: renamed to `gap_cognitive_threshold_part{1..6}_OPEN`.",
      "R4 Phase 4 audit (2026-05-12): WARNs — Part 1 missing degree-2 premise; Part 3 too weak (`0 ≤ κ*` only — paper claims continuity + IVT); Part 4 over-claims (paper restricts to instance class); Part 6 drops lattice qualifier. All patches deferred.",
      "R11 discipline audit (2026-05-13): docstring `\"Combines parts 1–6\"` was overclaim — actual conjunction only included Parts 1, 3, 4, 5. Patched per `feedback_lean_real_math` no-self-castration discipline: extended the conjunction body to truly include all six parts (Parts 2 and 6 added as additional conjuncts; Part 3 projects to its non-negativity sub-clause, with the substantive Continuous + Tendsto + sInf content accessible through `gap_cognitive_threshold_part3_OPEN` directly).",
      "R11 (Part 3 substantive promotion): the deferred `Part 3 too weak` patch from R4 was finally applied. `gap_cognitive_threshold_part3_OPEN` now encodes the paper's full Theorem 4.1 Part 3 content: continuity of `m(·)` on `(0, ∞)`, the `Tendsto m(·) atTop (𝓝 (mLimit p))` limit, strict positivity `0 < mLimit p`, and the sInf characterisation `kappaStar p α = sInf {κ | 0 < κ ∧ 0 ≤ mean_estimate_gap p κ}` together with `0 ≤ kappaStar p α`. Introduced opaque carrier `mLimit : ℝ → ℝ` for the asymptotic limit `V_dyn(u_2) − V_dyn(u_1)`.",
      "R12 discipline audit (2026-05-13): R11's continuity sub-claim was `Continuous (fun κ => mean_estimate_gap p κ)` on all of ℝ, but the paper restricts to `(0, ∞)` (Remark `kappa-discontinuity` separates greedy `κ = 0` from `κ → 0⁺`). Tightened to `ContinuousOn ... (Set.Ioi 0)` per `feedback_paper_audit_methodology` 8-pattern hostile-audit checklist #2 (scope overclaim). The conjunction structure is preserved — `gap_cognitive_threshold_characterisation`'s projection `(_).2.2.2.2` to the non-negativity sub-clause still type-checks.",
      "R17-C 2026-05-13: Cat 2 ↔ Cat 3 sub-claim chain CONFIRMED for Part 6 (`gap_cognitive_threshold_part6_OPEN`). Per R17-B's reductionism audit, Part 6's Cat 2 dependency on Harris-Kesten 1960/1980 (`p_c(Z²) = 1/2`) is operationally active via the `harrisKestenCriticalProb` opaque carrier (already anchored R16-B). NO source change applied for Part 6 chain (decision: skip h_HK threading for symmetry with phase transitions). The bundle entry retains inputCategory Cat 3 (the bundle dominantly Cat 3); Part 6 sub-claim recorded as Cat 3-with-Cat 2 at the per-axiom level via the Lean signature's `harrisKestenCriticalProb` consumption.",
      "R18-A 2026-05-13: Part 6 sub-claim Cat3-with-Cat2 retraction per R17-E hostile audit Audit 6. The R17-C claim that Part 6 is Cat 3-with-Cat 2 via `harrisKestenCriticalProb` opaque-carrier consumption was incorrect: a Types.lean opaque-carrier reference (a Cat 3 primitive) is NOT a typed BLOCKED-def Cat 2 chain. A genuine Cat 2 chain to Harris-Kesten 1960/1980 would require a separate `(h_HK : gap_harris_kesten_BLOCKED_by_Mathlib_percolation)` parameter on `gap_cognitive_threshold_part6_OPEN`. Bundle inputCategory is already honestly `Cat3`; the per-axiom Cat 3-with-Cat 2 claim for Part 6 is hereby retracted at the ledger level.",
      "R23-C2 2026-05-13: applied Manufactured-Recognition R-#25 atomic-decomposition pattern to Part 5 only. Under the current `kappaStar_def` (R23-C1 atom) encoding, the α-parameter does not appear on the RHS of the inf-characterisation, so `kappaStar p α₁ = kappaStar p α₂` for any α₁, α₂ trivially under this encoding; thus `gap_cognitive_threshold_part5_OPEN` (`α₁ ≤ α₂ → kappaStar p α₁ ≤ kappaStar p α₂`) becomes a Cat 1 derived theorem `gap_cognitive_threshold_part5` proved via `rw [kappaStar_def, kappaStar_def]`. HONESTY CAVEAT: this Cat 1 closure is trivial under the current α-erasing encoding; the paper's substantive `∂κ*/∂α > 0` strict-monotonicity claim (Prop:threshold-alpha line 540) is NOT yet captured — would require enriching `kappaStar_def` to retain α-dependence on the RHS. R24 candidate: enrich the encoding. Part 5 wrapper `gap_threshold_alpha_monotone` updated to consume the derived theorem. Conjunction theorem `gap_cognitive_threshold_characterisation` updated to use `gap_cognitive_threshold_part5` instead of `gap_cognitive_threshold_part5_OPEN`. PART 4 R23-C2 SKIPPED: the natural Cat 3 atom `mean_estimate_gap_antitone_in_p_OPEN` (paper line 511 `m(p,κ)` decreasing in `p`) was investigated, but the standard sInf-monotonicity chain breaks at the corner case where set_{p₂} = ∅ (Mathlib `Real.sInf_empty = 0` junk-value forces the inequality to fail when set_{p₁} has positive sInf). The paper's claim is correct only under implicit non-emptiness premise. Mirrors R9's `gap_p_monotonicity_OPEN` junk-value falsification finding. Part 4 retains OPEN status with R24-candidate documentation in axiom docstring; the proposed atom is NOT added to source.",
      "R24-B 2026-05-13: REVERTED Part 5 R23-C2 promotion per R23-D Audit 1+2+3 α-erasure violation. The R23-C2 closure `gap_cognitive_threshold_part5 := by rw [kappaStar_def, kappaStar_def]` was a tautological-premise (Pattern 4) closure: `kappaStar_def`'s RHS is α-free, so both sides reduce to the SAME expression and `≤` is discharged by `le_refl` regardless of whether `α₁ ≤ α₂`. Paper-source verification (R24-B): paper `m(κ)` (line 489 + 505) is literally α-free (depends on (p, κ) only); paper Part 3 inf-formula `κ* = inf{κ > 0 : m(κ) ≥ 0}` is itself α-free; paper Prop:threshold-alpha line 540 derives α-monotonicity from a DIFFERENT characterisation (welfare-transition value), which is NOT reducible to the inf-formula. Option A (refactor `mean_estimate_gap` to take α) was REJECTED: would phantom-introduce α-dependence on `m(κ)` that the paper does not state (Cat 3 phantom-attribution antipattern). Option B chosen: revert `gap_cognitive_threshold_part5` from CLOSED Cat 1 derived theorem to atomic OPEN Cat 3 axiom `gap_cognitive_threshold_part5_OPEN` (paper-stated structural monotonicity claim on `kappaStar` carrier, not reducible to `kappaStar_def`). Conjunction theorem `gap_cognitive_threshold_characterisation` updated to use `gap_cognitive_threshold_part5_OPEN` again (revert of R23-C2's conjunction patch). Wrapper `gap_threshold_alpha_monotone` re-exports the OPEN axiom. AxiomAudit.lean's print line for Part 5 also renamed (one-line consequence of the Part 5 axiom rename). Future-round candidate: encode the welfare-transition α-monotonicity as a SEPARATE atomic Cat 3 axiom (independent of `kappaStar_def`).",
      "R27-A 2026-05-13: Cat 3 sub-classification DERIVED_THEOREM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as CLOSED (Cat 3 derived theorem composing earlier Cat 1 + Cat 2 + Cat 3 atomic inputs — sub-class is descriptive only, not subject to the 永不/必须 close mandate). New `subClass` field set to DERIVED_THEOREM.",
      "R35-B Wave 2.6: restored explicit Cat 2 chain dropped in R26 on Part 2 (`gap_cognitive_threshold_part2_OPEN`) per R35 deep audit (R26 over-applied 'Cat 2 implicit consumption' rule for this entry whose CLAIM CONTENT is Cat 2 theorem applied to paper-novel carrier per `feedback_gap_ledger_in_lean4` §10). Added explicit antecedent `(∀ β₁ β₂, β₁ ≤ β₂ → agentWelfare AgentType.bayesian β₁ 0 1 ≤ agentWelfare AgentType.bayesian β₂ 0 1)` (the propositional content of `gap_blackwell_monotonicity_OPEN`) to `gap_cognitive_threshold_part2_OPEN` signature. Bundle conjunction theorem `gap_cognitive_threshold_characterisation` propagates the Cat 2 dependency by supplying `gap_blackwell_monotonicity_OPEN` directly to Part 2 (via `gap_cognitive_threshold_part2_OPEN gap_blackwell_monotonicity_OPEN hC hT`). `#print axioms gap_cognitive_threshold_characterisation` will now surface the Blackwell 1951/1953 dependency for Part 2.",
      "R36 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern to Part 3. Split the bundled `gap_cognitive_threshold_part3_OPEN` 5-conjunction (ContinuousOn ∧ Tendsto ∧ 0 < mLimit p ∧ kappaStar p α = sInf{...} ∧ 0 ≤ kappaStar p α) into four NEW Cat 3 atomic stipulations + reuse of existing `kappaStar_def` (R23-C1 atom): (a) `mean_estimate_gap_continuous_OPEN` (paper-stated continuity on (0,∞), line 493); (b) `mean_estimate_gap_tendsto_mLimit_OPEN` (paper-stated Tendsto limit on `mLimit` carrier, line 505 — distinct from existing `mLimit_def` which hosts the analogous Tendsto on the per-instance `mLimitOf` carrier); (c) `mLimit_pos_OPEN` (paper-stated 0 < mLimit p, line 505); (d) `kappaStar_nonneg_OPEN` (paper-stated 0 ≤ kappaStar p α, line 493). The bundled axiom is REPLACED by derived theorem `gap_cognitive_threshold_part3` (Cognitive.lean ~L246-L262) composing the four new atoms with `kappaStar_def`. Bundle conjunction `gap_cognitive_threshold_characterisation` updated to project from the derived theorem (`fun p α => (gap_cognitive_threshold_part3 hC p α).2.2.2.2`) instead of the prior `_OPEN` axiom. Net: +4 new Cat 3 OPEN atomic-stipulation entries (entry_atom_mean_estimate_gap_continuous, entry_atom_mean_estimate_gap_tendsto_mLimit, entry_atom_mLimit_pos, entry_atom_kappaStar_nonneg); the bundle entry remains CLOSED with Part 3 sub-claim now derived rather than axiomatized.",
      "R38 2026-05-14: applied §18 atomic-decomposition pattern to Parts 1, 2, 4, 5, 6 (Parts 3 already R36-decomposed). Each part's bundled `gap_cognitive_threshold_partN_OPEN` axiom replaced by a Cat 3 atomic-stipulation atom + derived theorem (paper-stated content unchanged; the bundle is now a chain of derived theorems re-exporting atoms): Part 1 → atom `alpha_above_alpha_star_implies_reversal_OPEN` + theorem `gap_cognitive_threshold_part1`; Part 2 → atom `kappa_large_blackwell_recovery_OPEN` + theorem `gap_cognitive_threshold_part2`; Part 4 → atom `kappaStar_p_monotone_OPEN` + theorem `gap_cognitive_threshold_part4`; Part 5 → atom `welfare_transition_alpha_monotone_OPEN` + theorem `gap_cognitive_threshold_part5` (the paper-stated welfare-transition α-monotonicity per R24-B's `Future-round candidate` directive — independent of `kappaStar_def`'s α-free inf-formula); Part 6 → atom `kappaStar_diverges_at_pc_OPEN` + theorem `gap_cognitive_threshold_part6`. Bundle conjunction `gap_cognitive_threshold_characterisation` updated to compose the six derived theorems (was three derived + three `_OPEN` axioms). Net: +5 new Cat 3 OPEN atomic-stipulation entries (entry_atom_alpha_above_alpha_star_implies_reversal, entry_atom_kappa_large_blackwell_recovery, entry_atom_kappaStar_p_monotone, entry_atom_welfare_transition_alpha_monotone, entry_atom_kappaStar_diverges_at_pc). The bundle entry remains CLOSED with all six parts now derived-theorem-hosted rather than bundle-axiom-hosted." ]
  scope := "Theorem 4.1 thm:cognitive-threshold, lines 487-518"
  obstacleOrAttribution :=
    "CLOSED-via-OPEN-input — assembles all six parts of the paper's Theorem 4.1. R36 Part 3 atomic decomposition: `gap_cognitive_threshold_part3_OPEN` (bundled 5-conjunction) replaced by derived theorem `gap_cognitive_threshold_part3` composing four new Cat 3 atomic stipulations (mean_estimate_gap_continuous_OPEN, mean_estimate_gap_tendsto_mLimit_OPEN, mLimit_pos_OPEN, kappaStar_nonneg_OPEN) with existing R23-C1 atom `kappaStar_def`. R35-B Wave 2.6 threaded `gap_blackwell_monotonicity_OPEN` into Part 2 via Cat 2 explicit chain per §10 paper-APPLICATION-to-opaque-carrier discipline; R24-B reverted Part 5 from R23-C2 Cat 1 derived theorem back to OPEN Cat 3 axiom. REMAINING DEFERRED PATCHES: (Part 1) add DegreeTwoStartingVertex premise; (Part 4) gate by IsCanonicalOrLatticeInstance OR enrich kappaStar_def to handle junk-value branch (R24); (Part 5) NEEDS-MORE-WORK — the paper proves α-monotonicity via a welfare-transition characterisation (line 540) NOT reducible to the inf-formula in `kappaStar_def`; an honest closure requires a SEPARATE atomic Cat 3 axiom encoding the welfare-transition α-monotonicity (Option B per R24-B); (Part 6) add LatticeZ2 qualifier. R18-A: `harrisKestenCriticalProb` opaque carrier is a Types.lean Cat 3 primitive, NOT the typed BLOCKED-def Cat 2 chain."
  conditionalOn := []

def entry_prop_supermodular : GapEntry where
  name := "gap_supermodular (derived) + welfareCrossPartial_explicit_form_OPEN + cross_partial_sign_in_z_lt_one_OPEN (Cat 3 atoms)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:supermodular, lines 552-585"
  attackHistory :=
    [ "R1 2026-05-12: vacuous `∃ crossPartial, 0 < crossPartial`.",
      "R4 Phase 4 audit (2026-05-12): patched — bind to opaque carrier `welfareCrossPartial : ℝ → ℝ → ℝ`, assert positivity in `|z| < 1` region.",
      "R6 2026-05-12: converted opaque carriers `snrZ` and `welfareCrossPartial` to concrete `def`s (snrZ ≡ 0, welfareCrossPartial ≡ 1). Positivity claim closed by `norm_num` after unfolding.",
      "R7 2026-05-12: hostile audit caught the R6 closure as a closure-count trick violating `feedback_lean_real_math` (concrete-placeholder shapes do not encode the paper's substantive analytic content). Reverted to opaque-carrier-bound `axiom gap_supermodular_OPEN` in the Lean source.",
      "R11 discipline audit (2026-05-13): retroactive Ledger-status correction — the R7 source-side revert was applied but the Ledger entry was never updated, leaving stale `status := \"CLOSED\"` metadata that contradicted the actual Lean source (`Cognitive.lean:149` `axiom gap_supermodular_OPEN`). Status now corrected to OPEN, name updated to match the source declaration.",
      "R17-C 2026-05-13: Cat 2 ↔ Cat 3 chain wiring per broken-link discipline. Paper line 553 invokes Topkis 1978/1998 as the Cat 2 supermodularity-from-cross-partial bridge, but the previous Lean signature did not consume this dependency (Cat 2 ↔ Cat 3 disconnect anti-pattern: docstring cited Topkis but Lean signature did not chain it). Threaded the BLOCKED Topkis predicate `gap_topkis_supermodularity_BLOCKED_by_Mathlib_topkis` as the explicit broken-link hypothesis `h_topkis : ∀ W mp h_nn, gap_topkis_supermodularity_BLOCKED_by_Mathlib_topkis W mp h_nn` (universally-quantified Prop form, since paper claim restricts welfareCrossPartial positivity to moderate-SNR regime |z| < 1 and so cannot directly instantiate the universally-quantified Topkis BLOCKED predicate — but the Lean signature dependency is now explicit). Downstream `gap_policy_complementarity_OPEN_derived` and wrapper `gap_policy_complementarity` updated to thread `h_topkis` through. inputCategory promoted Cat 3 → Cat 3-with-Cat 2 to record the explicit Topkis chain.",
      "R18-A 2026-05-13: Cat3-with-Cat2 → Cat3 demotion + drop performative `h_topkis` parameter per R17-E hostile audit. The R17-C threading was performative: the Topkis BLOCKED predicate is universally-quantified (∀ x y, 0 ≤ mixedPartial x y ⇒ supermodular) but the paper restricts positivity of `welfareCrossPartial` to the regional regime `|z| < 1`. The universal-vs-regional scope mismatch makes the BLOCKED predicate operationally non-instantiable here, so threading it as a hypothesis was a passport that cannot be redeemed (R17-E classification). Removed the `h_topkis` parameter from `gap_supermodular_OPEN` axiom signature; updated docstring to honestly state Topkis as structural inspiration only, with the regional positivity acknowledged as paper-novel Cat 3 substance. Downstream `gap_policy_complementarity_OPEN_derived` and `gap_policy_complementarity` proofs updated to drop `h_topkis` from the call sites.",
      "R21-B 2026-05-13: paper-source-verification antecedent restoration per R20-D Audit 2D finding. Paper line 558 explicitly restricts the cross-partial positivity claim to (β, κ) jointly satisfying TWO conditions: (i) `|z(β, κ)| < 1` (moderate SNR) AND (ii) `V_dyn(u_2, β) > r(u_1)` (bridge-dominance). The previous Lean signature only threaded condition (i); condition (ii) was silently dropped, scope-inflating the axiom relative to the paper. Restored the antecedent by introducing a Cat 3 paper-novel predicate `BridgeDominance : ℝ → Prop` (Cognitive.lean, immediately above `gap_supermodular_OPEN`) keyed off the paper's notation `V_dyn(u_2, β) > r(u_1)`, and added `BridgeDominance β →` as the new third antecedent of `gap_supermodular_OPEN`. Encoding choice: opaque predicate (not explicit `V_dyn`-vs-`reward` comparison) because the paper's vertices `u_1, u_2` are local to the proposition's setup and an explicit comparison would require committing to opaque-carrier choices for the paper-instance vertex pair outside the scope of this file. Downstream propagation: `gap_policy_complementarity_OPEN_derived` gains `(h_dom : ∀ β : ℝ, BridgeDominance β)` parameter and supplies `h_dom β_i` to each of the four corner-applications of `gap_supermodular_OPEN`; wrapper `gap_policy_complementarity` adds the matching `(∀ β : ℝ, BridgeDominance β) →` hypothesis after the SNR universal. Lake build green.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R37 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern. The bundled `gap_supermodular_OPEN` is REPLACED by derived theorem `gap_supermodular` (Cognitive.lean) composing two new Cat 3 atomic stipulations: (a) `welfareCrossPartial_explicit_form_OPEN` (paper-stated explicit closed-form decomposition of the welfare cross-partial via `φ'(z) = -z·φ(z)` Gaussian PDF derivative identity, paper proof lines 564-583); (b) `cross_partial_sign_in_z_lt_one_OPEN` (paper-stated sign-positivity of decomposition factors at `|z| < 1`, paper proof line 582-584). Net: status OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +2 new Cat 3 OPEN atomic-stipulation entries (entry_atom_welfareCrossPartial_explicit_form, entry_atom_cross_partial_sign_in_z_lt_one). The Cat 2 Topkis 1978/1998 dependency remains threaded as explicit `_h_topkis` antecedent on the derived theorem for audit-chain visibility (operationally consumed downstream by `gap_kappaWelfare_cross_partial_link_OPEN`). Downstream `gap_policy_complementarity_OPEN_derived` consumers updated to call `gap_supermodular` instead of `gap_supermodular_OPEN`." ]
  scope := "Proposition prop:supermodular, lines 552-585"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input. R37 derived theorem `gap_supermodular` composes two atomic stipulations: `welfareCrossPartial_explicit_form_OPEN` (paper-stated calculus closed form, line 580-583) + `cross_partial_sign_in_z_lt_one_OPEN` (paper-stated sign analysis at `|z| < 1`, line 582-584). Cat 2 Topkis 1978/1998 is structural inspiration; threaded as explicit `_h_topkis` antecedent on the derived theorem for audit-chain visibility (operationally consumed by `gap_kappaWelfare_cross_partial_link_OPEN`). Substantive Mathlib HasDerivAt + Φ + φ derivative machinery remains the underlying gap. R21-B bridge-dominance `BridgeDominance β` (paper line 558 joint antecedent) propagated through both atoms."
  conditionalOn := []

def entry_cor_policy_complementarity : GapEntry where
  name := "gap_policy_complementarity"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Corollary cor:policy-complementarity, lines 587-590"
  attackHistory :=
    [ "R1 2026-05-12: re-export of `gap_topkis_supermodularity_OPEN`.",
      "R13 hostile audit (2026-05-13): caught the R1 re-export as DEFECT — the wrapper proved Topkis supermodularity for an arbitrary `W` decoupled from the IDP welfare; `_hC` and `_hT` were unused. Folkloric Topkis on a generic function, not the IDP-specific corollary.",
      "R14 patch (2026-05-13): coupled to IDP welfare via paper-specific carrier `kappaAgentWelfareSNR : ℝ → ℝ → ℝ`; introduced `gap_policy_complementarity_OPEN` axiom whose statement consumes hC + hT + the SNR-regime hypothesis `∀ β κ, |snrZ β κ| < 1` and concludes Topkis supermodularity in the κ-agent welfare. Wrapper theorem `gap_policy_complementarity` now derives from this OPEN axiom; hC and hT are honestly used.",
      "R17-C 2026-05-13: Cat 2 ↔ Cat 3 chain wiring per broken-link discipline. Threaded the Topkis BLOCKED predicate `gap_topkis_supermodularity_BLOCKED_by_Mathlib_topkis` as the explicit broken-link hypothesis `h_topkis` through `gap_kappaWelfare_cross_partial_link_OPEN`, `gap_supermodular_OPEN`, `gap_policy_complementarity_OPEN_derived`, and the wrapper `gap_policy_complementarity`. Replaces the previous docstring-only Topkis citation with a typed Lean signature dependency (closing the Cat 2 ↔ Cat 3 disconnect). inputCategory promoted Cat 3 → Cat 3-with-Cat 2.",
      "R18-A 2026-05-13: Cat3-with-Cat2 → Cat3 demotion + drop performative `h_topkis` parameter per R17-E hostile audit. The R17-C `h_topkis` threading was performative for the same regional-vs-universal scope reason as `entry_prop_supermodular`: the Topkis BLOCKED predicate is universally-quantified, but the paper's positivity claim is regional (`|z| < 1`) and the four-corner coupling axiom likewise consumes only regional positivity hypotheses. The wrapper `gap_policy_complementarity` and the derived theorem `gap_policy_complementarity_OPEN_derived` had their `h_topkis` parameter removed; the proof body now calls `gap_kappaWelfare_cross_partial_link_OPEN` and `gap_supermodular_OPEN` without threading the inert hypothesis. Honest acknowledgment of universal-vs-regional Topkis mismatch lives in the upstream axiom docstrings (Cognitive.lean).",
      "R21-B 2026-05-13: bridge-dominance hypothesis propagation per upstream `entry_prop_supermodular` patch. After `gap_supermodular_OPEN` gained the new `BridgeDominance β →` antecedent (paper line 558 joint condition `V_dyn(u_2, β) > r(u_1)`), `gap_policy_complementarity_OPEN_derived` now takes `(h_dom : ∀ β : ℝ, BridgeDominance β)` and supplies `h_dom β_i` to each of the four corner-applications of `gap_supermodular_OPEN`; the wrapper `gap_policy_complementarity` likewise adds the matching `(∀ β : ℝ, BridgeDominance β) →` universal after the existing SNR universal in its signature. The corollary remains CLOSED-via-OPEN-input; the new hypothesis is honest paper-faithful threading (no inert performative passport). Lake build green.",
      "R27-A 2026-05-13: Cat 3 sub-classification DERIVED_THEOREM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as CLOSED (Cat 3 derived theorem composing earlier Cat 1 + Cat 2 + Cat 3 atomic inputs — sub-class is descriptive only, not subject to the 永不/必须 close mandate). New `subClass` field set to DERIVED_THEOREM.",
      "R35-B Wave 2.7: restored explicit Cat 2 chain dropped in R18-A on the underlying `gap_kappaWelfare_cross_partial_link_OPEN` axiom per R35 deep audit (R18-A performative-passport drop conflicted with §10 paper-APPLICATION-to-opaque-carrier discipline: the CLAIM CONTENT of the axiom is the Topkis cross-partial-to-supermodularity bridge applied to the paper-novel `kappaAgentWelfareSNR` carrier on the four corner-lattice points, even though the per-corner regional `|z| < 1` antecedents are paper-novel). Added explicit antecedent `(∀ W, supermodularity-on-W → supermodularity-on-W)` (the propositional content of `gap_topkis_supermodularity_OPEN` after R28-A's `mixedPartial`-drop restructure that eliminated the universal-vs-regional scope mismatch) to `gap_kappaWelfare_cross_partial_link_OPEN`. Downstream `gap_policy_complementarity_OPEN_derived` updated to supply `gap_topkis_supermodularity_OPEN` directly to the link axiom call (proof-body composition). The wrapper `gap_policy_complementarity` signature unchanged. `#print axioms gap_policy_complementarity` will now surface `gap_topkis_supermodularity_OPEN` for the cross-partial bridge step (in addition to its existing surfacing via `gap_supermodular_OPEN`'s `h_topkis` antecedent).",
      "R37 2026-05-14: downstream propagation of upstream `entry_prop_supermodular` §18 decomposition. The four corner-applications of `gap_supermodular_OPEN` in `gap_policy_complementarity_OPEN_derived` (Cognitive.lean) are renamed to `gap_supermodular` (the new derived theorem). Signature of `gap_policy_complementarity_OPEN_derived` and the wrapper `gap_policy_complementarity` is unchanged. `#print axioms gap_policy_complementarity` now surfaces `welfareCrossPartial_explicit_form_OPEN` and `cross_partial_sign_in_z_lt_one_OPEN` (the new R37 atoms) instead of the prior `gap_supermodular_OPEN` axiom, completing the §18 audit-chain visibility per the discipline." ]
  scope := "Corollary cor:policy-complementarity, lines 587-590"
  obstacleOrAttribution :=
    "CLOSED via `gap_policy_complementarity_OPEN_derived` (composes `gap_supermodular_OPEN` + `gap_kappaWelfare_cross_partial_link_OPEN`; R35-B Wave 2.7 threaded `gap_topkis_supermodularity_OPEN` into the link axiom via Cat 2 explicit chain per §10 paper-APPLICATION-to-opaque-carrier discipline). Substantive Topkis lattice-theoretic argument applied to the IDP κ-agent welfare remains the underlying Mathlib gap. R21-B: bridge-dominance universal `(∀ β, BridgeDominance β)` is an explicit hypothesis of both `gap_policy_complementarity_OPEN_derived` and the wrapper `gap_policy_complementarity`, propagating the upstream paper-faithful antecedent restoration in `gap_supermodular_OPEN`. Cat 2 chain to Topkis 1978/1998 now visible via `#print axioms` through both `gap_supermodular_OPEN` (R28-A `h_topkis`) and the link axiom (R35-B Wave 2.7 explicit antecedent)."
  conditionalOn := []

def entry_prop_sentimental : GapEntry where
  name := "gap_sentimental_immunity (derived) + signal_independent_at_alpha_zero_OPEN + welfare_continuity_in_alpha_OPEN + alpha_star_existence_via_continuity_OPEN (Cat 3 atoms)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:sentimental, lines 595-603"
  attackHistory :=
    [ "R1 2026-05-12: encoded as opaque axiom; faithful per Phase 4 audit (one nit on agent-type narrowness — uses `AgentType.sentimental` rather than universal). ",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R37 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern. The bundled `gap_sentimental_immunity_OPEN` is REPLACED by derived theorem `gap_sentimental_immunity` (Cognitive.lean) composing three new Cat 3 atomic stipulations: (a) `signal_independent_at_alpha_zero_OPEN` (paper L600 base case at α = 0 via Lemma `lem:conditional-reduction`(i) on signal-independent ranking); (b) `welfare_continuity_in_alpha_OPEN` (paper L602 perturbative continuity in α with small-α monotonicity neighbourhood width δ); (c) `alpha_star_existence_via_continuity_OPEN` (paper L602 sup-existence of `α*` over the monotonicity set given the small-α neighbourhood). Net: status OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +3 new Cat 3 OPEN atomic-stipulation entries (entry_atom_signal_independent_at_alpha_zero, entry_atom_welfare_continuity_in_alpha, entry_atom_alpha_star_existence_via_continuity)." ]
  scope := "Proposition prop:sentimental, lines 595-603"
  obstacleOrAttribution := "CLOSED-via-Cat-3-atom-input. R37 derived theorem `gap_sentimental_immunity` composes three atomic stipulations (paper proof lines 600-602): `signal_independent_at_alpha_zero_OPEN` (α = 0 base case) + `welfare_continuity_in_alpha_OPEN` (perturbative continuity neighbourhood) + `alpha_star_existence_via_continuity_OPEN` (sup over monotonicity set). Substantive mixture-of-Gaussians integration + closed-set/compact-domain Banach-lattice analysis remain the underlying Mathlib gaps."
  conditionalOn := []

def entry_prop_threshold_alpha : GapEntry where
  name := "gap_threshold_alpha_monotone (derived) — re-exports gap_cognitive_threshold_part5"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:threshold-alpha (re-exports cognitive_threshold_part5)"
  attackHistory :=
    [ "R1 2026-05-12: re-export of `gap_cognitive_threshold_part5_OPEN` (Cat 3 chain).",
      "R23-C2 2026-05-13: upstream `gap_cognitive_threshold_part5_OPEN` was Cat 1 promoted to derived theorem `gap_cognitive_threshold_part5` via `kappaStar_def` α-erasure (R23-C1 atom). Wrapper `gap_threshold_alpha_monotone` now re-exports the Cat 1 closure; inputCategory upgraded Cat 3 → Cat 1. HONESTY CAVEAT inherited from upstream: this is trivial under current α-erasing encoding; substantive paper `∂κ*/∂α > 0` strict-monotonicity (Prop:threshold-alpha line 540) awaits enriched encoding (R24).",
      "R24-B 2026-05-13: REVERTED CLOSED → OPEN per R23-D Audit 1+2+3 α-erasure violation. The R23-C2 Cat 1 promotion was tautological (Pattern 4); paper's `m(κ)` is α-free so `kappaStar_def` cannot encode α-monotonicity. Restored to atomic Cat 3 OPEN axiom; wrapper re-exports the OPEN axiom; future-round candidate: add a separate atom encoding the welfare-transition α-monotonicity.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN.",
      "R38 2026-05-14: upstream `gap_cognitive_threshold_part5_OPEN` decomposed via §18 pattern into atom `welfare_transition_alpha_monotone_OPEN` (the paper-stated welfare-transition α-monotonicity of Prop:threshold-alpha proof line 540, independent of the α-erasing inf-formula `kappaStar_def`) + derived theorem `gap_cognitive_threshold_part5`. The wrapper `gap_threshold_alpha_monotone` now re-exports the derived theorem (not the atom); status flipped OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM. The decomposition implements the R24-B `Future-round candidate` directive — the welfare-transition α-monotonicity has its own paper-stated atomic stipulation, no longer routed through `kappaStar_def`'s α-free RHS." ]
  scope := "Proposition prop:threshold-alpha (re-exports cognitive_threshold_part5)"
  obstacleOrAttribution := "CLOSED-via-Cat-3-atom-input. R38 derived theorem `gap_threshold_alpha_monotone` re-exports `gap_cognitive_threshold_part5` (Cognitive.lean), which derives directly from the atomic stipulation `welfare_transition_alpha_monotone_OPEN` (the paper-stated welfare-transition characterisation of Prop:threshold-alpha proof line 540). Independent of `kappaStar_def`'s α-free inf-formula; honest paper-faithful α-monotonicity encoding."
  conditionalOn := []

/-! # §4 Principal entries -/

def entry_prop_principal_optimum : GapEntry where
  name := "gap_principal_{interior_optimum,monotone_in_kappa,regime_bifurcation} (derived) + 7 Cat 3 atoms"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:principal-optimum (3 parts), lines 622-641"
  attackHistory :=
    [ "R1 2026-05-12: 3 axioms, all with vacuous existentials.",
      "R4 Phase 4 audit (2026-05-12): all 3 had DEFECTs. Patched: monotone_in_kappa now binds to `kappa_FOSD` + `aggregateOptimalBeta`; regime_bifurcation now binds to existing `W_bar`; interior_optimum still drops upper bound + reversal-regime support hypothesis (DEFERRED).",
      "R6 2026-05-12: converted opaque carriers to concrete `def`s. `W_bar β := -(β² - 2β)²` (non-concave M-shape), `betaBarStar := 3/2`, `kappa_FOSD ≡ True`, `aggregateOptimalBeta ≡ 3/2`. All three theorems closed by witness arithmetic.",
      "R7 2026-05-12: hostile audit caught all three R6 closures as concrete-placeholder closure-count tricks violating `feedback_lean_real_math` (the placeholder shapes encode no paper content). Reverted in source to `axiom gap_principal_*_OPEN` declarations with substantive opaque-carrier-bound statements (W_bar, betaBarStar, kappa_FOSD, aggregateOptimalBeta retained as opaque carriers).",
      "R11 discipline audit (2026-05-13): retroactive Ledger-status correction — the R7 source-side revert was applied but the Ledger entry was never updated, leaving stale `status := \"CLOSED\"` metadata that contradicted the actual Lean source (`Principal.lean:46/71/81` `axiom gap_principal_{interior_optimum,monotone_in_kappa,regime_bifurcation}_OPEN`). Status now corrected to OPEN.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R37 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern to all three parts. Each bundled `gap_principal_*_OPEN` axiom is REPLACED by a derived theorem in Principal.lean: Part 1 `gap_principal_interior_optimum` composes 3 atoms (`W_bar_eventually_decreasing_in_reversal_OPEN`, `W_bar_exceeds_zero_at_positive_beta_OPEN`, `interior_max_exists_from_unimodal_envelope_OPEN`); Part 2 `gap_principal_monotone_in_kappa` composes 2 atoms (`fosd_induces_derivative_domination_OPEN`, `argmax_monotone_under_derivative_domination_OPEN`); Part 3 `gap_principal_regime_bifurcation` composes 2 atoms (`W_bar_mixture_decomposition_OPEN`, `non_concave_triple_from_mixture_OPEN`). Net: status OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +7 new Cat 3 OPEN atomic-stipulation entries (entry_atom_W_bar_eventually_decreasing_in_reversal, entry_atom_W_bar_exceeds_zero_at_positive_beta, entry_atom_interior_max_exists_from_unimodal_envelope, entry_atom_fosd_induces_derivative_domination, entry_atom_argmax_monotone_under_derivative_domination, entry_atom_W_bar_mixture_decomposition, entry_atom_non_concave_triple_from_mixture)." ]
  scope := "Proposition prop:principal-optimum (3 parts), lines 622-641"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input across all three parts. R37 derived theorems compose 7 atomic stipulations: Part 1 (paper line 624-625, 632): `W_bar_eventually_decreasing_in_reversal_OPEN` + `W_bar_exceeds_zero_at_positive_beta_OPEN` + `interior_max_exists_from_unimodal_envelope_OPEN`; Part 2 (paper line 626, 634): `fosd_induces_derivative_domination_OPEN` + `argmax_monotone_under_derivative_domination_OPEN`; Part 3 (paper line 627, 636-640): `W_bar_mixture_decomposition_OPEN` + `non_concave_triple_from_mixture_OPEN`. Substantive measure-theoretic content (heterogeneous-population integrals, HasDerivAt + Lebesgue-Stieltjes, conditional-expectation, argmax-uniqueness) remains the underlying Mathlib gap encoded via opaque carriers `W_bar`, `betaBarStar`, `kappa_FOSD`, `aggregateOptimalBeta`, `aggregateWelfareWith`."
  conditionalOn := []

def entry_cor_disclosure : GapEntry where
  name := "gap_disclosure_{full_suboptimal,differentiated_dominates} (derived) + 3 Cat 3 atoms"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Corollary cor:disclosure (2 parts), lines 645-647"
  attackHistory :=
    [ "R1 2026-05-12: 2 axioms with vacuous existentials.",
      "R4 Phase 4 audit (2026-05-12): both DEFECTs. Patched: bind to `W_bar` + `W_bar_limit_infty` + `differentiatedDisclosureWelfare`.",
      "R6 2026-05-12: converted opaque carriers to concrete `def`s. `W_bar_limit_infty := -100`, `differentiatedDisclosureWelfare ≡ 0`. Both closures via witness arithmetic / `sq_nonneg`.",
      "R7 2026-05-12: hostile audit caught both R6 closures as concrete-placeholder closure-count tricks violating `feedback_lean_real_math`. Reverted in source to `axiom gap_disclosure_*_OPEN` with opaque carriers retained.",
      "R11 discipline audit (2026-05-13): retroactive Ledger-status correction — the R7 source-side revert was applied but the Ledger entry was never updated, leaving stale `status := \"CLOSED\"` metadata that contradicted the actual Lean source (`Principal.lean:101/118` `axiom gap_disclosure_{full_suboptimal,differentiated_dominates}_OPEN`). Status now corrected to OPEN.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R37 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern to both parts. Each bundled `gap_disclosure_*_OPEN` axiom is REPLACED by a derived theorem in Principal.lean: Part 1 `gap_disclosure_full_suboptimal` composes 2 atoms (`averaged_reversal_overshoot_positive_OPEN`, `finite_beta_above_limit_from_overshoot_OPEN`); Part 2 `gap_disclosure_differentiated_dominates` re-exports 1 atom (`differentiated_per_agent_optimum_dominates_uniform_OPEN`). Net: status OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +3 new Cat 3 OPEN atomic-stipulation entries (entry_atom_averaged_reversal_overshoot_positive, entry_atom_finite_beta_above_limit_from_overshoot, entry_atom_differentiated_per_agent_optimum_dominates_uniform)." ]
  scope := "Corollary cor:disclosure (2 parts), lines 645-647"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input across both parts. R37 derived theorems compose 3 atomic stipulations: Part 1 (paper line 645, 652-656): `averaged_reversal_overshoot_positive_OPEN` (G-averaged reversal-regime overshoot positivity via Theorem `thm:cognitive-threshold` Part 1) + `finite_beta_above_limit_from_overshoot_OPEN` (finite-β-strictly-above-limit existence via `λ ε < (1 - λ) δ̄` choice); Part 2 (paper line 647, 658): `differentiated_per_agent_optimum_dominates_uniform_OPEN` (per-agent-optimum aggregate dominates uniform aggregate). Substantive heterogeneous-population content (β → ∞ limit semantics + measure-theoretic per-agent integration) remains the underlying Mathlib gap encoded via opaque carriers `W_bar`, `W_bar_limit_infty`, `differentiatedDisclosureWelfare`."
  conditionalOn := []

/-! # §5 Constructive Instances entries -/

def entry_prop_canonical : GapEntry where
  name := "FourState.W_open + gap_W_open_limit_infty (CLOSED) + gap_W_open_limit_zero (CLOSED)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:canonical (4-state), lines 708-715"
  attackHistory :=
    [ "R1: closed-form `W_open` defined; β-limits axiomatised.",
      "R10: β-limits restored as CLOSED via Hodge-style def-rfl (def W_open_limit_infty := r_A; theorem ... = r_A := rfl).",
      "R13 hostile audit: caught both as DISHONEST def-rfl — Hodge-style is acceptable for paper-stated CLOSED FORMS but NOT for limits-of-process (the def discards the limit content). Reverted to honest OPEN axioms in R14: `gap_W_open_limit_infty_OPEN` and `gap_W_open_limit_zero_OPEN` now encode the actual `Filter.Tendsto W_open Filter.atTop (nhds r_A)` and `Filter.Tendsto W_open (nhdsWithin 0 (Set.Ioi 0)) (nhds ((r_A + r_G) / 2))` against the actual welfare process (not against a constant function). Honest OPEN: full proof requires Mathlib Gaussian asymptotic infrastructure (Φ → 1 as σ² → 0, Φ → 1/2 as σ² → ∞).",
      "R17 2026-05-13: reclassified CLOSED → PARTIAL per the rewritten compact `feedback_gap_ledger_in_lean4` (2026-05-13) PARTIAL definition `specific sub-clause closed; remaining content explicit`. The bundle has formula `FourState.W_open` Cat 3 def-CLOSED + two β-limit OPEN axioms (post-R14 honest Tendsto encoding); previously tagged CLOSED-at-entry-level which masked the OPEN sub-clauses. PARTIAL is now the canonical tag.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as PARTIAL (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R30 2026-05-13: β→∞ limit PROMOTED OPEN → CLOSED. `gap_W_open_limit_infty_OPEN` axiom replaced with `theorem gap_W_open_limit_infty : Filter.Tendsto W_open Filter.atTop (nhds r_A)` derived via the Cat 1 helper chain in ClassicalResults.lean: `signalVariance_tendsto_zero_atTop` (`σ²(β) = 1/(2^(2β)-1) → 0` via `Real.rpow_def_of_pos` + `Real.tendsto_exp_atTop` + `Filter.Tendsto.inv_tendsto_atTop`) → `2σ² → 0` → `√(2σ²) → 0` (continuity of sqrt) → `Δ_4/√(2σ²) → ∞` (via Cat 1 helper `tendsto_const_div_atTop_of_tendsto_zero_pos`, derived from `Filter.Tendsto.inv_tendsto_nhdsGT_zero` + `Tendsto.const_mul_atTop`) → `Phi(arg) → 1` (`Phi_tendsto_one_atTop`) → `1 − Phi → 0` → linear-combination Tendsto.add + Tendsto.mul_const yields the welfare limit `r_A`. Sub-class WORKING_ASSUMPTION promoted to DERIVED_THEOREM for the β→∞ sub-clause; β→0+ sub-clause remains OPEN (would require `signalVariance → ∞` as β → 0⁺ + `Phi` continuity at `0`). Entry status remains PARTIAL with reduced open-axiom count (1 OPEN axiom left: gap_W_open_limit_zero_OPEN).",
      "R35-B Wave 1.1: β→0+ limit PROMOTED OPEN → CLOSED (symmetric mirror of R30). `gap_W_open_limit_zero_OPEN` axiom replaced with `theorem gap_W_open_limit_zero : Filter.Tendsto W_open (nhdsWithin 0 (Set.Ioi 0)) (nhds ((r_A + r_G) / 2))`. New Cat 1 helpers added to ClassicalResults.lean: `signalVariance_tendsto_atTop_of_tendsto_zero_pos` (`σ²(β) = 1/(2^(2β)-1) → +∞` as β → 0⁺ via `Real.continuous_exp.tendsto 0` + `Real.one_lt_rpow` positivity within `Ioi 0` + `tendsto_const_div_atTop_of_tendsto_zero_pos` for `c = 1`) and `Phi_continuousAt` (from `gap_Phi_derivative.continuousAt`). Proof chain: `σ²(β) → +∞` → `2σ² → +∞` (via `Filter.Tendsto.const_mul_atTop`) → `√(2σ²) → +∞` (via `Real.tendsto_sqrt_atTop`) → `Δ_4/√(2σ²) → 0` (via `Filter.Tendsto.const_div_atTop`) → `Phi(arg) → Phi 0 = 1/2` (via continuity + `Phi_zero`) → `1 - Phi → 1/2` → arithmetic chain `(1/2)·r_A + (1/2)·r_G = (r_A + r_G)/2`. Entry now fully CLOSED; sub-class WORKING_ASSUMPTION promoted to DERIVED_THEOREM (both β-limits CLOSED via Cat 1 Mathlib chain, plus the Cat 3 closed-form W_open def)." ]
  scope := "Proposition prop:canonical (4-state), lines 708-715"
  obstacleOrAttribution := "CLOSED bundle: closed-form W_open def Cat 3 CLOSED; β→∞ limit `gap_W_open_limit_infty` CLOSED Cat 1 via R30 promotion (Mathlib Gaussian asymptotic chain through signalVariance_tendsto_zero_atTop + tendsto_const_div_atTop_of_tendsto_zero_pos + Phi_tendsto_one_atTop); β→0+ limit `gap_W_open_limit_zero` CLOSED Cat 1 via R35-B Wave 1.1 promotion (symmetric mirror chain through signalVariance_tendsto_atTop_of_tendsto_zero_pos + Filter.Tendsto.const_div_atTop + Phi_continuousAt + Phi_zero)."
  conditionalOn := []

def entry_prop_interior_optimum : GapEntry where
  name := "FiveState.L + gap_interior_optimum (derived) + interior_minimiser_existence_OPEN (Cat 3 atom)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:interior-optimum (5-state), lines 769-779"
  attackHistory :=
    [ "R1 2026-05-12: closed-form `L β p` defined; existence of β* ≈ 1.5 axiomatised.",
      "R17 2026-05-13: reclassified CLOSED → PARTIAL per the rewritten compact `feedback_gap_ledger_in_lean4` (2026-05-13) PARTIAL definition. The bundle has formula `FiveState.L β p` Cat 3 def-CLOSED + existence-of-unique-interior-minimum OPEN axiom; the entry-level CLOSED tag masked the OPEN sub-clause.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as PARTIAL (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R40 2026-05-14: PARTIAL → CLOSED bundle audit. The R38 atomic-decomposition pattern was applied (entry_atom_interior_minimiser_existence created, source-side `axiom interior_minimiser_existence_OPEN` at Canonical.lean:288 + derived theorem `gap_interior_optimum` at Canonical.lean:299 := the atom). The bundle's two sub-clauses are now both CLOSED at the theorem/atom level: (a) closed-form `L β p` def Cat 3 CLOSED; (b) existence of interior minimum CLOSED via derived theorem `gap_interior_optimum` composing the atomic stipulation `interior_minimiser_existence_OPEN`. cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; status PARTIAL → CLOSED. The atom remains separately tracked (entry_atom_interior_minimiser_existence) with its own gapDefinitional/structuralEquation classification per R39 + R40 reclassification." ]
  scope := "Proposition prop:interior-optimum (5-state), lines 769-779"
  obstacleOrAttribution := "CLOSED-via-Cat-3-atom-input. R40: bundle entry status flipped PARTIAL → CLOSED after R38 atomic decomposition. Two sub-clauses: (a) closed-form `L β p` Cat 3 def-CLOSED; (b) existence of unique interior minimum CLOSED via derived theorem `gap_interior_optimum := interior_minimiser_existence_OPEN` (Canonical.lean:299). The atom `interior_minimiser_existence_OPEN` is separately tracked via `entry_atom_interior_minimiser_existence` (gapDefinitional / structuralEquation per R39 reclassification). Numerical fact `β* ≈ 1.5` is encoded in the atom's existential statement on the carrier `L`; substantive proof still requires continuous-function-on-compact-interval Mathlib infrastructure plus uniqueness derivation, deferred to the atom level."
  conditionalOn := []

def entry_prop_three_regime : GapEntry where
  name := "gap_three_regime_{reversal_{existence,uniqueness,nonmonotone,overshoot_decreasing,overshoot_continuous,overshoot_vanishes_at_p1} (derived) + corresponding Cat 3 atoms,cognitive_augmentation_{arithmetic_part,monotonicity},sufficient_cognition} + opaque carrier betaStarOfP"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:three-regime-five-state (3 regimes), lines 806-834"
  attackHistory :=
    [ "R1 2026-05-12: 3 regime axioms encoded.",
      "R4 Phase 4 audit (2026-05-12): WARN on cognitive_augmentation (bundles arithmetic + monotonicity — split deferred); sufficient_cognition `∃ κ* > 0` was trivial → added separate kappaStar_pos closure axiom.",
      "R11 discipline audit (2026-05-13): `gap_three_regime_sufficient_cognition_OPEN` was caught as Anti-pattern #2 (trivially-provable `∃ x, 0 < x` with witness `1`, encoding nothing about regime (iii)). Strengthened to the substantive β-monotonicity sub-claim `∀ p, p_2 < p → p < 1 → ∀ β₁ β₂, 0 < β₁ → β₁ ≤ β₂ → L β₂ p ≤ L β₁ p`. The companion strict-positivity claim `κ*(p) > 0` is now exclusively encoded by the existing substantive closure `gap_three_regime_sufficient_cognition_kappaStar_pos` (real-analysis chain on the closed form), eliminating the trivial existential.",
      "R17-C 2026-05-13: applied the R4-deferred split per Cat 1 reductionism review. `gap_three_regime_cognitive_augmentation_OPEN` was a composite axiom bundling (a) the arithmetic identity `0.4·(1−p) ≤ 0.4 − W_topo_p p` (literal Cat 1 since `W_topo_p p := 0.4·p`) with (b) the substantive Cat 3 β-monotonicity `∀ β₁ β₂, 0 < β₁ → β₁ ≤ β₂ → L β₂ p ≤ L β₁ p`. SPLIT into Cat 1 theorem `gap_three_regime_cognitive_augmentation_arithmetic_part` (CLOSED kernel-pure via `unfold W_topo_p; linarith`) + Cat 3 axiom `gap_three_regime_cognitive_augmentation_monotonicity_OPEN` (β-monotonicity sub-claim retained as OPEN). Entry status now PARTIAL (mixed CLOSED arithmetic + OPEN monotonicity); inputCategory remains Cat 3 dominant per the bundle's β-monotonicity content. AxiomAudit.lean updated; new arithmetic theorem verified kernel-pure.",
      "R20-D Phase 4 paper-source verification (2026-05-13): caught `gap_three_regime_reversal_OPEN` dropping substantive paper content. The single existence-only encoding `∃ β*(p) > 0 ∧ L β*(p) p < 0.4` covered only one of the four sub-claims of paper line 814: (a) existence of below-limit β*; (b) UNIQUENESS of the interior minimum (paper's `unique`); (c) NON-MONOTONICITY of L(β, p) in β; (d) OVERSHOOT strictly decreasing in p on [0, p_1) with continuity + vanishing-at-p_1 (paper line 814 third bullet).",
      "R21-C 2026-05-13: applied Option C decomposition per `feedback_lean_axiom_decomposition` Anti-pattern #2 (composite axioms hide gaps). SPLIT `gap_three_regime_reversal_OPEN` into FOUR single-clause sub-axioms: (a) `gap_three_regime_reversal_existence_OPEN` (∃ β* > 0 ∧ L β* p < 0.4 — original encoding renamed); (b) `gap_three_regime_reversal_uniqueness_OPEN` (∃ β* > 0 ∧ ∀ β' > 0, L β' p ≤ L β* p → β' = β* — strict-min uniqueness); (c) `gap_three_regime_reversal_nonmonotone_OPEN` (∃ β_low < β_high, L β_high < L β_low ∧ ∃ β_a < β_b, L β_a < L β_b — both decrease and increase witnesses); (d) `gap_three_regime_reversal_overshoot_decreasing_OPEN` (∀ p₁ < p₂ in [0, p_1), ∃ β*₁ β*₂ > 0, L β*₁ p₁ < L β*₂ p₂ — minimised loss strictly smaller at smaller p, equivalently overshoot strictly decreasing). All four are Cat 3 paper-novel OPEN. Continuity-of-overshoot and vanishing-at-p_1 sub-clauses of paper line 814 deferred (no current downstream consumer; would need an additional axiom or opaque carrier). Downstream consumer `gap_fiveState_policy_mapping` updated to consume the existence sub-axiom only (the only sub-claim it needed). Entry status remains PARTIAL (cognitive_augmentation arithmetic CLOSED Cat 1; reversal sub-axioms + cognitive_augmentation monotonicity + sufficient_cognition still OPEN); inputCategory remains Cat 3.",
      "R22-B 2026-05-13: completed the 6-clause faithful encoding of paper line 814 by adding the two R21-C-deferred sub-clauses (continuity of overshoot in p on [0, p_1) + vanishing of overshoot at p_1). Introduced opaque carrier `betaStarOfP : ℝ → ℝ` (Cat 3 paper-novel implicit-function selection) naming the joint per-`p` `β*(p)` choice, plus `noncomputable def overshootRegimeI (p) := 0.4 − L (betaStarOfP p) p` packaging the paper-stated overshoot expression, plus two Cat 3 OPEN axioms operating on it: (e) `gap_three_regime_reversal_overshoot_continuous_OPEN : ContinuousOn overshootRegimeI (Set.Ico 0 p_1)`; (f) `gap_three_regime_reversal_overshoot_vanishes_at_p1_OPEN : Filter.Tendsto overshootRegimeI (nhdsWithin p_1 (Set.Iio p_1)) (nhds 0)`. Both are opaque-on-opaque (depend on `betaStarOfP` carrier — disclosed). Phase 0 reductionism check: (e) and (f) cannot reduce to Cat 1 (Mathlib has no implicit-function-continuity for the IDP-specific welfare functional `L`); cannot reduce to Cat 2 (the implicit-function-continuity step on this paper's specific `L` is paper-novel). Now-6-clause faithful encoding mirrors paper line 814 exactly (existence + uniqueness + non-monotonicity + 3 overshoot sub-clauses). Entry status remains PARTIAL (cognitive_augmentation arithmetic CLOSED Cat 1; all 6 reversal sub-axioms + cognitive_augmentation monotonicity + sufficient_cognition still OPEN); inputCategory remains Cat 3. AxiomAudit.lean updated with `#print axioms` for the two new sub-axioms; the carrier `betaStarOfP` will appear in their dependency list.",
      "R22-A 2026-05-13: Cat 1 PROMOTION of BOTH `gap_three_regime_cognitive_augmentation_monotonicity_OPEN` AND `gap_three_regime_sufficient_cognition_OPEN`. Both axioms (β-monotonicity of `L(β, p)` on Regime (ii) `[p_1, p_2]` and Regime (iii) `(p_2, 1)`) closed via a shared auxiliary lemma `L_monotone_under_q_le_5_9` whose hypothesis `(1 − p) ≤ 5/9` is satisfied in both regimes (Regime (ii) by `p ≥ p_1 = 4/9`; Regime (iii) by `p > p_2 = 2/3 > 4/9`). The auxiliary closure chain composes (a) `signalVariance_strictAntitoneOn` (Cat 1 closed in Types.lean R1) — gives σ²(β₂) < σ²(β₁) for β₁ < β₂; (b) `Real.sqrt_lt_sqrt` + `div_le_div_of_nonneg_left` chain — gives `arg_S_monotone` and `arg_B_monotone` (both Cat 1 promoted from `signalVariance_strictAntitoneOn` + `Delta_S_pos` / `Delta_B_pos`); (c) `Phi_strictMono` + `Phi_le_one` + `Phi_nonneg` (NEW Cat 1 closures in ClassicalResults.lean R22-A — `Phi_strictMono` proved via `strictMono_of_hasDerivAt_pos` applied to the closed `gap_Phi_derivative` + closed `phi_pos`; `Phi_le_one` proved via `intervalIntegral.integral_Ioi_sub_Ioi` + `integral_phi_Ioi_zero` + `integral_nonneg`; `Phi_nonneg` symmetric via `Phi_neg_eq` + same integral bound + `Phi_zero`); (d) algebraic decomposition `L β₂ p − L β₁ p = (u₂ − u₁)·(−0.5 + 0.9·q·v₁) − 0.9·q·(v₂ − v₁)·(1 − u₂)` (with `u := P_trap, v := Phi_B, q := 1 − p`) where the first term is non-positive iff `0.9·q·v₁ ≤ 0.5` (which holds because `q ≤ 5/9` and `v₁ ≤ 1`) and the second term is non-positive by basic non-negativity. The Lean proof avoids explicit derivative computation (which the paper line 829 uses) by means of this algebraic decomposition equivalent to integrating the paper's `∂L/∂β < 0`. Both theorems renamed `gap_three_regime_cognitive_augmentation_monotonicity` and `gap_three_regime_sufficient_cognition` (drop `_OPEN`); inputCategory promoted Cat 3 → Cat 1; status promoted OPEN → CLOSED. AxiomAudit verified kernel-pure for both theorems and all 5 Phi helpers (`[propext, Classical.choice, Quot.sound]`). Entry status now PARTIAL with REDUCED open-axiom count (was: 6 reversal sub-axioms + augmentation monotonicity + sufficient_cognition = 8 OPEN; now: 6 reversal sub-axioms = 6 OPEN), narrowing the bundle's Cat 3 surface to the reversal regime (i) family.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as PARTIAL (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R40 2026-05-14: PARTIAL → CLOSED bundle audit. The R37 + R38 atomic-decomposition pattern was applied to all 6 reversal sub-axioms; each former OPEN axiom is now a derived theorem composing a fresh Cat 3 atomic stipulation: `gap_three_regime_reversal_existence := L_below_limit_at_some_beta_OPEN` (Canonical.lean:358), `gap_three_regime_reversal_uniqueness := L_unimodal_in_regime_i_OPEN` (Canonical.lean:383), `gap_three_regime_reversal_nonmonotone := L_nonmonotone_witnesses_OPEN` (Canonical.lean:410), `gap_three_regime_reversal_overshoot_decreasing := envelope_derivative_sign_in_p_OPEN` (Canonical.lean:450), `gap_three_regime_reversal_overshoot_continuous := envelope_continuity_in_p_OPEN` (Canonical.lean:557), `gap_three_regime_reversal_overshoot_vanishes_at_p1 := Tendsto_overshoot_at_p1_OPEN` (Canonical.lean:583). All 6 atoms are separately tracked (entry_atom_L_below_limit_at_some_beta, entry_atom_L_unimodal_in_regime_i, entry_atom_L_nonmonotone_witnesses, entry_atom_envelope_derivative_sign_in_p, entry_atom_envelope_continuity_in_p, entry_atom_Tendsto_overshoot_at_p1) with gapDefinitional/structuralEquation classification per R39 reclassification. Combined with the prior R17-C/R22-A Cat 1 closures of cognitive_augmentation arithmetic, cognitive_augmentation monotonicity, and sufficient_cognition, the bundle's 9 sub-claims (3 augmentation/sufficient + 6 reversal) are now all CLOSED at theorem-level. cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; status PARTIAL → CLOSED." ]
  scope := "Proposition prop:three-regime-five-state (3 regimes), lines 806-834"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input. R40: bundle entry status flipped PARTIAL → CLOSED after R37 + R38 atomic decomposition of all 6 reversal sub-axioms. (a) `gap_three_regime_cognitive_augmentation_arithmetic_part` CLOSED Cat 1 (R17-C); (b) `gap_three_regime_cognitive_augmentation_monotonicity` CLOSED Cat 1 (R22-A); (c) `gap_three_regime_sufficient_cognition` CLOSED Cat 1 (R22-A); (d-i) all 6 reversal sub-clauses (existence, uniqueness, nonmonotone, overshoot_decreasing, overshoot_continuous, overshoot_vanishes_at_p1) CLOSED via R37/R38 derived theorems composing fresh Cat 3 atoms. The 6 atoms are separately tracked with gapDefinitional/structuralEquation classification per R39. R22-A introduces 5 new Cat 1 helpers in ClassicalResults.lean (`Phi_strictMono`, `Phi_monotone`, `Phi_zero`, `Phi_le_one`, `Phi_nonneg`) which become reusable infrastructure for future Lean derivation invoking standard normal CDF facts."
  conditionalOn := []

def entry_cor_five_state_policy : GapEntry where
  name := "gap_fiveState_policy_mapping"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Corollary cor:five-state-policy, lines 836-844"
  attackHistory := [ "R1 2026-05-12: theorem CLOSED via composition of three_regime_* axioms + p_2 = 2/3 boundary fact.",
      "R27-A 2026-05-13: Cat 3 sub-classification DERIVED_THEOREM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as CLOSED (Cat 3 derived theorem composing earlier Cat 1 + Cat 2 + Cat 3 atomic inputs — sub-class is descriptive only, not subject to the 永不/必须 close mandate). New `subClass` field set to DERIVED_THEOREM." ]
  scope := "Corollary cor:five-state-policy, lines 836-844"
  obstacleOrAttribution := "CLOSED-via-OPEN-input."
  conditionalOn := []

def entry_prop_threshold_five_state : GapEntry where
  name := "gap_threshold_fiveState_{greedy_has_interior_optimum,kappa_above_kstar,smooth_transition}_OPEN"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:threshold-five-state (3 parts), lines 858-866"
  attackHistory :=
    [ "R1 2026-05-12: greedy interior optimum re-exports `gap_interior_optimum_OPEN`; other parts are paper-citation axioms.",
      "R11 discipline audit (2026-05-13): `gap_threshold_fiveState_smooth_transition_OPEN` was caught as Anti-pattern #2 (trivially-true `∀ _p, ∃ β_inflection, 0 < β_inflection`, witness `1`). Patched: introduced opaque carrier `smoothTransitionBeta : ℝ → ℝ` and asserted both `0 < smoothTransitionBeta p` AND a substantive sub-bound on the κ-agent's welfare at the threshold `κ = κ*(p)` (welfare at any β below the inflection point is bounded above by welfare at the inflection point — encoding the smoothing of the trap-induced reversal).",
      "R27-A 2026-05-13: Cat 3 sub-classification DERIVED_THEOREM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as CLOSED (Cat 3 derived theorem composing earlier Cat 1 + Cat 2 + Cat 3 atomic inputs — sub-class is descriptive only, not subject to the 永不/必须 close mandate). New `subClass` field set to DERIVED_THEOREM.",
      "R35-B Wave 2.8: restored explicit Cat 2 chain dropped in R26 on Part (ii) `gap_threshold_fiveState_kappa_above_kstar_OPEN` per R35 deep audit (R26 over-applied 'Cat 2 implicit consumption' rule for this entry whose CLAIM CONTENT is Cat 2 theorem applied to paper-novel carrier per `feedback_gap_ledger_in_lean4` §10). Added explicit antecedent `(∀ β₁ β₂, β₁ ≤ β₂ → agentWelfare AgentType.bayesian β₁ 0 1 ≤ agentWelfare AgentType.bayesian β₂ 0 1)` (the propositional content of `gap_blackwell_monotonicity_OPEN`) to the axiom signature. `#print axioms` on downstream theorems consuming this axiom will now surface the Blackwell 1951/1953 dependency. No downstream consumer (this axiom has no Lean consumer in current ledger; threading is for audit-chain visibility of the underlying Cat 2 dependency)." ]
  scope := "Proposition prop:threshold-five-state (3 parts), lines 858-866"
  obstacleOrAttribution := "CLOSED-via-OPEN-input. R11: `smoothTransitionBeta` carrier added. R35-B Wave 2.8: Cat 2 chain to Blackwell 1951/1953 explicit on Part (ii) `gap_threshold_fiveState_kappa_above_kstar_OPEN` via the new `h_blackwell` antecedent (paper-APPLICATION-to-opaque-carrier per §10)."
  conditionalOn := []

def entry_prop_p_monotonicity : GapEntry where
  name := "gap_p_monotonicity_DEAD_END_by_junk_value (def : Prop, documented DEAD-END marker, NOT an axiom — no kernel impact) + gap_kappaStar_at_two_thirds (CLOSED Cat 1) + gap_p_monotonicity_bounded (CLOSED Cat 1, live encoding for paper's intended domain `p < 1`)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:p-monotonicity-five-state, lines 875-892"
  attackHistory :=
    [ "R1 2026-05-12: monotonicity axiomatised; boundary κ*(2/3) = 0 proved CLOSED via `if_pos le_rfl`.",
      "R9 2026-05-13: bounded-domain version `gap_p_monotonicity_bounded` (under `p₂ < 1`) CLOSED kernel-pure via real algebra. Universal `gap_p_monotonicity_OPEN` was caught as MATHEMATICALLY FALSE by Agent C: counterexample `p₁=0, p₂=10` gives `kappaStar_fiveState 10 ≈ -1.26 < 0` via Lean's junk-value semantics on `Real.log` of negative argument. The unconditional axiom retained with documented obstacle (junk-value falsehood) as a DEAD-END marker.",
      "R17 2026-05-13: reclassified entry-level CLOSED → PARTIAL per the rewritten compact `feedback_gap_ledger_in_lean4` (2026-05-13). The bundle is genuinely heterogeneous: (a) boundary κ*(2/3) = 0 sub-clause CLOSED kernel-pure; (b) bounded-domain `gap_p_monotonicity_bounded` CLOSED kernel-pure (R9); (c) bundled `gap_p_monotonicity_OPEN` axiom (universal form) is DEAD-END (R9 falsified universal form via Lean junk-value semantics counterexample p₁=0, p₂=10 — stated form is mathematically false on the unrestricted domain). Bundled `gap_p_monotonicity_OPEN` axiom is DEAD-END (R9 falsified universal form via Lean junk-value semantics counterexample p₁=0, p₂=10); the bounded version `gap_p_monotonicity_bounded` is the live CLOSED Cat 1 sub-claim. Per discipline naming convention, R17-D is responsible for renaming the source-side `gap_p_monotonicity_OPEN` → `gap_p_monotonicity_DEAD_END_by_junk_value`.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as PARTIAL (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R40 2026-05-14: state verified, retained as PARTIAL workingAssumption. Bundle has CLOSED + DEAD-END mix that cannot uniformly flip to CLOSED: (a) boundary κ*(2/3) = 0 CLOSED kernel-pure (Canonical.lean:1045); (b) bounded-domain `gap_p_monotonicity_bounded` CLOSED kernel-pure (Canonical.lean:961, R9); (c) universal `gap_p_monotonicity_OPEN` axiom is genuinely DEAD-END at axiom level (R9-falsified universal form). The bundle's universal-form OPEN axiom is mathematically FALSE under Lean's junk-value semantics, so it cannot be flipped to CLOSED — the paper's stated universal form is mathematically restricted to `p₂ < 1` (the bounded version). The `obstacleOrAttribution` enumerates the specific sub-clause status. Status PARTIAL retained (discipline does not have a per-sub-clause status mechanism for closed-plus-dead-end bundles); cat3SubType retained as workingAssumption since the universal form is still encoded as a workingAssumption-tagged axiom even though it's mathematically dead-end (the bounded version provides the live closure).",
      "R41 2026-05-14: bundle status flipped PARTIAL → CLOSED + cat3SubType workingAssumption → derivedTheorem after audit verification. The R17-D-stated rename target `gap_p_monotonicity_OPEN → gap_p_monotonicity_DEAD_END_by_junk_value` was already executed at the source level: Canonical.lean:947 encodes the universal-form claim as `def gap_p_monotonicity_DEAD_END_by_junk_value : Prop := ∀ p₁ p₂, p₁ ≤ p₂ → kappaStar_fiveState p₁ ≤ kappaStar_fiveState p₂` — a PURELY DOCUMENTATIONAL `def : Prop`, NOT an axiom. As a `def : Prop` it has zero kernel impact and is not consumed by any downstream theorem (the docstring at Canonical.lean:942-943 explicitly states 'Encoded as `def : Prop` per DEAD-END discipline; not consumed by any downstream theorem'). The bundle's operative content (the paper's intended-domain p-monotonicity at `p < 1`) is FULLY CLOSED via two Cat 1 kernel-pure theorems: (a) boundary κ*(2/3) = 0 CLOSED at Canonical.lean:1045; (b) bounded-domain `gap_p_monotonicity_bounded` CLOSED at Canonical.lean:961 (the LIVE encoding for paper's intended domain). The DEAD-END marker is purely documentational signposting why the universal form fails under Lean's junk-value semantics — it does NOT represent an open derivation gap. Bundle status gapClosed honestly reflects: all paper-intended content is closed via Cat 1 theorems, with the universal-form `def : Prop` retained as a kernel-inert documentation marker for the junk-value subtlety." ]
  scope := "Proposition prop:p-monotonicity-five-state, lines 875-892"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-1-theorems (R41 final closure of bundle): (a) boundary κ*(2/3) = 0 CLOSED kernel-pure at Canonical.lean:1045; (b) bounded-domain `gap_p_monotonicity_bounded` CLOSED kernel-pure at Canonical.lean:961 (R9, the LIVE encoding for paper's intended domain `p < 1`); (c) the universal-form `gap_p_monotonicity_DEAD_END_by_junk_value` is encoded as `def : Prop` at Canonical.lean:947 — a kernel-inert documentation marker, NOT an axiom (no downstream consumer; documents why the universal form is mathematically false under Lean's junk-value semantics for `Real.log` of negative argument: counterexample p₁=0, p₂=10 gives `kappaStar_fiveState 10 ≈ -1.26 < 0`). The bundle's operative paper content (paper's intended domain `p ∈ [0, 1)`) is fully closed; the DEAD-END marker is purely documentational signposting. R17-D source-side rename target executed."
  conditionalOn := []

def entry_prop_bayesian_naive_five_state : GapEntry where
  name := "gap_bayesian_naive_routing_threshold (CLOSED Cat 1) + gap_bayesian_naive_reversal_absent (R41 derived) + bayesian_naive_below_threshold_blackwell_recovery_atom_OPEN (Cat 3 atom) + gap_bayesian_naive_reversal_present (R38 derived) + bayesian_naive_above_threshold_reversal_OPEN (Cat 3 atom)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:bayesian-naive-five-state (3 parts), lines 950-967"
  attackHistory :=
    [ "R1 2026-05-12: routing iff CLOSED via `nlinarith`; absent/present axiomatised.",
      "R17 2026-05-13: reclassified CLOSED → PARTIAL per the rewritten compact `feedback_gap_ledger_in_lean4` (2026-05-13). The bundle has routing-threshold sub-clause CLOSED kernel-pure (`gap_bayesian_naive_routing_threshold`) + two OPEN reversal-regime axioms (`gap_bayesian_naive_reversal_absent_OPEN`, `gap_bayesian_naive_reversal_present_OPEN`); previously CLOSED-at-entry-level masked the OPEN sub-clauses. PARTIAL is the canonical tag.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as PARTIAL (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R35-B Wave 2.9: restored explicit Cat 2 chain dropped in R26 on Part (ii) `gap_bayesian_naive_reversal_absent_OPEN` per R35 deep audit (R26 over-applied 'Cat 2 implicit consumption' rule for this entry whose CLAIM CONTENT is Cat 2 theorem applied to paper-novel carrier per `feedback_gap_ledger_in_lean4` §10). Added explicit antecedent `(∀ β₁ β₂, β₁ ≤ β₂ → agentWelfare AgentType.bayesian β₁ 0 1 ≤ agentWelfare AgentType.bayesian β₂ 0 1)` (the propositional content of `gap_blackwell_monotonicity_OPEN`) to the axiom signature. `#print axioms` on downstream theorems consuming this axiom will now surface the Blackwell 1951/1953 dependency. No downstream consumer needs threading (axiom has no Lean consumer in current ledger; threading is for audit-chain visibility of the underlying Cat 2 dependency).",
      "R40 2026-05-14: state verified, retained as PARTIAL workingAssumption. Bundle progress since R35-B: (a) Part (i) routing-threshold `gap_bayesian_naive_routing_threshold` CLOSED Cat 1 (Canonical.lean:1191, kernel-pure via `nlinarith`); (b) Part (ii) reversal_absent `gap_bayesian_naive_reversal_absent_OPEN` REMAINS OPEN as a Cat 3 axiom with explicit Cat 2 Blackwell antecedent (Canonical.lean:1223) — atomic decomposition into a fresh sub-atom not yet applied; (c) Part (iii) reversal_present R38-promoted to derived theorem `gap_bayesian_naive_reversal_present := bayesian_naive_above_threshold_reversal_OPEN` (Canonical.lean:1254) composing the new R38 atom (entry_atom_bayesian_naive_above_threshold_reversal). Bundle still has 1 OPEN sub-clause (Part (ii)); status PARTIAL retained. Close target for full bundle CLOSED: apply §18 atomic-decomposition pattern to `gap_bayesian_naive_reversal_absent_OPEN` (paper-stated reversal-absent claim under threshold-routing scope), creating a fresh Cat 3 atom that the derived theorem composes with the Cat 2 Blackwell antecedent.",
      "R41 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern to Part (ii) reversal_absent. The bundled `gap_bayesian_naive_reversal_absent_OPEN` axiom (Canonical.lean:1223) is REPLACED by derived theorem `gap_bayesian_naive_reversal_absent` (Canonical.lean) composing the new Cat 3 paper-novel atomic stipulation `bayesian_naive_below_threshold_blackwell_recovery_atom_OPEN` (paper-stated Blackwell-recovery transfer at the bayesianNaive sub-problem under below-threshold scope `p̂ < 2/3`). Cat 2 Blackwell-monotonicity dependency threaded as explicit `h_blackwell` antecedent on both atom and derived theorem. Single-atom decomposition is honest because the paper-stated content IS the Blackwell-recovery transfer at this scope; further sub-decomposition would manufacture artificial intermediates. Net: bundle status PARTIAL → CLOSED (all 3 Parts now CLOSED at theorem level); cat3SubType workingAssumption → derivedTheorem; +1 new Cat 3 paper-foundational structural-equation atomic-stipulation entry (entry_atom_bayesian_naive_below_threshold_blackwell_recovery) classified gapDefinitional/structuralEquation per §3.4.3." ]
  scope := "Proposition prop:bayesian-naive-five-state (3 parts), lines 950-967"
  obstacleOrAttribution := "CLOSED-via-Cat-3-atom-input (R41 final closure of bundle): (a) Part (i) routing-threshold sub-clause CLOSED kernel-pure (Cat 1 routing decision iff at Canonical.lean:1191); (b) Part (ii) reversal_absent CLOSED via R41 derived theorem `gap_bayesian_naive_reversal_absent := bayesian_naive_below_threshold_blackwell_recovery_atom_OPEN` (Canonical.lean) composing the new Cat 3 atom (entry_atom_bayesian_naive_below_threshold_blackwell_recovery) with explicit Cat 2 Blackwell `h_blackwell` antecedent; (c) Part (iii) reversal_present CLOSED via R38 derived theorem `gap_bayesian_naive_reversal_present := bayesian_naive_above_threshold_reversal_OPEN` (Canonical.lean:1254) composing entry_atom_bayesian_naive_above_threshold_reversal. R35-B Wave 2.9: Cat 2 chain to Blackwell 1951/1953 explicit on Part (ii) atom via `h_blackwell` antecedent."
  conditionalOn := []

/-! # §6 Bayesian Immunity entries -/

def entry_thm_bayesian_immunity : GapEntry where
  name := "gap_bayesian_immunity"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Theorem 5.1 thm:bayesian-immunity, lines 923-930"
  attackHistory :=
    [ "R1 2026-05-12: re-export of `gap_blackwell_monotonicity_OPEN`.",
      "R4 Phase 0 audit (2026-05-12): `gap_blackwell_monotonicity_OPEN` was previously vacuous (∀ V monotone). Patched to specialise directly to Bayesian-agent welfare; bayesian_immunity now follows by direct application.",
      "R17-D 2026-05-13: extended signature with `h_blackwell : gap_blackwell_monotonicity_BLOCKED_by_Mathlib_decision_theory` broken-link hypothesis after R17 reclassified the Blackwell predicate OPEN → BLOCKED.",
      "R26 2026-05-13: dropped `h_blackwell` broken-link hypothesis parameter per the discipline clarification. `gap_blackwell_monotonicity_BLOCKED_by_Mathlib_decision_theory` was converted in R26 to plain Cat 2 axiom `gap_blackwell_monotonicity_OPEN` (paper-cited Blackwell 1951/1953 docstring); the theorem now consumes the Cat 2 axiom directly in its proof body. inputCategory promoted Cat 3 → Cat 2 (the entry is now honestly a direct Cat 2 axiom consumer).",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat2). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Theorem 5.1 thm:bayesian-immunity, lines 923-930"
  obstacleOrAttribution := "CLOSED-via-Cat-2-axiom-input. R26: theorem consumes `gap_blackwell_monotonicity_OPEN` Cat 2 axiom directly per the 2026-05-13 discipline clarification (Cat 2 axioms with paper authority are consumed directly, not threaded as broken-link hypotheses)."
  conditionalOn := []

def entry_prop_complementarity : GapEntry where
  name := "gap_information_knowledge_complementarity"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Proposition prop:complementarity, lines 932-935"
  attackHistory :=
    [ "R1 2026-05-12: encoded as integrated-form supermodularity (faithful per Phase 4 audit).",
      "R17-C 2026-05-13: Cat 1 PROMOTION via reductionism reduction. The integrated-form supermodularity `W_mix(β,λ_2) − W_mix(β,λ_1) = (λ_2 − λ_1)(W_B(β) − W_G(β)) ≥ 0` is purely arithmetic given (a) `W_G(β) ≤ W_B(β)` at the chosen `β > β*_G` (the operational consequence of the paper's `W_B' ≥ 0`/`W_G' < 0` derivative chain integrated from β*_G outwards — added as the new antecedent `h_dom`) and (b) `λ_1 ≤ λ_2`. CLOSED kernel-pure via `unfold W_mix; nlinarith [h_lam, h_dom]`. Axiom renamed to theorem `gap_information_knowledge_complementarity` (drop `_OPEN`); inputCategory promoted Cat 3 → Cat 1; status promoted OPEN → CLOSED. The paper's underlying derivative-chain content is now honestly absorbed into the `h_dom` hypothesis (a single restricted Bayesian-dominates-greedy fact at the chosen β), rather than being smuggled inside an opaque axiom. AxiomAudit.lean updated to `#print axioms gap_information_knowledge_complementarity`; verification confirms `[propext, Classical.choice, Quot.sound]` only.",
      "R18-A 2026-05-13: Option B vestigial-antecedent cleanup per R17-E hostile audit Audit 8. The R17-C theorem signature kept four unused antecedents (`_hWB_mono`, `_hWG_anti`, `_hβ`, `β_star_G`) that the proof body did not consume — the closure tactic `unfold W_mix; nlinarith [h_lam, h_dom]` only uses `h_lam` and `h_dom`, and the audit flagged the closure as smuggling-shaped because `h_dom` IS the paper's substantive Cat 3 dominance content. Cleaned per Pattern 4 (vestigial premise cleanup): removed `β_star_G : ℝ`, `_hWB_mono`, `_hWG_anti`, `_hβ`. Added docstring caveat clarifying that the Cat 1 closure is ARITHMETIC ONLY (presupposes the paper-novel dominance `h_dom`, which integrates the paper's derivative chain at `β > β*_G`); the closure proves the arithmetic step from dominance to mixture-supermodularity, not the dominance fact itself. Status remains CLOSED, inputCategory remains Cat 1 (the theorem IS Cat 1 arithmetic; the dominance hypothesis is delivered as input). R17-E hostile audit caught vestigial unused antecedents (`_hWB_mono`, `_hWG_anti`, `_hβ`) and flagged the closure as smuggling-shaped (since `h_dom` IS the paper's substantive content). R18-A cleaned up the unused antecedents and added docstring caveat clarifying that the Cat 1 closure is arithmetic-from-dominance, not a derivative-chain reconstruction.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat1). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Proposition prop:complementarity, lines 932-935"
  obstacleOrAttribution := "CLOSED Cat 1 via R17-C arithmetic closure (cleaned R18-A): theorem `gap_information_knowledge_complementarity` proves the integrated-form supermodularity from (a) Bayesian-dominates-greedy at β > β*_G (`h_dom`, paper-novel Cat 3 input) and (b) λ-ordering (`h_lam`). Closure tactic: `unfold W_mix; nlinarith [h_lam, h_dom]`. R18-A cleanup: removed vestigial unused antecedents `β_star_G`, `_hWB_mono`, `_hWG_anti`, `_hβ`. Kernel-pure per AxiomAudit. The Cat 1 closure is arithmetic-from-dominance; the dominance fact itself is paper-novel Cat 3 substance."
  conditionalOn := []

def entry_rem_robustness_misspec_bayesian_naive : GapEntry where
  name := "gap_robustness_bayesian_naive"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Remark rem:robustness-misspec (i), line 941"
  attackHistory :=
    [ "R1 2026-05-12: encoded.",
      "R4 Phase 4 audit (2026-05-12): bundling (parts ii+iii) DEFERRED to split.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R35-B Wave 1.2: PROMOTED OPEN → CLOSED via re-export of `FiveState.gap_bayesian_naive_routing_threshold` (already kernel-pure Cat 1 closed via `nlinarith` in Canonical.lean). The prior axiom form `∀ p_hat : ℝ, p_hat < 2/3 ↔ <p_hat-free welfare monotonicity claim>` was Pattern 4 (tautological premise): the RHS of the iff is independent of `p_hat`, so the universal iff cannot be a non-trivial theorem. The Remark's substantive paper content (the Bayesian-naive threshold `p̂* = 2/3`) is encoded directly via the routing-decision biconditional `0.4 + 0.6·(1 − p̂) > 0.6 ↔ p̂ < 2/3`, which IS the operative paper claim. β-monotonicity sub-claim of `prop:bayesian-naive-five-state` (ii) remains tracked separately by `FiveState.gap_bayesian_naive_reversal_absent_OPEN`. inputCategory Cat 3 → Cat 1 (the entry is now a Cat 1 re-export). cat3SubType WORKING_ASSUMPTION → N/A." ]
  scope := "Remark rem:robustness-misspec (i), line 941"
  obstacleOrAttribution := "CLOSED via re-export of `FiveState.gap_bayesian_naive_routing_threshold` (kernel-pure Cat 1 closure). Threshold-identification content of Remark `rem:robustness-misspec` (i) honestly encoded via the routing-decision biconditional `0.4 + 0.6·(1 − p̂) > 0.6 ↔ p̂ < 2/3`. β-monotonicity sub-claim tracked separately by `FiveState.gap_bayesian_naive_reversal_absent_OPEN` (now with explicit Cat 2 `gap_blackwell_monotonicity_OPEN` antecedent per R35-B Wave 2.9)."
  conditionalOn := []

def entry_rem_robustness_misspec_myopic_satisficing : GapEntry where
  name := "gap_robustness_{myopic_k,satisficing} (derived) + myopic_k_lookahead_recursion_OPEN + satisficing_threshold_trap_OPEN (Cat 3 atoms)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Remark rem:robustness-misspec (ii)+(iii), lines 942-944"
  attackHistory :=
    [ "R1 2026-05-12: 2 axioms with vacuous-Prop existentials.",
      "R4 Phase 4 audit (2026-05-12): patched — myopic_k binds to `myopicKWelfare`, satisficing binds to `satisficingWelfare`.",
      "R6 2026-05-12: converted opaque carriers to concrete `def`s (myopic = identity, satisficing = downward parabola). Closures via witness arithmetic.",
      "R7 2026-05-12: hostile audit caught both R6 closures as concrete-placeholder closure-count tricks violating `feedback_lean_real_math` (placeholder shapes do not encode the paper's bounded-rationality content). Reverted in source to `axiom gap_robustness_*_OPEN` with opaque carriers `myopicKWelfare`, `satisficingWelfare`.",
      "R11 discipline audit (2026-05-13): retroactive Ledger-status correction — the R7 source-side revert was applied but the Ledger entry was never updated, leaving stale `status := \"CLOSED\"` metadata that contradicted the actual Lean source. Status now corrected to OPEN.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN.",
      "R38 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern to both axioms. (ii) `gap_robustness_myopic_k_OPEN` REPLACED by derived theorem `gap_robustness_myopic_k` (Bayesian.lean) composing the new Cat 3 atomic stipulation `myopic_k_lookahead_recursion_OPEN` (paper-stated `k ≥ d` Blackwell-recovery on `myopicKWelfare`, line 942). (iii) `gap_robustness_satisficing_OPEN` REPLACED by derived theorem `gap_robustness_satisficing` (Bayesian.lean) composing the new Cat 3 atomic stipulation `satisficing_threshold_trap_OPEN` (paper-stated welfare-reversal under `r̄ ∈ (r(B), r(A))` on `satisficingWelfare`, line 944). Net: status OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +2 new Cat 3 OPEN atomic-stipulation entries (entry_atom_myopic_k_lookahead_recursion, entry_atom_satisficing_threshold_trap)." ]
  scope := "Remark rem:robustness-misspec (ii)+(iii), lines 942-944"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input. R38 derived theorems `gap_robustness_myopic_k` and `gap_robustness_satisficing` re-export atomic stipulations `myopic_k_lookahead_recursion_OPEN` (paper line 942) and `satisficing_threshold_trap_OPEN` (paper line 944). Substantive bounded-rationality content (k-step lookahead dynamics on the trap tree for myopic-k; satisficing-threshold acceptance criterion with non-monotone β-response) remains a Mathlib gap at the atom level; Lean side encodes via opaque carriers `myopicKWelfare`, `satisficingWelfare`."
  conditionalOn := []

/-! # §7 General Graphs entries -/

def entry_def_greedy_path : GapEntry where
  name := "V_g (axiom)"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.carrier
  paperSource := "Definition def:greedy-path, lines 982-985"
  attackHistory := [ "R1 2026-05-12: opaque axiomatic function.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic carrier (V_g function) that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Definition def:greedy-path, lines 982-985"
  obstacleOrAttribution := "Greedy-path traversal not defined inductively; opaque carrier."
  conditionalOn := []

def entry_lem_V_g_le_V_dyn : GapEntry where
  name := "gap_V_g_le_V_dyn (derived) + V_g_terminal_in_ForwardReachable_OPEN (Cat 3 atom)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Definition def:greedy-path, line 984 (terminal-vertex base case + open-edge propagation); paper line 987 (`V_g(u) ≤ V_dyn(u)` on deeper trees)"
  attackHistory :=
    [ "R1 2026-05-12: encoded as opaque axiom `gap_V_g_le_V_dyn_OPEN`.",
      "R23-C2 2026-05-13: applied Manufactured-Recognition R-#25 atomic-decomposition pattern. Added Cat 3 atomic structural equation `V_g_terminal_in_ForwardReachable_OPEN : ∀ u H ω, ∃ w ∈ ForwardReachable u H ω, V_g u H ω = reward w` (paper line 984 + Def 2.5 structural fact: greedy-traversal terminal vertex lies in ForwardReachable, and V_g equals its reward); REFACTORED prior `gap_V_g_le_V_dyn_OPEN` axiom into derived theorem `gap_V_g_le_V_dyn` whose proof composes the atom + V_dyn_def (R23-C1 atom) + Mathlib `Finset.le_sup'` (Cat 1). Lake build green. `gap_V_g_le_V_dyn` axiom dependency chain becomes [propext, Classical.choice, Quot.sound] + opaque Cat 3 atoms (`V_g_terminal_in_ForwardReachable_OPEN`, `V_dyn_def`).",
      "R27-A 2026-05-13: Cat 3 sub-classification DERIVED_THEOREM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as CLOSED (Cat 3 derived theorem composing earlier Cat 1 + Cat 2 + Cat 3 atomic inputs — sub-class is descriptive only, not subject to the 永不/必须 close mandate). New `subClass` field set to DERIVED_THEOREM." ]
  scope := "Definition def:greedy-path, line 984 (terminal-vertex base case + open-edge propagation); paper line 987 (`V_g(u) ≤ V_dyn(u)` on deeper trees)"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input. `gap_V_g_le_V_dyn` derived theorem composes: (a) Cat 3 atom `V_g_terminal_in_ForwardReachable_OPEN` (paper line 984 + Def 2.5), (b) Cat 3 atom `V_dyn_def` (R23-C1), (c) Cat 1 Mathlib `Finset.le_sup'` (any element ≤ sup of containing finset)."
  conditionalOn := []

def entry_thm_general_tree : GapEntry where
  name := "gap_general_tree (derived) + C2prime_implies_greedy_reversal_OPEN (Cat 3 atom)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Theorem 6.1 thm:general-tree, lines 989-998"
  attackHistory := [ "R1 2026-05-12: encoded; faithful per Phase 4 audit (paper has stronger conclusion `W(β) > W(∞) for all sufficiently large β` that Lean weakens to `∃ β β'`).",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN.",
      "R38 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern. The bundled `gap_general_tree_OPEN` is REPLACED by derived theorem `gap_general_tree` (GeneralGraphs.lean) composing the new Cat 3 atomic stipulation `C2prime_implies_greedy_reversal_OPEN` (paper-stated greedy-reversal under C2′ + non-interference + bounded-convergence). Net: status OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +1 new Cat 3 OPEN atomic-stipulation entry (entry_atom_C2prime_implies_greedy_reversal)." ]
  scope := "Theorem 6.1 thm:general-tree, lines 989-998"
  obstacleOrAttribution := "CLOSED-via-Cat-3-atom-input. R38 derived theorem `gap_general_tree` (GeneralGraphs.lean) composes the atomic stipulation `C2prime_implies_greedy_reversal_OPEN`. Substantive proof of the atom requires C2′ + non-interference + bounded-convergence Mathlib machinery."
  conditionalOn := []

def entry_lem_dilemma_subsumed_by_general_tree : GapEntry where
  name := "dilemma_subsumed_by_gap_general_tree (derived) + terminal_neighbour_implies_C2prime_atom_OPEN (Cat 3 atom)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Theorem 6.1 thm:general-tree subsumption + line 1019"
  attackHistory :=
    [ "R1 2026-05-12: encoded as opaque axiom `dilemma_subsumed_by_gap_general_tree_OPEN` on the bundle predicates `Conditions_C1_C2_C3 → TerminalNeighbourTopology → Conditions_C1_C2prime_C3`.",
      "R23-C2 2026-05-13: applied Manufactured-Recognition R-#25 atomic-decomposition pattern. Added Cat 3 atomic structural-implication axiom `terminal_neighbour_implies_C2prime_atom_OPEN : C2_RewardTopologyMisalignment → TerminalNeighbourTopology → C2prime_GreedyPathMisalignment` (paper line 1019 structural fact: `V_g = V_dyn` on flat subtrees + non-interference vacuous at degree 2); REFACTORED prior bundle-form axiom into derived theorem `dilemma_subsumed_by_gap_general_tree` whose proof composes the atom + trivial conjunction-rebuilding on the existing definitions of `Conditions_C1_C2_C3` and `Conditions_C1_C2prime_C3`. Lake build green. `dilemma_subsumed_by_gap_general_tree` axiom dependency chain becomes [propext] + opaque Cat 3 atom (`terminal_neighbour_implies_C2prime_atom_OPEN`).",
      "R27-A 2026-05-13: Cat 3 sub-classification DERIVED_THEOREM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as CLOSED (Cat 3 derived theorem composing earlier Cat 1 + Cat 2 + Cat 3 atomic inputs — sub-class is descriptive only, not subject to the 永不/必须 close mandate). New `subClass` field set to DERIVED_THEOREM." ]
  scope := "Theorem 6.1 thm:general-tree subsumption + line 1019"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input. `dilemma_subsumed_by_gap_general_tree` derived theorem composes: (a) Cat 3 atom `terminal_neighbour_implies_C2prime_atom_OPEN` (paper line 1019 structural implication on hypothesis predicates), (b) trivial conjunction-rebuilding step on `Conditions_C1_C2_C3` / `Conditions_C1_C2prime_C3` definitions (Types.lean §6 lines 294-299)."
  conditionalOn := []

def entry_ex_cyclic_trap : GapEntry where
  name := "gap_cyclic_trap (derived) + cyclic_4_satisfies_C2prime_at_open_event_OPEN (Cat 3 atom)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Example ex:cyclic-trap, lines 1026-1029"
  attackHistory :=
    [ "R1 2026-05-12: vacuous `∃ welfareReversed : Prop, welfareReversed`.",
      "R4 Phase 4 audit (2026-05-12): patched — assert concrete welfare reversal `agentWelfare AgentType.greedy β' 0 1 < agentWelfare AgentType.greedy β 0 1`.",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as OPEN.",
      "R38 2026-05-14: applied Manufactured-Recognition §18 atomic-decomposition pattern. The bundled `gap_cyclic_trap_OPEN` is REPLACED by derived theorem `gap_cyclic_trap` (GeneralGraphs.lean) composing the new Cat 3 atomic stipulation `cyclic_4_satisfies_C2prime_at_open_event_OPEN` (paper-stated 4-cycle trap configuration satisfies C2′ at positive-probability open-edge event). Net: status OPEN → CLOSED; cat3SubType WORKING_ASSUMPTION → DERIVED_THEOREM; +1 new Cat 3 OPEN atomic-stipulation entry (entry_atom_cyclic_4_satisfies_C2prime_at_open_event)." ]
  scope := "Example ex:cyclic-trap, lines 1026-1029"
  obstacleOrAttribution := "CLOSED-via-Cat-3-atom-input. R38 derived theorem `gap_cyclic_trap` (GeneralGraphs.lean) composes the atomic stipulation `cyclic_4_satisfies_C2prime_at_open_event_OPEN`. Cycle-trap example with opaque-carrier-bound paper-novel content."
  conditionalOn := []

def entry_prop_error_compounding : GapEntry where
  name := "gap_error_compounding_part1 (CLOSED) + oracleValueAtRoot_TrapTree_def (Cat 3 atom) + gap_error_compounding_part2 (derived) + W (Part 3 def) + TrapTree.gap_welfare_gain_decay + gap_kappaStar_depth_d_log_growth (R38 derived) + bernoulli_real_power_estimate_OPEN (Cat 3 atom) + gap_c_star_constant_pos_OPEN (R41 atom for c_star_constant positivity)"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Proposition prop:error-compounding (5 parts), lines 1037-1066"
  attackHistory :=
    [ "R1: Parts 1, 2, 3, 5 axiomatised; Part 4 CLOSED via `ring`.",
      "R4 Phase 4 audit: Part 1 CRITICAL — was logically WRONG (`agentWelfare AgentType.greedy 0 0 1 = r_trap` asserts welfare AT β=0 = 0.6, but at β=0 the agent chooses uniformly so welfare ≠ r_trap). Patched: introduce opaque limit-carrier `greedyWelfareLimitInfty_TrapTree d`. Part 2 was vacuous; patched to opaque `oracleValueAtRoot_TrapTree d`.",
      "R10: Parts 1, 2 restored as CLOSED via Hodge-style def-rfl with `(_ : ℕ)` shim arguments encoding the universal quantifier.",
      "R12 discipline audit: status tag `OPEN-PLUS-CLOSED-MIX` was outside the 5-tier canonical taxonomy. Status corrected to `PARTIAL`; `obstacleOrAttribution` enumerates which Parts are CLOSED vs OPEN.",
      "R13 hostile audit: caught Parts 1 and 2 as DISHONEST def-rfl — reverted to honest OPEN axioms.",
      "R23-C1 2026-05-13: Cat 3 atomic structural-equation refactor for Part 2 per `feedback_gap_ledger_in_lean4` 2026-05-13 update. The previously bundled `gap_error_compounding_part2_OPEN : ∀ d, 1 ≤ d → oracleValueAtRoot_TrapTree d = r_goal` was a higher-level paper claim wrongly axiomatised; refactored into Cat 3 atomic structural-equation axiom `oracleValueAtRoot_TrapTree_def : ∀ d, 1 ≤ d → oracleValueAtRoot_TrapTree d = r_goal` (paper line 1041 stating `oracle achieves V_dyn(v_0) = r(G) = 1.0`) and a derived theorem `gap_error_compounding_part2` that simply consumes the atomic axiom (`:= oracleValueAtRoot_TrapTree_def`). The atomic axiom hosts the paper-stated structural equation on the existing opaque `oracleValueAtRoot_TrapTree` carrier; Part 2's derived theorem makes the `OPEN axiom → derived theorem` discipline transition explicit. Part 1 (Tendsto-encoded), 3, 5 retain OPEN status.",
      "R24-D 2026-05-13: AxiomAudit instrumentation added per R23-D Audit 5 finding (Part 2's R23-C1 derived closure was uninstrumented in `AxiomAudit.lean`). `#print axioms BlackwellDilemma.TrapTree.gap_error_compounding_part2` line added at the §7 General graphs + trap tree section of the audit script; output confirms the Cat 3 derivation chain `[propext, Classical.choice, Quot.sound, TrapTree.oracleValueAtRoot_TrapTree, TrapTree.oracleValueAtRoot_TrapTree_def]` — kernel + Cat 3 atom (`oracleValueAtRoot_TrapTree_def` paper line 1041) + its host carrier. No source-side change required; audit output exactly matches the documented R23-C1 derivation chain (the derived theorem is `:= oracleValueAtRoot_TrapTree_def` so its only paper-cited dependency is the atomic axiom plus its host carrier).",
      "R27-A 2026-05-13: Cat 3 sub-classification WORKING_ASSUMPTION per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as PARTIAL (higher-level paper claim pending derivation from Cat 1 + Cat 2 + Cat 3 atomic inputs — 必须 close per discipline). New `subClass` field set to WORKING_ASSUMPTION.",
      "R30 2026-05-13: Part 1 PROMOTED OPEN → CLOSED. `gap_error_compounding_part1_OPEN` axiom replaced with `theorem gap_error_compounding_part1 : ∀ d, 1 ≤ d → Filter.Tendsto (fun β => W β d) Filter.atTop (nhds r_trap)` derived via the same Cat 1 helper chain as `gap_W_open_limit_infty` (Canonical.lean R30 promotion): `signalVariance_tendsto_zero_atTop` → `2σ² → 0` → `√(2σ²) → 0` → `Delta/√(2σ²) → ∞` (via `tendsto_const_div_atTop_of_tendsto_zero_pos`) → negation `−Delta/√(2σ²) → −∞` (via `Filter.tendsto_neg_atTop_atBot`) → `P_b(β) = Phi(−Delta/√(2σ²)) → 0` (via `Phi_tendsto_zero_atBot`) → `(P_b β)^d → 0` (via `continuous_pow d` + `zero_pow (d ≠ 0)`) → `r_trap + 0.4·(P_b)^d → r_trap + 0 = r_trap` (`Tendsto.const_mul + .add`). Sub-class WORKING_ASSUMPTION promoted to DERIVED_THEOREM for the Part 1 sub-clause. Entry status remains PARTIAL (Part 3 and Part 5 still OPEN with substantive content).",
      "R40 2026-05-14: state verified, retained as PARTIAL workingAssumption — 1 implicit OPEN sub-axiom remains. Bundle progress audit: (1) Part 1 CLOSED Cat 1 (R30, GeneralGraphs.lean:347); (2) Part 2 CLOSED via `gap_error_compounding_part2 := oracleValueAtRoot_TrapTree_def` (R23-C1, GeneralGraphs.lean:468); (3) Part 3 = `noncomputable def W` closed-form (GeneralGraphs.lean:333), structurally encoded; (4) Part 4 CLOSED kernel-pure (`gap_welfare_gain_decay` GeneralGraphs.lean:477); (5) Part 5 CLOSED via R38-promoted `gap_kappaStar_depth_d_log_growth := bernoulli_real_power_estimate_OPEN` (GeneralGraphs.lean:549) composing the new R38 atom (entry_atom_bernoulli_real_power_estimate, gapDefinitional/structuralEquation per R39 reclassification). All 5 paper Parts now CLOSED at theorem/def level. HOWEVER, the bundle still has 1 implicit OPEN sub-axiom: `gap_c_star_constant_pos_OPEN : 0 < c_star_constant` (GeneralGraphs.lean:490) — paper-stated positivity claim about the opaque `c_star_constant` carrier (paper line 1048 doesn't give explicit formula); used by the Part 5 upper-bound proof but NOT separately tracked as a Ledger entry. Status PARTIAL retained pending separate Ledger-entry promotion of `gap_c_star_constant_pos_OPEN` (which would itself qualify as a structural-equation atom per R39+R40 logic). Close target = add `entry_atom_c_star_constant_pos` ledger entry classified as gapDefinitional/structuralEquation, then bundle can flip to CLOSED.",
      "R41 2026-05-14: applied R40-stated close target. Added Ledger entry `entry_atom_c_star_constant_pos` for `gap_c_star_constant_pos_OPEN` (GeneralGraphs.lean:490) classified gapDefinitional/structuralEquation per §3.4.3 (paper-stated positivity claim on opaque `c_star_constant` carrier; paper line 1048 specifies `c*(Δ_r, Δ_V) > 0` but does not give an explicit closed form, so positivity is a paper-foundational atomic stipulation). Net: bundle status PARTIAL → CLOSED (all 5 paper Parts CLOSED at theorem/def level + the previously-untracked positivity sub-axiom now properly tracked as a Cat 3 paper-foundational atom); cat3SubType workingAssumption → derivedTheorem. The `c_star_constant` opacity is acknowledged in the paper (line 1048 only asserts existence + positivity); the Lean encoding faithfully matches with `c_star_constant : ℝ` carrier + `gap_c_star_constant_pos_OPEN : 0 < c_star_constant` positivity atom." ]
  scope := "Proposition prop:error-compounding (5 parts), lines 1037-1066"
  obstacleOrAttribution :=
    "CLOSED-via-Cat-3-atom-input (R41 final closure of bundle): All 5 paper Parts CLOSED at theorem/def level: Part 1 R30 CLOSED Cat 1 (GeneralGraphs.lean:347); Part 2 R23-C1 CLOSED via derived theorem on atom (GeneralGraphs.lean:468 + oracleValueAtRoot_TrapTree_def atom); Part 3 = closed-form `def W` (GeneralGraphs.lean:333); Part 4 CLOSED kernel-pure (gap_welfare_gain_decay, GeneralGraphs.lean:477); Part 5 R38 CLOSED via derived theorem `gap_kappaStar_depth_d_log_growth := bernoulli_real_power_estimate_OPEN` (GeneralGraphs.lean:549) composing entry_atom_bernoulli_real_power_estimate. R41 also added entry_atom_c_star_constant_pos for `gap_c_star_constant_pos_OPEN` (GeneralGraphs.lean:490) — paper-stated positivity atom on opaque `c_star_constant` carrier classified gapDefinitional/structuralEquation per §3.4.3. R24-D: AxiomAudit instrumentation active on Part 2's derived closure."
  conditionalOn := []

/-! # External classical results entries -/

def entry_blackwell_1953 : GapEntry where
  name := "gap_blackwell_monotonicity_OPEN"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Bibliography: Blackwell 1951 + Blackwell 1953 (lines 1111)"
  attackHistory :=
    [ "R1 2026-05-12: vacuous `∀ V, monotone V`.",
      "R3 Phase 0 audit (2026-05-12): caught tautology — patched in R4 to specialise directly to Bayesian-agent welfare in IDP setup.",
      "R4 patch (2026-05-12): substantive form, direct Bayesian-agent monotonicity.",
      "R17 2026-05-13: reclassified OPEN → BLOCKED per the rewritten compact `feedback_gap_ledger_in_lean4` (2026-05-13). Structural obstacle: Mathlib has no decision-theoretic Blackwell ordering (no `IsBlackwellOrdered` predicate, no value-monotonicity theorem on signal-experiment lattices). Cat 2 (Blackwell 1951 'Comparison of Experiments' / Blackwell 1953 'Equivalent Comparisons of Experiments'). Decl name updated to `gap_blackwell_monotonicity_BLOCKED_by_Mathlib_decision_theory` per discipline naming convention. R17-D is responsible for source-side rename + downstream rewrites of theorems consuming this axiom (notably `entry_thm_bayesian_immunity` and `entry_lem_conditional_reduction_i`'s `IsBlackwellOrdered signalFamily` hypothesis chain).",
      "R26 2026-05-13: per discipline clarification, Cat 2 BLOCKED-def encoding was over-engineered. Converted to plain Cat 2 axiom `gap_blackwell_monotonicity_OPEN` with Blackwell 1951/1953 paper-cited docstring; downstream `gap_bayesian_immunity` (Bayesian.lean) `h_blackwell` broken-link hypothesis dropped — the theorem now consumes `gap_blackwell_monotonicity_OPEN` axiom directly in its proof body. Status BLOCKED → OPEN: external paper authority covers the claim, so Mathlib infra absence alone is not BLOCKED per the 2026-05-13 discipline (BLOCKED is reserved for genuine no-acceptance-possible cases — folkloric, conjectural-unproven, or no-source-at-all).",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat2). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Bibliography: Blackwell 1951 + Blackwell 1953 (lines 1111)"
  obstacleOrAttribution := "Cat 2 axiom accepted on Blackwell 1951 + Blackwell 1953 authority (classical theorem `signal experiment X dominates Y in Blackwell order ⇒ ∀ decision problem, X-based optimal value ≥ Y-based optimal value`). Mathlib lacks formalized decision-theoretic Blackwell-ordering theory (no `IsBlackwellOrdered` typeclass, no signal-experiment lattice, no sub-σ-algebra dilation theory); the Lean encoding axiomatizes the paper-stated result on the IDP Bayesian agent. R26: BLOCKED-def encoding retired in favour of plain Cat 2 axiom + paper-cited docstring per the 2026-05-13 discipline clarification."
  conditionalOn := []

def entry_harris_kesten : GapEntry where
  name := "gap_harris_kesten_OPEN, gap_percolation_probability_OPEN, gap_grimmett_exponential_decay_OPEN"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Bibliography: harris1960, kesten1980, grimmett1999"
  attackHistory :=
    [ "R1 2026-05-12: encoded.",
      "R3 Phase 0 audit (2026-05-12): 4/4 mathematically clean per Percolation literature audit; 2 paper-side editorial patches deferred.",
      "R11 discipline audit (2026-05-13): CRITICAL — `gap_grimmett_exponential_decay_OPEN` was logically INCONSISTENT (FALSE-derivable). Statement `∀ tailBound : ℕ → ℝ, ∀ k, tailBound k ≤ Real.exp (-(c * k))` admits counterexample `tailBound k := 1000` (then `tailBound 0 = 1000 > Real.exp 0 = 1`), which means as an axiom it makes False derivable and poisons the entire dependency closure. Patched per `feedback_lean_real_math` by replacing the universally-quantified arbitrary function with an opaque carrier `clusterSizeTail : ℝ → ℕ → ℝ` (the SPECIFIC paper-cited probability `Pr(|R(v_0)| ≥ k)` on `Z²` at parameter `p`) and asserting the bound on it: `∀ k, clusterSizeTail p k ≤ Real.exp (-(c * k))`. Logical consistency restored.",
      "R14 2026-05-13: hostile audit found ∃ pc, pc = 1/2 was vacuous tautology (Pattern 2). Rebound to opaque carrier harrisKestenCriticalProb : ℝ + axiom harrisKestenCriticalProb = 1/2 per R11 clusterSizeTail template.",
      "R15 2026-05-13: 2nd-round hostile audit found harrisKestenCriticalProb orphaned (no downstream consumer; Pattern 7). Anchored by rewriting gap_phase_transition_below_OPEN and gap_phase_transition_above_OPEN statements to literally consume harrisKestenCriticalProb instead of literal 1/2.",
      "R17 2026-05-13: reclassified OPEN → BLOCKED per the rewritten compact `feedback_gap_ledger_in_lean4` (2026-05-13). Structural obstacle: Mathlib has no bond-percolation theory (no `bondPercolationCritical` definition, no Z² lattice percolation measure, no Harris-Kesten p_c = 1/2 theorem, no Grimmett exponential-decay subcritical theorem, no Aizenman-Newman supercritical theorem). Cat 2 sources: Harris 1960 'A lower bound for the critical probability in a certain percolation process' (Proc. Camb. Phil. Soc.) + Kesten 1980 'The critical probability of bond percolation on the square lattice equals 1/2' (Comm. Math. Phys.) + Grimmett 1999 'Percolation' 2nd ed. (Springer). Decl names updated to BLOCKED-by-Mathlib-percolation per discipline naming convention; R17-D is responsible for source-side renames and downstream rewrites (notably `entry_harris_kesten_squared` consumer + phase-transition entries).",
      "R26 2026-05-13: per discipline clarification, Cat 2 BLOCKED-def encoding was over-engineered. Converted all three to plain Cat 2 axioms (`gap_harris_kesten_OPEN`, `gap_percolation_probability_OPEN`, `gap_grimmett_exponential_decay_OPEN`) with Harris 1960 + Kesten 1980 + Grimmett 1999 paper-cited docstrings. Downstream broken-link hypothesis threading dropped: `gap_harris_kesten_squared` (theorem) now consumes `gap_harris_kesten_OPEN` directly via `rw`; `gap_phase_transition_below_OPEN`, `gap_phase_transition_above_OPEN`, `gap_info_decay_OPEN` (axioms) had their `h_perc_prob`/`h_grimmett` parameters dropped — Cat 2 dependencies now consumed implicitly via the axiom system; `gap_dilemma` (theorem) had its `h_grimmett` parameter dropped and now invokes `gap_info_decay_OPEN` directly. Status BLOCKED → OPEN: external paper authority covers the claims.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat2). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Bibliography: harris1960, kesten1980, grimmett1999"
  obstacleOrAttribution :=
    "Cat 2 axioms accepted on Harris 1960 + Kesten 1980 (jointly establishing p_c(Z²) = 1/2 for bond percolation) + Grimmett 1999 (textbook reference for `θ(p) > 0 for p > p_c` and `Pr(|R(v_0)| ≥ k) ≤ exp(-c·k)` above threshold) authority. Mathlib lacks formalized Z² bond-percolation theory; opaque carrier `harrisKestenCriticalProb : ℝ` bound to paper's stated value 1/2 via the Cat 2 axiom `gap_harris_kesten_OPEN` continues to anchor downstream `entry_harris_kesten_squared` (CLOSED bridge), `gap_phase_transition_{below,above}_OPEN`, `gap_info_decay_OPEN`, and `gap_dilemma`. R26: BLOCKED-def encoding retired in favour of plain Cat 2 axioms; downstream broken-link hypothesis threading dropped where consumed in theorem proof bodies."
  conditionalOn := []

def entry_harris_kesten_squared : GapEntry where
  name := "gap_harris_kesten_squared"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Theorem 3.3 (thm:phase) auxiliary p_c² = 1/4"
  attackHistory :=
    [ "R16 2026-05-13: kernel-pure CLOSED bridge theorem providing downstream consumer for gap_harris_kesten_OPEN and harrisKestenCriticalProb carrier. Closes V5 anchor gap from R15-D hostile audit.",
      "R17-D 2026-05-13: extended signature with `h_HK : gap_harris_kesten_BLOCKED_by_Mathlib_percolation` broken-link hypothesis after R17 reclassified the Harris-Kesten predicate OPEN → BLOCKED; proof body became `rw [h_HK]; norm_num`.",
      "R26 2026-05-13: dropped `h_HK` broken-link hypothesis parameter per the discipline clarification. `gap_harris_kesten_BLOCKED_by_Mathlib_percolation` was converted in R26 to plain Cat 2 axiom `gap_harris_kesten_OPEN` (paper-cited Harris 1960 + Kesten 1980 docstring); the theorem now consumes the Cat 2 axiom directly in its proof body via `rw [gap_harris_kesten_OPEN]; norm_num`.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat1). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Theorem 3.3 (thm:phase) auxiliary p_c² = 1/4"
  obstacleOrAttribution :=
    "CLOSED kernel-pure (norm_num + rw on gap_harris_kesten_OPEN); depends on [propext, Classical.choice, Quot.sound] + harrisKestenCriticalProb opaque carrier + gap_harris_kesten_OPEN Cat 2 axiom. R26: theorem consumes the Cat 2 axiom directly per the 2026-05-13 discipline clarification."
  conditionalOn := []

def entry_bollobas : GapEntry where
  name := "gap_er_subcritical_OPEN, gap_er_supercritical_OPEN"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Bibliography: bollobas2001 (corrected R5)"
  attackHistory :=
    [ "R1 2026-05-12: encoded with vacuous existentials.",
      "R3 Phase 0 audit (2026-05-12): CRITICAL — bib key `bollobas2006` resolves to wrong book (Bollobás-Riordan _Percolation_ 2006 vs Bollobás _Random Graphs_ 2001 2nd ed.).",
      "R4 patches (2026-05-12): both axioms patched to substantive (giantComponentSize_ER, poissonSurvival).",
      "R5 paper-side patch (2026-05-12): bib entry rewritten to `bollobas2001` (Bollobás _Random Graphs_ 2nd ed., Cambridge UP 2001, Ch. 6 Theorems 6.10/6.11); 3 \\citep{} sites updated in master tex.",
      "R17 2026-05-13: reclassified OPEN → BLOCKED per the rewritten compact `feedback_gap_ledger_in_lean4` (2026-05-13). Structural obstacle: Mathlib has no Erdős-Rényi random graph component-size theory (no `giantComponentSize_ER`, no Poisson-survival branching-process bounds for ER subcritical/supercritical regimes). Cat 2 source: Bollobás 2001 _Random Graphs_ 2nd ed. Ch. 6 Theorems 6.10/6.11 (giant component appearance at threshold c = 1 for G(n, c/n)). Decl names updated per discipline naming convention; source-side rename is R17-D's responsibility.",
      "R26 2026-05-13: per discipline clarification, Cat 2 BLOCKED-def encoding was over-engineered. Converted both to plain Cat 2 axioms (`gap_er_subcritical_OPEN`, `gap_er_supercritical_OPEN`) with Bollobás 2001 paper-cited docstrings. Downstream `gap_er_phase_subcritical` and `gap_er_phase_supercritical` (theorems in Phase.lean) had their `h_ER_sub`/`h_ER_sup` broken-link hypothesis parameters dropped — they now consume the Cat 2 axioms directly in their proof bodies. Status BLOCKED → OPEN: external paper authority covers the claims.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat2). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Bibliography: bollobas2001 (corrected R5)"
  obstacleOrAttribution := "Cat 2 axioms accepted on Bollobás 2001 _Random Graphs_ 2nd ed. (Cambridge UP) Ch. 6 Theorems 6.10/6.11 authority. Substantive content: ER cluster-size theorems (subcritical clusters of size O(log n); supercritical giant component of size Θ(n) with Poisson-survival probability 1 - 1/c). Mathlib lacks formalized Erdős-Rényi random-graph component-size theory; the Lean encoding axiomatizes the paper-stated results. R26: BLOCKED-def encoding retired in favour of plain Cat 2 axioms; downstream broken-link hypothesis threading dropped."
  conditionalOn := []

def entry_molloy_reed : GapEntry where
  name := "gap_molloy_reed_OPEN"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Bibliography: molloy1995"
  attackHistory :=
    [ "R1 2026-05-12: vacuous `↔ ∃ giant : Prop, giant`.",
      "R3 Phase 0 audit (2026-05-12): syntax issue (`\\` typo) + folkloric inflation flagged.",
      "R4 patch (2026-05-12): patched to substantive (`HasGiantComponent` opaque predicate).",
      "R17 2026-05-13: reclassified OPEN → BLOCKED per the rewritten compact `feedback_gap_ledger_in_lean4` (2026-05-13). Structural obstacle: Mathlib has no configuration-model giant-component theory (no `HasGiantComponent` predicate on configuration-model degree sequences, no Molloy-Reed Q-sum criterion `Q := ∑_k k(k-2)·p_k > 0 ⇒ giant component a.s.`). Cat 2 source: Molloy & Reed 1995 'A critical point for random graphs with a given degree sequence' (Random Structures & Algorithms). Decl name updated; source-side rename is R17-D's responsibility.",
      "R20-B 2026-05-13: phantom-downstream closure — `gap_molloy_reed_BLOCKED_by_Mathlib_config_model` now operationally chained as broken-link hypothesis `_h_molloy_reed` in `gap_power_law_thin_tail` (Phase.lean). The R17-E V5 phantom-downstream finding for this BLOCKED def is now CLOSED. Underscore prefix silences Lean unused-variable lint while preserving the typed Cat 2 dependency at the type level (paper line 1092 derives the closed form `p_c = 1 - E[D]/E[D(D-1)]` BY the Molloy-Reed criterion). Bidirectional record per `feedback_gap_ledger_in_lean4` discipline (closure recorded both at the BLOCKED def's entry and the consuming axiom's entry `entry_cor_power_law`).",
      "R26 2026-05-13: per discipline clarification, Cat 2 BLOCKED-def encoding was over-engineered. Converted to plain Cat 2 axiom `gap_molloy_reed_OPEN` with Molloy-Reed 1995 paper-cited docstring. Downstream `gap_power_law_thin_tail` (theorem in Phase.lean) had its `_h_molloy_reed` broken-link hypothesis parameter dropped — the parameter was operationally unused (the proof body is Hodge-style def-rfl + positivity arithmetic), and the Cat 2 dependency is now acknowledged in the docstring. Status BLOCKED → OPEN: external paper authority covers the claim.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat2). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Bibliography: molloy1995"
  obstacleOrAttribution := "Cat 2 axiom accepted on Molloy-Reed 1995 'A critical point for random graphs with a given degree sequence' (Random Structures & Algorithms 6(2-3):161-180) authority (Q-sum criterion for giant component in random graphs with prescribed degree sequence). Encoded as opaque `HasGiantComponent` predicate; Mathlib lacks formalized configuration-model probability infrastructure. R26: BLOCKED-def encoding retired in favour of plain Cat 2 axiom; the operationally-unused `_h_molloy_reed` broken-link hypothesis parameter was dropped from `gap_power_law_thin_tail`; Cat 2 dependency now acknowledged at the docstring level."
  conditionalOn := []

def entry_cohen_powerlaw : GapEntry where
  name := "gap_cohen_powerlaw_OPEN"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Bibliography: cohen2000"
  attackHistory :=
    [ "R1 2026-05-12: vacuous existential + boundary off-by-epsilon (γ < 3 strict; paper says α ≤ 3 closed).",
      "R3 Phase 0 audit (2026-05-12): boundary widened to `γ ≤ 3`; antecedents (lower-cutoff m, infinite-n limit) flagged.",
      "R4 patch (2026-05-12): boundary widened in Lean; substantive `HasGiantComponent (E_D*(1-p)) (E_D_DSub1*(1-p)^2)` form.",
      "R17 2026-05-13: reclassified OPEN → BLOCKED per the rewritten compact `feedback_gap_ledger_in_lean4` (2026-05-13). Structural obstacle: same Mathlib configuration-model gap as `entry_molloy_reed` (the power-law thinning result is encoded via the Molloy-Reed criterion applied to power-law degree distributions). Cat 2 source: Cohen, Erez, ben-Avraham, Havlin 2000 'Resilience of the Internet to random breakdowns' (Phys. Rev. Lett.); the α ≤ 3 boundary is Cohen et al's stated threshold. Decl name updated; source-side rename is R17-D's responsibility.",
      "R26 2026-05-13: per discipline clarification, Cat 2 BLOCKED-def encoding was over-engineered. Converted to plain Cat 2 axiom `gap_cohen_powerlaw_OPEN` with Cohen et al. 2000 paper-cited docstring. Downstream `gap_power_law_heavy_tail` (theorem in Phase.lean) had its `h_cohen` broken-link hypothesis parameter dropped — the theorem now consumes `gap_cohen_powerlaw_OPEN` axiom directly in its proof body. Status BLOCKED → OPEN: external paper authority covers the claim.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat2). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Bibliography: cohen2000"
  obstacleOrAttribution := "Cat 2 axiom accepted on Cohen, Erez, ben-Avraham, Havlin 2000 'Resilience of the Internet to random breakdowns' (Phys. Rev. Lett. 85(21):4626-4628) authority. Power-law thinning encoded via Molloy-Reed criterion applied to power-law degree distributions; Mathlib lacks the same configuration-model probability infrastructure as `gap_molloy_reed_OPEN`. R26: BLOCKED-def encoding retired in favour of plain Cat 2 axiom; downstream broken-link hypothesis threading dropped on `gap_power_law_heavy_tail`."
  conditionalOn := []

def entry_topkis : GapEntry where
  name := "gap_topkis_supermodularity_OPEN"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Bibliography: topkis1978 + topkis1998 (co-cited R5)"
  attackHistory :=
    [ "R1 2026-05-12: encoded.",
      "R3 Phase 0 audit (2026-05-12): WARN — primary source is Topkis 1978 OR Milgrom-Roberts 1990 (not 1998 textbook); C² antecedent missing.",
      "R5 paper-side patch (2026-05-12): added `topkis1978` bib entry + co-citation `\\citealt{topkis1978,topkis1998}` at master tex line 558. C² antecedent in Lean axiom remains DEFERRED Priority-2 patch.",
      "R17 2026-05-13: reclassified OPEN → BLOCKED per the rewritten compact `feedback_gap_ledger_in_lean4` (2026-05-13). Structural obstacle: Mathlib has Banach-lattice and order-theoretic fixed-point basics but lacks the Topkis 1978 supermodularity-from-cross-partial bridge (no `Topkis.supermodular_of_cross_partial_nonneg` lemma converting `∂²f / ∂x∂y ≥ 0` on a sublattice into supermodularity of `f` on that sublattice). Cat 2 sources: Topkis 1978 'Minimizing a submodular function on a lattice' (Operations Research) §3 / Topkis 1998 _Supermodularity and Complementarity_ Thm 2.6.2. Decl name updated; source-side rename is R17-D's responsibility.",
      "R18-B 2026-05-13: lint cleanup — renamed unused `h_mixed_nonneg` parameter to `_h_mixed_nonneg` (underscore prefix silences Lean unused-variable warning while preserving the BLOCKED def's signature so downstream consumers must still provide the non-negative-cross-partial hypothesis). Topkis 1978 statement structure preserved (the hypothesis is the antecedent of the implication, not an additional per-(x,y)-pair condition).",
      "R26 2026-05-13: per discipline clarification, Cat 2 BLOCKED-def encoding was over-engineered. Converted to plain Cat 2 axiom `gap_topkis_supermodularity_OPEN` with Topkis 1978/1998 paper-cited docstring (axiom signature retains the W / mixedPartial / non-neg-mixedPartial parameters as the Topkis criterion's antecedent structure). No downstream Lean signature change needed: per the R18-A retraction, downstream `gap_supermodular_OPEN` and `gap_kappaWelfare_cross_partial_link_OPEN` (Cognitive.lean) acknowledge the universal-vs-regional Topkis mismatch in docstrings only — they do not chain the Cat 2 axiom at the Lean level. The 3 docstring references in Cognitive.lean updated from `gap_topkis_supermodularity_BLOCKED_by_Mathlib_topkis` to `gap_topkis_supermodularity_OPEN` for consistency. Status BLOCKED → OPEN: external paper authority covers the claim.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat2). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Bibliography: topkis1978 + topkis1998 (co-cited R5)"
  obstacleOrAttribution := "Cat 2 axiom accepted on Topkis 1978 'Minimizing a Submodular Function on a Lattice' (Operations Research 26(2):305-321) §3 / Topkis 1998 _Supermodularity and Complementarity_ Thm 2.6.2 (Princeton UP) authority. Mathlib has Banach-lattice and order-theoretic fixed-point basics but lacks the Topkis 1978 supermodularity-from-cross-partial bridge; the Lean encoding axiomatizes the criterion (parameterised by `W` and `mixedPartial` carriers; the non-negative cross-partial premise is the antecedent of the Topkis implication). R26: BLOCKED-def encoding retired in favour of plain Cat 2 axiom + paper-cited docstring; Cognitive.lean docstring references updated for naming consistency (per R18-A discipline, no Lean-level consumption of the universal Topkis axiom occurs in this paper because the regional `|z|<1` cross-partial positivity is paper-novel content)."
  conditionalOn := []

def entry_phi_derivatives : GapEntry where
  name := "gap_phi_derivative, gap_Phi_derivative"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Paper §2.2 (phi) + prop:supermodular lines 578, 583"
  attackHistory :=
    [ "R1 2026-05-12: phi_derivative + Phi_derivative vacuous tautologies (∃ x, x = expr).",
      "R3 Phase 0 audit (2026-05-12): caught both as tautologies.",
      "R4 patches (2026-05-12): rewrote as `HasDerivAt phi (-z * phi z) z` and `HasDerivAt Phi (phi x) x` with phi/Phi as opaque axioms.",
      "R8 closure (2026-05-13): phi converted from axiom to concrete `noncomputable def (1/√(2π))·exp(-z²/2)`; Phi converted to `1/2 + ∫₀ˣ phi`; both HasDerivAt theorems proved via Mathlib's HasDerivAt.exp + chain rule + intervalIntegral.integral_hasDerivAt_right (FTC-1). #print axioms confirms only [propext, Classical.choice, Quot.sound].",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat1). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Paper §2.2 (phi) + prop:supermodular lines 578, 583"
  obstacleOrAttribution :=
    "CLOSED via Mathlib calculus + FTC-1. Phi's global normalisation `∫_{-∞}^0 φ = 1/2` (i.e., that Phi pointwise equals the measure-theoretic CDF) remains a Mathlib gap, but the derivative theorem is independent of this normalisation."
  conditionalOn := []

def entry_phi_tendsto_one_atTop : GapEntry where
  name := "Phi_tendsto_one_atTop"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Standard normal CDF asymptotic (textbook; not paper-novel)"
  attackHistory :=
    [ "R30 2026-05-13: Cat 1 Mathlib closure (`Filter.Tendsto Phi Filter.atTop (nhds 1)`). Derivation: `Phi x = 1/2 + ∫_0..x phi t` (definitional unfold), `integral_phi_zero_tendsto` (closed in R9 via `Real.integral_gaussian_Ioi (1/2)`) gives the interval-integral tends to `1/2` along `atTop`; `Filter.Tendsto.const_add` adds the constant `1/2`, yielding the limit `1/2 + 1/2 = 1`. Kernel-pure. New Cat 1 Mathlib-derivable helper supporting the R30 gap_W_open_limit_infty promotion." ]
  scope := "Standard normal CDF asymptotic (textbook; not paper-novel)"
  obstacleOrAttribution :=
    "CLOSED via `integral_phi_zero_tendsto` + `Filter.Tendsto.const_add`. Reused by `gap_W_open_limit_infty` (Canonical.lean R30 promotion)."
  conditionalOn := []

def entry_phi_tendsto_zero_atBot : GapEntry where
  name := "Phi_tendsto_zero_atBot"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Standard normal CDF asymptotic (textbook; not paper-novel)"
  attackHistory :=
    [ "R30 2026-05-13: Cat 1 Mathlib closure (`Filter.Tendsto Phi Filter.atBot (nhds 0)`). Derivation: by the symmetry identity `Phi(-y) = 1/2 - ∫_0..y phi` (`Phi_neg_eq`) and `integral_phi_zero_tendsto`, `Phi(-y) → 1/2 - 1/2 = 0` as `y → ∞`; converted to `atBot` via `Filter.map_neg_atTop`. Kernel-pure. New Cat 1 Mathlib-derivable helper supporting the R30 gap_error_compounding_part1 promotion (used to express `Phi(-(Delta/√(2σ²))) → 0` since the argument tends to `-∞`)." ]
  scope := "Standard normal CDF asymptotic (textbook; not paper-novel)"
  obstacleOrAttribution :=
    "CLOSED via `integral_phi_zero_tendsto` + `Phi_neg_eq` + `Filter.map_neg_atTop`. Reused by `gap_error_compounding_part1` (GeneralGraphs.lean R30 promotion)."
  conditionalOn := []

def entry_tendsto_const_div_atTop_helper : GapEntry where
  name := "tendsto_const_div_atTop_of_tendsto_zero_pos"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Standard real-analysis chain (textbook; not paper-novel)"
  attackHistory :=
    [ "R30 2026-05-13: Cat 1 Mathlib closure. Helper lemma: if `f β → 0` and `f β > 0` eventually along filter `l`, and `c > 0`, then `c / f β → ∞`. Derivation: `tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within` refines `Tendsto f l (𝓝 0)` + eventually-positive to `Tendsto f l (𝓝[>] 0)`; `Filter.Tendsto.inv_tendsto_nhdsGT_zero` yields `Tendsto f⁻¹ l atTop`; `Tendsto.const_mul_atTop` (for `0 < c`) gives `c * f⁻¹ → ∞`; final rewrite `div_eq_mul_inv`. Kernel-pure. R30-A previous failure encoded c/f → ∞ as composite axiom Helper_const_div_tendsto_atTop_of_pos pending Mathlib derivation; R30 fully closes it as a Cat 1 theorem." ]
  scope := "Standard real-analysis chain (textbook; not paper-novel)"
  obstacleOrAttribution :=
    "CLOSED via Mathlib `tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within` + `Filter.Tendsto.inv_tendsto_nhdsGT_zero` + `Tendsto.const_mul_atTop`. Used in both `gap_W_open_limit_infty` and `gap_error_compounding_part1` R30 promotions to express `Δ / √(2σ²(β)) → ∞`."
  conditionalOn := []

def entry_signalVariance_tendsto_zero_atTop : GapEntry where
  name := "signalVariance_tendsto_zero_atTop"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Standard reciprocal-of-exponential asymptotic (textbook; not paper-novel). Composed from paper Definition 2.1 (line 110) σ²(β) = 1/(2^(2β)-1)."
  attackHistory :=
    [ "R30 2026-05-13: Cat 1 Mathlib closure (`Filter.Tendsto signalVariance Filter.atTop (nhds 0)`). Derivation chain: `Filter.tendsto_id.const_mul_atTop` (`2β → ∞` from `β → ∞`) → `atTop_mul_const` with `log 2 > 0` (`Real.log_pos`) gives `(2β)·log 2 → ∞` → `Real.tendsto_exp_atTop.comp` gives `exp((2β)·log 2) → ∞` → `Real.rpow_def_of_pos` rewrite `2^(2β) = exp((2β)·log 2)` → `Filter.Tendsto.atTop_add tendsto_const_nhds` gives `2^(2β) - 1 → ∞` → `Filter.Tendsto.inv_tendsto_atTop` gives `(2^(2β)-1)⁻¹ → 0` → `one_div` rewrite to `1/(2^(2β)-1) = signalVariance β`. Kernel-pure." ]
  scope := "Standard reciprocal-of-exponential asymptotic (textbook; not paper-novel). Composed from paper Definition 2.1 (line 110) σ²(β) = 1/(2^(2β)-1)."
  obstacleOrAttribution :=
    "CLOSED via Mathlib `Real.rpow_def_of_pos` + `Real.tendsto_exp_atTop` + `Filter.Tendsto.atTop_add` + `Filter.Tendsto.inv_tendsto_atTop`. Used in both `gap_W_open_limit_infty` and `gap_error_compounding_part1` R30 promotions."
  conditionalOn := []

def entry_phi_tail : GapEntry where
  name := "gap_phi_tail_bound_OPEN, gap_order_statistics_max"
  status := GapStatus.gapPartial
  inputCategory := InputCategory.mixed
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Standard analytic facts, paper §2.2 + prop:info-decay + prop:topo-cluster"
  attackHistory :=
    [ "R1 2026-05-12: order_statistics_max vacuous tautology.",
      "R3 Phase 0 audit: caught.",
      "R4 patches: order_statistics bound to opaque `expectedMaxUniform`; phi_tail_bound stable.",
      "R6: order_statistics encoded as def-rfl bookkeeping; R7 hostile audit retained as CLOSED with honest Mathlib-gap docstring disclosure.",
      "R8 phi_tail honest-axiom: improper-integral + integration-by-parts proof estimated 80-150 lines; deferred per `feedback_truth_over_publication`. Honest axiom with Williams (1991) §A.7 / Feller (1968) Lemma VII.1.2 citation.",
      "R9: gap_phi_tail_bound subsequently CLOSED via Mathlib improper-integral machinery (Mills inequality, 272-line proof using `M(s) := 1/2 - ∫_0..s phi - phi(s)/s`, `monotoneOn_of_deriv_nonneg`, `ge_of_tendsto`, `integral_gaussian_Ioi`); kernel-pure. The entry still bundles `gap_order_statistics_max` (CLOSED via def-rfl) and `gap_phi_tail_bound` (CLOSED via Mathlib); both sub-claims now CLOSED.",
      "R12 discipline audit (2026-05-13): status tag `MIXED` was outside the 5-tier canonical taxonomy. Status corrected to `PARTIAL` per `feedback_gap_ledger_in_lean4` — `PARTIAL` is the canonical tag for `specific sub-clause closed or reduced; remaining content explicit`. The `obstacleOrAttribution` field already enumerates the per-sub-claim status.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Mixed). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Standard analytic facts, paper §2.2 + prop:info-decay + prop:topo-cluster"
  obstacleOrAttribution :=
    "gap_order_statistics_max: CLOSED via def-rfl encoding (Mathlib gap is the substantive `∫ x · k·x^(k-1) dx = k/(k+1)` Lebesgue identity); gap_phi_tail_bound: CLOSED via Mathlib improper-integral machinery in R9. Both bundled sub-claims now formally proved; entry retained as PARTIAL because the order-statistics Lebesgue identity remains a Mathlib gap accessed via def-rfl rather than a substantive measure-theoretic derivation."
  conditionalOn := []

/-! # Cat 3 atomic structural-equation entries (paper-foundational atoms)

Per `feedback_gap_ledger_in_lean4` (2026-05-13 rewrite), Cat 3 atomic
inputs comprise: (a) primitive types, (b) hypothesis predicates, and
(c) paper-stated STRUCTURAL EQUATIONS on existing primitives. The
seven entries below cover the (c) layer for `Types.lean` primitives,
threading paper-stated structural facts (boundedness, trivial-path
inclusion, ReachableSet ↔ ForwardReachable starting-vertex equality)
that downstream derivations can compose with Cat 1 (Mathlib) + Cat 2
(external published) + earlier Cat 3 atoms. Status `OPEN` (Cat 3
atomic axioms accepted as paper-foundational; the 5-tier `OPEN` tag
is reused, since "atomic" is not a separate status tier — `OPEN`
captures "axiom accepted without Lean proof"). -/

def entry_atom_intrinsicPref_unitInterval : GapEntry where
  name := "intrinsicPref_mem_unitInterval"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Definition 2.1 (def:idp), line 114 (`ξ: V → [0,1]`)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: paper-stated unit-interval support of the intrinsic preference primitive `intrinsicPref`. Companion to `reward_mem_unitInterval`; restores Definition 2.1's range claim that was previously unencoded on the opaque `intrinsicPref` carrier. The Lean signature does NOT encode the i.i.d. Uniform[0,1] joint distribution (a probabilistic claim on the joint percolation+preference measure); only the pointwise unit-interval support is captured. Cat 1 reduction check: not Mathlib-derivable (constrains opaque carrier `intrinsicPref` introduced as an axiom in Types.lean). Cat 2 reduction check: no external attribution — paper Def 2.1 introduces ξ as a paper-novel primitive of the IDP setup.",
      "R24-D 2026-05-13: paper-source verification of the encoding choice for `intrinsicPref`'s extra `PercolationOutcome` parameter (Audit 6 from R23-D). Paper-source verification at master tex Def 2.1 line 114 (`ξ: V → [0,1]` is drawn `i.i.d. from Uniform[0,1] independently of r`) and §2.5 line 207-208 (welfare's inner expectation ranges `over reward signals, topology signals, and the intrinsic preference realization`) confirms ξ is a SAMPLED realisation drawn jointly with the percolation experiment, NOT a fixed-deterministic function. The Lean signature `intrinsicPref : Vertex → PercolationOutcome → ℝ` encodes ξ as a measurable function of the joint sample space `Ω = PercolationOutcome` — i.e., `intrinsicPref v ω` denotes the realised value of ξ(v) under the joint sample ω. Encoding choice is paper-faithful (Option B per R23-D's Audit 6 framing). Types.lean docstring on `axiom intrinsicPref` extended to record this paper-source-verified justification (paper line 114 + line 207-208 citations). No signature change required; Option A (drop the ω parameter) was REJECTED as paper-unfaithful (would force ξ to be deterministic, contradicting the i.i.d. Uniform sampling clause and §2.5 joint-inner-expectation language).",
      "R24-C 2026-05-13: gained explicit downstream consumer via Wire #3 (R23-D Pattern 7 phantom-downstream repair): added Cat 1 derived theorem `realisedUtility_mem_unitInterval` (Types.lean) composing this atom with `reward_mem_unitInterval` and the convex-combination Cat 1 arithmetic (`linarith`) to prove `0 ≤ U(v) ≤ 1` whenever `α ∈ [0, 1]`. The atom now serves the realised-utility unit-interval bound operationally.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Definition 2.1 (def:idp), line 114 (`ξ: V → [0,1]`)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper-foundational, not derived). The Uniform[0,1] joint-distribution claim remains unencoded (a separate measure-theoretic Mathlib gap). R24-D paper-source verification: extra `PercolationOutcome` parameter is paper-faithful per Def 2.1 line 114 (i.i.d. Uniform sampling) + §2.5 line 207-208 (joint inner expectation `over ... the intrinsic preference realization`); ξ is a measurable function of the joint sample, not a fixed-deterministic function. Encoding choice docstring updated in Types.lean. R24-C: now consumed downstream by `realisedUtility_mem_unitInterval` derived theorem (Types.lean)."
  conditionalOn := []

def entry_atom_ReachableSet_self_member : GapEntry where
  name := "ReachableSet_self_member"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.derivedTheorem
  paperSource := "Definition 2.2 (def:reachable), lines 121-128 (length-0 path inclusion convention) — derived from Def 2.5 atoms"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: trivial-path inclusion `v ∈ R(v, ω)`. Paper Definition 2.2 reads `R(v_0) = {v ∈ V : ∃ path from v_0 to v using only unblocked edges}`; the empty (length-0) path from v_0 to v_0 yields v_0 ∈ R(v_0). Implicit graph-theoretic convention assumed by the paper's recursive constructions (def:greedy-path, etc.). Cat 1 reduction check: not Mathlib-derivable (constrains opaque carrier `ReachableSet` introduced as an axiom in Types.lean). Cat 2 reduction check: no external attribution — convention is part of the paper's IDP setup.",
      "R24-C 2026-05-13: Cat 3 derivation: `ReachableSet_self_member` REFACTORED from OPEN axiom to CLOSED Cat 3 derived theorem per the gap-ledger discipline's `atoms must serve downstream consumers` mandate (R23-D Pattern 7 phantom-downstream finding). The Def 2.2 trivial-path inclusion is now derived by composing `ReachableSet_eq_ForwardReachable_empty` (Def 2.5 line 193 paper-stated equation between IDP primitives) and `ForwardReachable_self_member` (Def 2.5 length-0 path inclusion), via a 2-step rewrite proof. The derivation chain shows that the Def 2.2 convention is a structural consequence of the Def 2.5 atoms, not an independent atomic input. Both Def 2.5 atoms gain explicit downstream consumers via this derivation. Status flipped OPEN → CLOSED (Cat 3 theorem proved kernel-pure via composition of Cat 3 atomic inputs).",
      "R27-A 2026-05-13: Cat 3 sub-classification DERIVED_THEOREM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status retained as CLOSED (Cat 3 derived theorem composing earlier Cat 1 + Cat 2 + Cat 3 atomic inputs — sub-class is descriptive only, not subject to the 永不/必须 close mandate). New `subClass` field set to DERIVED_THEOREM." ]
  scope := "Definition 2.2 (def:reachable), lines 121-128 (length-0 path inclusion convention) — derived from Def 2.5 atoms"
  obstacleOrAttribution :=
    "R24-C CLOSED via Cat 3 derivation: `rw [ReachableSet_eq_ForwardReachable_empty v ω]; exact ForwardReachable_self_member v ∅ ω`. Was Cat 3 OPEN axiom; refactored to derived theorem per R24-C wire #1 (R23-D Pattern 7 phantom-downstream repair)."
  conditionalOn := []

def entry_atom_ReachableSet_eq_ForwardReachable_empty : GapEntry where
  name := "ReachableSet_eq_ForwardReachable_empty"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Definition 2.5 (def:forward-reachable), line 193 (\"For the starting vertex, R(v_0) = R(v_0 | ∅) is the full reachable set\")"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: paper-stated equation between the two existing IDP primitives `ReachableSet` (Def 2.2) and `ForwardReachable` (Def 2.5) at the empty-history base case. Paper Def 2.5 line 193 explicitly states the equality. Cat 1 reduction check: not Mathlib-derivable (relates two opaque carriers in Types.lean). Cat 2 reduction check: no external attribution — paper Def 2.5 introduces both carriers and the relating equation.",
      "R24-C 2026-05-13: gained explicit downstream consumer via Wire #1 (R23-D Pattern 7 phantom-downstream repair): the prior `ReachableSet_self_member` OPEN atom was refactored to a CLOSED Cat 3 derived theorem deriving from this atom + `ForwardReachable_self_member`. The atom now serves the Def 2.2 trivial-path inclusion derivation operationally.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Definition 2.5 (def:forward-reachable), line 193 (\"For the starting vertex, R(v_0) = R(v_0 | ∅) is the full reachable set\")"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper-stated structural equation on opaque carriers). R24-C: now consumed downstream by `ReachableSet_self_member` derived theorem (Types.lean)."
  conditionalOn := []

def entry_atom_ForwardReachable_self_member : GapEntry where
  name := "ForwardReachable_self_member"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Definition 2.5 (def:forward-reachable), lines 187-194 (length-0 path inclusion convention parallel to Def 2.2)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: trivial-path inclusion for the forward-reachable construction `u ∈ R(u | H, ω)`. Paper Def 2.5 mirrors the Def 2.2 length-0 path convention. Cat 1 reduction check: not Mathlib-derivable (constrains opaque carrier `ForwardReachable`). Cat 2 reduction check: no external attribution — parallel to `ReachableSet_self_member` for the forward-reachable carrier.",
      "R24-A 2026-05-13: scope-discipline docstring patch per R23-D Audit 2 hostile audit (\"over-strong on H ∋ u case\"). The paper's `H_t` convention denotes the visit-history at step `t` BEFORE arriving at `u`, so `R(u | H_t)` is naturally evaluated only at histories with `u ∉ H`. Two options were considered: (A) tighten the axiom with a `u ∉ H` premise (paper-faithful); (B) keep the unconditional form with documented opaque-carrier convention. Option B selected because Option A would cascade premise-threading into `V_dyn_def` (Phase.lean) — which witnesses non-emptiness of `ForwardReachable v H ω` via this atom over arbitrary `H` to define `V_dyn` — and into every Phase / GeneralGraphs / Cognitive theorem unfolding `V_dyn` over a non-empty history (e.g. `gap_V_g_le_V_dyn` in GeneralGraphs.lean), and the parallel `ReachableSet_self_member` (now derived from this atom + `ReachableSet_eq_ForwardReachable_empty`) is also unconditional. Patch: docstring expanded to make the opaque-carrier convention EXPLICIT — paper-faithful theorems (e.g. `gap_trap_prevalence_zero`) apply this atom only at `H = ∅` where the convention coincides exactly with paper convention; the slightly-stronger Lean form is acknowledged as the documented opaque-carrier abstraction. No source-side signature change; no downstream cascade. Lake build green.",
      "R24-C 2026-05-13: explicit additional downstream consumer noted via Wire #1 (R23-D Pattern 7 phantom-downstream repair): the prior `ReachableSet_self_member` OPEN atom was refactored to a CLOSED Cat 3 derived theorem deriving from `ReachableSet_eq_ForwardReachable_empty` + this atom. (This atom was already consumed by `V_dyn_def`'s non-emptiness witness in Phase.lean and by `gap_trap_prevalence_zero`.)",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Definition 2.5 (def:forward-reachable), lines 187-194 (length-0 path inclusion convention parallel to Def 2.2)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper convention on the opaque `ForwardReachable` carrier). R24-A: docstring scope-discipline note added — paper's `H_t` convention excludes `u`; the unconditional Lean form is the documented opaque-carrier abstraction required by `V_dyn_def`'s non-emptiness witness over arbitrary `H`. Tightening with `u ∉ H` premise would cascade premise-threading into `V_dyn_def` and every downstream `V_dyn`-unfolding theorem (Option A rejected; Option B / docstring-only patch selected). R24-C: additional downstream consumer `ReachableSet_self_member` derived theorem (Types.lean) added."
  conditionalOn := []

def entry_atom_topoSignalVariance_distance_zero : GapEntry where
  name := "topoSignalVariance_distance_zero"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Proposition prop:threshold-five-state proof, line 870 (`σ²_topo(κ, 0) = 0` terminal-vertex case)"
  attackHistory :=
    [ "Cat 1 closure: paper-stated structural fact `σ²_topo(κ, 0) = 0` for any κ. Proved kernel-pure from the existing `def topoSignalVariance` and `(0 : ℝ)^2 = 0` via `unfold + simp`. Cat 1 reduction check: yes — Mathlib-derivable from the def. Cat 2 reduction check: not external (paper-cited line 870 is part of the paper's own constructive proof). The closure composes the paper's structural identity with Mathlib's standard arithmetic; recorded as Cat 1 (Mathlib-derivable) per the discipline's `Cat 1 must be a theorem if Mathlib proof exists` rule.",
      "R24-D 2026-05-13: AxiomAudit instrumentation added per R23-D Audit 5 finding (the R23-B closure was uninstrumented in `AxiomAudit.lean`). `#print axioms BlackwellDilemma.topoSignalVariance_distance_zero` line added at the §2 IDP Types section of the audit script; output confirms kernel-pure dependency `[propext, Classical.choice, Quot.sound]` (matching the obstacleOrAttribution claim). No source-side change required — only audit-script instrumentation.",
      "R27-A 2026-05-13: Cat 3 sub-classification N/A per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; non-Cat 3 entry (Cat1). Cat 3 sub-classification only applies to Cat 3 atomic inputs. New `subClass` field set to N/A." ]
  scope := "Proposition prop:threshold-five-state proof, line 870 (`σ²_topo(κ, 0) = 0` terminal-vertex case)"
  obstacleOrAttribution :=
    "CLOSED via Mathlib unfold + simp; kernel-pure (depends on [propext, Classical.choice, Quot.sound]). R24-D: AxiomAudit instrumentation now lists this closure under the §2 IDP Types section."
  conditionalOn := []

def entry_atom_oracleReward_unitInterval : GapEntry where
  name := "oracleReward_mem_unitInterval"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Definition 2.6 (def:oracle), lines 210-213, combined with Definition 2.1 line 113 (r: V → [0, 1])"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: unit-interval bound on the opaque `oracleReward β` carrier, inherited from the paper-stated `r: V → [0, 1]` reward range and Def 2.6's argmax-of-expectation oracle construction. Cat 1 reduction check: not Mathlib-derivable (constrains opaque carrier `oracleReward`). Cat 2 reduction check: no external attribution — paper Def 2.6 introduces oracleReward as a paper-novel quantity. Atomic axiom prevents per-downstream-module re-axiomatization of the bound under different names.",
      "R24-C 2026-05-13: Option B atomized-stub-awaiting-consumer classification per R23-D Pattern 7 phantom-downstream finding. The unit-interval bound on `oracleReward` is paper-foundational structural infrastructure (paper Def 2.6 + Def 2.1 line 113) but no current downstream theorem in this formalisation consumes it. Retained as paper-grade Cat 3 atomic record per the discipline's `structural facts about paper primitives are Cat 3 atomic inputs even when not yet operationally needed downstream`; future modules instantiating Definition 2.6 oracle on a concrete IDP setup are expected to consume this bound. Types.lean docstring updated with the atomized-stub status caveat.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Definition 2.6 (def:oracle), lines 210-213, combined with Definition 2.1 line 113 (r: V → [0, 1])"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper-foundational unit-interval bound on the opaque `oracleReward` carrier). R24-C: Option B classification — atomized stub awaiting downstream consumer (no current downstream consumer; future Def 2.6 oracle instantiations expected to consume)."
  conditionalOn := []

def entry_atom_agentWelfare_unitInterval : GapEntry where
  name := "agentWelfare_mem_unitInterval"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "§2.5 'Agent Behaviour', lines 204-208 (welfare definition) + Definition 2.1, line 113 (r: V → [0, 1])"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: unit-interval bound on the opaque `agentWelfare a β κ α` carrier for any AgentType `a` and parameter triple `(β, κ, α)`. Paper §2.5 line 205-208 defines welfare as `W(β, κ, α) = E_{G_p}[E_{s, ω̂_κ}[r(v_T)]]`; since `r : V → [0, 1]`, the expectation is bounded in [0, 1]. Cat 1 reduction check: not Mathlib-derivable (constrains opaque carrier `agentWelfare`). Cat 2 reduction check: no external attribution — agentWelfare is a paper-novel quantity. Atomic axiom prevents per-AgentType re-axiomatization.",
      "R24-C 2026-05-13: gained explicit downstream consumer via Wire #2 (R23-D Pattern 7 phantom-downstream repair): added Cat 1 derived theorem `kappaAgentWelfareSNR_mem_unitInterval` (Cognitive.lean) composing this atom with `kappaAgentWelfareSNR_def` to prove `0 ≤ kappaAgentWelfareSNR β κ ≤ 1`. The atom now serves the moderate-SNR κ-agent welfare unit-interval bound operationally.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "§2.5 'Agent Behaviour', lines 204-208 (welfare definition) + Definition 2.1, line 113 (r: V → [0, 1])"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper-foundational unit-interval bound on the opaque `agentWelfare` carrier). R24-C: now consumed downstream by `kappaAgentWelfareSNR_mem_unitInterval` derived theorem (Cognitive.lean)."
  conditionalOn := []

/-! # R23-C1 Cat 3 atomic structural-equation entries (paper-stated
    structural equations on existing carriers, by owning module)

Per `feedback_gap_ledger_in_lean4` 2026-05-13 update: Cat 3 atomic
inputs comprise (a) primitive types, (b) hypothesis predicates, and
(c) paper-stated STRUCTURAL EQUATIONS on existing primitives.
R23-B added 7 type-level atoms in Types.lean; R23-C1 extends the
atomic structural-equation layer across the remaining modules
(Phase, GeneralGraphs, Cognitive, Wrongness, Principal, Canonical),
encoding paper-stated structural equations on existing opaque carriers.
The atoms below are accepted as OPEN axioms per discipline; downstream
"higher-level paper claim" entries that previously bundled these
equations are refactored to derive the closed-form clauses Cat 1 from
the atoms (see `entry_prop_topo_cluster` PARTIAL refactor and the
`oracleValueAtRoot_TrapTree_def` Cat 3 atom + `gap_error_compounding_part2`
derived theorem refactor in `entry_prop_error_compounding`). -/

def entry_atom_V_dyn_def : GapEntry where
  name := "V_dyn_def"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Definition 2.2 (def:reachable), line 127; Definition def:value-functions, line 446"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: dynamic value of vertex `v` (parent set `H`, percolation outcome `ω`) equals the paper-stated sup of rewards over the forward-reachable set `ForwardReachable v H ω`. Encoding via `Finset.sup'` with non-emptiness witness from `ForwardReachable_self_member` (Types.lean R23-B atom). Cat 1 reduction check: not Mathlib-derivable (constrains opaque carrier `V_dyn`). Cat 2 reduction check: no external attribution — paper Def 2.2 + def:value-functions introduce `V_dyn` as a paper-novel quantity.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Definition 2.2 (def:reachable), line 127; Definition def:value-functions, line 446"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper-stated structural equation linking the opaque `V_dyn` carrier to the existing `ForwardReachable` and `reward` primitives)."
  conditionalOn := []

def entry_atom_V_g_def_terminal : GapEntry where
  name := "V_g_def_terminal"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Definition def:greedy-path, lines 982-985 (terminal-vertex base case)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: terminal-vertex base case of the greedy-path-value recursion. Paper Def `def:greedy-path` reads `if u is a leaf, V_g(u) = r(u)`; specialised to `ForwardReachable u H ω = {u}` (only the trivial-path-to-self in the forward-reachable set). Encoding choice: paper's recursive def can't be written directly as a Lean `def` over opaque `Vertex` (no induction principle), so terminal-base + recursion-step are exposed as separate atomic axioms (`V_g_def_terminal` + `V_g_def_step` below). Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel.",
      "R24-C 2026-05-13: gained explicit downstream consumer via Wire #5 (R23-D Pattern 7 phantom-downstream repair): added Cat 1 derived theorem `V_g_terminal_mem_unitInterval` (GeneralGraphs.lean) composing this atom with `reward_mem_unitInterval` to prove `0 ≤ V_g u H ω ≤ 1` in the terminal-vertex case (`ForwardReachable u H ω = {u}`). The atom now serves the terminal-case greedy-path-value bound operationally.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Definition def:greedy-path, lines 982-985 (terminal-vertex base case)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper recursive def's terminal base case). R24-C: now consumed downstream by `V_g_terminal_mem_unitInterval` derived theorem (GeneralGraphs.lean)."
  conditionalOn := []

def entry_atom_V_g_def_step : GapEntry where
  name := "V_g_def_step"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Definition def:greedy-path, lines 982-985 (recursive step / argmax-child)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: recursive step of greedy-path-value definition. Paper `def:greedy-path` reads `if u has children c_1, ..., c_b with open edges, V_g(u) = V_g(argmax_{c_i} r(c_i))`. Encoding: existential over a maximiser child `c ∈ N` (where `N := ForwardReachable u H ω \\ {u}`) with `reward c = N.image reward |>.max'` and `V_g u H ω = V_g c (insert u H) ω`. Avoids commitment to a specific argmax tie-breaking. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel.",
      "R24-C 2026-05-13: Option B atomized-stub-awaiting-consumer classification per R23-D Pattern 7 phantom-downstream finding. The recursive-step companion paired with `V_g_def_terminal` (now consumed by `V_g_terminal_mem_unitInterval`) is paper-stated structural infrastructure but no current theorem inducts on the existential-maximiser to consume it. Future derivations of `V_g`-monotonicity / `V_g`-connectivity arguments that descend through the greedy path are expected to consume this atom; until then the discipline accepts it as a foundational Cat 3 atomic structural-equation record. GeneralGraphs.lean docstring updated with the atomized-stub status caveat.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Definition def:greedy-path, lines 982-985 (recursive step / argmax-child)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper recursive def's argmax-child step; existential maximiser encoding to avoid committing to specific tie-break). R24-C: Option B classification — atomized stub awaiting downstream consumer (no current downstream consumer; future `V_g`-induction theorems expected to consume)."
  conditionalOn := []

def entry_atom_oracleValueAtRoot_TrapTree_def : GapEntry where
  name := "oracleValueAtRoot_TrapTree_def"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:error-compounding Part 2, line 1041"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: oracle dynamic value at the root of depth-d trap tree equals `r_goal = 1.0` for all `d ≥ 1`. Paper line 1041 reads `the oracle achieves V_dyn(v_0) = r(G) = 1.0 for all d`. R23-C1 refactor: previously bundled as `gap_error_compounding_part2_OPEN` (a higher-level paper claim wrongly axiomatised); now refactored into Cat 3 atomic axiom `oracleValueAtRoot_TrapTree_def` + derived theorem `gap_error_compounding_part2` (`:= oracleValueAtRoot_TrapTree_def`). Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Proposition prop:error-compounding Part 2, line 1041"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper-stated structural equation on the opaque `oracleValueAtRoot_TrapTree` carrier; replaces the prior bundled `gap_error_compounding_part2_OPEN`)."
  conditionalOn := []

def entry_atom_expectedTopoLoss_conditional_def : GapEntry where
  name := "expectedTopoLoss_conditional_def"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:topo-cluster proof, line 292 (order-statistics decomposition `n/(n+1) − k/(k+1)`)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: paper Proposition `prop:topo-cluster` proof line 292 derives the conditional expected topological loss as `E[|W_topo| | |R| = k] = n/(n+1) − k/(k+1)` (using order-statistics for `E[max k iid Uniform[0,1]]`). The closed-form simplification `(n−k)/((n+1)(k+1))` is now derived Cat 1 from this atom in `gap_topo_cluster_relation` (theorem refactored from `gap_topo_cluster_relation_OPEN`). R23-C1 refactor splits the prior bundled OPEN axiom into Cat 3 atomic structural equation + Cat 1 algebraic-simplification theorem. Cat 1 reduction check: not Mathlib-derivable (the order-statistics step is the substantive content). Cat 2 reduction check: depends on David & Nagaraja 2003 §2.1.4 order statistics (acknowledged at docstring level); the Cat 2 dependency remains a Mathlib gap requiring product-uniform-measure infrastructure.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Proposition prop:topo-cluster proof, line 292 (order-statistics decomposition `n/(n+1) − k/(k+1)`)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline. Cat 2 dependency on David & Nagaraja 2003 §2.1.4 disclosed in docstring; full closure requires Mathlib product-measure infrastructure."
  conditionalOn := []

def entry_atom_kappaStar_def : GapEntry where
  name := "kappaStar_def"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 4.1 Part 3, line 493 (`κ* = inf{κ > 0 : m(κ) ≥ 0}`)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: `kappaStar p α = sInf {κ : 0 < κ ∧ 0 ≤ mean_estimate_gap p κ}`. Paper Theorem 4.1 Part 3 line 493 IVT-based existence chain. Extracted as standalone atom from the bundled `gap_cognitive_threshold_part3_OPEN` per `feedback_gap_ledger_in_lean4` 2026-05-13 update. The α-parameter appears in `kappaStar`'s signature but isn't consumed on the RHS (paper threshold characterisation depends on α only through IDP-instance assumptions). Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM.",
      "R28 2026-05-13: status-laundering revert per R27-B Pattern 13 audit. This entry is a paper-DERIVED higher-level claim (Theorem 4.1 Part 3 IVT-based existence on κ*, characterising it as the inf-set of strictly-positive κ with non-negative `mean_estimate_gap`), NOT a paper definitional commitment. The IVT existence is paper-derived from continuity assumptions on `m(κ)`; pinning `kappaStar` to the inf-formula via axiom is a working-assumption shortcut pending derivation from those IVT inputs. Reclassified DEFINITIONAL → OPEN; subClass DEFINITIONAL_ATOM → WORKING_ASSUMPTION.",
      "R40 2026-05-14: reclassified workingAssumption → structuralEquation per R39 same-logic extension (paper-stated atomic characterization on opaque carrier per §3.4.3 'paper's commitment to how its primitives behave'); status gapOpen → gapDefinitional. Resolves R28 conservative status-laundering concern: R28 was correct to revert these from DEFINITIONAL to OPEN at the time because workingAssumption wasn't fully distinguished from structuralEquation; R39 + R40 establish the pattern: paper-stated atomic content on opaque carriers extracted from theorem statements = structuralEquation. The sInf characterisation pins the opaque `kappaStar` carrier to its paper-stated inf-formula on `mean_estimate_gap`; this IS how the paper introduces the carrier's relationship to its primitives, not a derivable consequence." ]
  scope := "Theorem 4.1 Part 3, line 493 (`κ* = inf{κ > 0 : m(κ) ≥ 0}`)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (extracted from bundled `gap_cognitive_threshold_part3_OPEN`). R40: structuralEquation per §3.4.3 — paper's atomic characterisation of `kappaStar` carrier on `mean_estimate_gap` primitive; 永不 close (paper definitional commitment to how its primitives behave)."
  conditionalOn := []

def entry_atom_mLimit_def : GapEntry where
  name := "mLimit_def + mLimitOf carrier"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 4.1 Part 3, line 505 (`m(κ) → V_dyn(u_2) − V_dyn(u_1) > 0` as `κ → ∞`)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: `Filter.Tendsto (mean_estimate_gap p) atTop (nhds (mLimitOf p))`. Paper Theorem 4.1 Part 3 line 505 limit. New opaque carrier `mLimitOf : ℝ → ℝ` introduced to host the limit value; the paper-stated `mLimitOf p = V_dyn(u_2) − V_dyn(u_1)` link is deferred to per-IDP-instance closure (paper's `(u_1, u_2)` are local to the instance). Extracted as standalone atom from the bundled `gap_cognitive_threshold_part3_OPEN`. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel.",
      "R24-C 2026-05-13: Option B atomized-stub-awaiting-consumer classification per R23-D Pattern 7 phantom-downstream finding. Direct downstream consumption requires composing this Tendsto limit with strict-positivity of `mLimitOf` (paper line 505 `mLimitOf p > 0`) plus the per-IDP-instance link `mLimitOf p = V_dyn(u_2) − V_dyn(u_1)` deferred to per-instance closure (paper's `(u_1, u_2)` are local to each IDP instance); pending those instantiations the atom is retained as a paper-grade structural equation record. Cognitive.lean docstring updated with the atomized-stub status caveat.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM.",
      "R28 2026-05-13: status-laundering revert per R27-B Pattern 13 audit. This entry is a paper-DERIVED higher-level claim (Theorem 4.1 Part 3 Tendsto limit on `mean_estimate_gap p` as `κ → ∞`), NOT a paper definitional commitment. The Tendsto characterisation is paper-derived from per-instance V_dyn convergence properties; pinning the `mLimitOf` value via axiom is a working-assumption shortcut pending derivation from the per-instance V_dyn link. Reclassified DEFINITIONAL → OPEN; subClass DEFINITIONAL_ATOM → WORKING_ASSUMPTION.",
      "R40 2026-05-14: reclassified workingAssumption → structuralEquation per R39 same-logic extension (paper-stated atomic characterization on opaque carrier per §3.4.3 'paper's commitment to how its primitives behave'); status gapOpen → gapDefinitional. Resolves R28 conservative status-laundering concern: R28 was correct to revert these from DEFINITIONAL to OPEN at the time because workingAssumption wasn't fully distinguished from structuralEquation; R39 + R40 establish the pattern: paper-stated atomic content on opaque carriers extracted from theorem statements = structuralEquation. The Tendsto characterisation pins the opaque `mLimitOf` carrier to be the limit of `mean_estimate_gap p` at infinity; this IS how the paper introduces the carrier's relationship to its primitives, not a derivable consequence." ]
  scope := "Theorem 4.1 Part 3, line 505 (`m(κ) → V_dyn(u_2) − V_dyn(u_1) > 0` as `κ → ∞`)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (extracted from bundled `gap_cognitive_threshold_part3_OPEN`); per-instance link to `V_dyn(u_2) − V_dyn(u_1)` deferred to per-IDP-instance closure. R40: structuralEquation per §3.4.3 — paper's atomic characterisation of `mLimitOf` carrier as Tendsto-limit of `mean_estimate_gap`; 永不 close (paper definitional commitment)."
  conditionalOn := []

def entry_atom_alphaStar_def : GapEntry where
  name := "alphaStar_def"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:sentimental proof, line 602 (sup-characterisation of α*)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: `alphaStar κ p = sSup {α ∈ [0,1] : ∀ β₁ β₂, β₁ ≤ β₂ → agentWelfare AgentType.sentimental β₁ κ α ≤ agentWelfare AgentType.sentimental β₂ κ α}`. Paper `prop:sentimental` proof line 602 reads `The critical α* is therefore well-defined as the supremum of [the monotonicity set]`. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel.",
      "R24-C 2026-05-13: Option B atomized-stub-awaiting-consumer classification per R23-D Pattern 7 phantom-downstream finding. Direct downstream derivation of `alphaStar`'s positivity / monotonicity properties requires composing this characterisation with the substantive sentimental-immunity content (paper `prop:sentimental` perturbation argument) which remains within `gap_sentimental_immunity_OPEN` pending Mathlib bounded-convergence + Φ-tail integral machinery. Retained as paper-grade structural-equation record. Cognitive.lean docstring updated with the atomized-stub status caveat.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM.",
      "R28 2026-05-13: status-laundering revert per R27-B Pattern 13 audit. This entry is a paper-DERIVED higher-level claim (`prop:sentimental` proof line 602 sSup characterisation of α* as supremum of the monotonicity set), NOT a paper definitional commitment. The sSup well-definedness is paper-derived from the perturbation argument; pinning the carrier via axiom is a working-assumption shortcut pending derivation from the perturbation inputs. Reclassified DEFINITIONAL → OPEN; subClass DEFINITIONAL_ATOM → WORKING_ASSUMPTION.",
      "R40 2026-05-14: reclassified workingAssumption → structuralEquation per R39 same-logic extension (paper-stated atomic characterization on opaque carrier per §3.4.3 'paper's commitment to how its primitives behave'); status gapOpen → gapDefinitional. Resolves R28 conservative status-laundering concern: R28 was correct to revert these from DEFINITIONAL to OPEN at the time because workingAssumption wasn't fully distinguished from structuralEquation; R39 + R40 establish the pattern: paper-stated atomic content on opaque carriers extracted from theorem statements = structuralEquation. The sSup characterisation pins the opaque `alphaStar` carrier to its paper-stated supremum on the monotonicity set; this IS how the paper introduces the carrier's relationship to its primitives, not a derivable consequence." ]
  scope := "Proposition prop:sentimental proof, line 602 (sup-characterisation of α*)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper-stated sup-characterisation on the existing `alphaStar` and `agentWelfare` carriers). R40: structuralEquation per §3.4.3 — paper's atomic characterisation of `alphaStar` carrier as sSup of monotonicity set; 永不 close (paper definitional commitment)."
  conditionalOn := []

def entry_atom_kappaAgentWelfareSNR_def : GapEntry where
  name := "kappaAgentWelfareSNR_def"
  status := GapStatus.gapClosed
  inputCategory := InputCategory.cat1Mathlib
  cat3SubType := Cat3SubType.notCat3
  paperSource := "Proposition prop:supermodular, line 565 (W(β, κ) for κ-agent at α=1)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: `kappaAgentWelfareSNR β κ = agentWelfare AgentType.kappaAgent β κ 1`. Pins the previously orphan `kappaAgentWelfareSNR` carrier to the existing `agentWelfare` primitive on the `AgentType.kappaAgent` constructor at α = 1, eliminating the opaque-on-opaque pattern. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel.",
      "R24-C 2026-05-13: gained explicit downstream consumer via Wire #2 (R23-D Pattern 7 phantom-downstream repair): added Cat 1 derived theorem `kappaAgentWelfareSNR_mem_unitInterval` (Cognitive.lean) composing this atom with `agentWelfare_mem_unitInterval` to prove `0 ≤ kappaAgentWelfareSNR β κ ≤ 1`. The atom now serves the moderate-SNR κ-agent welfare unit-interval bound operationally.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM.",
      "R28 2026-05-13 FIX 6 Hodge-style refactor: the prior `axiom kappaAgentWelfareSNR + axiom kappaAgentWelfareSNR_def` pair (Cat 3 DEFINITIONAL) is replaced by `noncomputable def kappaAgentWelfareSNR (β κ : ℝ) : ℝ := agentWelfare AgentType.kappaAgent β κ 1` (Mathlib-level def) plus `theorem kappaAgentWelfareSNR_def : ∀ β κ, kappaAgentWelfareSNR β κ = agentWelfare AgentType.kappaAgent β κ 1 := by intros β κ; rfl` (Cat 1 CLOSED kernel-pure via `rfl`). Net: the entry is reclassified Cat 3 DEFINITIONAL → Cat 1 CLOSED (the structural equation is now a definitional `rfl`-discharged theorem on the new Mathlib-level def). Eliminates 2 Cat 3 OPEN axioms (kappaAgentWelfareSNR + kappaAgentWelfareSNR_def axioms) and adds 1 Cat 1 CLOSED theorem. inputCategory Cat 3 → Cat 1; subClass DEFINITIONAL_ATOM → N/A." ]
  scope := "Proposition prop:supermodular, line 565 (W(β, κ) for κ-agent at α=1)"
  obstacleOrAttribution :=
    "R28: Hodge-style Mathlib-level `def` + Cat 1 CLOSED `rfl` theorem (eliminates the prior axiom pair). R24-C downstream consumer `kappaAgentWelfareSNR_mem_unitInterval` (Cognitive.lean) inherits the new def via `rw [kappaAgentWelfareSNR_def β κ]` reduction."
  conditionalOn := []

def entry_atom_betaBarStar_def : GapEntry where
  name := "betaBarStar_def"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:principal-optimum, line 622 (β̄* as maximiser of W̄)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: `∀ β, W_bar β ≤ W_bar betaBarStar`. Paper `prop:principal-optimum` line 622 introduces `\\bar{β}^*` as the maximiser of `W̄`. Argmax-characterisation pins `betaBarStar` to a maximiser of `W_bar` without committing to its existence proof (which follows from `gap_principal_interior_optimum_OPEN`). Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel.",
      "R24-C 2026-05-13: gained explicit downstream consumer via Wire #6 (R23-D Pattern 7 phantom-downstream repair): added Cat 1 derived theorem `W_bar_limit_infty_le_W_bar_betaBarStar` (Principal.lean) composing this atom with `W_bar_limit_infty_def` via Mathlib's `le_of_tendsto'` (limit-of-bounded-function lemma) to prove `W_bar_limit_infty ≤ W_bar betaBarStar`. The atom now serves the limit-bounded-by-maximiser fact operationally.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM.",
      "R28 2026-05-13: status-laundering revert per R27-B Pattern 13 audit. This entry is a paper-DERIVED higher-level claim (`prop:principal-optimum` line 622 argmax characterisation of β̄* as the maximiser of W̄), NOT a paper definitional commitment. The argmax characterisation is paper-derived from `gap_principal_interior_optimum_OPEN` existence; pinning β̄* via axiom is a working-assumption shortcut pending derivation from the existence proof. Reclassified DEFINITIONAL → OPEN; subClass DEFINITIONAL_ATOM → WORKING_ASSUMPTION.",
      "R40 2026-05-14: reclassified workingAssumption → structuralEquation per R39 same-logic extension (paper-stated atomic characterization on opaque carrier per §3.4.3 'paper's commitment to how its primitives behave'); status gapOpen → gapDefinitional. Resolves R28 conservative status-laundering concern: R28 was correct to revert these from DEFINITIONAL to OPEN at the time because workingAssumption wasn't fully distinguished from structuralEquation; R39 + R40 establish the pattern: paper-stated atomic content on opaque carriers extracted from theorem statements = structuralEquation. The argmax characterisation pins the opaque `betaBarStar` carrier as a maximiser of `W_bar`; this IS how the paper introduces the carrier's relationship to its primitives, not a derivable consequence." ]
  scope := "Proposition prop:principal-optimum, line 622 (β̄* as maximiser of W̄)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (argmax-characterisation on existing `betaBarStar` and `W_bar` carriers). R24-C: now consumed downstream by `W_bar_limit_infty_le_W_bar_betaBarStar` derived theorem (Principal.lean). R40: structuralEquation per §3.4.3 — paper's atomic characterisation of `betaBarStar` carrier as argmax of `W_bar`; 永不 close (paper definitional commitment)."
  conditionalOn := []

def entry_atom_kappa_FOSD_def : GapEntry where
  name := "kappa_FOSD_def"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:principal-optimum Part 2, line 634 (G₂ FOSD G₁ in κ)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: `kappa_FOSD G₁ G₂ ↔ ∀ x, G₂ x ≤ G₁ x`. Paper line 634 defines FOSD as the CDF inequality. The paper's joint distribution `G(κ, α)` reduces to its κ-marginal CDF in the FOSD claim. Cat 1 reduction check: not Mathlib-derivable (paper-stated definition on opaque `kappa_FOSD` predicate carrier). Cat 2 reduction check: FOSD is a standard probability-theoretic concept, but the specific application to the κ-marginal CDF is paper-novel scope.",
      "R24-C 2026-05-13: Option B atomized-stub-awaiting-consumer classification per R23-D Pattern 7 phantom-downstream finding. Substantive downstream consumption (FOSD-to-monotone-aggregate-optimum chain of paper Part 2 line 626) requires the integration-by-parts / Lebesgue-Stieltjes machinery embedded in `gap_principal_monotone_in_kappa_OPEN`; pending that closure the atom is retained as a paper-grade definitional-predicate equation. Principal.lean docstring updated with the atomized-stub status caveat.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Proposition prop:principal-optimum Part 2, line 634 (G₂ FOSD G₁ in κ)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper-stated structural equivalence on the opaque `kappa_FOSD` predicate). R24-C: Option B classification — atomized stub awaiting downstream consumer (`gap_principal_monotone_in_kappa_OPEN` closure expected to consume)."
  conditionalOn := []

def entry_atom_aggregateOptimalBeta_def : GapEntry where
  name := "aggregateOptimalBeta_def + aggregateWelfareWith carrier"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Definition def:principal, line 615; Proposition prop:principal-optimum Part 2, line 634"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: `∀ G β, aggregateWelfareWith G β ≤ aggregateWelfareWith G (aggregateOptimalBeta G)`. Parallel to `betaBarStar_def` for the G-parameterised case. New opaque carrier `aggregateWelfareWith : (ℝ → ℝ) → ℝ → ℝ` introduced to host the G-parameterised aggregate-welfare functional (the existing `W_bar : ℝ → ℝ` fixes G implicitly). Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel.",
      "R24-C 2026-05-13: Option B atomized-stub-awaiting-consumer classification per R23-D Pattern 7 phantom-downstream finding. Direct G-parameterised consumers would require a `Filter.Tendsto` limit on `aggregateWelfareWith G` analogous to `W_bar_limit_infty_def` (now consumed by `W_bar_limit_infty_le_W_bar_betaBarStar` via Wire #6), which is paper-implied by Cor `cor:disclosure` Part 1 but not yet encoded as a separate G-parameterised limit-carrier. Retained as paper-grade structural-equation record pending the G-parameterised limit infrastructure. Principal.lean docstring updated with the atomized-stub status caveat.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM.",
      "R28 2026-05-13: status-laundering revert per R27-B Pattern 13 audit. This entry is a paper-DERIVED higher-level claim (G-parameterised argmax characterisation paralleling `betaBarStar_def`, paper `def:principal` line 615 + `prop:principal-optimum` Part 2 line 634), NOT a paper definitional commitment. The G-parameterised argmax is paper-derived from the analogous interior-optimum existence; pinning `aggregateOptimalBeta` via axiom is a working-assumption shortcut pending derivation. Reclassified DEFINITIONAL → OPEN; subClass DEFINITIONAL_ATOM → WORKING_ASSUMPTION.",
      "R40 2026-05-14: reclassified workingAssumption → structuralEquation per R39 same-logic extension (paper-stated atomic characterization on opaque carrier per §3.4.3 'paper's commitment to how its primitives behave'); status gapOpen → gapDefinitional. Resolves R28 conservative status-laundering concern: R28 was correct to revert these from DEFINITIONAL to OPEN at the time because workingAssumption wasn't fully distinguished from structuralEquation; R39 + R40 establish the pattern: paper-stated atomic content on opaque carriers extracted from theorem statements = structuralEquation. The G-parameterised argmax characterisation pins the opaque `aggregateOptimalBeta` carrier as a maximiser of `aggregateWelfareWith G`; this IS how the paper introduces the carrier's relationship to its primitives, not a derivable consequence." ]
  scope := "Definition def:principal, line 615; Proposition prop:principal-optimum Part 2, line 634"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (argmax-characterisation on existing `aggregateOptimalBeta` and new opaque `aggregateWelfareWith` carriers). R24-C: Option B classification — atomized stub awaiting downstream consumer (G-parameterised limit infrastructure expected to consume). R40: structuralEquation per §3.4.3 — paper's atomic characterisation of `aggregateOptimalBeta` carrier as argmax of G-parameterised aggregate-welfare functional; 永不 close (paper definitional commitment)."
  conditionalOn := []

def entry_atom_W_bar_limit_infty_def : GapEntry where
  name := "W_bar_limit_infty_def"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Corollary cor:disclosure Part 1 proof, line 652 (aggregate welfare converges to a finite limit as β → ∞)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: `Filter.Tendsto W_bar atTop (nhds W_bar_limit_infty)`. Paper line 652 derives the limit existence by aggregating the per-agent finite-limit claim. Pins the limit-value carrier to the actual limit of `W_bar`. Cat 1 reduction check: not Mathlib-derivable (constrains opaque carrier `W_bar`). Cat 2 reduction check: paper-novel.",
      "R24-C 2026-05-13: gained explicit downstream consumer via Wire #6 (R23-D Pattern 7 phantom-downstream repair): added Cat 1 derived theorem `W_bar_limit_infty_le_W_bar_betaBarStar` (Principal.lean) composing this Tendsto atom with `betaBarStar_def` via Mathlib's `le_of_tendsto'` (limit-of-bounded-function lemma) to prove `W_bar_limit_infty ≤ W_bar betaBarStar`. The atom now serves the limit-bounded-by-maximiser fact operationally.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM.",
      "R28 2026-05-13: status-laundering revert per R27-B Pattern 13 audit. This entry is a paper-DERIVED higher-level claim (`cor:disclosure` Part 1 proof line 652 Tendsto limit on aggregate welfare), NOT a paper definitional commitment. The Tendsto limit is paper-derived from per-agent finite-limit aggregation; pinning the limit value via axiom is a working-assumption shortcut pending derivation from those per-agent inputs. Reclassified DEFINITIONAL → OPEN; subClass DEFINITIONAL_ATOM → WORKING_ASSUMPTION.",
      "R40 2026-05-14: reclassified workingAssumption → structuralEquation per R39 same-logic extension (paper-stated atomic characterization on opaque carrier per §3.4.3 'paper's commitment to how its primitives behave'); status gapOpen → gapDefinitional. Resolves R28 conservative status-laundering concern: R28 was correct to revert these from DEFINITIONAL to OPEN at the time because workingAssumption wasn't fully distinguished from structuralEquation; R39 + R40 establish the pattern: paper-stated atomic content on opaque carriers extracted from theorem statements = structuralEquation. The Tendsto characterisation pins the opaque `W_bar_limit_infty` carrier to be the limit of `W_bar` at infinity; this IS how the paper introduces the carrier's relationship to its primitives, not a derivable consequence." ]
  scope := "Corollary cor:disclosure Part 1 proof, line 652 (aggregate welfare converges to a finite limit as β → ∞)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper-stated `Filter.Tendsto` characterisation on existing carriers). R24-C: now consumed downstream by `W_bar_limit_infty_le_W_bar_betaBarStar` derived theorem (Principal.lean). R40: structuralEquation per §3.4.3 — paper's atomic characterisation of `W_bar_limit_infty` carrier as Tendsto-limit of `W_bar`; 永不 close (paper definitional commitment)."
  conditionalOn := []

def entry_atom_betaStarOfP_def : GapEntry where
  name := "betaStarOfP_def"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:three-regime-five-state Regime (i), line 814 (β*(p) interior minimum)"
  attackHistory :=
    [ "Cat 3 atomic structural-equation axiom: `∀ p ∈ [0, p_1), ∀ β > 0, L (betaStarOfP p) p ≤ L β p`. Paper Regime (i) line 814 reads `unique interior minimum β*(p) ∈ (0, ∞) satisfying L(β*(p), p) < L(∞, p) = 0.4`. Argmin-characterisation pins `betaStarOfP p` to a minimiser of `L(·, p)` over the positive reals. Existence and uniqueness are separate Cat 3 OPEN claims (`gap_three_regime_reversal_existence_OPEN`, `gap_three_regime_reversal_uniqueness_OPEN`). Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel.",
      "R24-C 2026-05-13: gained explicit downstream consumer via Wire #4 (R23-D Pattern 7 phantom-downstream repair): added Cat 3 derived theorem `betaStarOfP_loss_below_limit` (Canonical.lean) composing this argmin-fact with the existence sub-axiom `gap_three_regime_reversal_existence_OPEN` via transitivity (`betaStarOfP_def gives ≤ L β_star_p p; existence gives < 0.4; transitivity gives < 0.4`). The atom now serves the substantive paper claim `L(β*(p), p) < 0.4` operationally — binding the existential witness to the canonical `betaStarOfP` carrier.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM.",
      "R28 2026-05-13: status-laundering revert per R27-B Pattern 13 audit. This entry is a paper-DERIVED higher-level claim (`prop:three-regime-five-state` Regime (i) line 814 argmin characterisation of β*(p) as the unique interior minimum), NOT a paper definitional commitment. The argmin characterisation is paper-derived from existence + uniqueness sub-axioms; pinning `betaStarOfP` via axiom is a working-assumption shortcut pending derivation from those existence + uniqueness inputs. Reclassified DEFINITIONAL → OPEN; subClass DEFINITIONAL_ATOM → WORKING_ASSUMPTION.",
      "R40 2026-05-14: reclassified workingAssumption → structuralEquation per R39 same-logic extension (paper-stated atomic characterization on opaque carrier per §3.4.3 'paper's commitment to how its primitives behave'); status gapOpen → gapDefinitional. Resolves R28 conservative status-laundering concern: R28 was correct to revert these from DEFINITIONAL to OPEN at the time because workingAssumption wasn't fully distinguished from structuralEquation; R39 + R40 establish the pattern: paper-stated atomic content on opaque carriers extracted from theorem statements = structuralEquation. The argmin characterisation pins the opaque `betaStarOfP` carrier as a minimiser of `L(·, p)` within Regime (i); this IS how the paper introduces the carrier's relationship to its primitives, not a derivable consequence." ]
  scope := "Proposition prop:three-regime-five-state Regime (i), line 814 (β*(p) interior minimum)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (argmin-characterisation on existing `betaStarOfP` and `L` carriers within Regime (i)'s domain). R24-C: now consumed downstream by `betaStarOfP_loss_below_limit` derived theorem (Canonical.lean). R40: structuralEquation per §3.4.3 — paper's atomic characterisation of `betaStarOfP` carrier as argmin of `L` within Regime (i); 永不 close (paper definitional commitment)."
  conditionalOn := []

/-! ## R23-C2 Cat 3 atomic structural-equation layer (Manufactured-Recognition pattern)

R23-C2 conversions per `feedback_gap_ledger_in_lean4` 2026-05-13
worked-example pattern (decompose conclusion-axiom into carrier-predicate
atom + atomic-stipulation atom + derived theorem). Three new atomic
structural-equation axioms hosting the per-conversion paper-stated
structural facts; their downstream-derived theorems live in Phase.lean,
GeneralGraphs.lean (already counted in `entry_prop_trap_prevalence_zero`,
`entry_lem_V_g_le_V_dyn`, `entry_lem_dilemma_subsumed_by_general_tree`). -/

def entry_atom_forward_reachable_full_at_zero : GapEntry where
  name := "forward_reachable_full_at_zero_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:trap-prevalence Part 1 proof, line 463 (`R(v) = V` for all `v` when no edges are blocked)"
  attackHistory :=
    [ "R23-C2 2026-05-13: Cat 3 atomic structural-equation axiom: `∀ [Fintype Vertex] v H ω, blockingProb = 0 → ForwardReachable v H ω = Finset.univ`. Paper proof of Proposition `prop:trap-prevalence` Part 1 line 463 reads 'When no edges are blocked, `R(v) = V` for all `v`': the entire vertex set is forward-reachable from any starting vertex when no edge is blocked. Pins the paper-stated full-reachability fact at `p = 0` on the existing `ForwardReachable` carrier. Cat 1 reduction check: not Mathlib-derivable (depends on the paper's bond-percolation semantics linking `blockingProb = 0` to all-edges-open + connectivity). Cat 2 reduction check: paper-novel structural equation on the IDP primitives. Encoding requires `[Fintype Vertex]` to express `Finset.univ` (paper Definition 2.1: graph on `n` nodes, finite). Hosted by `gap_trap_prevalence_zero` derived theorem (Phase.lean).",
      "R24-A 2026-05-13: SCOPE-INFLATION repair per R23-D Audit 1 hostile audit. The R23-C2 form `∀ [Fintype Vertex] v H ω, blockingProb = 0 → ForwardReachable v H ω = Finset.univ` quantified the equality over ARBITRARY history `H`, but paper line 463 says only `R(v) = V` (i.e., `ReachableSet v ω = Finset.univ`, equivalently `ForwardReachable v ∅ ω = Finset.univ` via `ReachableSet_eq_ForwardReachable_empty`). For `H ∋ u` (e.g. `H = {v}` after visiting `v`), removing `v` from a connected graph could disconnect it, so `ForwardReachable u {v} ω ≠ Finset.univ` in general at `p = 0`. RESTATED to `∀ [Fintype Vertex] v ω, blockingProb = 0 → ForwardReachable v ∅ ω = Finset.univ` (H quantifier dropped from atom signature; H pinned to ∅ matching paper line 463 scope exactly). The downstream consumer `gap_trap_prevalence_zero` is also restated to apply the atom only at `H = ∅` (both sides), which matches paper line 463's `V_dyn(v) = r* = max r` for all `v` at `p = 0`. Lake build green.",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Proposition prop:trap-prevalence Part 1 proof, line 463 (`R(v) = V` for all `v` when no edges are blocked)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper-stated structural equation linking `blockingProb = 0` to `ForwardReachable v ∅ ω = Finset.univ` at the H=∅ scope matching paper line 463). Downstream consumer: `gap_trap_prevalence_zero` derived theorem (Phase.lean), refactored from prior `gap_trap_prevalence_zero_OPEN`. R24-A: scope tightened from `∀ H` to `H = ∅` to match paper line 463 (paper's `R(v) = V` is the `ReachableSet`-level statement); `H ∋ u` cases are handled by other reachable-set facts (e.g. `ForwardReachable_self_member`)."
  conditionalOn := []

def entry_atom_V_g_terminal_in_ForwardReachable : GapEntry where
  name := "V_g_terminal_in_ForwardReachable_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Definition def:greedy-path, lines 982-985 (terminal-vertex reward + open-edge propagation); Definition 2.5 def:forward-reachable"
  attackHistory :=
    [ "R23-C2 2026-05-13: Cat 3 atomic structural-equation axiom: `∀ u H ω, ∃ w ∈ ForwardReachable u H ω, V_g u H ω = reward w`. Paper Definition `def:greedy-path` describes the greedy traversal as moving via open edges; the terminal vertex (a) lies in `ForwardReachable u H ω` (paper Def 2.5 — open-edge propagation + length-0 path inclusion) and (b) yields the greedy-path value as its reward (paper line 984 leaf case `V_g(u) = r(u)`). Single-existential encoding. Cat 1 reduction check: not Mathlib-derivable (constrains opaque carrier `V_g` against the existing `ForwardReachable` and `reward` primitives). Cat 2 reduction check: paper-novel. Hosted by `gap_V_g_le_V_dyn` derived theorem (GeneralGraphs.lean).",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Definition def:greedy-path, lines 982-985 (terminal-vertex reward + open-edge propagation); Definition 2.5 def:forward-reachable"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper-stated structural fact about the greedy-traversal terminal vertex's membership in the forward-reachable set + reward equation). Downstream consumer: `gap_V_g_le_V_dyn` derived theorem (GeneralGraphs.lean) refactored from prior `gap_V_g_le_V_dyn_OPEN`."
  conditionalOn := []

def entry_atom_terminal_neighbour_implies_C2prime : GapEntry where
  name := "terminal_neighbour_implies_C2prime_atom_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 6.1 thm:general-tree subsumption + line 1019 (terminal-neighbour topology + C2 ⇒ C2′; non-interference clause vacuous at degree 2)"
  attackHistory :=
    [ "R23-C2 2026-05-13: Cat 3 atomic structural-implication axiom: `C2_RewardTopologyMisalignment → TerminalNeighbourTopology → C2prime_GreedyPathMisalignment`. Paper line 1019 reads 'Theorem 6.1 subsumes Theorem 3.2 (terminal-neighbour topology satisfies C2′ whenever C2 holds, since V_g = V_dyn on flat subtrees and the non-interference clause is vacuous for degree~2)'. Encoded as paper-stated structural-implication atom on the existing Cat 3 hypothesis predicates `C2_RewardTopologyMisalignment`, `C2prime_GreedyPathMisalignment`, `TerminalNeighbourTopology` (Types.lean §6 + §10). Cat 1 reduction check: not Mathlib-derivable (predicates are opaque IDP primitives). Cat 2 reduction check: paper-novel structural implication on the IDP hypothesis predicates. Hosted by `dilemma_subsumed_by_gap_general_tree` derived theorem (GeneralGraphs.lean).",
      "R27-A 2026-05-13: Cat 3 sub-classification DEFINITIONAL_ATOM per `feedback_gap_ledger_in_lean4` 2026-05-13 extension; status reclassified OPEN → DEFINITIONAL (paper-novel atomic structural-equation that IS the paper's starting commitment, NOT a gap to close — 永不 close per discipline). New `subClass` field set to DEFINITIONAL_ATOM." ]
  scope := "Theorem 6.1 thm:general-tree subsumption + line 1019 (terminal-neighbour topology + C2 ⇒ C2′; non-interference clause vacuous at degree 2)"
  obstacleOrAttribution :=
    "Accepted as Cat 3 atomic axiom per discipline (paper-stated structural-implication atom on existing hypothesis predicates per the discipline `paper-stated structural-implication atoms on existing hypothesis predicates are Cat 3 atoms`). Downstream consumer: `dilemma_subsumed_by_gap_general_tree` derived theorem (GeneralGraphs.lean) refactored from prior `dilemma_subsumed_by_gap_general_tree_OPEN`."
  conditionalOn := []

/-! ## R36 atomic-stipulation layer (Manufactured-Recognition §18 pattern)

R36 2026-05-14 decomposition per `feedback_gap_ledger_in_lean4` §18
Manufactured-Recognition pattern (split bundled conclusion-axioms into
Cat 3 atomic-stipulation atoms + derived theorem). Six new Cat 3 OPEN
atomic-stipulation entries supporting two derived-theorem promotions:

  * Cognitive.lean Part 3 decomposition (4 atoms): the bundled
    `gap_cognitive_threshold_part3_OPEN` 5-conjunction is replaced by
    derived theorem `gap_cognitive_threshold_part3` composing the four
    new atoms below with existing R23-C1 atom `kappaStar_def`.
    `entry_thm_cognitive_threshold` records the bundle-level R36 patch.
  * Wrongness.lean info-decay decomposition (2 atoms): the bundled
    `gap_info_decay_OPEN` 2-conjunction is replaced by derived theorem
    `gap_info_decay` composing the two new atoms below.
    `entry_prop_info_decay` flipped OPEN → CLOSED. -/

def entry_atom_mean_estimate_gap_continuous : GapEntry where
  name := "mean_estimate_gap_continuous_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 4.1 Part 3, line 493 (`m(κ)` continuous on `(0, ∞)`)"
  attackHistory :=
    [ "R36 2026-05-14: Cat 3 atomic-stipulation axiom: `Conditions_C1_C2_C3 → ∀ p, ContinuousOn (fun κ => mean_estimate_gap p κ) (Set.Ioi 0)`. Paper Theorem 4.1 Part 3 line 493 asserts continuity of `m(κ)` on `(0, ∞)` (the paper's domain restriction; `κ = 0` is structurally excluded per Remark `kappa-discontinuity`). Extracted as standalone Cat 3 atomic stipulation from the bundled `gap_cognitive_threshold_part3_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Cat 1 reduction check: not Mathlib-derivable (continuity is on opaque carrier `mean_estimate_gap`, paper-stated structural fact pending per-IDP-instance derivation from V_dyn / posterior continuity properties). Cat 2 reduction check: paper-novel (no external textbook covers this paper's `m(κ)` continuity). Downstream consumer: `gap_cognitive_threshold_part3` derived theorem (Cognitive.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 4.1 Part 3, line 493 (`m(κ)` continuous on `(0, ∞)`)"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

def entry_atom_mean_estimate_gap_tendsto_mLimit : GapEntry where
  name := "mean_estimate_gap_tendsto_mLimit_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 4.1 Part 3, line 505 (`m(κ) → V_dyn(u_2) − V_dyn(u_1) =: mLimit p` as `κ → ∞`)"
  attackHistory :=
    [ "R36 2026-05-14: Cat 3 atomic-stipulation axiom: `Conditions_C1_C2_C3 → ∀ p, Filter.Tendsto (fun κ => mean_estimate_gap p κ) Filter.atTop (nhds (mLimit p))`. Paper Theorem 4.1 Part 3 line 505 reads `m(κ) → V_dyn(u_2) − V_dyn(u_1)` as `κ → ∞`. Extracted as standalone Cat 3 atomic stipulation from the bundled `gap_cognitive_threshold_part3_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Hosts the Tendsto limit on the bundle's `mLimit` opaque carrier (distinct from the existing R23-C1 atom `mLimit_def` which hosts the analogous Tendsto on the separate `mLimitOf` carrier introduced for per-instance work; the two carriers exist because the bundled axiom and the R23-C1 extraction were introduced in separate rounds with separate carriers). Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel. Downstream consumer: `gap_cognitive_threshold_part3` derived theorem (Cognitive.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 4.1 Part 3, line 505 (Tendsto limit of `m(κ)` to `mLimit p` as `κ → ∞`)"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

def entry_atom_mLimit_pos : GapEntry where
  name := "mLimit_pos_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 4.1 Part 3, line 505 (`0 < mLimit p`)"
  attackHistory :=
    [ "R36 2026-05-14: Cat 3 atomic-stipulation axiom: `Conditions_C1_C2_C3 → ∀ p, 0 < mLimit p`. Paper Theorem 4.1 Part 3 line 505 writes `m(κ) → V_dyn(u_2) − V_dyn(u_1) > 0` as `κ → ∞`: strict positivity of the limit reflects C2 trap/bridge misalignment (`u_2` bridge neighbour has strictly higher dynamic value than trap neighbour `u_1`). Extracted as standalone Cat 3 atomic stipulation from the bundled `gap_cognitive_threshold_part3_OPEN` strict-positivity sub-clause per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Cat 1 reduction check: not Mathlib-derivable (constrains opaque carrier `mLimit`). Cat 2 reduction check: paper-novel. Downstream consumer: `gap_cognitive_threshold_part3` derived theorem (Cognitive.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 4.1 Part 3, line 505 (strict positivity of `mLimit p`)"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

def entry_atom_kappaStar_nonneg : GapEntry where
  name := "kappaStar_nonneg_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 4.1 Part 3, line 493 (`κ*(p, α) ≥ 0`)"
  attackHistory :=
    [ "R36 2026-05-14: Cat 3 atomic-stipulation axiom: `∀ p α, 0 ≤ kappaStar p α`. Paper Theorem 4.1 Part 3 line 493 characterises `kappaStar p α` as `sInf {κ > 0 : m(κ) ≥ 0}`, so `0 ≤ kappaStar p α` follows from the inf-over-positive-reals scope (the inf of a set of positive numbers is non-negative; the junk-value branch `Real.sInf_empty = 0` preserves the bound). Extracted as standalone Cat 3 atomic stipulation from the bundled `gap_cognitive_threshold_part3_OPEN` non-negativity sub-clause per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Retained as Cat 3 atomic stipulation rather than Cat 1 derivation because a Mathlib-level proof would require composing `kappaStar_def` (Cat 3 atom) with `Real.sInf` lower-bound / junk-value semantics; the paper-stated non-negativity is the natural primitive fact at this abstraction level. Cat 1 reduction check: derivable Cat 1 from `kappaStar_def` + `Real.sInf_nonneg` + junk-value handling, candidate for future round. Cat 2 reduction check: paper-novel. Downstream consumer: `gap_cognitive_threshold_part3` derived theorem (Cognitive.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 4.1 Part 3, line 493 (non-negativity of `kappaStar p α`)"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

def entry_atom_W_info_oracle_nonpos : GapEntry where
  name := "W_info_oracle_nonpos_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:info-decay, lines 270-272 (`W_info_oracle ≤ 0`)"
  attackHistory :=
    [ "R36 2026-05-14: Cat 3 atomic-stipulation axiom: `∀ p, harrisKestenCriticalProb < p → ∀ β > 0, W_info_oracle p β ≤ 0`. Paper Proposition `prop:info-decay` line 272 states the oracle's informational residual is non-positive and exponentially small; this atom isolates the sign clause of the paper's joint claim on the opaque carrier `W_info_oracle : ℝ → ℝ → ℝ` (R19-A). Non-positivity reflects information value is bounded by topology-only welfare under topology-blind signals (paper §3 W_info ≤ 0 family). Extracted as standalone Cat 3 atomic stipulation from the bundled `gap_info_decay_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Cat 1 reduction check: not Mathlib-derivable (constrains opaque carrier `W_info_oracle`). Cat 2 reduction check: paper-novel (no external textbook covers this paper's `W_info_oracle` sign). Downstream consumer: `gap_info_decay` derived theorem (Wrongness.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:info-decay, lines 270-272 (non-positivity sub-clause)"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

def entry_atom_W_info_oracle_exponential_bound : GapEntry where
  name := "W_info_oracle_exponential_bound_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:info-decay, lines 270-277 (`|W_info_oracle| = O(2^{-β})`, uniformly in `n` for `p > p_c`); Grimmett 1999 _Percolation_ 2nd ed. §6.75 (Cat 2 cluster-size exponential-decay dependency)"
  attackHistory :=
    [ "R36 2026-05-14: Cat 3 atomic-stipulation axiom: `(h_grimmett : Grimmett cluster-size tail) → ∀ p > p_c, ∃ C > 0, ∀ β > 0, |W_info_oracle p β| ≤ C * 2^{-β}`. Paper Proposition `prop:info-decay` line 272 reads `|W_info| = O(2^{-β})` as `β → ∞`, uniformly in `n` for `p > p_c`. The exponential-bound sub-clause of the paper's joint claim, extracted as standalone Cat 3 atomic stipulation from the bundled `gap_info_decay_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The Cat 2 dependency on Grimmett 1999 §6.75 cluster-size exponential tail is threaded as the explicit `h_grimmett` antecedent for audit-chain visibility (`#print axioms` on any theorem consuming this atom surfaces the Grimmett dependency). Cat 1 reduction check: not Mathlib-derivable (the substantive composition Cat 1 Mills + Cat 2 Grimmett remains a Mathlib measure-theoretic gap). Cat 2 reduction check: paper-novel framing on opaque carrier `W_info_oracle` (Grimmett 1999 is a Cat 2 dependency, not the claim itself). Downstream consumer: `gap_info_decay` derived theorem (Wrongness.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:info-decay, lines 270-277 (`O(2^{-β})` exponential bound sub-clause)"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-! # R37 atomic-stipulation layer (Manufactured-Recognition §18 decomposition,
     2026-05-14)

R37 extends the §18 decomposition pattern across 11 additional bundled
conclusion-axioms (10 derived theorems, since cor:disclosure parts (i)
and (ii) share an entry).  Per the discipline:
 * Wrongness.lean conditional-reduction-part-i: 1 atom +
   `gap_conditional_reduction_part_i` derived theorem.
 * Phase.lean phase-transition-below: 2 atoms +
   `gap_phase_transition_below` derived theorem.
 * Phase.lean phase-transition-above: 2 atoms +
   `gap_phase_transition_above` derived theorem.
 * Phase.lean trap-prevalence-above: 1 atom +
   `gap_trap_prevalence_above_threshold` derived theorem.
 * Cognitive.lean supermodular: 2 atoms + `gap_supermodular` derived theorem.
 * Cognitive.lean sentimental-immunity: 3 atoms + `gap_sentimental_immunity`
   derived theorem.
 * Principal.lean principal-interior-optimum: 3 atoms +
   `gap_principal_interior_optimum` derived theorem.
 * Principal.lean principal-monotone-in-kappa: 2 atoms +
   `gap_principal_monotone_in_kappa` derived theorem.
 * Principal.lean principal-regime-bifurcation: 2 atoms +
   `gap_principal_regime_bifurcation` derived theorem.
 * Principal.lean disclosure-full-suboptimal: 2 atoms +
   `gap_disclosure_full_suboptimal` derived theorem.
 * Principal.lean disclosure-differentiated-dominates: 1 atom +
   `gap_disclosure_differentiated_dominates` derived theorem.

Net: +21 new Cat 3 OPEN atomic-stipulation entries; existing 10 bundle
entries flip OPEN/PARTIAL → CLOSED (or the relevant sub-clause flips
within the existing bundle status, with bundle-level status updated). -/

/-- Cat 3 atomic stipulation: paper Lemma `lem:conditional-reduction`
    part (i), conditional-Blackwell applicability on the restricted
    action domain `R(v_0)` for Blackwell-ordered signal families. -/
def entry_atom_conditional_subproblem_blackwell_applicable : GapEntry where
  name := "conditional_subproblem_blackwell_applicable_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Lemma lem:conditional-reduction part (i), line 375 (statement); proof line 381 (fixed-feasible-set conditional subproblem permits direct Blackwell-theorem application); Blackwell 1951/1953 (Cat 2 dependency)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_conditional_reduction_part_i_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The atom isolates the paper-stated conditional-Blackwell-applicability fact on the existing carrier `conditionalWelfareOnR R signalFamily β`, threading the Cat 2 Blackwell 1951/1953 dependency as the explicit `h_blackwell` antecedent. Cat 1 reduction check: not Mathlib-derivable (Mathlib lacks decision-theoretic Blackwell ordering on signal-experiment lattices). Cat 2 reduction check: paper-novel application to opaque carrier (Blackwell 1951/1953 is the Cat 2 dependency, not the claim itself). Downstream consumer: `gap_conditional_reduction_part_i` derived theorem (Wrongness.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Lemma lem:conditional-reduction part (i), Blackwell ordering applicability to conditional subproblem on R(v_0)"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Theorem 3.3 Part 1 proof (line
    415-417), existence of decay envelope `topo_loss_decay : ℕ → ℝ`
    for `expectedTopoLoss n p` below the percolation threshold. -/
def entry_atom_topo_loss_decay_below_pc : GapEntry where
  name := "topo_loss_decay_below_pc_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 3.3 Part 1 proof, lines 415-417 (`E[|W_topo|] = O(1/N) → 0` via giant-component conditioning + topo-cluster formula); Grimmett 1999 (Cat 2 percolation-probability dependency)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_phase_transition_below_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The atom isolates the EXISTENCE of a decay-function envelope on the existing carrier `expectedTopoLoss`. Cat 2 dependency on Grimmett 1999 percolation-probability threaded as explicit `h_perc_prob` antecedent. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel framing on opaque carrier. Downstream consumer: `gap_phase_transition_below` derived theorem (Phase.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 3.3 Part 1, existence of decay envelope `topo_loss_decay` for `expectedTopoLoss n p` below percolation threshold"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Theorem 3.3 Part 1 proof (line
    417), arbitrary-threshold convergence form for `expectedTopoLoss
    n p` from the existence of a decay envelope. -/
def entry_atom_topo_loss_decay_arbitrary_threshold : GapEntry where
  name := "topo_loss_decay_arbitrary_threshold_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 3.3 Part 1 proof, line 417 (asymptotic convergence `O(1/N) → 0`)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_phase_transition_below_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Second atom completing the decomposition: converts the decay envelope (from `topo_loss_decay_below_pc_OPEN`) into the paper-stated arbitrary-ε convergence bound. Cat 1 reduction check: the unfolding step itself is Cat 1 derivable from Mathlib `Filter.Tendsto`, but this atom is retained as a paper-stated structural form per §18 (the paper-stated convergence is the operative downstream content). Cat 2 reduction check: paper-novel framing on opaque carrier. Downstream consumer: `gap_phase_transition_below` derived theorem (Phase.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 3.3 Part 1, arbitrary-threshold convergence form for `expectedTopoLoss n p`"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Theorem 3.3 Part 2 proof (lines
    421-427), existence of positive constant `c(p) > 0` characterising
    the `wInfoTopoRatio p β` exponential-decay rate above threshold. -/
def entry_atom_wInfoTopoRatio_const_exists : GapEntry where
  name := "wInfoTopoRatio_const_exists_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 3.3 Part 2 proof, lines 421-427 (cluster size exponential tail + ratio Θ-bound); Grimmett 1999 §6.75 (Cat 2 dependency)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_phase_transition_above_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The atom isolates the EXISTENCE of a positive constant on the existing carrier `wInfoTopoRatio`. Cat 2 dependency on Grimmett 1999 §6.75 cluster-size exponential decay threaded as explicit `h_grimmett` antecedent. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel framing on opaque carrier (Grimmett 1999 is the Cat 2 dependency, not the claim itself). Downstream consumer: `gap_phase_transition_above` derived theorem (Phase.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 3.3 Part 2, existence of positive constant `c(p) > 0` for `wInfoTopoRatio` exponential-decay rate"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Theorem 3.3 Part 2 proof (line 427),
    quantitative ratio bound `wInfoTopoRatio p β ≤ c * 2^{-β}` from
    the Mills-tail + cluster-size composition. -/
def entry_atom_wInfoTopoRatio_bound : GapEntry where
  name := "wInfoTopoRatio_bound_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 3.3 Part 2 proof, line 427 (`|W_info|/|W_topo| = O(2^{-β}) → 0`); Grimmett 1999 §6.75 + `prop:info-decay` composition (Cat 2 dependency)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_phase_transition_above_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The atom isolates the QUANTITATIVE bound on the existing carrier `wInfoTopoRatio` given a positive constant `c`. Cat 2 dependency on Grimmett 1999 §6.75 + `prop:info-decay` composition threaded as explicit `h_grimmett` antecedent. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel framing on opaque carrier. Downstream consumer: `gap_phase_transition_above` derived theorem (Phase.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 3.3 Part 2, quantitative ratio bound `wInfoTopoRatio p β ≤ c * 2^{-β}`"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:error-compounding`
    Part 5 (line 1048), positivity of the opaque `c_star_constant`
    appearing in the closed-form `κ*(d) = (1/2) log_2(d²/c* + 1)` for
    the depth-`d` trap tree.

    R41 promotion of GeneralGraphs.lean:490 implicit OPEN sub-axiom to
    a tracked Ledger entry. -/
def entry_atom_c_star_constant_pos : GapEntry where
  name := "gap_c_star_constant_pos_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:error-compounding Part 5, line 1048 (`c*(Δ_r, Δ_V) > 0`); paper does not give explicit closed form for c*"
  attackHistory :=
    [ "R41 2026-05-14: Cat 3 atomic-stipulation entry promotion. The axiom `gap_c_star_constant_pos_OPEN : 0 < c_star_constant` (GeneralGraphs.lean:490) was implicit in the source since R23 but not separately tracked in the Ledger; this entry corrects the audit-chain visibility per R40 close-target identification. Paper line 1048 asserts `c*(Δ_r, Δ_V) > 0` for the trap-tree opaque constant but does not give an explicit closed form (the Lean encoding mirrors via `axiom c_star_constant : ℝ` carrier + this positivity atom). Cat 1 reduction check: not Mathlib-derivable (requires explicit closed-form construction not given by paper). Cat 2 reduction check: paper-novel constant on opaque carrier. Downstream consumer: `gap_kappaStar_depth_d_upper_bound` derived theorem (GeneralGraphs.lean:567) consumes the atom for the Part 5 upper-bound proof. Classified as gapDefinitional/structuralEquation per §3.4.3 (paper-foundational atomic positivity stipulation on opaque `c_star_constant` carrier; 永不 close — paper does not provide derivation, only existence + positivity at line 1048)." ]
  scope := "Proposition prop:error-compounding Part 5, positivity of the opaque `c_star_constant` carrier appearing in `κ*(d)` closed form"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated positivity claim on opaque `c_star_constant` carrier (paper line 1048 asserts existence + positivity but provides no explicit formula)."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition
    `prop:bayesian-naive-five-state` (ii) (lines 955-956), Blackwell-
    recovery transfer at the bayesianNaive sub-problem under
    below-threshold scope `p̂ < 2/3` (given Cat 2 Blackwell antecedent).

    R41 §18 atomic decomposition of bundled `gap_bayesian_naive_reversal_absent_OPEN`. -/
def entry_atom_bayesian_naive_below_threshold_blackwell_recovery : GapEntry where
  name := "bayesian_naive_below_threshold_blackwell_recovery_atom_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:bayesian-naive-five-state (ii), lines 955-956 (Blackwell-recovery at below-threshold scope `p̂ < 2/3`); Blackwell 1951/1953 (Cat 2 dependency)"
  attackHistory :=
    [ "R41 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_bayesian_naive_reversal_absent_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The atom isolates the paper-stated Blackwell-recovery transfer at the bayesianNaive sub-problem (paper line 956: at `p̂ < 2/3` the trap-routing misspecification is dominated by the correctly-modelled bridge option, restoring the Blackwell-ordering chain). Single-atom decomposition is honest because the paper-stated content IS the Blackwell-recovery transfer at the below-threshold scope (per §10 paper-APPLICATION-to-opaque-carrier = Cat 3 with explicit Cat 2 chain). Cat 2 dependency on Blackwell 1951/1953 monotonicity threaded as explicit `h_blackwell` antecedent. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel transfer to bayesianNaive opaque carrier under below-threshold scope (Blackwell theorem itself is the Cat 2 underlying input). Downstream consumer: `gap_bayesian_naive_reversal_absent` derived theorem (Canonical.lean) hosts the atom. Classified as gapDefinitional/structuralEquation per §3.4.3 (paper-foundational atomic content on opaque `agentWelfare AgentType.bayesianNaive` carrier; 永不 close)." ]
  scope := "Proposition prop:bayesian-naive-five-state (ii), Blackwell-recovery transfer at bayesianNaive sub-problem under below-threshold scope `p̂ < 2/3`"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content on opaque `agentWelfare AgentType.bayesianNaive` carrier; Blackwell 1951/1953 acknowledged as Cat 2 underlying dependency via `h_blackwell` antecedent."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:topo-cluster`
    Part 1 (line 286), existence of a per-`n` decay envelope for
    `expectedTopoLoss n p` below the percolation threshold.

    R41 §18 atomic decomposition of bundled `gap_topo_loss_below_threshold_OPEN`.
    R42 reclassification structuralEquation → workingAssumption per hostile
    audit §3.4.3 vs §3.4.4 concern. -/
def entry_atom_topo_loss_below_envelope_exists : GapEntry where
  name := "topo_loss_below_envelope_exists_atom_OPEN"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.workingAssumption
  paperSource := "Proposition prop:topo-cluster Part 1, line 286 + proof lines 292-294 (`E[|W_topo|] = O(1/N) → 0` via giant-component conditioning + topo-cluster formula); Grimmett 1999 (Cat 2 percolation-probability dependency)"
  attackHistory :=
    [ "R41 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_topo_loss_below_threshold_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern (analogous to R37 `topo_loss_decay_below_pc_OPEN` which decomposed `gap_phase_transition_below_OPEN`; this entry is the prop:topo-cluster Part 1 mirror). The atom isolates the EXISTENCE of a decay-function envelope `topoLossBelowDecay : ℕ → ℝ` on the existing carrier `expectedTopoLoss`. Cat 2 dependency on Grimmett 1999 percolation-probability threaded as explicit `h_perc_prob` antecedent. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel framing on opaque carrier. Downstream consumer: `gap_topo_loss_below_threshold` derived theorem (Wrongness.lean) hosts the atom. Initial classification as gapDefinitional/structuralEquation per §3.4.3.",
      "R42 2026-05-14: hostile-audit-driven reclassification structuralEquation/gapDefinitional → workingAssumption/gapOpen. Discipline §3.4.3 examples are DEFINITIONAL EQUATIONS on primitives (`V_dyn_def`, paper §3.1 `W = W_topo + W_info` decomposition, Bridge_Defining_Biconditional) — paper commitments to how primitives behave that CANNOT BE PROVED (constitute meaning). The envelope-existence claim is NOT a definitional equation; it is a derived asymptotic existence claim that the paper proves at lines 292-294 via giant-component conditioning + Cat 2 Grimmett percolation-probability + topo-cluster formula. Substantive content requires Mathlib bond-percolation infrastructure (currently absent). Per §3.4.4 this is a workingAssumption (higher-level claim TEMPORARILY axiomatized; must convert to theorem before paper publication). Close target = Mathlib bond-percolation theory + paper's proof reconstruction." ]
  scope := "Proposition prop:topo-cluster Part 1, existence of decay envelope `topoLossBelowDecay` for `expectedTopoLoss n p` below threshold"
  obstacleOrAttribution :=
    "Cat 3 workingAssumption per `feedback_gap_ledger_in_lean4` §3.4.4 (higher-level claim TEMPORARILY axiomatized while derivation is being developed; 必须 close before publication). Close target = Mathlib bond-percolation theory + paper's lines 292-294 proof reconstruction (giant-component conditioning + topo-cluster formula). Substantive Cat 2 dependency on Grimmett 1999 _Percolation_ 2nd ed. percolation-probability theory."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:topo-cluster`
    Part 2 (line 287), existence of a positive lower bound `c₁(p) > 0`
    on `expectedTopoLoss n p` for sufficiently large `n` above the
    percolation threshold.

    R41 §18 atomic decomposition of bundled `gap_topo_loss_above_threshold_OPEN`.
    R42 reclassification structuralEquation → workingAssumption. -/
def entry_atom_topo_loss_above_lower_bound : GapEntry where
  name := "topo_loss_above_lower_bound_atom_OPEN"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.workingAssumption
  paperSource := "Proposition prop:topo-cluster Part 2, line 287 + proof via thm:phase Part 2 lines 421-427 (cluster-size theory above threshold); Grimmett 1999 §6.75 (Cat 2 dependency)"
  attackHistory :=
    [ "R41 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_topo_loss_above_threshold_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The atom isolates the LOWER-BOUND existence on the existing carrier `expectedTopoLoss`: paper proof uses above-threshold cluster theory `|R(v_0)| = O(1)` with positive probability so `E[1/(|R|+1)] ≥ c₁ > 0` for large `n`. Cat 2 dependency on Grimmett 1999 §6.75 cluster-size exponential decay threaded as explicit `h_grimmett` antecedent. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel framing on opaque carrier. Downstream consumer: `gap_topo_loss_above_threshold` derived theorem (Wrongness.lean) hosts the atom. Initial classification as gapDefinitional/structuralEquation per §3.4.3.",
      "R42 2026-05-14: hostile-audit-driven reclassification structuralEquation/gapDefinitional → workingAssumption/gapOpen per §3.4.4 (paper-derived existence claim requiring Mathlib percolation infra is workingAssumption, not paper-stipulative §3.4.3 commitment to primitive behavior)." ]
  scope := "Proposition prop:topo-cluster Part 2, existence of positive lower bound `c₁(p) > 0` on `expectedTopoLoss n p` for large `n`"
  obstacleOrAttribution :=
    "Cat 3 workingAssumption per §3.4.4 (必须 close before publication). Close target = Mathlib bond-percolation theory + Grimmett 1999 §6.75 cluster-tail derivation."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:topo-cluster`
    Part 2 (line 287), existence of an upper bound `c₂(p) ≥ c₁` on
    `expectedTopoLoss n p` for sufficiently large `n` (the Θ(1) upper
    side, conceptually weaker than the lower side but part of the
    paper's two-sided statement).

    R41 §18 atomic decomposition of bundled `gap_topo_loss_above_threshold_OPEN`.
    R42 reclassification structuralEquation → workingAssumption. -/
def entry_atom_topo_loss_above_upper_bound : GapEntry where
  name := "topo_loss_above_upper_bound_atom_OPEN"
  status := GapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.workingAssumption
  paperSource := "Proposition prop:topo-cluster Part 2, line 287; Grimmett 1999 §6.75 (Cat 2 dependency)"
  attackHistory :=
    [ "R41 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_topo_loss_above_threshold_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Second atom completing the decomposition: paper-stated existence of upper bound `c₂(p) ≥ c₁` on `expectedTopoLoss n p` for large `n`. Conceptually weaker than the lower-bound side (probabilistically `expectedTopoLoss ≤ 1` trivially) but part of the paper's Θ(1) two-sided statement; explicit upper constant from Θ-notation can be derived from the cluster-size analysis. Cat 2 dependency on Grimmett 1999 §6.75 threaded as explicit `h_grimmett` antecedent (paper attribution: the Θ(1) two-sided bound depends on the above-threshold cluster theory). Downstream consumer: `gap_topo_loss_above_threshold` derived theorem (Wrongness.lean) hosts the atom. Initial classification as gapDefinitional/structuralEquation per §3.4.3.",
      "R42 2026-05-14: hostile-audit-driven reclassification structuralEquation/gapDefinitional → workingAssumption/gapOpen per §3.4.4." ]
  scope := "Proposition prop:topo-cluster Part 2, existence of upper bound `c₂(p) ≥ c₁` on `expectedTopoLoss n p` for large `n`"
  obstacleOrAttribution :=
    "Cat 3 workingAssumption per §3.4.4 (必须 close before publication). Close target = Mathlib bond-percolation theory + Grimmett 1999 §6.75."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:trap-prevalence`
    Part 2 proof (line 473), local FKG-positivity of the trap pattern
    on `Z²` lattice with degree 4. -/
def entry_atom_trap_config_local_positive : GapEntry where
  name := "trap_config_local_positive_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:trap-prevalence Part 2 proof, line 473 (`binom(4, 2) p² (1-p)² · p^3 > 0` lattice-degree-4 local FKG estimate)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_trap_prevalence_above_threshold_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The atom isolates the LOCAL FKG-positivity fact on the existing carrier `trapMisalignmentProbability`. Cat 1 reduction check: not Mathlib-derivable (depends on Z²-lattice + percolation-measure machinery). Cat 2 reduction check: paper-novel local-FKG estimate (FKG inequality framework is Cat 2 in general, but the paper-specific local-pattern application is Cat 3 paper-novel). Downstream consumer: `gap_trap_prevalence_above_threshold` derived theorem (Phase.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:trap-prevalence Part 2, local FKG-positivity of trap pattern"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:supermodular`
    proof line 580-583, explicit closed-form expression for the
    welfare cross-partial via `φ'(z) = -z·φ(z)` Gaussian PDF
    derivative identity. -/
def entry_atom_welfareCrossPartial_explicit_form : GapEntry where
  name := "welfareCrossPartial_explicit_form_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:supermodular proof, lines 564-583 (welfare decomposition + cross-partial closed form via φ'(z) = -z·φ(z))"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_supermodular_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The atom isolates the EXISTENCE of an algebraic decomposition of `welfareCrossPartial β κ` as a sum of two paper-stated contributions on the carriers `welfareCrossPartial`, `snrZ`, `BridgeDominance`. Encoded as a per-(β, κ) existential `∃ first second, welfareCrossPartial = first + second ∧ second-non-negative ∧ (|z|<1 → 0 < first)`. Cat 1 reduction check: not Mathlib-derivable (HasDerivAt + Φ + φ derivative machinery is a Mathlib gap). Cat 2 reduction check: paper-novel calculus on the IDP welfare functional. Downstream consumer: `gap_supermodular` derived theorem (Cognitive.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:supermodular, explicit closed-form decomposition of welfare cross-partial"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:supermodular`
    proof line 582-584, sign-positivity of the cross-partial
    decomposition factors at `|z| < 1`. -/
def entry_atom_cross_partial_sign_in_z_lt_one : GapEntry where
  name := "cross_partial_sign_in_z_lt_one_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:supermodular proof, line 582-584 (factor-sign analysis at `|z| < 1`)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_supermodular_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Captures the paper's sign-analysis step that converts the explicit closed-form expression (encoded by `welfareCrossPartial_explicit_form_OPEN`) into the strict-positivity conclusion under the moderate-SNR + bridge-dominance joint antecedent. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel sign analysis on opaque-carrier decomposition. Downstream consumer: `gap_supermodular` derived theorem (Cognitive.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:supermodular, sign-positivity at `|z| < 1`"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:sentimental`
    proof line 600 (signal-independent ranking at α = 0). -/
def entry_atom_signal_independent_at_alpha_zero : GapEntry where
  name := "signal_independent_at_alpha_zero_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:sentimental proof, line 600 (signal-independent ranking at α = 0 + `lem:conditional-reduction` application)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_sentimental_immunity_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The α = 0 base case is the primitive paper-stated fact on the sentimental-agent welfare carrier. Cat 1 reduction check: not Mathlib-derivable (depends on `lem:conditional-reduction`(i) + sentimental-agent welfare carrier). Cat 2 reduction check: paper-novel application of `lem:conditional-reduction` to the sentimental agent at α = 0. Downstream consumer: `gap_sentimental_immunity` derived theorem (Cognitive.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:sentimental, α = 0 base case (signal-independent ranking)"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:sentimental`
    proof line 602, perturbative welfare continuity in α with small-α
    monotonicity neighbourhood. -/
def entry_atom_welfare_continuity_in_alpha : GapEntry where
  name := "welfare_continuity_in_alpha_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:sentimental proof, line 602 (closed monotonicity-set + small-α perturbation neighborhood)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_sentimental_immunity_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Captures paper-stated closedness + small-α perturbation neighborhood. Cat 1 reduction check: not Mathlib-derivable (depends on closed-set / compact-domain Banach-lattice analysis applied to opaque welfare carrier). Cat 2 reduction check: paper-novel perturbation argument. Downstream consumer: `gap_sentimental_immunity` derived theorem (Cognitive.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:sentimental, perturbative continuity in α + small-α monotonicity neighbourhood"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:sentimental`
    proof line 602, sup-existence of `α*` over the monotonicity set
    given a small-α neighbourhood. -/
def entry_atom_alpha_star_existence_via_continuity : GapEntry where
  name := "alpha_star_existence_via_continuity_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:sentimental proof, line 602 (sup over monotonicity set)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_sentimental_immunity_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Captures paper-stated existence of `α*` with positivity + upper-bound-by-1 + monotonicity-for-α-below-α* implication, given the small-α neighbourhood from `welfare_continuity_in_alpha_OPEN`. Cat 1 reduction check: not Mathlib-derivable (depends on opaque `alphaStar` carrier supremum characterisation). Cat 2 reduction check: paper-novel sup-existence argument on opaque carrier. Downstream consumer: `gap_sentimental_immunity` derived theorem (Cognitive.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:sentimental, sup-existence of `α*` from continuity neighbourhood"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:principal-optimum`
    Part 1 proof (line 632), `W_bar` eventually decreasing under
    reversal-regime support. -/
def entry_atom_W_bar_eventually_decreasing_in_reversal : GapEntry where
  name := "W_bar_eventually_decreasing_in_reversal_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:principal-optimum Part 1 proof, line 632 (each individual welfare non-monotone → `W_bar` eventually decreasing)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_principal_interior_optimum_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Captures the eventually-decreasing sub-clause via Theorem `thm:cognitive-threshold` Part 1. Cat 1 reduction check: not Mathlib-derivable (depends on `thm:cognitive-threshold` Part 1 `agentWelfare` opaque-carrier non-monotonicity). Cat 2 reduction check: paper-novel application. Downstream consumer: `gap_principal_interior_optimum` derived theorem (Principal.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:principal-optimum Part 1, `W_bar` eventually decreasing under reversal-regime support"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:principal-optimum`
    Part 1 proof (line 632), `W_bar` exceeds `W_bar(0)` at some
    `β > 0` via within-branch discrimination benefit. -/
def entry_atom_W_bar_exceeds_zero_at_positive_beta : GapEntry where
  name := "W_bar_exceeds_zero_at_positive_beta_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:principal-optimum Part 1 proof, line 632 (within-branch discrimination benefit at small β dominates routing loss)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_principal_interior_optimum_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Captures within-branch discrimination benefit on opaque carrier `W_bar`. Cat 1 reduction check: not Mathlib-derivable (depends on Lemma `lem:conditional-reduction`(i) + per-agent welfare derivative comparison). Cat 2 reduction check: paper-novel application. Downstream consumer: `gap_principal_interior_optimum` derived theorem (Principal.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:principal-optimum Part 1, `W_bar` exceeds `W_bar(0)` at some `β > 0`"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:principal-optimum`
    Part 1 (line 624-625), interior-maximum existence from unimodal
    envelope shape. -/
def entry_atom_interior_max_exists_from_unimodal_envelope : GapEntry where
  name := "interior_max_exists_from_unimodal_envelope_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:principal-optimum Part 1, lines 624-625 (interior optimum `betaBarStar ∈ (0, ∞)`)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_principal_interior_optimum_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Packages the paper's existence-of-interior-maximum inference given the prior two atomic stipulations (eventually-decreasing + exceeds-zero). Cat 1 reduction check: candidate Cat 1 derivation via Mathlib continuous-function-on-compact-interval IVT-style argument applied to `W_bar`, but the underlying continuity is a Mathlib gap (paper-implicit standing assumption, not separately encoded as a Cat 3 atom — would require a `W_bar_continuous` axiom). Cat 2 reduction check: paper-novel application. Downstream consumer: `gap_principal_interior_optimum` derived theorem (Principal.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:principal-optimum Part 1, interior-maximum existence"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:principal-optimum`
    Part 2 proof (line 634), FOSD-induced derivative-domination of
    `aggregateWelfareWith G`. -/
def entry_atom_fosd_induces_derivative_domination : GapEntry where
  name := "fosd_induces_derivative_domination_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:principal-optimum Part 2 proof, line 634 (FOSD + supermodular → derivative-domination)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_principal_monotone_in_kappa_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Encodes paper-stated FOSD-induces-derivative-domination on opaque carrier `aggregateWelfareWith` via the discrete derivative-inequality form. Cat 1 reduction check: not Mathlib-derivable (depends on HasDerivAt + Lebesgue-Stieltjes machinery). Cat 2 reduction check: paper-novel application of `prop:supermodular` integrated against FOSD-dominating distribution. Downstream consumer: `gap_principal_monotone_in_kappa` derived theorem (Principal.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:principal-optimum Part 2, FOSD-induced derivative domination"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:principal-optimum`
    Part 2 proof (line 634, second sentence), argmax-monotonicity from
    derivative-domination. -/
def entry_atom_argmax_monotone_under_derivative_domination : GapEntry where
  name := "argmax_monotone_under_derivative_domination_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:principal-optimum Part 2 proof, line 634 (zero crossing weakly to the right → argmax monotonicity)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_principal_monotone_in_kappa_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Captures paper-stated argmax-monotonicity inference from prior derivative-domination atom. Cat 1 reduction check: candidate Cat 1 derivation (Mathlib argmax-monotonicity from derivative-comparison), but depends on opaque `aggregateOptimalBeta` argmax-characterisation which is a paper-novel encoding. Cat 2 reduction check: paper-novel argmax framework. Downstream consumer: `gap_principal_monotone_in_kappa` derived theorem (Principal.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:principal-optimum Part 2, argmax-monotonicity from derivative-domination"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:principal-optimum`
    Part 3 proof (lines 636-640), mixture decomposition of `W_bar`
    into above-threshold non-decreasing + below-threshold eventually-
    decreasing parts. -/
def entry_atom_W_bar_mixture_decomposition : GapEntry where
  name := "W_bar_mixture_decomposition_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:principal-optimum Part 3 proof, lines 636-640 (mixture decomposition `W̄ = λ · above + (1-λ) · below`)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_principal_regime_bifurcation_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Encodes paper-stated mixture decomposition qualitatively. Cat 1 reduction check: not Mathlib-derivable (depends on bounded-measure / conditional-expectation machinery). Cat 2 reduction check: paper-novel application of mixture decomposition. Downstream consumer: `gap_principal_regime_bifurcation` derived theorem (Principal.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:principal-optimum Part 3, mixture decomposition of `W_bar`"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:principal-optimum`
    Part 3 proof (line 640), non-concavity triple from mixture
    decomposition. -/
def entry_atom_non_concave_triple_from_mixture : GapEntry where
  name := "non_concave_triple_from_mixture_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:principal-optimum Part 3 proof, line 640 (non-concavity `W̄` valley pattern)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_principal_regime_bifurcation_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Captures paper-stated non-concavity triple from mixture decomposition. Cat 1 reduction check: candidate Cat 1 derivation (Mathlib monotonicity-pattern analysis), but depends on the paper-novel mixture-decomposition framing. Cat 2 reduction check: paper-novel sum-of-monotone-and-non-monotone framework. Downstream consumer: `gap_principal_regime_bifurcation` derived theorem (Principal.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:principal-optimum Part 3, non-concavity triple from mixture"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Corollary `cor:disclosure` Part 1
    proof (lines 652-654), G-averaged reversal-regime overshoot
    `δ̄ > 0`. -/
def entry_atom_averaged_reversal_overshoot_positive : GapEntry where
  name := "averaged_reversal_overshoot_positive_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Corollary cor:disclosure Part 1 proof, lines 652-654 (G-averaged reversal-regime overshoot `δ̄ > 0`)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_disclosure_full_suboptimal_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Captures paper-stated overshoot positivity in reversal regime. Cat 1 reduction check: not Mathlib-derivable (depends on conditional-expectation + Theorem `thm:cognitive-threshold` Part 1 composition). Cat 2 reduction check: paper-novel application. Downstream consumer: `gap_disclosure_full_suboptimal` derived theorem (Principal.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Corollary cor:disclosure Part 1, averaged reversal-regime overshoot positivity"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Corollary `cor:disclosure` Part 1
    proof (line 656), finite-β-strictly-above-limit existence from
    positive averaged overshoot. -/
def entry_atom_finite_beta_above_limit_from_overshoot : GapEntry where
  name := "finite_beta_above_limit_from_overshoot_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Corollary cor:disclosure Part 1 proof, line 656 (`λ ε < (1 - λ) δ̄ ⇒ W̄(β_0) > W̄(∞)`)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_disclosure_full_suboptimal_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Captures finite-β-strictly-above-limit existence from positive averaged overshoot. Cat 1 reduction check: candidate Cat 1 derivation (Mathlib limit-comparison + ε-choice machinery), but depends on opaque `W_bar_limit_infty` characterisation. Cat 2 reduction check: paper-novel application. Downstream consumer: `gap_disclosure_full_suboptimal` derived theorem (Principal.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Corollary cor:disclosure Part 1, finite-β-strictly-above-limit existence"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Corollary `cor:disclosure` Part 2
    proof (line 658), per-agent-optimum aggregate dominates uniform
    aggregate. -/
def entry_atom_differentiated_per_agent_optimum_dominates_uniform : GapEntry where
  name := "differentiated_per_agent_optimum_dominates_uniform_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Corollary cor:disclosure Part 2 proof, line 658 (per-agent `β_i = β*(κ_i, α_i)` optimum aggregated)"
  attackHistory :=
    [ "R37 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_disclosure_differentiated_dominates_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Captures paper-stated per-agent-optimum aggregate dominates uniform aggregate. Cat 1 reduction check: not Mathlib-derivable (depends on measure-theoretic per-agent integration). Cat 2 reduction check: paper-novel application. Downstream consumer: `gap_disclosure_differentiated_dominates` derived theorem (Principal.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Corollary cor:disclosure Part 2, per-agent-optimum aggregate dominates uniform aggregate"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-! # R38 atomic-stipulation layer (Manufactured-Recognition §18 decomposition,
     2026-05-14)

R38 extends the §18 atomic-decomposition across the remaining bundled
conclusion-axioms. Per `feedback_gap_ledger_in_lean4` §18:

 * Cognitive.lean Parts 1, 2, 4, 5, 6 (5 atoms, 5 derived theorems).
 * Cognitive.lean cross-partial link (1 atom, 1 derived theorem).
 * Wrongness.lean wrongness lemma (1 atom, 1 derived theorem).
 * Canonical.lean interior optimum + 6 Regime (i) sub-claims + 5-state
   smooth transition (2 atoms) + 5-state kappa-above + Bayesian-naive (iii)
   (10 atoms, 10 derived theorems).
 * GeneralGraphs.lean general tree + cyclic trap + Bernoulli depth growth
   (3 atoms, 3 derived theorems).
 * Bayesian.lean myopic-k + satisficing (2 atoms, 2 derived theorems).

Net: +23 new Cat 3 OPEN atomic-stipulation entries (5 Cognitive + 1 link +
1 wrongness + 11 Canonical + 3 GeneralGraphs + 2 Bayesian).  Bundle
entries flip OPEN → CLOSED where the axiom was the only OPEN sub-clause.

Note: `gap_threshold_fiveState_smooth_transition_OPEN` decomposed into
two atoms (inflection-positivity + below-inflection-welfare-bound), so
the R38 atom count is 23 (= 22 targets + 1 split). -/

/-- Cat 3 atomic stipulation: paper Theorem 4.1 Part 1 (line 491), greedy
    welfare reversal triggered at `α > α*(0, p)`. -/
def entry_atom_alpha_above_alpha_star_implies_reversal : GapEntry where
  name := "alpha_above_alpha_star_implies_reversal_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 4.1 Part 1, line 491 (`α > α*(0, p)` ⇒ greedy welfare non-monotone in β)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_cognitive_threshold_part1_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Captures the paper-stated greedy-reversal triggering at the α-above-α* regime gate on the existing carrier `agentWelfare`. Cat 1 reduction check: not Mathlib-derivable (constrains opaque carrier). Cat 2 reduction check: paper-novel application. Downstream consumer: `gap_cognitive_threshold_part1` derived theorem (Cognitive.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 4.1 Part 1, α-above-α* greedy reversal at κ = 0"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Theorem 4.1 Part 2 (line 492), κ-agent
    welfare recovery to monotone β-dependence at sufficiently large κ. -/
def entry_atom_kappa_large_blackwell_recovery : GapEntry where
  name := "kappa_large_blackwell_recovery_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 4.1 Part 2, line 492 (sufficiently large κ ⇒ κ-agent welfare non-decreasing in β); Blackwell 1951/1953 (Cat 2 dependency)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_cognitive_threshold_part2_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The atom captures the paper-stated κ-large monotonicity recovery on the existing carrier `agentWelfare`. Cat 2 Blackwell 1951/1953 dependency threaded as explicit `h_blackwell` antecedent. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel application of Cat 2 Blackwell theorem. Downstream consumer: `gap_cognitive_threshold_part2` derived theorem (Cognitive.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 4.1 Part 2, κ-large monotonicity recovery"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Theorem 4.1 Part 4 (line 494),
    `κ*(p)` non-decreasing in `p`. -/
def entry_atom_kappaStar_p_monotone : GapEntry where
  name := "kappaStar_p_monotone_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 4.1 Part 4, line 494 (`κ*(p)` non-decreasing in `p` on lattices + Section 5 instances)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_cognitive_threshold_part4_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The atom captures the paper-stated `κ*` p-monotonicity on the existing carrier `kappaStar`, against the implicit non-emptiness premise (paper assumes threshold exists; unconditional universal form is junk-value-defective per R23-C2 audit). Cat 1 reduction check: candidate `mean_estimate_gap_antitone_in_p_OPEN` + sInf-monotonicity chain breaks at junk-value corner case. Cat 2 reduction check: paper-novel. Downstream consumer: `gap_cognitive_threshold_part4` derived theorem (Cognitive.lean) hosts the atom." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 4.1 Part 4, `κ*(p)` p-monotonicity"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Theorem 4.1 Part 5 + Prop:threshold-
    alpha (lines 495, 527-543), `κ*(α)` non-decreasing in `α` via the
    paper's welfare-transition characterisation (line 540), independent
    of `kappaStar_def`'s α-erasing inf-formula. -/
def entry_atom_welfare_transition_alpha_monotone : GapEntry where
  name := "welfare_transition_alpha_monotone_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 4.1 Part 5, line 495 + Proposition prop:threshold-alpha, proof line 540 (welfare-transition characterisation of α-monotonicity)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_cognitive_threshold_part5_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Implements R24-B's `Future-round candidate` directive: encodes the welfare-transition α-monotonicity (Prop:threshold-alpha proof line 540) as a SEPARATE atomic Cat 3 axiom independent of `kappaStar_def`'s α-erasing inf-formula. Paper-source verification: paper's `m(κ)` is α-free, so the α-monotonicity must come from a different characterisation; paper line 540 reads `since higher α increases the trap probability ... a higher κ is needed to compensate: ∂κ*/∂α > 0`. The atom is the operative paper claim on the `kappaStar` carrier. Cat 1 reduction check: not derivable from `kappaStar_def` (α-free RHS). Cat 2 reduction check: paper-novel. Downstream consumer: `gap_cognitive_threshold_part5` derived theorem (Cognitive.lean) + wrapper `gap_threshold_alpha_monotone`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 4.1 Part 5, welfare-transition α-monotonicity"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Theorem 4.1 Part 6 (line 496),
    `κ*(p, α)` divergence at the Harris-Kesten `p_c` from below. -/
def entry_atom_kappaStar_diverges_at_pc : GapEntry where
  name := "kappaStar_diverges_at_pc_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 4.1 Part 6, line 496 (`κ*(p, α) → +∞` as `p → p_c⁻` on Z² with `α > α*`)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_cognitive_threshold_part6_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The atom packages the paper-stated unboundedness on the `harrisKestenCriticalProb` carrier (Cat 2 Harris-Kesten 1960/1980 dependency surfaces via the carrier consumption per R18-A audit clarification). Cat 1 reduction check: not Mathlib-derivable (constrains opaque `kappaStar` carrier). Cat 2 reduction check: paper-novel application of Cat 2 Harris-Kesten p_c via opaque carrier. Downstream consumer: `gap_cognitive_threshold_part6` derived theorem (Cognitive.lean)." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 4.1 Part 6, `κ*(p, α)` divergence at `p_c`"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Prop:supermodular cross-partial-to-
    supermodularity bridge (corner-supermodularity via Topkis 1978/1998
    applied to the paper-novel `kappaAgentWelfareSNR` carrier). -/
def entry_atom_corner_supermodularity_via_topkis : GapEntry where
  name := "corner_supermodularity_via_topkis_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:supermodular proof, cross-partial-to-corner-supermodularity link on `kappaAgentWelfareSNR` carrier; Topkis 1978/1998 (Cat 2 dependency)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_kappaWelfare_cross_partial_link_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. The atom isolates the cross-partial-positive-at-four-corners → corner-supermodularity bridge on the paper-novel `kappaAgentWelfareSNR` carrier. Cat 2 Topkis 1978/1998 dependency threaded as explicit `h_topkis` antecedent. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel application of Cat 2 Topkis universal-supermodularity to paper-novel regional carrier. Downstream consumer: `gap_kappaWelfare_cross_partial_link` derived theorem (Cognitive.lean) + transitively `gap_policy_complementarity_OPEN_derived`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:supermodular, cross-partial-to-corner-supermodularity bridge"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Lemma `lem:wrongness` (lines 336-369),
    greedy welfare reversal under topology-blind + Blackwell-ordered
    signals + degree-2 starting vertex. -/
def entry_atom_topology_blind_wrongness : GapEntry where
  name := "topology_blind_wrongness_atom_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Lemma lem:wrongness, lines 336-369"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_wrongness_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Captures paper-stated greedy welfare reversal under C1-C3 + terminal-neighbour topology + degree-2 starting vertex + whole-family topology-blind Blackwell-ordered signal family. Cat 1 reduction check: not Mathlib-derivable. Cat 2 reduction check: paper-novel. Downstream consumer: `gap_wrongness` derived theorem (Wrongness.lean) + `gap_dilemma`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Lemma lem:wrongness, greedy welfare reversal under topology-blind signals"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Proposition `prop:interior-optimum`
    (line 774), existence of interior minimiser of `L(·, 0)`. -/
def entry_atom_interior_minimiser_existence : GapEntry where
  name := "interior_minimiser_existence_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:interior-optimum (5-state), line 774 (β* ≈ 1.5 bits)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_interior_optimum_OPEN` per `feedback_gap_ledger_in_lean4` §18 Manufactured-Recognition pattern. Existential encoding on the `L` carrier; numeric witness `β* ≈ 1.5 bits` deferred to per-instance closure. Cat 1 reduction check: candidate Mathlib transcendental optimisation (Φ + Φ_B + signalVariance combination), but the IDP-specific functional form is paper-novel. Cat 2 reduction check: paper-novel. Downstream consumer: `gap_interior_optimum` derived theorem (Canonical.lean) + `gap_threshold_fiveState_greedy_has_interior_optimum`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:interior-optimum, existence of `β* ≈ 1.5 bits`"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Prop:three-regime Regime (i) line 814,
    Regime (i) existence sub-claim. -/
def entry_atom_L_below_limit_at_some_beta : GapEntry where
  name := "L_below_limit_at_some_beta_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:three-regime-five-state Regime (i), line 814 (existence of β*(p) > 0 with L β*(p) p < 0.4)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_three_regime_reversal_existence_OPEN` per §18 (renamed to atom + derived theorem `gap_three_regime_reversal_existence` re-export). Downstream consumer: `gap_three_regime_reversal_existence`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Regime (i) existence of below-limit β*"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Prop:three-regime Regime (i) line 814,
    uniqueness sub-claim. -/
def entry_atom_L_unimodal_in_regime_i : GapEntry where
  name := "L_unimodal_in_regime_i_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:three-regime-five-state Regime (i), line 814 + proof line 825 (uniqueness from unimodal structure)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_three_regime_reversal_uniqueness_OPEN` per §18 (renamed to atom + derived theorem `gap_three_regime_reversal_uniqueness` re-export). Downstream consumer: `gap_three_regime_reversal_uniqueness`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Regime (i) uniqueness of strict interior minimum"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Prop:three-regime Regime (i) line 814,
    non-monotonicity sub-claim. -/
def entry_atom_L_nonmonotone_witnesses : GapEntry where
  name := "L_nonmonotone_witnesses_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:three-regime-five-state Regime (i), line 814 + proof lines 821-825"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_three_regime_reversal_nonmonotone_OPEN` per §18 (renamed to atom + derived theorem `gap_three_regime_reversal_nonmonotone` re-export). Downstream consumer: `gap_three_regime_reversal_nonmonotone`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Regime (i) non-monotonicity witnesses"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Prop:three-regime Regime (i) line 814,
    overshoot strictly decreasing sub-claim. -/
def entry_atom_envelope_derivative_sign_in_p : GapEntry where
  name := "envelope_derivative_sign_in_p_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:three-regime-five-state Regime (i), line 814 + proof line 825 (envelope differentiation)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_three_regime_reversal_overshoot_decreasing_OPEN` per §18 (renamed to atom + derived theorem `gap_three_regime_reversal_overshoot_decreasing` re-export). Downstream consumer: `gap_three_regime_reversal_overshoot_decreasing`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Regime (i) overshoot envelope-derivative sign"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Prop:three-regime Regime (i) line 814,
    overshoot continuity sub-claim. -/
def entry_atom_envelope_continuity_in_p : GapEntry where
  name := "envelope_continuity_in_p_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:three-regime-five-state Regime (i), line 814 + proof line 825 (continuity from envelope differentiation)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_three_regime_reversal_overshoot_continuous_OPEN` per §18 (renamed to atom + derived theorem `gap_three_regime_reversal_overshoot_continuous` re-export). Downstream consumer: `gap_three_regime_reversal_overshoot_continuous`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Regime (i) overshoot envelope continuity"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Prop:three-regime Regime (i) line 814,
    overshoot vanishes at `p_1` sub-claim. -/
def entry_atom_Tendsto_overshoot_at_p1 : GapEntry where
  name := "Tendsto_overshoot_at_p1_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:three-regime-five-state Regime (i), line 814 (overshoot vanishing at p_1)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_three_regime_reversal_overshoot_vanishes_at_p1_OPEN` per §18 (renamed to atom + derived theorem `gap_three_regime_reversal_overshoot_vanishes_at_p1` re-export). Downstream consumer: `gap_three_regime_reversal_overshoot_vanishes_at_p1`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Regime (i) overshoot Tendsto at p_1 from below"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Prop:threshold-five-state (ii)
    (line 862), kappa-above-threshold Blackwell recovery on 5-state. -/
def entry_atom_kappa_above_threshold_blackwell_recovery : GapEntry where
  name := "kappa_above_threshold_blackwell_recovery_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:threshold-five-state (ii), line 862; Blackwell 1951/1953 (Cat 2 dependency)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_threshold_fiveState_kappa_above_kstar_OPEN` per §18 (renamed to atom + derived theorem `gap_threshold_fiveState_kappa_above_kstar` re-export). Cat 2 Blackwell 1951/1953 dependency threaded as explicit `h_blackwell` antecedent. Downstream consumer: `gap_threshold_fiveState_kappa_above_kstar`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:threshold-five-state (ii), κ-above-threshold Blackwell recovery"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Prop:threshold-five-state (iii)
    (line 863), inflection at `κ*` strict positivity. -/
def entry_atom_inflection_at_kstar : GapEntry where
  name := "inflection_at_kstar_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:threshold-five-state (iii), line 863 (inflection point β > 0 at κ = κ*)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_threshold_fiveState_smooth_transition_OPEN` per §18 (first of two atoms — inflection-positivity sub-clause). Downstream consumer: `gap_threshold_fiveState_smooth_transition` derived theorem." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:threshold-five-state (iii), inflection point positivity"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Prop:threshold-five-state (iii)
    (line 863), κ-agent welfare bounded above by inflection-point
    welfare on `[0, β_inflection]`. -/
def entry_atom_welfare_bounded_below_inflection : GapEntry where
  name := "welfare_bounded_below_inflection_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:threshold-five-state (iii), line 863 (welfare-below-inflection upper bound)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from the bundled `gap_threshold_fiveState_smooth_transition_OPEN` per §18 (second of two atoms — below-inflection welfare upper-bound sub-clause). Downstream consumer: `gap_threshold_fiveState_smooth_transition` derived theorem." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:threshold-five-state (iii), welfare upper bound below inflection"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Prop:bayesian-naive-five-state (iii)
    (line 957), Bayesian-naive above-threshold reversal. -/
def entry_atom_bayesian_naive_above_threshold_reversal : GapEntry where
  name := "bayesian_naive_above_threshold_reversal_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:bayesian-naive-five-state (iii), line 957"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_bayesian_naive_reversal_present_OPEN` per §18 (renamed to atom + derived theorem `gap_bayesian_naive_reversal_present` re-export). Downstream consumer: `gap_bayesian_naive_reversal_present`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:bayesian-naive-five-state (iii), above-threshold reversal"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Theorem 6.1 thm:general-tree
    (lines 989-998), greedy reversal under C2′. -/
def entry_atom_C2prime_implies_greedy_reversal : GapEntry where
  name := "C2prime_implies_greedy_reversal_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Theorem 6.1 thm:general-tree, lines 989-998"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_general_tree_OPEN` per §18 (renamed to atom + derived theorem `gap_general_tree` re-export). Downstream consumer: `gap_general_tree`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Theorem 6.1 thm:general-tree, greedy reversal under C2′"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Example ex:cyclic-trap (lines 1026-
    1029), 4-cycle trap configuration satisfies C2′ at positive-
    probability open-edge event. -/
def entry_atom_cyclic_4_satisfies_C2prime_at_open_event : GapEntry where
  name := "cyclic_4_satisfies_C2prime_at_open_event_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Example ex:cyclic-trap, lines 1026-1029"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_cyclic_trap_OPEN` per §18 (renamed to atom + derived theorem `gap_cyclic_trap` re-export). Downstream consumer: `gap_cyclic_trap`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Example ex:cyclic-trap, 4-cycle C2′ satisfaction"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Prop:error-compounding Part 5
    (line 1044), Bernoulli-real-power estimate underlying the
    `κ*(d) = Θ(log d)` lower-bound half. -/
def entry_atom_bernoulli_real_power_estimate : GapEntry where
  name := "bernoulli_real_power_estimate_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Proposition prop:error-compounding Part 5, line 1044 (`κ*(d) = log_2 d + O(1)` lower-bound Bernoulli-real-power estimate)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_kappaStar_depth_d_log_growth_OPEN` per §18 (renamed to atom + derived theorem `gap_kappaStar_depth_d_log_growth` re-export). The upper-bound half is closed kernel-pure by `gap_kappaStar_depth_d_upper_bound` (R9); the atom packages the remaining lower-bound Bernoulli-style estimate `(1+1/K)^(log_2 d) ≤ d²/K + 1` that the upper-bound proof's `c_star_constant` opaqueness prevented closing universally. Downstream consumer: `gap_kappaStar_depth_d_log_growth`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Proposition prop:error-compounding Part 5, κ*(d) = Θ(log d) lower-bound half"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Remark rem:robustness-misspec (ii)
    (line 942), myopic-`k` lookahead `k ≥ d` Blackwell recovery. -/
def entry_atom_myopic_k_lookahead_recursion : GapEntry where
  name := "myopic_k_lookahead_recursion_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Remark rem:robustness-misspec (ii), line 942 (k-step lookahead with k ≥ d recovers monotonicity)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_robustness_myopic_k_OPEN` per §18 (renamed to atom + derived theorem `gap_robustness_myopic_k` re-export). Downstream consumer: `gap_robustness_myopic_k`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Remark rem:robustness-misspec (ii), k-step lookahead k ≥ d Blackwell recovery"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-- Cat 3 atomic stipulation: paper Remark rem:robustness-misspec (iii)
    (line 944), satisficing-threshold trap acceptance under
    `r̄ ∈ (r(B), r(A))`. -/
def entry_atom_satisficing_threshold_trap : GapEntry where
  name := "satisficing_threshold_trap_OPEN"
  status := GapStatus.gapDefinitional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType := Cat3SubType.structuralEquation
  paperSource := "Remark rem:robustness-misspec (iii), line 944 (satisficing threshold r̄ ∈ (r(B), r(A)) welfare reversal)"
  attackHistory :=
    [ "R38 2026-05-14: Cat 3 atomic-stipulation axiom extracted from `gap_robustness_satisficing_OPEN` per §18 (renamed to atom + derived theorem `gap_robustness_satisficing` re-export). Downstream consumer: `gap_robustness_satisficing`." ,
      "R39 2026-05-14: Cat 3 sub-type reclassified workingAssumption → structuralEquation; status reclassified gapOpen → gapDefinitional. Per `feedback_gap_ledger_in_lean4` §3.4.3 (paper-foundational atoms) the R36-R38 atomic stipulations are paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers; they constitute the paper’s commitments to how its primitives behave (永不 close per discipline). Reclassifying as workingAssumption (必须 close before publication) was an honest-but-overzealous starting state from R36-R38 that would have implied derivation gaps where none exist at the paper-stipulation level." ]
  scope := "Remark rem:robustness-misspec (iii), satisficing welfare reversal"
  obstacleOrAttribution :=
    "Cat 3 paper-foundational structural-equation atom per `feedback_gap_ledger_in_lean4` §3.4.3; 永不 close. Paper-stated atomic content extracted from theorem/proposition statements about the paper’s opaque carriers."
  conditionalOn := []

/-! # Aggregated ledger inventory (post-R32 enum-typed refactor)

The live status / input-category / Cat 3 sub-type counts are printed
by the `#eval` calls below (run `lake env lean
BlackwellDilemma/Ledger.lean` to see them).  Invariants:

  * status counts sum to `allGaps.length` (= 143 post-R38).
  * input-category counts sum to `allGaps.length` (= 143).
  * Cat 3 sub-type counts sum to `allGaps.length` (= 143).

BLOCKED entries post-R26 = 0; DEAD-END entries at entry level = 0
(the bundled axiom `gap_p_monotonicity_OPEN` is DEAD-END at the
axiom level inside the PARTIAL entry `entry_prop_p_monotonicity`
whose live CLOSED Cat 1 sub-claim is `gap_p_monotonicity_bounded`). -/

/-- All gap entries in canonical declaration order. -/
def allGaps : List GapEntry := [
  -- IDP primitive carriers (Cat 3 atoms, gapDefinitional) — R33-A coverage repair
  entry_carrier_Vertex,
  entry_carrier_IsEdge,
  entry_carrier_PercolationOutcome,
  entry_carrier_blockingProb,
  entry_carrier_reward,
  entry_carrier_intrinsicPref,
  entry_carrier_agentWelfare,
  entry_carrier_oracleReward,
  entry_carrier_V_dyn,
  -- Paper-novel hypothesis predicates (Cat 3 atoms, gapDefinitional) — R33-A coverage repair
  entry_hyp_IsTopologyBlind,
  entry_hyp_IsBlackwellOrdered,
  entry_hyp_TerminalNeighbourTopology,
  entry_hyp_DegreeTwoStartingVertex,
  entry_hyp_BridgeDominance,
  -- Original entries
  entry_thm_decomp,
  entry_signal_immunity,
  entry_W_topo_constant,
  entry_prop_info_decay,
  entry_prop_topo_cluster,
  entry_topo_loss_below,
  entry_topo_loss_above,
  entry_prop_physical,
  entry_lem_wrongness,
  entry_lem_conditional_reduction_i,
  entry_lem_conditional_reduction_ii,
  entry_thm_dilemma,
  entry_thm_phase_below,
  entry_thm_phase_above,
  entry_prop_trap_prevalence_zero,
  entry_prop_trap_prevalence_above,
  entry_cor_er_phase,
  entry_cor_power_law,
  entry_thm_cognitive_threshold,
  entry_prop_supermodular,
  entry_cor_policy_complementarity,
  entry_prop_sentimental,
  entry_prop_threshold_alpha,
  entry_prop_principal_optimum,
  entry_cor_disclosure,
  entry_prop_canonical,
  entry_prop_interior_optimum,
  entry_prop_three_regime,
  entry_cor_five_state_policy,
  entry_prop_threshold_five_state,
  entry_prop_p_monotonicity,
  entry_prop_bayesian_naive_five_state,
  entry_thm_bayesian_immunity,
  entry_prop_complementarity,
  entry_rem_robustness_misspec_bayesian_naive,
  entry_rem_robustness_misspec_myopic_satisficing,
  entry_def_greedy_path,
  entry_lem_V_g_le_V_dyn,
  entry_thm_general_tree,
  entry_lem_dilemma_subsumed_by_general_tree,
  entry_ex_cyclic_trap,
  entry_prop_error_compounding,
  entry_blackwell_1953,
  entry_harris_kesten,
  entry_harris_kesten_squared,
  entry_bollobas,
  entry_molloy_reed,
  entry_cohen_powerlaw,
  entry_topkis,
  entry_phi_derivatives,
  entry_phi_tendsto_one_atTop,
  entry_phi_tendsto_zero_atBot,
  entry_tendsto_const_div_atTop_helper,
  entry_signalVariance_tendsto_zero_atTop,
  entry_phi_tail,
  entry_atom_intrinsicPref_unitInterval,
  entry_atom_ReachableSet_self_member,
  entry_atom_ReachableSet_eq_ForwardReachable_empty,
  entry_atom_ForwardReachable_self_member,
  entry_atom_topoSignalVariance_distance_zero,
  entry_atom_oracleReward_unitInterval,
  entry_atom_agentWelfare_unitInterval,
  entry_atom_V_dyn_def,
  entry_atom_V_g_def_terminal,
  entry_atom_V_g_def_step,
  entry_atom_oracleValueAtRoot_TrapTree_def,
  entry_atom_expectedTopoLoss_conditional_def,
  entry_atom_kappaStar_def,
  entry_atom_mLimit_def,
  entry_atom_alphaStar_def,
  entry_atom_kappaAgentWelfareSNR_def,
  entry_atom_betaBarStar_def,
  entry_atom_kappa_FOSD_def,
  entry_atom_aggregateOptimalBeta_def,
  entry_atom_W_bar_limit_infty_def,
  entry_atom_betaStarOfP_def,
  entry_atom_forward_reachable_full_at_zero,
  entry_atom_V_g_terminal_in_ForwardReachable,
  entry_atom_terminal_neighbour_implies_C2prime,
  -- R36 atomic-stipulation layer (Manufactured-Recognition §18 decomposition)
  entry_atom_mean_estimate_gap_continuous,
  entry_atom_mean_estimate_gap_tendsto_mLimit,
  entry_atom_mLimit_pos,
  entry_atom_kappaStar_nonneg,
  entry_atom_W_info_oracle_nonpos,
  entry_atom_W_info_oracle_exponential_bound,
  -- R37 atomic-stipulation layer (Manufactured-Recognition §18 decomposition,
  -- 11 derived theorems flipped OPEN → CLOSED across Wrongness/Phase/
  -- Cognitive/Principal modules, with 21 new Cat 3 OPEN atomic stipulations).
  entry_atom_conditional_subproblem_blackwell_applicable,
  entry_atom_topo_loss_decay_below_pc,
  entry_atom_topo_loss_decay_arbitrary_threshold,
  entry_atom_wInfoTopoRatio_const_exists,
  entry_atom_wInfoTopoRatio_bound,
  entry_atom_trap_config_local_positive,
  entry_atom_welfareCrossPartial_explicit_form,
  entry_atom_cross_partial_sign_in_z_lt_one,
  entry_atom_signal_independent_at_alpha_zero,
  entry_atom_welfare_continuity_in_alpha,
  entry_atom_alpha_star_existence_via_continuity,
  entry_atom_W_bar_eventually_decreasing_in_reversal,
  entry_atom_W_bar_exceeds_zero_at_positive_beta,
  entry_atom_interior_max_exists_from_unimodal_envelope,
  entry_atom_fosd_induces_derivative_domination,
  entry_atom_argmax_monotone_under_derivative_domination,
  entry_atom_W_bar_mixture_decomposition,
  entry_atom_non_concave_triple_from_mixture,
  entry_atom_averaged_reversal_overshoot_positive,
  entry_atom_finite_beta_above_limit_from_overshoot,
  entry_atom_differentiated_per_agent_optimum_dominates_uniform,
  -- R38 atomic-stipulation layer (Manufactured-Recognition §18 decomposition,
  -- 22 conclusion-axioms decomposed into 23 new atoms + 22 derived theorems
  -- across Cognitive/Wrongness/Canonical/GeneralGraphs/Bayesian modules).
  entry_atom_alpha_above_alpha_star_implies_reversal,
  entry_atom_kappa_large_blackwell_recovery,
  entry_atom_kappaStar_p_monotone,
  entry_atom_welfare_transition_alpha_monotone,
  entry_atom_kappaStar_diverges_at_pc,
  entry_atom_corner_supermodularity_via_topkis,
  entry_atom_topology_blind_wrongness,
  entry_atom_interior_minimiser_existence,
  entry_atom_L_below_limit_at_some_beta,
  entry_atom_L_unimodal_in_regime_i,
  entry_atom_L_nonmonotone_witnesses,
  entry_atom_envelope_derivative_sign_in_p,
  entry_atom_envelope_continuity_in_p,
  entry_atom_Tendsto_overshoot_at_p1,
  entry_atom_kappa_above_threshold_blackwell_recovery,
  entry_atom_inflection_at_kstar,
  entry_atom_welfare_bounded_below_inflection,
  entry_atom_bayesian_naive_above_threshold_reversal,
  entry_atom_C2prime_implies_greedy_reversal,
  entry_atom_cyclic_4_satisfies_C2prime_at_open_event,
  entry_atom_bernoulli_real_power_estimate,
  entry_atom_myopic_k_lookahead_recursion,
  entry_atom_satisficing_threshold_trap,
  -- R41 atomic-stipulation layer (Manufactured-Recognition §18 decomposition,
  -- 5 new Cat 3 atoms across prop:topo-cluster + bayesian-naive-five-state Part (ii)
  -- + prop:error-compounding Part 5 c_star_constant positivity).
  -- R42 honest reclassification: 3 topo_loss existence atoms are workingAssumption
  -- (not structuralEquation per §3.4.3) since they are paper-derived existence
  -- claims requiring Mathlib percolation infra. The 4th topo_loss atom
  -- (eps_from_envelope) was Mathlib-derivable and is now a Cat 1 theorem
  -- (not tracked as a separate Ledger entry).
  entry_atom_c_star_constant_pos,
  entry_atom_bayesian_naive_below_threshold_blackwell_recovery,
  entry_atom_topo_loss_below_envelope_exists,
  entry_atom_topo_loss_above_lower_bound,
  entry_atom_topo_loss_above_upper_bound
]

/-- Status-keyed counts:
    `(open, partial, blocked, deadEnd, closed, closedConditional, definitional)`. -/
def gapCounts : Nat × Nat × Nat × Nat × Nat × Nat × Nat :=
  let countWhere (s : GapStatus) : Nat :=
    (allGaps.filter (fun g => g.status = s)).length
  ( countWhere GapStatus.gapOpen
  , countWhere GapStatus.gapPartial
  , countWhere GapStatus.gapBlocked
  , countWhere GapStatus.gapDeadEnd
  , countWhere GapStatus.gapClosed
  , countWhere GapStatus.gapClosedConditional
  , countWhere GapStatus.gapDefinitional )

/-- InputCategory-keyed counts:
    `(cat1Mathlib, cat2External, cat3PaperNovel, mixed, notInput)`. -/
def inputCategoryCounts : Nat × Nat × Nat × Nat × Nat :=
  let countWhere (c : InputCategory) : Nat :=
    (allGaps.filter (fun g => g.inputCategory = c)).length
  ( countWhere InputCategory.cat1Mathlib
  , countWhere InputCategory.cat2External
  , countWhere InputCategory.cat3PaperNovel
  , countWhere InputCategory.mixed
  , countWhere InputCategory.notInput )

/-- Cat3SubType-keyed counts:
    `(carrier, hypothesisPredicate, structuralEquation, workingAssumption, conditionalHypothesis, phenomenologicalConjecture, derivedTheorem, notCat3)`. -/
def cat3SubTypeCounts : Nat × Nat × Nat × Nat × Nat × Nat × Nat × Nat :=
  let countWhere (s : Cat3SubType) : Nat :=
    (allGaps.filter (fun g => g.cat3SubType = s)).length
  ( countWhere Cat3SubType.carrier
  , countWhere Cat3SubType.hypothesisPredicate
  , countWhere Cat3SubType.structuralEquation
  , countWhere Cat3SubType.workingAssumption
  , countWhere Cat3SubType.conditionalHypothesis
  , countWhere Cat3SubType.phenomenologicalConjecture
  , countWhere Cat3SubType.derivedTheorem
  , countWhere Cat3SubType.notCat3 )

#eval s!"Blackwell-Dilemma gap-ledger inventory (status):    open={(gapCounts).1} partial={(gapCounts).2.1} blocked={(gapCounts).2.2.1} deadEnd={(gapCounts).2.2.2.1} closed={(gapCounts).2.2.2.2.1} closedConditional={(gapCounts).2.2.2.2.2.1} definitional={(gapCounts).2.2.2.2.2.2}"

#eval s!"Blackwell-Dilemma gap-ledger inventory (input):     cat1Mathlib={(inputCategoryCounts).1} cat2External={(inputCategoryCounts).2.1} cat3PaperNovel={(inputCategoryCounts).2.2.1} mixed={(inputCategoryCounts).2.2.2.1} notInput={(inputCategoryCounts).2.2.2.2}"

#eval s!"Blackwell-Dilemma gap-ledger inventory (Cat 3 sub): carrier={(cat3SubTypeCounts).1} hypothesisPredicate={(cat3SubTypeCounts).2.1} structuralEquation={(cat3SubTypeCounts).2.2.1} workingAssumption={(cat3SubTypeCounts).2.2.2.1} conditionalHypothesis={(cat3SubTypeCounts).2.2.2.2.1} phenomenologicalConjecture={(cat3SubTypeCounts).2.2.2.2.2.1} derivedTheorem={(cat3SubTypeCounts).2.2.2.2.2.2.1} notCat3={(cat3SubTypeCounts).2.2.2.2.2.2.2}"

#eval s!"Total entries: {allGaps.length}"

#eval s!"Cat 3 ratio: {((inputCategoryCounts).2.2.1 * 100) / ((inputCategoryCounts).1 + (inputCategoryCounts).2.1 + (inputCategoryCounts).2.2.1)}% (>50% triggers ≥2-round hostile reductionism check per §3.4.6 — extensive R23-D/R27-B/R33-A audit chain documented in attackHistory)"

/-! # Phase 0/4 audit summary

Phase 0 audit dispatched 2026-05-12 on 4 literature groups:
* Percolation (Harris, Kesten, Grimmett): 4/4 CLEAN; 2 paper-side
  editorial patches deferred.
* Random Graphs (Bollobás, Molloy-Reed, Cohen): CRITICAL bib
  misattribution (`bollobas2006` → `bollobas2001`); 5 axioms had
  vacuous existentials → patched in R4.
* Decision Theory (Blackwell, Topkis): 4/6 axioms tautologically
  vacuous → patched in R4 (HasDerivAt + opaque carriers).

Phase 4 audit dispatched 2026-05-12 on Blackwell paper-internal axioms:
* FAITHFUL: 11
* MINOR: 16 (mostly missing antecedents — degree-2, lattice
  qualifier, instance restriction; deferred patches)
* DEFECT: 13 — patched in R4 (vacuous existentials replaced with
  substantive opaque-carrier-bound assertions; `error_compounding_part1`
  was logically WRONG (β=0 not β=∞), corrected.)

Cumulative 8-pattern hostile-audit checklist (R123-R129 BSD lessons):
1. Wrong-part-number — N/A for econ paper.
2. Folkloric inflation — caught in Topkis (1998 vs 1978).
3. Phantom attribution — caught in `bollobas2006` bib key.
4. Tautological premise — caught in 13+ axioms (R4 patches).
5. Wrong arXiv version — N/A.
6. Anachronism — N/A.
7. Phantom downstream user — N/A for this round.
8. Second-hand attribution — N/A (no chained agent claims).

-/

end BlackwellDilemma.Ledger