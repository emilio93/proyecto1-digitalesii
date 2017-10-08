# Avance de Bloques
## Conductuales y Estructurales
### ```paraleloSerial```, ```serialParalelo```, ```to8bit```, ```from8bit```, ```encoder```, ```decoder10to8```, ```clks```
_Por_
#### Robin Gonzalez
#### Boanerges Martinez
#### Emilio Rojas

---
# ```Makefile```
```Makefile
DIRS  = build pdfs
CC    = iverilog
CC1   = vvp
CC2   = gtkwave
CC3   = yosys -c # yosys con bandera para tcl

# para instalaciones locales(carpeta con .vpi's)
VPI   = -M ~/ruta/instalacion/lib/ivl

# crea folders necesarios en caso que no existan
MAKE_FOLDERS := $(shell mkdir -p $(DIRS))

# correr siempre
# evita 'nothing to be done for `target`'
.PHONY: compile synth run 
```

---
```Makefile
# Sintetiza, compila y corre
all: synth compile run

synth: synthYosys renameSynths
# Sintetiza segun scripts de yosys dentro de 
# las carpetas para los bloques
synthYosys:
  $(foreach vlog,$(wildcard ./bloques/**/*.v), 
  VLOG_FILE_NAME=$(vlog) 
  VLOG_MODULE_NAME=$(subst .v,,$(notdir $(vlog))) 
  CUR_DIR=$(shell pwd) $(CC3) ./yosys.tcl;)
  rm -f ./pdfs/*.dot
# Renombrar modulos sintetizados
renameSynths: 
  bash ./renameSynths.sh
  
# Compila con iverilog
compile:
  $(foreach test,$(wildcard pruebas/*.v), 
  cd pruebas; 
  $(CC) -o 
  ../build/$(subst pruebas/,,$(subst .v,.o,$(test))) 
  $(subst pruebas/,,$(test)) -Ttyp -g specify; 
  cd ..;)
```

---
```Makefile
run:
  $(foreach test,$(wildcard build/*.o), 
  $(CC1) $(VPI) $(test);)

# Uso:
# > make gtkw="./achivo.gtkw" view
# Resulta más sencillo utilizar simplemente
# > gtkwave ./archivo.gtkw
view:
  gtkwave $(gtkw)

clean:
  rm -r build
  rm -r pdfs
  rm -f ./*.dot
  rm -f tests/*.vcd
```

---
# ```yosys.tcl```
```bash
yosys -import

set curDir         "$::env(CUR_DIR)"
set vlogModuleName "$::env(VLOG_MODULE_NAME)"
set vlogFileName   "$::env(VLOG_FILE_NAME)"

yosys read_verilog $vlogFileName

hierarchy -check -top $vlogModuleName
show -prefix pdfs/$vlogModuleName-original \
     -format pdf -colors 3 -viewer echo
...
write_verilog ./build/$vlogModuleName-sintetizado.v
```
---

# ```renameSynth.sh```
```bash
cd build
# para todos los archivos que terminen en 
# '-sintetizado.v' en la carpeta 'build'
for file in ./*-sintetizado.v; do
  # elimina './'
  moduleName=${file/.\//} 
  
  # elimina '-sintetizado.v'
  # se tiene nombre del modulo
  moduleName=${moduleName/-sintetizado.v/} 
  
  # nombre del modulo sintetizado
  newModuleName=${moduleName}Synth
  
  # busca nombre del modulo y remplaza por nombre del 
  # modulo sintetizado
  sed -i \
  "s/module ${moduleName}/module  ${newModuleName}/" \
  "${file}"
done
```
---

# Sintesis de Bloques
### Correcta temporizacion

![center](presentacion-4/temporizacion-correcta.png)
_De ```gtkws/testParaleloSerial.gtkw```_

### Asignaciones no bloqueantes

