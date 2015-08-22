// with some approvements from 101: snare ringing in the body
class kjzSnare102 {
    // note: connect output to external sources to connect
    Noise s => Gain s_env => LPF s_f => Gain output; // white noise source
    Impulse i => Gain g => Gain g_fb => g => LPF g_f => s_env;

    s_env => DelayA ringing => Gain ringing_fb => ringing => LPF ringing_f => output;

    3 => s_env.op; // make s envelope a multiplier
    s_f.set(3000, 4); // set default drum filter
    g_fb.gain(1.0 - 1.0/3000); // set default drum decay
    g_f.set(200, 1); // set default drum attack

    ringing.max(second);
    ringing.delay((1.0 / 440) :: second); // set default: base ringing frequency = 440Hz
    ringing_fb.gain(0.35); // set default ringing feedback
    ringing_f.set(1500, 1); // set default ringing LPF
    ringing_f.gain(0.6); // set default ringing vol

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

    fun void setRingingGain(float g)
    {
        g => ringing_f.gain;
    }
    fun void setRingingFreq(float f)
    {
        (1.0 / f)::second => ringing.delay;
    }
    fun void setRingingFeedback(float g)
    {
        g => ringing_fb.gain;
    }
    fun void setRingingFilter(float f, float Q)
    {
        ringing_f.set(f, Q);
    }
}

kjzSnare102 A;
A.output => dac;
A.hit(0.8);
1::second => now;
A.setRingingFeedback(.995);
A.setRingingFilter(500, 1);
A.hit(0.8);
3::second => now;
