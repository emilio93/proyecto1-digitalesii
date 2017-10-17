`timescale 1ns/1ps


module diferencialReceptor(
//  rst,
//  enb,
  entrada, // D+
  salida,  //bit de salida serial
  TxElecIdle
  );

//  input wire rst, enb;
  input wire entrada;
  output reg TxElecIdle, salida;
//  output reg salida = 0;

//Variables internas
  reg entradaAnterior;

  always @ ( * )begin
//          if() salida = 0;
//          else if(enb) salida = 1;
            if(entradaAnterior != entrada) salida = 1;
		else salida = 0;	    
	    entradaAnterior = entrada;	
        
  end

//Como hacer que tire 0 si no cambia entrada?
//Como hacer que mantenga salida durante un ciclo si no tengo reloJ?
  endmodule
