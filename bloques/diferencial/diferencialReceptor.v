`timescale 1ns/1ps


module diferencialReceptor(
//  rst,
//  enb,
  entrada, // D+
  salida,  //bit de salida serial
  TxElecIdle //se pone en 1 si detecta un voltaje de 0 en la entrada, en este modulo, z
  );

//  input wire rst, enb;
  input wire entrada;
  output reg TxElecIdle, salida;
//  output reg salida = 0;

//Variables internas
//  reg entradaAnterior;

  always @ ( * )begin
//          if() salida = 0;
//          else if(enb) salida = 1;
//            if(entradaAnterior != entrada) salida = 1;
//		else salida = 0;	    
//	    entradaAnterior = entrada;
	if (entrada == 1 | entrada == 0) begin
		TxElecIdle = 0;
		if (entrada == 1) salida = 0;
		else salida = 1;
	end
		else TxElecIdle = 1;
end

//Como hacer que tire 0 si no cambia entrada?
//Como hacer que mantenga salida durante un ciclo si no tengo reloJ?
  endmodule
