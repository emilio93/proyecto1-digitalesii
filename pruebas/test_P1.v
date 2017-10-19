`timescale 1ns/1ps
`define CALCULOPOTENCIA
`define isTest 1
`ifndef cmos_cells
	`include "../lib/cmos_cells.v"
`endif

//include de desing under test(DUT), units under test(UUT)
`ifndef transmisor
  `include "../bloques/interfaz-PCIE/transmisor.v"
`endif
`ifndef transmisorSynth
  `include "../build/transmisor-sintetizado.v"
`endif

`ifndef recibidor
  `include "../bloques/interfaz-PCIE/recibidor.v"
`endif
`ifndef recibidorSynth
  `include "../build/recibidor-sintetizado.v"
`endif

//Memoria para llevar cuenta cantidad de transiciones en los ff de salida de los modulos DUT
`ifndef memTrans//MemoriaTransiciones
`include "./p1/memTrans.v"
`endif
//tester, generador datos para probar los modulos DUT
`ifndef testbench_P1
`include "./p1/testbench_P1.v"
`endif

module test_P1(
  output rst, enb, K, TxElecIdle, clkTx, clkRx,clkRstTx, clkEnbTx, clkRstRx, clkEnbRx,
  output [1:0] dataS,
  output [7:0] dataIn8,
  output [15:0] dataIn16,
  output [31:0] dataIn32,
	input k_out, k_outSynth, invalid_value, invalid_valueSynth,
  input [7:0] dataOut,dataOutSynht,
  input [15:0] dataOut16, dataOut16Synth,
  input [31:0] dataOut32, dataOut32Synth
);
  //variables locales
  //implementacion de contadores
  reg [31:0] Contador;
	reg [`Ndir:0] dir;
	reg LE;
	wire [31:0] dato;
	//Conexion a la memoria de contadores de transicion
	memTrans m1 (dir, LE, dato);
	//Control de E/S del puerto de dato de la memoria de contadores
	assign dato = (~LE)? Contador : 32'bz;

  //variables para generar numeros random
  reg [7:0] numrandom8;
  reg [15:0] numrandom16;
  reg [31:0] numrandom32;
  integer semilla = 0;

  //variables de entrada y salida
  //señales de control y reloj
  reg rst;
  reg enb;
  reg K;
  reg TxElecIdle;
  reg clkTx;
  reg clkRx;
  reg [1:0] dataS;
  //datos de entradas a los bloque de a probar
  reg [7:0] dataIn8;
  reg [15:0] dataIn16;
  reg [31:0] dataIn32;
  //salidas de los bloques a probar, bloque por comportamiento
  wire [7:0] dataOut8;
  wire [15:0] dataOut16;
  wire [31:0] dataOut32;
  wire k_out;
  wire invalid_value;
  //salidas de los bloques a probar, bloque sintetizado
  wire [7:0] dataOutSynht;
  wire [15:0] dataOut16Synth;
  wire [31:0] dataOut32Synth;
  wire k_outSynth;
  wire invalid_valueSynth;

	reg clkRstTx;
	reg clkEnbTx;

	reg clkRstRx;
	reg clkEnbRx;

  //revisa error de datos de salida entre comportamiento-sintetisis
  /*
  reg error;
  always @ ( * ) begin
    error = salida-salidaSynth;
  end
  */

  always # 0.1 clkTx <= ~clkTx; // clock transmisor, cambia cada 10ns
  always # 0.1 clkRx <= ~clkRx; //clock receptor, cambia cada 10ns,desfase 180 grados

	wire clkTx10;
	wire clkTx20;
	wire clkTx40;
	clks clksTx(
		clkTx, clkRstTx, clkEnbTx,
		clkTx10, clkTx20, clkTx40
	);

	wire clkRx10;
	wire clkRx20;
	wire clkRx40;
	clks clksRx(
		clkRx, clkRstRx, clkEnbRx,
		clkRx10, clkRx20, clkRx40
	);

  initial begin
    $dumpfile("gtkws/test_P1.vcd");
    $dumpvars();
    /*
    $monitor($time,,
    "clk= %b a= %b b= %b b_not= %b c_nand= %b c_nor= %b s= %b OE_neg= %b y_mux= %b d= %b  q= %b  q_neg= %b",
    clk,a,b,b_not,c_nand,c_nor,s,OE_neg,y_mux,d,q,q_neg);
    */
    $display($time, " << Starting the Simulation K=0, TxElecIdle=1, enb=0, rst=1,serialOut=0, clkTx=0, clkRx=1, dataIn8=8'hff, dataS = 2'b00  >>");
    //inicializacion de relojes, entradas y salidas
		clkTx <= 0; clkRx <=1;
		clkRstTx <= 1; clkEnbTx <=1;
    clkRstRx <= 1; clkEnbRx <=1;

    K <= 0; TxElecIdle = 1; enb <= 0; rst <= 1;
    dataIn8 <= 8'hff; dataS <= 2'b00;
    //serialOut = 0;

    //Borrar memoria del contador de transicion
		#1 LE <= 0;
		Contador <= 0;
		for (dir=0; dir<=`NumPwrCntr; dir=dir+1) begin
			#1 Contador <= 0;
		end
    //inician pruebas
		#100;
		@(posedge clkTx); clkRstTx <= 0;
		@(posedge clkRx); clkRstRx <= 0;
    #100;
    @(posedge clkTx)rst <= 0;
    @(posedge clkTx)TxElecIdle <= 0;
    @(posedge clkTx)enb <= 1;

    @(posedge clkTx10) dataIn8 <= 8'h00;
    @(posedge clkTx10) dataIn8 <= 8'hcc;
    @(posedge clkTx10) dataIn8 <= 8'hab;
    @(posedge clkTx10) dataIn8 <= 8'h25;
		dataIn16 <= 16'habcd;
    @(posedge clkTx10) dataS <= 2'b01;
    @(posedge clkTx20) dataS <= 2'b10;
		dataIn32 <= 32'hde23456f;
    @(posedge clkTx20) dataIn32 <= 32'h0123456f;

    //probar con valores random
    repeat (10)	begin
      //Semilla inicial para el generador de numeros aleatorios

      @(posedge clkTx10) numrandom8 <= $random(semilla);
      @(posedge clkTx20) numrandom16 <= $random(semilla);
      @(posedge clkTx40) numrandom32 <= $random(semilla);
       $display($time, " << Prueba random 8bits=%b, 16bits=%b, 32bits=%b >>", numrandom8, numrandom16, numrandom32);
      @(posedge clkTx10) dataIn8 <= numrandom8;
      @(posedge clkTx20)
				dataS <= 2'b01;
				dataIn16 <= numrandom16;

      @(posedge clkTx20)
			dataS <= 2'b10;
			dataIn32 <= numrandom32;
      @(posedge clkTx) dataIn32 <= numrandom32;
    end

    //Lea y despliegue la memoria con contadores de transicion
		#450 LE = 1;
		for (dir=0; dir<=`NumPwrCntr; dir=dir+1)	begin
			#1 Contador = dato;
			$display(,,"PwrCntr[%d]: %d", dir, Contador);
		end

    #1 $finish;

    end


endmodule
