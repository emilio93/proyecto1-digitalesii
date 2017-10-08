`timescale 1ns/1ps

// convierte una señal seleccionada por dataS de 8 a n bits segun sea el caso.
// dataS = 00 o 11 -> funcionamiento para 8 bits
// dataS = 01 -> funcionamiento para 16 bits
// dataS = 10 -> funcionamiento para 32 bits
//
// En cada flanco sucede lo siguiente:
// se entregan las salidas según el estado actual
// se lee un estado de lectura
//
module from8bit(
  rst, enb,
  clk, clk8, clk16, clk32,
  dataIn,
  dataS,
  dataOut, dataOut16, dataOut32,
  // estas salidas no son necesarias,
  // se agregan para ver sus ondas en
  // gtkwave
  bits,
  contador,
  dataSInternal
);

  // Señales básicas
  input wire rst;
  input wire enb;
  input wire clk;   // reloj con frecuencia máxima(para resets)
  input wire clk8;  // reloj con frecuencia base
  input wire clk16; // reloj con mitad de frecuencia base
  input wire clk32; // reloj con cuarto de frecuencia base

  input wire [7:0] dataIn; // entrada serial de 8 bits
  input wire [1:0] dataS;  // seleccion de cantidad de bits de salida

  output reg [1:0] dataSInternal; // indica cual es la cantidad de bits de salida
                                // por ejemplo, cuando dataS cambia a 01, debe
                                // esperarse 2 clk8 para tener los 16 bits
                                // deseados.

  reg [7:0] dataOutreg;    // salida en modo de 8 bits
  reg [15:0] dataOut16reg; // salida en modo de 16 bits
  reg [31:0] dataOut32reg; // salida en modo de 32 bits

  output reg [7:0] dataOut;    // salida en modo de 8 bits
  output reg [15:0] dataOut16; // salida en modo de 16 bits
  output reg [31:0] dataOut32; // salida en modo de 32 bits

  output reg [31:0] bits;

  reg [7:0] outBits8;
  reg [15:0] outBits16;
  reg [31:0] outBits32;

  output reg [1:0] contador;



  always @ ( * ) begin
    if (dataS == 2'b01 && dataSInternal) begin
      dataOut = outBits8;
      dataOut16 = outBits16;
      dataOut32 = outBits32;
    end else if (dataS == 2'b10 && dataSInternal) begin
      dataOut = outBits8;
      dataOut16 = outBits16;
      dataOut32 = outBits32;
    end else begin
      dataOut = (dataS == 2'b00 || dataS == 2'b11) ? {dataIn} : outBits8;
      dataOut16 = outBits16;
      dataOut32 = outBits32;
    end
  end

  always @ (posedge clk8) begin
    if (rst) begin
      bits <= 0;
      contador <= 0;
      dataSInternal <= 1;
    end
    if (~rst && enb) begin
      outBits8 <= (dataS == 2'b00 || dataS == 2'b11) ?
                  dataIn : outBits8;
      outBits16 <= dataSInternal && dataS == 2'b01 ?
                   {bits[15:8], dataIn} : outBits16;
      outBits32 <= dataSInternal && dataS == 2'b10 ?
                   {bits[31:8], dataIn} : outBits32;
      if (dataS == 2'b01) begin
        contador <= (contador >= 2'b01) ? 2'b00 : contador + 1;
        dataSInternal <= (contador == 2'b00) ? 1 : 0;
        if (contador == 2'b00) bits[15:8] <= dataIn;
        else                   bits[7:0]  <= dataIn;
      end else if (dataS == 2'b10) begin
        contador <= (contador >= 2'b11) ? 2'b00 : contador + 1;
        dataSInternal <= (contador == 2'b10) ? 1 : 0;
        if (contador == 2'b00)      bits[31:24] <= dataIn;
        else if (contador == 2'b01) bits[23:16] <= dataIn;
        else if (contador == 2'b10) bits[15:8]  <= dataIn;
        else                        bits[7:0]   <= dataIn;
      end else begin
        bits[7:0] <= dataIn;
        dataSInternal <= 0;
      end
    end
  end // always @ (posedge clk8)
endmodule
