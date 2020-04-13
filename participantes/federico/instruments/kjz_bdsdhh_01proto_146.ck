// Kijjaz's Noise+Sine Bass Drum, Snare Drum, Hi Hat machine ver. 0.1 prototype
// source code for ChucK programming language
// Copyright 2008 Kijjasak Triyanond (kijjaz@yahoo.com)
// This software is protected by the GNU General Public License.
// Feel free to use, modify, and distribute.

second / samp => float SampleRate;

// The Patch
Step freq => LPF freq_f => SinOsc drumtone => Gain drumtone_g =>
Dyno comp => LPF lpf1 => SinOsc overdrive => dac;

Noise n => Gain n_g => drumtone;
3 => n_g.op => drumtone_g.op;

comp.compress();
5 => comp.ratio;

1 => overdrive.sync;

Impulse n_i => Gain n_i_g => Gain n_i_g_fb => n_i_g => n_g;
Impulse drumtone_i => Gain drumtone_i_g => Gain drumtone_i_g_fb => drumtone_i_g => drumtone_g;

// Initiaization
freq_f.set(500, 1);

int i;
while(true)
{
    // BD
    40 => freq.next;
    // hpf1.set(30, 1);
    lpf1.set(80, 5);
    400 => n_g.gain;
    1.0 - 30.0/SampleRate => drumtone_i_g_fb.gain;
    1.0 - 200.0/SampleRate => n_i_g_fb.gain;    
    
    HIT();
    
    // SD
    750 => freq.next;
    // hpf1.set(30, 1);
    lpf1.set(9000, 1);
    2400 => n_g.gain;
    1.0 - 80.0/SampleRate => drumtone_i_g_fb.gain;
    1.0 - 10.0/SampleRate => n_i_g_fb.gain;
    
    HIT();
    
    // TT1
    200 => freq.next;
    // hpf1.set(30, 1);
    lpf1.set(400, 2);
    20 => n_g.gain;
    1.0 - 100.0/SampleRate => drumtone_i_g_fb.gain;
    1.0 - 60.0/SampleRate => n_i_g_fb.gain;    
    
    HIT();
    
    // TT2
    150 => freq.next;
    // hpf1.set(30, 1);
    lpf1.set(300, 2);
    20 => n_g.gain;
    1.0 - 85.0/SampleRate => drumtone_i_g_fb.gain;
    1.0 - 60.0/SampleRate => n_i_g_fb.gain;    
    
    HIT();
    
    // TT3
    100 => freq.next;
    // hpf1.set(30, 1);
    lpf1.set(300, 2);
    20 => n_g.gain;
    1.0 - 70.0/SampleRate => drumtone_i_g_fb.gain;
    1.0 - 60.0/SampleRate => n_i_g_fb.gain;    
    
    HIT();
    
    // HH
    4000 => freq.next;
    // hpf1.set(7000, 1);
    lpf1.set(12000, 1);
    12000 => n_g.gain;
    1.0 - 200.0/SampleRate => drumtone_i_g_fb.gain;
    1.0 - 50.0/SampleRate => n_i_g_fb.gain;
    
    HIT();
    
    // Open HH
    4000 => freq.next;
    // hpf1.set(7000, 1);
    lpf1.set(8000, 3);
    12000 => n_g.gain;
    1.0 - 40.0/SampleRate => drumtone_i_g_fb.gain;
    1.0 - 10.0/SampleRate => n_i_g_fb.gain;
    
    HIT();    
    
    // Clave
    1200 => freq.next;
    // hpf1.set(30, 1);
    lpf1.set(1000, 2);
    200 => n_g.gain;
    1.0 - 150.0/SampleRate => drumtone_i_g_fb.gain;
    1.0 - 120.0/SampleRate => n_i_g_fb.gain;    
    
    HIT();
}


fun void HIT()
{
    for(int i; i < 8; i++)
    {
        1 - n_i_g.last() => n_i.next;
        1 - drumtone_i_g.last() => drumtone_i.next;
        125::ms => now;
    }
    
}