`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/clk/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/to8bit/to8bit.v"
`include "../build/to8bit-sintetizado.v"

module testsTo8Bit;



  reg clk;
  reg rst;
  reg enb;

  reg [7:0] dataIn;
  reg [15:0] dataIn16;
  reg [31:0] dataIn32;
  reg [1:0] dataS;

  reg [7:0] dataInSynth;
  reg [15:0] dataIn16Synth;
  reg [31:0] dataIn32Synth;
  reg [1:0] dataSSynth;

  wire [7:0] dataOut;
  wire [7:0] dataOutSynth;

  wire clk10;
  wire clk20;
  wire clk40;

  wire clk10Synth;
  wire clk20Synth;
  wire clk40Synth;

  clks testClks(.clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10), .clk20(clk20), .clk40(clk40));

  clksSynth testClksSynth(.clk(clk), .rst(rst), .enb(enb),
  .clk10(clk10Synth), .clk20(clk20Synth), .clk40(clk40Synth));

  to8bit testTo8bit(
    .rst(rst),
    .enb(enb),
    .clk(clk10),
    .clk16(clk20),
    .clk32(clk40),
    .dataIn(dataIn),
    .dataIn16(dataIn16),
    .dataIn32(dataIn32),
    .dataS(dataS),
    .dataOut(dataOut)
  );
  to8bitSynth testTo8bitSynth(
    .rst(rst),
    .enb(enb),
    .clk(clk10Synth),
    .clk16(clk20Synth),
    .clk32(clk40Synth),
    .dataIn(dataInSynth),
    .dataIn16(dataIn16Synth),
    .dataIn32(dataIn32Synth),
    .dataS(dataSSynth),
    .dataOut(dataOutSynth)
  );

  always # 5 clk = ~clk; // inicio de la señal de reloj, cambia cada 10ns

  initial begin
    $dumpfile("gtkws/testTo8bit.vcd");
    $dumpvars;
  end

  initial begin
    clk = 0;
    rst = 1;
    enb = 1;

    # 40;
    @ (posedge clk);
    rst = 0;

    dataIn = 8'b11111111;
    dataIn16 = 16'hffff;
    dataIn32 = 32'hffffffff;
    dataS = 2'b00;

    dataInSynth = 8'hff;
    dataIn16Synth = 16'hffff;
    dataIn32Synth = 32'hffffffff;
    dataSSynth = 2'b00;

    @ (posedge clk10);
    dataIn = 8'b00000000;
    @ (posedge clk10Synth);
    dataInSynth = 8'b00000000;
    @ (posedge clk10);
    dataIn = 8'b11110000;
    @ (posedge clk10Synth);
    dataInSynth = 8'b11110000;
    @ (posedge clk10);
    dataIn = 8'b00001111;
    @ (posedge clk10Synth);
    dataInSynth = 8'b00001111;
    @ (posedge clk10);
    dataIn = 8'b10011010;
    @ (posedge clk10Synth);
    dataInSynth = 8'b10011010;
    @ (posedge clk10);
    dataIn = 8'h6d;
    @ (posedge clk10Synth);
    dataInSynth = 8'h6d;
    @ (posedge clk10);
    dataIn = 8'h9a;
    @ (posedge clk10Synth);
    dataInSynth = 8'h9a;

    @ (posedge clk10Synth);

    @ (posedge clk10);
    dataIn16 = 16'had43;
    dataS = 2'b01;
    @ (posedge clk10Synth);
    dataSSynth = 2'b01;
    dataIn16Synth = 16'had43;

    @ (posedge clk10);
    @ (posedge clk10);
    dataIn16 = 16'h543f;
    @ (posedge clk10Synth);
    dataIn16Synth = 16'h543f;

    @ (posedge clk10);
    @ (posedge clk10);
    dataIn16 = 16'h7d5a;
    @ (posedge clk10Synth);
    dataIn16Synth = 16'h7d5a;


    @ (posedge clk10);
    @ (posedge clk10);
    dataIn32 = 32'h95fdad43;
    dataS = 2'b10;
    @ (posedge clk10Synth);
    dataIn32Synth = 32'h95fdad43;
    dataSSynth = 2'b10;

    @ (posedge clk10);
    @ (posedge clk10);
    @ (posedge clk10);
    @ (posedge clk10);
    dataIn32 = 32'h94d5543f;
    @ (posedge clk10Synth);
    dataIn32Synth = 32'h94d5543f;

    @ (posedge clk10);
    @ (posedge clk10);
    @ (posedge clk10);
    @ (posedge clk10);
    dataIn32 = 32'h0378fdae;
    @ (posedge clk10Synth);
    dataIn32Synth = 32'h0378fdae;

    # 910;
    @ (posedge clk);
    enb = 0;
    # 600;
    $finish;
  end

endmodule
