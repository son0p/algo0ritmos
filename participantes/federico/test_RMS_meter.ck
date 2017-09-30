// ruta del archivo
me.sourceDir() + "trigo_launch_Selection.wav" => string filename;
// conecta el buffer a la salida de audio
SndBuf buf => dac ;
// lee el archivo
filename => buf.read;

function void track1(){
  while( true )
  {
    // suena unos milisegundos en diferentes puntos de inicio
    Math.random2(0, buf.samples()) => buf.pos;
    400::ms => now;
  }
}

function void meter(SndBuf target){
// entra el buffer para ser analizado 
  target => FFT fft =^ RMS rms => blackhole;

// tamaño de la lectura en samples
  1024 => fft.size;
// ventana
  Windowing.hann(1024) => fft.window;

// control loop
  while( true )
  {
    // upchuck: take fft then rms
    rms.upchuck() @=> UAnaBlob blob;
    // muestra el RMS
    <<< target+":"+ blob.fval(0) >>>;
    // advance time
    fft.size()::samp => now;
  }
}
spork~ track1();
spork~ meter(buf);
while(true){10::ms => now;}
