`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/clk/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/paraleloSerial/paraleloSerial.v"
`include "../build/paraleloSerial-sintetizado.v"

module testParaleloSerial ();

reg clk;
reg enb;
reg rst;

reg [9:0] entradas;
wire salida;
wire salidaSynth;


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
	.entradas(entradas),
	.salida(salida)
);
paraleloSerialSynth emisorSynth(
  .clk(clk),
	.rst(rst),
	.enb(enb),
	.clk10(clk10Synth),
	.entradas(entradas),
	.salida(salida)
);

integer periodo = 80;
integer reloj = 50;

integer periodoGrande = 800;
integer medioPeriodoGrande = 400;
integer cuartoPeriodoGrande = 200;

always # reloj clk = ~clk;//inicio de la señal de reloj, cambia cada 10ns


initial begin
  clk = 0;
  enb = 1;
	entradas = 10'b1010010101;
  rst = 1'b1;

  # cuartoPeriodoGrande
  @ (posedge clk);
  entradas = 10'b0000000001;

  # cuartoPeriodoGrande
  @ (posedge clk);
  entradas = 10'b1111111110;

  # cuartoPeriodoGrande
  @ (posedge clk);
  entradas = 10'b0111111111;

  # cuartoPeriodoGrande
  @ (posedge clk);
  entradas = 10'b1000000000;

  # cuartoPeriodoGrande
  @ (posedge clk);
  rst = 1'b0;

	# medioPeriodoGrande
  @ (posedge clk);
	entradas = 10'b1101101100;

	# 200
	@ (posedge clk);
	entradas = 10'b1111100000;

	# periodoGrande
	@ (posedge clk);
	entradas = 10'b0000011111;

  # periodoGrande
	@ (posedge clk);
	entradas = 10'b1101101101;

	# periodoGrande
	@ (posedge clk);
	entradas = 10'b1111100000;

	# periodoGrande
	@ (posedge clk);
	entradas = 10'b0000011111;

	# periodoGrande

	$finish;

end

initial begin
	$dumpfile("gtkws/testParaleloSerial.vcd");
	$dumpvars;
	$display("		tiempo    | clk | rstContador |   entradas    | salida | contadorE | timepo en escala usada");
	$monitor("%t      | %b   | %b           | %b      | %d         | %f ns",
		$time, clk, rst, entradas, salida, emisor.contador, $realtime);

end


endmodule
