
// runs with chuck 07_initialize.ck   --caution-to-the-wind
// TODO avoid gradual degradation of patterns after first round

Library lib;
Global glo;
OSC_Read osc;
OscIn oin;
OscMsg msg;
6449 => oin.port;

// create an address in the receiver, store in new variable
oin.addAddress( "/ffxf/step1, ffffffffffffffff" );
// Establece valores globales
150::ms => Global.beat;
36 => Global.root;
// cadena de audio -- drums
Gain master => dac;
// instrumentos
0.2 => float hhGain; // asignamos esta variable para afectarla en la función

float testPercent[100];
lib.insertChance(99, testPercent, 5.0) @=> testPercent;

int chanceBd[];
int chanceSd[];
int chanceT1[];
int chanceHh[];
float dynamicsFixed[];

[ 20,0,0,20, 60,0,100,0,  00,0,0,0, 100,0,0,0] @=> int chanceBass[];
[ 0, 0,0, 0,  0,3,  0,3,   0,0,10,12,  3,0,7,0] @=> int chanceBassNotes[];

// ========== Lib.Melody ============
// dos estados posibles:
[0.0,12.0,7.0] @=> float posibleStates[];

[ 1.0, 2.0] @=> float pulse2Durations[];

// ==== Lib.Melody 2 ====
[ 0,  0, 0, 100, 0,  80, 100, 0, 100,  5, 0 ,  100, 0,  0, 10,  10] @=> int chanceM2[];

//  ----------- Matriz de transición ----------
//                 a c t u a l
//                  |      |
//                  V      V
//                 root   octava
// p             +-----------------+
// r    root     |  0.0   |  0.5   |
// o             +--------+--------+
// x   octava    |  1.0   |  0.5   |
// i             +--------+--------+
// m
// o

/*
                  = Matriz de transición =
                   ---- a c t u a l ----
                    |      |         |
                    V      V         V
                    root   octava    quinta
  p             +-----------------+------+
  r    root     |  0.0   |  0.5   | 0.4  |
  o             +--------+--------+------+
  x   octava    |  1.0   |  0.5   | 0.3  |
  i             +--------+--------+------+
  m   quinta    |  0.0   |  0.0   | 0.3  |
  o             +--------+--------+------+

*/
// convierte la matrxíz de transición a un array multidimensional
[[0.0, 0.5, 0.4],
 [1.0, 0.5, 0.3],
 [0.0, 0.0, 0.3]   ] @=> float transitionMatrix[][];

// estado actual solo se usa al iniciar
12.0 => float currentState;

// si el estado actual es igual a al estado que hay en la posición i
// trae el porcentaje correspondiente de la matríz de transición
// para usarlo al llamar la función de probabilidad y renovar
// el estado actual, luego suma el estado actual a la nota raiz
// y asigna la frecuencia al instrumento sine

// break
[100,0,0,0, 0,0,100,0, 0,0,100,0,  100,0,0,0] @=> int chanceBreak[];
// Envolventes participantes
[lib.melody, lib.pulseADSR, lib.pulseADSR2, lib.bass, lib.bd, lib.sd, lib.hh, lib.pulseADSR3] @=> ADSR envs[];

// silence = 0, break =1
// TODO this function can be overload to receive an array
//      of switches of a 16 step pattern

// shreds ====================
Shred playDrumsShred;
Shred playBassFromOscShred;
Shred playBassFromOscCompShred;
Shred breakShred;
Shred uplifterShred;

// functions ====================
fun void oscRun()
{
   osc.values["gain"] => lib.pulse3.gain;
   //<<< "OSC value GAIN:", osc.values["gain"]>>>;
   1::samp => now;
}

fun float floatChance( int percent, float value1, float value2)
{
    // función generar probabilidades según corpus (FAIL when value already exist)
    float percentArray[100];
    for( 0 => int i; i < 100; i++)
    {
        if( i < percent ) value1 => percentArray[i];
        if( i >= percent ) value2 => percentArray[i];
    }
    percentArray[Math.random2(0, percentArray.cap()-1)] => float selected;
    return selected;
}

