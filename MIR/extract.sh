#!/bin/bash
for f in *.wav
 do chuck extractFromAudio3bands.ck:$f
 printf "\n" >> tempCorpus.txt
 cat tempCorpus.txt >> corpus.txt
 cat corpus.txt
done
