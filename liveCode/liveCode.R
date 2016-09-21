## ls() me muestra las variables que tengo cargadas
## dir() me muestra archivos del WD working directori
## list.files(pattern ="*.txt")  me hace un vector con los nombres de los archivos
## rep() , seq()
## escribir(rep(1:4, 15), "hihat2.txt")
## paste sirve como as.character y concatena strings

x <- c(0,2,3,5,7,9,10,12)
system(paste0("chuck ","004live:",paste0(root + x, collapse =":") ))

root <- 60
intervals <- c(2,2,1,2,2,2,1,2,1,2,1,1,1,1,2,1) # major # ¿cómo modulo esto?
scaleLenght <- 7
melody <- c(1:16)

for(j in 1:16) {
  #w[j] <- root + c[j]
  root <- root + intervals[j]
  melody[j] <- root
  print(root)  
}

intervals
#------ kick --------
kick <- c(36, 0, 0, 0, 36, 0, 0, 0, 36, 0, 0, 0, 36, 0, 0, 0)
# pat1 <- for( i in 0:15) { c(base[i%%4+1])} # NULL
kickFile <- file("kick.txt")
writeLines(paste0(kick),kickFile)


##...... sn
snare <- c(0, 0, 0, 0, 38, 0, 0, 0, 0, 0, 0, 0, 38, 0, 0, 0)
# pat1 <- for( i in 0:15) { c(base[i%%4+1])} # NULL
snareFile <- file("snare.txt")
writeLines(as.character(snare),snareFile)


                                       
#...... hh
base <- c(0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0)
# pat1 <- for( i in 0:15) { c(base[i%%4+1])} # NULL
escribir <- function(nombre, sequencia){
track <- file(nombre)
writeLines(as.character(sequencia),track)
}
charHihat

charHihat <- sample(charHihat) #randomize
writeLines(charHihat, hihat)

 #-------- bass ----------
bass <-  c(0,0,-2,-2,0,0,0,0,0,0,0,0,0,0,-2,-2)
bass <- bass+root
bassFile <- file("bass.txt")
writeLines(as.character(bass),bassFile)

mute(bass, "bass.txt")

onset(bass,"bass.txt")

#-------- lead1 ----------
lead1 <- c(0,0,0,-2,0,0,0,0,3,0,0,3,0,5,0,0)
lead1 <- lead1 + root + 48 ### reemplazar!
lead1File <- file("lead1.txt")
writeLines(as.character(lead1),lead1File)

lead1[c(4, 8, 12)] <- 0 # para escoger varias posiciones debo hacer un vector  y le aplico lo que quiera

lead1[c(4, 8, 12)] <- lead1[c(4, 8, 12)] + 2 

mute(lead1, "lead1.txt")

# No cerrar mientras se esta  en vivo haciendo cambios
close(score)

##### probar > x[is.na(x)] <- 0
##replaces any missing values in x by zeros and


## ----- functiones
onset <- function(x, track){
  track <- file(track)
  x[c(1,2)] <-root 
   x[c(2,3,4)] <- 0
   writeLines(as.character(x),track)
}

mute <- function(x, track){
  track <- file(track)
  x[] <- 0
  writeLines(as.character(x),track)
  }
## -- onset de 4

# changes ------------
x <- charLead1 # array
f <- lead1 # file

x <- charBass; f <- bass # file

x <- sample(x) # reorder
writeLines(x, f)

charMel <- rev(charMel) #reverse
writeLines(charMel,score)

set.seed(991)

set.seed(002)

charMel <- sample(charMel) # randomize
writeLines(charMel,score)
charMel

charMel <- sort(charMel, decreasing=FALSE) #sort
writeLines(charMel,score)

charMel <- sort(charMel, decreasing=TRUE) #sort
writeLines(charMel,score)


# ------ Mutes
charLead1[] <- 0; writeLines(charLead1,lead1)

charBass[] <- 0; writeLines(charBass,bass)


# -------- Favorites(store)
fav1 <- file("fav1.txt")
writeLines(charMel,fav1)
charMel

fav2 <- file("fav2.txt")
writeLines(charMel,fav2)

#---------- Favorites(recall)
readLines(fav1, charMel)
writeLines(charMel, score)

# b <- c(0,0,0,1)
# for( i in 0:15 ) { print(b[i%%4+1]) } 
