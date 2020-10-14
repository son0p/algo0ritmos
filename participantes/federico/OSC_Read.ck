// QuickOSC class version 0.1 (c) Casper Schipper 2011
public class OSC_Read {
    int port;
    OscRecv oscrecv;
    // the static (assosiative) array is the place you finally pick up the values when you need them.
    static float values[];
    
    // Set OSC listening port
    fun void setPort(int aport) {
        aport => port;
        oscrecv.port(aport);
        oscrecv.listen();
    }
    
    // idem with defealt
    fun void setPort() {
        7400 => oscrecv.port => port;
        oscrecv.listen();
    }
    
    // make a shred that follows parameter
    // parName can be anything you like.
    // address should be the osc address for example:
    // "/1/fader1, f" gets you the first fader as a float on TouchOSC 
    fun void makePar(string parName,string address) {
        if (port == 0)
            setPort();
        spork ~OSC_ReadShred(address,parName);
    }
    
    // The OSC listening shread
    fun void OSC_ReadShred(string address,string parName) {
        // create OscEvent
        address => oscrecv.event @=> OscEvent oe;
        while (true) {
            // wait for osc...
            oe => now;
             if (oe.nextMsg() != 0) {
                // store value in array
                oe.getFloat() => values[parName] => float print;
                <<<"get OSC, thanks", print>>>;
            }
        }
    }
    
    // Use this function to automatically scale the values.
    fun void makeScaledPar(string parName,string address,float low,float high) {
        if (port == 0)
            setPort();
        spork ~OSC_ReadShredScaled(address,parName,low,high);
    }
    
    // a seperate function for the scaled values...
    fun void OSC_ReadShredScaled(string address,string parName,float low,float high) {
        Std.fabs(high-low) => float range;
        Math.min(low,high) => float offset;
        // creation of OscEvent
        address => oscrecv.event @=> OscEvent oe;
        while (true) {
            // wait for osc...
            oe => now;
            if (oe.nextMsg() != 0) {
                // store in array
                (oe.getFloat()*range) + offset => values[parName];
            }
        }
    }        
}

// okay chuck wants me to init the array with something, else it would just stay an empty reference.
// for some reason this can't be done from within a public class.
[0.] @=> OSC_Read.values;


    
            
        
    
    
