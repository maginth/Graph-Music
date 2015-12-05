package ;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import flash.Memory;
import flash.utils.ByteArray;

/**
 * ...
 * @author Guinin Mathieu
 */

class Main 
{
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		/*
		var ba:ByteArray = new ByteArray();
		ba.length = 256*2;
		ba.position = 0;
		var f:Float = 0;
		for (i in 0...64) ba.writeInt(i);
		ba.position = 0;
		ba.readBytes(ba, 256, 256);
		ba.position = 4*48;
		for (i in 0...20) trace(ba.readInt());
		*/
		//*
		Mem.select();
		trace("debut");
		AudioBuffer.init();
		trace("buffer initialisé");
		//*
		for (i in 0...1000) {
			var wave:Harmonic = new Harmonic();
			wave.ampl = 0;
			wave.ampl_max = Math.random()*0.1+0.1;
			wave.decay = 0.999;
			wave.delta_1 = 4;
			wave.delta_f = 4*Std.random(100)+4;
			wave.echo = 0;
			wave.k_1 = 1;
			wave.middle = 8*Std.random(5000);
			wave.phase = 0;
			wave.start = AudioBuffer.buffer.start + 8*Std.random(100);
			wave.type = 0;
			wave.up = wave.ampl_max / (1 + Std.random(2000));
			
			AudioBuffer.addTask(wave,Std.random(1024));
		}
		//*/
		/*{
			var wave:Harmonic = new Harmonic();
			wave.ampl = 0;
			wave.ampl_max = 0.5;
			wave.decay = 0.9999;
			wave.delta_1 = 4;
			wave.delta_f = 4*1;
			wave.echo = 0;
			wave.k_1 = 1;
			wave.middle = 44100*8;
			wave.phase = 500;
			wave.start = AudioBuffer.buffer.start+8*314;
			wave.type = 0;
			wave.up = wave.ampl_max / (10000);
			
			AudioBuffer.addTask(wave,10);
		}*/
		trace("buffer tache remplis");
		AudioBuffer.play();
		trace("play!");
		//*/
	}
	
	
}
