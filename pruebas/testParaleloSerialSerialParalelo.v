`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/clks/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/paraleloSerial-serialParalelo/paraleloSerial.v"
`include "../build/paraleloSerial-sintetizado.v"

`include "../bloques/paraleloSerial-serialParalelo/serialParalelo.v"
`include "../build/serialParalelo-sintetizado.v"

module testParaleloSerialSerialParalelo ();

reg clk;
reg rst;
reg enb;

reg [9:0] entradasPS;
wire salidaPS;


wire [9:0] salidasSP;

wire salidaPSSynth;
wire [9:0] salidasSPSynth;

wire clk10;
wire clk10Synth;
wire clk20;
wire clk20Synth;
wire clk40;
wire clk40Synth;

clks clkGen(
  .clk(clk),
  .clk10(clk10),
  .clk20(clk20),
  .clk40(clk40),
  .rst(rst),
  .enb(enb)
);

clksSynth clkGenSynth(
  .clk(clk),
  .clk10(clk10Synth),
  .clk20(clk20Synth),
  .clk40(clk40Synth),
  .rst(rst),
  .enb(enb)
);

paraleloSerial emisor(
  .clk(clk),
	.rst(rst),
	.enb(enb),
	.clk10(clk10),
	.entradas(entradasPS),
	.salida(salidaPS)
);
paraleloSerialSynth emisorSynth(
  .clk(clk),
	.rst(rst),
	.enb(enb),
	.clk10(clk10),
	.entradas(entradasPS),
	.salida(salidaPSSynth)
);

serialParalelo receptor(
  .clk(clk),
  .rst(rst),
  .enb(enb),
  .clk10(clk10),
	.entrada(salidaPS),
	.salidas(salidasSP)
);

serialParaleloSynth receptorSynth(
  .clk(clk),
  .rst(rst),
  .enb(enb),
  .clk10(clk10Synth),
	.entrada(salidaPSSynth),
	.salidas(salidasSPSynth)
);

integer periodo=100;
integer reloj=50;

integer relojGrande=1000;
integer relojGrande2=2000;
integer periodoGrande=1000;
integer periodoGrande2=2000;
always # reloj clk = ~clk;//inicio de la señal de reloj, cambia cada 10ns

initial begin
  enb = 1;
	clk = 0;
  rst = 1'b1;
	entradasPS = 10'b1010010101;

  # periodo
  @ (posedge clk);
  entradasPS = 10'b0000000001;

  # periodo
  @ (posedge clk);
  entradasPS = 10'b1111111110;

  # periodo
  @ (posedge clk);
  entradasPS = 10'b0111111111;

  # periodo
  @ (posedge clk);
  entradasPS = 10'b0000011111;

  # relojGrande
  @ (posedge clk);
  rst = 1'b0;
  entradasPS = 10'b1000011111;

	# relojGrande
  @ (posedge clk);
	entradasPS = 10'b0111111110;

	# relojGrande2
	@ (posedge clk);
	entradasPS = 10'b1111100000;

	# relojGrande2
	@ (posedge clk);
	entradasPS = 10'b0000011111;

  # relojGrande2
	@ (posedge clk);
	entradasPS = 10'b1100101100;

	# relojGrande2
	@ (posedge clk);
	entradasPS = 10'b1111100000;

	# relojGrande2
	@ (posedge clk);
	entradasPS = 10'b0000011111;

	# 600
	$finish;

end

initial begin
	$dumpfile("gtkws/testParaleloSerialSerialParalelo.vcd");
	$dumpvars;
	$display("		tiempo    | clk | rstContador |   timepo en escala usada");
	$monitor("%t      | %b   | %b  | $f ns", $time, clk, rst, $realtime);

end


endmodule
