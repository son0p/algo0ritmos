g=0; for f in *.wav; do echo Renaming $f to $g.wav; g=$(($g+1)); mv $f $g.wav; done
