extends KinematicBody2D

var motion = Vector2(0,0)

const SPEED = 1500
const GRAVITY = 150
const UP = Vector2(0,-1)
const JUMP_SPEED = 3250
const WORLD_LIMIT = 4000

var lives = 3

signal animate

func _ready():
	update_GUI()

func _physics_process(delta):
	apply_gravity()
	jump()
	move()
	animate()
	move_and_slide(motion, UP)

func apply_gravity():
	if position.y > WORLD_LIMIT:
		end_game()
	elif is_on_floor() and motion.y > 0:
		motion.y = 0
	elif is_on_ceiling():
		motion.y = 1 
	else:
		motion.y += GRAVITY 

func jump():
	if Input.is_action_pressed("jump") and is_on_floor():
		motion.y -= JUMP_SPEED
		$JumpSFX.play()


func move():
	if Input.is_action_pressed("left") and Input.is_action_pressed("right"):
		motion.x = 0
	elif Input.is_action_pressed("left"):
		motion.x = -SPEED
	elif Input.is_action_pressed("right"):
		motion.x = SPEED
	else:
		motion.x = 0

func animate():
	
	emit_signal("animate", motion)


func end_game():
	get_tree().change_scene("res://Levels/GameOver.tscn")


func hurt():
	position.y -= 1
	position.x -= 25
	yield(get_tree(), "idle_frame")
	motion.y = -JUMP_SPEED
	lives -= 1
	update_GUI()
	$PainSFX.play()
	if lives < 0:
		end_game()

func update_GUI():
	get_tree().call_group("GUI", "update_lives", lives)














