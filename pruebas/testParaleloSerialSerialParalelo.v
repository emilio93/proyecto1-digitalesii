`timescale 1ns/1ps

`ifndef paraleloSerial
  `include "./bloques/paraleloSerial/paraleloSerial.v"
`endif
`ifndef serialParalelo
  `include "./bloques/paraleloSerial/serialParalelo.v"
`endif
`ifndef cmos_cells
  `include "./lib/cmos_cells.v"
`endif
`ifndef serialParaleloSynth
  `include "./build/serialParalelo-sintetizado.v"
`endif
`ifndef serialParaleloSynth
  `include "./build/paraleloSerial-sintetizado.v"
`endif
module testParaleloSerialSerialParalelo ();

reg clk;
reg rstContador;

reg [9:0] entradasPS;
wire salidaPS;


wire [9:0] salidasSP;

wire salidaPSSynth;
wire [9:0] salidasSPSynth;

paraleloSerial emisor(
	.entradas(entradasPS),
	.salida(salidaPS),
  .clk(clk),
  .rstContador(rstContador)
);

serialParalelo receptor(
	.entrada(salidaPS),
	.salidas(salidasSP),
  .clk(clk),
  .rstContador(rstContador)
);

paraleloSerialSynth emisorSynth(
  .entradas(entradasPS),
  .salida(salidaPSSynth),
  .clk(clk),
  .rstContador(rstContador)
  );

serialParaleloSynth receptorSynth(
	.entrada(salidaPSSynth),
	.salidas(salidasSPSynth),
  .clk(clk),
  .rstContador(rstContador)
);

integer periodo=100;
integer reloj=50;

integer relojGrande=1000;
integer relojGrande2=2000;
integer periodoGrande=1000;
integer periodoGrande2=2000;
always # reloj clk = ~clk;//inicio de la señal de reloj, cambia cada 10ns

initial begin
	clk = 0;
	entradasPS = 10'b1010010101;
  rstContador = 1'b1;

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
  entradasPS = 10'b1000000000;

  # relojGrande
  @ (posedge clk);
  rstContador = 1'b0;

	# relojGrande
  @ (posedge clk);
	entradasPS = 10'b1100101100;

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
	$monitor("%t      | %b   | %b  | $f ns", $time, clk, rstContador, $realtime);

end


endmodule
