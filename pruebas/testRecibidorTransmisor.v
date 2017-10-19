`timescale 1ns/1ps

`define isTest 1//revisar si funciona

`ifndef cmos_cells
        `include "../lib/cmos_cells.v"
`endif

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
  reg clkTx;
  reg clkRx;
  //variables para generar numeros random
  reg [7:0] numrandom8;
  reg [15:0] numrandom16;
  reg [31:0] numrandom32;
	integer semilla = 0;

  reg [7:0] dataIn8;
  reg [15:0] dataIn16;
  reg [31:0] dataIn32;
  reg [1:0] dataS;
  reg K;
  reg TxElecIdle;

  wire [7:0] dataOut8;
  wire [15:0] dataOut16;
  wire [31:0] dataOut32;
  wire [7:0] dataOut8Synht;
  wire [15:0] dataOut16Synth;
  wire [31:0] dataOut32Synth;
  wire k_outSynth;
  wire k_out;
  wire serialOut;
  wire serialOutSynth;
  wire invalid_value;
  wire invalid_valueSynth;

  transmisor testTransmi(
    .clk(clkTx),
    .rst(rst),
    .enb(enb),
    .K(K),
    .dataIn(dataIn8),
    .dataIn16(dataIn16),
    .dataIn32(dataIn32),
    .dataS(dataS),
    .TxElecIdle(TxElecIdle),
    .serialOut(serialOut)
  );

    transmisorSynth testTransmisorSint(
    .clk(clkTx),
    .rst(rst),
    .enb(enb),
    .K(K),
    .dataIn(dataIn8),
    .dataIn16(dataIn16),
    .dataIn32(dataIn32),
    .dataS(dataS),
    .TxElecIdle(TxElecIdle),
    .serialOut(serialOutSynth)
  );

  recibidor testRecibidor(
		.k_out(k_out),
		.error_probable(invalid_value),
		.dataOut8(dataOut8),
		.dataOut16(dataOut16),
		.dataOut32(dataOut32),
		.clkRx(clkRx),//revisar
		.enb(enb),
		.rst(rst),
		.serialIn(serialOut),
		.dataS(dataS)
	);


	recibidorSynth testRecibidorSint(
	.k_out(k_out),
	.error_probable(invalid_value),
	.dataOut8(dataOut8Synht),
	.dataOut16(dataOut16Synth),
	.dataOut32(dataOut32Synth),
	.clkRx(clkRx),//revisar
	.enb(enb),
	.rst(rst),
	.serialIn(serialOutSynth),
	.dataS(dataS)
	);
  parameter rc1 = 100; // 100/10 = 10 ciclos, reloj menor
  parameter rc2 = 200; // 20 ciclos, reloj intermedio
  parameter rc4 = 400; // 40 ciclos, reloj mayor

  always # 5 clkTx = ~clkTx; // inicio de la señal de reloj, cambia cada 10ns
  always # 5 clkRx = ~clkRx;
  initial begin
    $dumpfile("gtkws/testReceptorTransmisor.vcd");
    $dumpvars;
  end

  initial begin

	  K <= 0;
	  TxElecIdle = 1;
	  enb <= 0;
	  rst <= 1;
	  //serialOut = 0;
	  clkTx <= 0;
    clkRx <=1;
	  dataIn8 <= 8'hff;
	  dataS <= 2'b00;
	  #100;
	  @(posedge clkTx)rst <= 0;
	  @(posedge clkTx)TxElecIdle <= 0;
	  @(posedge clkTx)enb <= 1;
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

      @(posedge clkTx) numrandom8 <= $random(semilla);
      @(posedge clkTx) numrandom16 <= $random(semilla);
      @(posedge clkTx) numrandom32 <= $random(semilla);
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
