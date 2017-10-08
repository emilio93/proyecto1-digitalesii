`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/clks/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/to8bit-from8bit/to8bit.v"
`include "../build/to8bit-sintetizado.v"

`include "../bloques/to8bit-from8bit/from8bit.v"
`include "../build/from8bit-sintetizado.v"

module testsTo8bitFrom8Bit;

  reg clk;
  reg rst;
  reg rstClk;
  reg enb;
  reg enbClk;

  reg [7:0] dataIn;
  reg [15:0] dataIn16;
  reg [31:0] dataIn32;

  reg [1:0] dataS;

  wire [7:0] dataOut;
  wire [15:0] dataOut16;
  wire [31:0] dataOut32;

  wire [7:0] dataOutSynth;
  wire [15:0] dataOut16Synth;
  wire [31:0] dataOut32Synth;

  wire [7:0] dataOutEmisor;
  wire [7:0] dataOutEmisorSynth;

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

  to8bit testTo8bit(.rst(rst), .enb(enb),
    .clk(clk10), .clk16(clk20), .clk32(clk40),
    .dataIn(dataIn), .dataIn16(dataIn16), .dataIn32(dataIn32),
    .dataS(dataS),
    .dataOut(dataOutEmisor)
  );
  to8bitSynth testTo8bitSynth(.rst(rst), .enb(enb),
    .clk(clk10Synth), .clk16(clk20Synth), .clk32(clk40Synth),
    .dataIn(dataIn), .dataIn16(dataIn16), .dataIn32(dataIn32),
    .dataS(dataS),
    .dataOut(dataOutEmisorSynth)
  );

  from8bit testFrom8bit(.rst(rst), .enb(enb), .clk(clk),
    .clk8(clk10), .clk16(clk20), .clk32(clk40),
    .dataIn(dataOutEmisor), .dataS(dataS),
    .dataOut(dataOut), .dataOut16(dataOut16), .dataOut32(dataOut32)
  );
  from8bitSynth testFrom8bitSynth(.rst(rst), .enb(enb), .clk(clk),
    .clk8(clk10Synth), .clk16(clk20Synth), .clk32(clk40Synth),
    .dataIn(dataOutEmisorSynth), .dataS(dataS),
    .dataOut(dataOutSynth), .dataOut16(dataOut16Synth), .dataOut32(dataOut32Synth)
  );

  always # 5 clk = ~clk; // inicio de la señal de reloj, cambia cada 10ns

  initial begin
    $dumpfile("gtkws/testTo8bitFrom8bit.vcd");
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
    @ (posedge clk10); dataIn <= 8'h9d;
    @ (posedge clk10); dataIn <= 8'h48;

    @ (posedge clk10);
    dataS <= 2'b01;

    // Se espera 6b57
    dataIn16 <= 16'h6b57;

    // Se espera 9317
    @ (posedge clk20); dataIn16 <= 16'h9317;

    // Se espera e3c6
    @ (posedge clk20); dataIn16 <= 16'he3c6;

    // Se espera 9c29
    @ (posedge clk20); dataIn16 <= 16'h9c29;

    // Se espera 8f3e
    @ (posedge clk20); dataIn16 <= 16'h8f3e;

    @ (posedge clk40);
    dataS <= 2'b10;

    // Se espera 52d5a8f9
    dataIn32 <= 32'h52d5a8f9;

    // Se espera 01c59111
    @ (posedge clk40); dataIn32 <= 32'h01c59111;

    // Se espera 10f69f8a
    @ (posedge clk40); dataIn32 <= 32'h10f69f8a;

    @ (posedge clk40);
    @ (posedge clk40);
    dataS <= 2'b11;
    dataIn <= 8'h49;
    @ (posedge clk10); dataIn <= 8'h76;
    @ (posedge clk10); dataIn <= 8'hdf;
    @ (posedge clk10); dataIn <= 8'h8a;
    @ (posedge clk10); dataIn <= 8'hd6;
    @ (posedge clk10); dataIn <= 8'he4;
    @ (posedge clk10); dataIn <= 8'h9d;
    @ (posedge clk10); dataIn <= 8'h48;

    #2000
    $finish;
  end

endmodule
