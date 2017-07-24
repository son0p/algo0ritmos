x <- seq(0,64, 1)

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
plot(line2 <- c(sin(x/10)/sin(x*2)*4000), col="blue")

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

curve(sin(x)-sin(x)) # reset graph

write(bass, file="bass.txt", ncolumns=1)
write(line2, file="line2.txt", ncolumns=1)
write(line3, file="line3.txt", ncolumns=1)


