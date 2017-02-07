// Intialize array
[[1,2],[3,4],[8,16]] @=> int test[][];

// accedo a elementos  // esto no me funciona 
test[1,1];  // da 1
test[2,1]; // da 3
test[1,2]; // da 1?
test[3,1]; // da 8
test[3,2]; // da 16

test[1][2]; //pareciera funcionar
while( true ){
	<<< test[1][2]>>>;
	500::ms => now;
}