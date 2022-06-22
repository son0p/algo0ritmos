public class Sit
{
    Sitar m => Gain output;

    fun void note(float freq)
    {
        freq => m.freq;
        <<<freq , "">>>;
    }
    fun void gain(float gain)
    {
        gain => m.gain;
    }
     fun void velocity(float velocity)
    {
        velocity => m.noteOn;
        <<< "pluck", "">>>;
    }
}

Sit A;
A.output => dac;
0.5 =>A.gain;
