`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/clks/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/to8bit-from8bit/to8bit.v"
`include "../build/to8bit-sintetizado.v"

module testsTo8Bit;

  reg clk;
  reg rst;
  reg enb;

  reg [7:0] dataIn;
  reg [15:0] dataIn16;
  reg [31:0] dataIn32;
  reg [1:0] dataS;

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
    .rst(rst), .enb(enb),
    .clk(clk10), .clk16(clk20), .clk32(clk40),
    .dataIn(dataIn), .dataIn16(dataIn16), .dataIn32(dataIn32),
    .dataS(dataS),
    .dataOut(dataOut)
  );
  to8bitSynth testTo8bitSynth(
    .rst(rst), .enb(enb),
    .clk(clk10Synth), .clk16(clk20Synth), .clk32(clk40Synth),
    .dataIn(dataIn), .dataIn16(dataIn16), .dataIn32(dataIn32),
    .dataS(dataS),
    .dataOut(dataOutSynth)
  );

  always # 5 clk = ~clk; // inicio de la señal de reloj, cambia cada 10ns

  initial begin
    $dumpfile("gtkws/testTo8bit.vcd");
    $dumpvars;
  end

  initial begin
    clk <= 0;
    rst <= 1;
    enb <= 1;
    dataIn <= 8'h00;
    dataIn16 <= 16'h0000;
    dataIn32 <= 32'h00000000;

    # 40;
    @ (posedge clk);
    rst <= 0;
    dataS <= 2'b00;

    @ (posedge clk10); dataIn <= 8'hff;
    @ (posedge clk10); dataIn <= 8'hf0;
    @ (posedge clk10); dataIn <= 8'h0f;
    @ (posedge clk10); dataIn <= 8'h00;
    @ (posedge clk10); dataIn <= 8'h80;
    @ (posedge clk10); dataIn <= 8'h01;

    @ (posedge clk10); dataIn <= 8'ha6;
    @ (posedge clk10); dataIn <= 8'hd2;

    @ (posedge clk10);
    dataS <= 2'b01;
    dataIn16 <= 16'had43;

    @ (posedge clk10);
    @ (posedge clk10); dataIn16 <= 16'h543f;

    @ (posedge clk10);
    @ (posedge clk10);
    dataIn16 <= 16'h7d5a;

    @ (posedge clk10);
    @ (posedge clk10);  
    dataS <= 2'b10;
    dataIn32 <= 32'h95fdad43;

    @ (posedge clk10);
    @ (posedge clk10);
    @ (posedge clk10);
    @ (posedge clk10); dataIn32 <= 32'h94d5543f;

    @ (posedge clk10);
    @ (posedge clk10);
    @ (posedge clk10);
    @ (posedge clk10); dataIn32 <= 32'h0378fdae;

    # 910;
    @ (posedge clk);
    enb <= 0;
    # 600;
    $finish;
  end

endmodule
