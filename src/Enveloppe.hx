package ;

/**
 * ...
 * @author Guinin Mathieu
 */

interface Enveloppe {
	public var etape:Harmonic.Etape;
	public var next_enveloppe:Enveloppe;
	public function next():Enveloppe;
}

class Simple implements Enveloppe {
	
	public var etape:Harmonic.Etape;
	public var next_enveloppe:Enveloppe;
	
	public function new(etape) { this.etape = etape; }
	
	public function next():Enveloppe {
		return next_enveloppe;
	}
}

class Boucle implements Enveloppe {
	
	public var etape:Harmonic.Etape;
	public var liste:Array<Harmonic.Etape>;
	public var next_enveloppe:Enveloppe;
	var i:Int;
	var imax:Int;
	
	public function new(liste, iteration) { 
		i = 0;
		imax = iteration;
		this.liste = liste;
		etape = liste[0];
	}
	
	public function next():Enveloppe {
		i++;
		if (i > imax) return next_enveloppe;
		else {
			etape = liste[i % liste.length];
			return this;
		}
	}
}

class Transform implements Enveloppe {
	public var etape:Harmonic.Etape;
	public var liste:Harmonic.Etape;
	public var next_enveloppe:Enveloppe;
	var trans:Harmonic.Etape-> Harmonic.Etape;
	var i:Int;
	var imax:Int;
	
	public function new(etape:Harmonic.Etape,iteration:Int,trans:Harmonic.Etape->Harmonic.Etape) {
		this.etape = new Harmonic.Etape(etape);
		this.trans = trans;
		imax = iteration;
		i = 0;
	}
	
	public function next():Enveloppe {
		i++;
		if (i > imax) return next_enveloppe;
		else {
			etape = trans(etape);
			return this;
		}
	}
}