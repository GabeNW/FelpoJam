extends Node

var save_data := {
	"current_level": "",
	"completed_levels": []
}

const SAVE_PATH = "user://save.json"

# Funcoes principais
func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	save_data = JSON.parse_string(content)

func has_save():
	return FileAccess.file_exists(SAVE_PATH)
