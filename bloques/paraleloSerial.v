`timescale 1ns/1ps

module paraleloSerial(entradas,salida,clk);
input  wire [9:0] entradas;
input clk;
output reg salida;

integer contador = 0;

always @(posedge clk) begin
	salida = entradas[contador];
	++contador;
	if(contador == 10)contador = 0;

end

endmodule

