# PROTOTYPE - NOT FOR PRODUCTION
# Question: is walking two isometric rooms (with a blackout switch between them) not empty — does the player search on their own?
# Date: 2026-11-13
extends Node2D

# --- Iso projection (hardcoded on purpose: prototype) ---
const TW := 72.0
const TH := 36.0
const SPEED := 3.2          # tiles per second
const PLAYER_R := 0.25      # collision radius, tiles

const PAL_BIZ := {
	"bg": Color("#0f1820"), "floor": Color("#22374a"), "grid": Color("#2a4258"),
	"wall_l": Color("#1e3247"), "wall_r": Color("#2b4560"),
	"panel": Color(0.05, 0.08, 0.12, 0.92), "text": Color("#c9d8e6"), "accent": Color("#6fa8d6"),
	"hero": Color("#9fb4c8"), "hero_head": Color("#d8c8b0"),
}
const PAL_ADDICT := {
	"bg": Color("#1a1209"), "floor": Color("#4a3820"), "grid": Color("#55412a"),
	"wall_l": Color("#3e2e18"), "wall_r": Color("#5a4428"),
	"panel": Color(0.10, 0.07, 0.03, 0.92), "text": Color("#e6d2a8"), "accent": Color("#c9963f"),
	"hero": Color("#6e6a52"), "hero_head": Color("#c8b496"),
}

# Objects: kind box | npc | wall_r (on the gy=0 wall) | wall_l (on the gx=0 wall).
# box: g = footprint origin, s = footprint size, h = height px. npc: g = center.
# wall_*: a = start..end along the wall, y = bottom..top px above floor.
var rooms := {
	"office": {
		"name": "КАБИНЕТ · 42 ЭТАЖ", "pal": PAL_BIZ, "size": Vector2(9, 7), "start": Vector2(4.5, 5.0),
		"objects": [
			{"id": "window", "kind": "wall_r", "a": Vector2(1, 5), "y": Vector2(25, 105), "color": Color("#3d6a8f"), "label": "Окно", "spot": Vector2(3, 0.9), "node": "o_window"},
			{"id": "door", "kind": "wall_l", "a": Vector2(1.5, 2.7), "y": Vector2(0, 90), "color": Color("#121c26"), "label": "Дверь", "spot": Vector2(0.8, 2.1), "node": "o_door"},
			{"id": "desk", "kind": "box", "g": Vector2(3, 2), "s": Vector2(2, 1), "h": 26, "color": Color("#16232f"), "label": "Стол", "spot": Vector2(4, 3.6), "node": "o_desk", "detail": Color("#c9a24a")},
			{"id": "lisa", "kind": "npc", "g": Vector2(6.5, 4.5), "color": Color("#a07890"), "label": "Лиза", "spot": Vector2(6.5, 5.5), "node": "o_lisa"},
			{"id": "bar", "kind": "box", "g": Vector2(0.3, 4.5), "s": Vector2(0.8, 1.6), "h": 60, "color": Color("#2a2f36"), "label": "Бар", "spot": Vector2(1.7, 5.3), "node": "o_bar"},
			{"id": "sofa", "kind": "box", "g": Vector2(6, 0.4), "s": Vector2(2.4, 0.9), "h": 22, "color": Color("#1b2b3a"), "label": "Диван", "spot": Vector2(7.2, 1.9), "node": "o_sofa"},
		],
	},
	"room": {
		"name": "КОМНАТА · ПЕРВЫЙ ЭТАЖ", "pal": PAL_ADDICT, "size": Vector2(8, 6), "start": Vector2(5.8, 2.6),
		"objects": [
			{"id": "mattress", "kind": "box", "g": Vector2(4.5, 0.4), "s": Vector2(3, 1.5), "h": 10, "color": Color("#7a6238"), "label": "Матрас", "spot": Vector2(5.5, 2.5), "node": "r_mattress"},
			{"id": "window", "kind": "wall_r", "a": Vector2(1, 2.5), "y": Vector2(40, 95), "color": Color("#8a8f94"), "label": "Окно", "spot": Vector2(1.7, 0.8), "node": "r_window"},
			{"id": "mirror", "kind": "wall_l", "a": Vector2(2, 3), "y": Vector2(45, 100), "color": Color("#6f6a5e"), "label": "Зеркало", "spot": Vector2(0.8, 2.5), "node": "r_mirror"},
			{"id": "jacket", "kind": "box", "g": Vector2(2.5, 3.0), "s": Vector2(0.9, 0.6), "h": 4, "color": Color("#2f3a2a"), "label": "Куртка", "spot": Vector2(3.0, 2.4), "node": "r_jacket"},
			{"id": "gosha", "kind": "npc", "g": Vector2(6.5, 4.5), "color": Color("#8a4436"), "label": "Гоша", "spot": Vector2(5.6, 4.5), "node": "r_gosha"},
			{"id": "table", "kind": "box", "g": Vector2(1, 4.3), "s": Vector2(1, 1), "h": 24, "color": Color("#3a2c18"), "label": "Табурет", "spot": Vector2(2.6, 4.8), "node": "r_table"},
			{"id": "door", "kind": "wall_l", "a": Vector2(4, 5), "y": Vector2(0, 90), "color": Color("#1c140a"), "label": "Дверь", "spot": Vector2(0.8, 4.5), "node": "r_door"},
		],
	},
}
const ROOM_COUNTED := ["mattress", "window", "mirror", "jacket", "gosha", "table"]

