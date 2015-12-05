package ;

/**
 * ...
 * @author Guinin Mathieu
 */

class SimpleNote extends Harmonic
{
	inline static var ampl_min = 0.01;
	
	public var total_time:Float;
	
	public function new(freq:Float,ampl:Float,attack:Float,middle:Float,decay:Float,x:Float,y:Float) 
	{
		super();
		total_time = attack + middle + decay;
		// différence de marche au première ordre pour un écart de 20cm entres les oreils. célérité du son ~300m/s
		var d = Math.sqrt(x * x + y * y);
		var dd = x * 0.2 / d ;
		
		var etape_a = new Harmonic.Etape();
		etape_a.type = 0;
		etape_a.ampl_fin = ampl;
		etape_a.delta_f = 4*Std.int(freq*0x1000/44100);
		etape_a.samples = Std.int(attack * 44100);
		
		var etape_m = new Harmonic.Etape(etape_a);
		etape_m.type = 1;
		etape_m.samples = Std.int(middle * 44100);
		
		var etape_d = new Harmonic.Etape(etape_a);
		etape_d.type = 2;
		etape_d.ampl_fin = ampl_min;
		etape_d.samples = Std.int(decay *44100*Math.log(ampl_min/ampl)/Math.log(0.5)); // log(min/max)/log(1/2) avec decay=demie vie
		
		var ea = new Enveloppe.Simple(etape_a);
		var em = new Enveloppe.Simple(etape_m);
		var ed = new Enveloppe.Simple(etape_d);
		ea.next_enveloppe = em;
		em.next_enveloppe = ed;
		
		this.enveloppe = ea;
		this.ampl = 0;
		this.delta_0 = 8*Std.int((d - dd) * 0.003 * 44100);
		this.delta_1 = 4+8*Std.int((d + dd) * 0.003 * 44100);
		this.echo = 0;
		this.k_1 = 1;
		this.phase = 0;
		this.remaining_sample = etape_a.samples;
	}
	
}