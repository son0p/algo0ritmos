// Crea arreglo para guardar audio
SndBuf audioSource;
SndBuf audioFiltered;

" "=> string space;

// carga la fuente de audio
me.dir() + "/audio/loopCumbia0001.wav" => audioSource.read;
// divide la duración del loop en 16 partes
audioSource.samples() => int steps;
// define tamaño de un step
steps/16 => int step;

// Crea y configura filtro
LPF lpFilter;
lpFilter.set(80.0, 1.0);

// recorre el audio filtrando abajo de 80hz
// partes del ejemplo follower.ck de Perry Cook
audioSource => lpFilter => Gain g => OnePole p => blackhole;
// square the input
//adc => g;
audioSource =>g;

// multiply
3 => g.op;

// set pole position
0.99 => p.pole;

0 => int i;



while(i < 16)
{
    // ajuste la sensibilidad del valor >
    if( p.last() > 0.01 )
    {
        <<< "1", space >>>;
        step::samp => now;
    }
    else
    {
        <<< "0", space >>>;
        step::samp => now;
    }
    i++;

}
