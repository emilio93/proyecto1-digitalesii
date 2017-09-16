# Bitácora del Proyecto

  > El grupo de tres estudiantes trabajará en equipo para completar esta asignación. Las características del equipo de trabajo serán las siguientes.

  > a. Entre los integrantes del equipo de trabajo se escogerá una persona para que sea el líder. Esta persona será responsable de convocar a los otros integrantes del equipo a reuniones y llevará una bitácora de los acuerdos, y avances que haga el equipo.

  > b. Entre los integrantes del equipo se compartirán las destrezas que cada uno de los integrantes tiene. De esta forma se pueden asignar roles y ciertas tareas. Dentro de las destrezas podrían estar: facilidad para planear, facilidad para programar, facilidad para hacer presentaciones en público, facilidad para escribir reportes, etc. La idea es que el equipo pueda repartirse las tareas del proyecto tomando en cuenta las destrezas de cada uno.

  > c. Cada integrante del equipo debe mantener informado al resto del equipo de los avances que ha hecho en las tareas que está haciendo y el tiempo que ha tomado hacerlas.

  > d. Como equipo de trabajo, su primera tarea será evaluar las propuestas de diseño de todos los integrantes y seleccionar una que se utilizará para ejecutar el proyecto. Esta propuesta se presentará en la primera presentación de avance que se hace en la clase.

  ## Reuniones

  ### Reunión 1
  _15/9/2017_

  _de 8:00pm a *en proceso_

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
