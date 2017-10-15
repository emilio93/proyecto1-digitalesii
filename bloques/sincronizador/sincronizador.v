`timescale 1ns/1ps
/*Sincroniza los datos de entrada desde el transmisor, que pueden estar en desfase,
con el reloj del receptor, utilizando "2-FF synchronizers"*/
module sincronizador (
  output reg dataSync,  //salida sincronizada con el reloj del receptor
  input wire dataAsync, //entrada asincronica desde el transmisor
  input wire clkRx,     //reloj del receptor
  input wire rst      //señal de reset
);

reg flop1;

always @ ( posedge clkRx ) begin
  if (rst) begin
    flop1 <= 1'b0;
    dataSync <= 1'b0;
  end else begin
    flop1 <= dataAsync;
    dataSync <= flop1;
  end
end

endmodule // sincronizador