# Story nodes: lines [[speaker, text]], then choices [[label, next]] or next.
# next: node id | "@close" | "@blackout" | "@end".
var nodes := {
	"intro": {"lines": [
		["", "Сорок второй этаж. Стекло от пола до потолка."],
		["", "[Кликните по полу, чтобы идти, или по предмету и человеку, чтобы подойти. WASD тоже работает.]"],
	], "next": "@close"},

	# ---------- OFFICE ----------
	"o_window": {"lines": [["", "Город внизу — сетка огней. Отсюда не видно людей. Только схема, которую ты сам начертил."]], "next": "@close"},
	"o_door": {"lines": [["", "Дверь в приёмную. За ней ждёт совет директоров."], ["", "Пока не время."]], "next": "@close"},
	"o_desk": {"lines": [
		["", "Пустой стол. Только старые часы на потёртом ремешке — единственная вещь в кабинете дешевле стола."],
		["", "Стрелки стоят. Ты не помнишь, когда они остановились. Ты никогда их не снимаешь."],
	], "next": "@close"},
	"o_lisa": {"lines": [["Лиза", "Господин Ветров, совет через десять минут. Они хотят закрыть завод в Кольцове."]], "choices": [
		["«Закрываем. Цифры не врут.»", "o_lisa_a"],
		["«Сколько там людей?»", "o_lisa_b"],
	]},
	"o_lisa_a": {"lines": [["Лиза", "Хорошо. Я подготовлю документы."]], "next": "@close"},
	"o_lisa_b": {"lines": [["Лиза", "Четыреста двенадцать."], ["", "Ты киваешь, как будто это просто число."]], "next": "@close"},
	"o_bar": {"lines": [["", "Бутылка, которую ты держишь для партнёров. Голова гудит третью ночь подряд."]], "choices": [
		["Выпить", "o_bar_drink"],
		["Не сейчас", "@close"],
	]},
	"o_bar_drink": {"lines": [["", "Первый глоток обжигает. Второй — уже нет. Пол уходит из-под ног…"]], "next": "@blackout"},
	"o_sofa": {"lines": [["", "Кожаный диван. Ты не спал третью ночь."]], "choices": [
		["Лечь на минуту", "o_sofa_lie"],
		["Не сейчас", "@close"],
	]},
	"o_sofa_lie": {"lines": [["", "Ты закрываешь глаза на минуту. Темнота приходит сама, без спроса…"]], "next": "@blackout"},

	# ---------- ROOM ----------
	"r_wake": {"lines": [
		["", "Потолок в жёлтых разводах. Пахнет сыростью и чужими сигаретами."],
		["", "Ты не помнишь, как сюда попал. Но тело помнит."],
	], "next": "@close"},
	"r_mattress": {"lines": [["", "Матрас на полу. Простыня сбита, будто на ней долго с кем-то боролись. Или с собой."]], "next": "@close"},
	"r_window": {"lines": [["", "Маленькое окно. Свет за ним ровный и холодный. Странно холодный для этой комнаты."]], "next": "@close"},
	"r_mirror": {"lines": [["", "Зеркало в трещинах. Лицо небритое, серое."], ["", "Ты смотришь долго — пока не начинает казаться, что оно моргает чуть позже тебя."]], "next": "@close"},
	"r_jacket": {"lines": [
		["", "Куртка на полу. В кармане — смятый залоговый билет ломбарда."],
		["", "«Часы наручные, жёлтый металл, ремешок потёртый»."],
	], "choices": [
		["Сунуть обратно", "r_jacket_keep"],
		["Скомкать", "r_jacket_crumple"],
	]},
	"r_jacket_keep": {"lines": [["", "Ты аккуратно складываешь билет и убираешь во внутренний карман. Сам не знаешь, зачем бережёшь эту бумажку."]], "next": "@close"},
	"r_jacket_crumple": {"lines": [["", "Ты сжимаешь бумажку в кулаке — и всё равно не выбрасываешь."]], "next": "@close"},
	"r_gosha": {"lines": [["Гоша", "Живой? Ты вчера отключился посреди фразы. Говорил что-то про завод."]], "choices": [
		["«Какой завод?»", "r_gosha_a"],
		["«Есть что-нибудь?»", "r_gosha_b"],
	]},
	"r_gosha_a": {"lines": [["Гоша", "Тебя спросить. Ты так говорил, будто сам его строил."]], "next": "@close"},
	"r_gosha_b": {"lines": [["Гоша", "Последнее. Дальше сам ищи."]], "next": "@close"},
	"r_table": {"lines": [["", "Табурет вместо стола. Ложка, зажигалка, пустой пакетик. Всё, что осталось от вчера."]], "next": "@close"},
	"r_door": {"lines": [["", "Дверь на лестницу. Сквозняк пахнет улицей."]], "choices": [
		["Выйти", "@end"],
		["Остаться", "@close"],
	]},
}

