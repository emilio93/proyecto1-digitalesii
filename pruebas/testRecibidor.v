`timescale 1ns/1ps

`define isTestr 2
`ifndef cmos_cells
        `include "../lib/cmos_cells.v"
`endif

`ifndef recibidor
  `include "../bloques/interfaz-PCIE/recibidor.v"
`endif
`ifndef recibidorSynth
  `include "../build/recibidor-sintetizado.v"
`endif

module testRecibidor;

  reg rst;
  reg enb;
  reg clk;

  //variables para generar numeros random
  reg randIn;
  reg [7:0] numrandom8;
  reg [15:0] numrandom16;
  reg [31:0] numrandom32;
  integer semilla = 0;

  reg [1:0] dataS;

  wire [7:0] dataOut8;
  wire [15:0] dataOut16;
  wire [31:0] dataOut32;
  wire k_out;
//  reg TxElecIdle;
/*
  reg [7:0] dataOut8Synht;
  reg [15:0] dataOut16Synth;
  reg [31:0] dataOut32Synth;
  reg k_outSynth;
*/
  reg serialIn;

//  wire invalid_value;
//  wire invalid_valueSynth;

  recibidor testRecibidor(
    .clk(clk),
    .rst(rst),
    .enb(enb),
    .k_out(k_out),
    .serialIn(serialIn),
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
    .k_out(k_outSynth),
    .serialIn(serialIn),
    .dataOut8(dataOut8Synth),
    .dataOut16(dataOut16Synth),
    .dataOut32(dataOut32Synth),
    .dataS(dataS)
  );
*/
  parameter rc1 = 100; // 100/10 = 10 ciclos, reloj menor
  parameter rc2 = 200; // 20 ciclos, reloj intermedio
  parameter rc4 = 400; // 40 ciclos, reloj mayor

  always #5 clk = ~clk; // inicio de la señal de reloj, cambia cada 10ns

  initial begin
    $dumpfile("gtkws/testReceptor.vcd");
    $dumpvars;
  end

  initial begin
//	  repeat (100)	begin
//	  @(posedge clk) randIn <= $random(semilla);
//	  serialIn = randIn;

	  enb <= 0;
	  rst <= 1;
	  serialIn = 0;
	  clk <= 0;
	  dataS <= 2'b00;
	  #100;
	  @(posedge clk)rst <= 0;
	  @(posedge clk)enb <= 1;
//	  #rc2
//	  dataS = 2'b10;
//	  #rc4
//	  dataS = 2'b01;
//	  #rc2
//	  dataS = 2'b10;
//	  #rc4
//	  dataS = 2'b01;

	  //probar con valores random
	  repeat (110)	begin
	  //Semilla inicial para el generador de numeros aleatoriosi
	  @(posedge clk) randIn <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randIn);
	  serialIn = randIn;
	  //dataS = 2'b10;
//	  #rc2;
  end

  $finish;

end

endmodule
