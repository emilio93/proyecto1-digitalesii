`timescale 1ns/1ps
`define isTest//que significa esto?, se debe cambiar?
//`define CALCULOPOTENCIA//para activar el codigo en las celdas
//celdas para modulos sintetizados
`ifndef cmos_cells
	`include "../lib/cmos_cells.v"
`endif

//include de desing under test(DUT), units under test(UUT)
`ifndef transmisorDUT
  `include "../bloques/interfaz-PCIE/transmisor.v"
  `endif
`ifndef transmisorSynthDUT
  `include "../build/transmisor-sintetizado.v"
`endif

`ifndef receptorDUT
  `include "../bloques/interfaz-PCIE/recibidor.v"
`endif
`ifndef receptorSynthDUT
  `include "../build/recibidor-sintetizado.v"
`endif

//Memoria para llevar cuenta cantidad de transiciones en los ff de salida de los modulos DUT
`ifndef memTrans//MemoriaTransiciones
`include "memTrans.v"
`endif
//tester, generador datos para probar los modulos DUT
`ifndef testerP1
`include "test_P1.v"
`endif

module testbench_P1;
	//wires de entrada inicial, salida final, desde tester-DUT
	//señales de control y reloj a los bloques DUT
	wire rst, enb, K, TxElecIdle, clkTx, clkRx;
	//datos de entradas a los bloque de a probar
  wire [1:0] dataS;
  wire [7:0] dataIn8;
  wire [15:0] dataIn16;
  wire [31:0] dataIn32;
	//salidas de los bloques DUT
	input k_out,k_outSynth,invalid_value,invalid_valueSynth;
  input [7:0] dataOut,dataOutSynht;
  input [15:0] dataOut16, dataOut16Synth;
  input [31:0] dataOut32, dataOut32Synth;
	//wires de salida intermedias, entrada intermedia transmisorDUT-receptorDUT
	wire serialOut, serialOutSynth,


	//instanciamos los modulos
	//tester
	tester_P1 probador(
	.rst(rst), .enb(enb), .K(K), .TxElecIdle(TxElecIdle), .clkTx(clkTx), .clkRx(clkRx),
  .dataS(dataS),
  .dataIn8(dataIn8),
  .dataIn16(dataIn16),
  .dataIn32(dataIn32),
	.k_out(k_out), .k_outSynth(k_outSynth), .invalid_value(invalid_value), .invalid_valueSynth(invalid_valueSynth),
  .dataOut(dataOut), .dataOutSynht(dataOutSynht),
  .dataOut16(dataOut16), .dataOut16Synth(dataOut16Synth),
  .dataOut32(dataOut32), .dataOut32Synth(dataOut32Synth)
	);

	//desing under test(DUT), units under test(UUT)
	transmisorDUT testTransmi(
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

		transmisorSynthDUT testTransmisorSint(
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

	receptorDUT testRecibidor(
		.clk(clkRx),//revisar
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
	receptorSynthDUT testRecibidorSint(
		.clk(clk),
		.rst(rst),
		.enb(enb),
		.k_out(k_out),
		.serialIn(serialOutSynth),
		.dataOut8(dataOut8),
		.dataOut16(dataOut16),
		.dataOut32(dataOut32),
		.dataS(dataS)
	);
	*/
//falta implementar contador

endmodule
