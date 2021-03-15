#rm(list=ls())

## if(!require(plyr)){install.packages("plyr")}
## if(!require(dplyr)){install.packages("dplyr")}
## if(!require(magrittr)){install.packages("magrittr")}
## if(!require(tuneR)){install.packages("tuneR")}
##if(!require(profvis)){install.packages("profvis")}
if(!require(tibble)){install.packages("tibble")}
if(!require(unnest)){install.packages("unnest")}

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
s7<- replace(rep(-1,16), c(4,12), 3)
s8<- replace(rep(-1,16), c(4,16), 0)
mCorpus <- rbind(s1, s2, s3, s4, s5, s6, s7, s8)

targetSize <- c(1:16)

percentDistByStep <- function (corpus, x){
  count <- (data.frame(table(corpus[ ,x])))
  count$percent <- count$Freq / sum(count$Freq)
  count$step <- x
  return(count)
}


dfMcorpus <- lapply(targetSize, function(x){percentDistByStep(mCorpus, x)}) %>% tibble::enframe(.) %>% tidyr::unnest(., cols = c(value))

## number of steps to be evaluated
patternSize <- c(1:length(unique(dfMcorpus$step)))

factSel <- function(x){
  ## form each step select the factors
  fact <- dfMcorpus[dfMcorpus$step %in% x, ]
  values <- as.numeric(as.character(fact$Var1))
  pcts <- fact$percent
  ## select one value considering percent distribution
  stp <- sample(values, 1, prob=pcts)
  return(stp)
}

resultVec <- unlist(lapply(patternSize, function(x){factSel(x)}))

## MODS based on RESULT
## complement, TODO never touch the steps after a sincopa
options <- c(rep(-1,25),rep(0, 10),rep(3,1), rep(12,1),rep(51,1)) 
resultComp <- ifelse(resultVec == -1, sample(options) , -1)

## -- prepare  OSC boundles
result <- paste(as.character(resultVec),collapse=" ")
resultComp <- paste(as.character(resultComp),collapse=" ")
type <- paste(rep("f", 16), collapse = "")
toOscTyped(result, "/ffxf/step1", 6448, type)
toOscTyped(resultComp, "/ffxf/step1comp", 6447, type)

##})
