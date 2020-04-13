install.packages("formattable")
install.packages("plotly")
install.packages("readxl")
install.packages("ggplot2")

library(ggplot2)
library(plotly)
library(readxl)
library(formattable)



data <- read.csv2("corpus.csv", stringsAsFactor=FALSE, header=FALSE)
## nombrar las columnas              
colnames(data) <- c("tiempo", "valor")

data$tiempo <- as.numeric(data$tiempo)
data$valor <- as.numeric(data$valor)
## eliminar todo menos la primera fila!!!!
data <- data[-1,]
data[1,2]

## consultar con un condicional
data[data$valor < 0, ]
## borrar todo de x para abajo
data <- data[-which(data$valor <0),]
##data[,2]<-  data[,2]*100
registros <- ggplot(data, aes(tiempo, valor)) + geom_line() 
registros
ggplotly(registros)
