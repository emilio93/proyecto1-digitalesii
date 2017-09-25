`timescale 1ns/1ps

// Este módulo se encarga de escuchar n bits en n ciclos
// de reloj, y enviarlos una vez que se han adquirido los
// n bits.
//
// Para llevar la cuenta del bit, se utiliza un contador
// de ciclos de reloj
module serialParalelo(entrada, salidas, clk, rstContador);

parameter cantidadBits = 10;

// El bit que se lee
input wire entrada;

// el arreglo que almacena los bits durante los n ciclos de
// reloj que se almacenan los valores.
output reg [cantidadBits-1:0] salidas;
input wire clk;
input wire rstContador;

// Se utiliza para mantener la entrada
// cada vez que esta entra(cada 10 flancos
// positivos de reloj) independientemente
// de que esta señal de entrada cambie en el
// transcurso de esos flancos
reg [cantidadBits-1:0] bits;

reg [cantidadBits-1:0] contador;

always @(posedge clk) begin
	if (rstContador) begin
		contador <= 0;
		bits[0] <= entrada;
	end
	if (!rstContador) begin
		if (contador == 0) begin
			bits[1] <= entrada;
			contador <= contador + 1;
		end else if (contador < (cantidadBits-1)) begin
			bits[contador+1] <= entrada;
			contador <= contador + 1;
		end else begin
			contador <= 0;
			salidas <= bits;
			bits[0] <= entrada;
		end
	end
end
endmodule
