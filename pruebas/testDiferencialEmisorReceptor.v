`timescale 1ns/1ps

`include "../lib/cmos_cells.v"

`include "../bloques/diferencial/diferencialEmisor.v"
`include "../build/diferencialEmisor-sintetizado.v"

`include "../bloques/diferencial/diferencialReceptor.v"
`include "../build/diferencialReceptor-sintetizado.v"

module testDiferencialEmisorReceptor ();

//reg rst;
//reg enb;
wire salidaReceptor;
reg entradaEmisor;
//reg entradaEmisor;
wire salidaEmisor, TxElecIdleReceptor;
reg TxElecIdle;

wire salidaReceptorSynth;
wire salidaEmisorSynth, TxElecIdleReceptorSynth;

//Faltan mas vars

diferencialEmisor emisor(
//  .rst(rst), .enb(enb),
  .TxElecIdle(TxElecIdle),
  .entrada(entradaEmisor),
  .salida(salidaEmisor)
);


diferencialReceptor receptor(
//  .rst(rst), .enb(enb),
  .entrada(salidaEmisor),
  .TxElecIdle(TxElecIdleReceptor),
  .salida(salidaReceptor)
);

diferencialEmisorSynth emisorSint(
//  .rst(rst), .enb(enb),
  .TxElecIdle(TxElecIdle),
  .entrada(entradaEmisor),
  .salida(salidaEmisorSynth)
);


diferencialReceptorSynth receptorSint(
//  .rst(rst), .enb(enb),
  .entrada(salidaEmisorSynth),
  .TxElecIdle(TxElecIdleReceptorSynth),
  .salida(salidaReceptorSynth)
);


parameter delay = 10;
//always # 5 clk = ~clk;//inicio de la señal de reloj, cambia cada 10ns

initial begin
//  enb <= 1;
//  clk <= 0;
//  rst <= 1'b1;

  TxElecIdle = 1;
  entradaEmisor = 0;
  #10
  entradaEmisor = 1;
  #10
  entradaEmisor = 1;
  #10
  entradaEmisor = 0;
  #10
  entradaEmisor = 0;
  #10
  entradaEmisor = 0;
  #10
  TxElecIdle = 0;
  entradaEmisor = 0;
  #10
  entradaEmisor = 1;
  #10
  entradaEmisor = 0;
  #10
  entradaEmisor = 1;
  #10
  entradaEmisor = 1;
  #10
  entradaEmisor = 1;
  #10
  entradaEmisor = 0;
  #10
  entradaEmisor = 0;
  #10
  entradaEmisor = 0;
  #10
  entradaEmisor = 1;
  #10
  entradaEmisor = 0;
  #10
  entradaEmisor = 0;
  #10
  entradaEmisor = 1;
  #10
  entradaEmisor = 1;
  #10
  entradaEmisor = 0;
  #10
  entradaEmisor = 0;
  #10

  $finish;

end

initial begin
  $dumpfile("gtkws/testDiferencialEmisorReceptor.vcd");
  $dumpvars;
end

endmodule
