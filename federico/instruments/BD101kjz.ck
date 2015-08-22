// simple analog-sounding bass drum with pitch and amp decay and sine overdrive
public class BD101kjz
{
   Impulse i; // the attack
   i => Gain g1 => Gain g1_fb => g1 => LPF g1_f => Gain BDFreq; // BD pitch envelope
   i => Gain g2 => Gain g2_fb => g2 => LPF g2_f; // BD amp envelope

   // drum sound oscillator to amp envelope to overdrive to LPF to output
   BDFreq => SinOsc s => Gain ampenv => SinOsc s_ws => LPF s_f => Gain output;
   g2_f => ampenv; // amp envelope of the drum sound
   3 => ampenv.op; // set ampenv a multiplier
   1 => s_ws.sync; // prepare the SinOsc to be used as a waveshaper for overdrive

   // set default
   80.0 => BDFreq.gain; // BD initial pitch: 80 hz
   1.0 - 1.0 / 2000 => g1_fb.gain; // BD pitch decay
   g1_f.set(100, 1); // set BD pitch attack
   1.0 - 1.0 / 4000 => g2_fb.gain; // BD amp decay
   g2_f.set(50, 1); // set BD amp attack
   .75 => ampenv.gain; // overdrive gain
   s_f.set(600, 1); // set BD lowpass filter

   fun void hit(float v)
   {
      v => i.next;
   }
   fun void setFreq(float f)
   {
      f => BDFreq.gain;
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

// ---------- test
// kjzBD101 A;
// A.output => dac;

// for(int i; i < 8; i++)
// { A.hit(.5 + i * .1); .5::second => now; }
