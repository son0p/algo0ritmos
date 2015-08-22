// kijjaz's Table Rimshot 01 - version 0.1 testing

550.0 => float freq;
.3 => float randomRange;
.9 => float decay;
(second / samp / freq) $ int => int samples;

float table[samples];


Step s => Dyno compressor => dac;
s.gain(.5);
compressor.compress();
compressor.thresh(.1);

int j;
while(true)
{
    // reset
    if (now % second == 0::ms) for(int i; i < samples; i++) Std.rand2f(-1, 1) => table[i];


    Std.rand2(0, (samples * randomRange) $ int) => int i;
    table[(j + i) % samples] => s.next;
    decay *=> table[(j + i) % samples];
    samp => now;
    j++;
}
