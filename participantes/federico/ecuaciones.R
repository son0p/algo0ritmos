## actualmente funciona con liveDany.ck

devtools::install_github("tidyverse/ggplot2")
library(devtools)
library(ggplot2)
library(ggthemes) 
library(pracma)
library(binhf)
library(reshape)
library(dplyr)

## functions  

draw <- function(x,l1,l2,l3){
  df <- data.frame(x,l1,l2,l3)
  ggplot(df, aes(x))+
    geom_line(aes(y=l1), colour="green")+
    geom_line(aes(y=l2), colour="blue")+
    geom_line(aes(y=l3), colour="brown")
}

writeFiles <- function(l1,l2,l3,d1){
  write(d1, file="bd.txt", ncolumns=1)
  write(l1, file="bass.txt", ncolumns=1)
  write(l2, file="line2.txt", ncolumns=1)
  write(l3, file="line3.txt", ncolumns=1)
}

## Se necesita saber los semitonos posibles en un rango de frecuencias dado
## TODO: try recursion
semitonesGen <- function( freqFrom, freqTo){
  posibleSemitones <- floor(log(freqTo/freqFrom)/log(1.0594630943))
  semitones <- numeric(length <- posibleSemitones)
  semitones[1] <- freqFrom 
  for(i in 2:posibleSemitones){
    if(freqFrom < freqTo){
      freqFrom <- semitones[i] <- freqFrom * 1.05946309436
    }
  }
  return(semitones)
}

## TODO: entender modulo y vectores que no tienen posición 0
scaleGenerator <- function(notes, scaleJumps){
  scale <-https://twitter.com/ numeric(length <- (length(notes)-1))
  ## iterate below maximum posible scaleJumps shift
  scale[1] <- notes[1]
  for(i in 2:length(notes)){
    scale[i] <- notes[i+(scaleJumps[i])] ## es necesario sumar 1 al parecer porque scaleJumps inicia en la posición 1
  }
  return(scale)
}

## alternativa para magneticGrid DONE
magneticGrid <- function(ref, src){
  unlist(lapply(src, function(x)ref[which.min(abs(x-ref))]) )
}
offsetTrigo <- function(offsetX, data, offsetY){
  fun <- c(offsetX + data * offsetY)
  return(fun)
  }

## test functions
x <- numeric(length <- 5)
testRef <- notes
testSrc <- c(33,455,555)
magneticGrid(notes, c(33,455,555))
lapply(testSrc, function(x)notes[which.min(abs(x-notes))])



## INITIALIZE!! 
notes <- semitonesGen(32.7031956626, 20000)
scaleJumps <- c(2,2,1,2,2,2,1)
length(minorPenta)
length(semitones)
semitones[1+minorPenta]
scaleGenerator(notes,scaleJumps )
notes + notes[scaleJumps]

shift(notes, scaleJumps, dir="right")




## bassDrum
bd <- numeric(16)
bd[c(1,5,9,13)] <- 1
write(bd, file="bd.txt", ncolumns=1)
bd

## snareDrum
sd <- numeric(16)
sd[c(5,13,21)] <- 1
write(sd, file="sd.txt", ncolumns=1)
sd

## hiHat
hh <- numeric(16)
hh[c(1,2,3,5,6,7,9,10,11,13,14,15)] <- 1
write(hh, file="hh.txt", ncolumns=1)
hh

## clave  ## clave [1,0,0,0,5,0,7,0,0,0,11,0,13,0,0,0]
activate.steps <- function(activeSteps, value, filename){
  steps <- numeric(16)
  steps[activeSteps] <- value
  write(steps, file=filename, ncolumns=1)
  steps
}

write(c(1,2,3),c(4,5,6), file="foo.txt", ncolumns = 2)

## sincopas nivel 1: 1,5,9,13
## sincopas nivel 2: 3,7,11,15
## síncopas nivel 3: 2,6,10,14
## síncopas nivel 4: 4,8,12,16

