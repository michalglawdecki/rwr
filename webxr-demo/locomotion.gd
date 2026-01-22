extends XROrigin3D

@export var move_speed: float = 2.5
@export var deadzone: float = 0.15
@onready var xr_camera: XRCamera3D = $XRCamera3D
@onready var left_ctrl: XRController3D = $LeftController

func _physics_process(delta: float) -> void:
	var dir := Vector3.ZERO

	# 1. Pobieramy wektory, ale TYLKO w płaszczyźnie poziomej
	var fwd := -xr_camera.global_transform.basis.z
	fwd.y = 0.0 # Wyzerowanie osi Y zapobiega lataniu w górę/dół
	fwd = fwd.normalized() # Normalizujemy, żeby ruch nie był wolniejszy, gdy patrzymy w dół/górę

	var right := xr_camera.global_transform.basis.x
	right.y = 0.0 # To samo dla ruchu na boki (żeby nie wpływało na to przechylenie głowy)
	right = right.normalized()

	var v: Vector2 = left_ctrl.get_vector2("thumbstick")
	if v.length() < deadzone:
		v = Vector2.ZERO

	# 2. Poprawa kierunku
	# Usunąłem minus przy v.y. Jeśli teraz chodzisz tyłem do przodu, przywróć minus.
	# Zazwyczaj 'v.y' to góra/dół na gałce, co odpowiada ruchowi przód/tył.
	dir += fwd * v.y + right * v.x

	if dir.length() > 0.0:
		global_translate(dir.normalized() * move_speed * delta)
