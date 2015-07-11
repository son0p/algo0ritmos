public class volumen
{
    
    0 => static float VOLGENERAL;
    
    public void General(float Ganancia)
    {
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
        if((On == 0)&&(VOLGENERAL == 0))
        {
            for(0 => float i;i <= 1; i + 0.01)
            {
                General(0.01 + VOLGENERAL);
                0.1::second => now;
                <<<"Estado vol",VOLGENERAL>>>;
            }
        }
         if((On == 1)&&(VOLGENERAL == 1))
        {
            for(0 => float i;i <= 1; i + 0.01)
            {
                General(VOLGENERAL - 0.01);
                0.1::second => now;
                //<<<"Estado vol",VOLGENERAL>>>;
                if (VOLGENERAL < 0)
                {
                    break;
                }
            }
           
        }

    }
    
}