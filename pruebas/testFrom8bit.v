`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/clks/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/to8bit-from8bit/from8bit.v"
`include "../build/from8bit-sintetizado.v"

module testsFrom8Bit;

  reg clk;
  reg rst;
  reg enb;

  reg [7:0] dataIn;
  reg [1:0] dataS;
  wire [7:0] dataOut;
  wire [15:0] dataOut16;
  wire [31:0] dataOut32;

  reg [7:0] dataInSynth;
  reg [1:0] dataSSynth;
  wire [7:0] dataOutSynth;
  wire [15:0] dataOut16Synth;
  wire [31:0] dataOut32Synth;

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

  from8bit testFrom8bit(
    .rst(rst),
    .enb(enb),
    .clk(clk10),
    .clk16(clk20),
    .clk32(clk40),
    .dataIn(dataIn),
    .dataS(dataS),
    .dataOut(dataOut),
    .dataOut16(dataOut16),
    .dataOut32(dataOut32)
  );
  from8bitSynth testFrom8bitSynth(
    .rst(rst),
    .enb(enb),
    .clk(clk10Synth),
    .clk16(clk20Synth),
    .clk32(clk40Synth),
    .dataIn(dataInSynth),
    .dataS(dataSSynth),
    .dataOut(dataOutSynth),
    .dataOut16(dataOut16Synth),
    .dataOut32(dataOut32Synth)
  );

  always # 5 clk = ~clk; // inicio de la señal de reloj, cambia cada 10ns

  initial begin
    $dumpfile("gtkws/testFrom8bit.vcd");
    $dumpvars;
  end
  initial begin

    clk = 0;
    rst = 1;
    enb = 1;

    # 40
    @ (posedge clk);
    rst = 0;
    dataIn = 8'hd4;
    dataS = 2'b00;
    # 20
    dataInSynth = 8'hd4;
    dataSSynth = 2'b00;

    # 180
    @ (posedge clk);
    dataIn = 8'h76;
    dataS = 2'b00;

    # 20
    @ (posedge clk);
    dataInSynth = 8'h76;
    dataSSynth = 2'b00;

    # 180
    @ (posedge clk);
    dataIn = 8'hd6;
    dataS = 2'b00;
    # 20
    @ (posedge clk);
    dataInSynth = 8'hd6;
    dataSSynth = 2'b00;

    # 180
    @ (posedge clk);
    dataIn = 8'he4;
    dataS = 2'b01;
    # 20
    @ (posedge clk);
    dataInSynth = 8'he4;
    dataSSynth = 2'b01;

    # 180
    @ (posedge clk);
    dataIn = 8'h57;
    dataS = 2'b01;
    # 20
    @ (posedge clk);
    dataInSynth = 8'h57;
    dataSSynth = 2'b01;

    #2000
    $finish;
  end

endmodule
