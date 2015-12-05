package ;

import haxe.macro.Expr;
import haxe.macro.Context;
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
	
	public var enveloppe:Enveloppe;
	
	public var ampl:Float;
	public var remaining_sample:Int;
	
	public var phase:Int; //sinusoide phase
	
	public var start:Int;
	// décalage en des autres canaux et echos :
	public var delta_0:Int;
	public var delta_1:Int;
	public var delta_2:Int; //echo
	public var delta_3:Int; //echo
	// varialition d'amplitude des autres canaux et echos :
	public var k_1:Float;
	public var k_2:Float; //echo
	public var k_3:Float; //echo
	
	public var echo:Int;
	
	public function new(?model:Harmonic) {
		if (model == null) return;
		enveloppe = model.enveloppe;
		ampl = model.ampl;
		phase = model.phase;
		delta_0 = model.delta_0;
		delta_1 = model.delta_1;
		delta_2 = model.delta_2;
		delta_3 = model.delta_3;
		k_1 = model.k_1;
		k_2 = model.k_2;
		k_3 = model.k_3;
		echo = model.echo;
		remaining_sample = model.remaining_sample;
	}
	
	// ajoute une copie de l'harmonic comme une tâche à effectuer à l'instant t
	public function addToBuffer(t:Float) {
		var ech = Std.int(t * 44100);
		var hmc = new Harmonic(this);
		hmc.start = 8*(ech % 8192);
		AudioBuffer.addTask(hmc,Std.int(ech/8192)) ;
	}
	
	public function exec() {
		var end,end_etape,delta_f,pos1,pos2,pos3:Int;
		var a,up,decay:Float;
		var etape:Etape;
		// transformation des attributs d'objet en variables locales pour la performance 
		var pos=start+delta_0,ampl = ampl, phase = phase, delta_1 = delta_1, delta_2 = delta_2, delta_3 = delta_3, k_1 = k_1, k_2 = k_2, k_3 = k_3;
		var sin_end = AudioBuffer.sinusoide.end - 4, sin_start = AudioBuffer.sinusoide.start,buffer_end = AudioBuffer.buffer_size+delta_0;
		
		while (true) {
			etape = enveloppe.etape;
			delta_f = etape.delta_f;
			end_etape = pos + remaining_sample*8;
			end = end_etape > buffer_end? buffer_end : end_etape;
			switch (etape.type) {
				case 0: 
					up = (etape.ampl_fin - ampl) / remaining_sample;
					WAVE.TYPE(ampl += up);
				case 1:
					WAVE.TYPE(null);
				case 2: 
					decay = Math.pow(etape.ampl_fin / ampl, 1 / remaining_sample);
					WAVE.TYPE(ampl *= decay);
			}
			
			if (end_etape > buffer_end) {
				remaining_sample = (end_etape-end) >> 3;
				this.start = AudioBuffer.buffer.start;
				this.ampl = ampl; 
				this.phase = phase; 
				AudioBuffer.addTask(this, 1); // l'écriture continura imédiatement au prochain buffer (offset 1)
				return;
			} else {
				enveloppe = enveloppe.next();
				if (enveloppe == null) return;
				else remaining_sample = enveloppe.etape.samples;
			}
		}
	}
	
}

class Etape {
	public var ampl_fin:Float;
	public var samples:Int;
	public var delta_f:Int; // phase step (frequency)
	public var type:Int;
	
	public function new(?etape:Etape) {
		if (etape == null) return;
		ampl_fin = etape.ampl_fin;
		samples = etape.samples;
		delta_f = etape.delta_f;
		type = etape.type;
	}
}



#end


class WAVE {
	
	static function LOOP(ampl_variation:Expr, write_sample:Expr) {
		return macro {
			
			while (pos < end) {
				a = ampl * Memory.getFloat(sin_start + ((phase += delta_f) & 0x3fff));
				
				$write_sample; // addition des échentillons dans le buffer (oreille droite, gauche, echos...)
				pos += 8;
				$ampl_variation; 
			}
		}
	}
	
	@:macro public static function TYPE(ampl_variation:Expr) {
		var write_sample:Expr = macro {
				Memory.setFloat(pos, Memory.getFloat(pos) + a);
				pos1 = pos + delta_1;
				Memory.setFloat(pos1, Memory.getFloat(pos1) + a * k_1);
			};
		var write_sample_echo = macro {
				$write_sample;
				pos2 = pos + delta_2;
				Memory.setFloat(pos2, Memory.getFloat(pos2) + a * k_2);
				pos3 = pos + delta_3;
				Memory.setFloat(pos3, Memory.getFloat(pos3) + a * k_3);
			};
			
		return {expr : EIf(macro echo == 0,
					LOOP(ampl_variation, write_sample),
					LOOP(ampl_variation, write_sample_echo)),
				pos : Context.currentPos()}
	}

}