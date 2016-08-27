package ;

import Harmonic;
/**
 * ...
 * @author Mathieu Guinin
 */
class SimpleInstrument implements AudioBuffer.Task
{

	var harmonics:Array<Harmonic>;
	
	static var		at;
	static var		mt;
	static var		et;
	static var		ampl_decay;
	static var		decay_rand;
	static var		avr = { rand_init(); avr;}
	
	public static function rand_init() {
		at = Math.pow(Math.random(), 11) * 0.7 + 0.01;
		mt = Math.random() * 0.1 + 0.15;
		et = Math.random() * 0.5 + 0.1;
		ampl_decay = 0.8 * Math.random();
		decay_rand = 0.2 * Math.random();
		avr = ampl_decay + decay_rand / 2;
	}
	
	public function new(freq:Float) 
	{
		var f = freq,
			x = Math.random() * 10 - 5,
			y = Math.random() * 10 - 5,
			ampl = 0.05 * (1 - avr) / (avr - Math.pow(avr, 11));
		harmonics = [
			new SimpleNote(f, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y),
			new SimpleNote(f + Math.pow(Math.random(), 2) * 30, ampl, at, mt, et, x, y),
			new SimpleNote(f/2, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y),
			new SimpleNote(f/2 + Math.pow(Math.random(), 2) * 30, ampl, at, mt, et, x, y),
			new SimpleNote(f/3, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y),
			new SimpleNote(f/3 + Math.pow(Math.random(), 2) * 30, ampl, at, mt, et, x, y),
			new SimpleNote(f/4, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y),
			new SimpleNote(f/5, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y),
			new SimpleNote(f/6, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y),
			new SimpleNote(f/7, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y),
			new SimpleNote(f/8, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y),
			new SimpleNote(f/9, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y),
			new SimpleNote(f/10, ampl *= ampl_decay + decay_rand * Math.random(), at, mt, et, x, y),
			
			new SimpleNote(200 * Math.exp(Math.random() * 3), Math.random() * 0.001, at, mt, et, x, y),
			new SimpleNote(200 * Math.exp(Math.random() * 3), Math.random() * 0.001, at, mt, et, x, y),
			new SimpleNote(200 * Math.exp(Math.random() * 3), Math.random() * 0.001, at, mt, et, x, y),
			new SimpleNote(200 * Math.exp(Math.random() * 3), Math.random() * 0.001, at, mt, et, x, y),
			new SimpleNote(200 * Math.exp(Math.random() * 3), Math.random() * 0.001, at, mt, et, x, y)
		];
	}
	
	public function exec()
	{}
	
	public function addToBuffer(t:Float) {
		for (h in harmonics)
			h.addToBuffer(t) ;
	}
	
}