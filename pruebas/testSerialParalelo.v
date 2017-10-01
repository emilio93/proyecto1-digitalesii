`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/clk/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/paraleloSerial/serialParalelo.v"
`include "../build/serialParalelo-sintetizado.v"

module testSerialParalelo ();

reg clk;
reg enb;
reg rstContador;

reg entrada;
reg [9:0] esperado; // valor esperado en paralelo
wire [9:0] salidas;
wire [9:0] salidasSynth;

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
  .rst(rstContador),
  .enb(enb)
);

clksSynth clkGenSynth(
  .clk(clk),
  .clk10(clk10Synth),
  .clk20(clk20Synth),
  .clk40(clk40Synth),
  .rst(rstContador),
  .enb(enb)
);

serialParalelo receptor(
  .clk(clk),
  .rst(rstContador),
  .enb(enb),
  .clk10(clk10),
	.entrada(entrada),
	.salidas(salidas)
);

serialParaleloSynth receptorSynth(
  .clk(clk),
  .rst(rstContador),
  .enb(enb),
  .clk10(clk10Synth),
	.entrada(entrada),
	.salidas(salidasSynth)
);

integer periodo = 80;
integer reloj = 40;

integer periodoGrande = 800;
integer medioPeriodoGrande = 400;
integer cuartoPeriodoGrande = 200;

always # reloj clk = ~clk;//inicio de la señal de reloj, cambia cada 10ns

initial begin
	clk = 0;
	entrada = 1'b1;
  rstContador = 1'b1;
  enb = 0;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;
  enb = 1;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;

  # periodo
  @ (posedge clk);
  entrada = 1'b1;


  //
  // SE APAGA rstContador
  //
  # periodo
  @ (posedge clk);
  rstContador = 1'b0;
  entrada = 1'b1;

  @ (posedge clk10);
  esperado = 10'b1011001100;
  entrada = 1'b0;
  # 1 @ (posedge clk);
  entrada = 1'b1;
  # 1 @ (posedge clk);
  entrada = 1'b1;
  # 1 @ (posedge clk);
  entrada = 1'b0;
  # 1 @ (posedge clk);
  entrada = 1'b0;
  # 1 @ (posedge clk);
  entrada = 1'b1;
  # 1 @ (posedge clk);
  entrada = 1'b1;
  # 1 @ (posedge clk);
  entrada = 1'b0;
  # 1 @ (posedge clk);
  entrada = 1'b0;


  @ (posedge clk);
  entrada = 1'b1;


  @ (posedge clk);

  entrada = 1'b0;
  @ (posedge clk);
  entrada = 1'b0;
  @ (posedge clk);
  esperado = 10'b0011001100;
  entrada = 1'b1;
  @ (posedge clk);
  entrada = 1'b1;
  @ (posedge clk);
  entrada = 1'b0;
  @ (posedge clk);
  entrada = 1'b0;
  @ (posedge clk);
  entrada = 1'b1;
  @ (posedge clk);
  entrada = 1'b1;
  @ (posedge clk);
  entrada = 1'b0;
  @ (posedge clk);
  entrada = 1'b0;

  # 400
  @ (posedge clk);
  entrada = 1'b1;



  # 400
  @ (posedge clk);
  rstContador = 1'b1;

  # 50
  @ (posedge clk);
  entrada = 1'b0;

  # 50
  # periodoGrande
  @ (posedge clk);
  entrada = 1'b1;

  # 50
  @ (posedge clk);
  entrada = 1'b1;

	# 50
	$finish;

end

initial begin
	$dumpfile("gtkws/testSerialParalelo.vcd");
	$dumpvars;
	$display("		tiempo    | clk | rstContador |   entradas    | salida | contadorE | timepo en escala usada");
	$monitor("%t      | %b   | %b           | %b          | %f ns",
		$time, clk, rstContador, entrada, salidas, $realtime);

end


endmodule
