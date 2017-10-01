`timescale 1ns/1ps

// convierte una señal seleccionada por dataS de n a 8 bits segun sea el caso
module to8bit(
  rst,
  enb,
  clk,
  clk16,
  clk32,
  dataIn,
  dataIn16,
  dataIn32,
  dataS,
  dataOut
);
parameter cantidadBits = 10;

  input wire rst;
  input wire enb;
  input wire clk;
  input wire clk16;
  input wire clk32;

  input wire [7:0] dataIn;
  input wire [15:0] dataIn16;
  input wire [31:0] dataIn32;
  input wire [1:0] dataS;

  output reg [7:0] dataOut;

  reg [7:0] bits;

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
