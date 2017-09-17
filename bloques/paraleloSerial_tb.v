`timescale 1ns/1ps

/*
`ifndef paraleloSerial
  `include "paraleloSerial.v"
`endif
`ifndef serialParalelo
  `include "serialParalelo.v"
`endif
*/

module testerComunicaionPS();

reg clk;

reg [9:0] entradasPS;
wire salidaPS;

wire [9:0] salidasSP;


paraleloSerial emisor(
	.clk(clk),
	.entradas(entradasPS),
	.salida(salidaPS)
);

serialParalelo receptor(
	.clk(clk),
	.entrada(salidaPS),
	.salidas(salidasSP)
);

always # 10.4 clk = ~clk;//inicio de la señal de reloj, cambia cada 10.4 ns


initial begin

	#10.4 clk = 0;

	entradasPS = 10'b1010010101;

	#208

	entradasPS = 10'b1111100000;

	#208
	
	entradasPS = 10'b0000011111;

	#208

	$finish;
	
end

initial begin
	$dumpfile("testComSerialParalelo.vcd");
	$dumpvars;
	$display("		tiempo    |clk |   entradaPS   |salPS|  salidaSP   | contadorE |contadorR | timepo en escala usada");
	$monitor("%t      | %b  |   %b  |  %b  | %b  |%d|%d| %f ns",
		$time, clk, entradasPS, salidaPS, salidasSP,receptor.contador,emisor.contador, $realtime);

end

endmodule


