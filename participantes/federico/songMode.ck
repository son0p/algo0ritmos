// === SAMPLES ===
// sound file
//"/home/ffx1/Music/sounds/fx/366886__megablasterrecordings__reverse-door-slam.wav" => string reverse;
//if( me.args() ) me.arg(0) => reverse;
SndBuf rev => dac;
"/home/ffx1/Music/sounds/fx/366886__megablasterrecordings__reverse-door-slam.wav" => rev.read;
0 => rev.rate;
.4 => rev.gain;

fun void playRev(){
    1 => rev.rate;
    rev.length() => now;
    0 => rev.rate;
}
while(true){
    if(Global.mod256 == 146){
        spork~ playRev();
    }
    Global.beat => now;
}


spork~ playRev();


while(true) .5::second => now;
