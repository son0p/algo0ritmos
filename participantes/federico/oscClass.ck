public class OscCom
{
    Library lib;
    Inmutable inmutable;
    OscIn oin;
    OscMsg msg;
    6448 => oin.port;
    OscIn oin2;
    OscMsg msg2;
    6447 => oin2.port;
    // create our OSC receiver
    OscRecv recv;
    // use port 6449
    6449 => recv.port;
    // start listening (launch thread)
    recv.listen();

    // addreses ====================
    // create an address in the receiver, store in new variable
    oin.addAddress( "/audio/1/foo, ffffffffffffffff" );
    oin2.addAddress( "/audio/1/bar, ffffffffffffffff" );
    recv.event( "/audio/1/int, i" )      @=> OscEvent oi;
    recv.event( "/audio/1/envNotes, i" ) @=> OscEvent oscEnvNotes;
    recv.event( "/audio/1/float, f" )    @=> OscEvent of;
    recv.event( "/audio/2/bass, i" )     @=> OscEvent oscBass;
    recv.event( "/audio/2/envBass, i" )  @=> OscEvent oscEnvBass;
    recv.event( "/audio/2/bd, i" )       @=> OscEvent oscBD;
    recv.event( "/audio/2/sn, i" )       @=> OscEvent oscSN;
    recv.event( "/audio/2/hh, i" )       @=> OscEvent oscHH;

    // containers ====================
    float rec[0];
    int intNotes[16];
    int envNotes[16];
    int  intBass[16];
    int  envBass[16];
    int    intBD[16];
    int    intSN[16];
    int    intHH[16];
    inmutable.inmutableArray    @=> intNotes;
    inmutable.inmutableEnvNotes @=> envNotes;
    inmutable.inmutableBass     @=> intBass;
    inmutable.inmutableEnvBass  @=> envBass;
    inmutable.inmutableBD       @=> intBD;
    inmutable.inmutableSN       @=> intSN;
    inmutable.inmutableHH       @=> intHH;
    float floatNotes[16];

    // functions ====================
    fun  void oscRxFloat()
    {
        int i;
        while ( true ){
            // wait for event to arrive
            of => now;
            while ( of.nextMsg() != 0 ){
                of.getFloat() => floatNotes[i%16];
                i++;
            }
        }
    }

    fun void oscRxInt()
    {
        int j;
        while ( true ){
            oi => now;
            while ( oi.nextMsg() != 0 ){
                oi.getInt() =>  inmutable.inmutableArray[j%16];
                j++;
            }
        }
    }

    fun void oscRxEnvNotes()
    {
        int i;
        while ( true )
        {
            oscEnvNotes => now;
            while ( oscEnvNotes.nextMsg() != 0 )
            {
                oscEnvNotes.getInt() =>  inmutable.inmutableEnvNotes[i%16];
                i++;
            }
        }
    }

    fun void oscRxBass()
    {
        int j;
        while ( true )
        {
            oscBass => now;
            while ( oscBass.nextMsg() != 0 )
            {
                oscBass.getInt() =>  inmutable.inmutableBass[j%16];
                j++;
            }
        }
    }

    fun void oscRxEnvBass()
    {
        int i;
        while ( true )
        {
            oscEnvBass => now;
            while ( oscEnvBass.nextMsg() != 0 )
            {
                oscEnvBass.getInt() =>  inmutable.inmutableEnvBass[i%16];
                i++;
            }
        }
    }

    fun void oscRxBD()
    {
        int i;
        while(true)
        {
            oscBD => now;
            while( oscBD.nextMsg() != 0 )
            {
                oscBD.getInt() => inmutable.inmutableBD[i%16];
                i++;
            }
        }
    }

    fun void oscRxSN()
    {
        int i;
        while(true){
            oscSN => now;
            while( oscSN.nextMsg() != 0 )
            {
                oscSN.getInt() => inmutable.inmutableSN[i%16];
                i++;
            }
        }
    }

    fun void oscRxHH()
    {
        int i;
        while(true)
        {
            oscHH => now;
            while( oscHH.nextMsg() != 0 )
            {
                oscHH.getInt() => inmutable.inmutableHH[i%16];
                i++;
            }
        }
    }

    fun void print(){
        lib.print(rec);
    }

    fun void oscRxFloat()
    {
        while(true)
        {
            oin => now;
            while (oin.recv(msg)){
                for(0 => int i; i < 16; i++){
                    msg.getFloat(i) => Global.bassFromOsc[i];
                }
            }
        }
    }

    fun void oscRxFloat2()
    {
        while(true)
        {
            oin2 => now;
            while (oin2.recv(msg2))
            {
                for(0 => int i; i < 16; i++){
                    msg2.getFloat(i) => Global.bassFromOscComp[i];
                }
            }
        }
    }
}

OscCom oc;

spork~ oc.oscRxFloat();
spork~ oc.oscRxFloat2();
while(true){10::ms => now;}
