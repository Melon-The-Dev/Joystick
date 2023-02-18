@tool
extends Area2D

####### WHY MUST YOU CHECK THE SPAGHETTI CODE XD ########
####### DONT CHANGE ANYTHING, IT MIGHT BREAK LOL ########

var is_on_joystick = false
var is_pressing = false
var dist = 0
var on_mouse
var in_touch_area
var original_pos : Vector2

enum JoystickType {Fixed,Dynamic}
var Joystick_Type : JoystickType = JoystickType.Fixed
var smoothen : bool = false
var TouchArea : Shape2D
var linear
var pressed_opacity = 1
var normal_opacity :float= 0
var area_x = 0
var area_y = 0

@export_category("Joystick Object")
var bg_texture : CompressedTexture2D
var fg_texture : CompressedTexture2D
var bg_size : float


var Smoothen : bool

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if Joystick_Type == JoystickType.Dynamic:
				if !is_pressing and in_touch_area:
					global_position = event.position
					is_pressing = true
					opacity_change(true)
					change_pos(event.position)
			else:
				if on_mouse:
					is_pressing = true
					opacity_change(true)
					change_pos(event.position)
		else:
			is_pressing = false
			is_on_joystick = false
			if Joystick_Type == JoystickType.Dynamic:
				if linear:
					var t = create_tween()
					t.tween_property($bg/fg,"position",Vector2(0,0),0.25)
				else:
					$bg/fg.position = Vector2.ZERO
				if !smoothen:
					global_position = original_pos
				elif smoothen:
					var t2 = create_tween()
					t2.tween_property(self,"global_position",original_pos,0.25)
			else:
				if linear:
					var t = create_tween()
					t.tween_property($bg/fg,"position",Vector2(0,0),0.25)
				else:
					$bg/fg.position = Vector2.ZERO
			opacity_change(false)
	if event is InputEventScreenDrag:
		if is_pressing:
			is_on_joystick = true
			change_pos(event.position)

func change_pos(pos):
	$bg/fg.position = pos-$bg.global_position
	$bg/fg.position = $bg/fg.position.limit_length((bg_size/2)*scale.x)

func _on_mouse_entered() -> void:
	on_mouse = true


func _on_mouse_exited() -> void:
	on_mouse = false


func get_joystick_velocity(rounded:bool) -> Vector2:
	var velo = $bg/fg.position - $bg.position
	velo = velo.normalized()
	if rounded == true:
		velo = round(velo)
	return velo


func _on_touch_area_mouse_entered() -> void:
	in_touch_area = true


func _on_touch_area_mouse_exited() -> void:
	in_touch_area = false




###### STUFF #####

func _property_can_revert(property):
	if property == "/Joystick_Type":
		return true
	if property == "/Smoothen":
		return true
	if property == "/bg_texture":
		return true
	if property == "/fg_texture":
		return true
	if property == "/Opacity/pressed_opacity":
		return true
	if property == "/Opacity/normal_opacity":
		return true
	return false

func _property_get_revert(property):
	if property == "/Joystick_Type":
		return 0
	if property == "/Smoothen":
		return false
	if property == "/bg_texture":
		return preload("res://joystick/joystick_base_outline.png")
	if property == "/fg_texture":
		return preload("res://joystick/joystick_tip_arrows.png")
	if property == "/Opacity/pressed_opacity":
		return 1
	if property == "/Opacity/normal_opacity":
		return 0.0


func _get(property):
	if property == "/Joystick_Type":
		return Joystick_Type
	if property == "/Dynamic Joystick/Smoothen":
		return smoothen
	if property == "/Dynamic Joystick/area_x":
		return area_x
	if property == "/Dynamic Joystick/area_y":
		return area_y
	if property == "/Dynamic Joystick/TouchArea":
		return TouchArea
	if property == "/bg_texture":
		return bg_texture
	if property == "/fg_texture":
		return fg_texture
	if property == "/bg_size":
		return bg_size
	if property == "/Opacity/pressed_opacity":
		return pressed_opacity
	if property == "/Opacity/normal_opacity":
		return normal_opacity
	if property == "/Opacity/linear":
		return linear
	

