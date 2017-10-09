//Archivo que contiene la mitad de la interfaz PCIE que se encarga de
//transimitir.
//Se instanacian todos los bloques necesarios:
//Clks
//To8Bit
//encoder8-10
`timescale 1ns/1ps

`ifndef clks
  `include "../bloques/clks/clks.v"
`endif

`ifndef paraleloSerial
  `include "../bloques/paraleloSerial-serialParalelo/paraleloSerial.v"
`endif

`ifndef to8bit
  `include "../bloques/to8bit-from8bit/to8bit.v"
`endif

`ifndef encoder
  `include "../bloques/encoder-decoder/encoder.v"
`endif

module transmisor(
	clk,
	enb,
	rst,
	dataIn,
	dataIn16,
	dataIn32,
	dataS,
	serialOut,
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

	output wire serialOut;

//Variables internas:

	wire clk10, clk20, clk40, salidaSerial;
	wire [7:0] byteOut;
	wire [9:0] encoderOut;

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
        .enb(enb)
);

paraleloSerial emisor(
	.clk(clk),
	.rst(rst),
	.enb(enb),
	.clk10(clk10),
	.entradas(encoderOut),
	.salida(serialOut)
);


endmodule
