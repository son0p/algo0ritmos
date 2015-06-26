public class Synth
{
    0 => float freqcarrier;
    0 => float gaincarrier;

    public float volumen (float vol)
    {
        vol => gaincarrier;
        return vol;

    }

    public void frecuencia (float freq)
    {
        freq => freqcarrier;

    }
    public void fmconnection (Osc carrier, Osc modulator)
    {
        modulator => carrier => dac;
    }
    public void fm(Osc carrier, Osc modulator, float volumen)
    {

        2 => carrier.sync;
        freqcarrier => carrier.freq;
        gaincarrier => carrier.gain;
        freqcarrier*2 => modulator.freq;
        1000 => modulator.gain;
    }
    public void fm(Osc carrier, Osc carrMod, Osc modulator, int suiche)
    {
         2 => carrier.sync;
        if (suiche == 1)
            {

            20 => modulator.freq;
            1000 => modulator.gain;
            modulator => carrMod => carrier => dac;
            }
        if (suiche == 2)
            {

            20 => modulator.freq;
            1000 => modulator.gain;
            modulator => carrier => dac;
            carrMod => carrier => dac;
            }
    }
}
