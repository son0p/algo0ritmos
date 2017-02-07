public class Moodizer
{
    PlayerDrums dr;
    PlayerMelodies melodier;
    PlayerBass bassist;
    CollectionBeats beats;
    CollectionMelodies melodies;
    CollectionBasses basses;
    spork~ dr.soundTransformation();


    function void dancefloor(string mood, int agitation)
    {
        if(mood == "a")
        {
            spork~ bassist.arrays(basses.cumbia[agitation]);
            spork~ melodier.arrays(melodies.cumbia[agitation]);
            //spork~ dr.arrayDrums(beats.cumbia[agitation]);
            while(true){100::ms => now;}
        }
        if(mood == "b")
        {
            spork~ bassist.arrays(basses.cumbiaBuild[agitation]);
            spork~ melodier.arrays(melodies.cumbiaBuild[agitation]);
            //spork~ dr.arrayDrums(beats.cumbiaBuild[agitation]);
            while(true){100::ms => now;}
        }
        if(mood == "c")
        {
            spork~ bassist.arrays(basses.cumbiaDrop[agitation]);
            spork~ melodier.arrays(melodies.cumbiaDrop[agitation]);
            //spork~ dr.arrayDrums(beats.cumbiaDrop[agitation]);
            while(true){100::ms => now;}
        }
        else
        {
            <<< "no existe ese mood">>>;
        }
    }
}
