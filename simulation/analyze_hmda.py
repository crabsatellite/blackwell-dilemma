"""
HMDA Mortgage Data Analysis — Welfare Loss Distribution in High-Irreversibility Domain
========================================================================================
Mortgages are the archetypal high-irreversibility consumer decision:
- 30-year commitment
- High switching costs (refinancing fees, appraisal, closing costs)
- Information asymmetry (complex products, opaque pricing)

Key metric: rate_spread = borrower's APR minus Average Prime Offer Rate (APOR)
- rate_spread > 0: borrower pays above-market rate → welfare loss proxy
- Higher rate_spread = worse deal = more "welfare loss"
- This is the closest available proxy for "how far from optimal" each borrower's outcome is

If the phase transition theory is correct:
- The rate_spread distribution should be RIGHT-SKEWED or BIMODAL
  (most people near market rate, but a fat tail of people paying way too much)
- This contrasts with what we'd expect in a low-irreversibility domain (tight unimodal)
"""

import pandas as pd
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from scipy import stats
from pathlib import Path

DATA_DIR = Path(__file__).parent.parent / "data" / "hmda"
OUT_DIR = Path(__file__).parent.parent / "results"
OUT_DIR.mkdir(exist_ok=True)


def load_hmda():
    """Load HMDA data with relevant columns."""
    cols = ['interest_rate', 'rate_spread', 'loan_amount', 'loan_term',
            'income', 'debt_to_income_ratio', 'loan_type', 'loan_purpose',
            'property_value', 'occupancy_type', 'derived_race', 'derived_sex',
            'applicant_age', 'loan_to_value_ratio', 'lien_status',
            'total_loan_costs', 'origination_charges']

    df = pd.read_csv(DATA_DIR / "hmda_ny_2022_originated.csv",
                     usecols=cols, low_memory=False)
    print(f"Loaded {len(df):,} rows")

    # Convert numeric columns
    for col in ['interest_rate', 'rate_spread', 'loan_amount', 'income',
                'property_value', 'total_loan_costs', 'origination_charges']:
        df[col] = pd.to_numeric(df[col], errors='coerce')

    return df


def analyze_rate_spread(df):
    """Analyze rate_spread distribution — the key welfare loss proxy."""
    # Filter to first-lien, home purchase, conventional loans (cleanest comparison)
    mask = (
        (df['loan_purpose'] == 1) &          # home purchase
        (df['lien_status'] == 1) &            # first lien
        (df['loan_type'] == 1) &              # conventional
        (df['occupancy_type'] == 1) &         # principal residence
        df['rate_spread'].notna() &
        (df['rate_spread'] > -2) &
        (df['rate_spread'] < 10)              # remove extreme outliers
    )
    clean = df[mask]['rate_spread'].values
    print(f"\nClean rate_spread sample: {len(clean):,} loans")
    print(f"  Mean: {clean.mean():.4f}")
    print(f"  Median: {np.median(clean):.4f}")
    print(f"  Std: {clean.std():.4f}")
    print(f"  Skewness: {stats.skew(clean):.4f}")
    print(f"  Kurtosis: {stats.kurtosis(clean):.4f}")
    print(f"  P10: {np.percentile(clean, 10):.4f}")
    print(f"  P90: {np.percentile(clean, 90):.4f}")

    # Bimodality coefficient
    skew = stats.skew(clean)
    kurt = stats.kurtosis(clean, fisher=False)  # Pearson
    bc = (skew**2 + 1) / kurt if kurt != 0 else 0
    print(f"  Bimodality Coeff: {bc:.4f} ({'BIMODAL' if bc > 5/9 else 'UNIMODAL'} threshold=0.556)")

    return clean


def analyze_origination_costs(df):
    """Analyze total loan costs as alternative welfare metric."""
    mask = (
        (df['loan_purpose'] == 1) &
        (df['lien_status'] == 1) &
        (df['loan_type'] == 1) &
        (df['occupancy_type'] == 1) &
        df['total_loan_costs'].notna() &
        (df['total_loan_costs'] > 0) &
        (df['total_loan_costs'] < 50000) &     # reasonable range
        df['loan_amount'].notna() &
        (df['loan_amount'] > 0)
    )
    clean = df[mask].copy()
    # Normalize: costs as % of loan amount
    clean['cost_pct'] = clean['total_loan_costs'] / clean['loan_amount'] * 100
    cost_pct = clean['cost_pct'].values
    cost_pct = cost_pct[(cost_pct > 0) & (cost_pct < 15)]  # trim extremes

    print(f"\nLoan costs as % of amount: {len(cost_pct):,} loans")
    print(f"  Mean: {cost_pct.mean():.2f}%")
    print(f"  Median: {np.median(cost_pct):.2f}%")
    print(f"  Std: {cost_pct.std():.2f}%")
    print(f"  P10: {np.percentile(cost_pct, 10):.2f}%")
    print(f"  P90: {np.percentile(cost_pct, 90):.2f}%")

    return cost_pct


