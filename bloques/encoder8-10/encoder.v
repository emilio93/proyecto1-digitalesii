`timescale 1ns/1ps

module encoder(	//8 to 10 bit encoder
	entradas,
	salidas,
	K,
	clk,
	enb,
	);

	input wire [7:0] entradas;
	input wire clk, K, enb;
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
/*	j <= 	( (entradas[5]^entradas[6])&~entradas[7] | entradas[5]&entradas[6]&entradas[7]&K );		//j
	h <= 	entradas[7];				//h
	g <= 	(entradas[6] | ~entradas[5]&~entradas[6]&~entradas[7] -^ entradas[6] | ~entradas[5]&~entradas[7]);	//g
	f <= 	(entradas[5]&~(entradas[5]&entradas[6]&entradas[7]&K));			//f
	i <= 	(L21&~entradas[3]&~entradas[4] | L12&((entradas[3] ^ entradas[4]) | K) | L03&entradas[3]&~entradas[4] | L30&entradas[3]&entradas[4]);//i
	e <= 	( (entradas[4]&(~(L03&entradas[3]))) | (L12&(~entradas[3])&(~entradas[4])) | (L03&entradas[3]&~entradas[4]));//e
	d <=	((entradas[3]&~(L30&entradas[3])));			//d
	c <= 	( (entradas[2]|(L30&(~entradas[3])))  |  ((L03&entradas[3]&entradas[4]) -^ entradas[2])  |  ((L03&((~entradas[3])|(entradas[3]&entradas[4]))) -^ entradas[2])  | ( L03&((~entradas[3])|entradas[4])) );//c
	b <= 	(entradas[1]&~(L30&entradas[3]) | L03&~entradas[3]);		//b
	a <= 	entradas[0];				//a
*/


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


//end

//always @(posedge clk)begin

/*	salidas[9] <= 	j;
	salidas[8] <= 	h;
	salidas[7] <= 	g;
	salidas[6] <= 	f;
	salidas[5] <= 	i;
	salidas[4] <= 	e;
dfdf	salidas[3] <=	d;
	salidas[2] <= 	c;
	salidas[1] <= 	b;
	salidas[0] <= 	a;
*/
end

endmodule 

