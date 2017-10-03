`timescale 1ns/1ps

// Este módulo se encarga de serializar una entrada paralela
// cada n ciclos de reloj
module paraleloSerial(
  clk, rst, enb,
  clk10,
  entradas,
  salida
);

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

// El modulo se encarga de identificar cuando
// debe reiniciar el contador a partir de una
// cuenta de ciclos de reloj
// El reg contador se encarga de llevar la
// cuenta de ciclos de reloj.
reg [3:0] contador;

// la salida es 0 si rst está encendido o enb está
// apagado
// sino la salida va a ser la correspondiente al
// contador
always @ ( * ) begin
  salida = ~rst & enb ? entradas[contador] : 0;
end

always @(posedge clk) begin
  // Cuando rst está encendido se
  // asigna 0 al contador para comenzar con 9
  // inmediatamente se de el flanco positivo
  if (rst) begin
    contador <= 0;
  end else begin
    // contador de 9 a 0 en funcionamiento normal
    contador <= contador == 0 ? cantidadBits-1 : contador-1;
  end
end
endmodule
