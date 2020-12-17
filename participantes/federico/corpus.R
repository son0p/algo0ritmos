rm(list=ls())

if(!require(plyr)){install.packages("plyr")}
if(!require(tuneR)){install.packages("tuneR")}
library(ROSC)

## ======= FUNCTIONS =======
toOscTyped <- function(dataToOsc, address, type){
    msg <- paste(address, type, dataToOsc)
    command <-  paste("oscchief send", "localhost", 6449, address, type, dataToOsc )
    system(command)
}

## ===================

## extended 16 steps with 8 observations
s1 <- c(1 ,0,0,0,    0, 12, 0, 0,   11,0,0,0,    0,0,0,0)
s2 <- c(NA,0,0,0,    0, 0, 0, 0,    11,0,0,0,    0,0,0,0)
s3 <- c(NA,0,0,0,    0, 0, 0, 0,    11,0,0,0,    0,0,0,0)
s4 <- c(NA,0,0,0,    0, 5, 0, 0,    6,0,0,0,    0,0,0,0)
s5 <- c(NA,0,0,0,    0, 0, 0, 0,    0,0,0,0,    0,0,0,0)
s6 <- c(NA,0,0,0,    0, 3, 0, 0,    0,0,0,0,    0,0,0,0)
s7 <- c(NA,0,0,0,    0, 0, 0, 0,    0,0,0,0,    0,0,0,0)
s8 <- c(NA,0,0,0,    0, 3, 0, 0,    0,0,0,0,    0,0,0,0)
mCorpus <- rbind(s1, s2, s3, s4, s5, s6, s7, s8)

##TODO Abstract moving parts to make it a function
## contar los elementos únicos
count1 <- (data.frame(table(mCorpus[,1])))
## calcular su participación porcentual
count1$percent <- count1$Freq/ sum(count1$Freq)
count1$step <- 1  ## factor
count2 <- (data.frame(table(mCorpus[,2])))
count2$percent <- count2$Freq/ sum(count2$Freq)
count2$step <- 2
count3 <- (data.frame(table(mCorpus[,3])))
count3$percent <- count3$Freq/ sum(count3$Freq)
count3$step <- 3
count4 <- (data.frame(table(mCorpus[,3])))
count4$percent <- count4$Freq/ sum(count4$Freq)
count4$step <- 4
count5 <- (data.frame(table(mCorpus[,5])))
count5$percent <- count5$Freq/ sum(count5$Freq)
count5$step <- 5
count6 <- (data.frame(table(mCorpus[,6])))
count6$percent <- count6$Freq/ sum(count6$Freq)
count6$step <- 6
count7 <- (data.frame(table(mCorpus[,7])))
count7$percent <- count7$Freq/ sum(count7$Freq)
count7$step <- 7
count8 <- (data.frame(table(mCorpus[,8])))
count8$percent <- count8$Freq/ sum(count8$Freq)
count8$step <- 8
count9 <- (data.frame(table(mCorpus[,9])))
count9$percent <- count9$Freq/ sum(count9$Freq)
count9$step <- 9
count10 <- (data.frame(table(mCorpus[,10])))
count10$percent <- count10$Freq/ sum(count10$Freq)
count10$step <- 10
count11 <- (data.frame(table(mCorpus[,11])))
count11$percent <- count11$Freq/ sum(count11$Freq)
count11$step <- 11
count12 <- (data.frame(table(mCorpus[,12])))
count12$percent <- count12$Freq/ sum(count12$Freq)
count12$step <- 12
count13 <- (data.frame(table(mCorpus[,13])))
count13$percent <- count13$Freq/ sum(count13$Freq)
count13$step <- 13
count14 <- (data.frame(table(mCorpus[,14])))
count14$percent <- count14$Freq/ sum(count14$Freq)
count14$step <- 14
count15 <- (data.frame(table(mCorpus[,15])))
count15$percent <- count15$Freq/ sum(count15$Freq)
count15$step <- 15
count16 <- (data.frame(table(mCorpus[,16])))
count16$percent <- count16$Freq/ sum(count16$Freq)
count16$step <- 16

## percent distribution of in each step
dfMcorpus <- rbind(count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15, count16 )
dfMcorpus
## selecionamos un factor
fact6 <- dfMcorpus[dfMcorpus$step %in% 6, ]
## extraemos los  vectores de interes
values <- as.numeric(as.character(fact6$Var1))
pcts <- fact6$percent * 100
n <- sum(pcts)
res1 <- rep(values, floor(pcts))
set.seed(1512)
res2 <- sample(values, n - length(res1), prob=pcts)
result <- c(res1, res2)
## -- prepare  OSC boundle
result <- paste(as.character(result),collapse=" ")
type <- paste(rep("f", 100), collapse = "")
toOscTyped(result, "/ffxf/step1", type)

