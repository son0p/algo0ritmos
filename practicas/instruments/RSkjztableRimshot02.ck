// kijjaz's Table Rimshot 01 - version 0.1 testing with Ramdomwalk patch

440.0 => float freq;
.5 => float randomRange;
.95 => float decay;
(second / samp / freq) $ int => int samples;

float table[samples];


Step s => Dyno compressor => dac;
s.gain(.5);
compressor.compress();
compressor.thresh(.1);

int j, k;
1 => k;
while(true)
{
    // reset
    if (now % second == 0::ms) for(int i; i < samples; i++) Std.rand2f(-1, 1) => table[i];


    Std.rand2(0, (samples * randomRange) $ int) => int i;
    table[(j + i) % samples] => s.next;
    decay *=> table[(j + i) % samples];
    samp => now;
    if (maybe) -1 *=> k;
    k +=> j;
    if (j < 0) samples +=> j;
}
