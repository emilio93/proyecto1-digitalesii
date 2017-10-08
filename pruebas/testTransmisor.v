`timescale 1ns/1ps

`include "../lib/cmos_cells.v"
`include "../bloques/clks/clks.v"
`include "../bloques/to8bit-from8bit/to8bit.v"
`include "../bloques/encoder8-10/encoder.v"
`include "../bloques/paraleloSerial-serialParalelo/paraleloSerial.v"
//`include "../bloques/diferencial/diferencial.v"
`include "../bloques/interfaz-PCIE/transmisor.v"
//`include "../build/transmisor-sintetizado.v"

module testTransmisor;

  reg rst;
  reg enb;
  reg clk;

  reg [7:0] dataIn;
  reg [15:0] dataIn16;
  reg [31:0] dataIn32;
  reg [1:0] dataS;
  reg K;

/*  reg clk10, clk20, clk40;

  clks reloj(
        .clk(clk),
        .rst(rst),
        .enb(enb),
        .clk10(clk10),
        .clk20(clk20),
        .clk40(clk40)
  );
*/
  wire dataOut;

 // wire [7:0] dataOutSynth;


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

/*  transmisor testTransmisor-sintetizado(
    .clk(clk),
    .rst(rst),
    .enb(enb),
    .K(K),
    .dataIn(dataIn),
    .dataIn16(dataIn16),
    .dataIn32(dataIn32),
    .dataS(dataS),
    .serialOut;(dataOut)
  );
*/

  parameter rc1 = 50;
  parameter rc2 = 100;
  parameter rc4 = 200;

  always # 5 clk = ~clk; // inicio de la señal de reloj, cambia cada 10ns

  initial begin
    $dumpfile("gtkws/testTransmisor.vcd");
    $dumpvars;
  end


  initial begin

	  enb <= 0;
	  rst <= 1;
	  clk <= 0;
	  #50;
	  rst <= 0;
	  enb <= 1;
	  dataIn <= 8'hff;
	  enb <= 1;
	  K <= 0;
	  dataS <= 2'b00;
	  #rc1;
	  dataIn <= 8'h00;
	  #rc1;
	  dataIn <= 8'h00;
	  #rc1;
	  dataIn <= 8'h00;
	  #rc1;
	  dataIn <= 8'h00;
	  #rc1;
	  dataS <= 2'b01;
	  dataIn16 <= 16'h0000;
	  #rc2;
	  dataS <= 2'b10;
	  dataIn32 <= 32'h00000000;
	  #rc4;

	  $finish;

  end

/*  initial begin
    clk <= 0;
    rst <= 1;
    enb <= 1;
    K <= 0;
    dataIn <= 8'h00;
    dataIn16 <= 16'h0000;
    dataIn32 <= 32'h00000000;

    # 40;
    @ (posedge clk);
    rst <= 0;
    dataS <= 2'b00;

    @ (posedge clk10); dataIn <= 8'hff;
    @ (posedge clk10); dataIn <= 8'hf0;
    @ (posedge clk10); dataIn <= 8'h0f;
    @ (posedge clk10); dataIn <= 8'h00;
    @ (posedge clk10); dataIn <= 8'h80;
    @ (posedge clk10); dataIn <= 8'h01;

    @ (posedge clk10); dataIn <= 8'ha6;
    @ (posedge clk10); dataIn <= 8'hd2;

    @ (posedge clk10);
    dataS <= 2'b01;
    dataIn16 <= 16'had43;

    @ (posedge clk10);
    @ (posedge clk10); dataIn16 <= 16'h543f;

    @ (posedge clk10);
    @ (posedge clk10);
    dataIn16 <= 16'h7d5a;

    @ (posedge clk10);
    @ (posedge clk10);  
    dataS <= 2'b10;
    dataIn32 <= 32'h95fdad43;

    @ (posedge clk10);
    @ (posedge clk10);
    @ (posedge clk10);
    @ (posedge clk10); dataIn32 <= 32'h94d5543f;

    @ (posedge clk10);
    @ (posedge clk10);
    @ (posedge clk10);
    @ (posedge clk10); dataIn32 <= 32'h0378fdae;

    # 910;
    @ (posedge clk);
    enb <= 0;
    # 600;
    $finish;
  end
*/

endmodule
