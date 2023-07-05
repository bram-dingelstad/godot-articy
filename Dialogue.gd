extends Control

onready var template = $VBoxContainer/Template

const DAGGER_IS_HIGH_QUALITY = 1
const DAGGER_IS_LOW_QUALITY = 2

func _ready():
	$VBoxContainer.remove_child(template)

	$Interpreter.connect('line', self, '_on_line')
	$Interpreter.connect('choices', self, '_on_choices')
	$Interpreter.connect('stopped', self, '_on_stopped')

	# NOTE: You can also just add the Database in as an AutoLoad instead of your scene and refer to it with Database
	print($Database.get_models_of_type("Customers")[0])
	print($Database.get_models_of_type("Dialogue")[0])

	var groundskeeper_done = "0x0100000100000481"


	# Day 1
	$Interpreter.set_state('quality.groundskeeper_dagger', DAGGER_IS_LOW_QUALITY)
	$Interpreter.start(groundskeeper_done)


func _on_line(data):
	# NOTE: Wait one frame to prevent re-entrant problems with GDNative
	yield(get_tree(), 'idle_frame')
	var speaker = $Database.get_model(data.speaker)
	$RichTextLabel.bbcode_text = data.line


func _on_choices(data):
	var index = 0
	for choice in data:
		var button = template.duplicate()
		button.text = choice.label
		button.connect('pressed', self, '_on_choice', [index])
		$VBoxContainer.add_child(button)
		index += 1

func _on_choice(index):
	for child in $VBoxContainer.get_children():
		$VBoxContainer.remove_child(child)
		child.queue_free()

	$Interpreter.choose(index)
	$Interpreter.advance()

func _on_stopped():
	$RichTextLabel.bbcode_text = 'End of dialogue, thank you for playing :)'


func _input(event):
	if event is InputEventKey \
			and event.pressed:
		match event.scancode:
			KEY_ENTER:
				$Interpreter.advance()
