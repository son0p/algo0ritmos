public class PlayerDrums
{
  BPM.beat(1) => dur beat;
  // Instancio clases
  Generator generator;
  RimShot01 rs;
  BD101kjz BD;
  // Cadenas de sonido
  SndBuf kks => dac;
  SndBuf sns => dac;
  BD.output => dac;
  rs.output => dac;
 //rimShot01.output => dac;
  SndBuf hhs => dac;
  SndBuf bit01 => dac;
  SndBuf bit02 => dac;
  SndBuf bit03 => dac;

   // Por defecto
  0.1 => float globalKksGain => kks.gain;
  0.1 => float globalHhsGain => hhs.gain;
  0.1 => float globalSnsGain => sns.gain;
  0.1 => bit01.gain;
  0.3 => bit02.gain;
  0.1 => bit03.gain;
  0.9 => BD.output.gain;
  0.8 => rs.output.gain;

// Hacemos un bombo, filtrando un Impuslo.
  Impulse kick => TwoPole kp => dac;
  5000.0 => kp.freq; 0.5 => kp.radius;
  0.3 => kp.gain => float globalKpGain;
  static float toneSustain;
  0.1 => static float toneRelease;
  SinOsc tone => ADSR toneKick => dac;
  toneKick.set(0.001,0.09,toneSustain,0.1);
  0.3 => tone.gain;
  51.9 => tone.freq;
  // ojo RezonZ

  // Hacemos un redoblante, filtrando un Noise.
  Noise n => ADSR snare => TwoPole sp => NRev snRev => dac;
  800.0 => sp.freq; 0.9 => sp.radius;
  0.05 => static float snSustain;
  //snare.set(0.001,snSustain,0.0,0.1);
  0.02 => sp.gain => static float globalSpGain;

  // Hacemos un charles, filtrando un Noise.
  Noise h => ADSR hihat => TwoPole hsp => NRev hhRev => dac;
  10000.0 => hsp.freq; 0.9 => hsp.radius;
  0.05 => float hhSustain;
  hihat.set(0.001,hhSustain,0.0,0.1);
  0.02 => hsp.gain => float globalHspGain;

    // Inicializo las probabilidades de variacion de tres arrays
    // en porcentaje

    100 => static int variationBDOnset;
    5 => static int variationBDOffset;
    100 => static int variationSnOnset;
    5 => static int variationSnOffset;
    100 => static int variationHHatOnset;
    5 => static int variationHHatOffset;

  // Esta funcion toca un array multidimensonal que trae
  // en este caso tres arrays uno de  kick, otro sn, y hh.
  fun void arrayDrums( int arrays[][]  )
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
            generator.percentChance(variationBDOffset,1) => transArray1[ii];
          }
          if( sourceArray1[ii] == 1 )
          {
            generator.percentChance(variationBDOnset,1) => transArray1[ii];
          }
             //<<< transArray1[ii] >>>; //DEBUG
        }

        for( 0 => int ii; ii < sourceArray2.cap(); ii++)
        {
            if( sourceArray2[ii] == 0 )
            {
                generator.percentChance(variationSnOffset,1) => transArray2[ii];
            }
            if( sourceArray2[ii] == 1 )
            {
                generator.percentChance(variationSnOnset,1) => transArray2[ii];
            }
        }
        for( 0 => int ii; ii < sourceArray3.cap(); ii++)
        {
            if( sourceArray3[ii] == 0 )
            {
                generator.percentChance(variationHHatOffset,1) => transArray3[ii];
            }
            if( sourceArray3[ii] == 1 )
            {
                generator.percentChance(variationHHatOnset,1) => transArray3[ii];
            }
        }

        // Aquí sueno los arrays: 1 suena, 0 silencio, y hay acentos
        // en los tiempos fuertes.
        while(true)
        {
            i % sourceArray1.cap() => int loop;
            // suenan los sonidos de drums de syntesis
             if( transArray1[loop] == 0 ) toneKick.keyOff();
             if( transArray1[loop] != 0 ){ toneKick.keyOn(); 1.0 => kick.next;}
             if( transArray2[loop] == 0 ) snare.keyOff();
             if( transArray2[loop] != 0 ) snare.keyOn();

           // if( transArray1[loop] != 0 ) BD.hit(1);
             if( transArray2[loop] != 0 ) rs.hit(1);
             if( transArray3[loop] == 0 ) hihat.keyOff();
             if( transArray3[loop] != 0 ) hihat.keyOn();

            // Acentos: si esta en tiempos fuertes
            // la ganancia es normal, si esta en tiempos débiles la
            // ganancia se reduce.
            [0,0,0,0,4,0,0,0,8,0,0,0,12,0,0,0,0] @=> int hardBeats[]; // DO => mejor solucion
            if( loop == hardBeats[loop] )
            {
                globalKksGain => BD.output.gain;
                globalSnsGain => rs.output.gain;
                globalHhsGain => hhs.gain;
                globalKpGain => kp.gain;
                globalSpGain => sp.gain;
                globalHspGain => hsp.gain;
            }
            if( loop != hardBeats[loop] )
            {
                globalKksGain/2.0 => BD.output.gain;
                globalSnsGain/1.5 => rs.output.gain;
                globalHhsGain/3.0 => hhs.gain;
                globalKpGain/2.0 => kp.gain;
                globalSpGain/4.0 => sp.gain;
                globalHspGain/3.0 => hsp.gain;
            }
            beat /2 => now; // quemado para seq de 16 pasos.
            i++;
        }
    }

    // Cambios del sonido
    fun void soundTransformation()
    {
        [0.01, 0.01, 0.01, 0.05, 0.01, 0.001, 0.05, 0.05, 0.09, 0.14] @=> float hhSeeds[];
        [0.001, 0.035, 0.005, 0.019, 0.01, 0.005, 0.055, 0.009, 0.02] @=> float snSeeds[];
        while(true)
        {
            hhSeeds[Math.random2(0,hhSeeds.cap()-1 )] => hhSustain;
            hihat.set(0.001,hhSustain,hhSustain,0.1);
            snSeeds[Math.random2(0,snSeeds.cap()-1 )] => snSustain;
            snare.set(0.001,snSustain,snSustain,0.1);
            beat*2 => now;
            //<<< snSustain>>>;
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
            seeds[Math.random2(0,seeds.cap()-1 )]/4 => snRev.mix;
           // <<< snRev.mix()>>>;
            beat*beatDivision => now;
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