sincopa.level.4 <- c(  1,  5,  9, 13)
sincopa.level.1 <- c(  4,  8, 12, 16)

## pseudo code
sincopaGenerator <- function(vector, step.to.sincopate, level, value){
  step <- sample(level.generator(level), 1)
  print(step)
  vector[step] <- value
  vector[step + level] <- 0
  return(vector)
}
level.generator <- function(level){
  if(level == 1 ) {vector <- c(  4,  8, 12, 16)}
  if(level == 2 ) {vector <- c(  2,  6, 10, 14)}
  if(level == 3 ) {vector <- c(  3,  7, 11, 15)}
  if(level == 4 ) {vector <- c(  1,  5,  9, 13)}
  return(vector)
}

level <- level.generator(1)

## PLAYGROUND =====================
##  steps to play
##   drums
d1 <- activate.steps(c(  1,  5,  9, 13),     1, "d1.txt")
d2 <- activate.steps(c(  4,  7, 12, 15),     1, "d2.txt")
d3 <- activate.steps(c(  1,  2,  3,  5,  6,  7,  9, 10, 11, 13, 14, 15), 1, "d3.txt")
##   melodic lines
l1 <- activate.steps(c(  1, 2, 5, 9, 13, 16  ), 1, "l1.txt")
l2 <- activate.steps(c(  3,  7,  11, 13, 14), 1, "l2.txt")
l3 <- activate.steps(c(   11, 12), 1, "l3.txt")

## construction of melodic lines with trigonometrics
xAxis <- c(1:16) ## TODO: mas puntos para ver la función pero se escogen puntos dividiendo en 16 o 32 steps
x <- xAxis
## se intenta hacer más visibles las ecuaciones 
freqL1 <- sin(x)+csc(x)
freqL2 <- sin(x)-cos(x)
freqL1 <- offsetTrigo(110,freqL1,128)
freqL2 <- offsetTrigo(440,freqL2,128)
harmonized <- magneticGrid(notes, freqL1)
harmonized2 <- magneticGrid(notes, freqL2)
## build dataframe
points <- as.data.frame(cbind(freqL1, freqL2, harmonized, harmonized2, xAxis))
## melt los junta en una columna y hace un factor 
points.long <- melt(points, id="xAxis", measure =c("freqL1", "freqL2", "harmonized","harmonized2"))
## draw
ggplot(points.long, aes(xAxis, value, colour = variable)  ) +
  geom_line()+
  facet_wrap(points.long$variable ~ ., scales="free_y", ncol=1)+
  theme_stata()+
  scale_colour_canva(palette = "Sunny and calm")+
  labs(x="Time", y="Value")
## reduce to 16 points
harmonized[c(TRUE,FALSE)] ## TODO find a less ugly solution
## escribo los archivos que va a leer ChucK
write(harmonized, file="freqL1.txt", ncolumns = 1)
write(harmonized2, file="freqL2.txt", ncolumns = 1)



## LEGACY =================

############## PATTERN FUNCTIONS ###########################

## base generation
d0 <- activate.steps(c(  1,  5,  7, 11, 13), 1, "d0.txt") ## clave

pattern.A <- function(){
  d1 <- activate.steps(c(  1,  9),     1, "d1.txt")
  d2 <- activate.steps(c(   7,  13),     1, "d2.txt")
  d3 <- activate.steps(c(  0, 1,  2,    5,  6,    9, 10,  13, 14 ), 1, "d3.txt")

  l1 <- activate.steps(c(  1,  4, 10, 13, 16 ), 1, "l1.txt")
  l2 <- activate.steps(c(  1, 2, 4, 7, 10, 12, 15), 1, "l2.txt")
  l3 <- activate.steps(c(   7,  9, 11, 12), 1, "l3.txt")
}
pattern.B <- function(){
  d1 <- activate.steps(c(  1,  9, 13),     1, "d1.txt")
  d2 <- activate.steps(c(  4,  12),     1, "d2.txt")
  d3 <- activate.steps(c(  0, 1,  2,  3,  5,  6,  7,  9, 10, 11, 13, 14, 15), 1, "d3.txt")

  l1 <- activate.steps(c(  7,  11, 15, 16  ), 1, "l1.txt")
  l2 <- activate.steps(c(  3,  7, 11, 13), 1, "l2.txt")
  l3 <- activate.steps(c(   9, 11), 1, "l3.txt")
}

