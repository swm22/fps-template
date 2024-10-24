class_name IdlePlayerState extends PlayerMovementState

@export var SPEED: float = 7.0
@export var ACCELERATION: float = 0.1
@export var DECELERATION: float = 0.25
var from_sprint: bool

func enter(previous_state: State) -> void:
	if previous_state.name == "JumpingPlayerState":
		await animation_player.animation_finished
	else:
		animation_player.pause()
		
	from_sprint = previous_state.name == "SprintingPlayerState"

func update(delta: float) -> void:
	player.update_gravity(delta)
	player.update_input()
	player.update_velocity(SPEED, ACCELERATION, DECELERATION)
	
	if Input.is_action_just_pressed("crouch") and player.is_on_floor():
		transition.emit("CrouchingPlayerState")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transition.emit("JumpingPlayerState")
	elif player.velocity.length() > 0.0 and player.is_on_floor():
		if (from_sprint and player.toggle_sprint) or Input.is_action_pressed("sprint"):
			transition.emit("SprintingPlayerState")
		else:
			transition.emit("WalkingPlayerState")
