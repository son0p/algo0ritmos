SinOsc s => ADSR env =>  dac;
Step c => Envelope mod => s;

SinOsc t => s;
80 => t.gain;
30 => t.freq;

300 => c.next;

80 => s.freq;

2 => s.sync;

.7 => env.sustainLevel;
50::ms => env.decayTime;
.1::second => env.releaseTime;
.05::second => mod.duration;

while(1)
   {
   1 => mod.value;
   1 => mod.keyOff;
   1 => env.keyOn;

   .1::second => now;

   1 => env.keyOff;

   .4::second => now;
   }
