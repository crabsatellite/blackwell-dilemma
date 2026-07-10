/-
  BlackwellDilemma/PaperSemanticGate.lean

  Small proof-derived gate for the manuscript claim ledger. The old gate used
  editable open/closed strings and thousands of bridge certificates. This gate
  has one rule: a paper claim is closed exactly when its ledger evidence is a
  `ClaimEvidence.proved statement proof` value.
-/

import BlackwellDilemma.Ledger
import BlackwellDilemma.UnifiedIDP
import BlackwellDilemma.UnifiedWelfare

namespace BlackwellDilemma.PaperSemanticGate

open BlackwellDilemma.Ledger

theorem claim_isClosed_iff_fullProofFlag (claim : PaperClaim) :
    claim.isClosed = true <-> claim.evidence.hasFullProof = true := by
  rw [claim.isClosed_eq_hasFullProof]

theorem completePaperKernelOnly_iff_all_claims_have_proofs :
    CompletePaperKernelOnly <->
      forall claim : PaperClaim, claim ∈ paperClaims ->
        claim.evidence.hasFullProof = true := by
  constructor
  · intro hComplete claim hMember
    exact (claim_isClosed_iff_fullProofFlag claim).mp
      (hComplete claim hMember)
  · intro hProofs claim hMember
    exact (claim_isClosed_iff_fullProofFlag claim).mpr
      (hProofs claim hMember)

theorem completePaperKernelOnly_notYet_current :
    Not CompletePaperKernelOnly :=
  completePaperKernelOnly_notYet

theorem paperClaimMachineLedgerGate :
    paperClaims.length = 26 /\
      paperClaimLabels.Nodup /\
      Not CompletePaperKernelOnly := by
  exact ⟨paperClaims_count, paperClaimLabels_nodup,
    completePaperKernelOnly_notYet_current⟩

#eval IO.println
  s!"paper_claim_gate=total:{paperClaims.length},closed:{paperClaimClosedCount},partial:{paperClaimPartialCount},conditional:{paperClaimConditionalCount},refuted-encoding:{paperClaimRefutedEncodingCount},unformalized:{paperClaimUnformalizedCount}"

#eval paperClaims.forM fun claim =>
  IO.println
    s!"paper_claim={claim.label}|{claimStateName claim.state}|{workClassName claim.route}"

#eval paperClaims.forM fun claim =>
  IO.println
    s!"paper_claim_meta={claim.label}|{claimKindName claim.kind}|{claim.sourceLine}"

end BlackwellDilemma.PaperSemanticGate
