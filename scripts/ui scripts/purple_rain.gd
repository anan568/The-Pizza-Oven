extends Sprite2D

const VU_COUNT = 16
const FREQ_MAX = 11050.0

const WIDTH = 800
const HEIGHT = 250
const HEIGHT_SCALE = 8.0
const MIN_DB = 60
const ANIMATION_SPEED = 0.1

var spectrum: AudioEffectSpectrumAnalyzerInstance
var min_values: Array[float] = []
var max_values: Array[float] = []

func _process(_delta: float) -> void:
	var data: Array[float] = []
	var prev_hz := 0.0

	var hz := FREQ_MAX / VU_COUNT
	var magnitude := spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
	var energy := clampf((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
	var height := energy * HEIGHT * HEIGHT_SCALE
	data.append(height)
	prev_hz = hz

	var db_volume = roundi(height/100)
	if db_volume >= 8:
		if db_volume >= 12: frame = 5
		else:
			match db_volume:
				8: frame = 1
				9: frame = 2
				10: frame = 3
				11: frame = 4
	else:
		frame = 0

func _ready() -> void:
	spectrum = AudioServer.get_bus_effect_instance(1, 0)
