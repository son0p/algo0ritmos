x <- seq(0,10, 0.01)
plot(sin(x), cex=0.1)
plot(sin(x)+sin(2*x), cex=0.1)

plot(sin(x*1.8)+cos(x*4), cex=0.1)
plot(sin(x*1.3)/exp(x/18)+cos(x*4), cex=0.1) ## expo negativo y sin
plot(sin(x/x)/sin(x/8), cex=0.1)

## bass
plot(sin(x)/tan(x/4000), cex=0.1) ## estable
plot(sin(x)+sin(x/8)+tan(x/400)*200, cex=0.1)


## write file
plot(bass <- c(sin(x)/tan(x/4000), cex=0.1)) ## fav
plot(bass <- c((sin(x/2)*tan(x/100)*1000000), cex=0.1))

write(bass, file="bass.txt", ncolumns=1)

