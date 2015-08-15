public class Tempo
{
       
    static float tempo;
    public float beatUnity (float bpm)
    {
        60.0/bpm => float tempoUnitario; // tempo unitario es el valor unitario de un beat a X bpm
        tempoUnitario => tempo;
        return tempo;
    }    
    
    
}
/*   
___________________test beatUnity___________________
Tempo tempo;
tempo.beatUnity(120)=> float valorPrueba;
<<<valorPrueba>>>;
*/
