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
		
		Mem.select();
		AudioBuffer.init();
		
		var forks = new Array<Fork>();
		for (i in 0...100) {
			var f = forks[i] = new Fork();
			f.note= new SimpleNote(Math.random() * 1000, 0.1, Math.random() * 0.1, Math.random() * 0.2, Math.random(), Math.random() * 10 - 5, Math.random() * 10 - 5);
			f.ratio_fork = Math.random();
			f.ratio_note = Math.random();
		}
		for (i in 0...100) 
		{
			var f = forks[i];
			f.fork1 = forks[Std.random(100)];
			f.fork2 = forks[Std.random(100)];
		}
		new Fork.Fork_Task(forks[0], 0, 180);
		
		AudioBuffer.play();
	}
}
