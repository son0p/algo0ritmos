// Simple Delayline Snare 01 version 0.3 testing
// by kijjaz
// simple delaylines snare drum design: still a testing prototype

// licence: Attribution-Share Alike 3.0
// You are free:
//    * to Share — to copy, distribute and transmit the work
//    * to Remix — to adapt the work
// Under the following conditions:
//    * Attribution. You must attribute the work in the manner specified by the author or licensor
//      (but not in any way that suggests that they endorse you or your use of the work).
//    * Share Alike. If you alter, transform, or build upon this work,
//      you may distribute the resulting work only under the same, similar or a compatible license.

// news: version 0.2 is never released (0.3 is developed in a different direction)
// now includes a way to improve sound and flexibility from version 0.1
// and now is a class for easy integration with other programs

// note: there are 4 output for you to chuck out: outputTop, outputBottom, outputTopDrive, output
// output = sum of the first three outputs. warning! can be very loud
// use (or set) outputLimit if you need limiting

class DelaylineSnare01
{
    // constructing a snare drum: create top head, body, and bottom head
    // connect them by top -> body -> bottom -> body -> then back to top
    DelayA drumTop => Gain g1 => DelayA drumBody1 => Gain g2
    => DelayA drumBottom => Gain g3 => DelayA drumBody2 => Gain g4 => drumTop;
    
    // prepare maximum delay time for the parts
    // (one second is like 315 meters in the air, i hope a snare should not be that big haha!)
    second => drumTop.max => drumBody1.max => drumBottom.max => drumBody2.max;
    
    // make drum top head sustain by applying feedback
    drumTop => Gain g5 => drumTop;
    
    // make drum bottom head sustain and attach noisy snares by AM with Noise
    drumBottom => Gain g6 => drumBottom;
    Noise snare => LPF snare_f => g6;
    g6.op(3);
    
    // prepare a stick and attach to Drum Top Head
    Impulse stickImp => LPF stickImp_f => SinOsc stickDrive => drumTop;    
    stickDrive.sync(1); // prepare overdrive for the stick impulse
    Gain input => stickDrive; // chuck to input for external hitting!
    
    // prepare seperate outputs: outputTop, outputBottom, outputTopDrive
    drumTop => Gain outputTop;
    drumBottom => Gain outputBottom;
    drumTop => Gain drumTop_driveGain => SinOsc drumTop_drive => Gain outputTopDrive;
    drumTop_drive.sync(1);
    
    // prepare one master output: output, outputLimit (output with a Dyno limiter)
    drumTop => Gain outputTopMix => Gain output;
    drumBottom => Gain outputBottomMix => output;
    drumTop_drive => Gain outputTopDriveMix => output;
    output => Dyno outputLimit;
    outputLimit.limit();
    
    // initialization to default sound (by using loadPreset function)
    loadAllValues( [200.0, 600, 1000, .3, .4, .5, .5, .6, 5, 9000, .5, 5, 180, 5, .5, .5, 1, .5], false);
        
    fun void loadAllValues(float values[], int stickDrive)
    {
        values[0] => topFreq;
        values[1] => bottomFreq;
        values[2] => bodyFreq;
        values[3] => topDecay;
        values[4] => bottomDecay;
        values[5] => topGain;
        values[6] => bottomGain;
        values[7] => bodyGain;
        values[8] => snareGain;
        values[9] => snareFreq;
        values[10] => snareQ;
        values[11] => stickGain;
        values[12] => stickFreq;
        values[13] => stickQ;
        values[14] => topDriveGain;
        values[15] => topMix;
        values[16] => bottomMix;
        values[17] => topDriveMix;
        if (stickDrive) stickDriveOn(); else stickDriveOff();
    }
    
    
    // - - - functions - - -
    // drum part delay time (set by supplying frequency)
    fun void topFreq(float f)
    {
        second / f => drumTop.delay;
    }
    fun void bottomFreq(float f)
    {
        second / f => drumBottom.delay;
    }
    fun void bodyFreq(float f)
    {
        second / f => drumBody1.delay => drumBody1.delay;
    }
    // top and bottom decay rate
    fun void topDecay(float rate)
    {
        rate => g5.gain;
    }
    fun void bottomDecay(float rate)
    {
        rate => g6.gain;
    }
    fun void topGain(float g) // gain from top to body
    {
        g => g1.gain;
    }
    fun void bottomGain(float g) // gain from top to body
    {
        g => g3.gain;
    }    
    fun void bodyGain(float g) // gain from body to top and bottom
    {
        g => g2.gain => g4.gain;
    }
    // snare & bottom set up
    fun void snareGain(float g)
    {
        g => snare.gain;
    }
    fun void snareFreq(float f)
    {
        f => snare_f.freq;
    }
    fun void snareQ(float Q)
    {
        Q => snare_f.Q;
    }
       
    // stick
    fun void stickGain(float g)
    {
        g => stickImp.gain;
    }
    fun void hit(float velocity)
    {        
        velocity => stickImp.next;        
    }
    fun void stickFreq(float f)
    {
        f => stickImp_f.freq;
    }
    fun void stickQ(float Q)
    {
        Q => stickImp_f.Q;
    }
    fun void stickDriveOn() // compute Sine overdrive
    {
        stickDrive.op(1);
    }
    fun void stickDriveOff() // bypass the drive unit
    {
        stickDrive.op(-1);
    }
    
    fun void topDriveGain(float g) // set gain for drum top overdrive
    {
        g * .5 => drumTop_driveGain.gain;
    }
    // set balance mix of each sound into the main output (and also the outputLimit)
    fun void topMix(float g)
    {
        g => outputTopMix.gain;
    }
    fun void bottomMix(float g)
    {
        g => outputBottomMix.gain;
    }
    fun void topDriveMix(float g)
    {
        g => outputTopDriveMix.gain;
    }    
}


// test code

DelaylineSnare01 A;
A.outputLimit => dac;

int i;
while(true)
{
    if ((i * 5 + 2) % 8 < 3)
    for(int j; j < 4; j++)
    {
        A.hit(j + 1);
        300.0::ms / 4 => now;
    }    
    else
    {
        A.hit((9 - i % 8) * 2 + 2);
        300.0::ms => now;
    }
    i++;
}
