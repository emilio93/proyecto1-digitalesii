`timescale 1ns/1ps

// Este módulo se encarga de serializar una entrada paralela
// tomada cada n ciclos de reloj
//
// Lo que hace es almacenar en un arreglo 'bits' de n-1 wires
// la entrada tamada caada n ciclos de reloj.
//
// De este arreglo se entrega ordenadamente cada uno de sus
// elementos cada ciclo de reloj, luego de entregar el último
// elemento debe asignar a 'bits' las entradas, pero también
// debe entregar la primera entrada que aun no está en 'bits',
// se entrega la entrada directamente.
//
// Nota: precisamente por el hecho mencionado sobre lo que
// ocurre luego de cada n ciclo de reloj, el elemento de
// 'bits' que almacena esta entrada no es necesario, por
// lo que puede no utilizarse, reduciendo el consumo de
// potencia.
//
// Queda pendiente probar con la síntesis de yosys si al
// optimizar el diseño, el consumo permanece igual.

/*COMENTARIO_BOA:De la consulta que hice al profe, me parece que deberia de haber 2 CLK de entrada,
uno para sincronizar las salidas serializadas(el mas rapido),
y otro para sincronizar la lectura de los 8 bits de entrada(mas lento, multiplo del mas rapido)*/

module paraleloSerial(
	clk,
	rst,
	enb,
	clk10,
	entradas,
	salida
);

// esto es n en la explicación del módulo
parameter cantidadBits = 10;

// señales de control
input wire clk;
input wire enb;
input wire rst;

input wire clk10;

// Se tienen n entradas
input wire [cantidadBits-1:0] entradas;

// La salida es serial, por lo tanto es un solo elemento
output reg salida;

// Se utiliza para mantener la entrada
// cada vez que esta entra(cada 10 flancos
// positivos de reloj) independientemente
// de que esta señal de entrada cambie en el
// transcurso de esos flancos
reg [cantidadBits-1:0] bits;

// El modulo se encarga de identificar cuando
// debe reiniciar el contador a partir de una
// cuenta de ciclos de reloj
// El reg contador se encarga de llevar la
// cuenta de ciclos de reloj.
reg [3:0] contador;

// Únicamente se realizan operaciones no bloqueantes
// por lo que se utiliza un bloque que se ejecuta cada
// flanco positivo de reloj
always @(posedge clk) begin

	// Cuando rstContador está encendido se
	// asigna 0 al contador, se obtienen las
	// entradas y se envia la primer salida
	if (rst) begin
		contador <= 9;
		bits <= entradas;
	end else if (enb) begin
		salida <= bits[contador];
		if (contador >= cantidadBits-1) begin
			bits <= entradas;
			contador <= 0;
		end else begin
		contador <= contador + 1;
		end
	end
end
endmodule