fun float[] insertChance( int percent, float actual[], float valueToInsert)
{
    // Not usable yet
    float transitionArray[100];
    for( 0 => int i; i < 100; i++)
    {
        if( i < percent ) valueToInsert => transitionArray[i];
        if( i >= percent ) actual[i] => transitionArray[i];
    }
    return transitionArray;
}

fun void hitKick(int beats)
{
    <<<"hit K">>>;
    lib.bd.keyOn();  1.0 => lib.bdImpulse.next;
    Global.beat * beats => now;
    lib.bd.keyOff();
}

fun void initDrums()
{
// Probabilidad de un corpus -- drums
    [100,  0,  0, 80,   100,  0,  0, 00,  100,  0,  0,  80,   100,  0,  0, 00] @=>  chanceBd;
    [  0,  0,  0,  0,    00,  0,100,  0,     0,  0,  0,  0,    00,  0,100,  0] @=>  chanceSd;
    [  0,  0,100,  0,    00,  0,100,  0,     0,  0,100,  0,     0,  0,100, 20] @=>  chanceT1;
    [ 100, 0,100,100,   100,  0,100,100,    90,  0,100,100,    80,  0,100, 30] @=>  chanceHh;
// curva de dinámica fija
    [1.0,1.0,0.4,0.8,1.0,1.0,0.4,0.8,1.0,0.7,0.4,0.8,1.0,1.0,0.4,0.8] @=> dynamicsFixed;
}

fun void variations()
{
    initDrums();
    while(true){
        if(Global.mod16 > 12){
            lib.insertRandomInt(14, chanceSd, 30, 70) @=>  chanceSd;
        }
        if(Global.mod32 > 24){
            lib.insertRandomInt(12, chanceSd, 0, 80) @=>  chanceSd;
            lib.insertRandomInt(12, chanceBd, 0, 60) @=>  chanceBd;
        }
        if(Global.mod64 > 42){
            lib.insertRandomInt(8, chanceSd, 80, 70) @=>  chanceSd;
            lib.insertRandomInt(4, chanceBd, 0, 99) @=>  chanceBd;
            lib.insertRandomInt(4, chanceT1, 0, 90) @=>  chanceT1;
            lib.insertRandomInt(4, chanceHh, 0, 99) @=>  chanceHh;
        }
        else{ initDrums(); }
        Global.beat => now;
    }
}

fun void playDrums()
{
    // función que usa probabilidades para activar los instrumentos
    0 => int i;
    while(true)
    {
        i % 16 => i;
        hhGain * dynamicsFixed[i] => lib.hhImpulse.gain;
        floatChance( chanceBd[i], 1,0 ) => float bdSwitch;
        floatChance( chanceSd[i], 1,0 ) => float sdSwitch;
        floatChance( chanceT1[i], 1,0 ) => float t1Switch;
        floatChance( chanceHh[i], 1,0 ) => float hhSwitch;
        lib.bd.keyOff();
        lib.sd.keyOff();
        lib.hh.keyOff();
        if( bdSwitch == 1 ){ lib.bd.keyOn(); 1.0 => lib.bdImpulse.next;  }
        if( sdSwitch == 1 ){ lib.sd.keyOn(); }
        if( t1Switch == 1 ){ lib.t1.setBaseFreq(Std.mtof(Global.root +12) + i*1); lib.t1.hit(.1 + i * .1); }
        if( hhSwitch == 1 ){ lib.hh.keyOn(); }
        Global.beat => now;
        i++;
    }
}

fun void four()
{
    while(true)
    {
        lib.bd.keyOn();  1.0 =>   lib.bdImpulse.next;
        Global.beat * 4 => now;
    }
}

fun void playBass()
{
  while(true)
    {
      floatChance( chanceBass[Global.mod16], 1, 0 )   => float bassSwitch;
      chanceBassNotes[Math.random2(0, 15)] => float bassNote;
      lib.bass.keyOff();
      if( bassSwitch == 1 ){ Std.mtof( bassNote + Global.root ) => lib.fat.freq; lib.bass.keyOn();  }
      Global.beat  => now;
    }
}

