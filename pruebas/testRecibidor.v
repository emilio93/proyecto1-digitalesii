`timescale 1ns/1ps

`define isTest 1
`ifndef cmos_cells
        `include "../lib/cmos_cells.v"
`endif
`ifndef clks
  `include "../bloques/clks/clks.v"
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
reg clkRx;
reg clkRstRx;
reg clkEnbRx;

//variables para generar numeros random
reg randEntradaSerial;
integer semilla = 0;

wire [7:0] dataOut8;
wire [15:0] dataOut16;
wire [31:0] dataOut32;
wire k_out;
reg [1:0] dataS;

wire [7:0] dataOut8Synht;
wire [15:0] dataOut16Synth;
wire [31:0] dataOut32Synth;
wire k_outSynth;

wire invalid_value;
wire invalid_valueSynth;

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
  .serialIn(randEntradaSerial),
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
.serialIn(randEntradaSerial),
.dataS(dataS)
);


wire clkRx10;
wire clkRx20;
wire clkRx40;
clks clksRx(
  clkRx, rst, enb,
  clkRx10, clkRx20, clkRx40
);

  always #0.1 clkRx = ~clkRx; // inicio de la señal de reloj, cambia cada 10ns

  initial begin
    $dumpfile("gtkws/testRecibidor.vcd");
    $dumpvars;
  end

  initial begin
//	  repeat (100)	begin
//	  @(posedge clk) randIn <= $random(semilla);
//	  serialIn = randIn;
	  enb <= 1;
    rst <= 1;
    clkRstRx <= 1;
	  clkEnbRx <= 1;
	  randEntradaSerial <= 0;
	  clkRx <= 0;
	  dataS <= 2'b00;
	  #100;
    clkRstRx <= 0;
    # 100
	  @(posedge clkRx)rst <= 0;
	  @(posedge clkRx)enb <= 1;
//	  #rc2
//	  dataS = 2'b10;
//	  #rc4
//	  dataS = 2'b01;
//	  #rc2
//	  dataS = 2'b10;
//	  #rc4
//	  dataS = 2'b01;

	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b00;
	  end
  	  
	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b00;
  end

 	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b00;

	  end
  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b00;

	   end
 repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b00;
  end

	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b00;
  repeat (8)	begin
  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b01;
  end	  	
	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b01;
  end	  	
 	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b00;
  end	  	
	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b00;
  end	  	
	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
  end	  	
	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
   end	  	 repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
	  	  end	  	  
	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
  end	  	
 	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b00;
  end	  	
	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b01;
  end	  	
	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b01;
  end	  	
	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b01;
   end	  	 repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b01;
	  	  end	  	  
	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
  end	  	
 	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
  end

	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
  end

	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
  end

	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
   end	  	 repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
	  end
  	  
	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
  end

 	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
  end

	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b10;
  end

	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b00;
  end

	  repeat (8)	begin
	  @(posedge clkRx) randEntradaSerial <= $random(semilla);
	  $display($time, " << Prueba random bits = %b >>", randEntradaSerial);
	  dataS = 2'b00;
  end

  end

  $finish;

end

endmodule
