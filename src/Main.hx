package ;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import flash.Memory;
import flash.utils.ByteArray;
import flash.display.Sprite;

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
		/*
		var f = 200 * Math.exp(Math.random() * 3),
			at = Math.pow(Math.random(), 3) * 0.1 + 0.1,
			mt = Math.random() * 0.1 + 0.05,
			et = Math.random() * 0.2 + 0.1,
			x = Math.random() * 10 - 5,
			y = Math.random() * 10 - 5,
			ampl_decay = 0.8 * Math.random(),
			decay_rand = 0.8 * Math.random(),
			avr = ampl_decay + decay_rand / 2,
			ampl = 0.2 * (1 - avr) / (avr - Math.pow(avr,11));
		new SimpleNote(f, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y).addToBuffer(0);
		new SimpleNote(f/2, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y).addToBuffer(Math.random()*0.01);
		new SimpleNote(f/3, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y).addToBuffer(Math.random()*0.01);
		new SimpleNote(f/4, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y).addToBuffer(Math.random()*0.01);
		new SimpleNote(f/5, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y).addToBuffer(Math.random()*0.01);
		new SimpleNote(f/6, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y).addToBuffer(Math.random()*0.01);
		new SimpleNote(f/7, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y).addToBuffer(Math.random()*0.01);
		new SimpleNote(f/8, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y).addToBuffer(Math.random()*0.01);
		new SimpleNote(f/9, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y).addToBuffer(Math.random()*0.01);
		new SimpleNote(f / 10, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y).addToBuffer(Math.random() * 0.01);
		
		new SimpleNote(200 * Math.exp(Math.random() * 3), Math.random() * 0.1, at, mt, et, x, y).addToBuffer(0);
		new SimpleNote(200 * Math.exp(Math.random() * 3), Math.random() * 0.1, at, mt, et, x, y).addToBuffer(Math.random()*0.01);
		new SimpleNote(200 * Math.exp(Math.random() * 3), Math.random() * 0.1, at, mt, et, x, y).addToBuffer(Math.random()*0.01);
		new SimpleNote(200 * Math.exp(Math.random() * 3), Math.random() * 0.1, at, mt, et, x, y).addToBuffer(Math.random()*0.01);
		new SimpleNote(200 * Math.exp(Math.random() * 3), Math.random() * 0.1, at, mt, et, x, y).addToBuffer(Math.random()*0.01);
		/*//*
		for (i in 0...100) {
			new SimpleNote(Math.random() * 1000, 0.1, Math.random() * 0.1, Math.random() * 0.2, Math.random(), Math.random() * 10 - 5, Math.random() * 10 - 5).addToBuffer(Math.random()*10);
		}
		*///*
		var base_tempo = 0.2 + 0.6 * Math.random();
		var var_tempo = base_tempo * Math.pow(Math.random(), 3);
		var base_duree = 2 * base_tempo * Math.random();
		var var_duree = base_duree * Math.pow(Math.random(), 3);
		var nb_fork = 50;
		var forks = new Array<Fork>();
		for (i in 0...nb_fork) {
			var f = forks[i] = new Fork();
			f.task = new SimpleInstrument(Math.pow(2, 7 + (i % 50) / 50 * 4));/* ,
									0.2,//0.04*Math.pow(2, 1-i/nb_fork),
									0.001,//Math.pow(Math.random(), 2) * 0.05,
									0.1,//Math.pow(Math.random(), 2) * 0.2,
									0.3,//Math.random(),
									Math.random() * 10 - 5,
									Math.random() * 10 - 5);*/
			f.ratio_fork = Math.random();
			f.ratio_decalage = base_tempo - var_tempo * Math.pow(Math.random(), 3);
		}
		for (i in 0...nb_fork) 
		{
			var f = forks[i];
			var i1 = i + (2 * Std.random(2) - 1) * (1 + Std.random(3) * Std.random(3) +Std.random(3)*Std.random(3)*Std.random(3));
			var i2 = i + (2 * Std.random(2) - 1) * (1 + Std.random(3) * Std.random(3) +Std.random(3)*Std.random(3)*Std.random(3));
			i1 = (i1<0)? nb_fork+i1 : (i1>=nb_fork)? i1-nb_fork : i1;
			i2 = (i2<0)? nb_fork+i2 : (i2>=nb_fork)? i2-nb_fork : i2;
			f.fork1 = forks[i1];
			f.fork2 = forks[i2];
		}
		var context = new MusicContext(0.2);
		new Fork.Fork_Task(forks[0], 0, 3600*12, context);
		//*/
		
		AudioBuffer.play();
	}
}
