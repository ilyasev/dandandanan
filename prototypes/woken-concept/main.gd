# PROTOTYPE - NOT FOR PRODUCTION
# Question: does the blackout switch between two lives make the player curious, not confused?
# Date: 2026-11-13
extends Control

# --- Palettes (hardcoded on purpose: prototype) ---
const PAL_BIZ := {
	"bg": Color("#16222e"), "panel": Color(0.05, 0.08, 0.12, 0.88),
	"text": Color("#c9d8e6"), "accent": Color("#6fa8d6"), "art": Color("#2a4258"),
}
const PAL_ADDICT := {
	"bg": Color("#2e2212"), "panel": Color(0.10, 0.07, 0.03, 0.88),
	"text": Color("#e6d2a8"), "accent": Color("#c9963f"), "art": Color("#5a4220"),
}
const PAL_END := {
	"bg": Color("#0d0d0d"), "panel": Color(0, 0, 0, 0.0),
	"text": Color("#dddddd"), "accent": Color("#aaaaaa"), "art": Color("#1a1a1a"),
}

# Inner voices. РАСЧЁТ belongs to the businessman, ГОЛОД to the addict.
# The one hint: РАСЧЁТ speaks once inside the addict's head.
const VOICES := {
	"РАСЧЁТ": "#8fd3ff",
	"ГОЛОД": "#c8c85a",
}

# Story graph. Each node: lines [[speaker, text]], then choices [[label, next]] or next.
# next: node id, "@blackout:<id>" to switch lives, "@end" for the final question.
var nodes := {
	# ---------- БИЗНЕСМЕН ----------
	"b1": {"lines": [
		["", "Сорок второй этаж. Стекло от пола до потолка. Город внизу похож на схему, которую ты сам начертил."],
		["Лиза", "Господин Ветров, совет директоров через десять минут. Они хотят закрыть завод в Кольцове."],
	], "choices": [
		["«Закрываем. Цифры не врут.»", "b2a"],
		["«Сколько там людей?»", "b2b"],
	]},
	"b2a": {"lines": [
		["Лиза", "Хорошо. Я подготовлю документы."],
		["РАСЧЁТ", "Правильно. Люди — это строка в таблице. Ты всегда умел не читать строки."],
	], "next": "b3"},
	"b2b": {"lines": [
		["Лиза", "Четыреста двенадцать."],
		["РАСЧЁТ", "Четыреста двенадцать — это строка в таблице. Ты всегда умел не читать строки."],
	], "next": "b3"},
	"b3": {"lines": [
		["", "Ты смотришь на часы. Старые, дедовские, на потёртом ремешке — единственная вещь в кабинете дешевле стола."],
		["", "Стрелки стоят. 4:17. Опять."],
		["Лиза", "Может, отдать их в ремонт?"],
	], "choices": [
		["«Нет. Они остаются со мной.»", "b4"],
		["«Не твоё дело.»", "b4"],
	]},
	"b4": {"lines": [
		["", "Лиза уходит. Голова гудит третью ночь подряд."],
		["", "В нижнем ящике стола — бутылка, которую ты держишь для партнёров."],
		["РАСЧЁТ", "Один глоток. Ты заслужил тишину."],
	], "choices": [
		["Выпить", "b5_drink"],
		["Терпеть", "b5_endure"],
	]},
	"b5_drink": {"lines": [
		["", "Первый глоток обжигает. Второй — уже нет."],
		["", "Окно плывёт. Город сползает вниз, как мокрая краска по стеклу…"],
	], "next": "@blackout:a1"},
	"b5_endure": {"lines": [
		["", "Ты закрываешь ящик. Совет. Подписи. Вечер."],
		["", "Дома ты падаешь на кровать прямо в костюме, и темнота приходит сама, без спроса…"],
	], "next": "@blackout:a1"},

	# ---------- НАРКОМАН ----------
	"a1": {"lines": [
		["", "Потолок в жёлтых разводах. Пахнет сыростью и чужими сигаретами."],
		["", "Ты не помнишь, как сюда попал. Но тело помнит — тело всегда помнит."],
		["ГОЛОД", "Вставай. Нужно найти. Ты знаешь что."],
		["Гоша", "Ветер, живой? Ты вчера опять отключился посреди фразы. Говорил что-то про завод. Какой завод, Ветер?"],
	], "choices": [
		["«Не знаю. Приснилось.»", "a2a"],
		["«Сколько я был в отключке?»", "a2b"],
	]},
	"a2a": {"lines": [
		["Гоша", "Ну да. Тебе всегда что-то снится."],
	], "next": "a3"},
	"a2b": {"lines": [
		["Гоша", "Часов двенадцать. Как обычно."],
	], "next": "a3"},
	"a3": {"lines": [
		["", "В кармане джинсов — смятая бумажка. Залоговый билет ломбарда «Фортуна»."],
		["", "«Часы наручные, жёлтый металл, ремешок потёртый. Гравировка: „В. от деда“. Выкупить до 17.04.»"],
	], "choices": [
		["Перечитать гравировку", "a4a"],
		["Скомкать и выбросить", "a4b"],
	]},
	"a4a": {"lines": [
		["РАСЧЁТ", "Четыре семнадцать. Ты же помнишь, когда они остановились."],
		["", "Ты не помнишь. Ты не знаешь, откуда этот голос — такой ровный, такой чужой."],
		["ГОЛОД", "Плевать. Часы — это доза. Выкупишь потом. Или никогда."],
	], "next": "a5"},
	"a4b": {"lines": [
		["", "Бумажка не летит. Падает у ног."],
		["РАСЧЁТ", "Выбросишь — и что останется? Четыре семнадцать. Ты же помнишь, когда они остановились."],
		["ГОЛОД", "Не слушай. Это не твой голос. Тебе нужно другое."],
	], "next": "a5"},
	"a5": {"lines": [
		["Гоша", "Есть кое-что. Последнее. Будешь?"],
	], "choices": [
		["«Буду.»", "a6_yes"],
		["«Нет. Хватит.»", "a6_no"],
	]},
	"a6_yes": {"lines": [
		["", "Мир становится мягким и далёким."],
		["", "Последнее, что ты видишь, — свет за окном. Ровный и холодный, как стекло сорок второго этажа."],
	], "next": "@end"},
	"a6_no": {"lines": [
		["", "Ты отворачиваешься к стене. Сон приходит тяжело."],
		["", "Снится стекло. Много стекла."],
	], "next": "@end"},
}

