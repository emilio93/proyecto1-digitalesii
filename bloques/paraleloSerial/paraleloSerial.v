`timescale 1ns/1ps

module paraleloSerial(entradas, salida, clk);

parameter cantidadBits = 10;

input wire [cantidadBits-1:0] entradas;
output reg salida;
input wire clk;

// Se utiliza para mantener la entrada
// cada vez que esta entra(cada 10 flancos
// positivos de reloj) independientemente
// de que esta señal de entrada cambie en el
// transcurso de esos flancos
reg [cantidadBits-1:0] bits;

reg contador = 0;

always @(posedge clk) begin
	contador = contador + 1;
	salida <= bits[contador];
	if(contador == cantidadBits) begin
		contador = 0;
		bits <= entradas;
		salida <= entradas[0];
	end
end

endmodule
