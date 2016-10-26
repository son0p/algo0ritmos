// define tempo
120::ms => dur beat;

// Probabilidad de un corpus
[99, 0, 0, 0,90, 0, 50, 0, 90, 0, 0, 0,90, 0, 0, 0] @=> int chanceBd[]; // probabilidad Bombo
[ 0, 0, 0, 0,90, 0, 0, 0,  0, 0, 0, 0,90, 0, 0, 0] @=> int chanceSn[];
[ 0, 0,90, 0, 0, 0, 0, 0, 90, 0, 0, 0, 0, 90, 0, 0] @=> int chanceHh[];

fun void playDrums()
{
  0 => int i;
  while(true)
  {
    <<< chanceBd[i]>>>;
    beat => now;
    i++;
  }
}

// llama funciones
spork~ playDrums();

// vive un tiempo
beat*16 => now;
// antes de morir  se crea  a sí mismo
Machine.add(me.dir() + "/gen_agitation_001.ck");
