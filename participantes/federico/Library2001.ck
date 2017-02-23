public class Library
{
  // función generar probabilidades según corpus
  fun float floatChance( int percent, float value1, float value2)
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
  sd.set( 0::ms, 50::ms, .1, 100::ms );
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
}