# --- State ---
var room_id := "office"
var room: Dictionary
var pal: Dictionary
var origin := Vector2(300, 230)
var player := Vector2.ZERO
var target = null                # Vector2 or null (final destination, for the marker)
var path: Array[Vector2] = []    # waypoints to target
var astar: AStarGrid2D
const CELL := 0.25               # nav grid cell, tiles
var pending_obj = null           # object to interact with on arrival
var hover_obj = null
var busy := false                # text with buttons on screen → no walking
var examined := {}
var room_enter_time := 0.0
var font: Font

# --- UI ---
var world: Node2D
var panel: ColorRect
var log_label: RichTextLabel
var buttons: VBoxContainer
var location: Label
var overlay: ColorRect
var current: Dictionary
var line_i := 0


func _ready() -> void:
	font = ThemeDB.fallback_font
	world = Node2D.new()
	add_child(world)
	world.draw.connect(_draw_world)
	_build_ui()
	_enter_room("office")
	_show_node("intro")


func _build_ui() -> void:
	var ui := CanvasLayer.new()
	add_child(ui)

	location = Label.new()
	location.position = Vector2(32, 24)
	location.add_theme_font_size_override("font_size", 18)
	ui.add_child(location)

	panel = ColorRect.new()
	panel.anchor_left = 0.56
	panel.anchor_right = 1.0
	panel.anchor_bottom = 1.0
	ui.add_child(panel)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 26)
	panel.add_child(margin)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	margin.add_child(col)

	log_label = RichTextLabel.new()
	log_label.bbcode_enabled = true
	log_label.scroll_following = true
	log_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	for key in ["normal_font_size", "bold_font_size", "italics_font_size", "bold_italics_font_size"]:
		log_label.add_theme_font_size_override(key, 18)
	col.add_child(log_label)

	buttons = VBoxContainer.new()
	buttons.add_theme_constant_override("separation", 8)
	col.add_child(buttons)

	overlay = ColorRect.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0, 0, 0, 0)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(overlay)


