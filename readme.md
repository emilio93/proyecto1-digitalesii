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
 esta carpeta, únicamente las despcripciones conductuales.
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
gtkws y se le debe hacer un savefile(```.gtkw```).

#### Identificando fallas que no detienen al Make
Conforme se ha trabajado, se ha notado que el make no se detiene ante ciertas fallas, esto se traduce en que no se actualiza las ondas, el ```.vcd```. Cuando se sospecha que esto está pasando puede ser por varias razones.
   - Un  módulo no tiene salidas y yosys lo interpreta como un empty module. Para verificar que esto está sucediendo se puede realizar un ```make synth```, o ```make synthYosys``` y revisar la salida, esto puede ser algo complicado si la salida es muy grande, la alternativa es sintetizar únicamente el módulo del que sospechan que da error, por ejemplo para el módulo ```clks```:
   ```bash
   VLOG_FILE_NAME="./bloques/clk/clks.v" VLOG_MODULE_NAME="clks" CUR_DIR="$(pwd)" yosys ./yosys.tcl
   ```
   - Un módulo probador tiene errores de sintáxis o incluye algún archivo que no existe. Para verificarlo se puede correr ```make compile```, si no tira ninguna salida está bien, y el problema es en algún otro lado, si es un error de sintáxis debe revisarse la línea que indica que está mal y solucionarlo, si no se encuentra algun archivo, asegurarse que la ruta está bien y el archivo existe y define un módulo, si el archivo que no se encuentra es un sintetizado, asegurarse de haber corrido ```make synth```, si aun así no lo encuentra, probablemente se tiene el caso anterior en que se tiene un módulo vacío(sin salidas).
