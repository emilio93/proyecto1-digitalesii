`timescale 1ns/1ps

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
	input k_out,k_outSynth,invalid_value,invalid_valueSynth, clkRstTx, clkEnbTx, clkRstRx, clkEnbRx;
  input [7:0] dataOut8, dataOut8Synht;
  input [15:0] dataOut16, dataOut16Synth;
  input [31:0] dataOut32, dataOut32Synth;
	//wires de salida intermedias, entrada intermedia transmisorDUT-receptorDUT
	wire serialOut, serialOutSynth;


	//instanciamos los modulos
	//tester
	test_P1 probador(
	.rst(rst), .enb(enb), .K(K), .TxElecIdle(TxElecIdle), .clkTx(clkTx), .clkRx(clkRx),
	.clkRstRx(clkRstRx),//revisar
	.clkEnbRx(clkEnbRx),//revisar
  .dataS(dataS),
  .dataIn8(dataIn8),
  .dataIn16(dataIn16),
  .dataIn32(dataIn32),
	.k_out(k_out), .k_outSynth(k_outSynth), .invalid_value(invalid_value), .invalid_valueSynth(invalid_valueSynth),
  .dataOut(dataOut8), .dataOutSynht(dataOut8Synht),
  .dataOut16(dataOut16), .dataOut16Synth(dataOut16Synth),
  .dataOut32(dataOut32), .dataOut32Synth(dataOut32Synth)
	);

	//desing under test(DUT), units under test(UUT)
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
		.clkRstRx(clkRstRx),//revisar
		.clkEnbRx(clkEnbRx),//revisar
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
	.clkRstRx(clkRstRx),//revisar
	.clkEnbRx(clkEnbRx),//revisar
	.enb(enb),
	.rst(rst),
	.serialIn(serialOutSynth),
	.dataS(dataS)
	);

//falta implementar contador

endmodule