pattern.C <- function(){
  d1 <- activate.steps(c(  1,  5,  9, 13),     1, "d1.txt")
  d2 <- activate.steps(c(  4,  7, 12, 15),     1, "d2.txt")
  d3 <- activate.steps(c(  1,  2,  3,  5,  6,  7,  9, 10, 11, 13, 14, 15), 1, "d3.txt")

  l1 <- activate.steps(c(  7,  11, 15, 16  ), 1, "l1.txt")
  l2 <- activate.steps(c(  4,  8, 15), 1, "l2.txt")
  l3 <- activate.steps(c(   11, 12), 1, "l3.txt")
}
pattern.D <- function(){
  d1 <- activate.steps(c(  1,  5,  9, 13),     1, "d1.txt")
  l1 <- activate.steps(c(  6, 7, 10, 11, 15, 16  ), 1, "l1.txt")
  d2 <- activate.steps(c(  4,  7, 12, 15),     1, "d2.txt")
  l2 <- activate.steps(c(  4,  8, 15), 1, "l2.txt")
  d3 <- activate.steps(c(  3,  7,  11, 14, 15, 16 ), 1, "d3.txt")
  l3 <- activate.steps(c(  5,  7,  9, 11, 12,16), 1, "l3.txt")
}

pattern <- function(){
  vector <- activate.steps(steps, value, file)
}

pattern.A()
pattern.B()
pattern.C()
pattern.D()

## mutes

d0 <- activate.steps(c(0), 0, "d0.txt")

d1 <- activate.steps(c(0), 0, "d1.txt")
d2 <- activate.steps(c(0), 0, "d2.txt")
d3 <- activate.steps(c(0), 0, "d3.txt")

l1 <- activate.steps(c(0), 0, "l1.txt")
l2 <- activate.steps(c(0), 0, "l2.txt")
l3 <- activate.steps(c(0), 0, "l3.txt")


pattern <- 

## write files  
write(l1, file="bass.txt", ncolumns = 1)
write(l2, file="line2.txt", ncolumns = 1)
write(l3, file="line3.txt", ncolumns = 1)

## visualization
## mbd <- replace("1", as.character(bd), "X") ## TODO
matrix <- data.frame(d0, d1, d2, d3, l1, l2, l3)
matrix


## sincopa generation
d1 <- sincopaGenerator(d1, 11, 1, 1 )
write(d1, file="d1.txt", ncolumns = 1)

## experimental
l1 <- c(550+sin(x*2)+tan(x*2/10)*50)
l2 <- c(440+tan(x)*10)
l3 <- c(880+sin(x/16)*200)
writeFiles(l1,l2,l3,d1) 

## musical 1
plot(bass <- c((sin((x)/500)+sin((x)/10)+sin((x)/10+sin((x)/80))+sin((x)/20)+sin((x)/90))*100),  col="#cd6858", pch=6+x%%4, fg="#cdcecc", axes = FALSE, xlab=".o0o.", bg=FALSE)
plot(line2 <- c(sin(x/210)+sin(x/10)+cos(x/40)*1000), col="blue", pch=14)
plot(line3 <- c(880+asin(x/4)*100), col="brown")

## musical 2
plot(bass <- c((sin((x)/500)+sin((x)/10)+sin((x)/10+sin((x)/80))+sin((x+10)/20)+sin((x+10)/90))*100),  col="#cd6858", pch=6+x%%4, fg="#cdcecc", axes = FALSE, xlab=".o0o.", bg=FALSE)
plot(line2 <- c(asin((x+3)/64)+atan(x/64)*10000), col="blue", pch=14)
plot(line3 <- c(1000+sin(x/5)+tan(x/10)*200), col="brown")

