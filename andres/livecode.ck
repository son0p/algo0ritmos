Synth fm;
Arraylibrary O;
Drums dr;
    SinOsc carrier;
    SawOsc modulator;
    fm.ratio(1,2);
    spork~dr.recorrer();
    spork~fm.connectionfm(carrier, modulator);
    spork~fm.lectormidi(bassline1, 120.0, carrier, modulator ,1500.0 ,4.0);
    
    1::day => now;
    