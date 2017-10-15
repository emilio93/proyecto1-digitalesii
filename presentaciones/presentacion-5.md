# Capa fÃ­sica de la interfaz PCIE USB 3.0
## Demostracion de funcionamiento de descripcion estructural
_Por_
#### Robin Gonzalez
#### Boanerges Martinez
#### Emilio Rojas

---
# ```Modulos```
### Emisor
###  ```clks```,```to8bit```, ```encoder```, ```paraleloSerial``` 
### Receptor
###  ```serialParalelo```, ```decoder```, ```from8bit```, ```clkRecovery```

---

# Modulos restantes
### Clock recovery

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

# Emisor 

---

# Receptor 

---


# Interfaz, conexion de emisor y receptor 

---

# Interfaz con retardos

---


# Investigacion ```Modulo diferencial```

---

# Investigacion ```Elastic buffer```
---

