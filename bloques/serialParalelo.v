`timescale 1ns/1ps

module serialParalelo(entrada, salidas, clk);

input wire entrada;
output reg [9:0] salidas;
input clk;

integer contador = 0;

always @(posedge clk) begin
	salidas[contador] = entrada;
	++contador;
	if(contador == 10) contador = 0;
end

endmodule