func _enter_room(id: String) -> void:
	room_id = id
	room = rooms[id]
	pal = room.pal
	player = room.start
	target = null
	pending_obj = null
	room_enter_time = Time.get_ticks_msec() / 1000.0
	RenderingServer.set_default_clear_color(pal.bg)
	panel.color = pal.panel
	location.text = room.name
	location.add_theme_color_override("font_color", pal.accent)
	log_label.add_theme_color_override("default_color", pal.text)
	var sz: Vector2 = room.size
	# Center the room diamond in the left area (x 0..~716).
	origin = Vector2(40 + sz.y * TW / 2 + (676 - (sz.x + sz.y) * TW / 2) / 2, 210)
	path.clear()
	_build_nav()


func _build_nav() -> void:
	var sz: Vector2 = room.size
	astar = AStarGrid2D.new()
	astar.region = Rect2i(0, 0, int(sz.x / CELL), int(sz.y / CELL))
	astar.cell_size = Vector2(1, 1)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.update()
	for x in range(astar.region.size.x):
		for y in range(astar.region.size.y):
			if _blocked(_cell_center(Vector2i(x, y))):
				astar.set_point_solid(Vector2i(x, y), true)


func _cell_center(c: Vector2i) -> Vector2:
	return Vector2((c.x + 0.5) * CELL, (c.y + 0.5) * CELL)


func _cell_of(g: Vector2) -> Vector2i:
	var r := astar.region.size
	return Vector2i(clampi(int(g.x / CELL), 0, r.x - 1), clampi(int(g.y / CELL), 0, r.y - 1))


func _walk_to(dest: Vector2) -> void:
	target = dest
	path.clear()
	var ids := astar.get_id_path(_cell_of(player), _cell_of(dest), true)
	for i in range(1, ids.size()):
		path.append(_cell_center(ids[i]))
	if path.is_empty() or not _blocked(dest):
		if not path.is_empty():
			path.pop_back()
		path.append(dest)


# --- Projection ---
func g2s(g: Vector2) -> Vector2:
	return origin + Vector2((g.x - g.y) * TW / 2, (g.x + g.y) * TH / 2)


func s2g(s: Vector2) -> Vector2:
	var d := s - origin
	var a := d.x / (TW / 2)
	var b := d.y / (TH / 2)
	return Vector2((a + b) / 2, (b - a) / 2)


# --- Geometry of objects ---
func _footprint(o: Dictionary) -> Rect2:
	if o.kind == "box":
		return Rect2(o.g, o.s)
	if o.kind == "npc":
		return Rect2(o.g - Vector2(0.3, 0.3), Vector2(0.6, 0.6))
	return Rect2()


func _hull(o: Dictionary) -> PackedVector2Array:
	var up := Vector2(0, -1)
	match o.kind:
		"box", "npc":
			var r := _footprint(o)
			var h: float = o.h if o.kind == "box" else 64.0
			var gx := r.position.x
			var gy := r.position.y
			var w := r.size.x
			var d := r.size.y
			return PackedVector2Array([
				g2s(Vector2(gx, gy + d)), g2s(Vector2(gx + w, gy + d)), g2s(Vector2(gx + w, gy)),
				g2s(Vector2(gx + w, gy)) + up * h, g2s(Vector2(gx, gy)) + up * h, g2s(Vector2(gx, gy + d)) + up * h,
			])
		"wall_r":
			return PackedVector2Array([
				g2s(Vector2(o.a.x, 0)) + up * o.y.x, g2s(Vector2(o.a.y, 0)) + up * o.y.x,
				g2s(Vector2(o.a.y, 0)) + up * o.y.y, g2s(Vector2(o.a.x, 0)) + up * o.y.y,
			])
		"wall_l":
			return PackedVector2Array([
				g2s(Vector2(0, o.a.x)) + up * o.y.x, g2s(Vector2(0, o.a.y)) + up * o.y.x,
				g2s(Vector2(0, o.a.y)) + up * o.y.y, g2s(Vector2(0, o.a.x)) + up * o.y.y,
			])
	return PackedVector2Array()


