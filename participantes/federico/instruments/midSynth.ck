public class Moogi
{
    Moog moog => Gain output;

    fun void note(float freq)
    {
        freq => moog.freq;
        .8 => moog.noteOn;
    }
    fun void gain(float gain)
    {
        gain => moog.gain;
    }
    fun void filterQ(float filterQ)
    {
        filterQ => moog.filterQ;
    }
    fun void filterSweepRate(float filterSweepRate)
    {
        filterSweepRate => moog.filterQ;
    }
}


Moogi A;
A.output => dac;

 //for(int i; i < 8; i++)
 //{  A.note(200); .8::second => now; }
