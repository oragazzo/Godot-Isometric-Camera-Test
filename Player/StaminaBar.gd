extends Label

@onready var Player = get_owner()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.text = ("Stamina: " + str(round(Player.stamina)) + "/100")
	pass
