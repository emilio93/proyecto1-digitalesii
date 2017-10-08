`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/clks/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/to8bit-from8bit/from8bit.v"
`include "../build/from8bit-sintetizado.v"

module testsFrom8Bit;

  reg clk;
  reg rst;
  reg rstClk;
  reg enb;
  reg enbClk;

  reg [7:0] dataIn;
  reg [1:0] dataS;

  wire [7:0] dataOut;
  wire [15:0] dataOut16;
  wire [31:0] dataOut32;

  wire [7:0] dataOutSynth;
  wire [15:0] dataOut16Synth;
  wire [31:0] dataOut32Synth;

  wire clk10;
  wire clk20;
  wire clk40;

  wire clk10Synth;
  wire clk20Synth;
  wire clk40Synth;

  clks testClks(.clk(clk), .rst(rstClk), .enb(enbClk),
  .clk10(clk10), .clk20(clk20), .clk40(clk40));

  clksSynth testClksSynth(.clk(clk), .rst(rstClk), .enb(enbClk),
  .clk10(clk10Synth), .clk20(clk20Synth), .clk40(clk40Synth));

  from8bit testFrom8bit(
    .rst(rst), .enb(enb), .clk(clk),
    .clk8(clk10), .clk16(clk20), .clk32(clk40),
    .dataIn(dataIn), .dataS(dataS),
    .dataOut(dataOut), .dataOut16(dataOut16), .dataOut32(dataOut32)
  );
  from8bitSynth testFrom8bitSynth(
    .rst(rst), .enb(enb), .clk(clk),
    .clk8(clk10Synth), .clk16(clk20Synth), .clk32(clk40Synth),
    .dataIn(dataIn), .dataS(dataS),
    .dataOut(dataOutSynth), .dataOut16(dataOut16Synth), .dataOut32(dataOut32Synth)
  );

  always # 5 clk = ~clk; // inicio de la señal de reloj, cambia cada 10ns

  initial begin
    $dumpfile("gtkws/testFrom8bit.vcd");
    $dumpvars;
  end

  reg error8;
  reg error16;
  reg error32;
  always @ ( * ) begin
    error8 = dataOut!=dataOutSynth;
    error16 = dataOut16!=dataOut16Synth;
    error32 = dataOut32!=dataOut32Synth;
  end

  initial begin

    clk <= 0;
    rst <= 1;
    rstClk <= 1;
    enb <= 1;
    enbClk <= 1;
    dataS <= 2'b00;

    # 80
    @ (posedge clk);
    rstClk <= 0;

    @ (posedge clk10);
    rst <= 0;

    dataIn <= 8'h49;
    @ (posedge clk10); dataIn <= 8'h76;
    @ (posedge clk10); dataIn <= 8'hdf;
    dataS <= 2'b11;
    @ (posedge clk10); dataIn <= 8'h8a;
    @ (posedge clk10); dataIn <= 8'hd6;
    @ (posedge clk10); dataIn <= 8'he4;
    @ (posedge clk10); dataIn <= 8'h4e;

    @ (posedge clk10);
    dataS <= 2'b01;

    // Se espera 6b57
    dataIn <= 8'h6b;
    @ (posedge clk10); dataIn <= 8'h57;

    // Se espera 9317
    @ (posedge clk10); dataIn <= 8'h93;
    @ (posedge clk10); dataIn <= 8'h17;

    // Se espera e3c6
    @ (posedge clk10); dataIn <= 8'he3;
    @ (posedge clk10); dataIn <= 8'hc6;

    // Se espera 9c29
    @ (posedge clk10); dataIn <= 8'h9c;
    @ (posedge clk10); dataIn <= 8'h29;

    @ (posedge clk10);
    dataS <= 2'b10;

    // Se espera 52d5a8f9
    dataIn <= 8'h52;
    @ (posedge clk10); dataIn <= 8'hd5;
    @ (posedge clk10); dataIn <= 8'ha8;
    @ (posedge clk10); dataIn <= 8'hf9;

    // Se espera 01c59111
    @ (posedge clk10); dataIn <= 8'h01;
    @ (posedge clk10); dataIn <= 8'hc5;
    @ (posedge clk10); dataIn <= 8'h91;
    @ (posedge clk10); dataIn <= 8'h11;

    // Se espera 10f69f8a
    @ (posedge clk10); dataIn <= 8'h10;
    @ (posedge clk10); dataIn <= 8'hf6;
    @ (posedge clk10); dataIn <= 8'h9f;
    @ (posedge clk10); dataIn <= 8'h8a;

    #2000
    $finish;
  end

endmodule
