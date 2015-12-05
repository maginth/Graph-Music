package ;

#if flash
import flash.Memory;
import haxe.macro.Expr;

/**
 * Harmonic est une Task de l'AudioBuffer, son rôle est d'ajouter une harmonique en additionnant 
 * les échantillons d'une sinusoïde aux échantillons du buffer audio.
 * On distingue 3 type de phase à l'harmonique :
	 * la phase de monté paramétrable avec "up". l'amplitude "ampl" est incrémenté de "up" à chaque échantillon.
	 * la phase constante de duré "middle" échantillons.
	 * la phase de descente (exponentielle), l'amplitude "ampl" est multiplié par "decay" à chaque échantillon (0 < decay < 1).
 * 
 * Une copie ou plus de chaque échantillon est additionné au buffer pour chaque canal audio (son stéréo) et pour les effets d'echos.
 * Les copies sont additionné avec un décalage et une amplitude différente pour créer des sons 3D
 * 
 * @author Guinin Mathieu
 */


class Harmonic implements AudioBuffer.Task {
	public var nextTask:AudioBuffer.Task;
	
	public var ampl:Float;
	public var ampl_max:Float;
	public var up:Float;
	public var middle:Int;
	public var decay:Float;
	
	public var phase:Int;
	
	public var delta_f:Int;
	
	public var start:Int;
	// décalage en des autres canaux et echos :
	public var delta_1:Int;
	public var delta_2:Int; //echo
	public var delta_3:Int; //echo
	// varialition d'amplitude des autres canaux et echos :
	public var k_1:Float;
	public var k_2:Float; //echo
	public var k_3:Float; //echo
	
	public var type:Int;
	public var echo:Int;
	
	public function new() {}
	
	public function exec() {
		var end,pos1,pos2,pos3:Int;
		var a:Float;
		// transformation des attributs d'objet en variables locales pour la performance 
		var pos=start,type=type,ampl = ampl, up = up, decay = decay, phase = phase, delta_f = delta_f, delta_1 = delta_1, delta_2 = delta_2, delta_3 = delta_3, k_1 = k_1, k_2 = k_2, k_3 = k_3;
		var sin_end = AudioBuffer.sinusoide.end, sin_mod = -AudioBuffer.sinusoide.length,buffer_end = AudioBuffer.buffer_size;
		
		do {
			if (echo == 0) WAVE.TYPE(0);
			else WAVE.TYPE(1);
		} while (type <3 && end < buffer_end);
		
		// enregistrement des variable locales dans les attributs d'objet pour continuer le travaille au prochain buffer
		if (type <3) {
			this.middle = start+middle-end; // temps restant en type 1 (amplitude constante) après interruption (fin du buffer des échantillons audio) 
			this.start = AudioBuffer.buffer.start;
			this.ampl = ampl; 
			this.phase = phase; 
			this.type = type;
			AudioBuffer.addTask(this, 0); // l'écriture continura imédiatement au prochain buffer (offset 0)
		}
	}
	
}

#end

import haxe.macro.Expr;
import haxe.macro.Context;

class WAVE {
	
	static function LOOP(calc_end:Expr,ampl_variation:Expr, write_sample:Expr) {
		return macro {
			end = $calc_end;
			trace('type ' + type + '  echantillons ' + (end - pos)+'  pos '+pos+'  end '+end+' ampl '+ampl);
			if (end > buffer_end) end = buffer_end;
			else type++;
			while (pos < end) {
				a = ampl * Memory.getFloat(phase);
				phase += delta_f;
				if (phase > sin_end) phase += sin_mod;
				
				$write_sample; // addition des échentillons dans le buffer (oreille droite, gauche, echoes...)
				pos += 8;
				$ampl_variation; 
			}
		}
	}
	
	@:macro public static function TYPE(echo:Int) {
		var write_sample:Expr = macro {
				Memory.setFloat(pos, Memory.getFloat(pos) + a);
				pos1 = pos + delta_1;
				Memory.setFloat(pos1, Memory.getFloat(pos1) + a * k_1);
			};
		if (echo > 0)
			write_sample = macro {
				$write_sample;
				pos2 = pos + delta_2;
				Memory.setFloat(pos2, Memory.getFloat(pos2) + a * k_2);
				pos3 = pos + delta_3;
				Memory.setFloat(pos3, Memory.getFloat(pos3) + a * k_3);
			};
			
		return {expr : EIf(macro type == 0,
				LOOP(macro Std.int((ampl_max - ampl) / up) * 8 + pos , macro ampl += up, write_sample),
				{expr : EIf(macro type == 1, 
					LOOP(macro pos + middle , macro 0, write_sample),
					LOOP(macro Std.int(Math.log(0.01/ampl)/Math.log(decay)) * 8 + pos , macro ampl *= decay, write_sample)),
				pos : Context.currentPos()}
				),
		pos : Context.currentPos()};
	}

}