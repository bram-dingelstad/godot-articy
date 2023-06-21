tool
extends EditorPlugin

var import_plugin
var emote_import_plugin

func _enter_tree():
	import_plugin = ImportPlugin.new(self)
	add_import_plugin(import_plugin)

	emote_import_plugin = EmoteImportPlugin.new(self)
	add_import_plugin(emote_import_plugin)


func _exit_tree():
	remove_import_plugin(import_plugin)
	import_plugin = null

	remove_import_plugin(emote_import_plugin)
	emote_import_plugin = null


class ArticyResource extends PackedDataContainer:
	var placeholder

class ImportPlugin extends EditorImportPlugin:
	var plugin

	enum Presets {
		DEFAULT
	}

	func _init(_plugin):
		plugin = _plugin
		print('Initialized Articy Importer plugin')


	func get_importer_name():
		return 'bram.dingelstad.works.articy'


	func get_visible_name():
		return 'Articy Importer'


	func get_recognized_extensions():
		return ['articy']


	func get_save_extension():
		return 'res'


	func get_resource_type():
		return 'PackedDataContainer'


	func get_preset_count():
		return Presets.size()


	func get_preset_name(preset):
		match preset:
			Presets.DEFAULT:
				return 'Default'

			_:
				return 'Unknown'


	func get_import_options(preset):
		return [
			{
				name = 'default',
				default_value = preset == Presets.DEFAULT
			}
		]


	func get_option_visibility(option, options):
		return true


	func import(source_file, save_path, options, platform_variants, gen_files):
		print('Importing a Articy file')

		var file = File.new()
		file.open(source_file, File.READ)
		var bytes = file.get_buffer(file.get_len())
		file.close()

		var resource = ArticyResource.new()
		resource.__data__ = bytes

		# Save a stub
		return ResourceSaver.save('%s.%s' % [save_path, get_save_extension()], resource)

	
class ArticyEmoteResource extends PackedDataContainer:
	var placeholder

class EmoteImportPlugin extends EditorImportPlugin:
	var plugin

	enum Presets {
		DEFAULT
	}

	func _init(_plugin):
		plugin = _plugin
		print('Initialized Articy Emote Importer plugin')


	func get_importer_name():
		return 'bram.dingelstad.works.articy.emote'


	func get_visible_name():
		return 'Articy Emote Importer'


	func get_recognized_extensions():
		return ['articy-emote']


	func get_save_extension():
		return 'res'


	func get_resource_type():
		return 'PackedDataContainer'


	func get_preset_count():
		return Presets.size()


	func get_preset_name(preset):
		match preset:
			Presets.DEFAULT:
				return 'Default'

			_:
				return 'Unknown'


	func get_import_options(preset):
		return [
			{
				name = 'default',
				default_value = preset == Presets.DEFAULT
			}
		]


	func get_option_visibility(option, options):
		return true


	func import(source_file, save_path, options, platform_variants, gen_files):
		print('Importing a Articy emote file')

		var file = File.new()
		file.open(source_file, File.READ)
		var bytes = file.get_buffer(file.get_len())
		file.close()

		var resource = ArticyEmoteResource.new()
		resource.__data__ = bytes

		# Save a stub
		return ResourceSaver.save('%s.%s' % [save_path, get_save_extension()], resource)