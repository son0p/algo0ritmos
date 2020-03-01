library(ROSC)

## Example OSC address patterns
address <- "/audio/1/foo"
address.with.wildcards <- "/{th,s}ing/n[2-4]/red*"

## Example data to pack into OSC messages
data1 <-  12.9
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

                                        # Send OSC messages


oscchief.send(host=HOST, port=PORT, osc=OSC1)

oscchief.send(host=HOST, port=PORT, osc=OSC2)

oscchief.send(host=HOST, port=PORT, osc=OSC3)

oscchief.send(host=HOST, port=PORT, osc=OSC4)

oscchief.send(host=HOST, port=PORT, osc=OSC5)

oscchief.send(host=HOST, port=PORT, osc=test)

data8 <- 1:10*0.1
lapply(data8, function(x){
   OSC8 <- oscMessage(address = address, data = x, double="f") 
   oscchief.send(host=HOST, port=PORT, osc=OSC8)
    })
