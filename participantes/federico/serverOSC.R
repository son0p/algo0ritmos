library(tuneR)
library(ROSC)
source("ecuaciones.R")

## ====== VARIABLES ====
address.with.wildcards <- "/{th,s}ing/n[2-4]/red*"
## Define host and port
HOST <- "255.255.255.255" # this ip address means "all ip addresses on the local subnet"
LOCALHOST <- "localhost" # equivalent to "127.0.0.1", i.e. your own machine
PORT <- 6449 # recipient must listen on this port number.  Use any number in the thousands.

## ==== FUNCTIONS ====
# Wrapper for system("oscchief send")
oscchief.send <- function (host="localhost", port=6449, osc="/") {
    osc <- gsub(",","",osc) # strip type tag comma for compatibility with oscchief
    #print(osc)
    command <- paste("oscchief send", host, port, osc)
    system(command)
}
##test <- c("f", "59.99999")

toOsc <- function(dataToOsc, address){
    lapply(dataToOsc, function(x){
        msg <- oscMessage(address = address, data = x, double =  "f")
        oscchief.send(host=LOCALHOST, port=PORT, osc= msg)
    })
}

toOscTyped <- function(dataToOsc, address, type){
        msg <- paste(address, type, dataToOsc)
        command <-  paste("oscchief send", "localhost", 6449, address, type, dataTest )
        system(command)
}

## === TEST ==
dataTest <- ((0:100))/100
dataTest <- paste(as.character(dataTest),collapse=" ")
type <- paste(rep("f", 100), collapse = "")
toOscTyped(dataTest, "/ffxf/step1", type)
## =END TEST=

## GENERATORS
## - Euclidean Generator
## from aggaz http://electro-music.com/forum/topic-62215.htm
## c: current step number
## k: hits per bar
## n: bar length
## r: rotation
euclide <- function(c, k, n, r){
  return((((c+r) * k) %% n) < k)
}

euclidean.generator <- function(hitsPerBar, barLength, rotation){
    i <- 0
    vec <- c()
    while (i < 16){
        vec <- c(vec, euclide(i, hitsPerBar, barLength, rotation))
        i <- i+1
    }
    return(as.numeric(vec))
}
## euclidean.generator( 7, 12, 4) ## TEST

## - Read MIDI
midi1 <- readMidi("/home/ffx1/Projects/caminar_sin_ti_ardour/interchange/caminar_sin_ti_ardour/midifiles/gtr2-6.mid")
midi1Notes <- midi1$parameter1[!is.na(midi1$parameter1)]
data9 <- midi1Notes^2
data9 <- data9[32:64]

## == ARRAY CONSTRUCTION ==
notes <- semitonesGen(32.7031956626, 20000)
scaleJumps <- c(2,2,1,2,2,2,1)
scaleGenerator(notes,scaleJumps )
notes + notes[scaleJumps]

data9 <- as.integer(seq(runif(1, min=50 , max=299),runif(1, min=300, max=5000), length.out=16))

data9 <- as.integer(sample(notes,16))

dataBass <- as.integer(seq(runif(1, min=50 , max=5000),runif(1, min=30, max=100), length.out=16))
dataBass <-  as.integer(sample(subset(notes, x > 200 ),16))
dataBD <-  as.integer(c(1,0,0,0,1,0,0,0,1,0,0,0,1,0,1,0))

x <- c(1:16)
xAxis <- c(1:16)

data9 <-  cos(x*0.2)/32
data9 <-   offsetTrigo(20, data9 ,20000)
data9 <-   as.integer(magneticGrid(notes, data9))
##draw()
Update.all()

dataBass <-  tan(x/0.1)/8*tan(x)/24
dataBass <-  offsetTrigo(20, dataBass ,20000)
dataBass <-  as.integer(magneticGrid(notes, dataBass))
##draw()
Update.all()

dataBD       <- as.integer(euclidean.generator(4, 16, 0))
dataSN       <- as.integer(euclidean.generator(2, 16, 4))
dataHH       <- as.integer(euclidean.generator(4, 16, 2))
dataEnvBass  <- as.integer(euclidean.generator(12, 16, 0))
dataEnvNotes <- as.integer(euclidean.generator(12, 24, 4))
##draw()
Update.all()

