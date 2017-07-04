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
plot(bass <- c(cos(x/16)*200), col="red")
plot(line2 <- c(sin(x/10)/sin(x*2)*4000), col="blue")
plot(line3 <- c(sin(x)+sin(x*x)*1024), col="brown")

## S2
plot(bass <- c(sin(x/162)+cos(x/16)*200), col="red")
plot(line2 <- c(sin(x/10)/sin(x*4)*1000), col="blue")
plot(line3 <- c(sin(x/10)+sin(x*2)*1000), col="brown")

## S3 air
plot(bass <- c(sin(x/20.8)+cos(x*4)*200), col="red")
plot(line2 <- c(sin(x/10)/sin(x*4)*1000), col="blue")
plot(line3 <- c(sin(x/10)+sin(x*2)*4000), col="brown")



write(bass, file="bass.txt", ncolumns=1)
write(line2, file="line2.txt", ncolumns=1)
write(line3, file="line3.txt", ncolumns=1)


