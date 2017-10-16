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

// señal de reloj cada 10 ciclos
input wire clk10;

// Se tienen n entradas.
// El MSB es el bit cantidadBits-1
// El LSB es el bit 0
input wire [cantidadBits-1:0] entradas;

// La salida es serial, por lo tanto es un solo elemento
output reg salida;

// El modulo se encarga de identificar cuando
// debe reiniciar el contador a partir de una
// cuenta de ciclos de reloj
// El reg contador se encarga de llevar la
// cuenta de ciclos de reloj.
// la cantidad de bits de este contador debe ser
// de al menos log_2(cantidadBits) redondeado al
// entero mayor.
// log_2(10) =~ 3.322 => 4 bits
reg [3:0] contador;
//reg [3:0] contador = cantidadBits - 1;

// la salida es 0 si rst está encendido o enb está
// apagado
// sino la salida va a ser la correspondiente al
// contador
// Al usar un operador ternario se asumen todos los
// casos evitando latches.
always @ ( * ) begin
salida = ~rst & enb ? entradas[contador] : 0;
end

// Bloque secuencial.
always @(posedge clk) begin
  // Cuando rst está encendido se
  // asigna 0 al contador para comenzar con 9
  // inmediatamente se da el flanco positivo
  if (rst) begin
    // el contadorse resetea a 0 para que el primer
    // bit que tome sea el mayor, luego se continua
    // en orden descendente.
    contador <= 0;
  end else if(enb) begin
    // contador de 9 a 0 en funcionamiento normal.
    // el contador representa el bit de la entrada que pasa a
    // la salida.
    contador <= contador == 0 ? cantidadBits-1 : contador-1;
  end
  else  contador = contador;
  end
endmodule