func _depth(o: Dictionary) -> float:
	if o.kind == "box":
		return o.g.x + o.s.x * 0.5 + o.g.y + o.s.y * 0.5
	if o.kind == "npc":
		return o.g.x + o.g.y
	return -100.0  # wall items are always behind


func _blocked(p: Vector2) -> bool:
	var sz: Vector2 = room.size
	if p.x < PLAYER_R or p.y < PLAYER_R or p.x > sz.x - PLAYER_R or p.y > sz.y - PLAYER_R:
		return true
	for o in room.objects:
		var r := _footprint(o)
		if r.size != Vector2.ZERO and r.grow(PLAYER_R).has_point(p):
			return true
	return false


func _object_at(screen: Vector2):
	var best = null
	var best_depth := -INF
	for o in room.objects:
		if Geometry2D.is_point_in_polygon(screen, _hull(o)) and _depth(o) > best_depth:
			best = o
			best_depth = _depth(o)
	return best


# --- Input & movement ---
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		hover_obj = _object_at(event.position)
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if busy or overlay.mouse_filter == Control.MOUSE_FILTER_STOP:
			return
		var o = _object_at(event.position)
		if o != null:
			pending_obj = o
			_walk_to(o.spot)
		else:
			pending_obj = null
			_walk_to(s2g(event.position))


func _process(delta: float) -> void:
	var walking_locked := busy or overlay.mouse_filter == Control.MOUSE_FILTER_STOP
	var dir := Vector2.ZERO
	if not walking_locked:
		if Input.is_physical_key_pressed(KEY_W): dir += Vector2(-1, -1)
		if Input.is_physical_key_pressed(KEY_S): dir += Vector2(1, 1)
		if Input.is_physical_key_pressed(KEY_A): dir += Vector2(-1, 1)
		if Input.is_physical_key_pressed(KEY_D): dir += Vector2(1, -1)
	if dir != Vector2.ZERO:
		target = null
		path.clear()
		pending_obj = null
		_step(dir.normalized() * SPEED * delta)
	elif not path.is_empty() and not walking_locked:
		var wp: Vector2 = path[0]
		var to: Vector2 = wp - player
		if to.length() < 0.06:
			player = wp
			path.pop_front()
			if path.is_empty():
				target = null
				_arrive()
		else:
			var moved := _step(to.normalized() * min(SPEED * delta, to.length()))
			if not moved:
				path.clear()
				target = null
				if pending_obj != null and player.distance_to(pending_obj.spot) < 1.2:
					_arrive()
				else:
					pending_obj = null
	world.queue_redraw()


func _step(v: Vector2) -> bool:
	var tries := [player + v, player + Vector2(v.x, 0), player + Vector2(0, v.y)]
	for p in tries:
		if not _blocked(p):
			player = p
			return true
	return false


func _arrive() -> void:
	if pending_obj == null:
		return
	var o: Dictionary = pending_obj
	pending_obj = null
	if room_id == "room" and o.id in ROOM_COUNTED:
		examined[o.id] = true
	_show_node(o.node)


# --- Drawing ---
func _poly(points: PackedVector2Array, color: Color) -> void:
	world.draw_colored_polygon(points, color)


