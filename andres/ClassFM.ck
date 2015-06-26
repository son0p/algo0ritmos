public class Synth
{
    0 => float freqcarrier;
    0 => float gaincarrier;




   public void lectormidi(int array[], float tiempo, Osc carrier, Osc modulator)
        {
            Tempo tempo;
            Synth fm;
            //while (true)
              //  {
                    for(0 => int i; i < array.cap(); i++)
                    {
                    //<<<bassexample[i]>>>;

                    if (array[i]==0)
                        {
                        fm.volumen(0);
                        tempo.functionbpm(tiempo, array.cap());
                        //<<<"text">>>;
                        }

                    if (array[i]>0)
                        {
                        fm.volumen(0.5);
                        fm.frecuencia (Std.mtof(array[i]));
                        fm.fm (carrier ,modulator);
                        tempo.functionbpm(tiempo, array.cap());
                        }

                    }
                //}
        }

    public void frecuencia (float freq)
        {
            freq => freqcarrier;

        }

    public float volumen (float vol)
        {
            vol => gaincarrier;
        }

    public void connectionfm (Osc carrier, Osc modulator)
        {
            modulator => carrier => dac;
        }

    public void fm(Osc carrier, Osc modulator)
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
