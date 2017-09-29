# Propuesta  de Especificación para el Proyecto 1

Se diseña la capa PHY de un USB 3.1

## Módulo Probador del Transmisor
_Según la figura 4-2 y tabla 6-4_

Se prueba el diseño en un módulo probador con
las siguientes condiciones.

**Entradas(```reg```)**:

  - **TxDataS**: Selector de cantidad de bits en el bus de datos.
  - **TxData32**: Para probar funcionamiento con buses de 32 bits de datos.
  - **TxData16**: Para probar funcionamiento con buses de 16 bits de datos.
  - **TxData8**: Para probar funcionamiento con buses de 8 bits de datos.


  - **TxDataKS**: Selector de bits para símbolos de transmisión de datos.
  - **TxDataK4**: Para simbolos de 4 bits de transmision de datos
  - **TxDataK2**: Para simbolos de 2 bits de transmision de datos
  - **TxDataK1**: Para simbolos de 1 bits de transmision de datos

  **TxOnesZeroes**: Esta entrada se omite en el diseño.

  - **TxCompliance**: Asigna el Running Disparity a negativo si es 1(Implementación Opcional).

  **BitrateClk**: Señal de reloj base(ej 2.5G 5G).

**Salidas(```wires```)**:
  - **Salida**: Salida del paralelo serial con un clock de BitrateClk.

Entradas y salidas del transmisor diferencial se agregan luego.


## Módulo to8bit
_Funciona a BitrateClk/10 base_

Este módulo convierte un bus de datos ya sea de 32, 16 o 8 bits
a un bus de datos de 8 bits de acuerdo a la conversión necesaria
de reloj para no perder información.


**Entradas**:
  - **DataIn**: El bus de datos de entrada en 8 bits.
  - **DataIn16**: El bus de datos de entrada en 16 bits.
  - **DataIn32**: El bus de datos de entrada en 32 bits.
  - **DataS**: Selector de entrada.
  - **Clk**: señal de reloj para transmisión de 8 bits.
  - **Clk16**: señal de reloj para transmisión de 16 bits, es clk/2.
  - **Clk32**: señal de reloj para transmisión de 32 bits, es clk/4.

**Salidas**:
  - **DataOut**: El bus de datos de salida.

## Módulo Encoder8b10b
_Funciona a BitrateClk/10 o combinacional_

Este módulo se usa para realizar el encoding 8b10b.
Es una serie de funciones booleanas que se pueden probar
contra tablas de los resultados esperados.

**Entradas**:
  - **DataIn**: El bus de datos de entrada en 8 bits.
  - **TxDataKS**: Selector de bits para símbolos de transmisión de datos.
  - **TxDataK4**: Para simbolos de 4 bits de transmision de datos
  - **TxDataK2**: Para simbolos de 2 bits de transmision de datos
  - **TxDataK1**: Para simbolos de 1 bits de transmision de datos

  **TxOnesZeroes**: Esta entrada se omite en el diseño.

  - **TxCompliance**: Asigna el Running Disparity a negativo si es 1.
**Salidas**:
  - **DataOut**: El bus de datos de salida de 10 bits.
