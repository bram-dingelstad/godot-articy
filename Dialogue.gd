extends Control

onready var template = $VBoxContainer/Template

const DAGGER_IS_HIGH_QUALITY = 1
const DAGGER_IS_LOW_QUALITY = 2

func _ready():
	$VBoxContainer.remove_child(template)

	$Interpreter.connect('line', self, '_on_line')
	$Interpreter.connect('choices', self, '_on_choices')
	$Interpreter.connect('stopped', self, '_on_stopped')

	for model in $Database.get_all_models():
		if model.Type == 'DialogueFragment':
			var outputs = model.Properties.output_pins[0].connections.size()
			if outputs > 1:
				print(model)
				break

			
	var choice_dialogue = '0x01000001000003DF'

	$Interpreter.start(choice_dialogue)


func _on_line(data):
	# NOTE: Wait one frame to prevent re-entrant problems with GDNative
	yield(get_tree(), 'idle_frame')
	var _speaker = $Database.get_model(data.speaker)
	print(data)
	$RichTextLabel.bbcode_text = data.line


func _on_choices(data):
	var index = 0

	for child in $VBoxContainer.get_children():
		$VBoxContainer.remove_child(child)
		child.queue_free()

	for choice in data:
		print(choice)
		var button = template.duplicate()
		button.text = choice.label
		button.connect('pressed', self, '_on_choice', [choice.id])
		$VBoxContainer.add_child(button)
		index += 1

func _on_choice(id):
	for child in $VBoxContainer.get_children():
		$VBoxContainer.remove_child(child)
		child.queue_free()

	$Interpreter.choose(id)

func _on_stopped():
	$RichTextLabel.bbcode_text = 'End of dialogue, thank you for playing :)'


func _input(event):
	if event is InputEventKey \
			and event.pressed:
		match event.scancode:
			KEY_ENTER:
				$Interpreter.advance()
			KEY_E:
				print('Attempting to exhaust maximally')
				$Interpreter.exhaust_maximally()
