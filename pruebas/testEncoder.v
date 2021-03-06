`timescale 1ns/1ps

`ifndef cmos_cells
  `include "../lib/cmos_cells.v"
`endif

`ifndef clks
  `include "../bloques/clks/clks.v"
`endif
`ifndef to8bit
  `include "../bloques/to8bit-from8bit/to8bit.v"
`endif
`ifndef encoder
  `include "../bloques/encoder-decoder/encoder.v"
`endif
`ifndef paraleloSerial
  `include "../bloques/paraleloSerial-serialParalelo/paraleloSerial.v"
`endif

//`include "../diferencial/diferencial.v"

`ifndef encoderSynth
  `include "../build/encoder-sintetizado.v"
`endif

module testEncoder;

	reg [7:0] entradas;
	wire [9:0] salidasC;
	wire [9:0] salidasE;
	reg enb, clk, K, rst;
	parameter retardo = 30;

encoder testEnc(
	.entradas(entradas),
	.salidas(salidasC),
	.K(K),
	.clk(clk),
  .rst(rst),
  .enb(enb)
);

encoderSynth testEncoderSynth(
	.entradas(entradas),
	.salidas(salidasE),
	.K(K),
	.clk(clk),
  .rst(rst),
  .enb(enb)
);

always # 5 clk <= ~clk; // inicio de la señal de reloj, cambia cada 20ns

initial begin
	clk = 1;
	K = 0;
  rst =1;
	enb = 0;

	entradas = 8'b000_00011;

	#retardo;
	entradas = 8'b000_00011;

//0
	#retardo;
	entradas = 8'b000_00000;


	#retardo;
	entradas = 8'b000_00000;

	#retardo;
	entradas = 8'b000_00000;

	#retardo;
	entradas = 8'b000_00000;

	enb = 1;
  rst =0;

	#retardo;
	entradas = 8'b000_00000;

	#retardo;
	entradas = 8'b000_00000;

//1
	#retardo;
	entradas = 8'b000_00001;

	#retardo;
	entradas = 8'b000_00001;

	#retardo;
	entradas = 8'b000_00001;

	#retardo;
	entradas = 8'b000_00001;

	#retardo;
	entradas = 8'b000_00001;

	#retardo;
	entradas = 8'b000_00001;

//2
	#retardo;
	entradas = 8'b000_00010;

	#retardo;
	entradas = 8'b000_00010;

	#retardo;
	entradas = 8'b000_00010;

	#retardo;
	entradas = 8'b000_00010;


	#retardo;
	entradas = 8'b000_00010;

	#retardo;
	entradas = 8'b000_00010;

//3
	#retardo;
	entradas = 8'b000_00011;


	#retardo;
	entradas = 8'b000_00011;


	#retardo;
	entradas = 8'b000_00011;


	#retardo;
	entradas = 8'b000_00011;


	#retardo;
	entradas = 8'b000_00011;


	#retardo;
	entradas = 8'b000_00011;

//4
	#retardo;
	entradas = 8'b000_00100;


	#retardo;
	entradas = 8'b000_00100;


	#retardo;
	entradas = 8'b000_00100;


	#retardo;
	entradas = 8'b000_00100;


	#retardo;
	entradas = 8'b000_00100;


	#retardo;
	entradas = 8'b000_00100;


//5
	#retardo;
	entradas = 8'b000_00101;


	#retardo;
	entradas = 8'b000_00101;

	#retardo;
	entradas = 8'b000_00101;


	#retardo;
	entradas = 8'b000_00101;


	#retardo;
	entradas = 8'b000_00101;


	#retardo;
	entradas = 8'b000_00101;

//6
	#retardo;
	entradas = 8'b000_00110;

	#retardo;
	entradas = 8'b000_00110;

	#retardo;
	entradas = 8'b000_00110;

	#retardo;
	entradas = 8'b000_00110;

	#retardo;
	entradas = 8'b000_00110;

	#retardo;
	entradas = 8'b000_00110;
//1
	#retardo;
	entradas = 8'b000_10001;

	#retardo;
	entradas = 8'b000_10001;

	#retardo;
	entradas = 8'b000_00000;

	#retardo;
	entradas = 8'b000_00001;

	#retardo;
	entradas = 8'b000_00010;

	#retardo;
	entradas = 8'b100_00011;
//2
	#retardo;
	entradas = 8'b100_00100;

	#retardo;
	entradas = 8'b100_00101;

	#retardo;
	entradas = 8'b100_00110;

	#retardo;
	entradas = 8'b100_00111;

	#retardo;
	entradas = 8'b100_10000;

	#retardo;
	entradas = 8'b010_00000;
//4
	#retardo;
	entradas = 8'b010_00001;

	#retardo;
	entradas = 8'b010_00010;

	#retardo;
	entradas = 8'b010_00011;

	#retardo;
	entradas = 8'b010_00100;

	#retardo;
	entradas = 8'b010_00101;
//6
	#retardo;
	entradas = 8'b110_00110;

	#retardo;
	entradas = 8'b110_00111;

	#retardo;
	entradas = 8'b110_10000;

	#retardo;
	entradas = 8'b110_00110;

	#retardo;
	entradas = 8'b110_00111;

	#retardo;
	entradas = 8'b110_10000;

	#retardo;
	$finish;
	//@ (posedge clk);
//	rst <= 0;

  end

  initial begin
  	$dumpfile("gtkws/testEncoder.vcd");
  	$dumpvars;
  	$display("		tiempo    | clk | enb | entradas | K |  salidasC  |  salidasE  | tiempo ns");
  	$monitor("%t      | %b   |  %b    %b   %b   %b   %b   %f ns", $time, clk, enb, entradas, K , salidasC , salidasE, $realtime);

  end

endmodule
