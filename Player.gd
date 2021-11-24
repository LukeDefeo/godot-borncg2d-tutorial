extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SPEED = 250
const GRAVITY = 30
const JUMP_FORCE = 900

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_owner().get_node("Coins").get_children():		
		child.connect("coin_collected", self, "add_coin")
		

var coins_collected = 0
var velocity = Vector2(0,0)

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = true
		velocity.x = -SPEED
	elif Input.is_action_pressed("right"):
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
		velocity.x = SPEED
	else:
		$AnimatedSprite.play("idle")
		
	if not is_on_floor():
		$AnimatedSprite.play("air")
	# is on floor works bc we set up dir in move and slide
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_FORCE
	# first move the char
	
	velocity.y = velocity.y + GRAVITY
	
	velocity = move_and_slide(velocity, Vector2.UP)
	# then interp velocity back to 0 to slow down, if the char is press again goes back to
	# full speed
	velocity.x = lerp(velocity.x,0,0.2)
	

func _on_Fallzone_body_entered(body):
	get_tree().change_scene("res://level1.tscn")



func add_coin():
	coins_collected += 1
	$HUD.update_coins(coins_collected)
	if coins_collected == 2:
		get_tree().change_scene("res://level1.tscn")
