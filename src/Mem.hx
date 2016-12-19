package ;

import flash.Memory;
import flash.text.TextFieldAutoSize;
import flash.utils.Endian;
import flash.utils.ByteArray;
import flash.Vector;
/**
 * ...
 * @author Guinin Mathieu
 */


class Mem
{

	static public var byteArray(default,null):ByteArray;
	static var start_zone:Mem;			// premiere zone memoire occupe
	static var free_zone:Mem;			// zones memoire libre
	
	public var start:Int; // start in byteArray
	public var end:Int; // end in byteArray
	
	var next:Mem; // Mem are sorted in a list
	var prec:Mem;
	
	public var length(get_length, null):Int;
	
	
	
	function new(start,end,prec,next) 
	{
		this.start = start;
		this.end = end;
		this.next = next;
		this.prec = prec;
	}
	
	static public function alloc(size:Int):Mem {
		free_zone.start = free_zone.prec.end; // au cas où de la memoir a été libéré à la fin de la plage précédente
		var start:Int = free_zone.start;
		var end:Int = (size>0)? start + size : free_zone.end; // si size est <0 toute la memoire libre est aloue
		if (end > free_zone.end) {				// il n'y a plus de place, on essaye de defragmenter pour en faire
			Mem.defrag();
			start = free_zone.start;
			end = start + size;
			if (end > free_zone.end) {			// si la defragmentation n'a pas suffit on agrandit la memoire
				byteArray.length = free_zone.end = end + 0xFFFFF; // marge de 1Mb pour nouvelles allocutions
				Memory.select(byteArray);
			}
		}
		free_zone.start = end; // la zone libre et la derniere zone occupe sont contigus
		var res = new Mem(start, end, free_zone.prec, free_zone);
		res.next.prec = res;
		res.prec.next = res;
		return res;
	}
	
	
	public inline function free() {
		prec.next = next;
		next.prec = prec;
		next = prec = null; // in case it is free two times
	}
	
	
	inline function get_length():Int {
		return end-start;
	}
	
	
	static function defrag() {
		var m:Mem = start_zone;
		var pos:Int = 0; 
		while (m.start == pos && m != free_zone) { // on recherche le premier emplacement libre
			pos = m.end;
			m = m.next;
		}
		var end:Int ; var delta:Int;
		while (m != free_zone) {
			byteArray.position = m.start;
			delta = m.start - pos;
			do {
				end = m.end;
				m.start -= delta;
				m.end -= delta;
				m = m.next;
			} while (m != free_zone && m.start == end); // quand les Mem sont contigus, on les déplace en un seul bloc
			byteArray.readBytes(byteArray, pos, end-byteArray.position); 
			pos = end-delta;
		}
		free_zone.start = pos;
	}
	
	
	
	
	static public function select(size:Int=0xFFFFF) {
		
		byteArray = new ByteArray();
		byteArray.length = size;
			
		Memory.select(byteArray);
		
		start_zone = new Mem(0,0,null,null);
		free_zone = new Mem(0,size,null,null);
		
		start_zone.start = 0;
		start_zone.end = 0; 
		start_zone.next = free_zone;
		
		free_zone.start = 0;
		free_zone.end = size;
		free_zone.prec = start_zone;
		
		return byteArray;
	}
	
	static var clearByteArray:ByteArray = {
		var res = new ByteArray();
		res.length = 1024;
		res;
	}
	
	public inline function clear(pos1:Int, pos2:Int) {
		byteArray.position = pos1;
		while ((pos1 += 1024) < pos2) clearByteArray.writeBytes(byteArray, 0, 1024);
		clearByteArray.writeBytes(byteArray, 0, (pos2-pos1)&0x3ff);
	}
	
	public inline function copyAllFrom(ba:ByteArray) {
		byteArray.position = start;
		byteArray.writeBytes(ba, 0, length);
	}
	
	public inline function copyAllInto(ba:ByteArray) {
		byteArray.position = start;
		ba.readBytes(byteArray, 0, ba.length);
	}
	
	public static inline function copyBytes(from:ByteArray,from_start:Int,from_length:Int,into:ByteArray,into_start:Int) { // "to" endian must be Endian.LITTLE_ENDIAN
		from.position = from_start;
		from.readBytes(into, into_start, from_length);
	}
	
}









