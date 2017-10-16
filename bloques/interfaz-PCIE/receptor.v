//Archivo que contiene la mitad de la interfaz PCIE que se encarga de
//recibir la señal del emisor.
//Se instancian todos los bloques necesarios:
//
//from8Bit
//decoder8-10
//mk28.5
//serialParalelo
//
`timescale 1ns/1ps

`ifndef isTest
  `include "../../bloques/clks/clks.v"
`endif

`ifndef isTest
  `include "../../bloques/paraleloSerial-serialParalelo/paraleloSerial.v"
`endif

`ifndef isTest
  `include "../../bloques/to8bit-from8bit/to8bit.v"
`endif

`ifndef isTest
  `include "../../bloques/encoder-decoder/encoder.v"
`endif

module receptor(
	clk,
	enb,
	rst,
	serialIn,
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

	wire salidaSerial, invalido;
	wire [7:0] parallelOut;
	wire [9:0] decoderOut;

//Instancias:

clks reloj(
	.clk(clk),
	.rst(rst),
	.enb(enb),
	.clk10(clk10),
	.clk20(clk20),
	.clk40(clk40)
  );

from8bit (
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

decoder decodificador(
        .data10_in(parallelOut),
        .data8_out(encoderOut),
	.invalid_value(invalido)
        .k_out(K),
        .clk(clk),
	.rst(rst)
//        .enb(enb)
);

serialParalelo receptorSP(
	.clk(clk),
	.rst(rst),
	.enb(enb),
	.clk10(clk10),
	.entradas(serialIn),
	.salida(parallelOut)
);


endmodule
