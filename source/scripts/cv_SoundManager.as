import mx.events.EventDispatcher;
//
class scripts.cv_SoundManager {
	static var dispatchEvent:Function;
	private var addEventListener:Function;
	private var removeEventListener:Function;
	private var sound_array:Array;
	private var __local:MovieClip;
	private var muteSound:Boolean;
	private var files_array:Array;
	//////////////////
	// SoundManager //
	//////////////////
	public function cv_SoundManager(parent_mc:MovieClip) {
		__local = parent_mc;
		__local.createEmptyMovieClip("SoundManager_holder", __local.getNextHighestDepth());
		muteSound = false;
		sound_array = [];
		EventDispatcher.initialize(this);
	}
	// loadFile //
	public function loadFile(files:Array, idx:Number) {
		files_array = files;
		//
	}
	// addSound //
	public function addSound(new_sound:String):Number {
		var temp_holder:MovieClip = __local.SoundManager_holder.createEmptyMovieClip(new_sound + "_sound", __local.SoundManager_holder.getNextHighestDepth());
		var ary_length = sound_array.length;
		temp_holder.pause_pos = 0;
		temp_holder.def_sound = new Sound(temp_holder);
		temp_holder.def_sound.attachSound(new_sound);
		if (muteSound == true) {
			temp_holder.def_sound.setVolume(0);
		} else {
			temp_holder.def_sound.setVolume(100);
		}
		sound_array.push(temp_holder);
		// If first entry
		if (ary_length == undefined) {
			ary_length = 0;
		}
		return ary_length;
	}
	// removeSound //
	public function removeSound(ary_idx:Number):Void {
		var temp_holder = sound_array[ary_idx];
		sound_array.splice(ary_idx, 1);
		temp_holder.removeMovieClip();
	}
	// playSound //
	public function playSound(ary_idx:Number):Void {
		var temp_holder = sound_array[ary_idx];
		if (muteSound) {
			temp_holder.def_sound.setVolume(0);
		} else {
			temp_holder.def_sound.setVolume(100);
		}
		temp_holder.def_sound.start(temp_holder.pause_pos);
	}
	// stopSound //
	public function stopSound(ary_idx:Number):Void {
		var temp_holder = sound_array[ary_idx];
		temp_holder.pause_pos = 0;
		temp_holder.def_sound.stop();
	}
	// stopAll //
	public function muteAll(bool:Boolean):Void {
		for (var i = 0; i < sound_array.length; i++) {
			var temp_holder = sound_array[i];
			if (bool == true) {
				temp_holder.def_sound.setVolume(0);
			} else {
				temp_holder.def_sound.setVolume(100);
			}
		}
		muteSound = bool;
	}
	// pauseSound //
	public function pauseSound(ary_idx:Number):Void {
		var temp_holder = sound_array[ary_idx];
		temp_holder.pause_pos = (temp_holder.def_sound.position / 1000);
		temp_holder.def_sound.stop();
	}
	public function getSounds():Object {
		var return_obj = new Object();
		for (var i = 0; i < sound_array.length; i++) {
			return_obj[sound_array[i]].index = i;
			return_obj[sound_array[i]].sound = sound_array[i].substr(0, sound_array[i].length - 6);
		}
		return return_obj;
	}
}
