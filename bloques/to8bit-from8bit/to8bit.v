`timescale 1ns/1ps

// convierte una señal seleccionada por dataS de n a 8 bits segun sea el caso.
//  dataS = 00 o 11 -> funcionamiento para 8 bits
//  dataS = 01      -> funcionamiento para 16 bits
//  dataS = 10      -> funcionamiento para 32 bits
//
//  Este módulo espera una señal bien temporizada
module to8bit(
  rst,
  enb,
  clk, clk16, clk32,
  dataIn, dataIn16, dataIn32,
  dataS,
  dataOut
);
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

  always @ ( * ) begin
    if (dataS == 2'b01) begin
      if (clk16) dataOut = dataIn16[7:0];
      else dataOut = dataIn16[15:8];
    end else if (dataS == 2'b10) begin
      if (clk32 && clk16) dataOut = dataIn32[7:0];
      else if (clk32 && ~clk16) dataOut = dataIn32[15:8];
      else if (~clk32 && clk16) dataOut = dataIn32[23:16];
      else dataOut = dataIn32[31:24]; // if (~clk32 && ~clk16)
    end else begin
      dataOut = dataIn;
    end
  end

endmodule
