// ====== TEST llamado a Rscript y regresa OSC
Library lib;
// create our OSC receiver
OscIn oin;
// creeate our OSC msg
OscMsg msg;
// use port 6449
6449 => oin.port;

float rec[0];
// create an address in the receiver, store in new variable
oin.addAddress( "/ffxf/step1, ffffffffffffffff" );

fun void print(){
    // wait for event to arrive
    lib.print(rec);
}

fun void oscRxFloat(){
    while(true){
        // wait for event to arrive
        oin => now;
        while (oin.recv(msg)){
            for(0 => int i; i < 16; i++){
                rec << msg.getFloat(i);
            }
            <<<"DONE" , rec.cap()>>>;
            spork~ print();
        }
    }
}

fun void callR(){
    while(true){
        Std.system("Rscript corpus.R > out.log 2> /dev/null");
        <<< "calling R" >>>;
        1000::ms => now;
    }

}

spork~ callR();
spork~ oscRxFloat();
spork~ print();
while(true){100::samp => now;}


// =========== END TEST 

//// =========== TEST ENV variable
// chuck stdlib test
// Std.randf();
// // Std.randf() => stdout;
// // Std.randf() => stdout;
// // Std.randf() => stdout;
// // Std.randf() => stdout;
// // Std.randf() => stdout;
// // Std.randf() => stdout;

// //chout <= Std.abs(-10.0);
// Std.system("pwd");
// Std.getenv("USER");
// chout <= Std.sgn(-1.0) ;
// Std.setenv( "LAUGH", "HAHA" );
//// ========== END TEST 

// // ======= TEST OSC 16
// Library lib;
// // create our OSC receiver
// OscIn oin1; OscIn oin2; OscIn oin3; OscIn oin4; OscIn oin5; OscIn oin6; OscIn oin7; OscIn oin8; OscIn oin9; OscIn oin10; OscIn oin11; OscIn oin12; OscIn oin13; OscIn oin14; OscIn oin15; OscIn oin16; 
// // creeate our OSC msg
// OscMsg msg1; OscMsg msg2; OscMsg msg3; OscMsg msg4; OscMsg msg5; OscMsg msg6; OscMsg msg7; OscMsg msg8; OscMsg msg9; OscMsg msg10; OscMsg msg11; OscMsg msg12; OscMsg msg13 ; OscMsg msg14 ; OscMsg msg15 ; OscMsg msg16 ; 
// // use port 6449
// 6449 => oin1.port; 6449 => oin2.port; 6449 => oin3.port; 6449 => oin4.port; 6449 => oin5.port; 6449 => oin6.port; 6449 => oin7.port; 6449 => oin8.port; 6449 => oin9.port; 6449 => oin10.port; 6449 => oin11.port; 6449 => oin12.port; 6449 => oin13.port; 6449 => oin14.port; 6449 => oin15.port; 6449 => oin16.port; 
// // our arrays to be filled
// float rec1[0]; float rec2[0]; float rec3[0]; float rec4[0]; float rec5[0]; float rec6[0]; float rec7[0]; float rec8[0]; float rec9[0]; float rec10[0]; float rec11[0]; float rec12[0];  float rec13[0]; float rec14[0]; float rec15[0]; float rec16[0];
// // create an address in the receiver, store in new variable
// oin1.addAddress( "/ffxf/step1, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin2.addAddress( "/ffxf/step2, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin3.addAddress( "/ffxf/step3, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin4.addAddress( "/ffxf/step4, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin5.addAddress( "/ffxf/step5, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin6.addAddress( "/ffxf/step6, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin7.addAddress( "/ffxf/step7, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin8.addAddress( "/ffxf/step8, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin9.addAddress( "/ffxf/step9, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin10.addAddress( "/ffxf/step10, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin11.addAddress( "/ffxf/step11, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin12.addAddress( "/ffxf/step12, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin13.addAddress( "/ffxf/step13, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin14.addAddress( "/ffxf/step14, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin15.addAddress( "/ffxf/step15, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );
// oin16.addAddress( "/ffxf/step16, ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff" );

// fun void print(float rec[]){
//     // wait for event to arrive
//     lib.print(rec);
// }

// fun void oscRxFloat(OscIn oin, float rec[], OscMsg msg){
//     while(true){
//         // wait for event to arrive
//         oin => now;
//         while (oin.recv(msg)){
//             for(0 => int i; i < 100; i++){
//                 rec << msg.getFloat(i);
//             }
//             <<<"DONE1" , rec.cap()>>>;
//             spork~ print(rec);
//         }
//     }
// }


// spork~ oscRxFloat(oin1, rec1, msg1);
// spork~ oscRxFloat(oin2, rec2, msg2);
// while(true){100::samp => now;}
// /// END TEST OSC 16





// // ############## TEST sendind array[100] from R to ChucK
// Library lib;
// OSC_Read osc;
// osc.setPort(6449);
// osc.makePar("gain","/1/fader1, f" );


// fun void oscRun() {
//     while (true) {
//             // <<< "test value :", osc.values["gain"] >>>;
//             osc.values["gain"]  => float value;
//             1::samp => now;
//     }
// }

// fun void print() {
//     while(true) {
//   //      <<< "size:           ", glo.container.cap()>>>;
//        // <<< "inside class:  ", glo.container[2] >>>;
//         <<< "local container:  ", osc.localContainer[98] >>>;
//         <<< "global container:  ", Global.root >>>;
//         //lib.print(glo.container);
//         //lib.print(glo.container);
//         1000::ms => now;
//     }

// }

// spork~ oscRun();
// spork~ print();
// while(true) 10::ms => now;
// // ############# END test 

//lib.print(step1);


////========= END TEST


// // ################ FAIL test Clases to covert functions as objects and array them
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

