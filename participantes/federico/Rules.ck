public class Rules
{
     ModesClass modesClass;
    function float interval(float originNote, float generatedNote, float maxInterval, int mode)
    {
        mode => int internalMode;
        if ((generatedNote - originNote) >= maxInterval )
        {
            //<<< "ruleInterval skipped">>>; // DEBUG
            modesClass.mode(12) @=> int options[];
            options[Math.random2(0, options.cap()-1)] => int newInterval;
            interval(newInterval, generatedNote, maxInterval, mode);
        }
        // <<< "ruleInterval passed">>>; // DEBUG
        return generatedNote;

	}
}

//// ------ Test ----
//// --- monta  ModesClass.ck a la maquina virtual primero

// Rules rules;
// for(0 => int i; i < 30; i++)
// {
//    Math.random2(0, 12) => int seed;
//     seed + 0.0 => float floatSeed;
//     rules.interval(0.0, floatSeed, 6, 12) => float testNote;
//     <<< "testNote: "+testNote>>>;
//     100::ms => now;
// }
