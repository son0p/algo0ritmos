public class Library
{
    36 => float root;
    0 => static int counter;
   // ================== ARRAYS ======================

  fun void print( float array[] )
  {
    for( 0=> int i; i < array.cap(); i++)
    {
      <<<array[i]>>>;
    }
  }
  fun void print( int array[] )
  {
    for( 0=> int i; i < array.cap(); i++)
    {
      <<<array[i]>>>;
    }
  }
  fun void print( string array[] )
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
    // Recibe un array de 100, retorna un array con el porcentaje descrito en
    // percent del valor a insertar
    fun static float[] insertChance( int percent, float actual[], float valueToInsert)
    {
        //float transitionArray[100];
        for( 0 => int i; i < 100; i++)
        {
            if( i < percent ) valueToInsert => actual[i];
            if( i >= percent ) actual[i] => actual[i];
        }
        return actual;
    }

   // // ===test  insertChance
   //    float testPercent[100];
   //    insertChance(99, testPercent, 5.0) @=> testPercent;

    // Inserta aleatoriedad a partir de una posición del array
    fun static float[] insertRandom( int position, float actual[], float lowerLimit, float upperLimit)
    {
        float transitionArray[100];
        for( position => int i; i < 100; i++)
        {
            if( i >= position ) Math.random2f(lowerLimit, upperLimit) => transitionArray[i];
            if( i < position ) actual[i] => transitionArray[i];
        }
        return transitionArray;
    }
    // // ===== TEST insertRandom()
    // float testB[100];
    // insertRandom(50, testB, 100.0, 3000.9) @=> float testC[];
    // print(testC);

    fun static int[] insertRandomInt( int position, int actual[], int lowerLimit, int upperLimit)
    {
        //int transitionArray[100];
        for( position => int i; i < actual.cap(); i++)
        {
            if( i >= position ) Math.random2(lowerLimit, upperLimit) => actual[i];
            if( i < position ) actual[i] => actual[i];
        }
        return actual;
    }

// ==================== FX-s
    NRev revNR;
    revNR.mix(0.02);
    fun void rev(UGen ob)
    {
        ob => revNR => dac;
    }

  // instrumentos =========================================
    // --bassDrum
  Impulse bdImpulse => ResonZ bdFilter => ADSR bd => HPF hpfBD => dac;
  1000 => bdImpulse.gain;
  bdFilter.set(50.0, 10.0);
  bd.set( 1::ms, 150::ms, .50, 100::ms );
  70.0 => hpfBD.freq;
  // --snareDrum
  Noise sdImpulse => ResonZ sdFilter => ADSR sd => Gain sdGain => dac;
  0.9 => sdGain.gain;
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
  SinOsc sin0 => ADSR sin0env =>  Pan2 sin0Pan => revNR => dac;
  -0.5 => sin0Pan.pan;
  sin0env.set( 0::ms, 500::ms, .0, 100::ms );
  0.1 => sin0.gain;
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
    // Tri
    TriOsc tri0 => ADSR tri0env => NRev tri0rev => Pan2 tri0Pan => dac;
    -0.0 => tri0Pan.pan;
    tri0env.set( 0::ms, 500::ms, .0, 100::ms );
    // --Melody
    BlitSaw melodyImpulse => ADSR melody => NRev mReverb => dac;
    0.09 => melodyImpulse.gain;
    melody.set( 0::ms, 80::ms, 0.00, 500::ms );
    0.07 => mReverb.mix;

    // --bass
    Fat fat  => ADSR bass => LPF filterBass => NRev fatRev => dac;
    0.3 => fat.gain;  2800 => filterBass.freq;
    bass.set( 0::ms, 80::ms, fat.gain()/1.5, 100::ms );
    0.03 => fatRev.mix;


    PulseOsc pulse => ADSR pulseADSR => NRev pulseRev => dac;
    0.02 => pulse.gain;
    pulseADSR.set( 0::ms, 80::ms, 0.00, 100::ms );
    0.02 => pulseRev.mix;

    PulseOsc pulse2 => ADSR pulseADSR2 => NRev pulseRev2 => Gain pulse2gain => dac;
    0.03 => pulse2gain.gain;
    pulseADSR2.set( 0::ms, 80::ms, pulse2.gain()/2.5, 200::ms );
    0.19 => pulseRev2.mix;
    Math.random2f(0.1, 0.99)=> pulse2.width;

    PulseOsc pulse3 => ADSR pulseADSR3 => NRev pulseRev3 => dac;
    0.03 => pulse3.gain;
    pulseADSR3.set( 0::ms, 80::ms, pulse3.gain()/2.5, 200::ms );
    0.19 => pulseRev3.mix;
    Math.random2f(0.1, 0.99)=> pulse3.width;

    SqrOsc uplift => ADSR upliftADSR => NRev upliftRev => dac;
    Phasor lfo => blackhole;
    // set period (an alternative to .freq)
    8::second => lfo.period;
    0 => lfo.sync;
    0.1 => upliftRev.mix;


    kjzTT101 t1;
    t1.output => dac;
    0.01=> t1.setDriveGain;

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
  fun void fillArray( int toFill[], int positions[], int values[] )
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
  // evalua la presencia de <target> en un array <seed[]> FIX: ¿que valor regresa si no lo encuentra (por ahora -1.0)?
  fun float evalFor(float seed[], float target)
  {
    for(0 => int i; i < seed.cap(); i++)
    {
      if( target == seed[i]){ return target;}
    }
    return -1.0;
  }
  fun float[] semitonesGen(float freqFrom, float freqTo)
  {
    Math.floor(Math.log(freqTo/freqFrom)/Math.log(1.05946309436)) $ int => int posibleSemitones;
    float semitones[posibleSemitones]; // TODO: log(f1/f2)/log(sqr(2;12))  so Math.log(880/440)/Math.log(1 <<<.05946309436) = 12.0
    for( 0 => int i;  i < posibleSemitones; i++)
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
    float scale[notes.cap()-1];
    // iterate below maximum posible scaleJumps shift
    for(0 => int i; i < notes.cap()-scaleJumps[scaleJumps.cap()-1]; i++ )
    {
      scaleJumps.cap() => int cicle; // try module i positions by scaleJumps Size
      notes[i + scaleJumps[i % cicle]] => scale[i];
    }
    return scale;
  }

//////////// DYNAMICS ///////////////////////////
    //// CLASSIC: force decrease form beat possition: 1 > 3 > 4 > 2
   fun void dynClassic(Gain inst, float maxGain){
       while(true){
           maxGain => inst.gain;
           // grab the actual level
           // counter modulo:  if 1->100%, if 3->75%, if 4->50%, if 2->25%
           if(Global.mod16 % 4 == 3){ inst.gain() * 0.75 => inst.gain; }
           if(Global.mod16 % 4 == 4){ inst.gain() * 0.50 => inst.gain; }
           if(Global.mod16 % 4 == 2){ inst.gain() * 0.25 => inst.gain; }
           Global.beat => now;
       }
   }
//////////// END DYNAMICS ////////////////

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
  fun void mutate(int base[], int sequence[][], int goal[] )
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
  fun void run(dur time)
  {
    time => now;
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
