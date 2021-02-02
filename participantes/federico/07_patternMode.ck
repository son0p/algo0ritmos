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

kjzTT101 t1;
t1.output => dac;
0.01=> t1.setDriveGain;

0.2 => float hhGain; // asignamos esta variable para afectarla en la función

// --bass
Fat fat  => ADSR bass => LPF filterBass => NRev fatRev => dac;
0.3 => fat.gain;  2800 => filterBass.freq;
bass.set( 0::ms, 80::ms, fat.gain()/1.5, 100::ms );
0.03 => fatRev.mix;
// --Melody
BlitSaw melodyImpulse => ADSR melody => NRev mReverb => dac;
0.09 => melodyImpulse.gain;
melody.set( 0::ms, 80::ms, melodyImpulse.gain()/1.5, 100::ms );
0.03 => mReverb.mix;

PulseOsc pulse => ADSR pulseADSR => NRev pulseRev => dac;
0.02 => pulse.gain;
pulseADSR.set( 0::ms, 80::ms, pulse.gain()/1.5, 100::ms );
0.02 => pulseRev.mix;

PulseOsc pulse2 => ADSR pulseADSR2 => NRev pulseRev2 => Gain pulse2gain => dac;
0.03 => pulse2gain.gain;

pulseADSR2.set( 0::ms, 80::ms, pulse2.gain()/2.5, 200::ms );
0.19 => pulseRev2.mix;
Math.random2f(0.1, 0.99)=> pulse2.width;

PulseOsc pulse3 => ADSR pulseADSR3 => NRev pulseRev3 => dac;
0.03 => pulse3.gain;
pulseADSR3.set( 0::ms, 80::ms, pulse3.gain()/2.5, 200::ms );
0.19 => pulseRev3.mix;
Math.random2f(0.1, 0.99)=> pulse3.width;

// ===== FUNCTIONS ===

fun void oscRun(){
   osc.values["gain"] => pulse3.gain;
   //<<< "OSC value GAIN:", osc.values["gain"]>>>;
   1::samp => now;
}

// función generar probabilidades según corpus (FAIL when value already exist)
fun float floatChance( int percent, float value1, float value2)
{
  float percentArray[100];
  for( 0 => int i; i < 100; i++)
    {
      if( i < percent ) value1 => percentArray[i];
      if( i >= percent ) value2 => percentArray[i];
    }
  percentArray[Math.random2(0, percentArray.cap()-1)] => float selected;
  return selected;
}
// Not usable yet
fun float[] insertChance( int percent, float actual[], float valueToInsert)
{
    float transitionArray[100];
    for( 0 => int i; i < 100; i++)
    {
        if( i < percent ) valueToInsert => transitionArray[i];
        if( i >= percent ) actual[i] => transitionArray[i];
    }
    return transitionArray;
}

// test
float testPercent[100];
lib.insertChance(99, testPercent, 5.0) @=> testPercent;

// ============= DRUMS =================
// Probabilidad de un corpus -- drums
[100,  0,  0, 80,   100,  0,  0, 00,  100,  0,  0,  80,   100,  0,  0, 00] @=> int chanceBd[];
[  0,  0,  0,  0,    00,  0,100,  0,     0,  0,  0,  0,    00,  0,100,  0] @=> int chanceSd[];
[  0,  0,100,  0,    00,  0,100,  0,     0,  0,100,  0,     0,  0,100, 20] @=> int chanceT1[];
[ 100, 0,100,100,   100,  0,100,100,    90,  0,100,100,    80,  0,100, 30] @=> int chanceHh[];

// curva de dinámica fija
[1.0,1.0,0.4,0.8,1.0,1.0,0.4,0.8,1.0,0.7,0.4,0.8,1.0,1.0,0.4,0.8] @=> float dynamicsFixed[];

// función que usa probabilidades para activar los instrumentos
fun void playDrums()
{
  0 => int i;
  while(true)
  {
    hhGain * dynamicsFixed[i] => lib.hhImpulse.gain; // comente y descomente esta línea para escuchar la diferencia
    floatChance( chanceBd[i], 1,0 ) => float bdSwitch;
    floatChance( chanceSd[i], 1,0 ) => float sdSwitch;
    floatChance( chanceT1[i], 1,0 ) => float t1Switch;
    floatChance( chanceHh[i], 1,0 ) => float hhSwitch;
    lib.bd.keyOff();
    lib.sd.keyOff();
    lib.hh.keyOff();
    if( bdSwitch == 1 ){ lib.bd.keyOn(); 1.0 => lib.bdImpulse.next;  }
    if( sdSwitch == 1 ){ lib.sd.keyOn(); }
    if( t1Switch == 1 ){ t1.setBaseFreq(Std.mtof(Global.root +12) + i*1); t1.hit(.1 + i * .1); }
    if( hhSwitch == 1 ){ lib.hh.keyOn(); }
    Global.beat => now;
    //200::ms => now;
    i++;
  }
}

fun void four(){
    while(true){
        lib.bd.keyOn();  1.0 =>   lib.bdImpulse.next;
        Global.beat * 4 => now;
    }
}