## == APPLY CHANGES
## send OSC
Update.all <- function (){
    toOsc(data9, "/audio/1/int")
    toOsc(dataEnvNotes, "/audio/1/envNotes")
    toOsc(dataBass, "/audio/2/bass" )
    toOsc(dataBD, "/audio/2/bd ")
    toOsc(dataSN, "/audio/2/sn")
    toOsc(dataHH, "/audio/2/hh")
}

## == MUTES ==
## mutes
data9 <-  as.integer(rep(0, 16))
dataBass <- as.integer(rep(0, 16))
Update.all()

## == CAPTURE FAVORITES ==
rec1 <- data9
rec1bass <-dataBass
rec2 <- data9
rec2bass <-dataBass
## favs
data9 <- rec1
dataBass <- rec1bass

## == STRUCTURE BUILDER ==

## ==== CHARTS =======

## draw
draw  <- function(){
    points <- as.data.frame(cbind(data9, dataBass, dataBD, dataSN, dataHH, xAxis))
    points.long <- melt(points, id="xAxis", measure =c("data9", "dataBass", "dataBD", "dataSN", "dataHH"))
    ggplot(points.long, aes(xAxis, value, colour = variable, size = 3)  ) +
        geom_point()+
        facet_wrap(points.long$variable ~ ., scales="free_y", ncol=1)+
        theme_wsj()+
        scale_color_stata(scheme = "s2color")+
       ## markers = points.long$value+
        labs(x="Time", y="Value")
}

## ======== Reasoning  ================
## ==== Music as List data structure options

x <- vector(mode = "list" , length = 3)
x[[1]] <- c(52,55,60,0,10) ## midi notes
x[[2]] <- c(list(0,10,3,0), list(0,10,3,0), list(0,10,3,0), list(0,10,3,0), list(0,10,3,0)) ## ASRR note 1
x
x[[1]][2]  ## query note
x[[2]][2] ## query ADSR
## JSON

## YAML


## ======= end Reasoning

### ================= RESOURCES ===========
## ## Example data to pack into OSC messages
## data1 <-  12.5
## data2 <- 6:8
## data3 <- list(list(3:4,"apple"), TRUE, list(list(5.1,"foo"),NULL))

## ## Example of a manual type string for data3
## data3_typestring <- ",iiSidSN"
## data8 <- 0:15*0.01
## lapply(data8, function(x){
##     OSC8 <- oscMessage(address = address, data = x, double="f") 
##     oscchief.send(host=HOST, port=PORT, osc=OSC8)
## })

## ## Example OSC messages  ## TODO solo funciona el string data 1 
## OSC1 <- oscMessage(address = address, data = data1, double="f")
## OSC2 <- oscMessage(address = address, data = data2, typecomma=FALSE) # remove comma from typstring
## OSC3 <- oscMessage(address = address, data = data3) # now with a nested list of mixed data types
## OSC4 <- oscMessage(address = address, data = data3, double = "f") # convert doubles to 32bit floats
## OSC5 <- oscMessage(address = address, data = data3, logical = "integer") # convert logical to ints


## ## Send OSC messages
## oscchief.send(host=HOST, port=PORT, osc=OSC1)
## oscchief.send(host=HOST, port=PORT, osc=OSC2)
## oscchief.send(host=HOST, port=PORT, osc=OSC3)
## oscchief.send(host=HOST, port=PORT, osc=OSC4)
## oscchief.send(host=HOST, port=PORT, osc=OSC5)
## oscchief.send(host=HOST, port=PORT, osc=test)

## TEST:send an integer array
## x <- 1
## repeat {
##     print(x)
##     x = x+1
##     data9 <- as.integer(seq(runif(1, min=50 , max=299),runif(1, min=300, max=5000), length.out=16))
##     lapply(data9, function(x){
##         OSC9 <- oscMessage(address = address2, data = x, integer = "i") 
##         oscchief.send(host=HOST, port=PORT, osc=OSC9)
##     })
##     Sys.sleep(2.4);
##     if (x == 10){
##         break
##     }
## }
## -- Euclidean generator NOT WORKING
## fun int[] euclideangenerator ( int pulses, int steps ) {
##     // @jazzmonster Euclidean rhythm generator based Bresenhams algorithm
##         // pulses - amount of pulses
##         // steps - amount of discrete timing intervals
##         int seq[steps];
##         int error;
##         for ( int i; i < steps; i++ ) {
##             error + pulses => error;
##             if ( error > 0 ) {
##                 true => seq[i];
##                 error - steps => error;
##             } else {
##                 false => seq[i];
##             }
##         }
##         returnseq; 
##     }
## }
