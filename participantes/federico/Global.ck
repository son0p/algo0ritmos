public class Global
{
    int inmutableArray[16];
    int inmutableEnvNotes[16];
    static float inmutableLEAD[];
    static int midiLEAD[];
    static int midiMID[];
    static int midiBASS[];
    static float inmutableMID[];
    static float inmutableBASS[];
    static int inmutableBD[];
    static int inmutableSD[];
    static int inmutableHTOM[];
    static int inmutableHH[];
    static int inmutableGAIN[];
    static float bassFromOsc[];
    static float bassFromOscComp[];
    int inmutableEnvBass[16];
    float container[100];
    static int counter;
    static int mod4;
    static int mod16;
    static int mod32;
    static int mod64;
    static int mod256;
    200::ms => static dur beat; // if called without local assignation value is 0
    static int root;
    static int cursor;
}
//init the array with something, else it would just stay an empty reference.
[0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  @=> Global.bassFromOsc;
[0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  @=> Global.bassFromOscComp;
[0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  @=> Global.inmutableLEAD;
[0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  @=> Global.inmutableMID;
[0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  @=> Global.inmutableBASS;
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]    @=> Global.midiLEAD;
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]    @=> Global.midiMID;
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]    @=> Global.midiBASS;
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]    @=> Global.inmutableBD;
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]    @=> Global.inmutableSD;
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]    @=> Global.inmutableHTOM;
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]    @=> Global.inmutableHH;
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]    @=> Global.inmutableGAIN;
//[0.] @=> Global.bassFromOsc;
200::ms => Global.beat;