func _draw_world() -> void:
	var sz: Vector2 = room.size
	var up := Vector2(0, -1)
	var wall_h := 130.0
	# Walls (back-left along gx=0, back-right along gy=0)
	_poly(PackedVector2Array([g2s(Vector2(0, 0)), g2s(Vector2(0, sz.y)), g2s(Vector2(0, sz.y)) + up * wall_h, g2s(Vector2(0, 0)) + up * wall_h]), pal.wall_l)
	_poly(PackedVector2Array([g2s(Vector2(0, 0)), g2s(Vector2(sz.x, 0)), g2s(Vector2(sz.x, 0)) + up * wall_h, g2s(Vector2(0, 0)) + up * wall_h]), pal.wall_r)
	# Floor + grid
	_poly(PackedVector2Array([g2s(Vector2(0, 0)), g2s(Vector2(sz.x, 0)), g2s(sz), g2s(Vector2(0, sz.y))]), pal.floor)
	for i in range(1, int(sz.x)):
		world.draw_line(g2s(Vector2(i, 0)), g2s(Vector2(i, sz.y)), pal.grid, 1.0)
	for j in range(1, int(sz.y)):
		world.draw_line(g2s(Vector2(0, j)), g2s(Vector2(sz.x, j)), pal.grid, 1.0)

	# Wall items first
	for o in room.objects:
		if o.kind.begins_with("wall"):
			_poly(_hull(o), o.color)
			if o == hover_obj:
				_outline(_hull(o))

	# Depth-sorted: boxes, npcs, player
	var drawables := []
	for o in room.objects:
		if not o.kind.begins_with("wall"):
			drawables.append([_depth(o), o])
	drawables.append([player.x + player.y, null])
	drawables.sort_custom(func(a, b): return a[0] < b[0])
	for d in drawables:
		if d[1] == null:
			_draw_figure(player, pal.hero, pal.hero_head)
		elif d[1].kind == "npc":
			_draw_figure(d[1].g, d[1].color, pal.hero_head.darkened(0.15))
			if d[1] == hover_obj:
				_outline(_hull(d[1]))
		else:
			_draw_box(d[1])

	# Click target marker
	if target != null:
		var t := g2s(target)
		world.draw_polyline(PackedVector2Array([t + Vector2(-8, 0), t + Vector2(0, -4), t + Vector2(8, 0), t + Vector2(0, 4), t + Vector2(-8, 0)]), pal.accent, 1.5)

	# Hover name
	if hover_obj != null:
		var hull := _hull(hover_obj)
		var top := hull[0]
		for p in hull:
			if p.y < top.y:
				top = p
		world.draw_string(font, top + Vector2(-30, -10), hover_obj.label, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, pal.accent)


func _draw_box(o: Dictionary) -> void:
	var up := Vector2(0, -1) * float(o.h)
	var gx: float = o.g.x
	var gy: float = o.g.y
	var w: float = o.s.x
	var d: float = o.s.y
	var c: Color = o.color
	var top := PackedVector2Array([g2s(Vector2(gx, gy)) + up, g2s(Vector2(gx + w, gy)) + up, g2s(Vector2(gx + w, gy + d)) + up, g2s(Vector2(gx, gy + d)) + up])
	var left := PackedVector2Array([g2s(Vector2(gx, gy + d)), g2s(Vector2(gx + w, gy + d)), g2s(Vector2(gx + w, gy + d)) + up, g2s(Vector2(gx, gy + d)) + up])
	var right := PackedVector2Array([g2s(Vector2(gx + w, gy)), g2s(Vector2(gx + w, gy + d)), g2s(Vector2(gx + w, gy + d)) + up, g2s(Vector2(gx + w, gy)) + up])
	_poly(left, c)
	_poly(right, c.darkened(0.3))
	_poly(top, c.lightened(0.18))
	if o.has("detail"):  # small warm thing on the desk: the watch
		var p := g2s(Vector2(gx + w * 0.7, gy + d * 0.5)) + up
		_poly(PackedVector2Array([p + Vector2(-7, 0), p + Vector2(0, -3.5), p + Vector2(7, 0), p + Vector2(0, 3.5)]), o.detail)
	if o == hover_obj:
		_outline(_hull(o))


func _draw_figure(g: Vector2, body: Color, head: Color) -> void:
	var f := g2s(g)
	# shadow
	_poly(PackedVector2Array([f + Vector2(-14, 0), f + Vector2(0, -7), f + Vector2(14, 0), f + Vector2(0, 7)]), Color(0, 0, 0, 0.3))
	# legs, coat, shoulders
	_poly(PackedVector2Array([f + Vector2(-7, 0), f + Vector2(-2, 0), f + Vector2(-2, -22), f + Vector2(-7, -22)]), body.darkened(0.35))
	_poly(PackedVector2Array([f + Vector2(2, 0), f + Vector2(7, 0), f + Vector2(7, -22), f + Vector2(2, -22)]), body.darkened(0.35))
	_poly(PackedVector2Array([f + Vector2(-10, -20), f + Vector2(10, -20), f + Vector2(12, -46), f + Vector2(-12, -46)]), body)
	# neck + head (a squared-off head, not a circle)
	_poly(PackedVector2Array([f + Vector2(-3, -46), f + Vector2(3, -46), f + Vector2(3, -50), f + Vector2(-3, -50)]), head.darkened(0.2))
	_poly(PackedVector2Array([f + Vector2(-7, -50), f + Vector2(7, -50), f + Vector2(6, -63), f + Vector2(0, -66), f + Vector2(-6, -63)]), head)


