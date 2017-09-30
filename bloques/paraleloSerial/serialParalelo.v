`timescale 1ns/1ps

// Este módulo se encarga de escuchar n bits en n ciclos
// de reloj, y enviarlos una vez que se han adquirido los
// n bits.
module serialParalelo(
	clk,
	rst,
	enb,
	clk10,
	entrada,
	salidas
);

parameter cantidadBits = 10;

input wire clk;
input wire rst;
input wire enb;

input wire clk10;

// El bit que se lee
input wire entrada;

// el arreglo que almacena los bits durante los n ciclos de
// reloj que se almacenan los valores.
output reg [cantidadBits-1:0] salidas;

reg [3:0] contador;

// Se utiliza para mantener la entrada
// cada vez que esta entra(cada 10 flancos
// positivos de reloj) independientemente
// de que esta señal de entrada cambie en el
// transcurso de esos flancos
reg [cantidadBits-1:0] bits;

always @(posedge clk) begin
	if (rst) begin
		contador <= 9;
	end else if (enb) begin
		if (contador >= cantidadBits-1) begin
			contador <= 0;
			bits[0] <= entrada;
			salidas <= bits;
		end else begin
			bits[contador+1] <= entrada;
			contador <= contador + 1;
		end
	end
end

endmodule
