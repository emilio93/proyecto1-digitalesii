module 8to10coder(
	entradas,
	salidas,
	dataK,
	clk	
	);

input wire [7:0] entradas;
input wire clk;
input wire k;
output wire [9:0] salidas;

reg L03, L30, L21, L21;

//

//H G F E D C B A
//7 6 5 4 3 2 1 0


//j h g f i e d c b a
//9 8 7 6 5 4 3 2 1 0
//ahora se haya unca logica combinacional que consigue las 10 entradas deseadas cada flanco de reloj:
//ingoramos la senal s

always @(posedge clk) begin

L03 <= (~entradas[0])&(~entradas[1])&(~entradas[2]);
L30 <= (entradas[0])&(entradas[1])&(entradas[2]);
L12 <= (entradas[0]&~entradas[1]&~entradas[2])|(~entradas[0]&entradas[1]&~entradas[2])|(~entradas[0]&~entradas[1]&entradas[2]));
L21 <= (~entradas[0]&entradas[1]&entradas[2])|(entradas[0]&~entradas[1]&entradas[2])|(entradas[0]&entradas[1]&~entradas[2]);

end

always @(negedge clk) begin

salidas[9] <= 	entradas[1];
salidas[8] <= 	entradas[0];
salidas[7] <= 	entradas[0];
salidas[6] <= 	entradas[0];
salidas[5] <= 	entradas[0];
salidas[4] <= 	entradas[0];
salidas[3] <= 	entradas[0];
salidas[2] <= 	entradas[0];
salidas[1] <= 	entradas[0];
salidas[0] <= 	entradas[0];

end

endmodule 
