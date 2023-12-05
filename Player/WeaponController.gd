extends Node

@export var StartingWeapon: PackedScene

var hand
var equiped_weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	hand = get_parent().find_child("Hand")
	
	if StartingWeapon:
		equip_weapon(StartingWeapon)

func equip_weapon(weapon_to_equip):
	if equiped_weapon:
		equiped_weapon.queue_free()
	else:
		equiped_weapon = weapon_to_equip.instantiate()
		hand.add_child(equiped_weapon)

func shoot():
	if equiped_weapon:
		equiped_weapon.shoot()