func _set(property, value):
	if property == "/Joystick_Type":
		Joystick_Type = value
		notify_property_list_changed()
	if property == "/Dynamic Joystick/Smoothen":
		smoothen = value
	if property == "/Dynamic Joystick/area_x":
		area_x = value
	if property == "/Dynamic Joystick/area_y":
		area_y = value
	if property == "/Dynamic Joystick/TouchArea":
		TouchArea = value
	if property == "/bg_texture":
		bg_texture = value
	if property == "/fg_texture":
		fg_texture = value
	if property == "/bg_size":
		bg_size = value
	if property == "/Opacity/pressed_opacity":
		pressed_opacity = value
	if property == "/Opacity/normal_opacity":
		normal_opacity = value
	if property == "/Opacity/linear":
		linear = value



func _get_property_list():
	var property_list = []
	property_list.append({
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "/bg_texture",
		"type": TYPE_OBJECT,
		"hint_string": "CompressedTexture2D"
	})
	property_list.append({
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "/fg_texture",
		"type": TYPE_OBJECT,
		"hint_string": "CompressedTexture2D"
	})
	property_list.append({
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "/bg_size",
		"type": TYPE_FLOAT,
	})
	property_list.append({
		"hint": PROPERTY_HINT_RANGE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "/Opacity/pressed_opacity",
		"type": TYPE_FLOAT,
		"hint_string": "0.1,1,0.05"
	})
	property_list.append({
		"hint": PROPERTY_HINT_RANGE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "/Opacity/normal_opacity",
		"type": TYPE_FLOAT,
		"hint_string": "0.1,1,0.05"
	})
	property_list.append({
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "/Opacity/linear",
		"type": TYPE_BOOL,
	})
	property_list.append({
		"hint": PROPERTY_HINT_ENUM,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "/Joystick_Type",
		"type": TYPE_INT,
		"hint_string": "Fixed:0,Dynamic:1"
	})
	if Joystick_Type==1:
		property_list.append({
			"hint": PROPERTY_HINT_NONE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "/Dynamic Joystick/Smoothen",
			"type": TYPE_BOOL
		})
		property_list.append({
			"hint": PROPERTY_HINT_RANGE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "/Dynamic Joystick/area_x",
			"type": TYPE_INT,
			"hint_string": "-500,500,0.1"
		})
		property_list.append({
			"hint": PROPERTY_HINT_RANGE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "/Dynamic Joystick/area_y",
			"type": TYPE_INT,
			"hint_string": "-500,500,0.1"
		})
		property_list.append({
			"hint": PROPERTY_HINT_RESOURCE_TYPE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "/Dynamic Joystick/TouchArea",
			"type": TYPE_OBJECT,
			"hint_string": "Shape2D"
		})
	else:
		TouchArea = null
	return property_list


func opacity_change(pressed):
	if !Engine.is_editor_hint():
		if pressed:
			if linear:
				var t = create_tween()
				t.tween_property(self,"modulate:a",pressed_opacity,0.25)
			else:
				if normal_opacity == null: return
				else: modulate.a = normal_opacity
		else:
			if linear:
				var t = create_tween()
				t.tween_property(self,"modulate:a",normal_opacity,0.25)
			else:
				if normal_opacity == null: return
				else: modulate.a = normal_opacity


func _ready() -> void:
	if !Engine.is_editor_hint():
		original_pos = global_position
		opacity_change(false)
		$Touch_area.set_as_top_level(true)
		$Touch_area/CollisionShape2D.shape = TouchArea
		$Touch_area/CollisionShape2D.position.x = area_x
		$Touch_area/CollisionShape2D.position.y = -area_y
		$Touch_area.global_position = global_position
		$CollisionShape2D.shape.radius = bg_size/2
		$bg.texture = bg_texture
		$bg/fg.texture = fg_texture

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$Touch_area/CollisionShape2D.shape = TouchArea
		$Touch_area.set_as_top_level(false)
		$Touch_area/CollisionShape2D.position.x = area_x
		$Touch_area/CollisionShape2D.position.y = -area_y
		$CollisionShape2D.shape.radius = bg_size/2
		$bg.texture = bg_texture
		$bg/fg.texture = fg_texture
	pass
