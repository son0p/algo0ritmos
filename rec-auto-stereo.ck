// Usalo poniendolo al final de la cadena de los archivos que usas
// ejemplo> chuck miArchivo.ck rec-auto-stereo.ck

// saca muestras de la salida dac 
// las pasa por WvOut2 para grabarlas en stereo
dac => WvOut2 w => blackhole;

// ajusta el prefijo que se pone al inicio del nombre del archivo
// do this if you want the file to appear automatically
// in another directory.  if this isn't set, the file
// should appear in the directory you run chuck from
// with only the date and time.
"chuck-session" => w.autoPrefix;

// Aquí ajustas el nombre del archivo
"special:auto" => w.wavFilename;

// Lo muestras en la terminal
<<<"writing to file: ", w.filename()>>>;

// Ganancia de la salida.
.5 => w.fileGain;

// Arreglo temporal para matar el spork
null @=> w;

// Cilco infinito de tiempo
// ctrl-c interrumpe el proceso, 
// o podría aca poner una duración determinada
while( true ) 1::second => now;
