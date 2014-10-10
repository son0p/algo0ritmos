// definimos el tempo y lo asignamos a la duración bit
500::ms => dur beat;

// Instanciamos un Impulso en un objeto llamado tick
// y lo pasamos por un filtro y una reverberación.
Impulse tick => TwoPole kp => JCRev r => dac;
50.0 => kp.freq; 0.80 => kp.radius; 1 => kp.gain;
0.01 => r.mix;

// Iniciamos un valor i para hacer iteraciones.
0 => int i;

fun void ti()
{
	while( true )
	{
		// Modulamos i para que haga cilcos de 80
		i%80 => int ramp;
		// Generamos un tick
		1.0 => tick.next;
		// Multiplicamos el valor de i modulado por 1.0
		// para volverlo flotante, luego lo dividimos
		// por 100 para tener un valor menor que 1
		(ramp * 1.0)/100 => r.mix;
		// Avanzamos el tiempo 1 beat
		beat => now;
		<<< "Mezcla de Reverberación = "+(ramp * 1.0)/100 >>>;
		i++;
	}
}

// Llamamos la función 
spork~ ti();

// Loop infinito para mantener viva la función
while(true) beat*8 => now;
