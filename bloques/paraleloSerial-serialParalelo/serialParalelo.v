`timescale 1ns/1ps

// Este módulo se encarga de escuchar n bits en n ciclos
// de reloj, y enviarlos una vez que se han adquirido los
// n bits.
module serialParalelo(
  clk, rst, enb,
  clk10,
  entrada,
  salidas
);
//parametro para selecionar posicion en la memoria de contador
parameter PwrC=0;

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
    contador <= 0;
  end else if (enb) begin
    contador <= contador == 0 ? cantidadBits-1 : contador-1;
    bits[contador] <= entrada;
    if (contador ==  0) begin
      salidas <= {bits[cantidadBits-1:1], entrada};
    end
  end
end

//Codigo de intrumentacion para el conteo de transiciones
//para solo contar transiciones en conductual, sin modificar la libreria
`ifdef SIMULATION_conductual
  always @(posedge salidas[0]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[1]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[2]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[3]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[4]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[5]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[6]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[7]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[8]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
	always @(posedge salidas[9]) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
`endif

endmodule
