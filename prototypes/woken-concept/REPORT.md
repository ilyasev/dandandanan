<!-- PROTOTYPE - NOT FOR PRODUCTION -->
<!-- Question: does the blackout switch between two lives make the player curious, not confused? -->
<!-- Date: 2026-11-13 -->

# Concept Prototype Report: Тот, кто просыпается (woken-concept)

> **Date**: 2026-11-13
> **Prototype Path**: Engine (Godot 4.7.2, GDScript)
> **Concept File**: design/game-brief.md

---

## Hypothesis

If the player passes out as the businessman and wakes up as the addict, they will want to find
the link between the two lives — evidenced by the player, unprompted, naming a mirror detail,
stating a theory (one person or two) and wanting to continue.

---

## Riskiest Assumption Tested

That the blackout switch makes the player curious, not confused. It held: the transition was
"пойдёт", the link was noticed, and the player wanted to see where it goes.

---

## Approach

One pair of scenes (~4–5 min): businessman scene (blue) → drink or endure (both lead to
blackout) → fade and palette switch → addict scene (ochre) → final question "Один это человек
или двое?". Mirror detail: the grandfather's watch stopped at 4:17 ↔ a pawn ticket for the same
watch, "В. от деда", due 17.04. Extra hints: surname Ветров ↔ nickname "Ветер"; the
businessman's named inner voice РАСЧЁТ speaking once in the addict's head. Built in one sitting.

**Path chosen:** Engine
**Reason for path:** Godot already installed; half the hook is the atmosphere of the switch
(fade, palette change), which a text-only paper prototype cannot test.

**Shortcuts taken (intentional):**
- Colored rectangles for all art, no sound
- Story hardcoded in one script, no save, no menus
- Text panel with click choices (visual novel form)

---

## Result

- The switch works: "переход в отключку пойдёт", no errors seen.
- The mirror detail is where the idea clicked: "про задумку я то понял после зеркальной детали как раз, после часов". But it is too on-the-nose: "с часами достаточно в лоб". It gave the answer instead of doubt.
- Ветров ↔ "Ветер" went unnoticed: "на ветер и ветров не особо обратил внимание". Overall too many hints for two scenes.
- The final question was answered "Не знаю" "просто чтобы посмотреть что будет": no theory was formed.
- Interest came from the story itself: "было просто интересно почитать к чему это идет. Что дальше конечно хочется узнать, игра то оборвана".
- Rejected: "Не понравилась полная калька концепции эмоций с диско элизиума" (the named inner voices), and the form: "не хочется чтоб это была визуальная новелла с текстом, хочется и походить за персонажей".
- Noted by the player: the concept lives mostly in the story, which they may write elsewhere and heavily edit.

---

## Metrics

| Metric | Value |
|--------|-------|
| Path used | Engine |
| Iterations to playable | 1 (no errors reported; both branches auto-walked to the end) |
| Prototype duration | ~1 sitting |
| Playtesters | 1 internal (the author — no blind first-impression data) |
| Feel assessment | Blackout transition acceptable ("пойдёт"); the watch reveal too direct; text-only form rejected |
| Hypothesis verdict | PARTIALLY CONFIRMED |

---

## Recommendation: PIVOT

The core holds: the switch lands and the link between the lives is noticed and creates the wish
to continue. The form does not: the player rejects the visual-novel format and the named inner
voices as a copy of the reference, and the mirror detail as built reveals rather than seeds doubt.
Keep the idea, change the form.

---

## If Pivoting

**Pivot direction:** 2D isometric scenes the player walks through as both heroes; the blackout
switch happens in the world, not in a text log. No named inner voices — find an original device.
Mirror details subtler, fewer per scene, spread across more scenes.
**What to keep:** the blackout switch and its fade/palette change; the two lives (cold blue ↔
dirty ochre); mirror details as the device that makes the idea click.
**Next step:** `/prototype` (reads `PIVOT-NOTE.md`)

---

## Lessons Learned

- **What assumptions were broken by actually building this?**
  That a strong mirror detail creates doubt. It creates recognition: the idea clicks, then the mystery is over.
- **What surprised us that didn't show up in the brainstorm?**
  Nothing unexpected; the clearest signal was that the reference (Disco Elysium) was taken too literally.
- **What would we test differently next time?**
  A blind tester who does not know the idea; and one subtle detail per scene rather than three at once.

---

> *Prototype code location: `prototypes/woken-concept/`*
> *This code is throwaway. Never refactor into production.*
