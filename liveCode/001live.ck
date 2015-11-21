// define una duración
500::ms=> dur beat;
// iteraciones que pueden usarse para contadores
0 => int i;
// sonido para probar
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

// llama funciones concurrentes
spork ~ kick();
spork ~ hihat();

// ciclo que define cuanto tiempo transcurre
// antes de que el código sea reemplazado
// por si mismo, con o sin modificaciones.
while(i < 8)
{
    beat => now;
    <<< i + " ::: contador" >>>;
    i++;
}
// antes de desaparecer se instancia a sí mismo
Machine.add(me.dir() + "/001live.ck");
