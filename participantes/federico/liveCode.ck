220::ms => dur beat;
36 => int root;
Library lib;

// cadena de audio -- drums
Gain master => dac;
// instrumentos
// --bassDrum 
Impulse bdImpulse => ResonZ bdFilter => ADSR bd => master;
1000 => bdImpulse.gain; bdFilter.set(50.0, 10.0); bd.set( 1::ms, 150::ms, .50, 100::ms );
// --snareDrum
Noise sdImpulse => ResonZ sdFilter => ADSR sd => master;
0.7 => sdImpulse.gain; sdFilter.set(400.0, 1.0); sd.set( 0::ms, 100::ms, .01, 100::ms );
// --T1
//Noise t1Impulse => ResonZ t1Filter => ADSR t1 => master;
//0.7 => t1Impulse.gain; t1Filter.set(50.0, 1.0); t1.set( 0::ms, 100::ms, .01, 100::ms );
kjzTT101 t1;
t1.output => Gain t1Gain => master;
// --hiHat
Noise hhImpulse => ResonZ hhFilter => ADSR hh => master;
0.2 => float hhGain; // asignamos esta variable para afectarla en la función
hhGain => hhImpulse.gain; hhFilter.set(10000.0, 5.0); hh.set( 0::ms, 50::ms, .01, 10::ms );

// --bass
SqrOsc saw => ADSR bass => LPF filterBass => dac;
0.15 => saw.gain;  800 => filterBass.freq;
bass.set( 0::ms, 80::ms, saw.gain()/1.5, 100::ms );
// --Melody
BlitSaw melodyImpulse => ADSR melody => NRev mReverb => dac;
0.09 => melodyImpulse.gain;
melody.set( 0::ms, 80::ms, melodyImpulse.gain()/1.5, 100::ms );
0.03 => mReverb.mix;

PulseOsc pulse => ADSR pulseADSR => NRev pulseRev => dac;
0.02 => pulse.gain;
pulseADSR.set( 0::ms, 80::ms, pulse.gain()/1.5, 100::ms );
0.02 => pulseRev.mix;

PulseOsc pulse2 => ADSR pulseADSR2 => NRev pulseRev2 => dac;
0.03 => pulse2.gain;
pulseADSR2.set( 0::ms, 80::ms, pulse2.gain()/2.5, 200::ms );
0.19 => pulseRev2.mix;
Math.random2f(0.1, 0.99)=> pulse2.width;





/*
---------- Floor---------------
TODO: debe permitir cambiar de estados globales según tres estados
expo, buildUp, y drop
*/

// función generar probabilidades según corpus
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
[100,  0,  0,  0,100,  0,  10,  0,100,  0,  0,  0,100,  0,  0, 20] @=> int chanceBd[]; 
[  0,  0,  0,  0, 00,  0, 100,  0,  0,  0,  0,  0, 00,  0,100,  0] @=> int chanceSd[];
[  0,  0,100,  0, 00,  0, 100,  0,  0,  0,100,  0,  0,   0,100, 20] @=> int chanceT1[];
[ 100, 0,100,100,100,  0, 100,100, 90,  0,100,100, 80,  0,100, 30] @=> int chanceHh[];

// curva de dinámica fija
[1.0,1.0,0.4,0.8,1.0,1.0,0.4,0.8,1.0,0.7,0.4,0.8,1.0,1.0,0.4,0.8] @=> float dynamicsFixed[];



// función que usa probabilidades para activar los instrumentos
fun void playDrums()
{
  0 => int i;
  while(true)
  {
    hhGain * dynamicsFixed[i] => hhImpulse.gain; // comente y descomente esta línea para escuchar la diferencia
    floatChance( chanceBd[i], 1,0 ) => float bdSwitch;
    floatChance( chanceSd[i], 1,0 ) => float sdSwitch;
    floatChance( chanceT1[i], 1,0 ) => float t1Switch;
    floatChance( chanceHh[i], 1,0 ) => float hhSwitch;
    bd.keyOff();
    sd.keyOff();
    hh.keyOff();
    if( bdSwitch == 1 ){ bd.keyOn(); 1.0 => bdImpulse.next;  }
    if( sdSwitch == 1 ){ sd.keyOn(); }
    if( t1Switch == 1 ){ t1.setBaseFreq(80 + i*2); t1.hit(.1 + i * .1); }
    if( hhSwitch == 1 ){ hh.keyOn(); }
    beat => now;
    i++;
  }
}

fun void four(){
    while(true){
        bd.keyOn();  1.0 =>   bdImpulse.next;
        beat * 4 => now;
    }
}


