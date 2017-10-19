//Archivo que contiene la mitad de la interfaz PCIE que se encarga de
//transimitir.
//Se instanacian todos los bloques necesarios:
//Clks
//To8Bit
//encoder8-10
`timescale 1ns/1ps
`define isTransmisor 1

`ifndef isTest
  `include "../../bloques/clks/clks.v"
  `include "../../bloques/paraleloSerial-serialParalelo/paraleloSerial.v"
  `include "../../bloques/to8bit-from8bit/to8bit.v"
  `include "../../bloques/encoder-decoder/encoder.v"
  `include "../../bloques/diferencial/diferencialEmisor.v"
`endif

module transmisor(//no tiene sentido poner la señal TxElecIdle ya que su funcionalidad no se sintetiza
	clk,
	enb,
	rst,
	dataIn,
	dataIn16,
	dataIn32,
	dataS,
	serialOut,
	TxElecIdle,
	K
);

//Declaración de puertos:

	input wire clk;
	input wire enb;
	input wire rst;
	input wire K;
	input wire [7:0] dataIn;
	input wire [15:0] dataIn16;
	input wire [31:0] dataIn32;
	input wire [1:0] dataS;
	input wire TxElecIdle;
	output wire serialOut;


//Variables internas:

	wire clk10, clk20, clk40, salidaSerial;
	wire [7:0] byteOut;
	wire [9:0] encoderOut;
	wire salidaPS;
	reg offsetCnt;
//	reg setEnbG;//enable general para todos los modulos excepto clk y paraleloSerial
//	reg setEnbPS;
//	reg enbG = 0;
//	reg enbPS = 0;//esta señal se usa como enable para el modulo paraleloSerial para retardo de un ciclo
/*
always @(negedge clk)begin
	if (enb) setEnbG = 1;
	else setEnbG = 0;
	if (enbG) setEnbPS = 1;
	else setEnbPS = 0;
end

always @(posedge clk)begin
	if (setEnbG) enbG = 1;
	else enbG = 0;
	if (setEnbPS) enbPS = 1;
	else enbPS = 0;
end
*/

//Instancias:

clks reloj(
	.clk(clk),
	.rst(rst),
	.enb(enb),
	.clk10(clk10),
	.clk20(clk20),
	.clk40(clk40)
  );

to8bit reductor8bits(
	.rst(rst),
       	.enb(enb),
	.clk(clk10),
       	.clk16(clk20),
       	.clk32(clk40),
	.dataIn(dataIn),
       	.dataIn16(dataIn16),
       	.dataIn32(dataIn32),
	.dataS(dataS),
	.dataOut(byteOut)
  );

encoder codificador(
  .entradas(byteOut),
  .salidas(encoderOut),
  .K(K),
  .clk(clk),
  .rst(rst),
  .enb(enb)
);

paraleloSerial serializador(
	.clk(clk),
	.rst(rst),
	.enb(enb),
	.clk10(clk10),
	.entradas(encoderOut),
	.salida(salidaPS)
);

diferencialEmisor emisor(
	.entrada(salidaPS),
	.TxElecIdle(TxElecIdle),
	.salida(serialOut)
);

endmodule