var pal: Dictionary = PAL_BIZ
var bg: ColorRect
var art: Control
var location: Label
var panel: ColorRect
var log_label: RichTextLabel
var buttons: VBoxContainer
var overlay: ColorRect

var current: Dictionary
var line_i := 0
var choices_made: Array[String] = []


func _ready() -> void:
	_build_ui()
	_apply_palette(PAL_BIZ)
	_draw_office()
	_goto("b1")


func _build_ui() -> void:
	bg = ColorRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	art = Control.new()
	art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(art)

	location = Label.new()
	location.position = Vector2(40, 30)
	location.add_theme_font_size_override("font_size", 18)
	add_child(location)

	panel = ColorRect.new()
	panel.anchor_left = 0.52
	panel.anchor_right = 1.0
	panel.anchor_bottom = 1.0
	add_child(panel)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 28)
	panel.add_child(margin)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 16)
	margin.add_child(col)

	log_label = RichTextLabel.new()
	log_label.bbcode_enabled = true
	log_label.scroll_following = true
	log_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	for key in ["normal_font_size", "bold_font_size", "italics_font_size", "bold_italics_font_size"]:
		log_label.add_theme_font_size_override(key, 19)
	col.add_child(log_label)

	buttons = VBoxContainer.new()
	buttons.add_theme_constant_override("separation", 8)
	col.add_child(buttons)

	overlay = ColorRect.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0, 0, 0, 0)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(overlay)


func _apply_palette(p: Dictionary) -> void:
	pal = p
	bg.color = p.bg
	panel.color = p.panel
	location.add_theme_color_override("font_color", p.accent)
	log_label.add_theme_color_override("default_color", p.text)


# --- Placeholder "art": rectangles only ---
func _rect(pos: Vector2, size: Vector2, color: Color) -> void:
	var r := ColorRect.new()
	r.position = pos
	r.size = size
	r.color = color
	art.add_child(r)


func _clear_art() -> void:
	for c in art.get_children():
		c.queue_free()


