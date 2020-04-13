public class volumen
{
        //Inicio de la variable Volumen General
        0 => static float VOLGENERAL;
    
    public void General(float Ganancia)
    {
        //Si la Ganancia es menor a "1"
        //El valor es aceptado
        //De lo contrario es denegado
        if ( Ganancia <= 1)
        {
            Ganancia => VOLGENERAL;
            <<<"Volumen aceptado">>>;  
        }
        else
        {        
            <<<"Volumen Denegado">>>;
        }
    }

    public void FadeIn(float On)
    {
        //Cuando el boton On es igual a 0 y el volumen general es igual a 0
        //Se comenzara a subir lentamente el volumen General hasta estar de 
        // Nuevo en 1
        if((On == 0)&&(VOLGENERAL == 0))
        {
            for(0 => float i;i <= 1; i + 0.01)
                {
                    General(0.01 + VOLGENERAL);
                    0.1::second => now;
                    <<<"Estado vol",VOLGENERAL>>>;
                }
        }
        //Cuando el boton On es igual a 1 y el volumen general es igual a 1 
        // Se comienza a bajar lentamente el volumen General hasta estar de 
        // Nuevo en 0
        if((On == 1)&&(VOLGENERAL == 1))
        {
            for(0 => float i;i <= 1; i + 0.01)
                {
                    General(VOLGENERAL - 0.01);
                    0.1::second => now;
                    if (VOLGENERAL < 0)
                    {
                        // Cuando el volumen es menor que 0 rompera el ciclo
                        break;
                    }
                }
           
        }

    }    
}