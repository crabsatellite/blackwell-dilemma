# Mathlib Contribution Roadmap — BlackwellDilemma → Cat 1 only

**Date opened**: 2026-05-16 (R152)
**Strategic goal**: reduce all paper-novel Cat 3 entries to derivations from Cat 1 (Mathlib + Lean kernel) inputs only, by upstreaming the missing infrastructure to Mathlib4. Each upstream PR is broadly reusable beyond this paper.

## Current state (live counts)

```
Total ledger entries: 334
- gapClosed:       158
- gapDefinitional: 163  (Cat 3 §3.4.3 paper-foundational, 永不 close)
- gapOpen:         11   (9 Cat 2 classical + 2 Cat 3 lattice-percolation)
- gapPartial:      1    (Phi-tail bundle)
- gapDeadEnd:      1    (kappaStar_p_monotone def-marker, NOT axiom)
- gapBlocked:      0
Cat 3 sub-type:    workingAssumption=1 (also a marker, NOT axiom)
```

The 158 closed theorems are kernel-pure (`[propext, Classical.choice, Quot.sound]`) modulo paper-novel opaque carriers and structuralEquation atoms.

## Audit summary (R152, three parallel agents)

### Audit A — Mathlib coverage of 11 Cat 2 OPEN entries

| Bucket | Count | Entries |
|---|---|---|
| A: closeable NOW with existing Mathlib | 1 | `gap_iid_continuous_rank_symmetry_OPEN` (50–150 LoC via `IdentDistrib.prodMk` + `Measure.prod_swap` + `NoAtoms`) — note: actual ledger entry encodes a Cat 3 paper-novel implication, not the pure rank-symmetry; rank-symmetry can be added as a separate Cat 1 lemma but does not by itself close the OPEN |
| B: needs small Mathlib extension or in-repo derivation | 4 | David-Nagaraja eq2.14 (CDF-of-max + interval-integral), orderstats topo decomp (composition), Topkis supermodularity (special case via existing lattice + iteratedDeriv), Blackwell DPI (extend `bayesRisk_le_bayesRisk_comp` from Decision/Risk written 2025) |
| C: needs greenfield Mathlib infrastructure (multi-month) | 7 | Harris-Kesten, percolation θ(p), Grimmett 1999 §6.75 exponential decay, ER subcritical/supercritical, Molloy-Reed, Cohen power-law — all part of the percolation cluster |

### Audit B — Infrastructure/ PR-readiness (33 modules, 3,921 LOC)

| Bucket | Count | Action |
|---|---|---|
| A: ready NOW with editorial pass | 16 | Bundle into 9 PRs (sequence below) |
| B: needs cleanup (rename, deduplicate, generalise) | 13 | Triage against current Mathlib first; only PR genuine deltas |
| C: paper-specific (not for upstream) | 4 | `FiveStateRewards`, `FiveStateVDyn`, `MLimitDifferenceConcrete`, `Roadmap` — keep in repo, never PR |

### Audit C — Lattice + bond percolation Mathlib roadmap (6 phases)

| Phase | Content | Effort | Acceptance |
|---|---|---|---|
| 1 | Z^d integer lattice as `SimpleGraph` | small (8–10h) | high |
| 2 | Bond percolation as product Bernoulli measure | medium (30–45h) | high |
| 3 | FKG inequality for percolation (finite + infinite) | medium (25–35h) | high (finite) / medium (infinite) |
| 4 | Harris–Kesten theorem (`p_c(ℤ²) = 1/2`) | xl (250–400h) | high in principle, slow review |
| 5 | Grimmett 1999 §6.75 exponential decay (subcritical) | large (60–100h) | high |
| 6 | Erdős–Rényi phase transition (separate track) | large–xl (80–200h) | high |

**Total to Cat-1 closure of THIS paper's lattice gaps**: Phases 1 + 2a/b/c + 3a → 100–150h (excluding Mathlib review iteration).

**Full ambition (Phases 1–6, all OPEN entries closed)**: 600–900h.

## Master PR sequence (priority-ordered)

### Quick wins (under 50h each — can land in weeks)

**PR-1** — `Mathlib/Combinatorics/SimpleGraph/IntegerLattice.lean` ✅ **STARTED 2026-05-16**
- Stub already in `BlackwellDilemma/Infrastructure/IntegerLattice.lean` (builds GREEN)
- Defines `integerLatticeGraph (d : ℕ) : SimpleGraph (Fin d → ℤ)` + `Z2LatticeGraph`
- Adjacency = ℓ¹-distance equals one
- Basic lemmas: `l1Dist_self`, `l1Dist_symm`, `l1Dist_nonneg`, `integerLatticeGraph_adj_iff`
- Effort to PR-prep: 8h (add `degree_eq_two_mul_d`, `LocallyFinite`, `Preconnected`, ~15 API lemmas + Mathlib-style docstring polish)
- Acceptance: high; matches existing patterns (`Hasse`, `Circulant`, `UnitDistance/Basic`)

