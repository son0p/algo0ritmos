// test
Fm fm;
SinOsc modulator;
SinOsc carrier;
0.001 => fm.masterGain;

0.5 => float ratio;
[0.5, 1.0, 2.0, 4.0, 1.33333, 0.33333, 0.2857] @=> float ratioArr[];
for(0 =>int ii; ii < ratioArr.cap(); ii++)
{
  //ratio[ii] => ratio;
  ratioArr[ii] =>  ratio;
  for(500 => int i; i < 501; i++)
  {
      fm.changeModulatorFreq(i);
      500::ms => now;
      <<< i >>>;
      fm.fmSynth(modulator,carrier, ratioArr[ii]);
      <<< ii >>>;
  }
}
// fm.changeModulatorFreq(800);


1::day => now;
