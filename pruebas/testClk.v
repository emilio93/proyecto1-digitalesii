`timescale 1ns/1ps

`ifndef clks
  `include "./bloques/clk/clks.v"
`endif
`ifndef cmos_cells
  `include "./lib/cmos_cells.v"
`endif
`ifndef clksSynth
  `include "./build/clks-sintetizado.v"
`endif

module testClks;

  reg clk;
  reg rst;
  reg enb;

  wire clk10;
  wire clk20;
  wire clk40;

  wire clk10Synth;
  wire clk20Synth;
  wire clk40Synth;

  clks testClks(
    .clk(clk),
    .rst(rst),
    .enb(enb),
    .clk10(clk10),
    .clk20(clk20),
    .clk40(clk40)
  );

  clksSynth testClksSynth(
    .clk(clk),
    .rst(rst),
    .enb(enb),
    .clk10(clk10Synth),
    .clk20(clk20Synth),
    .clk40(clk40Synth)
  );

  always # 5 clk = ~clk; // inicio de la señal de reloj, cambia cada 10ns

  initial begin
  	clk = 0;
    rst = 1;
    enb = 1;
    # 40;
    @ (posedge clk);
    rst = 0;
  	# 900;
  	$finish;
  end

  initial begin
  	$dumpfile("gtkws/testClks.vcd");
  	$dumpvars;
  	$display("		tiempo    | clk | clk10 |   entradas    | salida | contadorE | timepo en escala usada");
  	$monitor("%t      | %b   | %b %f ns", $time, clk, clk10, $realtime);

  end

endmodule
