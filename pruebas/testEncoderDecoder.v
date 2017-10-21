`timescale 1ns/1ps

`include "../lib/cmos_cells.v"
`include "../bloques/encoder-decoder/encoder.v"
`include "../build/encoder-sintetizado.v"
`include "../bloques/encoder-decoder/decoder.v"
`include "../build/decoder-sintetizado.v"

module testEncoder;


reg [7:0] entradas;
wire [9:0] salidasC;
wire [9:0] salidasE;
wire [7:0] salidasDeco;
wire [7:0] salidasDecoSynt;
wire k;
wire kSynth;
wire invalid_value;
wire invalid_valueSynth;
reg enb, clk, K, rst;
parameter retardo = 400;




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


decoder decodificador(
  .clk(clk),
  .data10_in(salidasC),
  .data8_out(salidasDeco),
  .invalid_value(invalid_value),
  .k_out(k),
	.rst(rst),
	.enb(enb)
);
decoderSynth decodificadorSynth(
  .clk(clk),
  .data10_in(salidasE),
  .data8_out(salidasDecoSynt),
  .invalid_value(invalid_valueSynth),
	.rst(rst),
	.enb(enb),
  .k_out(kSynth)
);

always # 100 clk <= ~clk; // inicio de la señal de reloj, cambia cada 20ns

initial begin
	clk = 1;
	K = 0;
	rst=1;
	enb = 0;

	#retardo;
	entradas = 8'b000_00011;

	#retardo;
	entradas = 8'b000_00011;
	rst=0;
	enb = 1;
//0
	#retardo;
	entradas = 8'b000_00000;


	#retardo;
	entradas = 8'b000_00000;

	#retardo;
	entradas = 8'b000_00000;

	#retardo;
	entradas = 8'b000_00000;

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
  	$dumpfile("gtkws/testEncoderDecoder.vcd");
  	$dumpvars;
  	$display("		tiempo    | clk | enb | entradas | K |  salidasC  |  salidasE  | tiempo ns");
  	$monitor("%t      | %b   |  %b    %b   %b   %b   %b   %f ns", $time, clk, enb, entradas, K , salidasC , salidasE, $realtime);

  end

endmodule
