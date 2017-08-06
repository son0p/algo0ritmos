public class Library
{
  36 => float root;
  // ================== ARRAYS ======================

  fun void printArray( float array[] )
  {
    for( 0=> int i; i < array.cap(); i++)
    {
      <<<array[i]>>>;
    }
  }
  fun void printArray( int array[] )
  {
    for( 0=> int i; i < array.cap(); i++)
    {
      <<<array[i]>>>;
    }
  }
  fun void printArray( string array[] )
  {
    for( 0=> int i; i < array.cap(); i++)
    {
      <<<array[i]>>>;
    }
  }

  // función generar probabilidades según corpus
  fun static float floatChance( int percent, float value1, float value2)
  {
    float percentArray[100];
    for( 0 => int i; i < 100; i++)
      {
        if( i < percent ) value1 => percentArray[i];
        if( i >= percent ) value2 => percentArray[i];
      }
    percentArray[Math.random2(0, percentArray.cap()-1)] => float selected;
    return selected;
  }
  //
  // instrumentos =========================================
    // --bassDrum
  Impulse bdImpulse => ResonZ bdFilter => ADSR bd => dac;
  1000 => bdImpulse.gain;
  bdFilter.set(50.0, 10.0);
  bd.set( 1::ms, 150::ms, .50, 100::ms );
  // --snareDrum
  Noise sdImpulse => ResonZ sdFilter => ADSR sd => dac;
  0.9 => sdImpulse.gain;
  sdFilter.set(400.0, 1.0);
  sd.set( 0::ms, 50::ms, .0, 100::ms );
  // --hiHat
  Noise hhImpulse => ResonZ hhFilter => ADSR hh => dac;
  0.5 => hhImpulse.gain;
  hhFilter.set(10000.0, 5.0);
  hh.set( 0::ms, 50::ms, .0, 100::ms );
  // === Melodic
  // Sin
  SinOsc sin0 => ADSR sin0env => Pan2 sin0Pan => dac;
  -0.7 => sin0Pan.pan;
  sin0env.set( 0::ms, 500::ms, .0, 100::ms );
  // Sqr
  SqrOsc sqr0 => ADSR sqr0env => dac;
  0.15 => sqr0.gain;
  sqr0env.set( 0::ms, 300::ms, .0, 100::ms );
  SqrOsc sqr1 => ADSR sqr1env => LPF sqr1filter => dac;
  sqr1env.set( 0::ms, 500::ms, .0, 500::ms );
  // Blit
  BlitSaw blit0 => ADSR blit0env => NRev blit0rev => Pan2 blit0pan => dac;
  0.7 => blit0pan.pan;
  blit0env.set( 0::ms, 200::ms, .0, 100::ms );
  

  // modelado

  ResonZ modes[10];

  [[ root , 0.70212 ],              // these are the modes from the
   [ root + root/2 , 0.971846 ],    // plate we whacked in the
   [ root + root/8 , 0.849900 ],    // online video
   [ 2010.662842 , 0.378065 ],
   [ 2670.117188 , 1.000000 ],  // replace them with your own from
   [ 3071.173096 , 0.104546 ],  //    your analysis of your object/sound
   [ 3563.745117 , 0.098136 ],
   [ 4465.447998 , 0.043037 ],  // NOTE:  number of entries here should
   [ 4556.964111 , 0.007220 ],  //    equal NUM_MODES
   [ 5499.041748 , 0.004922 ]]  // which you can change if you like!
    @=> float freqsNamps[][];

  Noise n => ADSR strike;
  (ms, 50::ms, 0.01, 100::ms) => strike.set;
  30.0 => strike.gain;

  for (int i; i < 10; i++){
    strike => modes[i] => dac;
    freqsNamps[i][0] => modes[i].freq;
    500 - (i*30) => modes[i].Q;
    freqsNamps[i][1] => modes[i].gain;
  }

  // test
  // fun void bass()
  // {
  //   while(true)
  //     {
  //       1 => strike.keyOn;
  //       beat/2 => now;
  //       strike.keyOff;
  //       beat/2 => now;
  //     }
  // }


  // ============= Funciones
  //// ======= Arrays
  fun int fillArray( int toFill[], int positions[], int values[] )
  {
    for ( int i; i < positions.cap(); i++ )
      {
        values[i] => toFill[positions[i]];
      }
  }
  // verifica la presencia en el array
  fun int checkArray( int seq[], int iter )
  {
    int value;
    for(int i; i < seq.cap();i++)
    {
      if( seq[i] == iter )
      {
        1 =>  value;
      }
    }
    return value;
  }
  // aproximar según cercanía
  fun float magneticGrid(float ref[], float src)
  {
    0 => int index;
    Std.fabs( src - ref[0] ) => float difference;
    for( 0 => int i; i < ref.cap(); i++)
    {
      if( difference > Std.fabs( src - ref[i]))
      {
        Std.fabs( src - ref[i]) => difference;
        i => index;
      }
    }
    return ref[index];
  }
  // evalua la presencia de <target> en un array <seed[]>
  fun float evalFor(float seed[], float target)
  {
    for(0 => int i; i < seed.cap(); i++)
    {
      if( target == seed[i]){ return target;}
    }
  }
  fun float[] semitonesGen(float freqFrom, float freqTo)
  {
    float semitones[300]; // TODO: log(f1/f2)/log(sqr(2;12))
    for( 0 => int i;  i < 299; i++)
    {
      if (freqFrom < freqTo)
      {
        freqFrom * 1.05946309436 => semitones[i] => freqFrom;
      }
    }
    return semitones;
  }
  fun float[] scaleGenerator(float notes[], int scaleJumps[])
  {
    float scale[400]; //TODO: fix
    for(0 => int i; i < notes.cap()-1; i++ )
    {
      for (0 => int j; j < scaleJumps.cap()-1; j++)
      {
        notes[i]+scaleJumps[j] => scale[i];
      }
    }
    return scale;
  }

  // how many semintores between two freqs
// fun float semitonesFinder(float freqFrom, float freqTo)
//   {
//     log(freqFrom/freqTo)/log(1.05946309436)float howManySemiTones;
//   }

  // ---- Players
  //.............. playDrums

  fun void playDrums( ADSR instrument )
  {
    instrument.keyOff();
    instrument.keyOn();
  }
  fun void playDrums( ADSR instrument, Impulse imp )
  {
    instrument.keyOff();
    instrument.keyOn(); 1.0 => imp.next;
  }

  fun void playDrums( int active,  ADSR instrument )
  {
    instrument.keyOff();
    if( active == 1 ){ instrument.keyOn();  }
  }

  // bees=================
  //Math.srandom(33679);   ////////  INTERESTING to control randomnes
  fun int bees(int C)
  {
    SawOsc s[C]; // Oscillators and Pans for each bee
    Pan2 p[C];
    Envelope e[C];
    NRev r[C];
    Gain gBees;
    for ( 0 => int ii ; ii < C ; ++ii ) {
      s[ii] => e[ii] => r[ii] => p[ii]  =>  gBees => dac;
      r[ii].mix(0.1);
      s[ii].gain(0.05/C);
      root/1 + Math.random2f(-2, 2) => s[ii].freq;
      Math.random2f(-1, 1) => p[ii].pan;
    }
    return C;
  }
  // cambiar rango de i
  fun float changeRange (int OldValue, int OldMin, int OldMax, float NewMin, float NewMax)
  {
    (OldMax - OldMin) => int OldRange;
    (NewMax - NewMin) => float NewRange;
    (((OldValue - OldMin) * NewRange) / OldRange) + NewMin => float NewValue;
    return NewValue;
  }
  // ==== bass pulse arpegiator
  // PulseOsc pulse => ADSR ePulse => NRev rPulse=> dac;
  // rPulse.mix(0.0);
  // pulse.gain(0.2);
  // pulse.width(0.1);
  // fun void bassPulse(float freq, dur duration, float width)
  // {
  //   (ms, duration, 0.01, 100::ms) => ePulse.set;
  //   pulse.freq(freq);
  //   width => pulse.width;
  //   ePulse.keyOn();
  //   duration => now;l
  //   ePulse.keyOff();
  // }

  // fun void bassLine(int metro, int loopSize)
  // {
  //   120::ms => dur beat;
  //   while(true)
  //     {
  //       changeRange(metro, 0, loopSize, 0.1, 1.0) => float newWidth;
  //       floatChance(90 - metro*4/loopSize, 0, root/Math.random2(2,4)) => float tone;
  //       floatChance(70 - metro*2, 4, 16) $ int => int division;
  //       floatChance(70 - metro  , newWidth, 0.05) => float width;
  //       spork ~ bassPulse( root + tone , beat/division, width );
  //       beat/4 => now;
  //     }
  // }

  // funcion para mutar los arreglos aleatorios
  // TODO: la base de la mutación debe adaptarse a un nuevo arreglo que
  //       ya contiene las notas encontradas
  2 => int C;
  fun int mutate(int base[], int sequence[][], int goal[] )
  {
    Math.random2(0, C-1) => int seqToMutate;
    Math.random2(0, base.cap()-1) => int noteToMutate;
    // se evalua si la nota existente es igual a la melodía de referencia,
    if(sequence[seqToMutate][noteToMutate] == goal[noteToMutate])
      {
        <<< ": ** encontró coincidencia**  ",  goal[noteToMutate], "\n" >>>;
      }
    else
      {
        base[Math.random2(0, base.cap()-1)] => sequence[seqToMutate][noteToMutate];
        <<< "muta melodía ",seqToMutate,"\n">>>;
      }
  }
 

  // establece la relación entre dos ADSR en sporks depredador/presa
  // con una estructura de control excluyente y un valor de
  // permanencia de ese estado
  fun void predation(ADSR predator, ADSR prey, dur permanence)
  {
    while(true)
    {
      if( predator.state() != 2)
      {
          prey.keyOff();
      }
      permanence => now;
    }
  }

  // ====================== TIME -=======================
  fun dur run(dur time)
  {
    time => now;
  }

  // ==================== FX-s
  NRev revNR;
  fun void rev(UGen ob)
  {
    ob => revNR => dac;
  }
    // ================ Generators
    // ------- Rythm Generators
    // .... Euclidean
    fun int[] euclideangenerator ( int pulses, int steps ) {
        // @jazzmonster Euclidean rhythm generator based Bresenham's algorithm
        // pulses - amount of pulses
        // steps - amount of discrete timing intervals
        int seq[steps];
        int error;
        for ( int i; i < steps; i++ ) {
            error + pulses => error;
            if ( error > 0 ) {
                true => seq[i];
                error - steps => error;
            } else {
                false => seq[i];
            }
        }
        return seq; 
    }
}
