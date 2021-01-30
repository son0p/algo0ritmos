public class OscCom
{
   // Global glo;
    Library lib;
    OscIn oin;
    OscMsg msg;
    6448 => oin.port;
    OscIn oin2;
    OscMsg msg2;
    6447 => oin2.port;


// create an address in the receiver, store in new variable
    oin.addAddress( "/ffxf/step1, ffffffffffffffff" );
    oin2.addAddress( "/ffxf/step1comp, ffffffffffffffff" );

// containers
    float rec[0];

    fun void print(){
        lib.print(rec);
    }

    fun void oscRxFloat(){
        while(true){
            // wait for event to arrive
            oin => now;
            while (oin.recv(msg)){
                for(0 => int i; i < 16; i++){
                    msg.getFloat(i) => Global.bassFromOsc[i];
                }
            }
        }
    }

    fun void oscRxFloat2(){
        while(true){
            // wait for event to arrive
            oin2 => now;
            while (oin2.recv(msg2)){
                for(0 => int i; i < 16; i++){
                    msg2.getFloat(i) => Global.bassFromOscComp[i];
                }
            }
        }
    }

    fun void callR(){
        while(true){
            Std.system("Rscript corpus.R & > out.log 2> /dev/null");
            // <<< "called R" >>>;
            Global.beat * 16 => now;
        }
    }
}

OscCom oc;

spork~ oc.callR();
spork~ oc.oscRxFloat();
spork~ oc.oscRxFloat2();
while(true){10::ms => now;}