**PR-2** — `Mathlib/Topology/Order/Compact.lean` extension (independent of PR-1)
- From `BlackwellDilemma/Infrastructure/EVTBoundedDecreasing.lean` + `ArgmaxExistence.lean`
- Generalises EVT to `[a, ∞)` with eventually-decreasing dominance
- Effort: small (~10h after dedup against existing Mathlib)
- Acceptance: high

**PR-3** — `Mathlib/Combinatorics/SimpleGraph/Connectivity/Reachable.lean` extension
- From `BlackwellDilemma/Infrastructure/SimpleGraphReachable.lean`
- Adds Finset-packaging of forward-reachable component
- Effort: small (~6h)
- Acceptance: high

**PR-4** — `Mathlib/Algebra/Order/BigOperators/DiscreteTail.lean` (drop "Mills" name)
- From `BlackwellDilemma/Infrastructure/MillsRatioTail.lean` (rename — content is generic discrete tail bounds, NOT Mills's Gaussian ratio)
- Effort: small (~4h, mostly rename + dedup check)
- Acceptance: high

**PR-5** — `Mathlib/Algebra/Order/BigOperators/MonoLift.lean`
- From `BlackwellDilemma/Infrastructure/{BlackwellConditional, MonotoneIntegralFOSD, AbstractKernelMonotonicity, FOSDLiftedExpectation}.lean`
- Rename `BlackwellConditional` (generic Finset-sum monotonicity, no Blackwell theory)
- Effort: small (~12h after dedup)
- Acceptance: high

### Medium tier (50–100h each — 1–3 months part-time)

**PR-6** — `Mathlib/Order/Supermodular/{Basic,Comparative,Calculus}.lean` (foundation series)
- Pre-req: lattice-generalise from `ℝ → ℝ → ℝ` to `α → β → γ` over arbitrary lattices
- From `BlackwellDilemma/Infrastructure/{TopkisCrossPartial, SupermodularExtended, FOSDDerivativeChain, ArgmaxMonotone, DifferenceQuotientAlgebra, CalculusTopkis}.lean`
- Effort: medium (~50h for generalisation + Topkis equivalence theorem)
- Acceptance: high (Topkis is on Mathlib 1000.yaml as Q7824894 unformalised)
- **Closes `gap_topkis_supermodularity_OPEN`** (paper-special-case via in-repo specialisation)

**PR-7** — `Mathlib/Probability/Bayesian/GaussianConjugatePrior.lean`
- From `BlackwellDilemma/Infrastructure/GaussianPosterior.lean`
- Adds posterior variance + measure-theoretic statement using Mathlib's `MeasureTheory.Gaussian` if available
- Effort: medium (~30h)
- Acceptance: high

**PR-8** — `Mathlib/Probability/Bernoulli/FiniteProduct.lean`
- From `BlackwellDilemma/Infrastructure/{BernoulliProductFinite, PercolationExpectation}.lean`
- Reconciles with Mathlib's `ProbabilityTheory.bernoulli`
- Effort: medium (~20h)
- Acceptance: high; foundational for Phase 2 below

### Large tier (100–500h — multi-quarter)

**PR-9 / Phase 2 series** — `Mathlib/Probability/Percolation/{Basic,Cluster,Coupling,FKG}.lean`
- Pre-req: PR-1 (lattice graphs) + PR-8 (Bernoulli product) merged
- 3 sub-PRs:
  - 2a: `BondPercolation` definition + `IsOpen` + edge independence (~20h)
  - 2b: `Cluster` + measurability of cluster-size and infinite-cluster events (~25h)
  - 2c: Strassen monotone coupling + `percolationProbability` monotonicity (~15h)
- Effort: medium-large (~60h total)
- Acceptance: high (Mathlib explicitly waiting per `BinomialRandomGraph/README` stub)
- **Closes `trapLocalConfigProb_pos_and_le` and `restrictedExpectation_eq_localConfigProb`** Cat 3 OPEN entries
- **Closes `gap_cognitive_threshold_part4_lattice` DEAD-END marker** (κ* monotonicity in p)

**PR-10** — `Mathlib/Probability/Independence/FKG.lean` + `Mathlib/Probability/Percolation/FKG.lean`
- Specialise existing `Combinatorics/SetFamily/FourFunctions` (Ahlswede-Daykin) to Bernoulli product
- 2 sub-PRs (finite + infinite via `Probability/InfinitePi`)
- Effort: medium (~25h)
- Acceptance: high (textbook Mathlib target)

### Extra-large tier (500h+ — multi-year, team effort)

**PR-11 / Phase 4 series** — `Mathlib/Probability/Percolation/{Critical, Russo, RSW, HarrisKesten}.lean`
- The Harris-Kesten theorem (`p_c(ℤ²) = 1/2`) — Mathlib's prime-number-theorem analogue in scope
- Sub-PRs: planar duality, RSW box-crossing, Harris half, Russo's formula, BKKKL influence inequality, sharp threshold + Kesten half
- Effort: xl (~250–400h)
- Recommendation: 2–3 person team; expect 12–24 months
- **Closes `gap_harris_kesten_OPEN`, `gap_percolation_probability_OPEN` (downstream)**

**PR-12 / Phase 5** — `Mathlib/Probability/Percolation/SubcriticalDecay.lean`
- Duminil-Copin–Tassion 2016 modern proof of subcritical exponential decay
- Effort: large (~60–100h); needs Russo from Phase 4 framework but not full Harris-Kesten
- **Closes `gap_grimmett_exponential_decay_OPEN`**

**PR-13 / Phase 6 series** — `Mathlib/Probability/Combinatorics/BinomialRandomGraph/{GiantComponent, MolloyReed, ConfigurationModel}.lean`
- Erdős–Rényi phase transition + Molloy-Reed criterion + Cohen power-law thinning
- 4 sub-PRs (definition, subcritical, supercritical, Molloy-Reed, Cohen)
- Effort: large–xl (~150–250h)
- Different reviewer pool than percolation, can run in parallel
- **Closes `gap_er_subcritical_OPEN`, `gap_er_supercritical_OPEN`, `gap_molloy_reed_OPEN`, `gap_cohen_powerlaw_OPEN`**

## Recommended landing order (minimise blocking)

```
Phase A (quick wins, ~6 weeks part-time):
  PR-1 (Z² lattice)       ✅ STARTED 2026-05-16
  PR-2 (EVT extension)
  PR-3 (SimpleGraph reachable)
  PR-4 (discrete tail)
  PR-5 (BigOperators MonoLift)

Phase B (medium, ~3 months part-time):
  PR-6 (Supermodular series)  → closes Cat 2 Topkis OPEN
  PR-7 (Gaussian posterior)
  PR-8 (Bernoulli product)    ← prerequisite for PR-9

Phase C (paper's substantive Cat 3 closures, ~3 months part-time):
  PR-9 (Percolation Basic+Cluster+Coupling)  → closes 2 Cat 3 OPENs + DEAD-END marker
  PR-10 (FKG)                                 → high reusability for Phase 6 too

Phase D (multi-year, team or back-burner):
  PR-11 (Harris-Kesten series)  → closes 2 more Cat 2 OPENs
  PR-12 (subcritical decay)     → closes 1 more Cat 2 OPEN
  PR-13 (Erdős-Rényi series)    → closes 4 more Cat 2 OPENs (independent track)
```

**End-state at Phase C completion**: Lean v2.0 of BlackwellDilemma can claim Cat 1 only for ALL paper-stated theorems (the 7 percolation/random-graph Cat 2 entries become Mathlib-cited classical results, equivalent to citing Blackwell 1953 in a paper without re-proving it).

**End-state at Phase D completion**: Cat 1 only across the entire ledger; nothing remains in `gapOpen` or as Cat 2 axiom.

## Strategic value beyond this paper

Each PR contributes broadly reusable Mathlib infrastructure:

- **PR-1 (lattice)** — used by stat-mech, combinatorics, computer-science (cellular automata)
- **PR-6 (supermodularity)** — used by economics (Milgrom-Shannon), game theory (Vives), combinatorial optimization
- **PR-8 + PR-9 (percolation)** — used by stat-mech, probability theory, network science
- **PR-10 (FKG)** — used by Ising model, percolation, random-cluster representation
- **PR-11 (Harris-Kesten)** — Mathlib 1000.yaml target; high-prestige naming-rights anchor
- **PR-13 (Erdős-Rényi)** — used by graph theory, network science, computer science

## Cross-paper applicability (per OE memory)

These Mathlib contributions also serve other OE papers:
- `project_civilizational_capability_sinks` — graph fragmentation analysis
- `project_audit_framework_program` — V×P×S framework with network components
- `project_three_body_topology` — resilience-graph chapter
- `project_influence_decomposition_paper` — bipartite + network structure
- Future Millennium-target Lean projects (BSD, Hodge, Riemann, p-vs-np, Yang-Mills, Navier-Stokes) — all benefit from supermodularity, EVT, big-operator infrastructure

## Authorship leverage

Per `feedback_author_title_convention`: Mathlib commits are Tier A pure-mathematics → credit `Alex Li` only (no Accenture title). Accepted Mathlib PRs covering Harris-Kesten or Erdős-Rényi giant-component would establish naming-rights anchors well beyond the BlackwellDilemma paper, supporting v6 methodology-expert positioning.

## Immediate next actions (R152+ session work)

1. ✅ R152 complete: Phase 1 stub (`IntegerLattice.lean`) + this roadmap
2. Next session: PR-1 polish (add `LocallyFinite`, `Preconnected`, degree formula, ~15 API lemmas) → fork Mathlib4, draft PR
3. Session +2: PR-2/3/4 polish + draft (independent quick wins)
4. Session +3: PR-5 + start Mathlib Zulip thread for Supermodular series RFC
5. Session +4: PR-6 (Supermodular) — substantive math work begins

## Tracking

Each PR opened → tag with status in this file. Live ledger counts re-run via:
```bash
cd lean4 && lake env lean BlackwellDilemma/Ledger.lean | grep -E "(inventory|Total)"
```

When a Cat 2 OPEN entry is closed (Mathlib PR merged + downstream substitution applied), update `Ledger.lean` entry to `gapClosed` + cite the Mathlib commit hash.
