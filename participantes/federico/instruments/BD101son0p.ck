public class BD101son0p
{
    // Hacemos un bombo, filtrando un Impuslo.
  Impulse kick => TwoPole kp => dac;
  5000.0 => kp.freq; 0.5 => kp.radius;
  0.3 => kp.gain => float globalKpGain;
  static float toneSustain;
  0.1 => static float toneRelease;
  SinOsc tone => ADSR toneKick => dac;
  toneKick.set(0.001,0.2,toneSustain,0.1);
  0.3 => tone.gain;
  51.9 => tone.freq;
  // ojo RezonZ
}
