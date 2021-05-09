// Globals
Machine.add(me.dir()+"07_Global.ck");
// Libraries
Machine.add(me.dir()+"Library2001.ck");
Machine.add(me.dir()+"OSC_Read.ck");
Machine.add(me.dir()+"07_osc -- chuck class");
500::ms => now;  // offset time to load first data from R 
// Instruments
Machine.add(me.dir()+"inst_kjzTT101.ck");
Machine.add(me.dir()+"../../../lick/lick/fn/FloatFunction.ck");
Machine.add(me.dir()+"../../../lick/lick/interval/Interval.ck");
Machine.add(me.dir()+"../../../lick/lick/interval/Intervals.ck");
Machine.add(me.dir()+"../../../lick/lick/dist/WaveShaper.ck");


Machine.add(me.dir()+"../../../lick/lick/dist/Dist.ck");
Machine.add(me.dir()+"../../../lick/lick/synth/Fat.ck");
// Structure
Machine.add(me.dir()+"07_patternMode.ck");
Machine.add(me.dir()+"07_songMode.ck");
// Initial values
//200::ms => Global.beat;
//36 => Global.root;

