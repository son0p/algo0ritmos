
// Usamos un ruido para la transiente
Noise n => ADSR transient => BPF sp  => dac;

// Configuramos la Envolvente,
// altere el segundo valor para variar
// la duración de la transiente
transient.set(0.001,0.05,0.0,0.1);

0.3 => n.gain;

// Usamos una onda sinosoidal para el tono 
SinOsc s => ADSR boom => dac;
boom.set(0.001,0.1,0.0,0.1);
60 => s.freq;
0.7 => s.gain;

while( true )
{
	// filtramos de manera aleatoria la frecuencia
	// del transiente
	Math.random2f(200, 5000) => float varFreq;
	sp.set(varFreq, 1);
	transient.keyOn();
	boom.keyOn();
	1000::ms => now;
	transient.keyOff();
	boom.keyOff();
}