## musical 3
plot(bass <- c((sin((x)/500)+sin((x)/10)+sin((x)/10+sin((x)/80))+sin((x+10)/20)+sin((x+10)/90))*100),  col="#cd6858", pch=6+x%%4, fg="#cdcecc", axes = FALSE, xlab=".o0o.", bg=FALSE)
plot(line2 <- c(440+cot(x/4)*440), col="blue", pch=14)
plot(line3 <- c(1500+csc(x/4)*100), col="brown")



## no trigonometricas


## from video
plot(bass <- c(3/4*(sin(x))*1/4*(sin(3*x)),  col="red"))
## plot(line2 <- c(sin(x/210)+sin(2*x/10)*1000), col="blue")
plot(line3 <- c(440+sin(x)/5), col="brown")




## pony jump
plot(bass <- c((sin((x+10)/500)+sin((x+5)/10)+sin((x+10)/10+sin((x+10)/80))+sin((x+10)/20)+sin((x+10)/90))*100),  col="#cd6858", pch=6+x%%4, fg="#cdcecc", axes = FALSE, xlab=".o0o.", bg=FALSE)
plot(line2 <- c(sin(x/210)+sin(x/10)+sin(x/40)*1000), col="blue", pch=14)
plot(line3 <- c(440+sin(x)/10), col="brown")

## steady
plot(bass <- c(55+sin(x/20)))
plot(line2 <- c(440+sin(x/20)))
 plot(line3 <- c(440+sin(x)/10), col="brown")

## ------------- tools
## --- colors
plot(line3 <- c(1000+sin(x/8)*10000), pch=16,col=rainbow(10+sin(x*0), alpha=1), fg=3)
## --- draws
qplot(mpg, data=as.data.frame(c(1000+sin(x/8)*10000)), geom="density", fill=65, alpha=0.5, colour=1)


x <- seq(0,64, 1)

## change amplitude: sin(x)*a
plot(line3 <- c(1000+sin(x/8)*10000), pch=16,col=rainbow(10+sin(x*0), alpha=1), fg=3)
## change phase: sin(x+pi)
plot(line3 <- c(1000+sin((x+pi*1)/5)*1000))
## change frequency sin(x/b)
plot (line3 <- c(1000+sin(x/20)*1000))

curve(sin(x)-sin(x)) # reset graph


##
plot(curve <- c(440+(sin(x/2)+sin(x))*64), col= "grey")+ theme(plot.background = element_rect(fill = "darkblue"))
points(freqL1 <- magneticGrid(notes, curve), col = "darkgreen")
write(freqL1, file="freqL2.txt", ncolumns = 1)

## experimental
plot(bass <- c((sin((x)/500)+sin((x)/10)+sin((x)/10+sin((x)/80))+sin((x+10)/20)+sin((x+10)/90))*100),  col="#cd6858", pch=6+x%%4, fg="#cdcecc", axes = FALSE, xlab=".o0o.", bg=FALSE)
x <- x+pi*1.
plot(line2 <- c(250+csc((x+(pi*0.1)/tan(x/2))*1000)), col="blue", pch=19) 
plot(line3 <- c(440+csc((x+(pi*0.2))/sin(x))*10), col="brown", pch=19) ## interesante

## basic
plot(bass <- c(55+sin(x)+tan(x*2/10)*50), col="green")
plot(line2 <- c(440+tan(x/4)*10), col="blue")
(line2 <- c(880+tan(x/4)*.5), col="green")


plot(sin(x), cex=0.1)
plot(sin(x)+sin(2*x), cex=0.1)

plot(sin(x*1.8)+cos(x*4), cex=0.1)
plot(sin(x*1.3)/exp(x/18)+cos(x*4), cex=0.1) ## expo negativo y sin
plot(sin(x/x)/sin(x/8), cex=0.1)

## bass
plot(sin(x)/tan(x/4000), cex=0.1) ## estable
plot(sin(x)+sin(x/8)+tan(x/400)*200, cex=0.1)


