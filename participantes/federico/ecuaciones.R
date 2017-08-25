install.packages("rmarkdown")
library(ggplot2)
library(pracma)

x <- seq(0,64, 1)

## change amplitude: sin(x)*a
plot(line3 <- c(1000+sin(x/8)*10000), pch=16,col=rainbow(10+sin(x*0), alpha=1), fg=3)
 ## change phase: sin(x+pi)
plot(line3 <- c(1000+sin((x+pi*1)/5)*1000))
## change frequency sin(x/b)
plot (line3 <- c(1000+sin(x/20)*1000))

curve(sin(x)-sin(x)) # reset graph

write(l1, file="bass.txt", ncolumns=1)
write(l2, file="line2.txt", ncolumns=1)
write(l3, file="line3.txt", ncolumns=1)

## basic
l1 <- c(55+sin(x)+tan(x*2/10)*50)
l2 <- c(440+tan(x)*1)
l3 <- c(880+sin(x/4)*200)
draw(x,l1,l2,l3)
writeFiles(l1,l2,l3)


draw <- function(x,l1,l2,l3){
  df <- data.frame(x,l1,l2,l3)
  ggplot(df, aes(x))+
    geom_line(aes(y=l1), colour="green")+
    geom_line(aes(y=l2), colour="blue")+
    geom_line(aes(y=l3), colour="brown")
}

writeFiles <- function(l1,l2,l3){
  write(l1, file="bass.txt", ncolumns=1)
  write(l2, file="line2.txt", ncolumns=1)
  write(l3, file="line3.txt", ncolumns=1)
}



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


## -------- Legacy

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



