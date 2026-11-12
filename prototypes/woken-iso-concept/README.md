<!-- PROTOTYPE - NOT FOR PRODUCTION -->
<!-- Question: is walking two isometric rooms (with a blackout switch between them) not empty — does the player search on their own? -->
<!-- Date: 2026-11-13 -->

# woken-iso-concept — «Тот, кто просыпается», second prototype

**Status:** concluded — PROCEED (see REPORT.md)
**Carries forward:** `../woken-concept/PIVOT-NOTE.md` (first prototype: PIVOT)

## Hypothesis
If the player walks the businessman's office, passes out, then walks the addict's room, they
search for objects and links themselves. True if, unprompted, they examine more than half of the
interactable objects in the second room (4+ of 6) and the walking between conversations does not
feel empty.

## How to run
Open this folder (`prototypes/woken-iso-concept/`) as its own project in Godot 4.7.2, press F5. Or:

```
"E:/ilya/games/SteamLibrary/steamapps/common/Godot Engine/godot.windows.opt.tools.64.exe" --path prototypes/woken-iso-concept --windowed --resolution 1280x720
```

Click the floor to walk, click an object or a person to walk up and examine; WASD also moves.
The blackout: drink at the bar or lie on the sofa. In the room, leave through the door to end.
The end screen shows "examined N of 6"; the console prints `[PROTOTYPE] answer=… examined=…`.
Esc quits at any time; the end screen also has an "Выйти из игры" button.

## What is in it
- Office (blue): window, door, desk with the stopped watch, Лиза, bar, sofa
- Blackout in the world (bar or sofa) → fade, palette switch
- Room (ochre): mattress, window, mirror, jacket with the pawn ticket, Гоша, stool, door
- One subtle mirror detail per scene (the watch ↔ a pawn ticket for a watch); no named voices

## Findings
Hypothesis confirmed: 6 of 6 examined, walking and controls felt normal. Scene too small next to the text panel; watch ↔ ticket link too subtle. Full findings in REPORT.md.