## write file
plot(bass <- c(sin(x)/tan(x/40*x))) ## getting down
plot(bass <- c(x*sin(x)/exp(x*x)*10000)) ## sigmoid alike

## fabs
plot(bass <- c(sin(x)/tan(x*40))*5000)
plot(line2 <- c(sin(x/10)/sin(x*2)*4000), col="blue")http://son0p.net/functions/functionsInMusic.html

## S1 
plot(bass <- c(cos(x/16)*100), col="red")
plot(line2 <- c(sin(x/10)/sin(x*2)*4000), col="blue")
plot(line3 <- c(sin(x)+sin(x*x)*1024), col="brown")

## s1b
plot(bass <- c(cos(x/16)*2000), col="red")
plot(line2 <- c(sin(x/10)/sin(x*2)*4000), col="blue")
plot(line3 <- c(sin(x)+sin(x*x)*1024), col="brown")

## S2 // new test
plot(bass <- c(sin(x/16)+sin(x/16)*100), col="red")
plot(line2 <- c(sin(x/10)/sin(x*4)*100), col="blue")
plot(line3 <- c(4*sin(x/10)+sin(x*2)*100), col="brown")

## S3 air // new test 
plot(bass <- c(20+tan(x/2)+tan(x*2)*10), col="red")
plot(line2 <- c(sin(x)+tan(x*10)*100), col="blue")
plot(line3 <- c(sin(x/10)+sin(x/8)*500), col="brown")

## S4
plot(bass <- c(sin(x/10)*10),  col="red") 
plot(line2 <- c(sin(x/210)+sin(2*x/10)*1000), col="blue")
plot(line3 <- c(sin(x/10)+sin(x*2)*tan(x/10)*1000), col="brown")

## Sx test ERR:no cambia
curve(bass <- c(sin(x)*10),  col="red", from=0, to=1000) 
curve(line2 <- c(sin(x/210)+sin(2*x/10)*10), add=TRUE, col="blue")
plot(line3 <- c(1000+tan(x/4)*1000,  col="brown"))


## fav
plot(bass <- c(cos(x/32)*55), col="red")
plot(line2 <- c(220+sin(x/2)*110), col="blue")
plot(line3 <- c(440+sin(x)/10000), col="brown")

## steady lines
plot(bass <- c(100+sin(x/100),  col="red"))
plot(line2 <- c(sin(x/210)+sin(2*x/10)*1000), col="blue")
plot(line3 <- c(440+sin(x)/10000), col="brown")

## legado
## informacion del archivo viejo de chuck
##//  // --------  generación de escalas
## //[root/16,root/8, root/2, root/4, root, root*4, root*2, root*1.189207115, root*1.3348398542, root*1.4983070769, root*1.7817974363, root*1.6817928305] @=> float ref[];

// [2,1,4,1,4] @=> int aeolianPent[];
// scaleGenerator(65.406391, aeolianPent);
// [2,1,4,1,4] @=> int aeolianPent[];
// scaleGenerator(65.406391, aeolianPent);


lib.semitonesGen(220,2200) @=> float notes2[]; 
lib.semitonesGen(440,4400) @=> float notes3[];

[0,3,5,7,10] @=> int minorPenta[];
lib.scaleGenerator(notes1,minorPenta) @=> scale1;
lib.scaleGenerator(notes2,minorPenta) @=> scale2;
lib.scaleGenerator(notes3,minorPenta) @=> scale3;

## como las frecuencias vienen de una función trigonometrica que es continua, se necesita que cada frecuencia de un vector src  se convierta en la frecuencia válida mas cercana a un vector ref que esta definido por la escala FAIL 
magneticGrid2 <- function(ref, src){
  index <- 1
  difference <- abs(src - ref[1])
  for(i in 1:length(ref)){
    if( difference > abs(src - ref[i])){
      difference <- abs(src - ref[i])
      index <- i
    }
  }
  return(ref[index])
}
