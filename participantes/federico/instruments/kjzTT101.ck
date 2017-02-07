// simple analog-sounding tom-tom with pitch and amp decay and sine overdrive
class kjzTT101
{
   Impulse i; // the attack
   i => Gain g1 => Gain g1_fb => g1 => LPF g1_f => Gain TomFallFreq; // tom decay pitch envelope
   i => Gain g2 => Gain g2_fb => g2 => LPF g2_f; // tom amp envelope

   // drum sound oscillator to amp envelope to overdrive to LPF to output
   TomFallFreq => SinOsc s => Gain ampenv => SinOsc s_ws => LPF s_f => Gain output;
   Step BaseFreq => s; // base Tom pitch

   g2_f => ampenv; // amp envelope of the drum sound
   3 => ampenv.op; // set ampenv a multiplier
   1 => s_ws.sync; // prepare the SinOsc to be used as a waveshaper for overdrive

   // set default
   100.0 => BaseFreq.next;
   50.0 => TomFallFreq.gain; // tom initial pitch: 80 hz
   1.0 - 1.0 / 4000 => g1_fb.gain; // tom pitch decay
   g1_f.set(100, 1); // set tom pitch attack
   1.0 - 1.0 / 4000 => g2_fb.gain; // tom amp decay
   g2_f.set(50, 1); // set tomD amp attack
   .5 => ampenv.gain; // overdrive gain
   s_f.set(1000, 1); // set tom lowpass filter

   fun void hit(float v)
   {
      v => i.next;
   }
   fun void setBaseFreq(float f)
   {
      f => BaseFreq.next;
   }
   fun void setFreq(float f)
   {
      f => TomFallFreq.gain;
   }
   fun void setPitchDecay(float f)
   {
      f => g1_fb.gain;
   }
   fun void setPitchAttack(float f)
   {
      f => g1_f.freq;
   }
   fun void setDecay(float f)
   {
      f => g2_fb.gain;
   }
   fun void setAttack(float f)
   {
      f => g2_f.freq;
   }
   fun void setDriveGain(float g)
   {
      g => ampenv.gain;
   }
   fun void setFilter(float f)
   {
      f => s_f.freq;
   }
}


kjzTT101 A;
A.output => dac;

for(int i; i < 8; i++)
{ A.setBaseFreq(60 + i*20); A.hit(.5 + i * .1); .8::second => now; }
