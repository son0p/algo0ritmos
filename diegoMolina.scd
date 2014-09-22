//Algo de SuperCollider

s.boot //Prendemos SC


//Tipos de ondas
{SinOsc.ar(440)}.play //onda Seno
{Pulse.ar(440)}.play // onda cuadrada
{Saw.ar(440)}.play  // diente de sierra


//Algunas Envolventes (comportamiento del sonido en el timepo)
Env.adsr
Env.asr
Env.triangle
Env.perc
//para usar una envolvente, multiplicas una onda por la envolvente y el sonido de la onda cobrara las caracteristaicas de la envolvente

//Creamos un intruemnto
(
SynthDef(\melodia,{|gate=1,nota|
    var envo,onda,noti;
    envo= (EnvGen.kr(Env.perc(0,4),gate,doneAction:5));//envolvente
    noti= Pulse.ar(nota,0.3,0.2);//la nota musical de la onda
    onda =(RLPF.ar(noti,LFNoise0.kr(12,3900,4100),LFNoise0.kr(6,0.3,0.3)));//la onda ¿la volvemos mas sencilla para enternder mejor?
Out.ar(0,Pan2.ar(envo*onda,SinOsc.kr(1),0.5))}).send(s); //la salida
)


b=Synth(\melodia,[\nota,[[69,60,62,64,67,69,60,62,64,67,69,72].choose].midicps*12.midiratio])

//vamos hacer un loop y crear nuesta melodia

(
Tdef(\melodia, {
    inf.do{Synth(\melodia,[\nota,[[69,60,62,64,67,69,60,62,64,67,69,72].choose ].midicps*12.midiratio]);
        (~rittmo.choose).wait};
});
)

~rittmo=[1,2,0.2,0.5];
Tdef(\melodia).play
Tdef(\melodia).stop

