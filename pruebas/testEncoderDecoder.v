`timescale 1ns/1ps

`include "../lib/cmos_cells.v"
`include "../bloques/encoder8-10/encoder.v"
`include "../build/encoder-sintetizado.v"
`include "../bloques/8b10b-10bto8b/decoder10to8.v"
`include "../build/decoder10to8-sintetizado.v"

module testEncoder;


reg [7:0] entradas;
wire [9:0] salidasC;
wire [9:0] salidasE;
wire [7:0] salidasDeco;
wire [7:0] salidasDecoSynt;
reg enb, clk, K;
parameter retardo = 400;




encoder testEnc(
	.entradas(entradas),
	.salidas(salidasC),
	.K(K),
	.clk(clk),
	.enb(enb)
);

encoderSynth testEncoderSynth(
	.entradas(entradas),
	.salidas(salidasE),
	.K(K),
	.clk(clk),
	.enb(enb)
);


decoder10to8 decodificador(
  .clk(clk),
  .data10_in(salidasC),
  .data8_out(salidasDeco),
  .k_out(k)
);
decoder10to8Synth decodificadorSynth(
  .clk(clk),
  .data10_in(salidasE),
  .data8_out(salidasDecoSynt),
  .k_out(k)
);

always # 100 clk <= ~clk; // inicio de la señal de reloj, cambia cada 20ns

initial begin
	clk = 1;
	K = 0;

	enb = 0;

	#retardo;
	entradas = 8'b000_00011;

	#retardo;
	entradas = 8'b000_00011;

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
