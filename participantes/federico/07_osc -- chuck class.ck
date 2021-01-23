public class OscCom
{
   // Global glo;
    Library lib;
    OscIn oin;
    OscMsg msg;
    6448 => oin.port;

// create an address in the receiver, store in new variable
    oin.addAddress( "/ffxf/step1, ffffffffffffffff" );

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
while(true){10::ms => now;}
