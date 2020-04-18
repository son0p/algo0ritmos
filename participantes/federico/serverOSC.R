library(ROSC)
source("ecuaciones.R")
## Example OSC address patternsaddress <- "/audio/1/float"
address2 <- "/audio/1/int"
bass <- "/audio/2/bass"
address.with.wildcards <- "/{th,s}ing/n[2-4]/red*"

## Example data to pack into OSC messages
data1 <-  12.5
data2 <- 6:8
data3 <- list(list(3:4,"apple"), TRUE, list(list(5.1,"foo"),NULL))

## Example of a manual type string for data3
data3_typestring <- ",iiSidSN"

## Example OSC messages  ## TODO solo funciona el string data 1 
OSC1 <- oscMessage(address = address, data = data1, double="f")
OSC2 <- oscMessage(address = address, data = data2, typecomma=FALSE) # remove comma from typstring
OSC3 <- oscMessage(address = address, data = data3) # now with a nested list of mixed data types
OSC4 <- oscMessage(address = address, data = data3, double = "f") # convert doubles to 32bit floats
OSC5 <- oscMessage(address = address, data = data3, logical = "integer") # convert logical to ints



# Wrapper for system("oscchief send")
oscchief.send <- function (host="localhost", port=12345, osc="/") {
    osc <- gsub(",","",osc) # strip type tag comma for compatibility with oscchief
    command <- paste("oscchief send", host, port, osc)
    system(command)
}

test <- c("f", "59.99999")
                                        # Define host and port
HOST <- "255.255.255.255" # this ip address means "all ip addresses on the local subnet"
LOCALHOST <- "localhost" # equivalent to "127.0.0.1", i.e. your own machine
PORT <- 6449 # recipient must listen on this port number.  Use any number in the thousands.

## Send OSC messages
oscchief.send(host=HOST, port=PORT, osc=OSC1)
oscchief.send(host=HOST, port=PORT, osc=OSC2)
oscchief.send(host=HOST, port=PORT, osc=OSC3)
oscchief.send(host=HOST, port=PORT, osc=OSC4)
oscchief.send(host=HOST, port=PORT, osc=OSC5)
oscchief.send(host=HOST, port=PORT, osc=test)

data8 <- 0:15*0.01
lapply(data8, function(x){
   OSC8 <- oscMessage(address = address, data = x, double="f") 
   oscchief.send(host=HOST, port=PORT, osc=OSC8)
})

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

## ====== MUSIC CONSTRUCTION
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
data9 <-  tan(x-16) %>%
    offsetTrigo(410, . ,128) %>%
    as.integer(magneticGrid(notes, data9))

dataBass <-  sin(x/8) %>%
    offsetTrigo(50, . ,128) %>%
    as.integer(magneticGrid(notes, dataBass))


## chart
points <- as.data.frame(cbind(data9, dataBass, xAxis))
points.long <- melt(points, id="xAxis", measure =c("data9", "dataBass"))
## draw
ggplot(points.long, aes(xAxis, value, colour = variable)  ) +
  geom_point()+
  facet_wrap(points.long$variable ~ ., scales="free_y", ncol=1)+
  theme_stata()+
  scale_colour_canva(palette = "Sunny and calm")+
    labs(x="Time", y="Value")
## send OSC

lapply(data9, function(x){
    OSC9 <- oscMessage(address = address2, data = x, integer = "i") 
    oscchief.send(host=HOST, port=PORT, osc=OSC9)
})

lapply(dataBass, function(x){
    oscBass <- oscMessage(address = bass, data = x, integer = "i") 
    oscchief.send(host=HOST, port=PORT, osc=oscBass)
})


rec1 <-data9
rec1bass <-dataBass
## favs
data9 <- rec1
dataBass <- rec1bass

## mutes
data9 <-  as.integer(rep(0, 16))
dataBass <- as.integer(rep(0, 16))


