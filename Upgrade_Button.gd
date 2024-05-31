extends Button

var id
var cost = 0
var lambda_func

#TODO: add sound effects when buying or when there is not enough currency

func _on_pressed():
	if Globals.Currency >= cost:
		Globals.Currency -= cost
		lambda_func.call()
		#TODO: make some upgrades repeatable:
		Globals.upgrades_taken.append(id)
#reload the entire menu instead of doing queue_free, this allows the code to support stuff like "upgrade X requires upgrade Y"
		Globals.upgrademenu_reference.load_options()
#		queue_free()
	else:
		pass
#		print("not enough currency")