func _outline(points: PackedVector2Array) -> void:
	var closed := points.duplicate()
	closed.append(points[0])
	world.draw_polyline(closed, pal.accent, 2.0)


# --- Text panel ---
func _show_node(id: String) -> void:
	current = nodes[id]
	line_i = 0
	busy = true
	log_label.append_text("[color=#%s]────────[/color]\n" % pal.accent.darkened(0.4).to_html(false))
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
			var nxt: String = ch[1]
			_add_button("%d. %s" % [n, label], func(): _choose(label, nxt))
			n += 1
	else:
		_follow(current.next)


func _follow(nxt: String) -> void:
	match nxt:
		"@close":
			busy = false
			_clear_buttons()
		"@blackout":
			_blackout()
		"@end":
			_end_screen()
		_:
			_show_node(nxt)


func _choose(label: String, nxt: String) -> void:
	log_label.append_text("[color=#%s]— %s[/color]\n\n" % [pal.accent.to_html(false), label])
	_clear_buttons()
	_follow(nxt)


func _append_line(speaker: String, text: String) -> void:
	if speaker == "":
		log_label.append_text("%s\n\n" % text)
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
	b.add_theme_font_size_override("font_size", 17)
	b.pressed.connect(cb)
	buttons.add_child(b)


# --- Switch & end ---
func _blackout() -> void:
	_clear_buttons()
	busy = true
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	var t := create_tween()
	t.tween_property(overlay, "color:a", 1.0, 1.6)
	t.tween_interval(1.4)
	t.tween_callback(func():
		log_label.clear()
		hover_obj = null
		_enter_room("room"))
	t.tween_property(overlay, "color:a", 0.0, 2.2)
	t.tween_callback(func():
		overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_show_node("r_wake"))


func _end_screen() -> void:
	_clear_buttons()
	busy = true
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	var seconds := Time.get_ticks_msec() / 1000.0 - room_enter_time
	var n := examined.size()
	var t := create_tween()
	t.tween_property(overlay, "color:a", 1.0, 1.6)
	t.tween_callback(func():
		log_label.clear()
		panel.anchor_left = 0.25
		panel.anchor_right = 0.75
		panel.color = Color(0, 0, 0, 0)
		location.text = ""
		world.visible = false
		RenderingServer.set_default_clear_color(Color("#0d0d0d"))
		log_label.add_theme_color_override("default_color", Color("#dddddd"))
		log_label.append_text("\n\n[center][font_size=28]Один это человек или двое?[/font_size][/center]\n"))
	t.tween_property(overlay, "color:a", 0.0, 1.2)
	t.tween_callback(func():
		overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		for ans in ["Один", "Двое", "Не знаю"]:
			_add_button(ans, func(): _record(ans, n, seconds)))


func _record(answer: String, n: int, seconds: float) -> void:
	_clear_buttons()
	print("[PROTOTYPE] answer=%s examined=%d/%d keys=%s seconds_in_room=%.0f" % [answer, n, ROOM_COUNTED.size(), examined.keys(), seconds])
	log_label.append_text("\n[center]Ответ: %s.\n\nВо второй комнате осмотрено %d из %d предметов за %d с.\n\nКонец прототипа.[/center]" % [answer, n, ROOM_COUNTED.size(), int(seconds)])
	_add_button("Выйти из игры", func(): get_tree().quit())


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.physical_keycode == KEY_ESCAPE:
		get_tree().quit()
