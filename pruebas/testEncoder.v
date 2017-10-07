`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

//`include "lib/cmos_cells.v"

`include "../bloques/encoder8-10/encoder.v"
//`include "../build/encoder-sintetizado.v"

module testEncoder;


reg [7:0] entradas;
wire [9:0] salidasC;
wire [9:0] salidasE;
reg enb, clk;
parameter retardo = 80;
 
encoder testEnc(
	.entradas(entradas),
	.salidas(salidasC),
	.K(K),
	.clk(clk),
	.enb(enb)
);

//encoderSynth testEncoderSynth(
//	.entradas(entradas),
//	.salidas(salidasE),
//	.K(K),
//	.clk(clk),
//	.enb(enb)
//);

always # 20 clk <= ~clk; // inicio de la señal de reloj, cambia cada 20ns

initial begin
	clk = 1;
	entradas = 8'b111_0001;
	enb = 0;

	#retardo;

	enb = 1;

	#retardo;
	entradas = 8'b000_0000;

	#retardo;
	entradas = 8'b111_1111;

	#retardo;
	entradas = 8'b001_0001;

	#retardo;
	entradas = 8'b100_1000;

	#retardo;
	$finish;
	//@ (posedge clk);
//	rst <= 0;

  end

  initial begin
  	$dumpfile("gtkws/testEncoder.vcd");
  	$dumpvars;
  	$display("		tiempo    | clk | enb | entradas | K |  salidasC  |  salidasE  | tiempo ns");
  	$monitor("%t      | %b   |  %b    %b   %b   %b   %b   %f ns", $time, clk, enb, entradas, K , salidasC , salidasE, $realtime);

  end

endmodule
