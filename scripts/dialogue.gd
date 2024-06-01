extends CanvasLayer

@export_file("*.json") var d_file: String

var dialogue = []

func _ready():
	start()

func start():
	dialogue = load_dialogue()
	if dialogue.size() > 0:
		$NinePatchRect/Name.text = dialogue[0]['name']
		$NinePatchRect/Chat.text = dialogue[0]['text']

func load_dialogue():
	var file = FileAccess.open(d_file, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var result = JSON.parse_string(content)
		if typeof(result) == TYPE_DICTIONARY and result.has("error") and result.error == OK:
			return result.result
		elif typeof(result) == TYPE_ARRAY:
			return result
	return []
