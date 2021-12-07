extends KinematicBody2D

enum Direction {LEFT = -1, RIGHT = 1}

export var direction = Direction.LEFT
export var detect_cliffs = true
var killer = false
var velocity = Vector2(0,0)
var terminal_velocity =  500

func _ready():
	if direction == Direction.RIGHT:
		$AnimatedSprite.flip_h = true
	
	$Floorchecker.enabled = detect_cliffs
	$Floorchecker.position.x = $CollisionShape2D.shape.get_extents().y * direction
	
func _physics_process(delta):
	
	if is_on_wall() or (detect_cliffs and not  $Floorchecker.is_colliding() and is_on_floor()):
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h

		$Floorchecker.position.x = $CollisionShape2D.shape.get_extents().y * direction
		
	
	velocity.y = min(terminal_velocity, velocity.y + 20)
	if killer:
		velocity.x = 0
	else:
		velocity.x = 50 * direction	
	move_and_slide(velocity, Vector2.UP)
		
func _on_KillBox_body_entered(body):
	killer = true
	body.kill(position.x)


func _on_TopBox_body_entered(body):
	print("here")
	$AnimatedSprite.play("dead")
	body.bounce()
	$DeathTimer.start()
	


func _on_DeathTimer_timeout():
	queue_free()
	
