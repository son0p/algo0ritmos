public class Fm
{
  2 => carrier.sync; //debe ser dos para que se monte una sobre la otra
  20 => int modulatorFreq;
  1000 => int modulatorGain;
  public void fmSynth(Osc modulator, Osc carrier)
  {
    modulatorGain => modulator.gain;
    modulatorFreq => modulator.freq;
    modulator => carrier => dac;
  }

  public int changeModulatorFreq(int freq)
  {
      freq => modulatorFreq;
      return freq;
  }
}

// // test
// Fm fm;
// SinOsc s,r;
// fm.fmSynth(s,r);
// 1::day => now;
