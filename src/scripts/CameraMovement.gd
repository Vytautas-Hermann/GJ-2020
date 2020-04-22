extends Camera2D

func _ready():
	pass

# zoom in by 0.1, max is 0.6
func _zoom_in():
	if self.zoom[0] > 0.6:
		self.zoom = self.zoom - Vector2(0.1, 0.1)

# zoom out by 0.1, min is 1.2
func _zoom_out():
	if self.zoom[0] < 1.2:
		self.zoom = self.zoom + Vector2(0.1, 0.1)