```verilog
...
@ (posedge clk10); entradas <= 10'h36c;
@ (posedge clk10); entradas <= 10'h3e0;
@ (posedge clk10); entradas <= 10'h01f;
...
```
_Extracto de ```pruebas/testParaleloSerial.v```_

---

# Bloque ```clks```
```verilog
module clks(clk, rst, enb,        // entradas
            clk10, clk20, clk40); // salidas
```
```verilog
always @ (posedge clk) begin
  if (rst) begin
    cnt10 <= 3'd4; // contador
    clk10 <= 1'b0; clk20 <= 1'b0; clk40 <= 1'b0;
  end else begin
    if (enb) begin
      if (cnt10 >= 3'd4) begin
        cnt10 <= 3'd0;
        clk10 <= ~clk10;
        if (~clk10) clk20 <= ~clk20;
        if (~clk20 & ~clk10) clk40 <= ~clk40;
      end else begin
        cnt10 <= cnt10 + 1'b1;
      end
    end
  end
end
```

---
# Bloque ```clks```

 - Se comporta igual de manera conductual y estructuralmente.
 - Permite tener mismas senales de entrada a bloques conductuales y estructurales para las pruebas.

![center 75%](presentacion-4/prueba-clks.png)
_De ```gtkws/testClks.gtkw```_

---
# ```paraleloSerial```

```verilog
// Este modulo se encarga de serializar una 
// entrada paralela cada n ciclos de reloj
module paraleloSerial(clk, rst, enb, clk10, entradas,
                      salida);
```
 - Se modela como maquina de estados.
 - Estado esta definido por un contador.
 - La salida es tomada directamente de la entrada: 
   ```verilog
   always @(*) begin
     // operador ternario se asegura de usar 
     // todos los casos, senal 0 constante no 
     // es esperada, ver 8b10b
     salida = ~rst & enb ? entradas[contador] : 0;
   end 
   ```
 - Orden de contador es descendente, se devuelve el MSB primero.
---
# ```paraleloSerial```
 - Se actualiza estado en flanco positivo de reloj:
 ```verilog
always @(posedge clk) begin
  // Cuando rst esta encendido se
  // asigna 0 al contador para comenzar con 9
  // inmediatamente se de el flanco positivo
  if (rst) begin
    contador <= 0;
  end else begin
    contador <= contador == 0 ?
                cantidadBits-1 : contador-1;
  end
end
 ```
 ---
# ```serialParalelo```
```verilog
// Este modulo se encarga de escuchar n bits 
// en n ciclos de reloj, y enviarlos una vez
// que se han adquirido los n bits.
module serialParalelo(clk, rst, enb, clk10, entrada, 
                      salidas);
```
 - Se actualiza la salida cada 10 flancos de reloj ```clk```.
 - La salida es secuencial.
 - Se guardan valores en un arreglo de 10 bits que pasa a la salida una vez que se han capturado los 10 bits.
 - Se identifica que se han capturado 10 bits con el uso de un contador.

---
# ```serialParalelo```
```verilog
always @(posedge clk) begin
  if (rst) begin
    contador <= 0;
  end else if (enb) begin
    contador <= contador==0? cantidadBits-1:contador-1;
    bits[contador] <= entrada;
    if (contador ==  0) begin
      salidas <= {bits[cantidadBits-1:1], entrada};
    end
  end
end
```
 - ```rst``` se asigna a 0 para que siguiente número sea 9(contador descendente).
 - Primer bit que se escucha es el MSB.
 - Se cambia la salida cuando el contador llega a 0.
 - El bit 0 de la salida pasa directo de la entrada, porque no se ha almacenado _aun_.
---
# ```paraleloSerial``` y ```serialParalelo```

![center 80%](presentacion-4/prueba-paraleloserial-serialparalelo.png)
_De ```gtkws/testParaleloSerialSerialParalelo.gtkw```_
_Tambien se tienen pruebas individuales de cada modulo_

---

aca deberian ir demas slides

---

# Clock Recovery
