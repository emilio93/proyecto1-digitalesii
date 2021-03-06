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
`ifndef sincronizador
  `include "../bloques/sincronizador/sincronizador.v"
  `endif
`ifndef sincronizadorSynth
  `include "../build/sincronizador-sintetizado.v"
`endif

module testSincronizador;

  reg rst;
  reg enb;
  reg clk;

  reg [7:0] dataIn;
  reg [15:0] dataIn16;
  reg [31:0] dataIn32;
  reg [1:0] dataS;
  reg K;
  reg clkRx;

  wire dataOut;
  wire dataOutSynth;
  wire invalid_value;
  wire invalid_valueSynth;
  wire dataOutSinc;
  wire dataOutSincSynth;

//instancias del sincronizador
  sincronizador testSincronizador(
    .dataSync(dataOutSinc),  //salida sincronizada con el reloj del receptor
    .dataAsync(dataOut), //entrada asincronica desde el transmisor
    .clkRx(clkRx),     //reloj del receptor
    .enb(enb),
    .rst(rst)
    );

  sincronizadorSynth testSincronizadorSynth(
      .dataSync(dataOutSincSynth),  //salida sincronizada con el reloj del receptor
      .dataAsync(dataOutSynth), //entrada asincronica desde el transmisor
      .clkRx(clkRx),     //reloj del receptor
      .enb(enb),
      .rst(rst)
      );


  transmisor testTransmisor(
    .clk(clk),
    .rst(rst),
    .enb(enb),
    .K(K),
    .dataIn(dataIn),
    .dataIn16(dataIn16),
    .dataIn32(dataIn32),
    .dataS(dataS),
    .TxElecIdle(1'b0),
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
    .TxElecIdle(1'b0),
    .serialOut(dataOutSynth)
  );

  parameter rc1 = 100; // 100/10 = 10 ciclos, reloj menor
  parameter rc2 = 200; // 20 ciclos, reloj intermedio
  parameter rc4 = 400; // 40 ciclos, reloj mayor

  always # 5 clk <= ~clk; // inicio de la señal de reloj, cambia cada 10ns
  always # 5 clkRx <= ~clkRx;


  initial begin
    $dumpfile("gtkws/testSincronizador.vcd");
    $dumpvars;
  end

  initial begin

	  K <= 0;
	  enb <= 0;
	  rst <= 1;
	  clk <= 0;
    clkRx <=1;
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
