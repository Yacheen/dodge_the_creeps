extends Area2D

signal hit	
export var speed = 300
var screen_size
var target = Vector2()


func _ready():
	screen_size = get_viewport_rect().size
	print(screen_size)
	hide()

func start(pos):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		target = event.position


func _process(delta):
	var velocity = Vector2()
	if position.distance_to(target) > 10:
		velocity = target - position
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0



func _on_Your_ADC_body_entered(body:Node):
	hide() # player disappears after being hit, use hide() on the node
	emit_signal("hit") # emit signal
	$CollisionShape2D.set_deferred("disabled", true)

