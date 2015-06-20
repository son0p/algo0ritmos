Synth fm;

SinOsc carrier;
SawOsc modulator;

[70,0,70,0,69,0,69,0,70,0,0,67,0,67,0,0]@=> int bassexample[];
//[1,0,0,0,1,0,0,0]@ int basicdrum;

while(true)
{
for(0=> int i; i < bassexample.cap(); i++)
    {
        <<<bassexample[i]>>>;

        if (bassexample[i]==0)
        {
            0 => carrier.gain;
            0.128 :: second => now;
            <<<"text">>>;

        }
        if (bassexample[i]>0)
        {
            0.5 => fm.volumen;
            fm.frecuencia (Std.mtof(bassexample[i]-24));
            fm.fm (carrier ,modulator);
            0.128 :: second => now;

        }
    }
}
