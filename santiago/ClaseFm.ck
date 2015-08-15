// Publicacion de la variable
public class Fm
{
    //Llamar la variable Volumen.
    volumen Volumen;
    // La Moduladora del Gain comenzara en 10000.
    float ratioFreq;
    float freqCarrier;
    100 => float ModularGain; 
    
    //Dos ondas que hacen la sintesis basica FM
    ADSR adsr;
    NRev rever;
    SinOsc carrier;
    SqrOsc moduladora;
    Delay dely;
    //Variable Publica que retorna un entero
    //Que mueve la Modular Frencuencia
    public float MoFreq(float usoRatio)
        {
            if (true)
            {
                8/usoRatio => ratioFreq;
                return ratioFreq;
            }
        }

     //Variable Publica que retorna un entero
    //Que mueve la Modular Ganancia
    public float MoGain(float ModuGain)
        {
            if (true)
            {
                ModuGain => ModularGain;
                <<<"Modulador",ModularGain>>>;
                return ModularGain;
            }
        }
    
    // Ondas Osc PAra una sintesis Basica de FM
    public void fmsin(Osc carrier, Osc modulador)
        {
            // Sincronizacion de la FM
            2 => carrier.sync;
            modulador => carrier => rever => adsr => dely => dely => Gain VolumenGen => dac;
            adsr.set(20::ms,250::ms,0.5,20::ms);
            500 :: ms => dely.delay => dely.max;
            0.8 => dely.gain;
            0.1 => rever.mix;
            while(true)
            {
                ModularGain => modulador.gain;
                <<<"Modulador",ModularGain>>>;
                Volumen.VOLGENERAL => VolumenGen.gain;
                //<<<"VolumenGen",VolumenGen.gain()>>>;
                0.001::second =>now;
            }
        
        }

    // Las ondas en funcionamiento
    spork~fmsin(carrier,moduladora);
        
        
    // Lector de notas midi
    fun void NumMel(int b[])
    {
        while (true)
        {
            for(0 => int i; i < b.cap(); i++)
            {
                if (b[i] == 0)
                {
                    // Silencio de la moduladora cuando sea 0
                    0 => carrier.gain;
                    0 => moduladora.gain;
                    0.125::second => now;
                }
                    
                if (b[i] == 1)
                {
                    [0,67,0,0,67,0,0,67,0,63,0,0,63,0,0,0,60,0,0,60,0,0,60,0,0,63,0,0,63,0,0,0] @=> int melodia[];
                  
                    for(0 => int c ; c < melodia.cap();c++)
                    {
                        if (melodia[c] == 00)
                        {
                            adsr.keyOff();
                            0.125 :: second => now;
                            
                        }
                        else
                        {
                            1 => carrier.gain;
                            1 => moduladora.gain;
                            Std.mtof(melodia[c]) => carrier.freq;
                            carrier.freq()*ratioFreq => moduladora.freq;
                            adsr.keyOn();
                            0.125 :: second => now;
                            adsr.keyOff();
                            
                        }
                    }
                }
            }
        }
    }
}
    