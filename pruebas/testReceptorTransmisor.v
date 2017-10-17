`timescale 1ns/1ps


`define isTestr 2
`ifndef cmos_cells
        `include "../lib/cmos_cells.v"
`endif

//`include "../bloques/diferencial/diferencialReceptor.v"


`ifndef recibidor
  `include "../bloques/interfaz-PCIE/recibidor.v"
`endif
`ifndef recibidorSynth
  `include "../build/recibidor-sintetizado.v"
`endif

`ifndef transmisor
  `include "../bloques/interfaz-PCIE/transmisor.v"
  `endif
`ifndef transmisorSynth
  `include "../build/transmisor-sintetizado.v"
`endif


module testRecibidorTransmisor;

  reg rst;
  reg enb;
  reg clk;
  //variables para generar numeros random
  reg [7:0] numrandom8;
  reg [15:0] numrandom16;
  reg [31:0] numrandom32;
	integer semilla = 0;

  reg [7:0] dataIn8;
  reg [15:0] dataIn16;
  reg [31:0] dataIn32;
  reg [1:0] dataS;

  reg [7:0] dataOut8;
  reg [15:0] dataOut16;
  reg [31:0] dataOut32;
  reg k_out;
  reg K;

  reg [7:0] dataOutSynht;
  reg [15:0] dataOut16Synth;
  reg [31:0] dataOut32Synth;
  reg k_outSynth;

  wire serialOut;
  wire serialOutSynth;
  wire invalid_value;
  wire invalid_valueSynth;

  transmisor testTransmi(
    .clk(clk),
    .rst(rst),
    .enb(enb),
    .K(K),
    .dataIn(dataIn8),
    .dataIn16(dataIn16),
    .dataIn32(dataIn32),
    .dataS(dataS),
    .serialOut(serialOut)
  );

    transmisorSynth testTransmisorSint(
    .clk(clk),
    .rst(rst),
    .enb(enb),
    .K(K),
    .dataIn(dataIn8),
    .dataIn16(dataIn16),
    .dataIn32(dataIn32),
    .dataS(dataS),
    .serialOut(serialOutSynth)
  );

  recibidor testRecibidor(
    .clk(clk),
    .rst(rst),
    .enb(enb),
    .k_out(k_out),
    .serialIn(serialOut),
    .dataOut8(dataOut8),
    .dataOut16(dataOut16),
    .dataOut32(dataOut32),
    .dataS(dataS)
  );

/*
  recibidorSynth testRecibidorSint(
    .clk(clk),
    .rst(rst),
    .enb(enb),
    .k_out(k_out),
    .serialIn(serialOut),
    .dataOut8(dataOut8),
    .dataOut16(dataOut16),
    .dataOut32(dataOut32),
    .dataS(dataS)
  );
*/
  parameter rc1 = 100; // 100/10 = 10 ciclos, reloj menor
  parameter rc2 = 200; // 20 ciclos, reloj intermedio
  parameter rc4 = 400; // 40 ciclos, reloj mayor

  always # 5 clk = ~clk; // inicio de la señal de reloj, cambia cada 10ns

  initial begin
    $dumpfile("gtkws/testReceptorTransmisor.vcd");
    $dumpvars;
  end

  initial begin

	  K <= 0;
	  enb <= 0;
	  rst <= 1;
	  clk <= 0;
	  dataIn8 <= 8'hff;
	  dataS <= 2'b00;
	  #100;
	  @(posedge clk)rst <= 0;
	  @(posedge clk)enb <= 1;
	  #rc1;
	  dataIn8 <= 8'h00;
	  #rc1;
	  dataIn8 <= 8'hcc;
	  #rc1;
	  dataIn8 <= 8'hab;
	  #rc1;
	  dataIn8 <= 8'h25;
	  #rc1;
	  dataS <= 2'b01;
	  dataIn16 <= 16'habcd;
	  #rc2;
	  dataS <= 2'b10;
	  dataIn32 <= 32'h0123456f;
	  #rc4;

    //probar con valores random
		repeat (10)	begin
  		//Semilla inicial para el generador de numeros aleatorios

      @(posedge clk) numrandom8 <= $random(semilla);
      @(posedge clk) numrandom16 <= $random(semilla);
      @(posedge clk) numrandom32 <= $random(semilla);
  		 $display($time, " << Prueba random 8bits=%b, 16bits=%b, 32bits=%b >>", numrandom8, numrandom16, numrandom32);
      #rc1;
   	  dataIn8 <= numrandom8;
   	  #rc1;
   	  dataS <= 2'b01;
   	  dataIn16 <= numrandom16;
   	  #rc2;
   	  dataS <= 2'b10;
   	  dataIn32 <= numrandom32;
   	  #rc4;
		end

	  $finish;

  end
endmodule
