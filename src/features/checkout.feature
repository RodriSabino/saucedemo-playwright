# language: es
@checkout
Característica: Proceso de compra
  Como cliente de Sauce Demo
  Quiero completar el proceso de compra
  Para adquirir los productos que agregué al carrito

  Antecedentes:
    Dado que el usuario "standard_user" ha iniciado sesión

  @happy @smoke @e2e
  Escenario: Completar una compra hasta la confirmación
    Cuando agrega al carrito el producto "Sauce Labs Backpack"
    Y va al carrito de compras
    Y inicia el checkout
    Y ingresa sus datos: nombre "Ana", apellido "Pérez" y código postal "15001"
    Y continúa al resumen de la compra
    Entonces ve la página de resumen de la compra
    Y el resumen de compra muestra los siguientes productos:
      | Sauce Labs Backpack |
    Y los importes del resumen son correctos
    Cuando finaliza la compra
    Entonces ve la confirmación de la compra con el mensaje "Thank you for your order!"
    Y el ícono del carrito no muestra contador

  @happy @e2e @importes
  Esquema del escenario: Comprar <descripcion> calcula correctamente subtotal, impuesto y total
    Cuando agrega al carrito los productos "<productos>"
    Y va al carrito de compras
    Y inicia el checkout
    Y ingresa sus datos: nombre "Luis", apellido "Gómez" y código postal "15046"
    Y continúa al resumen de la compra
    Entonces ve la página de resumen de la compra
    Y el resumen de compra muestra los productos "<productos>"
    Y los importes del resumen son correctos
    Y el impuesto del resumen es el 8% del subtotal
    Cuando finaliza la compra
    Entonces ve la confirmación de la compra con el mensaje "Thank you for your order!"

    Ejemplos:
      | descripcion                 | productos                                                                                                                                         |
      | el producto más barato      | Sauce Labs Onesie                                                                                                                                 |
      | el producto más caro        | Sauce Labs Fleece Jacket                                                                                                                          |
      | dos productos               | Sauce Labs Bike Light,Sauce Labs Fleece Jacket                                                                                                    |
      | todo el catálogo            | Sauce Labs Backpack,Sauce Labs Bike Light,Sauce Labs Bolt T-Shirt,Sauce Labs Fleece Jacket,Sauce Labs Onesie,Test.allTheThings() T-Shirt (Red) |

  @happy @formulario
  Esquema del escenario: El formulario acepta datos de envío válidos - <caso>
    Cuando agrega al carrito el producto "Sauce Labs Backpack"
    Y va al carrito de compras
    Y inicia el checkout
    Y ingresa sus datos: nombre "<nombre>", apellido "<apellido>" y código postal "<postal>"
    Y continúa al resumen de la compra
    Entonces ve la página de resumen de la compra

    Ejemplos:
      | caso                           | nombre     | apellido   | postal |
      | un carácter por campo          | A          | B          | 1      |
      | nombres con tildes y eñes      | José       | Ñúñez      | 15001  |
      | nombres compuestos con espacio | María José | De la Cruz | 15-001 |

  @unhappy @validaciones
  Esquema del escenario: El formulario de envío rechaza datos incompletos - <caso>
    Cuando agrega al carrito el producto "Sauce Labs Backpack"
    Y va al carrito de compras
    Y inicia el checkout
    Y ingresa sus datos: nombre "<nombre>", apellido "<apellido>" y código postal "<postal>"
    Y continúa al resumen de la compra
    Entonces ve el mensaje de error "<mensaje>"
    Y ve la página de datos de envío

    Ejemplos:
      | caso                                 | nombre | apellido | postal | mensaje                        |
      | todos los campos vacíos              |        |          |        | Error: First Name is required  |
      | solo falta el nombre                 |        | Pérez    | 15001  | Error: First Name is required  |
      | faltan nombre y apellido             |        |          | 15001  | Error: First Name is required  |
      | faltan nombre y código postal        |        | Pérez    |        | Error: First Name is required  |
      | solo falta el apellido               | Ana    |          | 15001  | Error: Last Name is required   |
      | faltan apellido y código postal      | Ana    |          |        | Error: Last Name is required   |
      | solo falta el código postal          | Ana    | Pérez    |        | Error: Postal Code is required |

  @happy @estado
  Escenario: Cancelar desde el formulario de datos regresa al carrito sin perder productos
    Cuando agrega al carrito el producto "Sauce Labs Backpack"
    Y va al carrito de compras
    Y inicia el checkout
    Y cancela el checkout desde el formulario de datos
    Entonces ve la página del carrito
    Y el carrito contiene los siguientes productos:
      | producto            | precio |
      | Sauce Labs Backpack | $29.99 |

  @happy @estado
  Escenario: Cancelar desde el resumen regresa a la página de productos sin perder productos
    Cuando agrega al carrito el producto "Sauce Labs Backpack"
    Y va al carrito de compras
    Y inicia el checkout
    Y ingresa sus datos: nombre "Ana", apellido "Pérez" y código postal "15001"
    Y continúa al resumen de la compra
    Y cancela el checkout desde el resumen
    Entonces ve la página de productos
    Y el ícono del carrito muestra 1 producto

  @happy @estado @e2e
  Escenario: Después de la compra el carrito queda vacío y se puede volver a la tienda
    Cuando agrega al carrito los productos "Sauce Labs Bike Light,Sauce Labs Fleece Jacket"
    Y va al carrito de compras
    Y inicia el checkout
    Y ingresa sus datos: nombre "Luis", apellido "Gómez" y código postal "15046"
    Y continúa al resumen de la compra
    Y finaliza la compra
    Entonces ve la confirmación de la compra con el mensaje "Thank you for your order!"
    Cuando vuelve a la página de productos desde la confirmación
    Entonces ve la página de productos
    Y el ícono del carrito no muestra contador
    Cuando va al carrito de compras
    Entonces el carrito está vacío