fun void playBassFromOsc()
{
    while(true)
    {
        Global.bassFromOsc[Global.mod16] => float bassNote;
        lib.bass.keyOff();
        if( bassNote != -1 ){ Std.mtof( bassNote + Global.root ) => lib.fat.freq; lib.bass.keyOn();  }
        Global.beat => now;
    }
}

fun void playBassFromOscComp()
{
    while(true)
    {
        Global.bassFromOscComp[Global.mod16] => float bassNoteComp;
        lib.sin0env.keyOff();
        if( bassNoteComp != -1 ){ Std.mtof( bassNoteComp + Global.root ) => lib.sin0.freq; lib.sin0env.keyOn();  }
        Global.beat => now;
    }
}

fun void playBassDrop()
{
    while(true)
    {
        lib.bass.keyOff();
        Std.mtof( Global.root ) => lib.fat.freq; lib.bass.keyOn();
        Global.beat * 2 => now;
        lib.bass.keyOff();
        Global.beat * 2 => now;
    }
}

fun void pitchUp()
{
    //  buildup function
    while(true)
    {
        Global.root * Global.mod64  => lib.pulse.freq;
        lib.pulseADSR.set(  Math.random2(0,20)::ms, Math.random2(5,180)::ms, 0.0, 100::ms);
        Global.mod64/100 => lib.pulseRev.mix; 
        Global.beat => now;
    }
}

fun void uplifter()
{
    0.05 => lib.uplift.gain;
    lib.upliftADSR.keyOn();
    // TODO: un-absolutize
    // TODO: LOGIC ERROR if Global.beat > 59 ADSR do not keyOff
    Global.beat * 59 => now;
    lib.upliftADSR.keyOff();
 }

fun void uplifterLFO()
{
    while(true){
        12::second => lib.lfo.period;
        lib.lfo.last()*100 => lib.uplift.freq;
        50::ms => now;
    }
}

fun void kickRoll()
{
        hitKick(8); hitKick(8);
        hitKick(4); hitKick(4); hitKick(4); hitKick(4);
        hitKick(2); hitKick(2); hitKick(2); hitKick(2); hitKick(2); hitKick(2); hitKick(2); hitKick(2);
        hitKick(1); hitKick(1); hitKick(1); hitKick(1); hitKick(1); hitKick(1); hitKick(1); hitKick(1); hitKick(1); hitKick(1); hitKick(1); hitKick(1); hitKick(1); hitKick(1); hitKick(1); hitKick(1);
}

fun void playMarkov()
{
    while(true)
    {
        lib.melody.keyOff();
        lib.pulseADSR.keyOff();
        // recorre la cantidad de estados posibles
        for( 0 => int i; i < posibleStates.cap(); i++)
        {
            if( currentState == posibleStates[i] )
            {
                (transitionMatrix[i][i] * 100.0) $ int => int percent;
                floatChance( percent,posibleStates[0],posibleStates[1]) => currentState;
                Std.mtof(Global.root + 12 + currentState) => lib.melodyImpulse.freq;
                Std.mtof(Global.root + 24 - (2*currentState)) => lib.pulse.freq;
                lib.melody.keyOn();
                lib.pulseADSR.keyOn();
                Global.beat => now;
                lib.melody.keyOff();
                lib.pulseADSR.keyOff();
            }
        }
    }
}

fun void playMarkov2()
{
    //lib.print(testPercent);
    while(true)
    {
        lib.pulseADSR2.keyOff();
        floatChance( chanceM2[Global.mod16], 1, 0 )   => float M2Switch;
        // recorre la cantidad de estados posibles
        for( 0 => int i; i < posibleStates.cap(); i++)
        {
            if( currentState == posibleStates[i] )
            {
                lib.insertChance(50, testPercent, 0.0) @=> testPercent;
                //lib.insertChance(30, testPercent, 12.0) @=> testPercent;
                lib.insertChance(20, testPercent, 3.0) @=> testPercent;
                lib.insertChance(10, testPercent, 7.0) @=> testPercent;
                Std.mtof(Global.root + 24 + testPercent[Math.random2(0, 99)]) => lib.pulse2.freq;
                if( M2Switch == 1 ){ lib.pulseADSR2.keyOn();  }
                Global.beat => now;
                lib.pulseADSR2.keyOff();
             }
        }
    }
}

