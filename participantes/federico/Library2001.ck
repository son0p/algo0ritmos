public class Library
{
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
  // --bass
  SqrOsc saw => ADSR bass => dac;
  0.15 => saw.gain;
  bass.set( 0::ms, 80::ms, saw.gain()/1.5, 100::ms );
  // --Melody
  BlitSaw sin1 => ADSR melody1 => NRev melodyReverb => dac;
  0.35 => sin1.gain;
  melody1.set( 0::ms, 80::ms, saw.gain()/1.5, 100::ms );
  0.03 => melodyReverb.mix;

  // ============= Funciones
  //// ======= Arrays
  fun int fillArray( int toFill[], int positions[], int values[] )
  {
    for ( int i; i < positions.cap(); i++ )
      {
        values[i] => toFill[positions[i]];
      }
  }
  // ---- Players
  //.............. playDrums

  fun void playDrums( ADSR instrument, Impulse imp)
  {
    instrument.keyOff();
    instrument.keyOn(); 1.0 => imp.next;  
  }

  fun void playDrums( int active,  ADSR instrument)
  {
    instrument.keyOff();
    if( active == 1 ){ instrument.keyOn();  }
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

  // bees
  //Math.srandom(33679);   ////////  INTERESTING to control randomnes
  6 => int C; //number of bees
  SawOsc s[C]; // Oscillators and Pans for each bee
  Pan2 p[C];
  Envelope e[C];
  NRev r[C];
  Gain gBees;
  36 => int root;
  120::ms => dur beat;
  fun void bees(){
    for ( 0 => int ii ; ii < C ; ++ii ) {
      s[ii] => e[ii] => r[ii] => p[ii]  =>  gBees => dac;
      r[ii].mix(0.1);
      s[ii].gain(0.05/C);
      root/1 + Math.random2f(-2, 2) => s[ii].freq;
      Math.random2f(-1, 1) => p[ii].pan;
    }
    while(true){
      for ( 0 => int ii ; ii < C ; ++ii ) { e[ii].keyOn(); }
      beat*2 => now;
      for ( 0 => int ii ; ii < C ; ++ii ) { e[ii].keyOff(); }
      beat*2 => now;
    }
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
  PulseOsc pulse => ADSR ePulse => NRev rPulse=> dac;
  rPulse.mix(0.0);
  pulse.gain(0.2);
  pulse.width(0.1);
  fun void bassPulse(float freq, dur duration, float width)
  {
    (ms, duration, 0.01, 100::ms) => ePulse.set;
    pulse.freq(freq);
    width => pulse.width;
    ePulse.keyOn();
    duration => now;
    ePulse.keyOff();
  }


  fun void bassLine(int metro, int loopSize)
  {
    while(true)
      {
        changeRange(metro, 0, loopSize, 0.1, 1.0) => float newWidth;
        floatChance(90 - metro*4/loopSize, 0, root/Math.random2(2,4)) => float tone;
        floatChance(70 - metro*2, 4, 16) $ int => int division;
        floatChance(70 - metro  , newWidth, 0.05) => float width;
        spork ~ bassPulse( root + tone , beat/division, width );
        beat/4 => now;
      }
  }
}