def plot_mortgage_welfare(rate_spread, cost_pct, filename="hmda_welfare_distribution.png"):
    """
    Plot mortgage welfare distributions — expect heavy right tail / bimodality
    consistent with high-irreversibility domain prediction.
    """
    fig, axes = plt.subplots(2, 2, figsize=(14, 10))

    # Panel 1: Rate spread histogram
    ax = axes[0, 0]
    ax.hist(rate_spread, bins=100, density=True, alpha=0.7, color='steelblue',
            edgecolor='black', linewidth=0.2)
    ax.axvline(np.median(rate_spread), color='red', linestyle='--', linewidth=1.5,
               label=f'Median={np.median(rate_spread):.2f}')
    ax.axvline(np.mean(rate_spread), color='orange', linestyle='--', linewidth=1.5,
               label=f'Mean={np.mean(rate_spread):.2f}')
    ax.set_xlabel('Rate Spread (APR − APOR, percentage points)', fontsize=11)
    ax.set_ylabel('Density', fontsize=11)
    ax.set_title('Mortgage Rate Spread Distribution\n(High-Irreversibility Domain)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    # Panel 2: Rate spread — log scale to see tail
    ax = axes[0, 1]
    positive_spread = rate_spread[rate_spread > 0]
    ax.hist(positive_spread, bins=100, density=True, alpha=0.7, color='coral',
            edgecolor='black', linewidth=0.2)
    ax.set_yscale('log')
    ax.set_xlabel('Rate Spread (positive only)', fontsize=11)
    ax.set_ylabel('Density (log scale)', fontsize=11)
    ax.set_title('Right Tail Analysis\n(heavy tail = catastrophic welfare loss for some)', fontsize=11)
    ax.grid(True, alpha=0.3)

    # Panel 3: Loan costs as % of amount
    ax = axes[1, 0]
    ax.hist(cost_pct, bins=100, density=True, alpha=0.7, color='forestgreen',
            edgecolor='black', linewidth=0.2)
    ax.axvline(np.median(cost_pct), color='red', linestyle='--', linewidth=1.5,
               label=f'Median={np.median(cost_pct):.1f}%')
    ax.set_xlabel('Total Loan Costs (% of loan amount)', fontsize=11)
    ax.set_ylabel('Density', fontsize=11)
    ax.set_title('Loan Cost Distribution\n(Alternative welfare metric)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    # Panel 4: QQ plot — if normal, points lie on line; if heavy-tailed, points curve up
    ax = axes[1, 1]
    sorted_data = np.sort(rate_spread)
    n = len(sorted_data)
    theoretical = stats.norm.ppf(np.linspace(0.001, 0.999, n))
    # Subsample for plotting
    step = max(1, n // 2000)
    ax.scatter(theoretical[::step], sorted_data[::step], s=1, alpha=0.5, color='steelblue')
    # Reference line
    slope, intercept = np.polyfit(theoretical[n//4:3*n//4:step],
                                   sorted_data[n//4:3*n//4:step], 1)
    ax.plot(theoretical[::step], slope * theoretical[::step] + intercept,
            'r-', linewidth=1.5, label='Normal reference')
    ax.set_xlabel('Theoretical Normal Quantiles', fontsize=11)
    ax.set_ylabel('Rate Spread Quantiles', fontsize=11)
    ax.set_title('QQ Plot: Rate Spread vs Normal\n(Right tail deviation = heavy tail)', fontsize=11)
    ax.legend(fontsize=9)
    ax.grid(True, alpha=0.3)

    plt.suptitle('Mortgage Market: Welfare Loss Distribution (HMDA NY 2022)\n'
                 'HIGH IRREVERSIBILITY DOMAIN — Theory predicts right-skewed / heavy-tailed',
                 fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.savefig(OUT_DIR / filename, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"\nSaved: {OUT_DIR / filename}")


def compute_welfare_loss_by_group(df):
    """
    Compare rate spread distributions across borrower groups.
    If irreversibility is the mechanism, ALL groups should show heavy tails
    (it's the market structure, not the borrower).
    """
    mask = (
        (df['loan_purpose'] == 1) &
        (df['lien_status'] == 1) &
        (df['loan_type'] == 1) &
        (df['occupancy_type'] == 1) &
        df['rate_spread'].notna() &
        (df['rate_spread'] > -2) &
        (df['rate_spread'] < 10) &
        df['income'].notna() &
        (df['income'] > 0)
    )
    clean = df[mask].copy()

    # Income quartiles
    clean['income_q'] = pd.qcut(clean['income'], 4, labels=['Q1 (low)', 'Q2', 'Q3', 'Q4 (high)'])

    print("\nRate spread by income quartile:")
    for q in ['Q1 (low)', 'Q2', 'Q3', 'Q4 (high)']:
        subset = clean[clean['income_q'] == q]['rate_spread']
        skew = stats.skew(subset)
        print(f"  {q}: mean={subset.mean():.3f}, std={subset.std():.3f}, "
              f"skew={skew:.3f}, P90={subset.quantile(0.9):.3f}")

    return clean


if __name__ == "__main__":
    print("=" * 70)
    print("HMDA Mortgage Data Analysis — High-Irreversibility Domain")
    print("=" * 70)

    df = load_hmda()

    print("\n--- Rate Spread Analysis ---")
    rate_spread = analyze_rate_spread(df)

    print("\n--- Origination Cost Analysis ---")
    cost_pct = analyze_origination_costs(df)

    print("\n--- Plotting ---")
    plot_mortgage_welfare(rate_spread, cost_pct)

    print("\n--- Group Analysis ---")
    compute_welfare_loss_by_group(df)

    print("\n" + "=" * 70)
    print("HMDA ANALYSIS COMPLETE")
    print("=" * 70)
