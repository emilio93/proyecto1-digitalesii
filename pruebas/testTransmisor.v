`timescale 1ns/1ps
`define isTest 1
`ifndef cmos_cells
  `include "../lib/cmos_cells.v"
`endif

//`include "../bloques/diferencial/diferencial.v"
`ifndef transmisor
  `include "../bloques/interfaz-PCIE/transmisor.v"
  `endif
`ifndef transmisorSynth
  `include "../build/transmisor-sintetizado.v"
`endif

module testTransmisor;

  reg rst;
  reg enb;
  reg clk;

  reg [7:0] dataIn;
  reg [15:0] dataIn16;
  reg [31:0] dataIn32;
  reg [1:0] dataS;
  reg K;

  wire dataOut;
  wire dataOutSynth;
  wire invalid_value;
  wire invalid_valueSynth;

  transmisor testTransmisor(
    .clk(clk),
    .rst(rst),
    .enb(enb),
    .K(K),
    .dataIn(dataIn),
    .dataIn16(dataIn16),
    .dataIn32(dataIn32),
    .dataS(dataS),
    .serialOut(dataOut)
  );

    transmisorSynth testTransmisorSintetizado(
    .clk(clk),
    .rst(rst),
    .enb(enb),
    .K(K),
    .dataIn(dataIn),
    .dataIn16(dataIn16),
    .dataIn32(dataIn32),
    .dataS(dataS),
    .serialOut(dataOutSynth)
  );

  parameter rc1 = 100; // 100/10 = 10 ciclos, reloj menor
  parameter rc2 = 200; // 20 ciclos, reloj intermedio
  parameter rc4 = 400; // 40 ciclos, reloj mayor

  always # 5 clk = ~clk; // inicio de la señal de reloj, cambia cada 10ns

  initial begin
    $dumpfile("gtkws/testTransmisor.vcd");
    $dumpvars;
  end

  initial begin

	  K <= 0;
	  enb <= 0;
	  rst <= 1;
	  clk <= 0;
	  dataIn <= 8'hff;
	  dataS <= 2'b00;
	  #100;
	  @(posedge clk)rst <= 0;
	  @(posedge clk)enb <= 1;
	  #rc1;
	  dataIn <= 8'h00;
	  #rc1;
	  dataIn <= 8'hcc;
	  #rc1;
	  dataIn <= 8'hab;
	  #rc1;
	  dataIn <= 8'h25;
	  #rc1;
	  dataS <= 2'b01;
	  dataIn16 <= 16'habcd;
	  #rc2;
	  dataS <= 2'b10;
	  dataIn32 <= 32'h0123456f;
	  #rc4;

	  $finish;

  end
endmodule
