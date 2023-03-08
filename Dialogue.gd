extends Control

onready var template = $VBoxContainer/Template

func _ready():
	$VBoxContainer.remove_child(template)

	var file = File.new()
	file.open('res://example_project.json', File.READ)
	var bytes = file.get_buffer(file.get_len())
	file.close()

	print('file size: %d bytes' % bytes.size())

	$Articy.load(bytes)

	for method in $Articy.get_method_list():
		if method.name in ['advance', 'start']:
			print(method.name)

	$Articy.connect('line', self, '_on_line')
	$Articy.connect('choices', self, '_on_choices')
	$Articy.connect('stopped', self, '_on_stopped')

	# Day 1
	$Articy.start("0x010000000000188A")


func _on_line(data):
	print(data)
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

	$Articy.choose(index)
	$Articy.advance()

func _on_stopped():
	$RichTextLabel.bbcode_text = 'End of dialogue, thank you for playing :)'


func _input(event):
	if event is InputEventKey \
			and event.pressed:
		match event.scancode:
			KEY_ENTER:
				$Articy.advance()
