`timescale 1ns/1ps

`ifndef paraleloSerial
  `include "./bloques/paraleloSerial/paraleloSerial.v"
`endif
`ifndef cmos_cells
  `include "./lib/cmos_cells.v"
`endif
`ifndef paraleloSerialSynth
  `include "./build/paraleloSerial-sintetizado.v"
`endif

module testParaleloSerial ();

reg clk;
reg rstContador;

reg [9:0] entradas;
wire salida;
wire salidaSynth;


paraleloSerial emisor(
	.entradas(entradas),
	.salida(salida),
  .clk(clk),
  .rstContador(rstContador)
);

paraleloSerialSynth emisorSynth(
	.entradas(entradas),
	.salida(salidaSynth),
  .clk(clk),
  .rstContador(rstContador)
);

integer periodo = 80;
integer reloj = 50;

integer periodoGrande = 800;
integer medioPeriodoGrande = 400;
integer cuartoPeriodoGrande = 200;

always # reloj clk = ~clk;//inicio de la señal de reloj, cambia cada 10ns


initial begin
	clk = 0;
	entradas = 10'b1010010101;
  rstContador = 1'b1;

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
  rstContador = 1'b0;

	# medioPeriodoGrande
  @ (posedge clk);
	entradas = 10'bx10x10x10x;

	# periodoGrande
	@ (posedge clk);
	entradas = 10'b1111100000;

	# periodoGrande
	@ (posedge clk);
	entradas = 10'b0000011111;

  # periodoGrande
	@ (posedge clk);
	entradas = 10'bx10x10x10x;

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
		$time, clk, rstContador, entradas, salida, emisor.contador, $realtime);

end


endmodule
