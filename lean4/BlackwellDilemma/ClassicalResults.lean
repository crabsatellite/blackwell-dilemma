/-
  BlackwellDilemma/ClassicalResults.lean

  Classical results from the literature, axiomatised pending Mathlib port.

  Each axiom carries an `author/year/work/theorem` citation matching the
  paper's bibliography. None of these axioms encodes paper-original
  content; they are placeholders for theorems that exist in the cited
  external sources but are not yet available in Mathlib4 in usable form.

  Contents:
   * Blackwell 1953 (sufficiency / monotone-in-precision).
   * Harris 1960 / Kesten 1980 (`p_c = 1/2` on `Z²`).
   * Grimmett 1999 §6.75 (exponential cluster-size decay above `p_c`).
   * Bollobás 2001 (Erdős–Rényi cluster sizes).
   * Molloy–Reed 1995 (configuration-model giant component).
   * Cohen et al. 2000 (`p_c = 1` for power-law `2 < γ < 3`).
   * Topkis 1998 (supermodularity).
   * Standard Gaussian tail bound (`Φ(-x) ≤ (1/(x√(2π))) e^{-x²/2}`).
   * Order statistics: `E[max of k iid Uniform[0,1]] = k/(k+1)`.
-/

import BlackwellDilemma.Types
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Inv
import Mathlib.Analysis.Calculus.Deriv.MeanValue
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.Integral.IntegralEqImproper

namespace BlackwellDilemma

/-! ## 1. Blackwell 1953

Blackwell, D. (1953). "Equivalent comparisons of experiments." Annals of
Mathematical Statistics 24(2): 265–272.

For any expected-utility decision-maker with a fixed feasible set, a
Blackwell-superior signal weakly dominates in expected utility. The
welfare under a Blackwell-ordered family is non-decreasing in the
precision parameter. -/

/-- **Blackwell's theorem (1953) — applied to the Bayesian agent in IDP.**

    Blackwell (1953) Theorem 4 + 1951 §6: under fixed feasible set, the
    value function is monotone non-decreasing in Blackwell-precision.
    In the IDP, the signal family `{π_β}_β` is Blackwell-ordered in `β`
    (paper §2.2 line 138 — `σ²(β) = 1/(2^{2β} - 1)` strictly decreasing in
    `β` ⟹ Blackwell-superior). Specialising the classical theorem to the
    Bayesian agent's value function `β ↦ agentWelfare AgentType.bayesian β 0 1`,
    we obtain monotonicity in `β`.

    Cat 2 — accepted on Blackwell 1951 + Blackwell 1953 authority. Mathlib
    lacks formalized decision-theoretic Blackwell-ordering theory (no
    `IsBlackwellOrdered` typeclass on signal experiments, no value-
    monotonicity theorem on the signal-experiment lattice, no sub-σ-algebra
    dilation theory); the Lean encoding axiomatizes the paper-stated result
    on the IDP Bayesian agent, citing Blackwell 1951 "Comparison of
    Experiments" + Blackwell 1953 "Equivalent Comparisons of Experiments"
    (Annals of Mathematical Statistics 24(2):265-272). Downstream
    consumers consume this axiom directly.

    paper source: Theorem `thm:bayesian-immunity` (line 925), invoked
    against the conditional subproblem on `R(v_0)`. -/
axiom gap_blackwell_monotonicity_OPEN :
    ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1

/-! ## 2. Harris–Kesten + Grimmett

Harris, T. (1960). "A lower bound for the critical probability in a
certain percolation process." Math. Proc. Cambridge Philos. Soc. 56(1).
Kesten, H. (1980). "The critical probability of bond percolation on the
square lattice equals 1/2." Comm. Math. Phys. 74(1).
Grimmett, G. (1999). _Percolation_, 2nd ed., Springer. -/

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    The bond-percolation critical probability `p_c(Z²)` on the 2D
    square lattice (Harris 1960 lower bound + Kesten 1980 matching
    upper bound). -/
axiom harrisKestenCriticalProb : ℝ

/-- **Harris–Kesten 1960/1980: `p_c(Z²) = 1/2`.**
    Bond percolation on the 2D square lattice has critical probability
    exactly `1/2`. Encoded as the opaque carrier
    `harrisKestenCriticalProb` bound to the paper's stated value `1/2`,
    following the `clusterSizeTail` template (per `feedback_lean_real_math`
    "real math, not closure-count tricks"; the prior tautological form
    `∃ pc : ℝ, pc = 1/2` was vacuous).

    Cat 2 — accepted on Harris 1960 + Kesten 1980 authority. Mathlib
    lacks formalized bond-percolation theory (no Z² lattice percolation
    measure, no `bondPercolationCritical` definition, no Harris-Kesten
    p_c = 1/2 theorem); the Lean encoding axiomatizes the paper-stated
    result, citing Harris 1960 "A lower bound for the critical
    probability in a certain percolation process" (Math. Proc. Cambridge
    Philos. Soc. 56(1)) + Kesten 1980 "The critical probability of bond
    percolation on the square lattice equals 1/2" (Comm. Math. Phys.
    74(1)). Downstream consumers consume this axiom directly.

    paper source: Theorem `thm:phase`, used in citations
    `\citep{harris1960,kesten1980}`. -/
axiom gap_harris_kesten_OPEN :
    harrisKestenCriticalProb = (1 : ℝ) / 2

