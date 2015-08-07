// Crea arreglo para guardar audio
SndBuf audioSource;
SndBuf audioFiltered;

// Preparo archivo para guardar
FileIO corpusTxt;

// creo un espacio para que la consola no me ponga la palabra "string"
" "=> string space;
//<<< me.arg(1) >>>;

//"/Deep_Tech_House_Attack_Magazine_Beat_Dissected_Deep_Tech_House_Step_1.mp3.wav" => string path;
me.arg(0) => string path;

 // carga la fuente de audio
    me.dir() + "/"+ path  => audioSource.read;

// divide la duración de la fuente en 16 partes
audioSource.samples() => int steps;
// define tamaño de un step
steps/16 => int step;

// Crea y configura filtro
// ! acá debería mejor usar un pasabanda .. luego ..
BPF bpFilter;


// recorre el audio filtrando (ej: abajo de 80hz para extraer
// la presencia de un bombo o percusión baja)
// partes del ejemplo follower.ck de Perry Cook
audioSource => bpFilter => FFT fft =^ RMS rms => blackhole;
bpFilter => dac;
[80.0, 2000.0, 10000.0] @=> float bands[];
[1.2, 1.5, 1.9] @=> float gains[];

// inicializo el iterador
0 => int i;

// abre el archivo destino
corpusTxt.open(me.dir() + "/tempCorpus.txt", FileIO.WRITE);

for(0 => int ii; ii < bands.cap(); ii++)
{



    bpFilter.set(bands[ii], 1.0);
    bpFilter.gain(gains[ii]);
    <<< bands[ii] >>>;
    for(0 => int i; i < 16; i++)
    {
        // set parameters
        1024 => fft.size;
        // set hann window
        Windowing.hann(1024) => fft.window;
        // upchuck: take fft then rms
        rms.upchuck() @=> UAnaBlob blob;

        // ajuste la sensibilidad del valor comparado para tener resultados
        // más precisos o diferentes
        if( blob.fval(0) > 0.00005 )
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
    }
    me.dir() + "/"+ path  => audioSource.read;
}
corpusTxt.close();
