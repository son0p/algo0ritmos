
// 07_Global.ck - VERSIÓN LIMPIA Y CORREGIDA

public class Global
{
    // ============ CONTADORES Y TIMING ============
    0 => static int counter;
    0 => static int mod4;
    0 => static int mod16;
    0 => static int mod32;
    0 => static int mod64;
    0 => static int mod256;

    200::ms => static dur beat;
    36 => static int root;
    0 => static int cursor;

    // ============ CONFIGURACIÓN GLOBAL ============
    0.7 => static float masterGain;
    0.2 => static float hhGain;
    0 => static int currentBPM;

    // ============ ARRAYS OSC ============
    static float bassFromOsc[16];
    static float bassFromOscComp[16];

    // ============ ARRAYS DE INSTANCIA ============
    int inmutableArray[16];
    int inmutableEnvNotes[16];
    int inmutableBass[16];
    int inmutableEnvBass[16];
    int inmutableBD[16];
    int inmutableSN[16];
    int inmutableHH[16];
    float container[100];

    // ============ PATRONES DE PROBABILIDAD ============
    static int chanceBd[16];
    static int chanceSd[16];
    static int chanceT1[16];
    static int chanceHh[16];
    static int chanceBass[16];
    static int chanceBassNotes[16];
    static int chanceBreak[16];
    static int chanceM2[16];

    // ============ ESTADOS ============
    0 => static int currentSection;
    0 => static int isPlaying;
}

// ============ INICIALIZACIÓN ============
// Inicializar arrays OSC con -1
for(0 => int i; i < 16; i++) {
    -1.0 => Global.bassFromOsc[i];
    -1.0 => Global.bassFromOscComp[i];
}

// Inicializar timing
200::ms => Global.beat;
36 => Global.root;

// Inicializar patrones de drums
[100,0,0,80, 100,0,0,0, 100,0,0,80, 100,0,0,0] @=> Global.chanceBd;
[0,0,0,0, 0,0,100,0, 0,0,0,0, 0,0,100,0] @=> Global.chanceSd;
[0,0,100,0, 0,0,100,0, 0,0,100,0, 0,0,100,20] @=> Global.chanceT1;
[100,0,100,100, 100,0,100,100, 90,0,100,100, 80,0,100,30] @=> Global.chanceHh;

// Inicializar patrones de bass/melodía
[20,0,0,20, 60,0,100,0, 0,0,0,0, 100,0,0,0] @=> Global.chanceBass;
[0,0,0,0, 0,3,0,3, 0,0,10,12, 3,0,7,0] @=> Global.chanceBassNotes;
[100,0,0,0, 0,0,100,0, 0,0,100,0, 100,0,0,0] @=> Global.chanceBreak;
[0,0,0,100, 0,80,100,0, 100,5,0,100, 0,0,10,10] @=> Global.chanceM2;

<<< "Global.ck cargado correctamente" >>>;
<<< "Beat:", Global.beat / 1::ms, "ms" >>>;
<<< "Root:", Global.root >>>;
