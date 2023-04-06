public class Inmutable
{
    int inmutableArray[16];
    int inmutableEnvNotes[16];
    int inmutableBass[16];
    static float bassFromOsc[];
    static float bassFromOscComp[];
    int inmutableEnvBass[16];
    int inmutableBD[16];
    int inmutableSN[16];
    int inmutableHTOM[16];
    int inmutableHH[16];
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
[-1.0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  -1]  @=> Global.bassFromOsc;
[-1.0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  -1]  @=> Global.bassFromOscComp;
//[0.] @=> Global.bassFromOsc;
200::ms => Global.beat; // initializacion in the class is not working .. bug?
