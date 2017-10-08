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

	reg PDRS6, PDRS4;
	reg NDRS6 = 1;	
	reg NDRS4 = 1;	
	reg PDFS6, NDFS6, PDFS4, NDFS4; //ESTADO ANTERIOR
	reg alterno6;
	reg L03, L30, L12, L21;
	reg A, B, C, D, E, F, G, H;
	reg DB6n;
	reg [1:0] DBDR4;

//Nomenclatura de señales
//H G F E D C B A
//7 6 5 4 3 2 1 0

//j h g f i e d c b a
//9 8 7 6 5 4 3 2 1 0

//ahora se haya una logica combinacional que consigue las 10 entradas deseadas cada flanco de reloj:
//ingoramos la senal s

always @(posedge clk)begin

	A <= enb & entradas[0];
	B <= enb & entradas[1];
	C <= enb & entradas[2];
	D <= enb & entradas[3];
	E <= enb & entradas[4];
	F <= enb & entradas[5];
	G <= enb & entradas[6];
	H <= enb & entradas[7];

	L03 <= (~A)&(~B)&(~C);
	L30 <= (A)&(B)&(C);
	L12 <= (A&(~B)&(~C))|((~A)&B&(~C))|((~A)&(~B)&C);
	L21 <= (~A&B&C)|(A&~B&C)|(A&B&~C);


//	L03 <= (~entradas[0])&(~entradas[1])&(~entradas[2]);
//	L30 <= (entradas[0])&(entradas[1])&(entradas[2]);
//	L12 <= (entradas[0]&(~entradas[1])&(~entradas[2]))|((~entradas[0])&entradas[1]&(~entradas[2]))|((~entradas[0])&(~entradas[1])&entradas[2]);
//	L21 <= (~entradas[0]&entradas[1]&entradas[2])|(entradas[0]&~entradas[1]&entradas[2])|(entradas[0]&entradas[1]&~entradas[2]);


	//DIFERENTE: XOR ^
	//IGUAL: XNOR -^
	//Ingoro señal s como lo recomendó el profesor
	salidas[9] <= 	( (F^G)&~H | F&G&H&K );		//j
	salidas[8] <= 	H;				//h
	salidas[7] <= 	(G | ~F&~G&~H -^ G | ~F&~H);	//g
	salidas[6] <= 	(F&~(F&G&H&K));			//f
	salidas[5] <= 	(L21&~D&~E | L12&((D ^ E) | K) | L03&D&~E | L30&D&E);//i
	salidas[4] <= 	((E&~(L03&D)) | (L12&~D&~E) | (L03&D&~E));//e
	salidas[3] <=	((D&~(L30&D)));			//d
	salidas[2] <= 	(C|(L30&~D) | L03&D&(E -^ C) | (L03&(~D|D&E)) -^ C | L03&(~D|E));//c
	salidas[1] <= 	(B&~(L30&D)|L03&~D);		//b
	salidas[0] <= 	A;				//a

//Usar if(señal) asignaciones
//causa latches inferidos y esto hace el verilog no sintetizable
//
//Las siguientes lineas su utilizaban, segun el PDF de IBM para identificar
//cuando usar la forma primaria o alterna de las salidas sin embargo no
//funcionaron muy bien, motivo por el cual implementé esto de otra manera en
//las lineas posteriores.	
//	PDRS6 <= (L03&(D|~E)) | (L30&D&~E) | (L12&~D&~E);//Running Disparity
//	NDRS6 <= L30&(~D&E) |L03&~D&E | L21&D&E | K;
//	PDRS4 <= ~F&~G | (F ^ G)&K;
//	NDRS4 <= F&G;
//	if ((PDRS6 != NDRS6) & (PDRS4 != NDRS4)) alterno = 1;
//		else alterno = 0;
//	PDFS6 <= PDRS6;
//	PDFS4 <= PDRS4;
//	NDFS6 <= NDRS6;
//	NDFS4 <= NDRS4;

//	DB6n = L21&(~D|~E)|L30&~D&~E|L12&(D|E)&~K;
//	if(DB6n) alterno6 = 0 ; else alterno6 = 1;
//	if (alterno6) salidas[9:0] = salidas[9:0] ^ (10'b0000111111);

//	DBDR4[0] = (F ^ G | F&G&!H);
//	DBDR4[1] = (!(F ^ G)&K|(F&G));

//	DBDR4[1] = G&!F | !H&F | !G&F;	//DB
//	DBDR4[0] = G&F | K | !G&!F;	//DR

	//if(DB4n) alterno4 = 0 ; else alterno4 = 1;
	
//	if (DBDR4 != 2'b10) salidas[9:0] = salidas[9:0] ^ (10'b1111000000);//Hay shift


end

endmodule 
