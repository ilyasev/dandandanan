<!-- PROTOTYPE - NOT FOR PRODUCTION -->
<!-- Question: is walking two isometric rooms (with a blackout switch between them) not empty — does the player search on their own? -->
<!-- Date: 2026-11-13 -->

# Concept Prototype Report: Тот, кто просыпается — isometric walking (woken-iso-concept)

> **Date**: 2026-11-13
> **Prototype Path**: Engine (Godot 4.7.2, GDScript)
> **Concept File**: design/game-brief.md (not yet updated for the new form)
> **Pivot chain**: `prototypes/woken-concept/` (PIVOT) → this prototype

---

## Hypothesis

If the player walks the businessman's office, passes out, then walks the addict's room, they
search for objects and links themselves — evidenced by the player, unprompted, examining more
than half of the interactable objects in the second room (4+ of 6), and the walking between
conversations not feeling empty.

---

## Riskiest Assumption Tested

That walking is not empty — that moving and examining is interesting in itself, not just the road
from one text to the next. It held: 6 of 6 examined, walking "вроде норм".

---

## Approach

Two isometric rooms drawn from simple shapes (floor diamond, walls, box objects, figures). Click
to walk (click an object to walk up and examine), WASD too, hover shows names; grid pathfinding
(AStarGrid2D). Text pops up in a right-side panel. Office: window, door, desk with the stopped
watch, Лиза, bar, sofa; blackout by drinking at the bar or lying on the sofa → fade, palette
switch. Room: mattress, window, mirror, jacket with a pawn ticket for a watch, Гоша, stool, door
→ end question and "examined N of 6". No named inner voices; one subtle mirror detail per scene.

**Path chosen:** Engine
**Reason for path:** the hypothesis is about how walking feels in isometric view, which only the engine can show.

**Shortcuts taken (intentional):**
- Shapes instead of art, no sound
- Story and room layouts hardcoded in one script
- No menus, no save

---

## Result

- All 6 objects in the second room examined: "я все 6 осмотрел".
- Walking and controls: "ходьба между предметами вроде норм, ощущение управления нормальное".
- Best moment: "Когда начал общаться и читать текст, так ощущалось как обычная игра такого плана".
- Worst: the balance of text and picture — "экран ходьбы и комнаты самой маленький"; "самое неудобное как раз таки текст и картинка, а остальное я плюс минус так и привык в играх видеть".
- The watch ↔ pawn ticket link was not noticed ("Связь между часами и билетом не заметил"): too subtle this time, where the first prototype was too direct.
- Some objects were "нативно непонятны, типо зеркала" — the player chose to keep them unobvious: "нет смысла их как то выделять пусть так и будут неочевидны".
- Bugs found in play: the end buttons could not be clicked (a fade overlay kept blocking input) and there was no way to quit. Fixed the same session; verified with real mouse clicks in a window; Esc and an "Выйти из игры" button added.
- Nothing unexpected.

---

## Metrics

| Metric | Value |
|--------|-------|
| Path used | Engine |
| Iterations to playable | 2 (pathfinding added after an auto-walk found the hero stuck behind furniture; end-screen input fix after play) |
| Prototype duration | ~1 sitting |
| Playtesters | 1 internal (the author — knew what to look for; no blind data) |
| Feel assessment | Walking and click-to-move "нормальное"; scene too small next to the text panel |
| Hypothesis verdict | CONFIRMED |

---

## Recommendation: PROCEED

Both risks are now covered across the two prototypes: the blackout switch lands (first prototype)
and walking two isometric rooms is not empty (6 of 6 examined, controls felt normal). What is left
— the text/picture balance and how strong the mirror details are — is tuning for development, not
a doubt about the concept. Caveat: the only tester is the author; a blind playtest should come
early in development.

---

## If Proceeding

- **Core tuning values discovered:** tile 72×36 px with the scene in the left 56% of the screen is too small — the room must be bigger on screen; walk speed 3.2 tiles/s and click-to-move felt normal.
- **Assumptions confirmed:** walking and examining holds interest; dialogue in a right-side text panel feels like a normal game of the genre; the blackout switch works in the world (bar / sofa).
- **Assumptions disproved:** the brief's "text novel, static scene frame, inner voices" form (first prototype); a single "watch ↔ ticket for a watch" pair is too subtle on its own.
- **Emergent mechanics:** none new; the "examined N of 6" counter is a useful playtest signal to keep in debug builds.

**Order of work the player chose:** the script first (scenes for both heroes, objects, blackouts,
mirror details, ending), then the art style and generated images (`/art-bible`, `/asset-spec`),
then assembly. Code for walking, the text panel, the switch and data-driven scenes can be built in
parallel on placeholders. Production code is written fresh; nothing is copied from this prototype.

---

## Lessons Learned

- **What assumptions were broken by actually building this?**
  That a straight-line walk is enough: the auto-walk got the hero stuck behind the desk and the stool; any real build needs pathfinding.
- **What surprised us that didn't show up in the brainstorm?**
  Nothing for the player; for the build, that a programmatic test pressed buttons a real mouse could not reach — input checks need real clicks in a window.
- **What would we test differently next time?**
  A blind tester; and a bigger on-screen scene with the text panel shown only when needed.

---

> *Prototype code location: `prototypes/woken-iso-concept/`*
> *This code is throwaway. Never refactor into production.*
