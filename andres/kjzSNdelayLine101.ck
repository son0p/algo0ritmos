// Simple Delayline Snare 01 version 0.1 testing
// by kijjaz
// simple delaylines snare drum design: still a testing prototype

// licence: Attribution-Share Alike 3.0
// You are free:
//    * to Share — to copy, distribute and transmit the work
//    * to Remix — to adapt the work
// Under the following conditions:
//    * Attribution. You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
//    * Share Alike. If you alter, transform, or build upon this work, you may distribute the resulting work only under the same, similar or a compatible license.

290.0 => float SnareHeadFreq;
600.0 => float SnareBodyFreq;
630.0 => float SnareBottomFreq;

.4 => float SnareHeadDecay;
.3 => float SnareBottomDecay;
.5 => float SnareBodyDecay;

7000.0 => float SnareBuzzFreq;
.7 => float SnareBuzzQ;
4.0 => float SnareBuzzGain;

180.0 => float StickFreq;
6.0 => float StickQ;

.8 => float HeadMicGain;
.4 => float BottomMicGain;

DelayA drumHead1 => DelayA drumBody1 => DelayA drumHead2 =>
Gain drumHead2_mod => DelayA drumBody2 =>
drumHead1;

drumHead1 => Gain drumHead1_mic => SinOsc drumHead1_drive => Dyno limiter => dac;
drumHead2 => Gain drumHead2_mic => limiter;
drumHead1_mic.gain(HeadMicGain / 2);
drumHead1_drive.sync(1);
drumHead2_mic.gain(BottomMicGain);

limiter.limit();
limiter.gain(.9);

drumHead2_mod.op(3);

Noise snareBuzz => LPF snareBuzz_f => drumHead2_mod;
snareBuzz_f.set(SnareBuzzFreq, SnareBuzzQ);
snareBuzz.gain(SnareBuzzGain);

drumHead1 => Gain drumHead1_fb => drumHead1;
drumHead2 => Gain drumHead2_fb => drumHead2;

Impulse stickImp => LPF stickImp_f => drumHead1;
stickImp_f.set(StickFreq, StickQ);

second => drumHead1.max => drumHead2.max => drumBody1.max => drumBody2.max;
second / SnareHeadFreq => drumHead1.delay;
second / SnareBodyFreq => drumBody1.delay => drumBody2.delay;
second / SnareBottomFreq => drumHead2.delay;

SnareHeadDecay => drumHead1_fb.gain;
SnareBottomDecay => drumHead2_fb.gain;

SnareBodyDecay => drumBody1.gain => drumBody2.gain;
// - - - start hitting

int i;
while(true)
{
    if (i % 8 < 3) stickImp.next(40); else stickImp.next(2 + i%2 * 3);
    if ((i * 7) % 12 > 1) 300::ms => now;
    else
    for(int j; j < 6; j++)
    {
        stickImp.next(j + j%2);
        50::ms => now;
    }

    i++;
}
