Library lib;

130::ms => dur beat;
16 => int cicleSize;
0 => int counter;
1000.0 => float root; // frecuency center

//  // --------  generación de escalas
//[root/16,root/8, root/2, root/4, root, root*4, root*2, root*1.189207115, root*1.3348398542, root*1.4983070769, root*1.7817974363, root*1.6817928305] @=> float ref[];
float scale1[400];
float scale2[400];
float scale3[400];
// [2,1,4,1,4] @=> int aeolianPent[];
// scaleGenerator(65.406391, aeolianPent);

lib.semitonesGen(25,110) @=> float notes1[]; 
lib.semitonesGen(220,2200) @=> float notes2[]; 
lib.semitonesGen(440,4400) @=> float notes3[];

[0,3,5,7,10] @=> int minorPenta[];
lib.scaleGenerator(notes1,minorPenta) @=> scale1;
lib.scaleGenerator(notes2,minorPenta) @=> scale2;
lib.scaleGenerator(notes3,minorPenta) @=> scale3;



fun void playDrum(string name, ADSR instrument)
{
  FileIO fio;
  // open a file
  me.dir()+ name;
  fio.open(name, FileIO.READ);
  // ensure it's ok
  if(!fio.good()) {
      cherr <= "can't open file: " <= name <= " for reading..." <= IO.newline();
      me.exit();
  }
  while(true)
  {
    Std.atoi(fio.readLine()) => int value; 
    if( value != 0 && instrument == lib.bd )
    {
      lib.playDrums(instrument, lib.bdImpulse);
    }
    if(value != 0)
    {
      lib.playDrums(instrument);
      lib.run(beat);
    }
    else
    {
      lib.run(beat); 
    }
  }
}

fun void playFreq(string name, SinOsc u)
{
    FileIO fio;
    // open a file
    me.dir()+ name;
    fio.open(name, FileIO.READ);
    // ensure it's ok
    if(!fio.good()) {
        cherr <= "can't open file: " <= name <= " for reading..." <= IO.newline();
        me.exit();
    }
    while(true)
    {
        Std.atoi(fio.readLine()) => int value; 
        if(value > 20)
        {
            value => u.freq;
            lib.run(beat);
        }
        else
        {
            lib.run(beat); 
        }
    }
}

// ======== mixer ===========
lib.sd.gain      (0.50);
lib.hh.gain       (0.2);
lib.sqr0.gain    (0.02);
lib.sin0.gain    (0.1);
lib.blit0.gain   (0.05);
lib.tri0.gain    (0.20);

lib.sqr0env.set     ( 0::ms, 100::ms, .0, 1000::ms);
lib.sin0env.set       ( 0::ms, 80::ms, 0.0, 10::ms);
lib.blit0env.set      ( 0::ms, 60::ms, 0.0, 10::ms);
lib.tri0env.set       ( 0::ms, 80::ms, 0.0, 10::ms);

lib.blit0rev.mix  (0.00);

lib.sqr0.freq    (3520); 
lib.sin0.freq     (220);
lib.blit0.freq     (880);
lib.tri0.freq     (55);

// ========= tracks =================

spork~ playDrum("d1.txt",lib.bd);
spork~ playDrum("d2.txt",lib.sd);
spork~ playDrum("d3.txt",lib.hh);
//spork~ playDrum("d0.txt", lib.sqr0env);
spork~ playDrum("l2.txt", lib.sin0env);
spork~ playFreq("freqL2.txt", lib.sin0);
//spork~ playDrum("l1.txt", lib.tri0env);
//spork~ playDrum("l3.txt", lib.blit0env);



// === live, die, and reborn ===
beat*cicleSize => now;
Machine.add(me.dir()+"/liveDany");


