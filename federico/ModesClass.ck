//
//  ModesClass.ck
//  CHmUsiCK
//
//  Created by Esteban Betancur on 18/10/14.
//  Copyright (c) 2014 Esteban Betancur. All rights reserved.
//



public class Modes 
{
    int notes[];
    
    public int[] modes (int input)
    {
        if( input == 1 )
        {
            [0, 2, 4, 5, 7, 9, 11] @=> int maj[]; //major scale
            maj @=> notes;
            return notes;
        }
        if( input == 2 )
        {
            [0, 2, 3, 5, 7, 9, 10] @=> int dor[]; //dorian
            dor @=> notes;
            return notes;
        }
        if( input == 3 )
        {
            [0, 1, 3, 5, 7, 8, 10] @=> int phg[]; //phrygian 
            phg @=> notes;
            return notes;  
        }
        if( input == 4 )
        {
            [0, 2, 4, 6, 7, 9, 11] @=> int lyd[]; //lydian
            lyd @=> notes;
            return notes;
        }
        if( input == 5 )
        {
            [0, 2, 4, 5, 7, 8, 10] @=> int mix[]; //mixolydian
            mix @=> notes;
            return notes;
        }
        if( input == 6 )
        {
            [0, 2, 3, 5, 7, 8, 10] @=> int min[]; //aeolyan - minor
            min @=> notes;
            return notes;
        }
        if( input == 7 )
        {
            [0, 1, 3, 5, 6, 8, 10] @=> int loc[]; //locyan
            loc @=> notes;
            return notes;
        }
        if( input == 8 )
        {
            [0, 2, 4, 7, 9] @=> int pent[]; //major pentatonic
            pent @=> notes;
            return notes;
        }
        if( input == 9 )
        {
            [0, 2, 3, 5, 7, 8, 11] @=> int har[]; //harmonic minor
            har @=> notes;
            return notes;
        }
        if( input == 10 )
        {
            [0, 2, 3, 5, 7, 9, 11] @=> int asc[]; //ascending melodic minor
            asc @=> notes;
            return notes;
        }
        if( input == 11 )
        {
            [0, 1, 4, 5, 7, 8, 10] @=> 
            int jewish[]; //phrygian dominant-jewish
            jewish @=> notes;
            return notes;
        }
        if( input == 12 )
        {
            [0, 2, 3, 6, 7, 8, 11] @=> int gypsy[]; //hungarian-gypsy
            gypsy @=> notes;
            return notes;
        }
        if( input == 13 )
        {
            [0, 1, 4, 5, 7, 8, 11] @=> int arabic[]; //arabic
            arabic @=> notes;
            return notes;
        }
        if( input == 13 )
        {
            [0, 2, 4, 6, 8, 10] @=> int wt[]; //whole tone
            wt @=> notes;
            return notes;
        }
        if( input == 14 )
        {
            [0, 2, 3, 5, 6, 8, 9, 11] @=> int dim[]; //diminished
            dim @=> notes;
            return notes;
        }
        if( input == 15 )
        {
            [0, 2, 4, 6, 7, 9, 10] @=> int ind[];//psuedo indian lydian
            ind @=> notes;
            return notes;
        }
        else
        {
            <<<"Number between 1 and 15">>>;
        }     
    }
}
