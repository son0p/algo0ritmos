// Módulos de sonido
SinOsc modulator;
SinOsc carrier;
// para lograr la modulación FM en chuck se debe poner
// el oscilador del carrier con sync en 2
2 => carrier.sync;

// Cadena de sonido
modulator => carrier => dac;

// Puede cambiar este valor para escuchar diferencias en el timbre
1000 => modulator.gain;

// Inicializamos la frecuencia del modulador
440 => modulator.freq;
// Establecemos una relación entre la frecuencia del modulador con la del carrier,
// ensaye relaciones 0.38, 0.5, 1.0, 2.0, 4.0, 1.33333, 0.33333, 0.2857
0.5 => float ratio;

// Aplicamos la relación entre la frecuencia del modulador y el carrier
modulator.freq() * ratio => carrier.freq;

// Hacemos que transcurra en el tiempo
1::day => now;