// ========== BASS ===========================
[ 20,0,0,20, 60,0,100,0,  00,0,0,0, 100,0,0,0] @=> int chanceBass[];
[ 0, 0,0, 0,  0,3,  0,3,   0,0,10,12,  3,0,7,0] @=> int chanceBassNotes[];
fun void playBass()
{
  0 => int i;
  while(true)
    {
      floatChance( chanceBass[i], 1, 0 )   => float bassSwitch;
      chanceBassNotes[Math.random2(0, 15)] => float bassNote;
      bass.keyOff();
      if( bassSwitch == 1 ){ Std.mtof( bassNote + Global.root ) => fat.freq; bass.keyOn();  }
      Global.beat => now;
      i++;
    }
}

fun void playBassFromOsc()
{
    0 => int i;
    while(true)
    {
        Global.bassFromOsc[i] => float bassNote;
        bass.keyOff();
        if( bassNote != -1 ){ Std.mtof( bassNote + Global.root ) => fat.freq; bass.keyOn();  }
        Global.beat => now;
        i++;
    }
}

fun void playBassFromOscComp()
{
    0 => int i;
    while(true)
    {
        Global.bassFromOscComp[i] => float bassNoteComp;
        lib.sin0env.keyOff();
        if( bassNoteComp != -1 ){ Std.mtof( bassNoteComp + Global.root ) => lib.sin0.freq; lib.sin0env.keyOn();  }
        Global.beat => now;
        i++;
    }
}

fun void playBassDrop()
{
    while(true)
    {
        bass.keyOff();
        Std.mtof( Global.root ) => fat.freq; bass.keyOn();
        Global.beat * 2 => now;
        bass.keyOff();
        Global.beat * 2 => now;

    }
}

fun void pitchUp()
{
    while(true)
    {
        Global.root * Global.mod64  => pulse.freq;
        pulseADSR.set(  Math.random2(0,20)::ms, Math.random2(5,180)::ms, pulse.gain()/ Math.random2f(0.5,1.8), Math.random2(100,8000)::ms);
        Global.mod64/100 => pulseRev.mix; 
        Global.beat => now;
    }
}
// ========== Melody ============
// dos estados posibles:
[0.0,12.0,7.0] @=> float posibleStates[];


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

fun void playMarkov()
{
  while(true)
  {
    // recorre la cantidad de estados posibles
    for( 0 => int i; i < posibleStates.cap(); i++)
    {
      melody.keyOff();
      pulseADSR.keyOff();
      if( currentState == posibleStates[i] )
      {
        (transitionMatrix[i][i] * 100.0) $ int => int percent;
        floatChance( percent,posibleStates[0],posibleStates[1]) => currentState;
        Std.mtof(Global.root + 12 + currentState) => melodyImpulse.freq;
        Std.mtof(Global.root + 24 - (2*currentState)) => pulse.freq;
        melody.keyOn();
        pulseADSR.keyOn();
        Global.beat => now;
      }
    }
  }
}

[ 1.0, 2.0] @=> float pulse2Durations[];

// ==== Melody 2 ====
[ 0,  0, 0, 100, 0,  80, 100, 0, 100,  5, 0 ,  100, 0,  0, 10,  10] @=> int chanceM2[];
fun void playMarkov2()
{
    //lib.print(testPercent);
    while(true)
    {
        pulseADSR2.keyOff();
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
                Std.mtof(Global.root + 24 + testPercent[Math.random2(0, 99)]) => pulse2.freq;
                if( M2Switch == 1 ){ pulseADSR2.keyOn();  }
                Global.beat => now;
             }
        }
    }
}

// switch chance for each step
[ 0, 0, 0, 95,  0, 10,0,0,   40,5,0,100,   0,0,80,30] @=> int chanceM3[];
//  percent distribution of distances
float step1[100];
float step2[100];
float step3[100];
float step4[100];
float step5[100];
float step6[100];
float step7[100];
float step8[100];
float step9[100];
float step10[100];
float step11[100];
float step12[100];
float step13[100];
float step14[100];
float step15[100];
float step16[100];
lib.insertChance(50, step1, 12.0) @=> step1;
lib.insertChance(50, step2, 7.0) @=> step2;
lib.insertChance(50, step4, 0.0) @=> step4;
lib.insertChance(50, step7, 5.0) @=> step7;
lib.insertChance(20, step7, 4.0) @=> step7;
lib.insertChance(20, step9, 4.0) @=> step9;
lib.insertChance(40, step12, 12.0) @=> step12;
lib.insertChance(40, step15, 7.0) @=> step15;
lib.insertChance(40, step16, 4.0) @=> step16;
// Index steps in a mutidimensional array
[ step1, step2, step3, step4, step5, step6, step7, step8, step9, step10, step11, step12, step13, step14, step15, step16
    ] @=> float multiTest[][];


