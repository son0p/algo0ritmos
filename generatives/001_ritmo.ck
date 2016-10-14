// probabilidad de un corpus
[99, 0, 0, 0,90, 0, 0, 0, 90, 0, 0, 0,90, 0, 0, 0] @=> int chanceBd[]; // probabilidad Bombo
[ 0, 0, 0, 0,90, 0, 0, 0,  0, 0, 0, 0,90, 0, 0, 0] @=> int chanceSn[];
[ 0, 0,90, 0, 0, 0, 0, 0, 90, 0, 0, 0, 0, 90, 0, 0] @=> int chanceHh[];

// lee la probabilidad
120::ms => dur  tempo;

for(int i; i < 16; i++)
  {
    <<< chanceBd[i]>>>;
    tempo => now;
    
  }

// antes de desaparecer se instancia a sí mismo
Machine.add(me.dir() + "/001_ritmo.ck");
