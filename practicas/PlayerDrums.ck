500::ms => dur bit;

public class PlayerDrums
{
	// Instancio clases
	Generator generator;

	// Cadenas de sonido
	SndBuf kks => dac;
	SndBuf sns => dac;
	SndBuf hhs => dac;
	SndBuf bit01 => dac;
	SndBuf bit02 => dac;
	SndBuf bit03 => dac;

	// Samples
	me.dir() + "/audio/kick_01.wav" => kks.read;
	me.dir() + "/audio/hihat_01.wav" => hhs.read;
	me.dir() + "/audio/snare_01.wav" => sns.read;
	me.dir() + "/audio/3048_starpause_k9dhhPulseEffect.wav" => bit01.read;
	me.dir() + "/audio/3049_starpause_k9dhhPulseKick.wav" => bit02.read;
	me.dir() + "/audio/3047_starpause_k9dhhNotSnare.wav" => bit03.read;

	// Por defecto
	0.1 => float globalKksGain => kks.gain;
	0.1 => float globalHhsGain => hhs.gain;
	0.1 => float globalSnsGain => sns.gain;
	0.1 => bit01.gain;
	0.3 => bit02.gain;
	0.1 => bit03.gain;

	// ultimo sample para evitar sonido
	kks.samples() => kks.pos;
	sns.samples() => sns.pos;
	hhs.samples() => hhs.pos;
	bit01.samples() => bit01.pos;
	bit02.samples() => bit02.pos;
	bit03.samples() => bit03.pos;

	// Hacemos un bombo, filtrando un Impuslo.
	Impulse kick => TwoPole kp => dac;
	5000.0 => kp.freq; 0.5 => kp.radius;
	0.3 => kp.gain => float globalKpGain;
    static float toneSustain;
	0.1 => static float toneRelease;
	SinOsc tone => ADSR toneKick => dac;
	toneKick.set(0.001,0.2,toneSustain,0.1);
	0.3 => tone.gain;
	51.9 => tone.freq;


	// ojo RezonZ

	// Hacemos un redoblante, filtrando un Noise.
	Noise n => ADSR snare => TwoPole sp => NRev snRev => dac;
	1000.0 => sp.freq; 0.9 => sp.radius;
	0.05 => static float snSustain;
	snare.set(0.001,snSustain,0.0,0.1);
	0.02 => sp.gain => static float globalSpGain;

	// Hacemos un charles, filtrando un Noise.
	Noise h => ADSR hihat => TwoPole hsp => NRev hhRev => dac;
	10000.0 => hsp.freq; 0.9 => hsp.radius;
	0.05 => float hhSustain;
	hihat.set(0.001,hhSustain,0.0,0.1);
    0.05 => hsp.gain => float globalHspGain;

