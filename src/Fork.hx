package ;

/**
 * ...
 * @author Guinin Mathieu
 */

class Fork 
{
	public var task:AudioBuffer.Task;
	public var fork1:Fork;
	public var fork2:Fork;
	public var ratio_fork:Float;
	public var ratio_decalage:Float;
	
	public function new() {}
}

class Fork_Task implements AudioBuffer.Task {
	
	var total_time:Float;
	var fork:Fork;
	var start_time:Float;
	var context:MusicContext;
	
	public function new(fork,start_time:Float,total_time:Float, context:MusicContext) {
		this.fork = fork;
		this.context = context;
		this.total_time = total_time;
		var data_offset = Std.int(start_time * 44100 / 8192);
		this.start_time = start_time % (8192 / 44100);
		AudioBuffer.addTask(this, data_offset);
	}
	
	public function exec() {
		var x = fork.ratio_fork * total_time;
		x -= x % context.tempo;
		if (total_time > context.tempo && x > 0.001) {
			new Fork_Task(fork.fork1, start_time, x, context);
			new Fork_Task(fork.fork2, start_time + x, total_time-x, context);
		} else
			fork.task.addToBuffer(start_time);
	}
	
	public function addToBuffer(t:Float)
	{
		//var data_offset = Std.int(t * 44100 / 8192);
		//this.start_time = start_time % (8192 / 44100);
		//AudioBuffer.addTask(this, data_offset);
		//AudioBuffer.addTask(this, data_offset);
	}
}