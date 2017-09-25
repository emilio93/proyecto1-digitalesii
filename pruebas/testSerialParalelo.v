`timescale 1ns/1ps

`ifndef serialParalelo
  `include "./bloques/paraleloSerial/serialParalelo.v"
`endif
`ifndef cmos_cells
  `include "./lib/cmos_cells.v"
`endif
`ifndef serialParaleloSynth
  `include "./build/serialParalelo-sintetizado.v"
`endif

module testSerialParalelo ();

reg clk;
reg rstContador;

reg entrada;
wire [9:0] salidas;
wire [9:0] salidasSynth;


serialParalelo receptor(
	.entrada(entrada),
	.salidas(salidas),
  .clk(clk),
  .rstContador(rstContador)
);

serialParaleloSynth receptorSynth(
	.entrada(entrada),
	.salidas(salidasSynth),
  .clk(clk),
  .rstContador(rstContador)
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

  # periodo
  @ (posedge clk);
  entrada = 1'bx;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;

  # periodo
  @ (posedge clk);
  entrada = 1'b1;

  # periodo
  @ (posedge clk);
  rstContador = 1'b0;
  entrada = 1'b1;

  # periodoGrande
  @ (posedge clk);
  entrada = 1'b0;

  # periodoGrande
  @ (posedge clk);
  entrada = 1'bx;

	# periodoGrande
  @ (posedge clk);
	entrada = 1'b1;



  # periodo
  @ (posedge clk);
  entrada = 1'b1;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;

  # periodo
  @ (posedge clk);
  entrada = 1'b1;

  # periodo
  @ (posedge clk);
  entrada = 1'b1;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;

  # periodo
  @ (posedge clk);
  entrada = 1'b1;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;

  # periodo
  @ (posedge clk);
  entrada = 1'b1;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;

  # periodo
  @ (posedge clk);
  entrada = 1'b1;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;

  # periodo
  @ (posedge clk);
  entrada = 1'b1;

  # periodo
  @ (posedge clk);
  entrada = 1'b1;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;

  # periodo
  @ (posedge clk);
  entrada = 1'b1;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;

  # periodo
  @ (posedge clk);
  entrada = 1'b1;

  # periodo
  @ (posedge clk);
  entrada = 1'b0;



  # periodoGrande
  @ (posedge clk);
  rstContador = 1'b1;

  # periodoGrande
  # periodoGrande
  @ (posedge clk);
  entrada = 1'b0;

  # periodoGrande
  # periodoGrande
  @ (posedge clk);
  entrada = 1'bx;

  # periodoGrande
  # periodoGrande
  @ (posedge clk);
  entrada = 1'b1;

  # periodoGrande
	# 250
	$finish;

end

initial begin
	$dumpfile("gtkws/testSerialParalelo.vcd");
	$dumpvars;
	$display("		tiempo    | clk | rstContador |   entradas    | salida | contadorE | timepo en escala usada");
	$monitor("%t      | %b   | %b           | %b      | %d         | %f ns",
		$time, clk, rstContador, entrada, salidas, receptor.contador, $realtime);

end


endmodule
