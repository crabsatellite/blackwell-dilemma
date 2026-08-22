/- Current Theory and Decision paper coverage gate. -/

import BlackwellDilemma.TheoremMap

namespace BlackwellDilemma.CurrentPaperLedger

theorem currentPaper_status_gate :
    currentPaperEntries.length = 10 /\
      currentPaperLabels.Nodup /\
      currentPaperUnfinished.length = 0 /\
      currentPaperClosed.length = 10 := by
  exact ⟨currentPaper_count, currentPaper_labels_nodup,
    currentPaper_no_unfinished, currentPaper_all_closed⟩

#eval s!"current-paper theory map: entries={currentPaperEntries.length} " ++
  s!"closed={currentPaperClosed.length} " ++
  s!"unfinished={currentPaperUnfinished.length}"

#eval currentPaperEntries.forM fun entry =>
  IO.println s!"current-paper binding={entry.label}|{entry.binding}"

end BlackwellDilemma.CurrentPaperLedger
