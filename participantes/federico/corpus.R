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

## extended 16 steps with some observations, distances from root, [temporal convention: -1 = silence, 0 = root, 12 = octave ]

observation <- function(size, activeSteps, distances) {
  replace(rep(-1,size), activeSteps, distances)
}

mCorpus <- rbind(
  observation(16, c(1,5,7), c(0,3,3)),
  observation(16, c(1,7,9), c(0,5,5)),
  observation(16, c(1,5,7), c(0,3,3)),
  observation(16, c(1,7,9), c(0,5,5))
)

mCorpusArtificial <-   lapply(1:20, function(i) {
    observation(16,sample(1:16, 4), sample(c(0,0,0,0,0,0,0,3,5,7,12,24,36), 4))
  })
mCorpusArtificial <- t(sapply(1:20, function(i){mCorpusArtificial[[i]]}))

targetSize <- c(1:16)

percentDistByStep <- function (corpus, x){
  count <- (data.frame(table(corpus[ ,x])))
  count$percent <- count$Freq / sum(count$Freq)
  count$step <- x
  return(count)
}

dfMcorpus <- lapply(targetSize, function(x){percentDistByStep(mCorpusArtificial, x)}) %>% tibble::enframe(.) %>% tidyr::unnest(., cols = c(value))

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
