`timescale 1ns/1ps

module serialParalelo(entrada, salidas, clk);

parameter cantidadBits = 10;

input wire entrada;
output reg [cantidadBits-1:0] salidas;
input wire clk;

reg [cantidadBits-1:0] bits;

reg contador = 0;

always @(posedge clk) begin
	bits[contador] <= entrada;
	contador <= contador + 1;
	if(contador == cantidadBits) begin
		contador <= 0;
		salidas <= bits;
		salidas[cantidadBits-1] <= entrada;
	end
end

endmodule
