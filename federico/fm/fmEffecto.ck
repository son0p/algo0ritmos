public class Synth
{
    0=> float freqmodulator ;
    public void frecuencia (float freq)
    {
        freq => freqmodulator;
    }

    public void fm(Osc carrier, Osc modulator)
    {
        2 => carrier.sync;
        freqmodulator => modulator.freq;
        1000 => modulator.gain;
        modulator => carrier => dac;
    }
    public void fm(Osc carrier, Osc carrMod, Osc modulator, int suiche)
    {
         2 => carrier.sync;
        if (suiche == 1)
            {

            freqmodulator => modulator.freq;
            1000 => modulator.gain;
            modulator => carrMod => carrier => dac;
            }
        if (suiche == 2)
            {

            freqmodulator => modulator.freq;
            1000 => modulator.gain;
            modulator => carrier => dac;
            carrMod => carrier => dac;
            }
    }
}

// test

Synth fm;

SinOsc carrier;
SawOsc modulator;
[70,0,70,0,69,0,69,0,70,0,0,0,67,0,67,0]@=> int bassexample[];
//[1,0,0,0,1,0,0,0]@ int basicdrum;

for(0=> int i; i < bassexample.cap(); i++)
    {
    fm.frecuencia (Std.mtof(bassexample[i]-48));
    fm.fm (carrier,modulator);
    1 :: second => now;
    }
