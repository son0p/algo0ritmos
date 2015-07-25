public class Volume
{
    
    1 => static float VOLUMENGENERAL;
    1 => static float specificvolume;
    
    public void volumenGeneral(float Ganancia)
    {
        if ( Ganancia <= 1)
            {
              Ganancia => VOLUMENGENERAL;
              //<<<"Volumen aceptado">>>;  
            }
        else
            {
                <<<"Volumen Denegado">>>;
            }
    }

    public void fadesvolume(float switchInOff, float gainalteration)
    {
        //FadeIn
         if((switchInOff == 0)&&(specificvolume == 0))
         {
                for(0 => float i;i <= 1; i + gainalteration)
                {
                        gainalteration+=> specificvolume;
                        0.1::second => now;
                    //<<<"Estado vol",VOLUMENGENERAL>>>;
                }
         }
         //FadeOut                
         if((switchInOff == 1)&&(specificvolume == 1))
         {
                for(0 => float i;i <= 1; i + gainalteration)
                {
                        gainalteration-=> specificvolume;
                        0.1::second => now;
                    //<<<"Estado vol",VOLUMENGENERAL>>>;
                        if (specificvolume < 0)
                        {
                                break;
                        }
                }
               
          }   

    }
    
}