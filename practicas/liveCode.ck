BPM.sync(120.00) => BPM.tempo => dur beat;
16 => BPM.steps; // no anda
Generator generator;
PlayerDrums dr;
PlayerMelodies melodier;
PlayerBass bassist;
MelodyGenerator ml;
Player play;
ProgressionGenerator prog;
Synth synth;
CollectionBeats beats;
CollectionMelodies melodies;
CollectionBasses basses;

50 =>  BPM.root;
[
[
[1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0],
[0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0],
[1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1]
]
]@=>  int liveBeat[][][];

[
[
[24.0, 15.0,  12, 10, 12, 0, 7, 9, 10 ],
[0.50, .50, .50, .50, .50, 1, 1, .25, .25 ],
[0.0,  1,    2,   3,   4 , 10, 18, 22, 24]
]
]@=> float liveMel[][][];

[
[
[0.0,  -2, 0  ],
[1.0, 0.5, 1.0],
[0.0,  1,  4 ]
]
]@=> float liveBass[][][];


function void bassIntegrated()
{
  while(true)
  {
     BPM.roundCounter % 32 => int bassPhrase;

     if (bassPhrase == 0){ spork~ bassist.arrays(basses.cumbia[0]); }
     if (bassPhrase == 16){ spork~ bassist.arrays(basses.cumbia[1]); }
     beat * 16 => now;
  }
}

function void melodyIntegrated()
{
  while(true)
  {
    BPM.roundCounter % 32 => int phrase;
      if (phrase == 0){ spork~ melodier.arrays(melodies.cumbia[1]); }
      if(phrase == 16){ spork~ melodier.arrays(melodies.cumbia[2]); }
      beat * 16  => now;
  }
}

//spork~ dr.arrayDrums(liveBeat[0]);
//spork~ BPM.metro(8, beat);
spork~ dr.arrayDrums(beats.cumbia[0]);

//spork~ bassist.arrays(liveBass[0]);
spork~ bassIntegrated();

spork~ melodier.arrays(liveMel[0]);//live
//spork~ melodyIntegrated();

//spork~ dr.reverbTransformation(1);
spork~ dr.soundTransformation();

//spork~ dr.fill(5, 0.125);
//spork~ melodier.arrays(melodies.base[1]);
//spork~ melodier.arrays(liveMel[0]);
//spork~ play.chordPlayer(test,1);
//spork~ synth.playChord([57,60,64], 1, 0);
//spork~ play.chordPlayer([[57,60,64], [57,63,67], [80, 84, 88]]);
//spork~ play.playMelody(1, root, 3, [[(test[0]),2],[test(1),1]]);
//spork~ play.playMelody(1, root, 3, [[0,1],[3,1]]);
//spork~ play.playMelody(1, root, 3, [[0,2],[4,1],[2,2],[0,1],[-88,1],[6,1],[-88,1]]);
//spork~ ml.searchMelody( root,6,4, 8);
//spork~ ml.generateMelody(root,2);


// DEBUG zone

while( true ){
    100::ms => now;
}
