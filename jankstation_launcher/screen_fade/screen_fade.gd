class_name ScreenFade
extends CanvasLayer


@export var color: Color = Color.BLACK
	
	
func fade_out(duration: float) -> bool:
	App.instance.pause()
	$ColorRect.visible = true
	
	var tween: Tween = create_tween()
	tween.tween_property($ColorRect, "color", color, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	await tween.finished
	tween.kill()
	
	return true
	
	
func fade_in(duration: float) -> bool:
	App.instance.resume()
	
	var tween: Tween = create_tween()
	tween.tween_property($ColorRect, "color", Color(color.r, color.g, color.b, 0.0), duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	await tween.finished
	tween.kill()
	
	$ColorRect.visible = false
	
	return true
