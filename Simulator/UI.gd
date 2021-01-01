extends CanvasLayer


signal start_simulation
signal stop_simulation
signal reset_simulation

signal born_updated(value)
signal survive_updated(value)
signal die_updated(value)
signal simulation_speed_updated(value)

signal mouse_in_ui
signal mouse_left_ui

onready var born_field = $Control/VBoxContainer/BornSetting/BornLineEdit
onready var survive_field = $Control/VBoxContainer/SurviveSetting/SurviveLineEdit
onready var die_field = $Control/VBoxContainer/DieSetting/DieLineEdit

onready var start_button = $Control/VBoxContainer/StartSimulation
onready var stop_button = $Control/VBoxContainer/StopSimulation
onready var reset_button = $Control/VBoxContainer/ResetSimulation

onready var speed_label = $Control/VBoxContainer/SpeedSetting/SpeedLabel

func _on_StartSimulation_pressed():
	emit_signal("start_simulation")
	start_button.visible = false
	stop_button.visible = true
	
	born_field.editable = false
	survive_field.editable = false
	die_field.editable = false


func _on_StopSimulation_pressed():
	emit_signal("stop_simulation")
	start_button.visible = true
	stop_button.visible = false
	
	born_field.editable = true
	survive_field.editable = true
	die_field.editable = true


func _on_ResetSimulation_pressed():
	emit_signal("reset_simulation")
	start_button.visible = true
	stop_button.visible = false
	
	born_field.editable = true
	survive_field.editable = true
	die_field.editable = true


func _on_BornLineEdit_text_changed(new_text):
	emit_signal("born_updated", int(new_text))


func _on_SurviveLineEdit_text_changed(new_text):
	emit_signal("survive_updated", int(new_text))


func _on_DieLineEdit_text_changed(new_text):
	emit_signal("die_updated", int(new_text))


func _on_SpeedSlider_value_changed(value):
	emit_signal("simulation_speed_updated", 5.0 - value)
	speed_label.text = str((value / 5.0) * 100) + "%"


func _on_Control_mouse_entered():
	emit_signal("mouse_in_ui")


func _on_Control_mouse_exited():
	emit_signal("mouse_left_ui")
