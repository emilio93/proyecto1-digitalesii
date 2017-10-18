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
// Ante cambios en la opinion del profesor usaremos la codificación NRZ-L
// la cual solamente invierte la señal de entrada.

module diferencialEmisor(
//  rst,
//  enb,
  entrada, // bit de entrada serial
  salida,  //D+
//  contadorE,
//  contador,
  TxElecIdle	//Es como un enable cuando esta alto la salida es 0 V, ya que en nuestro codigo no ponemos signos en los voltajes se pondra como z
//  TxDetectRx, //Se usa para empezar loopback o sea devolver señales emitidas para pruebas por lo tanto// no lo usaremos
//  TxMargin, //Seleciona rango de voltajes del emisor, por eso no lo usaremos
//  TxSwing, //Controla nivel de swing de voltaje de transmision y por lo  tanto no se usara
//  TxDeemph  //Se usa para seleccionar el nivel de de-emphasis del transmisor por esto no lo usaremos
    );

  input wire entrada;
  input wire TxElecIdle;
//  input wire TxDetectRx, TxMargin, TxSwing, TxDeemph;
//  input wire [5:0] contadorE;
  output reg salida = 0;
//  output reg [5:0]  contador = 0;

  always @ ( * )begin
	  if(TxElecIdle) salida = 1'bz;
	  else begin if (entrada == 1) salida = 0;
	  else salida = 1; 
//		  contador = contador +1;
//		  contadorE = contador;
//		  if(contador == 5'b11111) begin contador = 0;
//		  if (entrada == 1) salida = !salida;
//		  else salida = salida;
////	  end
  end
  end

endmodule
                       
/*Fuentes:
https://es.wikipedia.org/wiki/C%C3%B3digos_NRZ#NRZ-I
www.teknoplof.com/tag/nrz-i/
Especificion de intel.
*/
