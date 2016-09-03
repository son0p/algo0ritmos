
algo0ritmos
===============

[![Join the chat at https://gitter.im/son0p/algo-ritmos](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/son0p/algo-ritmos?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[Wiki](http://wiki.son0p.net/aprendizaje/algo-ritmos/start)

# Entornos para aprendizaje de código en vivo y música generativa

Este proyecto fue financiado por Medellin Vive La Música durante dos años 

## Uso
Instale ChucK http://chuck.cs.princeton.edu/release/

## Instalación

### Onliner para Ubuntu
Esta línea pretende instalar las dependencias de Chuck, Chuck, MiniAudicle y clonar los  repositorios algo0ritmos y CHmUsiCK

Abra una terminal y pegue esta larga línea:

```
mkdir Algo-Ritmos-ChucK; cd Algo-Ritmos-ChucK; git clone https://github.com/son0p/algo-ritmos.git; git clone https://github.com/essteban/CHmUsiCK.git; wget http://audicle.cs.princeton.edu/mini/release/files/miniAudicle-1.3.2.tgz; tar zxvf miniAudicle-1.3.2.tgz;
sudo apt-get install make gcc g++ bison flex libasound2-dev libsndfile1-dev libqt4-dev libqscintilla2-dev libjack-dev; cd miniAudicle-1.3.2/; cd src; make linux-jack;mv miniAudicle ~/Desktop/
```

### Instalación para Windows
Descargue y ejecute este instalador [chuck-1.3.5.0.msi](http://chuck.stanford.edu/release/files/exe/chuck-1.3.5.0.msi)
Encuentre más información aquí: [Mini-Audicle Windows](http://audicle.cs.princeton.edu/mini/windows/)

### Instalación para OSX
Descargue y ejecute este instalado [chuck-1.3.5.0.pkg](http://chuck.stanford.edu/release/files/exe/chuck-1.3.5.0.pkg)
Encuentre más información aquí: [Mini-Audicle MAC OS X](http://audicle.cs.princeton.edu/mini/mac/)

## Información de este repositorio

La carpeta [practicas](practicas/) contiene ejercicios descritos en el [wiki](http://wiki.son0p.net/aprendizaje/algo-ritmos/start)

