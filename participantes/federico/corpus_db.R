observation <- function(size, activeSteps, distances) {
  replace(rep(-1,size), activeSteps, distances)
}

## observation based corpus
mCorpus <- rbind(
  observation(16, c(1,5,7), c(0,3,3)),
  observation(16, c(1,7,9), c(0,5,5)),
  observation(16, c(1,5,7), c(0,3,3)),
  observation(16, c(1,7,9), c(0,5,5))
)
## artificial corpus
mCorpusArtificial <-   lapply(1:20, function(i) {
  observation(16,sample(1:16, 4), sample(c(0,0,0,0,0,0,0,3,5,7,8,10,12,14,15,17,19,20,24,100), 4))
})
mCorpusArtificial <- t(sapply(1:20, function(i){mCorpusArtificial[[i]]}))

corpus_bass_marejada  <- rbind(
  observation(16, c(1,6,14), c(0,0,0)),
  observation(16, c(1,6,14), c(0,0,0)),
  observation(16, c(1,6,14), c(0,0,0)),
  observation(16, c(1,6,14), c(0,0,0))
  )