func _draw_office() -> void:
	_clear_art()
	location.text = "КАБИНЕТ · 42 ЭТАЖ"
	var glass := Color("#2c4a66")
	_rect(Vector2(60, 90), Vector2(520, 420), glass)  # window
	for i in range(1, 4):  # window frames
		_rect(Vector2(60 + i * 130, 90), Vector2(4, 420), Color("#0f1922"))
	for i in range(8):  # city below
		_rect(Vector2(80 + i * 62, 380 - (i * 37) % 120), Vector2(40, 130 + (i * 37) % 120), Color("#1d3348"))
	_rect(Vector2(40, 540), Vector2(560, 30), Color("#0b1118"))  # desk
	_rect(Vector2(470, 520), Vector2(36, 20), Color("#b08d3a"))  # the watch, the one warm thing


func _draw_room() -> void:
	_clear_art()
	location.text = "КОМНАТА · ПЕРВЫЙ ЭТАЖ"
	_rect(Vector2(90, 70), Vector2(140, 60), Color("#4a3818"))  # stains
	_rect(Vector2(330, 120), Vector2(90, 40), Color("#4a3818"))
	_rect(Vector2(420, 120), Vector2(140, 300), Color("#1c140a"))  # doorway
	_rect(Vector2(60, 500), Vector2(420, 70), Color("#6b5530"))  # mattress
	_rect(Vector2(150, 540), Vector2(40, 22), Color("#d8cfb8"))  # the pawn ticket
	_rect(Vector2(150, 150), Vector2(120, 90), Color("#8a8a7a"))  # small window, cold light


# --- Story flow ---
func _goto(next: String) -> void:
	if next == "@end":
		_end_screen()
	elif next.begins_with("@blackout:"):
		_blackout(next.get_slice(":", 1))
	else:
		current = nodes[next]
		line_i = 0
		_next_line()


func _next_line() -> void:
	_clear_buttons()
	var lines: Array = current.lines
	if line_i < lines.size():
		_append_line(lines[line_i][0], lines[line_i][1])
		line_i += 1
	if line_i < lines.size():
		_add_button("Далее ▸", _next_line)
	elif current.has("choices"):
		var n := 1
		for ch in current.choices:
			var label: String = ch[0]
			var target: String = ch[1]
			_add_button("%d. %s" % [n, label], func(): _choose(label, target))
			n += 1
	else:
		_add_button("Далее ▸", func(): _goto(current.next))


func _choose(label: String, target: String) -> void:
	choices_made.append(label)
	log_label.append_text("[color=#%s]— %s[/color]\n\n" % [pal.accent.to_html(false), label])
	_goto(target)


func _append_line(speaker: String, text: String) -> void:
	if speaker == "":
		log_label.append_text("%s\n\n" % text)
	elif VOICES.has(speaker):
		log_label.append_text("[color=%s][b]%s[/b] — [i]%s[/i][/color]\n\n" % [VOICES[speaker], speaker, text])
	else:
		log_label.append_text("[b]%s:[/b] %s\n\n" % [speaker, text])


func _clear_buttons() -> void:
	for c in buttons.get_children():
		c.queue_free()


func _add_button(text: String, cb: Callable) -> void:
	var b := Button.new()
	b.text = text
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	b.add_theme_font_size_override("font_size", 18)
	b.pressed.connect(cb)
	buttons.add_child(b)


func _blackout(target: String) -> void:
	_clear_buttons()
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	var t := create_tween()
	t.tween_property(overlay, "color:a", 1.0, 1.6)
	t.tween_interval(1.4)
	t.tween_callback(func():
		log_label.clear()
		_apply_palette(PAL_ADDICT)
		_draw_room())
	t.tween_property(overlay, "color:a", 0.0, 2.2)
	t.tween_callback(func():
		overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_goto(target))


func _end_screen() -> void:
	_clear_buttons()
	var t := create_tween()
	t.tween_property(overlay, "color:a", 1.0, 1.6)
	t.tween_callback(func():
		_clear_art()
		location.text = ""
		log_label.clear()
		_apply_palette(PAL_END)
		log_label.append_text("\n\n[center][font_size=30]Один это человек или двое?[/font_size][/center]\n"))
	t.tween_property(overlay, "color:a", 0.0, 1.2)
	t.tween_callback(func():
		for ans in ["Один", "Двое", "Не знаю"]:
			_add_button(ans, func(): _record(ans)))


func _record(answer: String) -> void:
	_clear_buttons()
	print("[PROTOTYPE] answer=%s choices=%s" % [answer, choices_made])
	log_label.append_text("\n[center]Ответ записан: %s.\n\nКонец прототипа. Расскажите, что вы заметили.[/center]" % answer)
