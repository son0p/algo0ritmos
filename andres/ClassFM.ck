public class Synth
{
    1 => float gaincarrier;
    1000 => float gainmodulator;
    1 => float ratioVariable;
    
        Tempo tempo;
        Volume gain;
    
public void lectormidi(int array[], float tempo1, Osc carrier, Osc modulator)
    {
    array.cap()$float => float arrayCapacity;
    //<arrayCapacity>>>;
        1000 => modulator.gain;
            carrier => ADSR envolvente; // hacer test
            while(true)
                {
                    for(0 => int i; i < array.cap(); i++)
                    {
                                //<<<array[i]>>>;

                                if (array[i]==0)
                                {
                                    //volumeSynth(0);
                                    0 => carrier.gain;   
                                    tempo.functionBpm(tempo1, arrayCapacity,16)=> now; 
                                    //<<<"0">>>;
                                }
                                    
                                if (array[i]>0)
                                {
                                    //volumeSynth(0.5); 
                                    0.5 => carrier.gain;
                                    Std.mtof(array[i])=> carrier.freq;
                                    carrier.freq()*ratioVariable => modulator.freq;
                                    tempo.functionBpm(tempo1, arrayCapacity,16)=>now;
                                    //<<<"1", array[i]>>>;
                                }
                        
                    }
                }  
            
        }
    
    public void ratio (float numerador, float denominador)
    {
            numerador/denominador => ratioVariable; 
            
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
            2 => carrier.sync;
            gaincarrier => carrier.gain;
            gainmodulator => modulator.gain;
        while (true)
            {
                gain.VOLUMENGENERAL => volumeGen.gain; 
                gain.specificvolume => gainSynth.gain;
                0.01::second => now;
            }
                                                    
    }
//_______________________________________________________
        
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
  //------------------test lectormidi--------------
    Synth fm;
    SinOsc carrier;
    TriOsc modulator;
    fm.ratio(5,2);
    [52,55,59,55,0,52,55,52,52,55,59,55,0,52,55,52] @=>int bassline1[];
    spork~fm.connectionfm(carrier, modulator);
    spork~fm.lectormidi(bassline1, 124.0, carrier, modulator);
    1::day => now;
    
  //   