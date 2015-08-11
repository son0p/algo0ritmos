public class Moodizer
{
    PlayerDrums dr;
    PlayerMelodies melodier;
    PlayerBass bassist;
    CollectionBeats beats;
    CollectionMelodies melodies;
    CollectionBasses basses;

    function void dancefloor(string mood, int agitation)
    {
        if(mood == "expo")
        {
            if(agitation == 0)
            {
                spork~ bassist.arrays(basses.cumbia[0]);
                spork~ melodier.arrays(melodies.cumbia[0]);
                spork~ dr.arrayDrums(beats.cumbia[0]);
                while(true){100::ms => now;}
            }
             if(agitation == 1)
            {
                spork~ bassist.arrays(basses.cumbia[Math.random2(1,5)]);
                spork~ melodier.arrays(melodies.cumbia[Math.random2(1,5)]);
                spork~ dr.arrayDrums(beats.cumbia[Math.random2(1,5)]);
                while(true){100::ms => now;}
            }
             if(agitation == 3)
            {
                spork~ bassist.arrays(basses.cumbia[Math.random2(7,basses.cumbia.cap()-1)]);
                spork~ melodier.arrays(melodies.cumbia[Math.random2(7,melodies.cumbia.cap()-1)]);
                spork~ dr.arrayDrums(beats.cumbiaDrop[Math.random2(7,beats.cumbia.cap()-1)]);
                while(true){100::ms => now;}
            }
      }
       if(mood == "build")
        {
            if(agitation == 0)
            {
                spork~ bassist.arrays(basses.cumbiaBuild[0]);
                spork~ melodier.arrays(melodies.cumbiaBuild[0]);
                spork~ dr.arrayDrums(beats.cumbiaBuild[0]);
                while(true){100::ms => now;}
            }
             if(agitation == 1)
            {
                spork~ bassist.arrays(basses.cumbiaBuild[Math.random2(1,5)]);
                spork~ melodier.arrays(melodies.cumbiaBuild[Math.random2(1,5)]);
                spork~ dr.arrayDrums(beats.cumbiaBuild[Math.random2(1,5)]);
                while(true){100::ms => now;}
            }
             if(agitation == 3)
            {
                spork~ bassist.arrays(basses.cumbiaBuild[Math.random2(7,basses.cumbiaBuild.cap()-1)]);
                spork~ melodier.arrays(melodies.cumbiaBuild[Math.random2(7,melodies.cumbiaBuild.cap()-1)]);
                spork~ dr.arrayDrums(beats.cumbiaBuild[Math.random2(7,beats.cumbiaBuild.cap()-1)]);
                while(true){100::ms => now;}
            }
      }
       if(mood == "drop")
        {
            if(agitation == 0)
            {
                spork~ bassist.arrays(basses.cumbiaDrop[0]);
                spork~ melodier.arrays(melodies.cumbiaDrop[0]);
                spork~ dr.arrayDrums(beats.cumbiaDrop[0]);
                while(true){100::ms => now;}
            }
             if(agitation == 1)
            {
                spork~ bassist.arrays(basses.cumbiaDrop[Math.random2(1,5)]);
                spork~ melodier.arrays(melodies.cumbiaDrop[Math.random2(1,5)]);
                spork~ dr.arrayDrums(beats.cumbiaDrop[Math.random2(1,5)]);
                while(true){100::ms => now;}
            }
             if(agitation == 3)
            {
                spork~ bassist.arrays(basses.cumbiaDrop[Math.random2(7,basses.cumbiaDrop.cap()-1)]);
                spork~ melodier.arrays(melodies.cumbiaDrop[Math.random2(7,melodies.cumbiaDrop.cap()-1)]);
                spork~ dr.arrayDrums(beats.cumbiaDrop[Math.random2(7,beats.cumbiaDrop.cap()-1)]);
                while(true){100::ms => now;}
            }
      }
  }
}
