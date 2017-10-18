`timescale 1ns/1ps

// convierte una señal seleccionada por dataS de n a 8 bits segun sea el caso.
//  dataS = 00 o 11 -> funcionamiento para 8 bits
//  dataS = 01      -> funcionamiento para 16 bits
//  dataS = 10      -> funcionamiento para 32 bits
//
//  Este módulo espera una señal bien temporizada
module to8bit(
  rst, enb, clk,
  clk16, clk32,
  dataIn, dataIn16, dataIn32,
  dataS,
  dataOut
);
  //parametro para selecionar posicion en la memoria de contador
  parameter PwrC=0;
  // Señales básicas
  input wire rst;
  input wire enb;
  input wire clk;   // reloj con frecuencia base
  input wire clk16; // reloj con mitad de frecuencia base
  input wire clk32; // reloj con cuarto de frecuencia base

  input wire [7:0]  dataIn;   // entrada de 8 bits
  input wire [15:0] dataIn16; // entrada de 16 bits
  input wire [31:0] dataIn32; // entrada de 32 bits
  input wire [1:0]  dataS;    // selección de entrada y funcionamiento

  output reg [7:0] dataOut; // salida del módulo

  reg [1:0] contador;

  always @ ( * ) begin
    if (dataS == 2'b01) begin
      dataOut = contador == 0 ? dataIn16[15:8] : dataIn16[7:0];
    end else if (dataS == 2'b10) begin
      if (contador == 0) dataOut = dataIn32[31:24];
      else if (contador == 2'b01) dataOut = dataIn32[23:16];
      else if (contador == 2'b10) dataOut = dataIn32[15:8];
      else dataOut = dataIn32[7:0]; // if (~clk32 && ~clk16)
    end else begin
      dataOut = dataIn;
    end
  end

  always @ (posedge clk) begin
    if (dataS == 2'b01) begin
      contador <= contador >= 2'b01 ? 0 : contador + 1;
    end else if (dataS ==2'b10) begin
      contador <= contador >= 2'b11 ? 0 : contador + 1;
    end else begin
      contador <= 0;
    end
  end

endmodule
