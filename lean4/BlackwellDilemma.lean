/-
  BlackwellDilemma.lean

  Root module. Machine-checked formalisation of the math content of:

    "Information Value Under Endogenous Feasibility"
     (Alex Chengyu Li, 2026; SSRN preprint, EJOR submission).

  Module map (paper section → file):

    Basic.lean                  §3 Welfare Decomposition
                                  Thm 3.1 (welfare_decomposition)
    SignalImmunity.lean         §3 final clause (∂W_topo/∂β = 0)
    PhysicalIrreducibility.lean §3.1 Prop physical-irreducibility,
                                       W_info ≤ 0, oracle saturation

    Percolation.lean            §2-§3.3 paper-faithful finite
                                  bond-percolation framework: the
                                  BondConfig sample space, the explicit
                                  Bernoulli-product measure, and the
                                  E_{G_p}[·] expectation with its
                                  monotonicity / linearity lemmas
    Types.lean                  §2 IDP primitives, agents, signal /
                                  topology signal families
    ClassicalResults.lean       Blackwell 1953, Harris-Kesten,
                                  Molloy-Reed, Topkis 1998 (axiomatised)

    Wrongness.lean              §3.2 Lemma wrongness, Lemma
                                  conditional-reduction, Thm 3.2 dilemma,
                                  Prop info-decay, Prop topo-cluster
    Phase.lean                  §3.3 Thm 3.3 phase, Prop trap-prevalence,
                                  Cor er-phase, Cor power-law

    Cognitive.lean              §4 Thm 4.1 cognitive-threshold,
                                  Prop supermodular, Prop sentimental,
                                  Prop threshold-alpha
    Principal.lean              §4 Def principal, Prop principal-optimum,
                                  Cor disclosure, Cor policy-complementarity

    Canonical.lean              §5 Prop canonical (4-state),
                                  Prop interior-optimum (5-state),
                                  Prop three-regime, Prop p-monotonicity,
                                  Prop threshold-five-state,
                                  Prop bayesian-naive-five-state
    Bayesian.lean               §6 Thm 5.1 bayesian-immunity,
                                  Prop complementarity
    GeneralGraphs.lean          §7 Def greedy-path, Def trap-tree,
                                  Thm 6.1 general-tree,
                                  Prop error-compounding, Ex cyclic-trap

    Ledger.lean                 proof-derived ledger for all 29 labelled
                                  manuscript claims
    PaperSemanticGate.lean      build-checked proof-witness closure gate
    AxiomAudit.lean             #print axioms for proof-bearing ledger terms
-/

import BlackwellDilemma.Basic
import BlackwellDilemma.SignalImmunity
import BlackwellDilemma.PhysicalIrreducibility
import BlackwellDilemma.Percolation
import BlackwellDilemma.Types
import BlackwellDilemma.ClassicalResults
import BlackwellDilemma.Wrongness
import BlackwellDilemma.Phase
import BlackwellDilemma.Cognitive
import BlackwellDilemma.Principal
import BlackwellDilemma.Canonical
import BlackwellDilemma.Bayesian
import BlackwellDilemma.GeneralGraphs
import BlackwellDilemma.Ledger
import BlackwellDilemma.PaperSemanticGate

-- Cat 1 Infrastructure (Mathlib-PR-ready, kernel-pure)
import BlackwellDilemma.Infrastructure.Roadmap
import BlackwellDilemma.Infrastructure.FiveStateRewards
import BlackwellDilemma.Infrastructure.FiveStateVDyn
import BlackwellDilemma.Infrastructure.MLimitDifferenceConcrete
import BlackwellDilemma.Infrastructure.EVTBoundedDecreasing
import BlackwellDilemma.Infrastructure.SimpleGraphReachable
import BlackwellDilemma.Infrastructure.TopkisCrossPartial
import BlackwellDilemma.Infrastructure.TopkisCrossPartialCriterion
import BlackwellDilemma.Infrastructure.FOSDDerivativeChain
import BlackwellDilemma.Infrastructure.ArgmaxMonotone
import BlackwellDilemma.Infrastructure.KappaStarConcrete
import BlackwellDilemma.Infrastructure.HarrisKestenCriticalDivergence
import BlackwellDilemma.Infrastructure.BlackwellConditional
import BlackwellDilemma.Infrastructure.GaussianPosterior
import BlackwellDilemma.Infrastructure.SupermodularExtended
import BlackwellDilemma.Infrastructure.DifferenceQuotientAlgebra
import BlackwellDilemma.Infrastructure.MillsRatioTail
import BlackwellDilemma.Infrastructure.MonotoneFunctionAlgebra
import BlackwellDilemma.Infrastructure.TendstoLimitArithmetic
import BlackwellDilemma.Infrastructure.ContinuousArithmetic
import BlackwellDilemma.Infrastructure.MonotoneIntegralFOSD
import BlackwellDilemma.Infrastructure.ArgmaxExistence
import BlackwellDilemma.Infrastructure.FiniteConvexCombination
import BlackwellDilemma.Infrastructure.AbstractKernelMonotonicity
import BlackwellDilemma.Infrastructure.BernoulliProductFinite
import BlackwellDilemma.Infrastructure.UnitIntervalAlgebra
import BlackwellDilemma.Infrastructure.PercolationExpectation
import BlackwellDilemma.Infrastructure.MonotoneCDFAlgebra
import BlackwellDilemma.Infrastructure.FOSDLiftedExpectation
import BlackwellDilemma.Infrastructure.MaxOverFinset
import BlackwellDilemma.Infrastructure.TendstoFiniteSum
import BlackwellDilemma.Infrastructure.PiecewiseFunction
import BlackwellDilemma.Infrastructure.NonNegativeRealAlgebra
import BlackwellDilemma.Infrastructure.AbsValueBounds
import BlackwellDilemma.Infrastructure.CalculusTopkis
import BlackwellDilemma.Infrastructure.LebesgueStieltjesAtoms
import BlackwellDilemma.Infrastructure.IntegerLattice
import BlackwellDilemma.Infrastructure.BondPercolationLattice
import BlackwellDilemma.Infrastructure.OrderStatisticsAlgebraicBound
import BlackwellDilemma.Infrastructure.TerminalNeighbourTopology