	// Esta funcion toca un array multidimensonal que trae
	// en este caso tres arrays uno de  kick, otro sn, y hh.
	fun void arrayDrums( int arrays[][] )
	{
		0 => int i;
		// presets cuando no hay transformaciones del sonido
		0.005 => snRev.mix;
		0.03 => hhRev.mix;

		// ---acá intercepto el array buscando inyectar
		// aleatoriedad

		//conformo los arrays de origen
		// DO => hacerlo dinamico
		arrays[0] @=> int sourceArray1[];
		arrays[1] @=> int sourceArray2[];
		arrays[2] @=> int sourceArray3[];

		// creo arrays que van a contener el resultado
		// transformado
		int transArray1[arrays[0].cap()];
		int transArray2[arrays[1].cap()];
		int transArray3[arrays[2].cap()];

		// recorro los array y son variados
		// con una probabilidad de cambio

		for( 0 => int ii; ii < sourceArray1.cap(); ii++)
		{
			if( sourceArray1[ii] == 0 )
			{
				generator.percentChance(5,1) => transArray1[ii];
			}
			if( sourceArray1[ii] == 1 )
			{
                generator.percentChance(100,1) => transArray1[ii];
			}
			 //<<< transArray1[ii] >>>; //DEBUG
		}

		for( 0 => int ii; ii < sourceArray2.cap(); ii++)
		{
			if( sourceArray2[ii] == 0 )
			{
                generator.percentChance(1,1) => transArray2[ii];
			}
			if( sourceArray2[ii] == 1 )
			{
			    generator.percentChance(100,1) => transArray2[ii];
			}
		}
		for( 0 => int ii; ii < sourceArray3.cap(); ii++)
		{
			if( sourceArray3[ii] == 0 )
			{
                generator.percentChance(5,1) => transArray3[ii];
			}
			if( sourceArray3[ii] == 1 )
			{
                generator.percentChance(100,1) => transArray3[ii];
	        }
		}

		// Aquí sueno los arrays: 1 suena, 0 silencio, y hay acentos
		// en los tiempos fuertes.
		while(true)
		{
			i % sourceArray1.cap() => int loop;

			// Suenan los samples
			 //if( transArray1[loop] == 0 ) kks.samples() => kks.pos;
			 //if( transArray1[loop] == 1 ) 0 => kks.pos;
			 //if( transArray2[loop] == 0 ) sns.samples() => sns.pos;
			//if( transArray2[loop] == 1 ) 0 => sns.pos;
			// if( transArray3[loop] == 0 ) hhs.samples() => hhs.pos;
			// if( transArray3[loop] == 1 ) 0 => hhs.pos;

			// suenan los sonidos de drums de syntesis
			if( transArray1[loop] == 0 ) toneKick.keyOff();
			if( transArray1[loop] != 0 ){ toneKick.keyOn(); 1.0 => kick.next;}
			if( transArray2[loop] == 0 ) snare.keyOff();
			if( transArray2[loop] != 0 ) snare.keyOn();
			if( transArray3[loop] == 0 ) hihat.keyOff();
			if( transArray3[loop] != 0 ) hihat.keyOn();

			// Acentos: si esta en tiempos fuertes
			// la ganancia es normal, si esta en tiempos débiles la
			// ganancia se reduce.
			[0,0,0,0,4,0,0,0,8,0,0,0,12,0,0,0,0] @=> int hardBeats[]; // DO => mejor solucion
			if( loop == hardBeats[loop] )
			{
				globalKksGain => kks.gain;
				globalSnsGain => sns.gain;
				globalHhsGain => hhs.gain;
				globalKpGain => kp.gain;
				globalSpGain => sp.gain;
				globalHspGain => hsp.gain;
			}
			if( loop != hardBeats[loop] )
			{
				globalKksGain/2.0 => kks.gain;
				globalSnsGain/1.5 => sns.gain;
				globalHhsGain/3.0 => hhs.gain;
				globalKpGain/2.0 => kp.gain;
				globalSpGain/4.0 => sp.gain;
				globalHspGain/3.0 => hsp.gain;
			}
			bit/4=> now; // quemado para seq de 16 pasos.
			i++;
		}
	}

	// Cambios del sonido
	fun void soundTransformation()
	{
		[0.01, 0.01, 0.01, 0.05, 0.01, 0.001, 0.05, 0.05, 0.09, 0.14] @=> float hhSeeds[];
		[0.01, 0.05, 0.05, 0.05, 0.09, 0.05, 0.03, 0.09] @=> float snSeeds[];
		while(true)
		{
			hhSeeds[Math.random2(0,hhSeeds.cap()-1 )] => hhSustain;
			hihat.set(0.001,hhSustain,0.0,0.1);
			snSeeds[Math.random2(0,snSeeds.cap()-1 )] => snSustain;
			snare.set(0.001,snSustain,0.0,0.1);
			bit/16 => now;
		}
	}

	fun void reverbTransformation(float beatDivision)
	{
	  if (beatDivision == 0){
		  <<< "WARNING: argument for reverbTransformation function must be >= 1">>>;
	  }
	  if (beatDivision >= 1){
	    [0.01, 0.3, 0.4, 0.05, 0.09, 0.05, 0.03, 0.01, 0.01 ] @=> float seeds[];
		while(true)
		{
			seeds[Math.random2(0,seeds.cap()-1 )]*2 => hhRev.mix;
			(seeds[Math.random2(0,seeds.cap()-1 )])/4 => snRev.mix;
			bit*beatDivision => now;
		}
	  }
	}
	//arrayDrums(0,0); // DEBUG

