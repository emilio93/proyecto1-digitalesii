# Proyecto 1 de Circuitos Digitales II
## II Ciclo 2017

### Syntetizando con ```yosys```, compilando con ```iverilog``` y corriendo con ```vvp```

```bash
make
# esto ejecuta
#  - make synth
#  - make compile
#  - make run

# Abrir visualizador con ondas generadas
gtkwave gtkws/testSerialParalelo.gtkw
gtkwave gtkws/testParaleloSerial.gtkw
gtkwave gtkws/testParaleloSerialSerialParalelo.gtkw
```
#### Para Utilizar el Makefile
El makefile está adecuado para funcionar ante cierta configuración 
de folders y archivos, no es necesario modificar el makefile
ni el archivo ```yosys.tcl``` si se siguen los siguientes rubros
 - Los archivos de módulos deben colocarse dentro de una carpeta
 dentro de la carpeta bloques, las pruebas no deben colocarse en 
 esta carpeta, únnicamente las despcripciones conductuales.
 - Cada archivo debe contener un único módulo cuyo nombre sea el
 mismo que el archivo sin la extensión. Esto asegura que el modulo
 del sintetizado va a llamarse igual con Synth(<nombre-del-modulo>Synth).
 - La inclusión de los archivos requeridos para una prueba se hacen en 
 los archivos de prueba, que se colocan en la carpeta pruebas.
 
 #### Funcionamiento del Make
 
 El make realiza la síntesis para todos los archivos ```.v``` dentro de 
 una carpeta dentro de la carpeta ```bloques```, a partir del nombre del
 archivo y otros parámetros, el archivo ```yosys.tcl``` se encarga de 
 llamar adecuadamente a los comandos de yosys para realizar la síntesis
 de cada módulo. Los modulos sintetizados se colocan en la carpeta ```build```, 
 se nombran ```<nombre-del-modulo>-sintetizado.v```, y el nombre del módulo 
 sintetizado es ```<nombre-del-modulo>Synth```.
 
 Una vez que se ha sintetizado se compilan todos los archivos .v en la carpeta
 pruebas y por ultimo se corren. Los archivos .gtkw deberían salir a la carpeta
 gtkws y se le debe haccer un savefile(```.gtkw```).
