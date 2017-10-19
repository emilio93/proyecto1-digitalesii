`timescale 1ns/1ps

module encoder(	//8 to 10 bit encoder
	entradas,
	salidas,
	K,
	clk,
	enb,
	rst
	);
	//parametro para selecionar posicion en la memoria de contador
	parameter PwrC=0;

	input wire [7:0] entradas;
	input wire clk, K, enb, rst;
	output reg [9:0] salidas;//wire no funca
	reg j, h, g, f, i, e, d, c, b, a;
	reg L03, L30, L12, L21;

//Nomenclatura de señales
//H G F E D C B A
//7 6 5 4 3 2 1 0

//j h g f i e d c b a
//9 8 7 6 5 4 3 2 1 0

//ahora se haya una logica combinacional que consigue las 10 entradas deseadas cada flanco de reloj:
//ingoramos la senal s

always @(*)begin

	L03 <= (~entradas[0])&(~entradas[1])&(~entradas[2]);
	L30 <= (entradas[0])&(entradas[1])&(entradas[2]);
	L12 <= (entradas[0]&(~entradas[1])&(~entradas[2]))|((~entradas[0])&entradas[1]&(~entradas[2]))|((~entradas[0])&(~entradas[1])&entradas[2]);
	L21 <= (~entradas[0]&entradas[1]&entradas[2])|(entradas[0]&~entradas[1]&entradas[2])|(entradas[0]&entradas[1]&~entradas[2]);

end

always @(posedge clk)begin

	//DIFERENTE: XOR ^
	//IGUAL: XNOR -^
	//Ingoro señal s como lo recomendó el profesor
	if (rst) begin
		salidas <= 10'b0;
	end else if (~rst && enb) begin
		salidas[9]  <= 	( (entradas[5]^entradas[6])&~entradas[7] | entradas[5]&entradas[6]&entradas[7]&K );		//j
		salidas[8]  <= 	entradas[7];				//h
		salidas[7]  <= 	(entradas[6] | ~entradas[5]&~entradas[6]&~entradas[7] -^ entradas[6] | ~entradas[5]&~entradas[7]);	//g
		salidas[6]  <= 	(entradas[5]&~(entradas[5]&entradas[6]&entradas[7]&K));			//f
		salidas[5]  <= 	(L21&~entradas[3]&~entradas[4] | L12&((entradas[3] ^ entradas[4]) | K) | L03&entradas[3]&~entradas[4] | L30&entradas[3]&entradas[4]);//i
		salidas[4]  <= 	( (entradas[4]&(~(L03&entradas[3]))) | (L12&(~entradas[3])&(~entradas[4])) | (L03&entradas[3]&~entradas[4]));//e
		salidas[3]  <=	((entradas[3]&~(L30&entradas[3])));			//d
		salidas[2]  <= 	( (entradas[2]|(L30&(~entradas[3])))  |  ((L03&entradas[3]&entradas[4]) -^ entradas[2])  |  ((L03&((~entradas[3])|(entradas[3]&entradas[4]))) -^ entradas[2])  | ( L03&((~entradas[3])|entradas[4])) );//c
		salidas[1]  <= 	(entradas[1]&~(L30&entradas[3]) | L03&~entradas[3]);		//b
		salidas[0]  <= 	entradas[0];				//a
	end
end

//Codigo de intrumentacion para el conteo de transiciones
//para solo contar transiciones en conductual, sin modificar la libreria
`ifdef SIMULATION_conductual
  always @(posedge salidas[0]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[1]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[2]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[3]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[4]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[5]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[6]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[7]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[8]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[9]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
`endif


endmodule