// ========== BASS ===========================
[ 0,  0, 0, 90, 100,  80, 100, 0, 100,  5, 0 ,  3, 0,  0, 10,  10] @=> int chanceBass[];
[ 0,  0,  0, 0,  0,  3,  12,  3,  12,   0, 10, 12, 3,  0,  7, 0] @=> int chanceBassNotes[];
fun void playBass()
{
  0 => int i;
  while(true)
    {
      floatChance( chanceBass[i], 1,0 )   => float bassSwitch;
      chanceBassNotes[Math.random2(0, 15)] => float bassNote;
      bass.keyOff();
      if( bassSwitch == 1 ){ Std.mtof( bassNote + root ) => saw.freq; bass.keyOn();  }
      beat => now;
      i++;
    }
}

fun void playBassDrop()
{
    while(true)
    {
        bass.keyOff();
        Std.mtof( root ) => saw.freq; bass.keyOn(); 
        beat * 2 => now;
        bass.keyOff();
        beat * 2 => now;

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
        Std.mtof(root + 12 + currentState) => melodyImpulse.freq;
        Std.mtof(root + 24 - (2*currentState)) => pulse.freq;
        melody.keyOn();
        pulseADSR.keyOn();
        beat => now;
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
        floatChance( chanceM2[Inmutable.mod16], 1,0 )   => float M2Switch;
        // recorre la cantidad de estados posibles
        for( 0 => int i; i < posibleStates.cap(); i++)
        {
            if( currentState == posibleStates[i] )
            {
                lib.insertChance(50, testPercent, 0.0) @=> testPercent;
                //lib.insertChance(30, testPercent, 12.0) @=> testPercent;
                lib.insertChance(20, testPercent, 3.0) @=> testPercent;
                lib.insertChance(10, testPercent, 7.0) @=> testPercent;
                Std.mtof(root + 24 + testPercent[Math.random2(0, 99)]) => pulse2.freq;
                if( M2Switch == 1 ){ pulseADSR2.keyOn();  }
                beat => now;
             }
        }
    }
}

fun void rollCounter(){
    while(true){
        Inmutable.counter + 1 @=> Inmutable.counter;
        <<< Inmutable.counter, Inmutable.mod256 >>>;
        Inmutable.counter % 16 @=> Inmutable.mod16;
        Inmutable.counter % 32 @=> Inmutable.mod32;
        Inmutable.counter % 64 @=> Inmutable.mod64;
        Inmutable.counter % 256 @=> Inmutable.mod256;
        beat => now;
    }
}

fun void variations(){
while(true){
    if(Inmutable.mod16 > 12){
        lib.insertRandomInt(14, chanceSd, 30, 70) @=>  chanceSd;
        }
    if(Inmutable.mod32 > 24){
        lib.insertRandomInt(12, chanceSd, 0, 80) @=>  chanceSd;
        lib.insertRandomInt(12, chanceBd, 0, 60) @=>  chanceBd;
    }
    if(Inmutable.mod64 > 42){
        lib.insertRandomInt(8, chanceSd, 80, 70) @=>  chanceSd;
        lib.insertRandomInt(4, chanceBd, 0, 99) @=>  chanceBd;
        lib.insertRandomInt(4, chanceT1, 0, 90) @=>  chanceT1;
        lib.insertRandomInt(4, chanceHh, 0, 99) @=>  chanceHh;
    } 

    beat => now; 
}
// ==== cambios al final del array

//lib.print(chanceSd);

}

//==== SECTIONS ( Breaks and Samples in InmutableLiveCode)=======
4 => int scale;
16 * scale => int section;
[0, 1, 2, 3, 4, 5, 6, 7] @=> int structureMultiplicators[];
int iIntro; int oIntro; int iBreakDown1; int oBreakDown1; int iBuildUp1; int oBuildUp1; int iDropA; int oDropB;
[ iIntro,  oIntro,  iBreakDown1,  oBreakDown1,  iBuildUp1,  oBuildUp1,  iDropA,  oDropB] @=> int structureParts[];

for (int i; i < structureMultiplicators.cap(); i++){
    structureParts[i] + (section * structureMultiplicators[i]) @=> structureParts[i];
}
lib.print(structureParts);


// ----- INTRO  VOY aca
if(Inmutable.mod256 >= iIntro && Inmutable.mod256 < oIntro){
    spork~ playDrums() @=> Shred  offspring;
    <<< offspring>>>;
    spork~ playBass();
}
// ---- BREAKDOWN 1

// --- BuildUp 
if(Inmutable.mod256 >= 32 && Inmutable.mod256 < 128){
    spork~ playMarkov();
}

// DROP A 
if(Inmutable.mod256 >= 132 && Inmutable.mod256 < 196){
    spork~ playMarkov2(); // not markov yet
    spork~ four();
    spork~ playBassDrop();
}

// BREAKDOWN 2
if(Inmutable.mod256 >= 196){
    spork~ playMarkov2(); // not markov yet
    spork~ playDrums();
    spork~ playBassDrop();
}

// --- BUILDUP

// --- DROP B

// --- OUTRO

spork~ rollCounter();
spork~ variations();

// mantiene vivos los sporks
beat * 16 => now;
// antes de morir se crea a sí mismo
Machine.add(me.dir()+"liveCode.ck"); 







