
Algo-Ritmos
===============

[![Join the chat at https://gitter.im/son0p/algo-ritmos](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/son0p/algo-ritmos?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[Wiki](http://wiki.medellinvivelamusica.com/aprendizaje:algo-ritmos:start)

# Entornos para aprendizaje de código en vivo y música generativa

Actualmente el proyecto habita en la Escuela de Experimentos de <a href="http://wiki.medellinvivelamusica.com/"><img src="http://wiki.medellinvivelamusica.com/_media/logo.png" alt="Medellin Vive La Música" height="100" width="200"></a>

## Uso
Instale ChucK http://chuck.cs.princeton.edu/release/

Clone este repositorio

```
$ git clone https://github.com/son0p/algo-ritmos.git
$ cd algo-ritmos/practicas
$ chuck initialize.ck
```


### Onliner para Ubuntu
Esta línea pretende instalar las dependencias de Chuck, Chuck, MiniAudicle y clonar los  repositorios Algo-Ritmos y CHmUsiCK

```
mkdir Algo-Ritmos-ChucK; cd Algo-Ritmos-ChucK; git clone https://github.com/son0p/algo-ritmos.git; git clone https://github.com/essteban/CHmUsiCK.git; wget http://audicle.cs.princeton.edu/mini/release/files/miniAudicle-1.3.2.tgz; tar zxvf miniAudicle-1.3.2.tgz;
sudo apt-get install make gcc g++ bison flex libasound2-dev libsndfile1-dev libqt4-dev libqscintilla2-dev libjack-dev; cd miniAudicle-1.3.2/; cd src; make linux-jack;mv miniAudicle ~/Desktop/
```
## Documentación

initialize.ck : carga las clases que usaremos en el entorno

looper.ck : recarga el archivo livecode.ck cada determinados beats para hacer live coding (escribir, salvar, y lo escrito se ejecuta en el próximo compás)
