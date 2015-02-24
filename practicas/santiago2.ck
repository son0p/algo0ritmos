public class Prog 
{
    // Vector de ocho posiciones N[8]
	int N[8];
    // C = contandor 
	0 => int C;
    // Reglas para sacar notas Mayores en donde M[] es el vector que guarda 8 caracteres ya definidos
	[0,2,2,1,2,2,2,1] @=> int M[]; //1
    // Reglas para sacar notas Mayores en donde m[] es el vector que guarda 8 caracteres ya definidos
	[0,2,1,2,2,1,2,2] @=> int m[]; //0
    // Cj = Una constante, lo que hace esta variable es guardar las notas y enviarlas a N[] en la posicion de C
	0 => int Cj;
    // Esta es la variable que retorna de la clase publica entera 
	int ope;
    // Esta es la clase publica entera
	public int NotayTono(int x, int y)
	{
        // Condicional si Y es igual a 1 entonces !! 1 es para generar notas Mayores 0 es para generar notas menores
        if (y == 1)
        {
            // imprimame el valor de Y antes de entrar al while.
            <<<"Y =",y>>>;
            
				// Este es el codicional de mientras C (= Contador) sea menor que 8 entonces haga
			while (C < 8)
			{
           // el valor de X al entrar en el while es la nota raiz que se designa en "Test"
				x => ope;
				// imprima X y C
				<<<"X",x>>>;
				<<<"C",C>>>;
				//si "Y" es "1" entonces, Mayores[en la posicion C] + Nota raiz => Cj (guardar) y llevelo a N[en la           posicion de C]
				M[C] + x => Cj => N[C];
				// imprima lo que acaba de hacer.
				<<<"M[C]",M[C],"+",x,"x","=",Cj,"CJ",N[C],"= N">>>;
				//La nota que se guardo llevela a X
				Cj => x;
				// retorne ope con el valor de X
				return int ope;
				// C sumele 1
				<<< C >>>;
				C++; 
			}           
			// Lo de abajo es copy paste pero con las notas menores.
		}     
   if (y == 0)
   {
       <<<"Y =",y>>>;
       while (C < 8)
       {
		   x => ope;
		   <<<"X",x>>>;
		   <<<"C",C>>>;
		   m[C] + x => Cj => N[C];
		   <<<"m[C]",m[C],"+",x,"x","=",Cj,"CJ",N[C],"= N">>>;
		   Cj => x;
		   return int ope;
		   C++; 
       }
   }
   
   /* for( 0 => int i; i < N.cap(); i++ )
   {
	   N[i] => ope;
	   
	   <<<"Pos N", N[i] >>>;
   }*/
   
}
}
// test -----------
Prog Progre;

int P[8]; // variable en la que quiero guardar todas las notas generadas en la clase anterior
int o; // o es la variable que recibe lo que viene de la clase anterior
Progre.NotayTono((60),(0)); // (el primer parentesis es para colocar la nota raiz) (el segundo para colocar la tonalidad 1 o 0 )

Progre.ope => o; // el valor retornado tráigamelo a o

// condicional para
for( 0 => int i; i < P.cap(); i++ )
{
// lo que trae o llevelo a P [en la posicion de i]
    o => P[i];
// imprima lo que trae o

}
<<<"o",o>>>;