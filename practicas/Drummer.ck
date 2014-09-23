500::ms => dur bit;
public class Drummer
{

	SndBuf kks => dac;
	SndBuf sns => dac;
	SndBuf hhs => dac;
	
	me.dir() + "/audio/kick_01.wav" => kks.read; 
	me.dir() + "/audio/hihat_01.wav" => hhs.read;
	me.dir() + "/audio/snare_01.wav" => sns.read;

	0.3 => kks.gain;
	0.3 => hhs.gain;
	
	// ultimo sample para evitar sonido
	kks.samples() => kks.pos;
	sns.samples() => sns.pos;
	hhs.samples() => hhs.pos;
	// Hacemos un bombo, filtrando un Impuslo.
	Impulse kick =>TwoPole kp => dac;
	50.0 => kp.freq; 0.99 => kp.radius; 1 => kp.gain;

	
	
	// Hacemos un redoblante, filtrando un Noise.
	Noise n => ADSR snare => TwoPole sp  => dac;
	800.0 => sp.freq; 0.9 => sp.radius; 0.1 => sp.gain;
	snare.set(0.001,0.1,0.0,0.1);
	
	// Hacemos un charles, filtrando un Noise.
	Noise h => ADSR hihat => TwoPole hsp => dac;
	5000.0 => hsp.freq; 0.9 => hsp.radius; 0.1 => hsp.gain;
	hihat.set(0.001,0.1,0.0,0.1);

	
	fun void kk(int div, int density)
	{
		0 => int i;
		if( density == 0 )
		{
			0 => kks.pos;
			8*bit => now;
		}
		else
		{
			while(true)
			{
				i % 8 => int loop8;
				if( loop8 < 7)
				{ 
					1.0 => kick.next;
					0 => kks.pos;	
					bit/div => now;
				}
				else
				{
					[1, 1, 1, 1,  2, 4] @=> int seed[];
					1.0 => kick.next;
					kks.samples() => kks.pos;	
					bit/seed[(Math.random2(0, seed.cap()-1))] => now;
				}
				i++;
			}
		}
	}
	
	// Una función que ejecuta un redoblante
	// dejando una negra en silencio. 
	fun void sn()
	{
		0 => int i;
		while(true)
		{
			i % 8 => int loop8;
			if ( loop8 < 7)
			{
				bit => now;
				//snare.keyOn();
				0 => sns.pos;	
				bit => now;
				//snare.keyOff();
			}
			else
			{
				[1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 4, 8] @=> int seed[];
				bit/seed[(Math.random2(0, seed.cap()-1))] => now;
				//snare.keyOn();
				0 => sns.pos;	
				bit/seed[(Math.random2(0, seed.cap()-1))] => now;
				//snare.keyOff();
			}
			i++;
			
		}
	}
	
	// Una función que ejecuta el hihat
// dejando un silencio de corchea.
	fun void hh()
	{
		while(true)
		{
			hhs.samples() => hhs.pos;
			bit/2 => now;
		//	hihat.keyOn();
			0 => hhs.pos;	
			bit/2 => now;
		//	hihat.keyOff();
			0 => hhs.pos;
		}
	}
}