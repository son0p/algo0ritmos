250::ms => dur beat;
fun Osc osc( string name)
{
    SinOsc name;
    return  name;
}

osc("test");

fun Noise instanciarNoise(float gain)
{
    Noise noise;
    noise.gain(gain);
    return noise;
}

fun HPF filtrosNoise(float freq)
{
    HPF filter;
    filter.freq(freq);
    return filter;
}

class envelope
{
  fun Envelope envelopeNoise()
  {
    Envelope envelope;
    return envelope;
  }
}
Gain gain => dac;
envelope e;

for( 0 => int i; i < 10; i++)
{
    HPF filter;
    filter.freq(Math.random2f(100, 10000));
    Math.random2(2,4) => int div;
   spork~ playa( filter, div );
}
fun void playa(HPF f, int div)
  {
    Envelope e;
    Noise n;
    n.gain(0.002);
    n => e => gain;
    <<< "test", f.freq() >>>;
    while( true )
      {
        e.keyOn();
        beat/div => now;
        e.keyOff();
        beat/div => now;
      }
   }
while( true )20::ms => now;
