// Crea arreglo para guardar audio
SndBuf audioSource;
SndBuf audioFiltered;

// Preparo archivo para guardar
FileIO corpusTxt;

// creo un espacio para que la consola no me ponga la palabra "string"
" "=> string space;

// carga la fuente de audio
me.dir() + "/audio/loopCumbia0001.wav" => audioSource.read;
// divide la duración de la fuente en 16 partes
audioSource.samples() => int steps;
// define tamaño de un step
steps/16 => int step;

// Crea y configura filtro
// ! acá debería mejor usar un pasabanda .. luego ..
BPF bpFilter;
bpFilter.set(80.0, 5.0);

// recorre el audio filtrando (ej: abajo de 80hz para extraer
// la presencia de un bombo o percusión baja)
// partes del ejemplo follower.ck de Perry Cook
audioSource => bpFilter => FFT fft =^ RMS rms => blackhole;

// set parameters
1024 => fft.size;
// set hann window
Windowing.hann(1024) => fft.window;


// inicializo el iterador
0 => int i;

corpusTxt.open(me.dir() + "/corpus.txt", FileIO.WRITE);
while(i < 16)
{
    // upchuck: take fft then rms
    rms.upchuck() @=> UAnaBlob blob;

    // ajuste la sensibilidad del valor comparado para tener resultados
    // más precisos o diferentes
    if( blob.fval(0) > 0.0005 )
    {
       // <<< "1", space, blob.fval(0)  >>>;
        corpusTxt.write(1);
        step::samp => now;

    }
    else
    {
        //<<< "0", space >>>;
        corpusTxt.write(0);
        step::samp => now;
    }
    i++;
}
corpusTxt.close();
