# Comandos de compilación tomados del ```Make```

## Preprocesamiento

```
cd pruebas; iverilog -E -DKEY=10 -o ../build/testTo8bit.pre.v testTo8bit.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testRecibidor.pre.v testRecibidor.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testTo8bitEncoder.pre.v testTo8bitEncoder.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testClk.pre.v testClk.v -Ttyp -g specify;cd ..; cd pruebas; iverilog -E -DKEY=10 -o ../build/testDecode10bto8b.pre.v testDecode10bto8b.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testDiferencialEmisorReceptor.pre.v testDiferencialEmisorReceptor.v -Ttyp -g specify;cd ..; cd pruebas; iverilog -E -DKEY=10 -o ../build/testFrom8bit.pre.v testFrom8bit.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/test_P1.pre.v test_P1.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testEncoder.pre.v testEncoder.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testRecibidorTransmisor.pre.v testRecibidorTransmisor.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testTransmisor.pre.v testTransmisor.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testK285Detector.pre.v testK285Detector.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testSincronizador.pre.v testSincronizador.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testSerialParalelo.pre.v testSerialParalelo.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testParaleloSerialSerialParalelo.pre.v testParaleloSerialSerialParalelo.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testEncoderDecoder.pre.v testEncoderDecoder.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testParaleloSerial.pre.v testParaleloSerial.v -Ttyp -g specify;cd ..;

cd pruebas; iverilog -E -DKEY=10 -o ../build/testTo8bitFrom8bit.pre.v testTo8bitFrom8bit.v -Ttyp -g specify;cd ..;
```

## Compilación

```
cd build; iverilog -o test_P1.o test_P1.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testEncoder.o testEncoder.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testRecibidorTransmisor.o testRecibidorTransmisor.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testDiferencialEmisorReceptor.o testDiferencialEmisorReceptor.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testTransmisor.o testTransmisor.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testK285Detector.o testK285Detector.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testFrom8bit.o testFrom8bit.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testSincronizador.o testSincronizador.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testSerialParalelo.o testSerialParalelo.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testTo8bit.o testTo8bit.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testParaleloSerialSerialParalelo.o testParaleloSerialSerialParalelo.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testEncoderDecoder.o testEncoderDecoder.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testbench_P1.o testbench_P1.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o memTrans.o memTrans.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testParaleloSerial.o testParaleloSerial.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testTo8bitFrom8bit.o testTo8bitFrom8bit.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testRecibidor.o testRecibidor.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testTo8bitEncoder.o testTo8bitEncoder.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testClk.o testClk.pre.v -Ttyp -g specify;cd ..;

cd build; iverilog -o testDecode10bto8b.o testDecode10bto8b.pre.v -Ttyp -g specify;cd ..;
```