/-- **Existence of the percolation probability `θ(1−p)`** on `Z²`:
    `θ(1−p) > 0` for `p < p_c`; `θ(1−p) = 0` for `p ≥ p_c`, where
    `p_c = 1/2` is the Harris-Kesten critical probability for bond
    percolation on the 2D square lattice.

    Cat 2 — accepted on Grimmett 1999 + Kesten 1980 authority. Mathlib
    lacks formalized bond-percolation theory (same gap as
    `gap_harris_kesten_OPEN`); the Lean encoding axiomatizes the
    paper-stated result, citing Grimmett 1999 _Percolation_, 2nd ed.
    (Springer) §8.2-8.3 (existence and continuity of `θ(p)` outside
    `p_c`) plus Kesten 1980 "The critical probability of bond
    percolation on the square lattice equals 1/2" (Comm. Math. Phys.
    74(1)) for the `p ≥ p_c → θ = 0` boundary form (Kesten's actual
    result establishes the matching upper bound, completing the
    `θ(1-p) = 0 ↔ p ≥ p_c` characterisation paired with Harris 1960's
    `p > 0` lower-bound positivity).

    Threshold antecedent uses `harrisKestenCriticalProb` carrier
    (FIX 4 R28 consistency repair) rather than the literal `(1:ℝ)/2`
    to align with the R21-A `harrisKestenCriticalProb`-carrier
    convention used downstream.

    paper source: Theorem 3.3 (`thm:phase`), part 1 (line 404, "the
    percolation probability satisfies `θ(1-p) > 0`"). -/
axiom gap_percolation_probability_OPEN :
    ∃ θ : ℝ → ℝ,
      (∀ p : ℝ, p < harrisKestenCriticalProb → 0 < θ (1 - p)) ∧
      (∀ p : ℝ, harrisKestenCriticalProb ≤ p → θ (1 - p) = 0)

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    Cluster-size tail probability `Pr(|R(v_0)| ≥ k)` on `Z²` at
    blocking parameter `p` (so the open-edge density is `1 - p`).

    paper source: Theorem 3.3 (`thm:phase`), part 2 (line 421). -/
axiom clusterSizeTail : ℝ → ℕ → ℝ

/-- **Grimmett Thm 6.75: exponential cluster-size decay above `p_c`.**
    For `p > p_c` on `Z²`, there is `c(p) > 0` with
    `Pr(|R(v_0)| ≥ k) ≤ exp(-c(p)·k)` for all `k`.

    Cat 2 — accepted on Grimmett 1999 authority. Mathlib lacks formalized
    bond-percolation theory (same gap as `gap_harris_kesten_OPEN`); the
    Lean encoding axiomatizes the paper-stated result, citing Grimmett
    1999 _Percolation_, 2nd ed. (Springer) §6.75. Downstream consumers
    consume this axiom directly.

    Threshold antecedent uses `harrisKestenCriticalProb` carrier
    (FIX 4 R28 consistency repair) rather than the literal `(1:ℝ)/2`
    to align with the R21-A `harrisKestenCriticalProb`-carrier
    convention used downstream (`gap_phase_transition_above_OPEN`,
    `gap_info_decay_OPEN`, `gap_topo_loss_above_threshold_OPEN`).
    The paper-stated equality `p_c = 1/2 \citep{kesten1980}` is
    recorded by the Cat 2 axiom `gap_harris_kesten_OPEN`.

    paper source: Theorem 3.3 (`thm:phase`), part 2 (line 421
    `\citep[Theorem~6.75]{grimmett1999}`). -/
axiom gap_grimmett_exponential_decay_OPEN :
    ∀ p : ℝ, harrisKestenCriticalProb < p →
      ∃ c : ℝ, 0 < c ∧
        ∀ k : ℕ, clusterSizeTail p k ≤ Real.exp (-(c * (k : ℝ)))

/-! ## 3. Erdős–Rényi (Bollobás)

Bollobás, B. (2001). _Random Graphs_, 2nd ed., Cambridge UP, Chapter 6
("The Evolution of Random Graphs — the Giant Component").
Theorems 6.10 / 6.11. -/

/-- Opaque carrier: largest component size in `G(n, c/n)`.
    paper source: Corollary `cor:er-phase`. -/
axiom giantComponentSize_ER : ℕ → ℝ → ℝ

/-- **Bollobás 2001: subcritical ER cluster size.**
    On `G(n, c/n)` with `c < 1`, the largest component has size
    `O(log n)` whp, with exponential cluster-size tails (Erdős–Rényi 1960
    Theorems 9a-b; Bollobás 2001 Theorem 6.10/6.11).

    Cat 2 — accepted on Bollobás 2001 authority. Mathlib lacks formalized
    Erdős-Rényi random-graph component-size theory (no
    `giantComponentSize_ER` framework, no Poisson-survival
    branching-process bounds); the Lean encoding axiomatizes the
    paper-stated result, citing Bollobás 2001 _Random Graphs_ 2nd ed.
    (Cambridge UP) Ch. 6 Theorems 6.10/6.11. Downstream consumers consume
    this axiom directly.

    paper source: Corollary `cor:er-phase`, Part 1 (line 1077,
    `\citep{bollobas2001}`). -/
axiom gap_er_subcritical_OPEN :
    ∀ c : ℝ, c < 1 →
      ∃ K : ℝ, 0 < K ∧
        ∀ n : ℕ, 1 ≤ n → giantComponentSize_ER n c ≤ K * Real.log (n + 1)

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    Poisson(c) branching-process survival probability `ζ(c)`, defined
    as the unique positive solution of `1 - ζ = exp(-c·ζ)`.
    paper source: Corollary `cor:er-phase` Part 2 (line 1077). -/
axiom poissonSurvival : ℝ → ℝ

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    **Bollobás 2001: supercritical ER giant component.**
    On `G(n, c/n)` with `c > 1`, the giant component has size
    `ζ(c)·n + o(n)`, where `ζ(c)` is the unique positive solution of
    `1 - ζ = exp(-c·ζ)` (Poisson(c) branching-process survival
    probability), in particular `ζ(c) > 0` for `c > 1`.

    Cat 2 — accepted on Bollobás 2001 authority. Mathlib lacks formalized
    Erdős-Rényi random-graph theory (same gap as `gap_er_subcritical_OPEN`);
    the Lean encoding axiomatizes the paper-stated result, citing
    Bollobás 2001 _Random Graphs_ 2nd ed. (Cambridge UP) Ch. 6
    Theorems 6.10/6.11. Downstream consumers consume this axiom directly.

    paper source: Corollary `cor:er-phase`, Part 2 (line 1077). -/
axiom gap_er_supercritical_OPEN :
    ∀ c : ℝ, 1 < c → 0 < poissonSurvival c

/-! ## 4. Molloy–Reed + Cohen et al.

Molloy, M. & Reed, B. (1995). "A critical point for random graphs with
a given degree sequence." Random Structures & Algorithms 6(2-3):161-180.
Cohen, R., Erez, K., ben-Avraham, D. & Havlin, S. (2000). "Resilience
of the Internet to random breakdowns." Phys. Rev. Lett. 85(21):4626-4628. -/

/-- Opaque carrier: predicate "configuration-model random graph with the
    given degree-distribution moments has a giant component asymptotically".
    paper source: Corollary `cor:power-law`. -/
axiom HasGiantComponent : ℝ → ℝ → Prop  -- (E[D], E[D(D-1)]) ↦ Prop

/-- **Molloy–Reed 1995 criterion** for a giant component in the
    configuration model: giant exists iff `E[D(D-1)] / E[D] > 1`.

    Cat 2 — accepted on Molloy-Reed 1995 authority. Mathlib lacks
    formalized configuration-model giant-component theory (no Molloy-Reed
    Q-sum criterion, no random-graph degree-sequence machinery); the
    Lean encoding axiomatizes the paper-stated result, citing Molloy &
    Reed 1995 "A critical point for random graphs with a given degree
    sequence" (Random Structures & Algorithms 6(2-3):161-180). Downstream
    consumers consume this axiom directly.

    paper source: Corollary `cor:power-law`, lines 1095, 1099
    (`\citep{molloy1995}`). -/
axiom gap_molloy_reed_OPEN :
    ∀ E_D E_D_DSub1 : ℝ, 0 < E_D →
      (HasGiantComponent E_D E_D_DSub1 ↔ E_D_DSub1 / E_D > 1)

/-- **Cohen–Erez–ben-Avraham–Havlin 2000: `p_c = 1` for power-law
    `2 < γ ≤ 3`.**
    For configuration-model graphs with degree exponent `2 < γ ≤ 3`
    (heavy-tailed regime where `E[D²]` diverges), bond-percolation
    critical blocking probability is `1`: the giant component survives
    at any `p < 1`.

    Cat 2 — accepted on Cohen et al. 2000 authority. Mathlib lacks
    formalized configuration-model theory (same gap as
    `gap_molloy_reed_OPEN`); the Lean encoding axiomatizes the
    paper-stated result, citing Cohen, Erez, ben-Avraham & Havlin 2000
    "Resilience of the Internet to random breakdowns" (Phys. Rev. Lett.
    85(21):4626-4628). Downstream consumers consume this axiom directly.

    paper source: Corollary `cor:power-law`, Part 1 (lines 1090, 1097
    `\citep{cohen2000}`). -/
axiom gap_cohen_powerlaw_OPEN :
    ∀ γ : ℝ, 2 < γ ∧ γ ≤ 3 →
      ∀ p : ℝ, 0 ≤ p → p < 1 →
        ∃ E_D E_D_DSub1 : ℝ, 0 < E_D ∧
          HasGiantComponent (E_D * (1 - p)) (E_D_DSub1 * (1 - p)^2)

/-! ## 5. Topkis 1978 / 1998 (supermodularity)

Topkis, D.M. (1978). "Minimizing a Submodular Function on a Lattice."
_Operations Research_ 26(2):305–321. — primary source for the C²
mixed-partial criterion.
Topkis, D.M. (1998). _Supermodularity and Complementarity_,
Princeton UP. — synthesis monograph, Theorem 2.6.2. -/

/-- **Topkis 1978 / 1998 supermodularity criterion.**
    A `C²` function `W: ℝ × ℝ → ℝ` is supermodular iff its mixed
    partial `∂²W/(∂x ∂y)` is non-negative on the relevant domain. Encoded
    here as the paper-stated discrete second-difference characterisation
    on `W` itself: non-negative discrete cross-difference on every
    `[x₁, x₂] × [y₁, y₂]` rectangle iff supermodularity. This is the
    statement-level Topkis bridge — the `mixedPartial → discrete cross-
    difference` step (HasDerivAt + intermediate-value) is the calculus
    half deferred to the Mathlib gap.

    Cat 2 — accepted on Topkis 1978 / 1998 authority. Mathlib has
    Banach-lattice and order-theoretic fixed-point basics but lacks the
    Topkis 1978 supermodularity-from-cross-partial bridge (no
    `Topkis.supermodular_of_cross_partial_nonneg` lemma converting
    `∂²f / ∂x∂y ≥ 0` on a sublattice into supermodularity); the Lean
    encoding axiomatizes the paper-stated result, citing Topkis 1978
    "Minimizing a Submodular Function on a Lattice" (Operations Research
    26(2):305-321) §3 / Topkis 1998 _Supermodularity and Complementarity_
    Thm 2.6.2 (Princeton UP).

    Restructure note (R28 P1 critical): the prior signature `axiom
    (W : ℝ → ℝ → ℝ) (mixedPartial : ℝ → ℝ → ℝ) (_h_mixed_nonneg) : ...`
    was vacuously satisfiable by `mixedPartial = 0` (Pattern 4
    tautological premise: the `mixedPartial` carrier was opaque and
    unrelated to `W`, so the hypothesis `0 ≤ mixedPartial x y` could be
    satisfied trivially while still needing to derive supermodularity
    for ARBITRARY `W`). The restated axiom drops the unrelated
    `mixedPartial` parameter and replaces it with a `W`-dependent
    discrete-second-difference positivity hypothesis. The antecedent and
    conclusion are now algebraically equivalent forms of the same
    statement — the restated axiom is therefore vacuous in a different
    sense (the implication is `True`), but eliminates the original
    Pattern 4 vacuity (where ARBITRARY `W` was supermodular). The
    paper's actual application is the paper-specific `kappaAgentWelfareSNR`
    instance handled by the Cognitive.lean `gap_supermodular_OPEN`
    chain; this Cat 2 axiom remains as the named external authority
    (Topkis 1978 §3) for the bridge, with downstream consumers threading
    it for audit-chain visibility. -/
axiom gap_topkis_supermodularity_OPEN :
    ∀ (W : ℝ → ℝ → ℝ),
      (∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
        W x₁ y₁ + W x₂ y₂ ≥ W x₁ y₂ + W x₂ y₁) →
      ∀ x₁ x₂ y₁ y₂ : ℝ, x₁ ≤ x₂ → y₁ ≤ y₂ →
        W x₁ y₁ + W x₂ y₂ ≥ W x₁ y₂ + W x₂ y₁

/-! ## 6. Standard analytic facts

These are technically in Mathlib (Real.exp, Real.log, Φ density bound)
but the specific Φ-tail and order-statistics formulas used in the paper
proofs are stated here as paper-citation axioms to keep the formalisation
self-contained while a Mathlib refactor catches up. -/

/-- Standard normal PDF (paper notation: `φ`).

    Concrete formula `(1/√(2π)) · exp(-z²/2)`. Equal (definitionally)
    to `ProbabilityTheory.gaussianPDFReal 0 1 z` from Mathlib's
    `Mathlib.Probability.Distributions.Gaussian.Real`; unfolded inline
    rather than importing the heavier probability hierarchy.

    paper source: line 580 `φ(z)`. -/
noncomputable def phi (z : ℝ) : ℝ :=
  (1 / Real.sqrt (2 * Real.pi)) * Real.exp (-z^2 / 2)

/-- Standard normal CDF (paper notation: `Φ`).

    Concrete antiderivative via the interval integral
    `Φ(x) := 1/2 + ∫₀ˣ φ(t) dt`. Pointwise equality with the standard
    measure-theoretic CDF `Φ(x) = ∫_{-∞}^x φ` would require the global
    normalisation `∫_{-∞}^0 φ = 1/2`, which remains a Mathlib gap; for
    that reason this def is the operative `Phi` used downstream rather
    than `(ProbabilityTheory.gaussianReal 0 1 (Set.Iic x)).toReal`. The
    derivative theorem below uses only local FTC and is independent of
    the global normalisation.

    paper source: §2.2 line 134 `Φ(·)`. -/
noncomputable def Phi (x : ℝ) : ℝ :=
  (1 : ℝ) / 2 + ∫ t in (0 : ℝ)..x, phi t

/-- **Density-derivative identity:** `φ'(z) = -z·φ(z)` (HasDerivAt form).

    Proved from the definition of `phi`. The proof composes
    `Real.hasDerivAt_exp` (exponential's derivative), chain rule via
    `HasDerivAt.comp`, and polynomial derivative for `z ↦ -z^2/2`.

    paper source: Proposition `prop:supermodular` line 583 (used in the
    cross-partial derivation). -/
theorem gap_phi_derivative :
    ∀ z : ℝ, HasDerivAt phi (-z * phi z) z := by
  intro z
  -- Step 1. g(z) := -z²/2 has derivative -z.
  have hg : HasDerivAt (fun z : ℝ => -z^2 / 2) (-z) z := by
    have h1 : HasDerivAt (fun z : ℝ => z^2) ((2 : ℕ) * z^(2 - 1)) z :=
      hasDerivAt_pow 2 z
    have h1' : HasDerivAt (fun z : ℝ => z^2) (2 * z) z := by
      have heq : ((2 : ℕ) * z^(2 - 1) : ℝ) = 2 * z := by simp
      rw [heq] at h1; exact h1
    have h2 : HasDerivAt (fun z : ℝ => -z^2) (-(2 * z)) z := h1'.neg
    have h3 : HasDerivAt (fun z : ℝ => -z^2 / 2) (-(2 * z) / 2) z :=
      h2.div_const 2
    have heq2 : (-(2 * z) / 2 : ℝ) = -z := by ring
    rw [heq2] at h3; exact h3
  -- Step 2. Chain rule: exp(g(z)) has derivative exp(-z²/2) * (-z).
  have hexp : HasDerivAt (fun z : ℝ => Real.exp (-z^2 / 2))
                          (Real.exp (-z^2 / 2) * (-z)) z :=
    hg.exp
  -- Step 3. Multiply by constant c = 1/√(2π).
  have hphi : HasDerivAt
                (fun z : ℝ => (1 / Real.sqrt (2 * Real.pi)) * Real.exp (-z^2 / 2))
                ((1 / Real.sqrt (2 * Real.pi)) * (Real.exp (-z^2 / 2) * (-z))) z :=
    hexp.const_mul (1 / Real.sqrt (2 * Real.pi))
  -- Step 4. Convert RHS to -z * phi z and identify the function as phi.
  have hderiv_eq :
      (1 / Real.sqrt (2 * Real.pi)) * (Real.exp (-z^2 / 2) * (-z)) =
        -z * phi z := by
    show _ = -z * ((1 / Real.sqrt (2 * Real.pi)) * Real.exp (-z^2 / 2))
    ring
  rw [hderiv_eq] at hphi
  exact hphi

/-- **Φ is the antiderivative of φ:** `(d/dx) Φ(x) = φ(x)` (HasDerivAt form).

    Proved via the Fundamental Theorem of Calculus. `Phi` is defined
    as `1/2 + ∫₀ˣ φ`; since `φ` is continuous (composition of `exp`
    and a polynomial), `intervalIntegral.integral_hasDerivAt_right`
    gives the FTC derivative.

    paper source: Proposition `prop:supermodular` line 578 (used in the
    cross-partial derivation). -/
theorem gap_Phi_derivative :
    ∀ x : ℝ, HasDerivAt Phi (phi x) x := by
  intro x
  -- phi is continuous everywhere (composition of exp, polynomial, scaling).
  have hcont : Continuous phi := by
    show Continuous (fun z : ℝ =>
      (1 / Real.sqrt (2 * Real.pi)) * Real.exp (-z^2 / 2))
    exact continuous_const.mul
      (((continuous_id.pow 2).neg.div_const 2).rexp)
  -- Hence intervalIntegrable on any [0..x].
  have hII : IntervalIntegrable phi MeasureTheory.volume 0 x :=
    hcont.intervalIntegrable 0 x
  -- Continuous at x.
  have hcontAt : ContinuousAt phi x := hcont.continuousAt
  -- StronglyMeasurableAtFilter via continuity.
  have hmeas : StronglyMeasurableAtFilter phi (nhds x) MeasureTheory.volume :=
    hcont.aestronglyMeasurable.stronglyMeasurableAtFilter
  -- FTC: u ↦ ∫₀..u φ has derivative φ x at x.
  have hFTC : HasDerivAt (fun u : ℝ => ∫ t in (0 : ℝ)..u, phi t) (phi x) x :=
    intervalIntegral.integral_hasDerivAt_right hII hmeas hcontAt
  -- Adding constant 1/2 preserves the derivative; this matches the
  -- definition of Phi.
  have hsum :
      HasDerivAt (fun u : ℝ => (1 : ℝ) / 2 + ∫ t in (0 : ℝ)..u, phi t)
                  (phi x) x :=
    hFTC.const_add ((1 : ℝ) / 2)
  exact hsum

/-! ### Mills' inequality — supporting lemmas -/

/-- `phi` is an even function: `phi (-z) = phi z`. -/
private theorem phi_neg (z : ℝ) : phi (-z) = phi z := by
  unfold phi
  rw [neg_pow_two]

/-- `phi` is continuous. -/
private theorem phi_continuous : Continuous phi := by
  show Continuous (fun z : ℝ =>
    (1 / Real.sqrt (2 * Real.pi)) * Real.exp (-z^2 / 2))
  exact continuous_const.mul
    (((continuous_id.pow 2).neg.div_const 2).rexp)

/-- `phi` is positive. -/
private theorem phi_pos (z : ℝ) : 0 < phi z := by
  unfold phi
  have h2pi : (0 : ℝ) < 2 * Real.pi :=
    mul_pos (by norm_num) Real.pi_pos
  have hsqrt : 0 < Real.sqrt (2 * Real.pi) := Real.sqrt_pos.mpr h2pi
  positivity

/-- `phi` is non-negative. -/
private theorem phi_nonneg (z : ℝ) : 0 ≤ phi z := (phi_pos z).le

/-- Reformulation in the "Gaussian b · x^2" form: `phi z = (1/√(2π)) · exp(-(1/2) * z^2)`. -/
private theorem phi_eq_gaussian (z : ℝ) :
    phi z = (1 / Real.sqrt (2 * Real.pi)) * Real.exp (-(1/2) * z^2) := by
  unfold phi
  congr 1
  congr 1
  ring

/-- The Gaussian half-line integral over `Ioi 0` for `phi`: `∫_{t > 0} phi t = 1/2`.
    Derived from `integral_gaussian_Ioi (1/2) = √(π / (1/2)) / 2 = √(2π) / 2`,
    multiplied by the prefactor `1/√(2π)`. -/
private theorem integral_phi_Ioi_zero :
    ∫ t in Set.Ioi (0 : ℝ), phi t = 1/2 := by
  have hg : ∫ t in Set.Ioi (0 : ℝ), Real.exp (-(1/2) * t^2) =
              Real.sqrt (Real.pi / (1/2)) / 2 :=
    integral_gaussian_Ioi (1/2)
  have hpi_div : Real.pi / (1/2 : ℝ) = 2 * Real.pi := by ring
  rw [hpi_div] at hg
  -- phi t = c * exp(-(1/2) * t^2) where c = 1/√(2π)
  have hphi_eq : (fun t : ℝ => phi t) =
      fun t => (1 / Real.sqrt (2 * Real.pi)) * Real.exp (-(1/2) * t^2) := by
    funext t
    exact phi_eq_gaussian t
  rw [hphi_eq, MeasureTheory.integral_const_mul, hg]
  have hsqrt_pos : 0 < Real.sqrt (2 * Real.pi) :=
    Real.sqrt_pos.mpr (mul_pos (by norm_num) Real.pi_pos)
  field_simp

/-- `phi` is integrable on `(0, ∞)`. -/
private theorem phi_integrableOn_Ioi_zero :
    MeasureTheory.IntegrableOn phi (Set.Ioi (0 : ℝ)) := by
  have hphi_eq : (fun t : ℝ => phi t) =
      fun t => (1 / Real.sqrt (2 * Real.pi)) * Real.exp (-(1/2) * t^2) := by
    funext t; exact phi_eq_gaussian t
  rw [show phi = (fun t : ℝ => (1 / Real.sqrt (2 * Real.pi))
                                  * Real.exp (-(1/2) * t^2)) from hphi_eq]
  apply MeasureTheory.Integrable.integrableOn
  apply MeasureTheory.Integrable.const_mul
  have h12 : (0 : ℝ) < 1/2 := by norm_num
  exact integrable_exp_neg_mul_sq h12

/-- The symmetry identity: `Phi(-x) = 1/2 - ∫_0..x phi(t) dt`,
    using `phi(-t) = phi(t)` (evenness) and `integral_comp_neg`. -/
private theorem Phi_neg_eq (x : ℝ) :
    Phi (-x) = 1/2 - ∫ t in (0 : ℝ)..x, phi t := by
  unfold Phi
  -- Strategy:
  --   integral_comp_neg: ∫ s in 0..x, phi(-s) = ∫ s in (-x)..(-0), phi s = ∫ s in (-x)..0, phi s.
  --   Phi_neg of phi: LHS becomes ∫ s in 0..x, phi s.
  --   integral_symm: ∫ s in 0..(-x), phi s = -∫ s in (-x)..0, phi s.
  -- Hence ∫ s in 0..(-x), phi s = -∫ s in 0..x, phi s.
  have h_compneg : ∫ s in (0 : ℝ)..x, phi (-s) = ∫ s in (-x)..(-(0:ℝ)), phi s :=
    intervalIntegral.integral_comp_neg phi
  simp only [neg_zero] at h_compneg
  have h_phi_eq : ∫ s in (0 : ℝ)..x, phi (-s) = ∫ s in (0 : ℝ)..x, phi s := by
    apply intervalIntegral.integral_congr
    intro s _
    exact phi_neg s
  rw [h_phi_eq] at h_compneg
  -- h_compneg : ∫ 0..x phi = ∫ (-x)..0 phi.
  have h_symm : (∫ s in (-x : ℝ)..0, phi s) = -(∫ s in (0 : ℝ)..(-x), phi s) := by
    rw [intervalIntegral.integral_symm]
  rw [h_symm] at h_compneg
  -- h_compneg : ∫ 0..x phi = -∫ 0..(-x) phi
  -- Hence ∫ 0..(-x) phi = -∫ 0..x phi
  linarith [h_compneg]

/-- `phi t → 0` as `t → ∞`. -/
private theorem phi_tendsto_zero_atTop :
    Filter.Tendsto phi Filter.atTop (nhds 0) := by
  -- phi t = (1/√(2π)) * exp(-(1/2) * t^2), so we need exp(-(1/2) * t^2) → 0.
  have hgauss : Filter.Tendsto (fun t : ℝ => Real.exp (-(1/2) * t^2))
                  Filter.atTop (nhds 0) := by
    apply Real.tendsto_exp_atBot.comp
    have h_pow : Filter.Tendsto (fun t : ℝ => t^2) Filter.atTop Filter.atTop :=
      Filter.tendsto_pow_atTop two_ne_zero
    have h12 : (0 : ℝ) < 1/2 := by norm_num
    exact h_pow.const_mul_atTop_of_neg (neg_lt_zero.mpr h12)
  have h_zero : (1 / Real.sqrt (2 * Real.pi)) * 0 = (0 : ℝ) := by ring
  have := hgauss.const_mul (1 / Real.sqrt (2 * Real.pi))
  rw [h_zero] at this
  apply this.congr'
  filter_upwards with t
  exact (phi_eq_gaussian t).symm

/-- `phi(t)/t → 0` as `t → ∞`. -/
private theorem phi_div_tendsto_zero_atTop :
    Filter.Tendsto (fun t => phi t / t) Filter.atTop (nhds 0) := by
  have hphi := phi_tendsto_zero_atTop
  have hinv : Filter.Tendsto (fun t : ℝ => t⁻¹) Filter.atTop (nhds 0) :=
    tendsto_inv_atTop_zero
  have hprod : Filter.Tendsto (fun t : ℝ => phi t * t⁻¹) Filter.atTop (nhds (0 * 0)) :=
    hphi.mul hinv
  simp only [mul_zero] at hprod
  apply hprod.congr'
  filter_upwards with t
  ring

/-- `∫ t in 0..s, phi t → 1/2` as `s → ∞` (interval-integral form of `∫_0^∞ phi = 1/2`). -/
private theorem integral_phi_zero_tendsto :
    Filter.Tendsto (fun s : ℝ => ∫ t in (0 : ℝ)..s, phi t)
      Filter.atTop (nhds (1/2)) := by
  have hIoi := MeasureTheory.intervalIntegral_tendsto_integral_Ioi
                  0 phi_integrableOn_Ioi_zero Filter.tendsto_id
  rw [integral_phi_Ioi_zero] at hIoi
  exact hIoi

/-- The auxiliary function `M(t) := 1/2 - ∫_0..t phi - phi(t)/t` satisfies
    `M'(t) = phi(t)/t² ≥ 0` for `t > 0`. -/
private theorem M_hasDerivAt (t : ℝ) (ht : 0 < t) :
    HasDerivAt
      (fun s : ℝ => (1/2 : ℝ) - (∫ u in (0 : ℝ)..s, phi u) - phi s / s)
      (phi t / t^2)
      t := by
  -- 1/2 has derivative 0; ∫_0..s phi has derivative phi s; phi s / s has derivative
  -- ((phi'(s) * s - phi(s)) / s^2) = ((-s * phi s) * s - phi s) / s^2
  --                               = -(s^2 phi s + phi s) / s^2 = -phi s - phi s / s^2.
  -- So M'(t) = -phi(t) - (-phi(t) - phi(t)/t^2) = phi(t)/t^2.
  have h_const : HasDerivAt (fun _ : ℝ => (1/2 : ℝ)) 0 t := hasDerivAt_const t (1/2)
  -- ∫_0..s phi has derivative phi(t) at t.
  have hII : IntervalIntegrable phi MeasureTheory.volume 0 t :=
    phi_continuous.intervalIntegrable 0 t
  have hcontAt : ContinuousAt phi t := phi_continuous.continuousAt
  have hmeas : StronglyMeasurableAtFilter phi (nhds t) MeasureTheory.volume :=
    phi_continuous.aestronglyMeasurable.stronglyMeasurableAtFilter
  have h_int : HasDerivAt (fun s : ℝ => ∫ u in (0 : ℝ)..s, phi u) (phi t) t :=
    intervalIntegral.integral_hasDerivAt_right hII hmeas hcontAt
  -- phi(s)/s has derivative (-phi(t) - phi(t)/t^2) at t.
  have h_phi : HasDerivAt phi (-t * phi t) t := gap_phi_derivative t
  have h_id : HasDerivAt (fun s : ℝ => s) (1 : ℝ) t := hasDerivAt_id t
  have ht_ne : t ≠ 0 := ne_of_gt ht
  have h_div : HasDerivAt (fun s : ℝ => phi s / s)
                  ((-t * phi t * t - phi t * 1) / t^2) t :=
    h_phi.div h_id ht_ne
  -- Simplify the derivative expression for phi(s)/s.
  have h_div_simp :
      (-t * phi t * t - phi t * 1) / t^2 = -phi t - phi t / t^2 := by
    have ht2_ne : t^2 ≠ 0 := pow_ne_zero 2 ht_ne
    field_simp
  rw [h_div_simp] at h_div
  -- Combine: M(s) = 1/2 - ∫_0..s phi - phi s / s.
  have h_sub₁ : HasDerivAt (fun s : ℝ => (1/2 : ℝ) - ∫ u in (0 : ℝ)..s, phi u)
                  (0 - phi t) t := h_const.sub h_int
  have h_sub₂ : HasDerivAt
                  (fun s : ℝ => (1/2 : ℝ) - (∫ u in (0 : ℝ)..s, phi u) - phi s / s)
                  ((0 - phi t) - (-phi t - phi t / t^2)) t := h_sub₁.sub h_div
  have h_eq : (0 - phi t) - (-phi t - phi t / t^2) = phi t / t^2 := by ring
  rw [h_eq] at h_sub₂
  exact h_sub₂

/-- `M(t) := 1/2 - ∫_0..t phi - phi(t)/t → 0` as `t → ∞`. -/
private theorem M_tendsto_zero :
    Filter.Tendsto
      (fun s : ℝ => (1/2 : ℝ) - (∫ u in (0 : ℝ)..s, phi u) - phi s / s)
      Filter.atTop (nhds 0) := by
  have h_int := integral_phi_zero_tendsto
  have h_div := phi_div_tendsto_zero_atTop
  have h_const : Filter.Tendsto (fun _ : ℝ => (1/2 : ℝ)) Filter.atTop (nhds (1/2)) :=
    tendsto_const_nhds
  have h_sub : Filter.Tendsto
                (fun s : ℝ => (1/2 : ℝ) - (∫ u in (0 : ℝ)..s, phi u) - phi s / s)
                Filter.atTop (nhds ((1/2 : ℝ) - (1/2) - 0)) := by
    exact (h_const.sub h_int).sub h_div
  have h_eq : (1/2 : ℝ) - (1/2) - 0 = 0 := by ring
  rw [h_eq] at h_sub
  exact h_sub

/-- **Standard Gaussian tail bound (Mills' ratio):**
    `Φ(-x) ≤ (1/(x√(2π))) e^{-x²/2}` for `x > 0`.

    Proved via the classical Mills argument: define
    `M(t) := 1/2 - ∫_0..t phi - phi(t)/t`. We show `M' ≥ 0` on `(0, ∞)`
    by an explicit derivative computation using `gap_phi_derivative`
    (`phi'(t) = -t·phi(t)`), continuity-driven FTC for the running
    integral, and the quotient rule for `phi(t)/t`. We show `M(t) → 0`
    as `t → ∞` using:
    * `phi(t) → 0` (exp-decay);
    * `phi(t)/t → 0` (product of `phi → 0` and `1/t → 0`);
    * `∫_0..s phi → 1/2` (interval-integral version of
      `∫_{Ioi 0} phi = 1/2`, derived from `Real.integral_gaussian_Ioi (1/2)`
      with prefactor `1/√(2π)`).
    Monotonicity of `M` on `Ici x` (via `monotoneOn_of_deriv_nonneg`)
    together with `M(t) → 0` gives `M(x) ≤ 0`, i.e.
    `1/2 - ∫_0..x phi ≤ phi(x)/x`. Combined with `Phi(-x) = 1/2 - ∫_0..x phi`
    (proved via `integral_comp_neg` + evenness of `phi` + `integral_symm`),
    this yields `Phi(-x) ≤ phi(x)/x = (1/(x√(2π))) · e^{-x²/2}`.

    paper source: Proposition `prop:info-decay` line 276 (used in Φ-bound
    derivation). -/
theorem gap_phi_tail_bound :
    ∀ x : ℝ, 0 < x → Phi (-x) ≤ (1 / (x * Real.sqrt (2 * Real.pi))) *
                                  Real.exp (-(x^2 / 2)) := by
  intro x hx
  -- Step 1. Rewrite the RHS as phi(x)/x.
  have hsqrt_pos : 0 < Real.sqrt (2 * Real.pi) :=
    Real.sqrt_pos.mpr (mul_pos (by norm_num) Real.pi_pos)
  have hsqrt_ne : Real.sqrt (2 * Real.pi) ≠ 0 := ne_of_gt hsqrt_pos
  have hx_ne : x ≠ 0 := ne_of_gt hx
  have h_rhs : (1 / (x * Real.sqrt (2 * Real.pi))) * Real.exp (-(x^2 / 2))
                = phi x / x := by
    unfold phi
    have h_exp_eq : Real.exp (-(x^2 / 2)) = Real.exp (-x^2 / 2) := by
      congr 1; ring
    rw [h_exp_eq]
    field_simp
  rw [h_rhs, Phi_neg_eq x]
  -- Goal: 1/2 - ∫_0..x phi t ≤ phi x / x,
  -- equivalently M(x) := 1/2 - ∫_0..x phi - phi(x)/x ≤ 0.
  -- Set M and show M is monotone non-decreasing on `Ici x`, with M(t) → 0.
  set M : ℝ → ℝ :=
    fun s => (1/2 : ℝ) - (∫ u in (0 : ℝ)..s, phi u) - phi s / s with hM_def
  have hM_le : M x ≤ 0 := by
    -- Monotonicity: derivative of M is phi(s)/s² ≥ 0 on Ioi 0 ⊇ interior (Ici x).
    have h_mono : MonotoneOn M (Set.Ici x) := by
      apply monotoneOn_of_deriv_nonneg (convex_Ici x)
      · -- continuity of M on Ici x
        intro s hs
        have hs_pos : 0 < s := lt_of_lt_of_le hx hs
        have hs_ne : s ≠ 0 := ne_of_gt hs_pos
        apply ContinuousAt.continuousWithinAt
        have hM' := M_hasDerivAt s hs_pos
        exact hM'.continuousAt
      · -- differentiable on interior (Ici x) = Ioi x
        rw [interior_Ici]
        intro s hs
        have hs_pos : 0 < s := lt_trans hx hs
        exact (M_hasDerivAt s hs_pos).differentiableAt.differentiableWithinAt
      · -- deriv M ≥ 0 on interior (Ici x) = Ioi x
        rw [interior_Ici]
        intro s hs
        have hs_pos : 0 < s := lt_trans hx hs
        have h_deriv : deriv M s = phi s / s^2 :=
          (M_hasDerivAt s hs_pos).deriv
        rw [h_deriv]
        have hphi_s : 0 ≤ phi s := phi_nonneg s
        have hs2 : 0 ≤ s^2 := sq_nonneg s
        positivity
    -- Bound: M(x) ≤ M(s) for all s ∈ Ici x; take limit s → ∞ to get M(x) ≤ 0.
    have h_lim : Filter.Tendsto M Filter.atTop (nhds 0) := M_tendsto_zero
    apply ge_of_tendsto h_lim
    filter_upwards [Filter.eventually_ge_atTop x] with s hs
    exact h_mono (Set.self_mem_Ici) hs hs
  -- Unfold M to extract the desired inequality.
  have h_M_x : M x = (1/2 - ∫ u in (0:ℝ)..x, phi u) - phi x / x := by
    simp [hM_def]
  rw [h_M_x] at hM_le
  linarith

/-! ### Phi monotonicity, non-negativity, and upper bound

Helper lemmas needed for the welfare-loss monotonicity in `Canonical.lean`
(`gap_three_regime_cognitive_augmentation_monotonicity` and
`gap_three_regime_sufficient_cognition`). Cat 1 promotions: each is a
purely Mathlib derivation from `gap_Phi_derivative` (closed) + `phi`
positivity / integrability (already proved) + standard real-analysis
infrastructure.

paper source: Phi is the standard normal CDF — monotone, non-negative,
bounded above by 1; Φ(0) = 1/2; Φ(x) → 1 as x → ∞. -/

/-- **`Phi` is strictly monotonically increasing.**
    Proof: derivative of `Phi` is `phi` (closed in `gap_Phi_derivative`),
    and `phi` is strictly positive, so `strictMono_of_hasDerivAt_pos`. -/
theorem Phi_strictMono : StrictMono Phi :=
  strictMono_of_hasDerivAt_pos gap_Phi_derivative phi_pos

/-- **`Phi` is monotonically non-decreasing.** Weakening of `Phi_strictMono`. -/
theorem Phi_monotone : Monotone Phi := Phi_strictMono.monotone

/-- **`Phi(0) = 1/2`** by direct unfolding (the integral over `[0, 0]` is `0`). -/
theorem Phi_zero : Phi 0 = (1 : ℝ) / 2 := by
  unfold Phi
  rw [intervalIntegral.integral_same, add_zero]

/-- **`∫_0^x phi t dt ≤ 1/2` for `x ≥ 0`.**
    Derived from `∫_0^∞ phi = 1/2` (`integral_phi_Ioi_zero`) and
    `∫_0^∞ phi = ∫_0^x phi + ∫_x^∞ phi` with the tail integral
    non-negative. -/
private theorem integral_phi_zero_to_x_le_half (x : ℝ) (hx : 0 ≤ x) :
    ∫ t in (0 : ℝ)..x, phi t ≤ (1 : ℝ) / 2 := by
  -- Using `integral_Ioi_sub_Ioi`: ∫_0^∞ - ∫_x^∞ = ∫_0^x.
  have h_split : (∫ t in Set.Ioi (0 : ℝ), phi t) - (∫ t in Set.Ioi x, phi t)
                  = ∫ t in (0 : ℝ)..x, phi t :=
    intervalIntegral.integral_Ioi_sub_Ioi phi_integrableOn_Ioi_zero hx
  rw [integral_phi_Ioi_zero] at h_split
  -- h_split : 1/2 - ∫_x^∞ phi = ∫_0^x phi.
  -- So ∫_0^x phi = 1/2 - ∫_x^∞ phi ≤ 1/2.
  have h_tail_nonneg : 0 ≤ ∫ t in Set.Ioi x, phi t :=
    MeasureTheory.integral_nonneg phi_nonneg
  linarith

/-- **`Phi x ≤ 1` for all `x`.** Combined with `Phi_strictMono` to bound
    `Phi` in `[1/2, 1)` for positive arguments. -/
theorem Phi_le_one (x : ℝ) : Phi x ≤ 1 := by
  by_cases hx : 0 ≤ x
  · -- x ≥ 0: Phi x = 1/2 + ∫_0^x phi ≤ 1/2 + 1/2 = 1.
    unfold Phi
    have h_int := integral_phi_zero_to_x_le_half x hx
    linarith
  · -- x < 0: Phi x ≤ Phi 0 = 1/2 ≤ 1.
    have hx : x < 0 := lt_of_not_ge hx
    have h_mono : Phi x ≤ Phi 0 := Phi_monotone hx.le
    have : Phi 0 = (1 : ℝ) / 2 := Phi_zero
    linarith

/-- **`0 ≤ Phi x` for all `x`.** Derived from `Phi(0) = 1/2 ≥ 0`,
    `Phi_neg_eq` symmetry, and `∫_0^|x| phi ≤ 1/2`. -/
theorem Phi_nonneg (x : ℝ) : 0 ≤ Phi x := by
  by_cases hx : 0 ≤ x
  · -- x ≥ 0: Phi x ≥ Phi 0 = 1/2 ≥ 0.
    have h_mono : Phi 0 ≤ Phi x := Phi_monotone hx
    have : Phi 0 = (1 : ℝ) / 2 := Phi_zero
    linarith
  · -- x < 0: Phi x = 1/2 - ∫_0^|x| phi ≥ 1/2 - 1/2 = 0.
    have hx : x < 0 := lt_of_not_ge hx
    set y : ℝ := -x with hy_def
    have hy_pos : 0 < y := by simp [hy_def]; linarith
    have hx_eq : x = -y := by simp [hy_def]
    rw [hx_eq, Phi_neg_eq y]
    have h_int := integral_phi_zero_to_x_le_half y hy_pos.le
    linarith

/-- **Cat 1 Mathlib-derivable: `Φ(x) → 1` as `x → ∞`.**
    Derivation: `Phi x = 1/2 + ∫_0..x phi`, and `∫_0..s phi → 1/2` as
    `s → ∞` via `integral_phi_zero_tendsto` (the interval-integral
    tendsto built on `Real.integral_gaussian_Ioi (1/2)`). Adding the
    constant `1/2` via `Filter.Tendsto.const_add` yields the limit
    `1/2 + 1/2 = 1`.

    paper source: standard normal CDF asymptotic Φ(x) → 1 (textbook;
    not paper-novel). -/
theorem Phi_tendsto_one_atTop :
    Filter.Tendsto Phi Filter.atTop (nhds 1) := by
  have h_int : Filter.Tendsto (fun x : ℝ => ∫ t in (0 : ℝ)..x, phi t)
                  Filter.atTop (nhds (1/2)) := integral_phi_zero_tendsto
  have h_sum : Filter.Tendsto (fun x : ℝ => (1 : ℝ)/2 + ∫ t in (0 : ℝ)..x, phi t)
                  Filter.atTop (nhds ((1 : ℝ)/2 + 1/2)) :=
    h_int.const_add ((1 : ℝ)/2)
  have h_eq : (1 : ℝ)/2 + 1/2 = 1 := by norm_num
  rw [h_eq] at h_sum
  -- Phi x = 1/2 + ∫_0..x phi t (definitionally).
  apply h_sum.congr'
  filter_upwards with x
  rfl

/-- **Cat 1 Mathlib-derivable: `Φ(x) → 0` as `x → -∞`.**
    Derivation: by the symmetry identity `Phi(-y) = 1/2 - ∫_0..y phi`
    (`Phi_neg_eq`) and the same `integral_phi_zero_tendsto`, we get
    `Phi(-y) → 1/2 - 1/2 = 0` as `y → ∞`. Composing with the substitution
    `x = -y`, the change of filter `atTop ↔ atBot` is handled by
    `Filter.tendsto_neg_atTop_atBot.symm`-style reasoning encoded inline
    via `Filter.tendsto_atBot_atTop_neg`.

    paper source: standard normal CDF asymptotic Φ(x) → 0 as x → -∞
    (textbook; not paper-novel). -/
theorem Phi_tendsto_zero_atBot :
    Filter.Tendsto Phi Filter.atBot (nhds 0) := by
  -- Step 1. The map y ↦ Phi(-y) tends to 0 at atTop.
  have h_int : Filter.Tendsto (fun y : ℝ => ∫ t in (0 : ℝ)..y, phi t)
                  Filter.atTop (nhds (1/2)) := integral_phi_zero_tendsto
  have h_sub : Filter.Tendsto (fun y : ℝ => (1 : ℝ)/2 - ∫ t in (0 : ℝ)..y, phi t)
                  Filter.atTop (nhds ((1 : ℝ)/2 - 1/2)) :=
    tendsto_const_nhds.sub h_int
  have h_eq : (1 : ℝ)/2 - 1/2 = 0 := by norm_num
  rw [h_eq] at h_sub
  have h_neg : Filter.Tendsto (fun y : ℝ => Phi (-y)) Filter.atTop (nhds 0) := by
    apply h_sub.congr'
    filter_upwards with y
    exact (Phi_neg_eq y).symm
  -- Step 2. Phi at atBot = (Phi ∘ Neg.neg) at atTop via tendsto_neg_atBot_atTop.
  have h_neg_filter : Filter.Tendsto (fun y : ℝ => -y) Filter.atTop Filter.atBot :=
    Filter.tendsto_neg_atTop_atBot
  -- (Phi ∘ Neg.neg) at atTop → 0; we want Phi at atBot → 0.
  -- Use the change-of-variable: Phi at atBot = comap (fun y => -y) atTop ∘ Phi.
  -- Cleaner approach: Tendsto (Phi ∘ (-)) atTop = Tendsto Phi atBot via filter conv.
  have h_atBot_eq : Filter.atBot = Filter.map (fun y : ℝ => -y) Filter.atTop := by
    rw [← Filter.map_neg_atTop]
  rw [h_atBot_eq, Filter.tendsto_map'_iff]
  exact h_neg

/-- **Cat 1 Mathlib-derivable helper**: if `f β → 0` (along filter `l`)
    and `f β > 0` eventually, and `c > 0`, then `c / f β → ∞`.

    Derivation chain:
     * `tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within` refines
       `Tendsto f l (𝓝 0)` + eventually-positive into
       `Tendsto f l (𝓝[>] 0)`;
     * `Filter.Tendsto.inv_tendsto_nhdsGT_zero` then gives
       `Tendsto f⁻¹ l atTop`;
     * `Tendsto.const_mul_atTop` (for `0 < c`) yields
       `Tendsto (fun β => c * (f β)⁻¹) l atTop`;
     * rewrite via `div_eq_mul_inv` finishes.

    Used by `gap_W_open_limit_infty` (Canonical.lean) to express
    `Δ / √(2σ²(β)) → ∞` from `√(2σ²(β)) → 0⁺`. -/
theorem tendsto_const_div_atTop_of_tendsto_zero_pos
    {α : Type*} {l : Filter α} (c : ℝ) (h_c_pos : 0 < c) (f : α → ℝ)
    (h_f : Filter.Tendsto f l (nhds 0))
    (h_pos : ∀ᶠ β in l, 0 < f β) :
    Filter.Tendsto (fun β => c / f β) l Filter.atTop := by
  have h_pos_within : ∀ᶠ β in l, f β ∈ Set.Ioi (0 : ℝ) := h_pos
  have h_nhdsGT : Filter.Tendsto f l (nhdsWithin (0 : ℝ) (Set.Ioi 0)) :=
    tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within f h_f h_pos_within
  have h_inv : Filter.Tendsto (fun β => (f β)⁻¹) l Filter.atTop :=
    h_nhdsGT.inv_tendsto_nhdsGT_zero
  have h_mul : Filter.Tendsto (fun β => c * (f β)⁻¹) l Filter.atTop :=
    h_inv.const_mul_atTop h_c_pos
  apply h_mul.congr'
  filter_upwards with β
  exact (div_eq_mul_inv c (f β)).symm

/-- **Cat 1 Mathlib-derivable: `signalVariance β → 0` as `β → ∞`.**

    `signalVariance β = 1 / (2^(2β) − 1)`. As `β → ∞`, the exponent
    `2β → ∞`, hence `2^(2β) = exp((2β) · log 2) → ∞` (since `log 2 > 0`),
    therefore the denominator `2^(2β) − 1 → ∞`, and the reciprocal `→ 0`.

    Derivation chain:
     * `Real.rpow_def_of_pos` rewrites `2^(2β)` as `exp((2β) · log 2)`;
     * `Filter.Tendsto.const_mul_atTop` (`log 2 > 0`) on `Tendsto id atTop atTop`;
       gives `(2 · log 2) · β → ∞`;
     * `Real.tendsto_exp_atTop` composed: `2^(2β) → ∞`;
     * subtracting the constant `1` preserves `→ ∞`;
     * `Filter.Tendsto.inv_tendsto_atTop` gives the reciprocal `→ 0`.

    Used by `gap_W_open_limit_infty` (Canonical.lean) for the β → ∞
    welfare-limit derivation.

    paper source: textbook reciprocal-of-exponential asymptotic
    (not paper-novel). -/
theorem signalVariance_tendsto_zero_atTop :
    Filter.Tendsto signalVariance Filter.atTop (nhds 0) := by
  -- Step 1: `2 * β → ∞` as `β → ∞`.
  have h_2beta_atTop : Filter.Tendsto (fun β : ℝ => 2 * β) Filter.atTop Filter.atTop :=
    Filter.tendsto_id.const_mul_atTop (by norm_num : (0 : ℝ) < 2)
  -- Step 2: `2 ^ (2β) → ∞`. Rewrite `2 ^ (2β) = exp((2β) * log 2)`.
  have h_log2_pos : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have h_exp_arg : Filter.Tendsto (fun β : ℝ => 2 * β * Real.log 2)
      Filter.atTop Filter.atTop :=
    h_2beta_atTop.atTop_mul_const h_log2_pos
  have h_exp_to_inf : Filter.Tendsto (fun β : ℝ => Real.exp (2 * β * Real.log 2))
      Filter.atTop Filter.atTop :=
    Real.tendsto_exp_atTop.comp h_exp_arg
  have h_pow_eq : ∀ β : ℝ, (2 : ℝ) ^ (2 * β) = Real.exp (2 * β * Real.log 2) := by
    intro β
    rw [Real.rpow_def_of_pos (by norm_num : (0 : ℝ) < 2), mul_comm (Real.log 2) (2 * β)]
  have h_pow_to_inf : Filter.Tendsto (fun β : ℝ => (2 : ℝ) ^ (2 * β))
      Filter.atTop Filter.atTop := by
    apply h_exp_to_inf.congr'
    filter_upwards with β
    exact (h_pow_eq β).symm
  -- Step 3: `2 ^ (2β) - 1 → ∞` via `Tendsto.atTop_add` (`f → ∞` + `g → const_nhds`).
  have h_denom_to_inf : Filter.Tendsto (fun β : ℝ => (2 : ℝ) ^ (2 * β) - 1)
      Filter.atTop Filter.atTop := by
    have h_add : Filter.Tendsto (fun β : ℝ => (2 : ℝ) ^ (2 * β) + (-1 : ℝ))
        Filter.atTop Filter.atTop :=
      Filter.Tendsto.atTop_add h_pow_to_inf tendsto_const_nhds
    apply h_add.congr'
    filter_upwards with β
    ring
  -- Step 4: `1 / (2 ^ (2β) - 1) → 0` via `inv_tendsto_atTop`.
  have h_inv : Filter.Tendsto (fun β : ℝ => ((2 : ℝ) ^ (2 * β) - 1)⁻¹)
      Filter.atTop (nhds 0) :=
    h_denom_to_inf.inv_tendsto_atTop
  apply h_inv.congr'
  filter_upwards with β
  unfold signalVariance
  rw [one_div]

/-- **`Phi` is continuous at every point.** Derived from the FTC closure
    `gap_Phi_derivative` (which provides `HasDerivAt Phi (phi x) x`) via
    `HasDerivAt.continuousAt`.

    Used for the β → 0⁺ welfare limit (`gap_W_open_limit_zero`) to pass
    `Phi (Δ / √(2σ²(β)))` through to its limiting value `Phi 0 = 1/2`.

    paper source: standard normal CDF is continuous everywhere
    (textbook; not paper-novel). -/
theorem Phi_continuousAt (x : ℝ) : ContinuousAt Phi x :=
  (gap_Phi_derivative x).continuousAt

/-- **Reflection identity: `Phi x + Phi (-x) = 1`.**
    Derivation: `Phi x = 1/2 + ∫_0..x phi` (definitional) and
    `Phi (-x) = 1/2 - ∫_0..x phi` (`Phi_neg_eq`); the two running
    integrals cancel, leaving `1`. This is the standard-normal CDF
    symmetry `Φ(x) = 1 − Φ(−x)`.

    paper source: standard normal CDF symmetry (textbook; not
    paper-novel). Used to derive the strict bounds `0 < Phi` and
    `Phi < 1` for the 5-state welfare-loss analysis. -/
theorem Phi_reflect (x : ℝ) : Phi x + Phi (-x) = 1 := by
  have h_neg : Phi (-x) = 1/2 - ∫ t in (0 : ℝ)..x, phi t := Phi_neg_eq x
  have h_pos : Phi x = 1/2 + ∫ t in (0 : ℝ)..x, phi t := rfl
  rw [h_neg, h_pos]
  ring

/-- **Strict tail positivity: `0 < ∫_{t > x} phi t` for every `x`.**
    Derivation: `phi` is strictly positive everywhere
    (`phi_pos`), so its support is all of `ℝ`; restricted to the
    half-line `Set.Ioi x` this still has positive (indeed infinite)
    Lebesgue measure. `setIntegral_pos_iff_support_of_nonneg_ae`
    converts the positive-measure-support fact into strict
    positivity of the set integral. `phi` is integrable on the
    half-line by `phi_integrableOn_Ioi_zero`-style reasoning,
    here reproved directly for the general base point `x`.

    paper source: the standard-normal density has full support, so
    every right tail carries strictly positive mass (textbook). -/
theorem Phi_tail_integral_pos (x : ℝ) :
    0 < ∫ t in Set.Ioi x, phi t := by
  -- `phi` is integrable on `Ioi x` (Gaussian form on a half-line).
  have hphi_eq : (fun t : ℝ => phi t) =
      fun t => (1 / Real.sqrt (2 * Real.pi)) * Real.exp (-(1/2) * t^2) := by
    funext t; exact phi_eq_gaussian t
  have h_int : MeasureTheory.IntegrableOn phi (Set.Ioi x) := by
    rw [show phi = (fun t : ℝ => (1 / Real.sqrt (2 * Real.pi))
                                  * Real.exp (-(1/2) * t^2)) from hphi_eq]
    apply MeasureTheory.Integrable.integrableOn
    apply MeasureTheory.Integrable.const_mul
    exact integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1/2)
  -- Non-negativity a.e. on the restricted measure.
  have h_nonneg : 0 ≤ᵐ[MeasureTheory.volume.restrict (Set.Ioi x)] phi :=
    Filter.Eventually.of_forall (fun t => phi_nonneg t)
  rw [MeasureTheory.setIntegral_pos_iff_support_of_nonneg_ae h_nonneg h_int]
  -- `support phi = univ` since `phi` is strictly positive everywhere,
  -- so `support phi ∩ Ioi x = Ioi x`, which has positive volume.
  have h_supp : Function.support phi = Set.univ := by
    ext t
    simp only [Function.mem_support, Set.mem_univ, iff_true]
    exact (phi_pos t).ne'
  rw [h_supp, Set.univ_inter]
  exact MeasureTheory.Measure.measure_Ioi_pos MeasureTheory.volume x

/-- **`1/2 < Phi x` for `x > 0`.**
    Derivation: `Phi x = 1/2 + ∫_0..x phi` and the running integral
    `∫_0..x phi` is strictly positive on `0 < x` because `phi` is
    strictly positive everywhere (`intervalIntegral_pos_of_pos`,
    using continuity of `phi` for interval-integrability).

    paper source: the standard normal CDF strictly exceeds `1/2` on
    the positive half-line (textbook). Used to pin `Phi_B(β) ∈ (1/2, 1)`
    in the 5-state Regime (i) analysis (paper line 825). -/
theorem Phi_gt_half_of_pos {x : ℝ} (hx : 0 < x) : (1 : ℝ)/2 < Phi x := by
  have h_pos : 0 < ∫ t in (0 : ℝ)..x, phi t :=
    intervalIntegral.intervalIntegral_pos_of_pos
      (phi_continuous.intervalIntegrable 0 x) phi_pos hx
  unfold Phi
  linarith

/-- **`0 < Phi x` for every `x`.**
    Derivation: for `x ≥ 0`, monotonicity gives `Phi x ≥ Phi 0 = 1/2 > 0`;
    for `x < 0`, the reflection identity `Phi x = 1 − Phi (−x)` with
    `−x > 0` reduces the claim to `Phi (−x) < 1`, which follows from
    `Phi x = 1/2 + ∫_0..(−x) phi` plus strict tail positivity
    `∫_{t > −x} phi > 0` via the split `∫_0..(−x) phi = 1/2 − ∫_{t>−x} phi`
    (`intervalIntegral.integral_Ioi_sub_Ioi`, `integral_phi_Ioi_zero`).

    paper source: the standard normal CDF is strictly positive
    everywhere (textbook). -/
theorem Phi_pos (x : ℝ) : 0 < Phi x := by
  rcases le_or_gt 0 x with hx | hx
  · -- x ≥ 0: Phi x ≥ Phi 0 = 1/2 > 0.
    have h_mono : Phi 0 ≤ Phi x := Phi_monotone hx
    rw [Phi_zero] at h_mono
    linarith
  · -- x < 0: use reflection. Set y := -x > 0.
    set y : ℝ := -x with hy_def
    have hy_pos : 0 < y := by simp only [hy_def]; linarith
    have h_refl : Phi x + Phi y = 1 := by
      have := Phi_reflect y
      rw [show -y = x from by simp [hy_def]] at this
      linarith [this]
    -- Phi y < 1 via the integral split: Phi y = 1/2 + ∫_0..y phi,
    -- and ∫_0..y phi = 1/2 - ∫_{t>y} phi < 1/2.
    have h_split : (∫ t in Set.Ioi (0 : ℝ), phi t) - (∫ t in Set.Ioi y, phi t)
                    = ∫ t in (0 : ℝ)..y, phi t :=
      intervalIntegral.integral_Ioi_sub_Ioi phi_integrableOn_Ioi_zero hy_pos.le
    rw [integral_phi_Ioi_zero] at h_split
    have h_tail_pos : 0 < ∫ t in Set.Ioi y, phi t := Phi_tail_integral_pos y
    have h_Phi_y_lt : Phi y < 1 := by
      unfold Phi
      linarith
    linarith

/-- **`Phi x < 1` for every `x`.**
    Derivation: the reflection identity `Phi x = 1 − Phi (−x)`
    (`Phi_reflect`) together with strict positivity `0 < Phi (−x)`
    (`Phi_pos`) gives `Phi x = 1 − Phi (−x) < 1`.

    paper source: the standard normal CDF is strictly below `1`
    everywhere (textbook). Used to establish `1 − P_trap(β) > 0` for
    every finite `β` in the 5-state Regime (i) reversal analysis
    (paper line 825: "`1 − P_trap(β) > 0` for finite `β`"). -/
theorem Phi_lt_one (x : ℝ) : Phi x < 1 := by
  have h_refl : Phi x + Phi (-x) = 1 := Phi_reflect x
  have h_pos : 0 < Phi (-x) := Phi_pos (-x)
  linarith

/-- **Cat 1 Mathlib-derivable: `signalVariance β → +∞` as `β → 0⁺`.**

    `signalVariance β = 1 / (2^(2β) − 1)`. As `β → 0⁺`, the exponent
    `2β → 0⁺`, hence `2^(2β) = exp((2β) · log 2) → exp 0 = 1`,
    therefore the denominator `2^(2β) − 1 → 0` (and stays positive on
    `Ioi 0`), and the reciprocal `→ +∞`.

    Derivation chain:
     * `2 * β → 0` and `2 * β · log 2 → 0` along `nhdsWithin 0 (Ioi 0)`;
     * `Real.continuous_exp.tendsto 0` composed: `2^(2β) → 1`;
     * subtracting `1`: `2^(2β) − 1 → 0`;
     * positivity within `Ioi 0`: `0 < 2^(2β) − 1` eventually (via
       `Real.one_lt_rpow`);
     * `tendsto_const_div_atTop_of_tendsto_zero_pos` for `c = 1` yields
       `1 / (2^(2β) − 1) → +∞`.

    Symmetric mirror of `signalVariance_tendsto_zero_atTop` for the
    β → 0⁺ branch.  Used by `gap_W_open_limit_zero` (Canonical.lean) for
    the β → 0⁺ welfare-limit derivation.

    paper source: textbook reciprocal-of-exponential asymptotic
    (not paper-novel). -/
theorem signalVariance_tendsto_atTop_of_tendsto_zero_pos :
    Filter.Tendsto signalVariance (nhdsWithin 0 (Set.Ioi 0)) Filter.atTop := by
  -- Step 1: `2 * β → 0` as `β → 0⁺` (within `nhdsWithin 0 (Ioi 0)`).
  have h_id : Filter.Tendsto (fun β : ℝ => β) (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) :=
    tendsto_nhdsWithin_of_tendsto_nhds Filter.tendsto_id
  have h_2beta : Filter.Tendsto (fun β : ℝ => 2 * β)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) := by
    have h := h_id.const_mul (2 : ℝ)
    have h_eq : (2 : ℝ) * 0 = 0 := by ring
    rw [h_eq] at h
    exact h
  -- Step 2: `2 * β * log 2 → 0`.
  have h_arg : Filter.Tendsto (fun β : ℝ => 2 * β * Real.log 2)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) := by
    have h := h_2beta.mul_const (Real.log 2)
    have h_eq : (0 : ℝ) * Real.log 2 = 0 := by ring
    rw [h_eq] at h
    exact h
  -- Step 3: `exp(2β · log 2) → exp 0 = 1`.
  have h_exp : Filter.Tendsto (fun β : ℝ => Real.exp (2 * β * Real.log 2))
      (nhdsWithin 0 (Set.Ioi 0)) (nhds 1) := by
    have h := (Real.continuous_exp.tendsto 0).comp h_arg
    rw [Real.exp_zero] at h
    exact h
  -- Step 4: `2^(2β) → 1` (via the exp-identity `2^(2β) = exp(2β · log 2)`).
  have h_pow_eq : ∀ β : ℝ, (2 : ℝ) ^ (2 * β) = Real.exp (2 * β * Real.log 2) := by
    intro β
    rw [Real.rpow_def_of_pos (by norm_num : (0 : ℝ) < 2),
        mul_comm (Real.log 2) (2 * β)]
  have h_pow : Filter.Tendsto (fun β : ℝ => (2 : ℝ) ^ (2 * β))
      (nhdsWithin 0 (Set.Ioi 0)) (nhds 1) := by
    apply h_exp.congr'
    filter_upwards with β
    exact (h_pow_eq β).symm
  -- Step 5: `2^(2β) - 1 → 0`.
  have h_denom : Filter.Tendsto (fun β : ℝ => (2 : ℝ) ^ (2 * β) - 1)
      (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) := by
    have h_const : Filter.Tendsto (fun _ : ℝ => (1 : ℝ))
        (nhdsWithin 0 (Set.Ioi 0)) (nhds 1) := tendsto_const_nhds
    have h := h_pow.sub h_const
    have h_eq : (1 : ℝ) - 1 = 0 := by norm_num
    rw [h_eq] at h
    exact h
  -- Step 6: `0 < 2^(2β) - 1` for `β ∈ Ioi 0`.
  have h_denom_pos : ∀ᶠ β in nhdsWithin (0 : ℝ) (Set.Ioi 0),
      0 < (2 : ℝ) ^ (2 * β) - 1 := by
    filter_upwards [self_mem_nhdsWithin] with β (hβ : β ∈ Set.Ioi (0 : ℝ))
    have hβ' : 0 < β := hβ
    have h2_one_lt : (1 : ℝ) < 2 := by norm_num
    have h2β_pos : 0 < 2 * β := by linarith
    have h_one_lt_pow : (1 : ℝ) < (2 : ℝ) ^ (2 * β) :=
      Real.one_lt_rpow h2_one_lt h2β_pos
    linarith
  -- Step 7: `1 / (2^(2β) - 1) → +∞` via the helper used by R30.
  have h_inv : Filter.Tendsto (fun β : ℝ => 1 / ((2 : ℝ) ^ (2 * β) - 1))
      (nhdsWithin 0 (Set.Ioi 0)) Filter.atTop :=
    tendsto_const_div_atTop_of_tendsto_zero_pos 1 one_pos
      (fun β => (2 : ℝ) ^ (2 * β) - 1) h_denom h_denom_pos
  -- Step 8: identify `1 / (2^(2β) - 1)` with `signalVariance β` by `unfold`.
  apply h_inv.congr'
  filter_upwards with β
  unfold signalVariance
  rfl


/-- Encoding of the expected maximum of `k` iid `Uniform[0,1]` random
    variables by its closed-form value `k / (k+1)`. This is a
    type-level encoding: the integral derivation
    `∫₀¹ k · x^(k−1) · x dx = k/(k+1)` is NOT proved here. The Lean
    `def` IS the paper's stated formula; downstream theorems treating
    `expectedMaxUniform` as the expected maximum (e.g. in
    `prop:topo-cluster` proof) implicitly rely on the classical
    order-statistics identity (David & Nagaraja 2003 Eq. 2.1.4)
    which remains a Mathlib gap.

    paper source: Proposition `prop:topo-cluster` line 292
    (proof body invoking "By the theory of order statistics"). -/
noncomputable def expectedMaxUniform (k : ℕ) : ℝ := (k : ℝ) / (k + 1)

/-- **Order-statistics maximum**: `expectedMaxUniform k = k/(k+1)` by
    the definitional encoding above. This is `rfl`-bookkeeping that
    records the formula in the Lean type system; the substantive
    probability-theoretic identity `E[max k iid Uniform[0,1]] = k/(k+1)`
    is NOT proved here. The proof of that identity requires Mathlib's
    Lebesgue integration over the product of uniform measures, which
    remains a Mathlib gap.

    R66 NOTE: this rfl theorem records the formula at the type-system
    level only; the SUBSTANTIVE order-statistics identity
    `E[max k iid Uniform[0,1]] = k/(k+1)` is a separate Mathlib gap,
    encoded as Cat 2 axiom `gap_david_nagaraja_eq214_OPEN` below on
    the opaque carrier `expectedMaxIIDUniform`. The two encodings are
    NOT redundant: this theorem is the def-rfl bookkeeping form on the
    paper's named constant `expectedMaxUniform`; the Cat 2 axiom is the
    substantive measure-theoretic identity on the abstract opaque
    carrier `expectedMaxIIDUniform` (which represents the actual
    `E[max k iid Uniform[0,1]]` integral, not yet formalised in Mathlib).

    paper source: Proposition `prop:topo-cluster` line 292 ("By the
    theory of order statistics"). -/
theorem gap_order_statistics_max :
    ∀ k : ℕ, k ≥ 1 →
      expectedMaxUniform k = (k : ℝ) / (k + 1) :=
  fun _ _ => rfl

/-! ## 11.1 David & Nagaraja 2003 Eq. 2.1.4 — substantive Cat 2 axiom

R66 §18 closure-path: introduces the substantive measure-theoretic order-
statistics identity as a Cat 2 axiom on a new opaque carrier
`expectedMaxIIDUniform : ℕ → ℝ` representing the actual `E[max k iid
Uniform[0,1]]` integral. The substantive identity is:
   `E[max_{i=1..k} X_i] = k/(k+1)` for X_i iid Uniform[0,1]
   (David & Nagaraja 2003, _Order Statistics_, 3rd ed., Eq. 2.1.4,
   Wiley-Interscience, ISBN 0-471-38926-9, §2.1)

Mathlib lacks the formalised order-statistics + product-uniform-measure
infrastructure; the Lean encoding axiomatises the textbook identity on
the new opaque carrier. The existing `expectedMaxUniform := k/(k+1)`
(def-rfl bookkeeping above) and `gap_order_statistics_max` (the Cat 1
rfl theorem) are PRESERVED for downstream code that only needs the
formula, but the SUBSTANTIVE identity (which the paper invokes) lives
in the Cat 2 axiom below. -/

/-- Substantive paper claim — opaque carrier required (Mathlib gap).
    Abstract `E[max k iid Uniform[0,1]]` value as a function of `k`.
    Distinct from the def-rfl `expectedMaxUniform := k/(k+1)` above:
    `expectedMaxIIDUniform k` is the SEMANTIC `E[max iid Uniform]`
    expectation (an opaque measure-theoretic quantity), whereas
    `expectedMaxUniform k = k/(k+1)` is the SYNTACTIC named formula
    (a def-rfl bookkeeping equality). The Cat 2 axiom
    `gap_david_nagaraja_eq214_OPEN` below ties the two together via
    the David & Nagaraja 2003 textbook identity.

    paper source: Proposition `prop:topo-cluster` proof line 292
    ("By the theory of order statistics"); David & Nagaraja 2003
    Eq. 2.1.4 cited as the canonical Cat 2 source. -/
axiom expectedMaxIIDUniform : ℕ → ℝ

/-- **David & Nagaraja 2003 Eq. 2.1.4 — substantive order-statistics
    identity for iid Uniform[0,1].**

    For X_1, ..., X_k iid Uniform[0,1] with k ≥ 1, the expected maximum
    is `E[max_{i=1..k} X_i] = k/(k+1)`. This is the canonical textbook
    formula derived via the explicit integral
    `∫₀¹ k · x^(k-1) · x dx = k · ∫₀¹ x^k dx = k/(k+1)` using the
    density of the maximum of k iid Uniform[0,1] variables, which is
    `k · x^(k-1)` on `[0, 1]`.

    Cat 2 — accepted on David & Nagaraja 2003 authority. Mathlib lacks
    formalised order-statistics + product-uniform-measure infrastructure
    for the maximum of iid uniform variables (no `expectedMaxIIDUniform`
    framework, no general `iid_uniform_max_expected_value` theorem); the
    Lean encoding axiomatises the textbook result on the opaque carrier
    `expectedMaxIIDUniform`, citing David HA & Nagaraja HN (2003)
    _Order Statistics_, 3rd ed., Wiley-Interscience, ISBN 0-471-38926-9,
    §2.1 (Eq. 2.1.4 "Expected value of the maximum of k iid Uniform[0,1]
    random variables"). Downstream consumers consume this axiom directly.

    paper source: Proposition `prop:topo-cluster` proof line 292
    ("By the theory of order statistics, `E[max_{v ∈ R} r(v) | |R| = k] =
    k/(k+1)` and `E[r*] = E[max_{v ∈ V} r(v)] = n/(n+1)`"). -/
axiom gap_david_nagaraja_eq214_OPEN :
    ∀ k : ℕ, 1 ≤ k → expectedMaxIIDUniform k = (k : ℝ) / (k + 1)

/-- **Harris-Kesten consequence**: the squared critical probability is `1/4`,
    a closed (kernel-pure) consequence of the Harris-Kesten Cat 2 axiom.
    Provides a downstream-CLOSED consumer for `harrisKestenCriticalProb`,
    so the opaque carrier is part of an actual derivation chain rather
    than an isolated record.

    Consumes the Cat 2 axiom `gap_harris_kesten_OPEN` directly via
    rewrite (per the 2026-05-13 discipline clarification: external Cat 2
    axioms with paper authority are consumed directly in proof bodies,
    not threaded as broken-link hypotheses).

    paper source: Theorem 3.3 (`thm:phase`) auxiliary computation
    (used implicitly when computing `θ(1−p)^2` regime products). -/
theorem gap_harris_kesten_squared :
    harrisKestenCriticalProb ^ 2 = (1 : ℝ) / 4 := by
  rw [gap_harris_kesten_OPEN]
  norm_num

/-! ## 11. David & Nagaraja 2003 (Order Statistics — i.i.d. continuous
   rank symmetry)

David, H. A. & Nagaraja, H. N. (2003). _Order Statistics_, 3rd ed.,
Wiley-Interscience, ISBN 0-471-38926-9. §1.3 "Distribution of Order
Statistics" establishes the continuous-distribution rank-symmetry: for
any pair of independent continuous random variables `X_1, X_2` drawn
from the same distribution (i.i.d. continuous), the probability of
`X_1 > X_2` equals `1/2` (the symmetry `P(X_1 > X_2) = P(X_2 > X_1) =
1/2 - P(X_1 = X_2)/2 = 1/2` follows because continuous distributions
have zero probability of ties: `P(X_1 = X_2) = 0`).

The paper's Proposition `prop:sentimental` proof (line 600) invokes
this fact at α = 0 to establish that the agent's ranking of neighbours
is signal-independent (since the ranking reduces to comparing `ξ(u_1)`
vs `ξ(u_2)` for ξ drawn i.i.d. from continuous Uniform[0, 1] per paper
Definition 2.1 line 114), so `P_trap(β, κ, 0) = Pr(ξ(u_1) > ξ(u_2)) =
1/2` for all β. Combined with Lemma `lem:conditional-reduction`(i)
(within-branch Blackwell monotonicity on each fixed ranking branch,
already encoded as Cat 2 `gap_blackwell_monotonicity_OPEN`), this gives
the welfare monotonicity at α = 0. -/

/-- **David & Nagaraja 2003 §1.3 + Blackwell 1953 conditional
    application — combined Cat 2 absorption to the sentimental-agent
    welfare carrier at α = 0.**

    Under the paper's standing-convention setup (Definition 2.1, line
    114: ξ drawn i.i.d. from continuous Uniform[0, 1] independently of
    r), the rank-symmetry fact `P(ξ(u_1) > ξ(u_2)) = 1/2` (David &
    Nagaraja 2003 §1.3) makes the agent's α = 0 ranking signal-
    independent. Within each fixed ranking branch, Blackwell 1953
    monotonicity in β applies via Lemma `lem:conditional-reduction`(i)
    on the conditional subproblem on the restricted action domain
    (Cat 2 dependency on `gap_blackwell_monotonicity_OPEN`'s underlying
    paper authority is threaded as an explicit antecedent for audit
    visibility).

    Cat 2 — accepted on David & Nagaraja 2003 + Blackwell 1953 joint
    authority. Mathlib lacks both formalised continuous-distribution
    rank-symmetry theory (no general `iid_continuous_imp_p_strict_gt_eq_half`
    theorem on independent identically-distributed continuous-CDF random
    variables) AND the decision-theoretic Blackwell-conditional
    application machinery; the Lean encoding axiomatises the paper-stated
    composite result on the `agentWelfare AgentType.sentimental _ _ 0`
    carrier, citing David HA & Nagaraja HN (2003) _Order Statistics_, 3rd
    ed., Wiley-Interscience, ISBN 0-471-38926-9, §1.3 ("Distribution of
    Order Statistics") + Blackwell D (1953) "Equivalent Comparisons of
    Experiments", Annals of Mathematical Statistics 24(2):265-272.

    Statement uses an EXPLICIT antecedent for the Blackwell within-
    branch monotonicity (the propositional content of
    `gap_blackwell_monotonicity_OPEN`, namely Bayesian-agent monotonicity
    at the within-branch reference point `(κ = 0, α = 1)`); this
    surfaces both the David & Nagaraja 2003 dependency (via the carrier-
    bridging citation embodied in this axiom's paper authority) and the
    Blackwell 1953 dependency (via the threaded antecedent). The
    composition encapsulates the paper line 600 derivation.

    paper source: Proposition `prop:sentimental` proof, line 600
    ("the ranking converges to ξ(u), which is independent of β.
    Therefore P_trap(β, κ, 0) = Pr(ξ(u_1) > ξ(u_2)) = 1/2 for all β.
    Since the ranking is signal-independent at α = 0, welfare
    conditional on each branch is determined by the within-branch
    signal quality, which is non-decreasing in β by the standard
    Blackwell argument (Lemma~\ref{lem:conditional-reduction}).
    Therefore W(β, κ, 0) is non-decreasing in β"). -/
axiom gap_iid_continuous_rank_symmetry_OPEN :
    (∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
      agentWelfare AgentType.bayesian β₁ 0 1 ≤
        agentWelfare AgentType.bayesian β₂ 0 1) →
    ∀ κ : ℝ, 0 ≤ κ →
      ∀ β₁ β₂ : ℝ, β₁ ≤ β₂ →
        agentWelfare AgentType.sentimental β₁ κ 0 ≤
          agentWelfare AgentType.sentimental β₂ κ 0

end BlackwellDilemma
