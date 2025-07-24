extends CharacterBody2D

@onready var RayLeft: RayCast2D = $RaycastLeft
@onready var RayRight: RayCast2D = $RaycastRight
@onready var RayUp: RayCast2D = $RaycastUp
@onready var RayDown: RayCast2D = $RaycastDown
@onready var MagLeft: Sprite2D = $LeftMagnet
@onready var MagRight: Sprite2D = $RightMagnet
@onready var MagUp: Sprite2D = $UpMagnet
@onready var MagDown: Sprite2D = $DownMagnet

var magnetsOn: Dictionary = {"Left": false, "Right": false, "Up": false, "Down": false}
var detectedPolarities: Dictionary = {"Left": null, "Right": null, "Up": null, "Down": null}
var polarity = "+"
# var movementDirection: Vector2
var speed = 100
var accelerationRate = 1.5
var accelerationX = 1
var accelerationY = 1
var movementDirection: Vector2
var latestCollision = Vector2(0, 0)
var latestVelocity

func _ready():
	pass

func _physics_process(delta):
	# will implement acceleration at some point?
	collisionCheck()
	if latestCollision.x >= 0:
		if magnetsOn["Left"]:
			if detectedPolarities["Left"] != null:
				accelerationX *= accelerationRate
				if detectedPolarities["Left"] == polarity:
					movementDirection.x += 1
				else:
					movementDirection.x += -1
	if latestCollision.x <= 0:
		if magnetsOn["Right"]:
			if detectedPolarities["Right"] != null:
				accelerationX *= accelerationRate
				if detectedPolarities["Right"] == polarity:
					movementDirection.x += -1
				else:
					movementDirection.x += 1
	
	if latestCollision.y >= 0:
		if magnetsOn["Up"]:
			if detectedPolarities["Up"] != null:
				accelerationY *= accelerationRate
				if detectedPolarities["Up"] == polarity:
					movementDirection.y += 1
				else:
					movementDirection.y += -1
	if latestCollision.y <= 0:
		if magnetsOn["Down"]:
			if detectedPolarities["Down"] != null:
				accelerationY *= accelerationRate
				if detectedPolarities["Down"] == polarity:
					movementDirection.y += -1
				else:
					movementDirection.y += 1
	var collision
	for i in self.get_slide_collision_count():
		collision = get_slide_collision(i).get_normal()
		if (collision.x > 0) and magnetsOn["Right"]:
			if movementDirection.x > 0:
				# movementDirection.x = movementDirection.x + movementDirection.x * -1
				accelerationX = 100
		elif (collision.x < 0) and magnetsOn["Left"]:
			if movementDirection.x < 0:
				# movementDirection.x = movementDirection.x + movementDirection.x * -1
				accelerationX = 100
		if (collision.y > 0) and magnetsOn["Down"]:
			if movementDirection.y > 0:
				# movementDirection.y = movementDirection.y + movementDirection.y * -1
				accelerationY = 100
		elif (collision.y < 0) and magnetsOn["Up"]:
			if movementDirection.y < 0:
				# movementDirection.x = movementDirection.y + movementDirection.y * -1
				accelerationY = 100
		elif collision == Vector2(0, 0):
			accelerationX = 100
			accelerationY = 100
		latestCollision = collision
	if velocity != latestVelocity:
		print(velocity)
	if collision != latestCollision:
		print(collision)
	
	
	velocity = Vector2(movementDirection.x * speed * accelerationX, movementDirection.y * speed* accelerationY)
	latestVelocity = velocity
	print("xaccel = " + str(accelerationX) + ", yaccel = " + str(accelerationY))
	move_and_slide()

func _process(delta):
	if Input.is_action_pressed("shift"):
		polarity = "-"
		spriteChange()
	else:
		polarity = "+"
		spriteChange()
	if Input.is_action_pressed("left"):
		magnetsOn["Left"] = true
		MagLeft.show()
		RayLeft.enabled = true
	else:
		magnetsOn["Left"] = false
		MagLeft.hide()
		RayLeft.enabled = false
	if Input.is_action_pressed("right"):
		magnetsOn["Right"] = true
		MagRight.show()
		RayRight.enabled = true
	else:
		magnetsOn["Right"] = false
		MagRight.hide()
		RayRight.enabled = false
	if Input.is_action_pressed("up"):
		magnetsOn["Up"] = true
		MagUp.show()
		RayUp.enabled = true
	else:
		magnetsOn["Up"] = false
		MagUp.hide()
		RayUp.enabled = false
	if Input.is_action_pressed("down"):
		magnetsOn["Down"] = true
		MagDown.show()
		RayDown.enabled = true
	else:
		magnetsOn["Down"] = false
		MagDown.hide()
		RayDown.enabled = false
	spriteChange()

func collisionCheck():
	var collider
	var colliderCharge
	if RayLeft.is_colliding():
		detectedPolarities["Left"] = RayLeft.get_collider().get_name().substr(0, 1)
	else:
		detectedPolarities["Left"] = null
	
	if RayRight.is_colliding():
		detectedPolarities["Right"] = RayRight.get_collider().get_name().substr(0, 1)
	else:
		detectedPolarities["Right"] = null

	if RayUp.is_colliding():
		detectedPolarities["Up"] = RayUp.get_collider().get_name().substr(0, 1)
	else:
		detectedPolarities["Up"] = null
	
	if RayDown.is_colliding():
		detectedPolarities["Down"] = RayDown.get_collider().get_name().substr(0, 1)
	else:
		detectedPolarities["Down"] = null

func spriteChange():
	if polarity == "+":
		MagUp.region_rect.position.x = 0
		MagLeft.region_rect.position.x = 0
		MagDown.region_rect.position.x = 0
		MagRight.region_rect.position.x = 0
	elif polarity == "-":
		MagUp.region_rect.position.x = 80
		MagLeft.region_rect.position.x = 80
		MagDown.region_rect.position.x = 80
		MagRight.region_rect.position.x = 80
