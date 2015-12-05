package ;

/**
 * ...
 * @author Guinin Mathieu
 */

class Fork 
{
	public var note:SimpleNote;
	public var fork1:Fork;
	public var fork2:Fork;
	public var ratio_fork:Float;
	public var ratio_note:Float;
	
	public function new() {}
}

class Fork_Task implements AudioBuffer.Task {
	
	public var nextTask:AudioBuffer.Task;
	
	var total_time:Float;
	var fork:Fork;
	var start_time:Float;
	
	public function new(fork,start_time:Float,total_time:Float) {
		this.fork = fork;
		this.total_time = total_time;
		var data_offset = Std.int(start_time * 44100 / 8192);
		this.start_time = start_time % (8192 / 44100);
		trace('st_time' + start_time + '    tot' + total_time+'    oft'+data_offset);
		AudioBuffer.addTask(this, data_offset);
	}
	
	public function exec() {
		if (total_time < fork.ratio_note * fork.note.total_time) fork.note.addToBuffer(start_time);
		else {
			var x = fork.ratio_fork * total_time;
			new Fork_Task(fork.fork1, start_time, x);
			new Fork_Task(fork.fork2, start_time + x, total_time-x);
		}
		return 1;
	}
}