public class Generator
{
  // Generador de aleatoriedad entre cero y un valor
  fun int percentChance( int percent, int value )
  {
    // Se crea un array de 100 valores, por defecto chuck lo crea con ceros
    int percentArray[100];
    // Inserto el valor que viene en el  argumento tantas veces como me
    // indique el porcentaje, que también es dado por el argumento.
    for( 0 => int i; i < percent; i++)
    {
      value => percentArray[i];
    }
    // Selecciono un valor aleatorio del array que ya esta conformado
    // según el porcentaje
    percentArray[Math.random2( 0, percentArray.cap()-1 )] => int selected;
    return selected;
  }
}
// //-------------------------------------
// // Test

// // Descomenta este código para probar esta clase

// Generator myGenerator;
// while( true )
// {
// 	// el primero argumento es el porcentaje,
// 	// segundo el valor que queremos que retorne
// 	// según ese porcentaje.
// 	myGenerator.percentChance(90,5) => int selected;
// 	<<< selected >>>;
// 	100::ms => now;
// }
