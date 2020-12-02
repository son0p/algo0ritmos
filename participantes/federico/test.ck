////====== TEST sendind array[100] from R to ChucK
Library lib;
OSC_Read osc;
osc.setPort(6449);
osc.makePar("gain","/1/fader1, f" );

Global glo;
float localContainer[100];
glo.container @=> localContainer;
OscRecv oscrecv;

fun void oscRun() {
    oscrecv.event @=> OscEvent oe;
    0 => int j;
    while (true) {
        // wait for osc
        oe => now;
        if (oe.nextMsg() != 0) {
            // store value in array
            // <<< "test value :", osc.values["gain"] >>>;
            osc.values["gain"]  => float value;
            value =>  glo.container[j%100];
            j++;
            1::samp => now;
        }
    }
}


fun void print() {
    0.55555 => osc.localContainer[99];
    while(true) {
  //      <<< "size:           ", glo.container.cap()>>>;
       // <<< "inside class:  ", glo.container[2] >>>;
        <<< "local container:  ", osc.localContainer[98] >>>;
        //lib.print(glo.container);
        //lib.print(glo.container);
        1000::ms => now;
    }

}

spork~ oscRun();
spork~ print();
while(true) 10::ms => now;

//lib.print(step1);


////========= END TEST


// // ==== FAIL test Clases to covert functions as objects and array them
// class foo
// {
//     fun float foo(float a){
//         <<<"foo">>>;
//         float result;
//         return result;
//     }
// }
// class bar
// {
//     fun float bar(float b){
//         <<<"bar">>>;
//         float  result;
//         return result;
//     }
// }
// foo f;
// bar b;

// fun float add( f.foo(), f.bar())
//     {
//         float result;
//         f.foo + f.bar => result;
//         return result;
//     }

// //[f.foo, b.bar] @=> Object part;

// //part[0]; // array subscripts (1) exceeds defined dimension (0)
// // ========= END ============

// =========== string as function name
// ["foo", "bar"] @=> string names[];

// fun void foo()
//     {
//         <<<"foo">>>;
//     }
// () => names[0];
// ============ end FAIL
//foo();
//<<< names[1]>>>;


// fun int eatParts(int x)
// {
//     if( x <= 1 ) return x;
//     else return x + eatParts( x-1 );
// }

// <<<eatParts(5)>>>;



//*Test de captura de step y sumarlo a donde voy*
//#+BEGIN_SRC chuck
// 0 => int counter;
// 200::ms => dur beat;

// int parts[10];
// 8 => parts["intro"];
// 4 => parts["fill"];
// 8 => parts["breakDown"];
// [
//     parts["intro"],
//     parts["fill"],
//     parts["breakDown"]
//     ] @=> int songStructure[];

// fun void foo()
// {
//     <<< "playing foo" >>>;
//     songStructure[0] * beat => now;
// }

// fun void bar()
// {
//     <<< "playing bar" >>>;
//     songStructure[1] * beat => now;
// }


// fun void testPlaySong()
// {
//     for( 0 => int i; i < songStructure.cap(); i++ )
//     {
//         songStructure[i] * beat => now;      //corro el numero de beats,
//         <<< "part .. ", songStructure[i] >>>;
//     }
// }

// spork~ testPlaySong();
// fun int partEater(int currentPosition, int part )
// {
//     currentPosition + part => int newPosition;
//     return(newPosition);
// }
// ¿Como se llama?
//<<<partEater(0, songStructure[0])>>>;
// ¿Cömo itero?
// for (0 => int i; i < songStructure.cap(); i++ )
//     {
//         partEater(i, songStructure[i]);
//     }
// fun int eatParts(int x)
// {
//     if( x <= 0 ) return x;
//     else return songStructure[x] + songStructure[ x - 1 ]; eatParts( x - 1 );
// }

// <<< "Recursion: ", eatParts(songStructure.cap() - 1 )>>>;

//fun void intro()
// {
//     if(counter > 10 && counter < 10 + 4) {
//         <<< "intro" >>>;
//     }
//     beat => now;
// }
// fun void breakDown()
// {
//     if(counter > 13 && counter < 13 + 8) {
//         <<<"breakDown">>>;
//     }
//     beat => now;
// }

// fun int nextPartIn(int actualPart){
//         0 => int sum;
//         fun int acumulated(){
//             for(0 => int i; i < actualPart; i++){
//                 sum + songStructure[actualPart]
//             }

//         actualPart + songStructure[actualPart] => int sum;  // se debe sumar lo acumulado, lo actualPart
//         <<< "Next part in : ", sum>>>;
//         return(sum);
//
// ================= DONE call functions in a row ============
// 200::ms => dur beat;
// [8, 4] @=> int parts[];

// fun void foo()
// {
//     <<< "playing foo" >>>;
//     parts[0] * beat => now;
// }

// fun void bar()
// {
//     <<< "playing bar" >>>;
//     parts[1] * beat => now;
// }

// fun void testPlay()
// {
//     () => foo => bar;
// }
// //spork~ () => foo => bar;
// spork~ testPlay();
// while(true) 200::ms => now;
//========================== TEST 
// while(true){
//     //spork~ intro();
//     //spork~ breakDown();
// //    spork~ nextPartIn(counter%songStructure.cap());

//     counter++;
//     <<< counter >>>;
//     beat => now;
// }
//#+END_SRC



// int part[10]; // In asociative arrays size do not matter
// // parts
// 7 => part["intro"];
// 1 => part["fill"];
// 8 => part["breakDown"];
// 8 => part["buildUp"];
// 8 => part["drop"];

//     [part["intro"], 
//      part["breakDown"]
//         ]  @=> int songStructure[];
// <<< songStructure[0]>>>;
// TEST array of UGens

// ADSR a;
// ADSR b;

// [a, b] @=> ADSR envs[];


// Library lib;

// [lib.sin0env, lib.sqr0env] @=> ADSR envs[];

// while(true){
//     envs[0].keyOn();
//     1::second => now;
//     envs[0].keyOff();
//     1::second => now;
// }



// // El array multidimensional puede tener referencias a los nombres?
// float step1[100];
// float step2[100];
// float step3[100];
// lib.insertChance(50, step1, 1.0) @=> step1;
// lib.insertChance(50, step2, 7.0) @=> step2;

// [
//     step1,
//     step2,
//     step3
// ] @=> float multiTest[][];

// <<< multiTest[1][1] >>>;

//[0, 12] @=> int values[];
//[33.0, 66] @=> float percentToValues[];

// int arrContainer[100];
// lib.insertChance(percentToValues, arrContainer, values) @=> arrContainer;
// print(arrContainer); 
// int arrContainer[0];
// [3, 2, 5] @=> int x[];
// [0, 12, 88] @=> int y[];
// for( 0 => int i; i < x.cap(); i++){
//     for( 0 => int j; j < x[i]; j++){
//         arrContainer << y[i];   // ¿Como ir llenando?
//     }
// }
//lib.print(arrContainer);

// [
//     [
//       [0.0, 0.50], [3.0, 0.25], [5.0, 0.125], [12.0, 0.125] // step 5
//     ],
//     [
//         [0.0, 0.5] // step 6
//     ]
// ] @=> float test[][][];
// <<< test[1].cap()>>>; // capacidad de un array intenrno
// <<< test.cap()>>>;

// // accede al segundo elemento de todos los arrays internos
// for( 0 => int i; i < test.cap(); i++ ){
//     for( 0 => int j; j <  test[i].cap(); j++ ){
//         <<< test[i][j][0]>>>;
//     }
// }

