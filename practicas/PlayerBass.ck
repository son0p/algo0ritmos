public class PlayerBass
{
    BPM.beat(0.25) => dur beat;
    BPM.root - 24 => int root;
	// Instancio clases
	Generator generator;
    SynthBass synthBass;
    Event event;


	// Esta funcion toca un array multidimensonal que trae
	// en este caso tres arrays uno de  kick, otro sn, y hh.
	fun void arrays( float arrays[][] )
	{
       	0 => int i;
		//conformo los arrays de origen
		// DO => hacerlo dinamico
		arrays[0] @=> float sourceArray1[];
		arrays[1] @=> float sourceArray2[];
		arrays[2] @=> float sourceArray3[];

		// creo arrays que van a contener el resultado
		// transformado
		float transArray1[arrays[0].cap()];
		float transArray2[arrays[1].cap()];
		float transArray3[arrays[2].cap()];

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
          i % sourceArray1.cap() => int loop;// TODO: se mide segun un array, debe protegerse contra arrays de otros tamaños en los arrays de abajo del array multidimensional
            // El bajo suena si la posición del contador habita en el array
            for(0 => int ii; ii < sourceArray1.cap();ii++)
            {
                if ( sourceArray3[ii] == i)
                {
                   spork~ synthBass.playNote(root + sourceArray1[ii], sourceArray2[ii] );
               }
            }
            beat => now;
            i++;
		}
	}
}

//------ Test ----------
// [
// [
// [0.0,  -2, 0  ],
// [.50, .50, .50],
// [0.0,  4,  8 ]
// ]
// ]@=> float liveBass[][][];
