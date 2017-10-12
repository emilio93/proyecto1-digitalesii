`timescale 1ns/1ps

`define isTest 1

`include "../lib/cmos_cells.v"

`include "../bloques/clks/clks.v"
`include "../build/clks-sintetizado.v"

`include "../bloques/k28.5/k285Detector.v"
`include "../build/k285Detector-sintetizado.v"

module testsK285Detector;

  reg clk;

  reg rstClk;
  reg enbClk;

  reg rst;
  reg enb;

  reg entrada;

  wire lectura;
  wire lecturaSynth;

  wire esk285;
  wire esk285Synth;

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

  k285Detector testK285Detector(
    .clk(clk), .rst(rst), .enb(enb), .entrada(entrada),
    .esk285(esk285), .lectura(lectura)
  );
  k285DetectorSynth testK285DetectorSynth(
    .clk(clk), .rst(rst), .enb(enb), .entrada(entrada),
    .esk285(esk285Synth), .lectura(lecturaSynth)
  );

  always # 5 clk = ~clk;
  initial begin
    $dumpfile("gtkws/testK285Detector.vcd");
    $dumpvars;
  end

  reg errorEsK285;
  reg errorLectura;
  always @ ( * ) begin
    errorEsK285 = esk285 != esk285Synth;
    errorLectura = lectura!=lecturaSynth;
  end

  initial begin

    clk <= 0;
    rst <= 1;
    rstClk <= 1;
    enb <= 1;
    enbClk <= 1;

    # 80
    @ (posedge clk);
    rstClk <= 0;
    rst <= 0;
    entrada <= 0;
    @ (posedge clk); entrada <= 1;

    // k28.5 0011111010
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 0;
    // k28.5

    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 1;


    // k28.5 0011111010
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 0;
    // k28.5

    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 1;
    @ (posedge clk); entrada <= 0;
    @ (posedge clk); entrada <= 1;
    # 200
    $finish;
  end

endmodule