fun void playBreak(int type)
{
    while(true)
    {
        if(type == 1)
        {
            // apaga todas las envolventes antes de empezar 
            for(0 => int i; i < envs.cap(); i++){ envs[i].keyOff(); }
            floatChance( chanceBreak[Global.mod16], 1, 0 )   => float breakSwitch;
            if( breakSwitch == 1 ){
                // asigna frecuencia
                //Std.mtof(Global.root + 12 + multiTest[Global.mod16][Math.random2(0, 99)]) => pulse3.freq;
                // siendo 1 enciende todas las envolventes
                for(0 => int i; i < envs.cap(); i++){ envs[i].keyOn(); }
            }
        }
        if(type == 0)
        {
            for(0 => int i; i < envs.cap(); i++){ envs[i].keyOff(); }
        }
        else
        {
            for(0 => int i; i < envs.cap(); i++){ envs[i].keyOn(); }
        }
        Global.beat => now;
    }
}

fun void rollCounter()
{
        while(true)
        {
            Global.counter  +  1 @=> Global.counter;
            Global.counter %   4 @=> Global.mod4;
            Global.counter %  16 @=> Global.mod16;
            Global.counter %  32 @=> Global.mod32;
            Global.counter %  64 @=> Global.mod64;
            Global.counter % 256 @=> Global.mod256;
            Global.beat => now;
            <<< Global.counter, Global.mod16, Global.mod32, Global.mod64 >>>;
    }
}

fun int intro(int steps)
{
    spork~ playBassFromOscComp();
    spork~ playDrums();
    Global.beat * steps => now;
    return steps;
}

fun int breakDown(int steps)
{
    spork~ playDrums() @=> playDrumsShred;  // store Shred to be removed by id()
    spork~ playBassFromOsc() @=> playBassFromOscShred;
    spork~ playBassFromOscComp() @=> playBassFromOscCompShred;
    Global.beat * steps => now;
    return steps;
}

fun int buildUp(int steps)
{
    Machine.remove(playDrumsShred.id());
    Machine.remove(playBassFromOscShred.id());
    Machine.remove(playBassFromOscCompShred.id());
    spork~ playMarkov();
    spork~ pitchUp();
    spork~ uplifter() @=> uplifterShred;
    spork~ uplifterLFO();
    spork~ kickRoll();
    Global.beat * steps => now;
    return steps;
}

fun int breakA(int steps)
{
    Machine.remove(uplifterShred.id());
    spork~ playBreak(0) @=> breakShred;
    Global.beat * steps => now;
    return steps;
}

fun int drop(int steps)
{
    //  TODO remove precedent sporks
    spork~ playMarkov2(); // not markov yet
    spork~ four();
    spork~ playBassDrop();
    Global.beat * steps => now;
    return steps;
}


fun void removeBreak()
{
    Machine.remove(breakShred.id()); 
}

fun int postDrop(int steps)
{
    spork~ playMarkov2();
    spork~ playDrums();
    spork~ playBassFromOscComp();
    spork~ playBassFromOsc();
    Global.beat * steps => now;
    return steps;
}

// sporks ====================
spork~ rollCounter();
spork~ variations();
spork~ oscRun();
spork~ lib.dynClassic(lib.sdGain, 0.9); // gain dynamics on instrument level
spork~ lib.dynClassic(lib.pulse2gain, 0.05);

while(true)
{
    // play parts in serial
    64 => int steps;
    spork~ breakDown(steps*2);
    Global.beat * steps => now; // TODO: porque no multiplica por dos?
    spork~ buildUp(steps - 4);
    Global.beat * (steps - 4) => now;
    spork~ breakA(steps/8);
    Global.beat * steps/8 => now;
    spork~ drop(steps);
    Global.beat * steps => now;
    spork~ removeBreak();
    spork~ postDrop(steps);
    Global.beat * steps  => now;
}

Global.beat * 256 => now; // keep sporks alive
Machine.add(me.dir()+"07_patternMode.ck:777"); // reload
