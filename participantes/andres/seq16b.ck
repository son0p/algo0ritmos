int pasos[16];
[0, 4, 8, 12] @=> int onSet[];// posiciones donde suena 
for( 0 => int i; i < onSet.cap(); i++ )
{ 
  1 => pasos[onSet[i]]; // solo se llenan los 1, pues el array se inicializa lleno de ceros
}
// test
for( 0 => int i; i < 16; i++){ <<< pasos[i]>>>; } // resultado [1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0]