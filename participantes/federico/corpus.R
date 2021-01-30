#rm(list=ls())

## if(!require(plyr)){install.packages("plyr")}
## if(!require(dplyr)){install.packages("dplyr")}
## if(!require(magrittr)){install.packages("magrittr")}
## if(!require(tuneR)){install.packages("tuneR")}
##if(!require(profvis)){install.packages("profvis")}
##if(!require(R.utils)){install.packages("R.utils")}
## library(ROSC)
##library(R.utils)
#profvis({
## ======= FUNCTIONS =======
toOscTyped <- function(dataToOsc, address, port, type){
    msg <- paste(address, type, dataToOsc)
    command <-  paste("oscchief send", "localhost", port, address, type, dataToOsc )
    system(command)
}

## ===================

## extended 16 steps with 8 observations, distances from root, [temporal convention: -1 = silence, 0 = root, 12 = octave ] 
##s1 <- c( 0, 0,-1,-1,    -1, 3,-1,-1,     0,-1,-1, 0,    -1,-1,-1,-1)

s1<- replace(rep(-1,16), c(4,8), 0)## create a vector of size 16 filled with -1, and replace certain positions
s2<- replace(rep(-1,16), c(4,8), 0)
s3<- replace(rep(-1,16), c(4,8), 0)
s4<- replace(rep(-1,16), c(4,8), 0)
s5<- replace(rep(-1,16), c(4,8), 0)
s6<- replace(rep(-1,16), c(4,8), 0)
s7<- replace(rep(-1,16), c(4,8), 0)
s8<- replace(rep(-1,16), c(4,8), 0)
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
count4 <- (data.frame(table(mCorpus[,4])))
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
##dfMcorpus

## ## TEST to abstract TODO
## bundle <- rep(NA, 16)
## ##FAIL
## for(i in bundle){
##           testPercent <-dfMcorpus[dfMcorpus$step %in% 1, ] %>%
##             select(percent) %$%
##             as.numeric(percent)
##         dfMcorpus[dfMcorpus$step %in% 1, ] %>%
##         select(Var1) %$% sample(as.numeric(as.character(Var1)), 1, prob = testPercent )
## }


## ## DONE TEST but two branchas of pipes and just 1 value
## testPercent <-dfMcorpus[dfMcorpus$step %in% 6, ] %>%
##     select(percent) %$%
##     as.numeric(percent)
## dfMcorpus[dfMcorpus$step %in% 6, ] %>%
##     select(Var1) %$% sample(as.numeric(as.character(Var1)), 1, prob = testPercent )

## === END TEST

## TODO abstract to a function
## selecionamos un factor
fact1 <- dfMcorpus[dfMcorpus$step %in% 1, ]
## extraemos los  vectores de interes convirtiendo de factor a numeric
values <- as.numeric(as.character(fact1$Var1))
pcts <- fact1$percent
stp1 <- sample(values, 1, prob=pcts)
fact2 <- dfMcorpus[dfMcorpus$step %in% 2, ]
values <- as.numeric(as.character(fact2$Var1))
pcts <- fact2$percent
stp2 <- sample(values, 1, prob=pcts)
fact3 <- dfMcorpus[dfMcorpus$step %in% 3, ]
values <- as.numeric(as.character(fact3$Var1))
pcts <- fact3$percent
stp3 <- sample(values, 1, prob=pcts)
fact4 <- dfMcorpus[dfMcorpus$step %in% 4, ]
values <- as.numeric(as.character(fact4$Var1))
pcts <- fact4$percent
stp4 <- sample(values, 1, prob=pcts)
fact5 <- dfMcorpus[dfMcorpus$step %in% 5, ]
values <- as.numeric(as.character(fact5$Var1))
pcts <- fact5$percent
stp5 <- sample(values, 1, prob=pcts)
fact6 <- dfMcorpus[dfMcorpus$step %in% 6, ]
values <- as.numeric(as.character(fact6$Var1))
pcts <- fact6$percent
stp6 <- sample(values, 1, prob=pcts)
fact7 <- dfMcorpus[dfMcorpus$step %in% 7, ]
values <- as.numeric(as.character(fact7$Var1))
pcts <- fact7$percent
stp7 <- sample(values, 1, prob=pcts)
fact8 <- dfMcorpus[dfMcorpus$step %in% 8, ]
values <- as.numeric(as.character(fact8$Var1))
pcts <- fact8$percent
stp8 <- sample(values, 1, prob=pcts)
fact9 <- dfMcorpus[dfMcorpus$step %in% 9, ]
values <- as.numeric(as.character(fact9$Var1))
pcts <- fact9$percent
stp9 <- sample(values, 1, prob=pcts)
fact10 <- dfMcorpus[dfMcorpus$step %in% 10, ]
values <- as.numeric(as.character(fact10$Var1))
pcts <- fact10$percent
stp10 <- sample(values, 1, prob=pcts)
fact11 <- dfMcorpus[dfMcorpus$step %in% 11, ]
values <- as.numeric(as.character(fact11$Var1))
pcts <- fact11$percent
stp11 <- sample(values, 1, prob=pcts)
fact12 <- dfMcorpus[dfMcorpus$step %in% 12, ]
values <- as.numeric(as.character(fact12$Var1))
pcts <- fact12$percent
stp12 <- sample(values, 1, prob=pcts)
fact13 <- dfMcorpus[dfMcorpus$step %in% 13, ]
values <- as.numeric(as.character(fact13$Var1))
pcts <- fact13$percent
stp13 <- sample(values, 1, prob=pcts)
fact14 <- dfMcorpus[dfMcorpus$step %in% 14, ]
values <- as.numeric(as.character(fact14$Var1))
pcts <- fact14$percent
stp14 <- sample(values, 1, prob=pcts)
fact15 <- dfMcorpus[dfMcorpus$step %in% 15, ]
values <- as.numeric(as.character(fact15$Var1))
pcts <- fact15$percent
stp15 <- sample(values, 1, prob=pcts)
fact16 <- dfMcorpus[dfMcorpus$step %in% 16, ]
values <- as.numeric(as.character(fact16$Var1))
pcts <- fact16$percent
stp16 <- sample(values, 1, prob=pcts)

## RESULT 
resultVec <-c(stp1,stp2,stp3,stp4,stp5,stp6,stp7,stp8,stp9,stp10,stp11,stp12,stp13,stp14,stp15,stp16 )

## MODS based on RESULT
## complement, TODO never touch the steps after a sincopa
options <- c(-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,12,51)
resultComp <- ifelse(resultVec == -1, sample(options) , -1)


## -- prepare  OSC boundles
result <- paste(as.character(resultVec),collapse=" ")
resultComp <- paste(as.character(resultComp),collapse=" ")
type <- paste(rep("f", 16), collapse = "")
toOscTyped(result, "/ffxf/step1", 6448, type)
toOscTyped(resultComp, "/ffxf/step1comp", 6447, type)



##})