	// Se llaman estas funciones para ritmos fijos, los usaba para
	// livecoding
	fun void kk(int div, int density)
	{
		0 => int i;
		// Un golpe cada 16 beats, usable para cortes.
		if( density == 0 )
		{
			0 => kks.pos;
			8*bit => now;
		}
		// Golpes estables y variación leve
		// al final del compás.
		if( density == 1 )
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
				if( loop8 > 7)
				{
					[1, 1, 1, 1,  2, 4] @=> int seed[];
					1.0 => kick.next;
					kks.samples() => kks.pos;
					bit/seed[(Math.random2(0, seed.cap()-1))] => now;
				}
				i++;
			}
		}
		// Golpes estables y variación
		// al final del compás.
		if( density == 2)
		{
			while(true)
			{
				i % 8 => int loop8;
				if( loop8 < 4)
				{
					1.0 => kick.next;
					0 => kks.pos;
					bit/div => now;
				}
				if( loop8 > 4 )
				{
					[1, 1, 1, 1,  2, 4] @=> int seed[];
					1.0 => kick.next;
					kks.samples() => kks.pos;
					bit/seed[(Math.random2(0, seed.cap()-1))] => now;
				}
				i++;
			}
		}

		if( density == 3)
		{
			while(true)
			{
				i % 8 => int loop8;
				if( loop8 < 4)
				{
					1.0 => kick.next;
					0 => kks.pos;
					bit/div => now;
				}
				if( loop8 > 4 )
				{
					[1, 2, 4, 4, 8] @=> int seed[];
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
		0 => int i;
		while(true)
		{
			i % 8 => int loop8;
			if( loop8 < 7)
			{
				hhs.samples() => hhs.pos;
				bit/2 => now;
				//	hihat.keyOn();
				0 => hhs.pos;
				bit/2 => now;
				//	hihat.keyOff();
				0 => hhs.pos;
			}
			if( loop8 >= 7)
			{

				hhs.samples() => hhs.pos;
				bit/2 => now;
				0 => hhs.pos; globalHhsGain - 0.05 => hhs.gain;
				bit/4 => now;
				0 => hhs.pos; globalHhsGain  => hhs.gain;
				bit/4 => now;
			}
			i++;

		}
	}
	// Función para manejar sonidos de 8bit.
	fun void bi(int div, int density)
	{
		0 => int i;
		if( density == 0 )
		{
			12*bit => now;
			while( true )
			{
				0 => bit03.pos;
				bit/div => now;
			}
		}
		if( density == 1 )
		{
			while(true)
			{
				i % 8 => int loop8;
				if( loop8 < 7)
				{
					0 => bit02.pos;
					bit/div => now;

				}
				if( loop8 > 7)
				{
					[1, 1, 1, 1,  2, 4] @=> int seed[];
					bit01.samples() => bit01.pos;
					bit/seed[(Math.random2(0, seed.cap()-1))] => now;
				}
				i++;
			}
		}
		if( density == 2)
		{
			while(true)
			{
				i % 8 => int loop8;
				if( loop8 < 4)
				{
					0 => bit01.pos;
					bit/div => now;
				}
				if( loop8 > 4 )
				{
					[1, 1, 1, 1,  2, 4] @=> int seed[];
					bit01.samples() => bit01.pos;
					bit/seed[(Math.random2(0, seed.cap()-1))] => now;
				}
				i++;
			}
		}
		if( density > 2)
		{
			while(true)
			{
				i % 16 => int loop8;
				if( loop8 < 4)
				{
					0 => bit03.pos;
					bit/div => now;

				}
				if( (loop8 > 4) && (loop8 < 12) )
				{
					[1, 1, 3, 3] @=> int seed[];
					0 => bit01.pos;
					bit/seed[(Math.random2(0, seed.cap()-1))] => now;

				}
				if( loop8 > 12 )
				{
					[1, 1, 1, 3, 3] @=> int seed[];
					0 => bit02.pos;
					bit/seed[(Math.random2(0, seed.cap()-1))] => now;

				}
				i++;
			}
		}
	}

}


// ======= TEST

// [[
// [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
// [0,0,0,0,1,0,0,0,1,0,0,1,0,0,1,0],
// [1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0]
// ],

// [
// [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
// [1,0,0,0,1,0,0,0,1,0,0,1,0,0,1,0],
// [1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1]
// ],

// [
// [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
// [1,1,0,0,1,0,0,0,1,0,0,1,0,0,1,0],
// [1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1]
// ],

// [
// [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
// [0,0,1,0,1,0,0,0,1,0,0,1,0,0,1,0],
// [1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1]
// ]

// ]@=>  int fav1[][][];

// Drummer dr;
// dr.arrayDrums(fav1[0]);
