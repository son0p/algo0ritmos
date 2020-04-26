library(ROSC)
source("ecuaciones.R")

## ====== VARIABLES ====
## Example OSC address patterns
address <- "/audio/1/float"
address2 <- "/audio/1/int"
bass <- "/audio/2/bass"
bd <- "/audio/2/bd"
address.with.wildcards <- "/{th,s}ing/n[2-4]/red*"
## Define host and port
HOST <- "255.255.255.255" # this ip address means "all ip addresses on the local subnet"
LOCALHOST <- "localhost" # equivalent to "127.0.0.1", i.e. your own machine
PORT <- 6449 # recipient must listen on this port number.  Use any number in the thousands.

## ==== FUNCTIONS ====
# Wrapper for system("oscchief send")
oscchief.send <- function (host="localhost", port=12345, osc="/") {
    osc <- gsub(",","",osc) # strip type tag comma for compatibility with oscchief
    command <- paste("oscchief send", host, port, osc)
    system(command)
}

test <- c("f", "59.99999")

## - Euclidean Generator
## from aggaz http://electro-music.com/forum/topic-62215.html
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
    while (i < 12){
        vec <- c(vec, euclide(i, hitsPerBar, barLength, rotation))
        i <- i+1
    }
    return(as.numeric(vec))
}
## euclidean.generator( 7, 12, 4) ## TEST  

## == MUSIC CONSTRUCTION ==
notes <- semitonesGen(32.7031956626, 20000)
scaleJumps <- c(2,2,1,2,2,2,1)
scaleGenerator(notes,scaleJumps )
notes + notes[scaleJumps]

data9 <- as.integer(seq(runif(1, min=50 , max=299),runif(1, min=300, max=5000), length.out=16))

data9 <- as.integer(sample(notes,16))

dataBass <- as.integer(seq(runif(1, min=50 , max=5000),runif(1, min=30, max=100), length.out=16))
dataBass <-  as.integer(sample(subset(notes, x > 200 ),16))

x <- c(1:16)
xAxis <- c(1:16)

data9 <-  200+sin(x)*choose((x*2),2)
data9 <-   offsetTrigo(410, . ,128)
data9 <-   as.integer(magneticGrid(notes, data9))
draw()

dataBass <-  sin(x/8)*sin(x/4)*sin(x)
dataBass <-  offsetTrigo(50, dataBass ,128)
dataBass <-  as.integer(magneticGrid(notes, dataBass))
draw()

dataBD <-  as.integer(c(1,0,0,0,1,0,0,0,1,0,0,0,1,0,1,0))
draw()

## == APPLY CHANGES
## send OSC
lapply(data9, function(x){
    OSC9 <- oscMessage(address = address2, data = x, integer = "i")
    oscchief.send(host=HOST, port=PORT, osc=OSC9)
})

lapply(dataBass, function(x){
    oscBass <- oscMessage(address = bass, data = x, integer = "i")
    oscchief.send(host=HOST, port=PORT, osc=oscBass)
})

lapply(dataBD, function(x){
    oscBD <- oscMessage(address = bd, data = x, integer = "i")
    oscchief.send(host=HOST, port=PORT, osc=oscBD)
})

## == MUTES ==
## mutes
data9 <-  as.integer(rep(0, 16))
dataBass <- as.integer(rep(0, 16))

## == CAPTURE FAVORITES ==
rec1 <-data9
rec1bass <-dataBass
## favs
data9 <- rec1
dataBass <- rec1bass


## ==== CHARTS =======

## draw
draw  <- function(){
    points <- as.data.frame(cbind(data9, dataBass, dataBD, xAxis))
    points.long <- melt(points, id="xAxis", measure =c("data9", "dataBass", "dataBD"))
    ggplot(points.long, aes(xAxis, value, colour = variable, size = 4)  ) +
        geom_point()+
        facet_wrap(points.long$variable ~ ., scales="free_y", ncol=1)+
        theme_wsj()+
        scale_color_stata(scheme = "s2color")+
        labs(x="Time", y="Value")
}

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
