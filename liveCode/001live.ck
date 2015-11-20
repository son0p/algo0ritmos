// define una
500::ms=> dur beat;
0 => int i;
Impulse impulse => dac;

// funciones de prueba
fun void kick()
{
    while(true)
    {
        <<<"kick">>>;
        1 => impulse.next;
        beat => now;
    }
}
fun void hihat()
{
    while(true)
    {
        <<<"hihat">>>;
        beat/2 => now;
    }
}
// llama las funciones de forma paralela
spork ~ kick();
spork ~ hihat();

while(i < 16)
{
    beat => now;
    i++;
    <<<i+ " ::: contador">>>;
}
// antes de terminar se llama a si mismo
Machine.add(me.dir() + "/001live.ck");
