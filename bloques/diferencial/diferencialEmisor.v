`timescale 1ns/1ps

// Existen diferentes tipos de codificacion NRZ, en este caso nosotros 
// usaremos la codificacion NRZI para el bloque diferencial, la cual 
// consiste en realizar una transicion en la señal de salida cuando en la 
// entrada se recibe un 1 y mantener el valor actual en la señal de salida
// cuando en la entrada se presenta un 0.
// Este módulo recibe la informacion del modulo paraleloSerial la codifica
// y envia al receptor diferencial que se haya en la mitad receptora de la
// interfaz PCIE.                                        
// Es importante notar que esta codificacion siempre empieza con 0.

module diferencialEmisor(
  rst,
  enb,
  entrada, // bit de entrada serial
  salida,  //D+
  TxElecIdle,
  TxDetectRx,
  TxMargin,
  TxSwing,
  TxDeemph
  );

  input wire rst, enb, entrada;
  output reg TxElecIdle, TxDetectRx, TxMargin, TxSwing, TxDeemph;
  output reg salida = 0;

  always @ (entrada)begin
	  if(rst) salida = 0;
	  else if(enb)begin
	  if (entrada == 1)	salida = !salida;
	  else salida = salida;
  end
			else salida = 0;
  end

endmodule
                       
/*Fuentes:
      https://es.wikipedia.org/wiki/C%C3%B3digos_NRZ#NRZ-I
	www.teknoplof.com/tag/nrz-i/
	Especificion de intel.
	*/
