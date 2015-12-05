package ;


import flash.events.SampleDataEvent;
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.utils.Endian;
import flash.Memory;

/**
 * ...
 * @author Guinin Mathieu
 */

class AudioBuffer
{

	static public inline var buffer_size = 8 * 8192;
	static inline var buffer_extended = buffer_size + 8 * 2048;
	static inline var task_buf_end = 1024;
	
	public static var buffer:Mem;
	public static var sinusoide:Mem;
	
	static var sound:Sound;
	static var soundChannel:SoundChannel;
	
	static var task_buf:Array<Array<Task>>;
	static var task_index:Int = 0;
	
	
	public static function init() 
	{
		if (buffer != null) return;
		buffer = Mem.alloc(buffer_size + buffer_extended);
		buffer.clear(buffer.start,buffer.end);
		
		// initialisation de la table sinusoide
		sinusoide = Mem.alloc(0x4000);
		var dt:Float = 2 * Math.PI / 0x4000;
		var i:Int = sinusoide.start;
		while (i<sinusoide.end) {
			Memory.setFloat(i, Math.sin(i * dt));
			i += 4;
		}
		task_buf = new Array<Array<Task>>();
		for (i in 0...task_buf_end) task_buf[i] = new Array<Task>();
		
		sound = new Sound();
		sound.addEventListener(SampleDataEvent.SAMPLE_DATA, fillBuffer);
	}
	
	
	static function fillBuffer(e:SampleDataEvent) {
		Mem.copyBytes(Mem.byteArray, buffer.start + buffer_size, buffer_extended, Mem.byteArray, buffer.start);
		
		var task = task_buf[task_index]; // on récuppère les taches correspondant au buffer courrant
		
		var i = 0;
		while (i < task.length) task[i++].exec();
		
		task_buf[task_index] = new Array<Task>(); // on vide la liste des taches pour les prochains buffers
		task_index++; // on incrémente l'index du buffer;
		if(task_index == task_buf_end) task_index = 0; 
		
		e.data.endian = Endian.LITTLE_ENDIAN;
		e.data.length = buffer_size;
		Mem.copyBytes(Mem.byteArray, buffer.start, buffer_size, e.data, 0);
		e.data.position = buffer_size;
	}
	
	public static inline function play() { soundChannel = sound.play(); }
	public static inline function stop() { soundChannel.stop(); }
	
	public static inline function addTask(task:Task, offset:Int) {
		var i:Int;
		if (offset >= task_buf_end) {
			i = (task_index == 0)? task_buf_end - 1 : task_index - 1;
			task = new FarawayTask(task, offset - task_buf_end+1);
		} else i = (task_index + offset) % task_buf_end;
		var buf = task_buf[i];
		buf[buf.length] = task;
	}
	
	
}

interface Task {
	function exec():Void;
}

class FarawayTask implements Task {
	var task:Task;
	var offset:Int;
	
	public function new(task, offset) {
		this.task = task;
		this.offset = offset;
	}
	
	public function exec() {
		AudioBuffer.addTask(task, offset);
	}
}



