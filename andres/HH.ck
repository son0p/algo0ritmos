// easy white noise snare
class HH 
{
    // note: connect output to external sources to connect
    Noise s => Gain s_env => LPF s_f => Gain output; // white noise source
    Impulse i => Gain g => Gain g_fb => g => LPF g_f => s_env;

    3 => s_env.op; // make s envelope a multiplier
    s_f.set(3000, 4); // set default drum filter
    g_fb.gain(1.0 - 1.0/3000); // set default drum decay
    g_f.set(200, 1); // set default drum attack

    fun void setFilter(float f, float Q)
    {
        s_f.set(f, Q);
    }
    fun void setDecay(float decay)
    {
        g_fb.gain(1.0 - 1.0 / decay); // decay unit: samples!
    }
    fun void setAttack(float attack)
    {
        g_f.freq(attack); // attack unit: Hz!
    }
    fun void hit(float velocity)
    {
        velocity => i.next;
    }
}
/*
kjzSnare101 A;
A.output => dac;
A.hit(0.8);
2::second => now;
A.setDecay(10000);
A.setFilter(5000, 5);
A.hit(0.8);
2::second => now;
*/