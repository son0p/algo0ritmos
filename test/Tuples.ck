// test escrito por: https://github.com/essteban/
class Tuple
{
    int x;
    float y;
    float z;

    fun void tuple(int x, float y, float z)
    {
        x => this.x;
        y => this.y;
        z => this.z;
    }
}

Tuple a,b,c,d,e,f,g;

SinOsc sin => dac;

(60,0.125,1) => a.tuple;
(62,0.125,0.5) => b.tuple;
(64,0.125,0.4) => c.tuple;
(65,0.125,0.3) => d.tuple;
(67,0.25,0.7) => e.tuple;
(67,0.125,0.7) => f.tuple;
(60,0.25,1) => g.tuple;

[a,b,c,d,e,e,f,d,c,b,g,g] @=> Tuple test[];

while(true)
{
    for(0 => int i; i < test.cap(); i++)
    {
        Std.mtof(test[i].x) => sin.freq;
        test[i].z => sin.gain;
        test[i].y::second => now;
    }
}
