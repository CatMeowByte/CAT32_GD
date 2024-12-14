extends RefCounted

# Dependency
static var FPS
static var SAMPLE

const NOTE_FREQUENCY = {
	"C": 261.63,
	"C#": 277.18,
	"D": 293.66,
	"D#": 311.13,
	"E": 329.63,
	"F": 349.23,
	"F#": 369.99,
	"G": 392.00,
	"G#": 415.30,
	"A": 440.00,
	"A#": 466.16,
	"B": 493.88
}

static var _speaker: AudioStreamPlayer
static var volume: float = 1.0
static var play: bool = true

static var _buffer: Array[Array] = [] # Fill with frequency and duration
static var _frequency: float = 0.0
static var _duration: float = 0.0
static var _phase: float = 0.0

static var playback: AudioStreamGeneratorPlayback


func _setup() -> void:
	_speaker.get_stream().set_mix_rate(SAMPLE)
	_speaker.get_stream().set_buffer_length(1.0 / FPS)
	_speaker.play()
	playback = _speaker.get_stream_playback()


func _process_buffer(delta: float) -> void:
	if not play:
		return

	if _duration <= 0.0:
		if not _buffer:
			play = false
			return

		# read
		_frequency = _buffer[0][0]
		_duration = _buffer[0][1] + _duration
		_buffer.pop_front()
	else:
		_duration -= delta

		# buffer
		for i in range(playback.get_frames_available()):
			playback.push_frame(Vector2.ONE * sin(_phase * TAU) * volume)
			_phase = fmod(_phase + (_frequency / SAMPLE), 1.0)


func get_freq(note: String, octave: int) -> float:
	var key = note.to_upper()
	if key not in NOTE_FREQUENCY.keys():
		return 0.0

	return NOTE_FREQUENCY[key] * (2 ** (octave - 4))


func play_tone(frequency: float, duration: float, immediate: bool = false) -> void:
	if immediate:
		_buffer.clear()

	_buffer.append([frequency, duration])
	play = true
