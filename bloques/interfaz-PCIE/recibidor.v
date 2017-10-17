//Archivo que contiene la mitad de la interfaz PCIE que se encarga de
//recibir la señal del emisor.
//Se instancian todos los bloques necesarios:
//
//clks
//from8Bit
//decoder
//k285Detector
//serialParalelo
//
`timescale 1ns/1ps

`ifndef isTestr
  `include "../../bloques/clks/clks.v"
`endif

`ifndef isTestr
  `include "../../bloques/to8bit-from8bit/from8bit.v"
`endif

`ifndef isTestr
  `include "../../bloques/encoder-decoder/decoder.v"
`endif

`ifndef isTestr
  `include "../../bloques/paraleloSerial-serialParalelo/serialParalelo.v"
`endif

`ifndef isTestr
	`include "../../bloques/k28.5/k285Detector.v"
`endif


module recibidor(
	clk,
	enb,
	rst,
	serialIn,
	dataOut8,
	dataOut16,
	dataOut32,
	dataS,
	k_out
);

//Declaración de puertos:

	input wire clk;
	input wire enb;
	input wire rst;
	input wire serialIn;
	output wire k_out;
	output wire [7:0] dataOut8;
	output wire [15:0] dataOut16;
	output wire [31:0] dataOut32;
	input wire [1:0] dataS;

//Variables internas:

	wire salidaSerial, invalido;
	wire [9:0] parallelOut;
	wire [7:0] decoderOut;

//Instancias:

clks relojReceptor(
	.clk(clk),
	.rst(rst),
	.enb(enb),
	.clk10(clk10),
	.clk20(clk20),
	.clk40(clk40)
  );

from8bit expansorDe8bits(
	.rst(rst),
       	.enb(enb),
	.clk(clk),
	.clk8(clk10),
       	.clk16(clk20),
       	.clk32(clk40),
	.dataIn(decoderOut),
	.dataOut(dataOut8),
       	.dataOut16(dataOut16),
       	.dataOut32(dataOut32),
	.dataS(dataS)
  );

/*
k28Detector kDetector(//Cuál es la entrdad del detector k285?
	.clk(clk),
	.rst(rst),
	.enb(enb),
	.entrada(),
	.esk285(),
	.lectura(),
	.offsetCnt(),
	.rxValid()
);
*/

decoder decodificador(
        .data10_in(parallelOut),
        .data8_out(decoderOut),
	.invalid_value(invalido),
        .k_out(k_out),
        .clk(clk),
	.rst(rst)
//      .enb(enb)
);

serialParalelo receptor(
	.clk(clk),
	.rst(rst),
	.enb(enb),
	.clk10(clk10),
	.entrada(serialIn),
	.salidas(parallelOut)
);


endmodule
