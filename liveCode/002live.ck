// define una
500::ms=> dur beat;
0 => int i;
16 => int loopSize;
// sonido para probar
Impulse impulse => dac;
PulseOsc pulse => ADSR ePulse => NRev rPulse=> dac;
rPulse.mix(0.0);
pulse.gain(0.3);
pulse.width(0.0);

// notes
110 => float root;
//[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, root/2, root/3, root/4, root/8] @=> float tones[];

// bass
ResonZ modes[10];

[[ root , 0.70212 ],   // these are the modes from the
[ root + root/2 , 0.971846 ],    // plate we whacked in the
[ root + root/8 , 0.849900 ],      // online video
[ 2010.662842 , 0.378065 ],
[ 2670.117188 , 1.000000 ],  // replace them with your own from
[ 3071.173096 , 0.104546 ],  //    your analysis of your object/sound
[ 3563.745117 , 0.098136 ],
[ 4465.447998 , 0.043037 ],  // NOTE:  number of entries here should
[ 4556.964111 , 0.007220 ],  //    equal NUM_MODES
[ 5499.041748 , 0.004922 ]]  // which you can change if you like!
     @=> float freqsNamps[][];

Noise n => ADSR strike;
(ms, 50::ms, 0.01, 100::ms) => strike.set;
30.0 => strike.gain;

for (int i; i < 10; i++){
    strike => modes[i] => dac;
    freqsNamps[i][0] => modes[i].freq;
    500 - (i*30) => modes[i].Q;
    freqsNamps[i][1] => modes[i].gain;
}

// cambiar rango de i
fun float changeRange (int OldValue, int OldMin, int OldMax, float NewMin, float NewMax)
{
    (OldMax - OldMin) => int OldRange;
    (NewMax - NewMin) => float NewRange;
    (((OldValue - OldMin) * NewRange) / OldRange) + NewMin => float NewValue;
    return NewValue;
}

// funciones de prueba
fun float floatChance( int percent, float value1, float value2)
{
    float percentArray[100];
    for( int i; i < 100; i++)
    {
        if( i < percent )
        {
            value1 => percentArray[i];
        }
        if( i >= percent )
        {
            value2 => percentArray[i];
        }
    }

    percentArray[Math.random2(0, percentArray.cap()-1)] => float selected;
    return selected;
}

fun void kick()
{
    while(true)
    {
        <<<"kick">>>;
        1 => impulse.next;
        beat => now;
    }
}
fun void bassPulse(float freq, dur duration, float width)
{
    (ms, duration, 0.01, 100::ms) => ePulse.set;
    pulse.freq(freq);
    width => pulse.width;
    ePulse.keyOn();
    duration => now;
    ePulse.keyOff();

}

fun void bass()
{
    while(true)
    {
        1 => strike.keyOn;
        beat/2 => now;
        strike.keyOff;
        beat/2 => now;
    }
}
fun void bassLine()
{
    while(true)
    {
        changeRange(i, 0, loopSize, 0.1, 1.0) => float newWidth;
        floatChance(95 - i, 0, root/Math.random2(2,4)) => float tone;
        floatChance(70 - i*2, 4, 16) $ int => int division;
        floatChance(70 - i*2  , newWidth, 0.05) => float width;
        spork ~ bassPulse( root + tone , beat/division, width );
        beat/4 => now;
    }
}
fun void reverbCall()
{
    while(true)
    {
        changeRange(i, 0, loopSize, 0.001, 0.05) => rPulse.mix;
        beat * 2 => now;
    }
}
// llama las funciones de forma paralela
spork ~ reverbCall();
spork ~ kick();
spork ~ bassLine();
spork ~ bass();
// alcance del loop
while(i < loopSize)
{
    beat => now;
    <<< i + " ::: contador" >>>;
    i++;
}
// antes de terminar se llama a si mismo
Machine.add(me.dir() + "/002live.ck");
