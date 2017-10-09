# Bitácora del Proyecto

  > El grupo de tres estudiantes trabajará en equipo para completar esta asignación. Las características del equipo de trabajo serán las siguientes.

  > a. Entre los integrantes del equipo de trabajo se escogerá una persona para que sea el líder. Esta persona será responsable de convocar a los otros integrantes del equipo a reuniones y llevará una bitácora de los acuerdos, y avances que haga el equipo.

  > b. Entre los integrantes del equipo se compartirán las destrezas que cada uno de los integrantes tiene. De esta forma se pueden asignar roles y ciertas tareas. Dentro de las destrezas podrían estar: facilidad para planear, facilidad para programar, facilidad para hacer presentaciones en público, facilidad para escribir reportes, etc. La idea es que el equipo pueda repartirse las tareas del proyecto tomando en cuenta las destrezas de cada uno.

  > c. Cada integrante del equipo debe mantener informado al resto del equipo de los avances que ha hecho en las tareas que está haciendo y el tiempo que ha tomado hacerlas.

  > d. Como equipo de trabajo, su primera tarea será evaluar las propuestas de diseño de todos los integrantes y seleccionar una que se utilizará para ejecutar el proyecto. Esta propuesta se presentará en la primera presentación de avance que se hace en la clase.

  ## Reuniones

  ### Reunión 1
  _15/9/2017_

  _de 8:00pm a 11:15pm_

  _Son 3hrs 15mins_

   - Revisión del proyecto.

   - Hemos decidido trabajar según el libro _PCI Express System Architecture_, y las sugerencias del profesor.

   - Se decide usar la especificación de Intel 4.4.1 en vez de la 4.0 puesto que es más reciente. Esta utiliza el estandar USB 3.1 y no el 3.0 que viene en la especificación 4.0. El posible trabajo _extra_ se ve recompensado en estudiar una tecnología más actual.

   - Se decide usar [Marp](https://yhatt.github.io/marp/) para las presentaciones. Es fácil de usar, curva de aprendizaje mínima, poco configurable pero funciona para lo que necesitamos.

   - Estudio de Mercado:
     > Busque 2 fabricantes de circuitos integrados que vendan un dispositivo que sirva para implementar la funcionalidad de la capa PHY de una interfaz PCIe y de una interfaz USB. Un posible fabricante y producto se puede encontrar en http://www.nxp.com/. Examine el producto de este fabricante y otro para determinar, tanto para PCIe como para USB, lo siguiente:
1. ¿Qué bloques funcionales trae la capa PHY para una interfaz PCIe?
2. ¿Qué bloques funcionales trae la capa PHY para una interfaz USB?
3. ¿Cuáles son las diferencias entre las capas PHY de PCIe y USB?
4. ¿Qué posibilidad hay de hacer un diseño que combine la funcionalidad de ambas
interfaces: PCIe y USB?
5. ¿Cuál debería ser el precio de cada circuito para ser competitivo con los productos que ya
están en el mercado?
6. ¿Cuál debería ser la frecuencia de operación y el consumo de energía para ser
competitivos?

     Se buscan 2 componentes de PCIe y 2 componentes de USB.
     Se han encontrado los siguientes productos:
     ### [PX1011B: PCI Express stand-alone X1 PHY](https://www.nxp.com/products/interfaces/pci-express/pci-express-stand-alone-x1-phy:PX1011B)

     - __Precio:__ $6.88 por unidad al comprar 1000 unidades.
     - __Bloques:__

       ![Bloques del componente](https://www.nxp.com/assets/images/en/block-diagrams/002aac211.gif)

     - __Frecuencia:__ De la hoja del fabricante: fclk(ref) reference clock frequency min:99.97, typ:100, max:100.03 MHz

     - __Potencia:__ De la hoja del fabricante:

       Power management

       - Dissipates < 300 mW in L0 normal mode

       - Support power management of L0, L0s and L1

   - Se inicia la presentación 1 en ```/presentaciones/presentacion-1.md```.

   - Se agregan documentos de referencia en ```/documentos```.

  ### Pendientes

   - Se eligió el componenete XIO1100 de TI, queda pendiente agregar información de este.
   - Busqueda de usb's.
   - Propuesta de trabajo.
   - Finalizar Presentación.

  _Fin de la reunión 1_

  ### Reunión 2

  _Propuesta para el 16/9/2017, hora todavía por acordar_

  _17/9/2017_

  _Se inicia a las 15:00, Se finaliza a las 4:45_

    - Se discute sobre M31Tech que provee diseños para diferentes protocolos IP.

    - Se continua con la presentación

    - Se asignan tareas para el día de hoy y siguiente semana.

    _Emilio se va a las 16:00_
    _Reunión continua con los demás integrantes_

    - Se agrego un componente USB 3.0 de Texas Instruments
    - Falta agregar la informacion de potencia y frecuencia
    - En la mañana trabajare en ello
    - Robin completo una version de los modulos paralelo-serial, serial-paralelo
    - Boa se desconecta a las 7:20pm
    
  ### Reunión 3

  _21/9/2017_

  _Se inicia a las 11:00_

  Se definen las entradas y salidas para los bloques
  Encoder8b10b y Decoder10b8b y en general se habla
  sobre el funcionamiento de estos bloques y su utilidad

  Se enfatiza en la nececidad de crear pruebas para los
  bloques existentes, sin embargo se da prioridad al
  diseño en este momento.
  _Se termina a las 12:45_

  ### Reunión 4

  _24/9/2017_
  _Reunión breve a través de mensajes a las 20:30_

  Se da un resumen de la semana a Robin, se decide
  exponer el jueves para poder nivelarnos con lo que
  se ha hecho.
  No obstante al final expusimos el mismo lunes.

  Entre el 24 y el 4 de octubre no se dan reuniones estrictamente.
  Robin ha pasado a ser el líder del equipo.

  ### Reunión 5

  _5/10/17_
  _Reunión breve a través de llama de voz_
  _Se inicia a las 8:20_

  Nos ponemos de acuerdo para qué hacer cada uno,
  nos ponemos al día con el trabajo de Emilio.
  Los siguientes pasos son: tener listo el modulo 8bit (Emilio), codificador 8 a 10 b (Robin)
  decodificador (Boanerges) y su respectivo tester.
  Para exponer esto en la clase del lunes.
  Una vez logrado este avance aun faltaría hacer el módulo diferenciador, los otros 3 modulos 
  presentes en el receptor y optimizar toda nuestra interfaz PCIE.
  _Emilio se desconecta a las 8:40
  _Boanerges y Robin a las 9:10

  ### Reunión 6

  _7/10/17_
  _Reunión a través de mensajes por 25 min a las 9:15_

  Se toma la decisción de exponer por aparte por un lado Robin y Boanerges y por el otro Emilio.
  Quedan aun varios bloques por hacer:from8bit, bloques en receptor de PCI, diferencial.
  Emilio considera haber hecho su trabajo de la semana.
  Robin y Boanerges seguirán trabajando dedicando el domingo el proyecto para avanzar más rápido y
  presentarán los resultados obtenidos.
  

### Reunión 7

  _8/10/2017

  _Reunión  a través de llama de voz_
  _Se inicia a las 9:35, Se finaliza a las 10:15_

    - Hablamos acerca de nuestros avances y qué expondremos juntos mañana.
    - Acordamos dividirnos el trabajo mañana durante clase.
    - Observamos los resultados y Emilio explica brevemente como usar Marp.
    - Siguientes pasos:
	- Averiguar si se ocupan los 3 modulos presentes en el receptor.
	- Aclarar dudas con tiempos de encoder en emisor y dudas de funcionamiento entre encoder
	y decoder.
	- Hacer modulo diferenciador.
	- Hacer modulo recuperador de reloj.
	- Hacer modulo receptor.
	- Interconectar todo.
	- Optimizar el diseño.
