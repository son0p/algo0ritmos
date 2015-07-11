public class Synth
{
    0 => float freqcarrier;
    0 => float freqmodulator;
    0 => float gaincarrier;
    1000 => float gainmodulator;
    0 => float ratio;
    
        Tempo tempo;
        Volume gain;
    
   public void lectormidi(int array[], float tiempo, Osc carrier, Osc modulator)
        {
            Tempo tempo;

            //while (true)
              //  {
                    for(0 => int i; i < array.cap(); i++)
                    {
                        //<<<bassexample[i]>>>;

                        if (array[i]==0)
                            {
                            volumeSynth(0);
                            tempo.functionbpm(tiempo, array.cap());    
                            //<<<"text">>>;
                            }
                            
                        if (array[i]>0)
                            {
                            volumeSynth(0.5);
                            frecuencias (Std.mtof(array[i]));
                            fm(carrier ,modulator);
                            tempo.functionbpm(tiempo, array.cap());
                            }
                
                    }
                //}
        }
        
    public void frecuencias (float freqc, float freqm)
    {
            freqc => freqcarrier;
            freqm => freqmodulator;
            freqcarrier/freqmodulator => ratio;
    }
        
//_______________________________________________________
    public float volumeSynth (float gainc)
    {
            gainc => gaincarrier;      
    }
    public float volumeSynth (float gainc, float gainm)
    {
            gainc => gaincarrier;
            gainm => gainmodulator;            
    }
//_______________________________________________________        
        
    public void connectionfm (Osc carrier, Osc modulator)
    {
            modulator => carrier => Gain gainSynth => Gain volumeGen=> dac; 
            while (true)
            {
                gain.VOLUMENGENERAL => volumeGen.gain; 
                gain.specificvolume => gainSynth.gain;
                0.01::second => now;
            }
                                                    
    }
//_______________________________________________________        
    public void fm(Osc carrier, Osc modulator)
        {
            2 => carrier.sync;
            freqcarrier => carrier.freq;
            gaincarrier => carrier.gain;
            freqcarrier*ratio => modulator.freq;
            gainmodulator => modulator.gain;
        }
        
    public void fm(Osc carrier, Osc carrMod, Osc modulator, int Switch)
        {
            2 => carrier.sync;
                if (Switch == 1)
                    {

                    20 => modulator.freq;
                    1000 => modulator.gain;
                    modulator => carrMod => carrier => dac;
                    }
                if (Switch == 2)
                    {

                    20 => modulator.freq;
                    1000 => modulator.gain;
                    modulator => carrier => dac;
                    carrMod => carrier => dac;
                    }
        }
      
}