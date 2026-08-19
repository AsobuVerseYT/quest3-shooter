extends Node3D
## Root script for the main scene: starts the OpenXR session so the game
## renders to the Quest 3 headset instead of the flat desktop viewport.
## If no headset/OpenXR runtime is available (e.g. testing in the editor
## on a PC with no headset and no Quest Link/Air Link connected), it falls
## back to the flat DesktopCamera so you still see something instead of a
## black screen — the XRCamera3D only ever renders during an active XR
## session, by design.

@onready var desktop_camera: Camera3D = $DesktopCamera

func _ready() -> void:
	var xr_interface: XRInterface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		get_viewport().use_xr = true
		desktop_camera.current = false
	else:
		push_warning("OpenXR not initialized — falling back to flat desktop preview camera. Connect a headset (or Quest Link/Air Link) to play in VR.")
		desktop_camera.current = true
