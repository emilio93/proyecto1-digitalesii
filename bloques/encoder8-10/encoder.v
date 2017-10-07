module encoder(	//8 to 10 bit encoder
	entradas,
	salidas,
	K,
	clk,
	enb,
	);

input wire [7:0] entradas;
input wire clk;
input wire K, enb;
output reg [9:0] salidas;//wire no funca

reg PDRS6, NDRS6, PDRS4, NDRS4;
reg PDFS6, NDFS6, PDFS4, NDFS4; //ESTADO ANTERIOR
reg alterno, DBn;
reg L03, L30, L12, L21;
reg A, B, C, D, E, F, G, H;

//H G F E D C B A
//7 6 5 4 3 2 1 0

//j h g f i e d c b a
//9 8 7 6 5 4 3 2 1 0
//ahora se haya unca logica combinacional que consigue las 10 entradas deseadas cada flanco de reloj:
//ingoramos la senal s

parameter retardo = 10;

//always @(clk)begin

always @(negedge clk) begin

//	alterno = 0;
//	NDRS6 = 1;
//	NDRS4 = 1;
//	PDRS6 = 0;
//	PDRS4 = 0;

	if(enb)begin

	L03 <= (~entradas[0])&(~entradas[1])&(~entradas[2]);
	L30 <= (entradas[0])&(entradas[1])&(entradas[2]);
	L12 <= (entradas[0]&(~entradas[1])&(~entradas[2]))|((~entradas[0])&entradas[1]&(~entradas[2]))|((~entradas[0])&(~entradas[1])&entradas[2]);
	L21 <= (~entradas[0]&entradas[1]&entradas[2])|(entradas[0]&~entradas[1]&entradas[2])|(entradas[0]&entradas[1]&~entradas[2]);

	A <= entradas[0];
	B <= entradas[1];
	C <= entradas[2];
	D <= entradas[3];
	E <= entradas[4];
	F <= entradas[5];
	G <= entradas[6];
	H <= entradas[7];

	#retardo;

	//DIFERENTE: XOR ^
	//IGUAL: XNOR -^
	//Ingoro señal s como lo recomendó el profesor
//	salidas[9] <= 	(F^G)&~H | F&G&H&K;	//j
//	salidas[8] <= 	H;			//h
//	salidas[7] <= 	G | ~F&~G&~H -^ G | ~F&~H;//g
//	salidas[6] <= 	F&~(F&G&H&K);		//f
	salidas[5] <= 	L21&~D&~E | L12&((D ^ E) | K) | L03&D&~E | L30&D&E;//i
	salidas[4] <= 	(E&~(L03&D)) | (L12&~D&~E) | (L03&D&~E);//e
	salidas[3] <=	(D&~(L30&D));		//d
	salidas[2] <= 	C|(L30&~D) | L03&D&(E -^ C) | (L03&(~D|D&E)) -^ C | L03&(~D|E);//c
	salidas[1] <= 	B&~(L30&D)|L03&~D;	//b
	salidas[0] <= 	A;			//a

	#retardo

//DR cambia menos que DB para inventir señal	
//~
	PDRS6 <= (L03&(D|~E)) | (L30&D&~E) | (L12&~D&~E);//Running Disparity
	NDRS6 <= L30&(~D&E) |L03&~D&E | L21&D&E | K;
	PDRS4 <= ~F&~G | (F ^ G)&K;
	NDRS4 <= F&G;

//	if ((PDRS6 != NDRS6) & (PDRS4 != NDRS4)) alterno = 1;
//		else alterno = 0;

	DBn = L21&(~D|~E)|L30&~D&~E|L12&(D|E)&~K;
	if(DBn) alterno = 0 ; else alterno = 1;

	PDFS6 <= PDRS6;
	PDFS4 <= PDRS4;
	NDFS6 <= NDRS6;
	NDFS4 <= NDRS4;

	if (alterno) salidas[9:0] = salidas[9:0] ^ (10'b1111111111);
end//if

end

//always @(negedge clk) begin
//end

endmodule 
