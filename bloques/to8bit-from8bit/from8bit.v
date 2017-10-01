`timescale 1ns/1ps

// convierte una señal seleccionada por dataS de 8 a n bits segun sea el caso.
// dataS = 00 o 11 -> funcionamiento para 8 bits
// dataS = 01 -> funcionamiento para 16 bits
// dataS = 10 -> funcionamiento para 32 bits
module from8bit(
  rst,
  enb,
  clk, clk16, clk32,
  dataIn,
  dataS,
  dataOut, dataOut16, dataOut32
);

  input wire rst;
  input wire enb;
  input wire clk;
  input wire clk16;
  input wire clk32;

  input wire [7:0] dataIn;
  input wire [1:0] dataS;

  output reg [7:0] dataOut;
  output reg [15:0] dataOut16;
  output reg [31:0] dataOut32;

  reg [31:0] bits;

  always @ ( * ) begin
    if (dataS == 2'b01) begin
      dataOut <= 8'h00;
      dataOut16 = bits[15:0];
      dataOut32 <= 32'h00000000;

    end else if (dataS == 2'b10) begin
      dataOut <= 8'h00;
      dataOut16 <= 16'h0000;
      dataOut32 = bits[31:0];

    end else begin
      dataOut = {bits[7:0]};
      dataOut16 <= 16'h0000;
      dataOut32 <= 32'h00000000;
    end
  end

  always @ (posedge clk) begin
    if (rst) begin
      bits <= 32'h00000000;
      dataOut <= 8'h00;
      dataOut16 <= 16'h0000;
      dataOut32 <= 32'h00000000;
    end else if (enb) begin
      if (dataS == 2'b01) begin
        if (clk16) bits[7:0] <= dataIn;
        else bits [15:8] <= dataIn;
      end else if (dataS == 2'b10) begin
        if (clk32 && clk16) bits[7:0] <= dataIn;
        else if (clk32 && ~clk16) bits[15:8] <= dataIn;
        else if (~clk32 && clk16) bits[23:16] <= dataIn;
        else bits[31:24] <= dataIn;
      end else begin
        bits[7:0] <= dataIn;
      end
    end

  end

endmodule
