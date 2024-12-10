extends Node3D  # Attach to MainScene or another parent node

var player: Node3D
var cylinder: CSGCylinder3D

# Define the fixed Y position for the cylinder
@export var cylinder_fixed_y: float = 25.0

func _ready():
	# Get references to the Player and Cylinder nodes
	player = $crow_v2
	cylinder = $CSGBox3D/CSGCylinder3D


func _process(delta):
	if player and cylinder:
		# Get the player's position
		var player_position = player.global_transform.origin

		# Update only the X and Z positions of the cylinder; keep Y fixed
		var cylinder_position = cylinder.global_transform.origin
		cylinder_position.x = player_position.x
		cylinder_position.z = player_position.z
		cylinder_position.y = cylinder_fixed_y  # Keep Y constant

		# Update the cylinder's position
		cylinder.global_transform.origin = cylinder_position