fun void playDistPercent()
{
    while(true)
    {
        pulseADSR3.keyOff();
        floatChance( chanceM3[Global.mod16], 1, 0 )   => float M3Switch;
         if( M3Switch == 1 ){
            Std.mtof(Global.root + 12 + multiTest[Global.mod16][Math.random2(0, 99)]) => pulse3.freq;
            pulseADSR3.keyOn();  }
        Global.beat => now;
    }
}

// ========= break ============
[100,0,0,100, 0,0,100,0, 0,100,100,0,  100,100,0,0] @=> int chanceBreak[];
// Envolventes participantes
[pulseADSR, pulseADSR2, bass, lib.bd, lib.sd, lib.hh, pulseADSR3] @=> ADSR envs[];

fun void playBreak()
{
    while(true)
    {
        // apaga todas las envolventes antes de empezar (falta el kick)
        for(0 => int i; i < envs.cap(); i++){ envs[i].keyOff(); }
        floatChance( chanceBreak[Global.mod16], 1, 0 )   => float breakSwitch;
        if( breakSwitch == 1 ){
            // asigna frecuencia
            Std.mtof(Global.root + 12 + multiTest[Global.mod16][Math.random2(0, 99)]) => pulse3.freq;
            // siendo 1 enciende todas las envolventes
            for(0 => int i; i < envs.cap(); i++){ envs[i].keyOn(); }
            }
        Global.beat => now;
    }
}
fun void rollCounter(){
        while(true){
        Global.counter  +  1 @=> Global.counter;
        Global.counter %   4 @=> Global.mod4;
        Global.counter %  16 @=> Global.mod16;
        Global.counter %  32 @=> Global.mod32;
        Global.counter %  64 @=> Global.mod64;
        Global.counter % 256 @=> Global.mod256;
        Global.beat => now;
        <<< Global.counter, Global.mod256 >>>;
    }
}

fun void variations(){
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

    Global.beat => now;
}
// ==== cambios al final del array
//lib.print(chanceSd);
}

//==== SECTIONS ( Breaks and Samples in InmutableLiveCode)=======

[ "a", "b", "c", "d", "e", "f", "g","h"] @=> string Names[];

//== SONG STRUCTURE
4 => int scale;
16 * scale => int section;
[0, 1, 2, 3, 4, 5, 6, 7] @=> int structureMultiplicators[];
int iIntro; int oIntro; int iBreakDown1; int oBreakDown1; int iBuildUp1; int oBuildUp1; int iDropA; int oDropB;
[ iIntro,  oIntro,  iBreakDown1,  oBreakDown1,  iBuildUp1,  oBuildUp1,  iDropA,  oDropB] @=> int structureParts[]; // TODO assign values to var names
// -- Populate sections borders
for (int i; i < structureMultiplicators.cap(); i++){
    structureParts[i] + (section * structureMultiplicators[i]) @=> structureParts[i];
}

// === PIECE: LOCAL STRUCTURE ====
// ----- INTRO
if(Global.mod256 >= structureParts[0] && Global.mod256 < structureParts[1])
{
    //  spork~ playDrums() @=> Shred  offspring;
    // <<< offspring>>>;
    spork~ playBassFromOsc();
    spork~ playBassFromOscComp();
    spork~ playDrums();
}

// ---- BREAKDOWN 1
if(Global.mod256 >= structureParts[1] && Global.mod256 < structureParts[2]){
    spork~ playDrums();
    spork~ playBassFromOscComp();
    spork~ playBassFromOsc();
}
// --- BuildUp
if(Global.mod256 >= structureParts[2] && Global.mod256 < structureParts[3]){
    spork~ playMarkov();
    spork~ pitchUp();
}
// DROP A
if(Global.mod256 >= structureParts[3] && Global.mod256 < structureParts[4]){
    spork~ playMarkov2(); // not markov yet
    spork~ four();
    spork~ playBassDrop();
}
// BREAKDOWN 2
if(Global.mod256 >= structureParts[4] && structureParts[5] ){
    spork~ playMarkov2(); // not markov yet
    spork~ playDrums();
    spork~ playBassFromOsc();
}
// --- BUILDUP
if(Global.mod256 >= structureParts[5] && Global.mod256 < structureParts[6]){
    spork~ playMarkov();
    spork~ pitchUp();
}
// --- DROP B
if(Global.mod256 >= structureParts[6] && Global.mod256 < structureParts[7]){
    spork~ playMarkov2(); // not markov yet
    spork~ four();
    spork~ playBassDrop();
}
// --- OUTRO
if(Global.mod256 >= structureParts[7] && Global.mod256 < structureParts[8]){
    spork~ four();
}

//// SPORKS ////////
//spork~ playBreak();
spork~ rollCounter();
spork~ variations();
//spork~ playDrums();
spork~ oscRun();
spork~ lib.dynClassic(lib.sdGain, 0.9); // gain dynamics on instrument level
spork~ lib.dynClassic(pulse2gain, 0.05);

// mantiene vivos los sporks
Global.beat * 16 => now;
// antes de morir se crea a sí mismo
Machine.add(me.dir()+"07_patternMode.ck:777");
