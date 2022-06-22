public class Stif
{
// STK StifKarp

// patch
    StifKarp m =>  Gain output;

        Math.random2f( 0, 1 ) => m.pickupPosition;
        Math.random2f( 0, 1 ) => m.sustain;
        Math.random2f( 0, 1 ) => m.stretch;

        <<< "---", "" >>>;
        <<< "pickup:", m.pickupPosition() >>>;
        <<< "sustain:", m.sustain() >>>;
        <<< "stretch:", m.stretch() >>>;

        // factor
        Math.random2f( 1, 4 ) => float factor;

    fun void note(float freq)
    {
        freq => m.freq;
    }
    fun void gain(float gain)
    {
        gain => m.gain;
    }
     fun void velocity(float velocity)
    {
        velocity => m.pluck;
    }

}

Stif A;
A.output => dac;
0.01 =>A.gain;
// for(int i; i < 8; i++)
//  {  A.note(500); A.velocity(100); .8::second => now; <<<"play">>>; }
