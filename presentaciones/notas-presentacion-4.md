# Portada
Buenos días blah blah

Esta presentación es más grande porque culmina los bloques del emisor así como
sus _espejos_ en el receptor.

Se tienen 7 bloques que funcionan conductual y estructuralmente.

# Makefile 1

Usar ```make``` hace todo lo necesario para ver los resultados del codigo que
se tiene en el momento.

Primero se asignan variables, ```DIRS``` son los directorios que se crean cada
vez que se corre make.
La verdad es que algunas no son realmente necesarias porque dificilmente se
va a cambiar los comandos que se usan(eg ```iverilog```, ```vvp```), pero en
todo caso es bueno tenerlo ahí parametrizado.

La bandera de yosys, ```-c```([ver página ](http://www.clifford.at/yosys/files/yosys_manual.pdf))
indica que se usa tcl([Tool Command Language](https://www.tcl.tk/), esta
posibilidad la había dicho Brian, me parece), tcl hace muchas cosas, nosotros
la usamos para agarrar variables de entorno, tenerlas en variables, y llamar
esas variables en el script de yosys. De esto se habla más adelante.

La bandera ```-M``` es para ```vvp```, agrega una carpeta a una variable de
entorno donde estan ciertos archivos ```.vpi``, esos son los archivos bases de
icarus verilog, es como el api o framework de icarus verilog. Por lo general no
se tiene que usar esa bandera, en instalaciones buildeadas es posible que tenga
que usarse. Parece que no afecta en caso que ya se tenga agregada la var de ent.
Por eso se puede dejar ahí, por mi XD.

El ```MAKE_FOLDERS``` es lo que se encarga de que cada vez que se llame al
make se creen los directorios donde salen los archivos, los compilados y los
pdf. Se usa ```$(shell comandos)``` que tira la salida que se tenría en el
bash normal(opuesto al make, que no existen comandos de bash), es como una
interfaz de make hacia el bash o shell. ```mkdir```  es básico, se agrega la
bandera -p para crearlos solo cuando no existan(osea evita que no se pueda
crear la carpeta porque ya existe, evita un error)

```.PHONY```([referencia oficial](https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html))
([stack overflow](https://stackoverflow.com/questions/2145590/what-is-the-purpose-of-phony-in-a-makefile))
Básicamente quita la relación entre el nombre del rule con un archivo. Evita
error ```'nothing to be done for `target'```.

# Makefile 2
```all``` llama a ```synth```, ```compile``` y ```run```, estos otros
targets sintetizan, compilan y corren los archivos necesarios.

Primero ```synth```(ese no es el orden en el que está en el makefile del repo)
Se tienen dos targets:
 - ```synthYosys```: esta es la síntesis con yosys para cada módulo que está en
la carpeta ```./bloques/loquesea/modulo.v```(ojo que ```./``` significa el
folder en el que se está).
    - El foreach([referencia](https://www.gnu.org/software/make/manual/html_node/Foreach-Function.html)) lo que hace es concatenar strings, se puede hacer
    ```comando1 args1;comando2 args2;...``` para ejecutar muchos comandos,
    entonces se usa eso para llamar a yosys con cada módulo. wildcard(referencia
    está en misma página que la del foreach) le asigna a vlog la lista en la que
    actua el foreach, son todos los módulos, ```./bloques/**/*.v```, por eso es
    importante tener los archivos en esas carpetas y que cada archivo tenga un
    solo módulo, se hacen tantos sintetizados como archivos ```.v``` se tengan
    en esas carpetas. Ahora, que tenga el mismo nombre el archivo y el módulo
    es por esto, ```VLOG_FILE_NAME``` y ```VLOG_MODULE_NAME``` son variables de
    entorno que se setean antes de llamar a yosys(luego el tcl agarra esas
    variables en el script de yosys), y esas variables indican la ruta al
    archivo(relativa a la ruta actual), y el nombre del modulo, respectivamente,
    el segundo agarra el nombre del modulo a partir del nombre del archivo, aqui
    es donde se asume que el nombre del archivo es igual al del modulo que se
    declara en ese archivo. ```CUR_DIR``` es la ruta en la que se está, pero no
    se usa, se agarra igual que el ```MAKE_FOLDERS```, con pwd(print working dir)..
    Cuando ya se asignaron esas variables se llama con el comando para yosys al
    archivo ```.tcl```. Se borran los dots, no estoy seguro si se están creando
    porque se está usando la bandera ```-format``` en el script de yosys, eso se
    ve más adelante.
  - ```renameSynth```: este target llama a un script que le cambia el nombre del
    módulo a los sintetizados(que yosys los tira con el mismo nombre que el
    módulo conductual). Ese script se explica más adelante.

El target ```compile``` corre ```iverilog```. De nuevo se usa el foreach de la
misma manera que para el target ```synth```, para todos los archivos ```.v```
en la carpeta pruebas.
El comando se corre desde la ruta donde están los ```.v```, osea, en
```./pruebas```, por eso el cd, esto afecta los includes de los tests,
deben ser relativos a la ruta donde se encuentran. Por eso es que se hacen
con ```../blah/blah```, porque el ```iverilog``` toma en cuenta la ruta de donde
se corre, y de esa ruta es de donde se referencian los includes.
A las pruebas compiladas se les pone la extensión ```.o```(con la función
subst... buscar que hace en misma referencia que foreach y wildcard)
se usa bandera de retrasos típicos, ```-g specify``` habilita soporte para
bloques specify, pero en realidad lo usamos para algo de los tiempos(no recuerdo
exactamente que)([referencia](http://iverilog.wikia.com/wiki/Iverilog_Flags)).
Al final se regresa al directorio base del makefile(raiz del proyecto).

# Makefile 3

El target ```run``` es el más simple, de nuevo se usa el foreach y corre todos
los ```.o``` generados en el paso anterior. Ahí se usa el flag ```VPI```.

El target ```view``` no es muy util porque es más complicado que nada más abrir
los ```.gtkw``` con ```gtkwave```, comparar el uso en el código en el slide.

El target ```clean``` borra las cosas generadas, las carpetas ```build``` y ```pdfs```, posibles ```.dot```(eg el target ```synth``` no terminó bien),
y los ```.vcd```. El flag de force ```-f```, más que para asegurarse de borrar
los archivos, es para evitar errores en caso que no existan de esos archivos,
por ejemplo, si no hay ```.dots```, tiraría error, y no borraría los ```.pdfs```.

# Yosys
De nuevo, se de esto gracias a que alguien habló de los tcl antes. Luego
investigué un toque como sirven.
En el script tcl se tienen que importar los comandos de yosys, eso es lo que
hace esa primer línea en el slide.
Se le asignan a variables del script, las variables de entorno que se asignan
en el makefile. Se pueden llamar con un signo de dolar antes(```$```).
Se lee el archivo, ahí se usa una varible, se usan comandos de yosys(nada
nuevo). Se usan algunos flags, prefix es el archivo de salida, format hace que
salgan los pdfs de una vez, colors es para que salgan con colorcitos y así los
pdfs, viewer se pone con echo para que no abra un monton de ventanas con los pdfs.
Ojo que el ```\``` se usa en bash para continuar escribiendo en la siguiente
línea, no se si funcione en tcl, el archivo de nosotros eso lo tiene en una sola
línea, el punto que se quiere mostrar es que es un solo comando.
blah blah, pasan cosas de yosys, se usan la varibales, blah blah.
luego se escribe el archivo del sintetizado. Ojo ahí la ruta en el slide.

# renameSynth.sh

Este script se encarga de renombrar los módulos sintetizdos. Lee el
contenido en los módulos sintetizados, busca donde esta el nombre del
módulo y se lo cambia al mismo pero con ```Synth``` al final.

Primero entra a la carpeta donde estan los sintetizados, ```build```,
y para cada archivo ahí(es el for file ...) que termine en ```-sintetizado.v```
hace lo siguiente:
Los dos primeros comandos agarran el nombre del modulo, que va a ser la parte
que no dice ```-sintetizado.v```, por como tira yosys los sintetizados. Esa
nomenclatura es un find replace en una variable(```${varibale/find/replace}```),
el primero busca ```./```(se escapa el forward slash), y lo cambia con nada,
el sgundo quita la parte ```-sintetizado.v``` de la misma manera.
Otra variable ```newModuleName``` tiene el nuevo nombre del módulo, osea con el
```Synth``` agregado. ```sed``` es el comando mágico, es un find replace del
contenido en los archivos, no estoy muy seguro del flag ```-i```, pero se
necesita para que haga el replace, entonces busca donde dice
```module <nombre-modulo>``` y lo cambia por ```module <nombre-modulo>Synth```,
eso lo hace en el archivo que se pone ahí ```"${file}"```.
