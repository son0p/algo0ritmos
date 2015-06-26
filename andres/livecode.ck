Synth fm;
SinOsc carrier;
TriOsc modulator;
fm.connectionfm(carrier, modulator);
[70,0,70,0,69,0,69,0,70,0,0,67,0,67,0,0]@=> int bassexample[];
//[1,0,0,0,1,0,0,0]@ int basicdrum;
while (true)
{
fm.lectormidi(bassexample, 125.0, carrier, modulator);
}
