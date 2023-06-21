extends Control

onready var template = $VBoxContainer/Template

func _ready():
	$VBoxContainer.remove_child(template)

	$Interpreter.connect('line', self, '_on_line')
	$Interpreter.connect('choices', self, '_on_choices')
	$Interpreter.connect('stopped', self, '_on_stopped')

	# print($Database.get_models_of_type("Customers")[0])
	# print($Database.get_models_of_type("Dialogue")[0])

	# Day 1
	$Interpreter.start($Database.get_available_dialogues()[0].id)

	


func _on_line(data):
	print(data)
	# NOTE: Wait one frame to prevent re-entrant problems with GDNative
	yield(get_tree(), 'idle_frame')
	var speaker = $Database.get_model(data.speaker)
	$RichTextLabel.bbcode_text = data.line


func _on_choices(data):
	print(data)
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
