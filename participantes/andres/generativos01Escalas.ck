// Oscilador
SinOsc sin => Envelope env => dac;
0.3 => sin.gain;

// Escalas
[0,2,1,2,2,1,2,2] @=> int min[]; // menor
[0,2,2,1,2,2,2,1] @=> int maj[]; // mayor

// Raiz es la nota inicial de la escala
// 60 = Do, crea la nota inicial

60 => int root;

// Generación de las escalas
fun void scaleGenerator(int scale[])
{
  for( 0 => int i; i < scale.cap(); i++ )
  {
    root + scale[i] =>  root;
    Std.mtof(root) => float note;
    note => sin.freq;
    env.keyOn();
    300::ms => now;
    env.keyOff();
   }
}

// test
spork~ scaleGenerator(maj);

while(true){10::ms => now;}



