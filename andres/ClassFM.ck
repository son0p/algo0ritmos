 public class Synth
{
    1 => float gaincarrier; 
    1000 => float gainmodulator;
    1 => float ratioVariable;
    ADSR envolvente;
        Tempo tempo;
        Volume gain;
    
public void lectormidi(int array[], float bpm, Osc carrier, Osc modulator, float amSynth, float div)
    {
    array.cap()$float => float arrayCapacity;
    //<arrayCapacity>>>;
        amSynth => modulator.gain;
             
            while(true)
                {
                    for(0 => int i; i < array.cap(); i++)
                    {
                                //<<<array[i]>>>;

                                if (array[i]==0)
                                {
                                    //volumeSynth(0);
                                    0 => carrier.gain;
                                    envolvente.keyOff();    
                                    (tempo.beatUnity(bpm)/div)::second => now; 
                                    //<<<"0">>>;
                                }
                                    
                                if (array[i]>0)
                                {
                                    //volumeSynth(0.5); 
                                    0.5 => carrier.gain;
                                    Std.mtof(array[i])=> carrier.freq;
                                    carrier.freq()*ratioVariable => modulator.freq;
                                    envolvente.keyOn();
                                    <<<"sonido">>>;
                                    (tempo.beatUnity(bpm)/div)::second => now; 
                                    envolvente.keyOff();
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
            modulator => carrier => envolvente => Gain gainSynth => Gain volumeGen=> dac;
            envolvente.set( 20::ms, 8::ms, .5, 100::ms );
            2 => carrier.sync;
            gaincarrier => carrier.gain;
            gainmodulator => modulator.gain;
        while (true)
            {
                gain.VOLUMENGENERAL => volumeGen.gain; 
                gain.SPECIFICVOLUME => gainSynth.gain;
                0.01::second => now;
            }
                                                    
    }
//_______________________________________________________
    /*    
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
      */
}
  //------------------test lectormidi--------------
/*
    Synth fm;
    SinOsc carrier;
    SawOsc modulator;
    fm.ratio(1,2);
    [52,55,59,55,0,52,55,52,52,55,59,55,0,52,55,52,52,55,59,55,0,52,55,52,52,55,59,55,0,52,55,52] @=>int bassline1[];
    spork~fm.connectionfm(carrier, modulator);
    spork~fm.lectormidi(bassline1, 120.0, carrier, modulator ,1500.0 ,4.0);
    1::day => now;
*/    
  //-----------------------------------------------   