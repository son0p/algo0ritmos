x <- seq(0,1, 0.01)

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



bass <- c(sin(x)*100)
line2 <- c(sin(x)*500)
line3 <- c(sin(x)*1000)

write(bass, file="bass.txt", ncolumns=1)
write(line2, file="line2.txt", ncolumns=1)
write(line3, file="line3.txt", ncolumns=1)

curve(line2)
