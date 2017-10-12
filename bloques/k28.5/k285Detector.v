`timescale 1ns/1ps

// Para iniciar la lectura de datos durante una transmisión, es necesario
// identificar el inicio de los bits que se reciben, estos bits se reciben
// encodeados(8b10b). Se define un símbolo de diez bits conocido como 28.5k
// que indica el marco en que se reciben los bits.
//
// Este módulo se encarga de observar los últimos diez bits de una entrada
// serial para detectar el símbolo de control k28.5 que indica el inicio o
// fin de una secuencia de datos que envía el transmisor.
//
// La indicación del simbolo se realiza de manera inmediata
// {memoria[8:0], entrada} == k28.5
// El bit 9 fue evaluado en el ciclo anterior, por eso se
// procede a realizar la comparacion con los siguientes datos.
//
// Este módulo cuenta con una señal de lectura que indica que se está
// dentro de un marco de k28.5, esta señal se enciende cuando se observa
// un k28.5, y se apaga cuando se observa otro. Esta señal también se
// apaga cuando se enciende rst.
//
// El modulo lleva un offset de diez ciclos al inicio para
// tener 10 bits en registros y evitar señales de salida
// indeterminadas(ojo que 001xxxxxxxxx puede ser igual a la
// serie k28.5).

module k285Detector(
  clk,
  rst,
  enb,
  entrada, // bit de entrada serial
  esk285,  // indica que se tiene k28.5
  lectura, // indica estado de lectura
  offsetCnt,
  rxValid
);

  // Valor del simbolo K.28.5
  //   dec 188
  //   hex BC
  //   HGF EDCBA 101 11100
  //   rd -1 abcdei fghj 001111 1010
  //   rd +1 abcdei fghj 110000 0101
  //
  //   Se usa rd -1
  parameter valork285 = 10'b001111_1010;

  // señales base
  input wire clk;
  input wire rst;
  input wire enb;

  // bit de entrada serial
  input wire entrada;

  // indica si se tiene el simbolo k28.5
  // se indica inmediatamente se ha detectado
  // el simbolo
  output reg esk285;
  output reg lectura;

  output reg rxValid;

  output reg [3:0] offsetCnt;
  reg [8:0] bits; // 9 bits + entrada

  always @ (posedge clk) begin
    if (rst) begin
      esk285 <= 0;
      lectura <= 0;
      offsetCnt <= 4'd10;
    end else if (~rst && enb) begin
      bits[0] <= entrada;
      bits[1] <= bits[0];
      bits[2] <= bits[1];
      bits[3] <= bits[2];
      bits[4] <= bits[3];
      bits[5] <= bits[4];
      bits[6] <= bits[5];
      bits[7] <= bits[6];
      bits[8] <= bits[7];
      if (offsetCnt > 0) begin
        offsetCnt <= offsetCnt-1;
      end else begin
        esk285 <= ({bits[8:0], entrada} == valork285);
        lectura <= esk285 ? ~lectura : lectura;
      end
    end
  end

endmodule
