int pasos[16];
[0, 4, 8, 12] @=> int onSet[];
for( 0 => int i; i < onSet.cap(); i++ )
{ 
  1 => pasos[onSet[i]];
}
for( 0 => int i; i < 16; i++){ <<< pasos[i]>>>; } // imprima el array pasos