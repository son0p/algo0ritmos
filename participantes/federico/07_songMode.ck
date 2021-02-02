// === SAMPLES ===

3 => int C;

SndBuf s[C];
JCRev r[C];
Gain g[C];

"/home/ffx1/Music/sounds/fx/165154__rhythmpeople__rpeople-revcrash2.wav" => s[0].read;
"/home/ffx1/Music/sounds/fx/257838__lostphosphene__white-noise-sweep-up.wav" => s[1].read;
"/home/ffx1/Music/sounds/fx/366886__megablasterrecordings__reverse-door-slam.wav" => s[2].read;

[170, 115, 157] @=> int startPoint[]; // wav positions on song, to be fixed if tempo change
[0,1,2] @=> int options[];  // wav array options

fun void wavs(){
    for( 0 => int i; i < C; i++ ){
        s[i]  => r[i] => g[i] => dac;
        r[i].mix(0.05);
        g[i].gain(0.2);
        s[i].samples() => s[i].pos; // playhead position to the end to be silent on initialization
    }
}
//// === FUNCTIONS ===
fun void playOneSample(SndBuf sample){
    <<< "here! ">>>;
    0 => sample.pos;
    1 => sample.rate;
    sample.length() => now;
}

fun void selectWav(){
    0 => int selected;
    while(true){
        //// Select sample number and startPoint number
        if(Global.mod256 == 5){
            Math.random2(0, options.cap()-1) => selected;
            <<< "selected:", selected>>>;
        }
        //// Play at selected startPoint
        if(Global.mod256 == startPoint[selected]){
            spork~ playOneSample(s[selected]);
        }
        Global.beat => now;
    }
}

//// === RUN ===
spork~ wavs();
spork~ selectWav();
while(true) .5::second => now;
