# language: es
@carrito
Característica: Carrito de compras
  Como cliente de Sauce Demo
  Quiero agregar productos al carrito y revisarlos
  Para confirmar lo que voy a comprar

  Antecedentes:
    Dado que el usuario "standard_user" ha iniciado sesión

  @happy @smoke
  Escenario: Agregar un producto al carrito desde la página de productos
    Cuando agrega al carrito el producto "Sauce Labs Backpack"
    Entonces el ícono del carrito muestra 1 producto
    Y el botón del producto "Sauce Labs Backpack" cambia a "Remove"

  @happy @cantidades
  Esquema del escenario: Agregar <cantidad> producto(s) actualiza el contador y el contenido del carrito
    Cuando agrega al carrito los productos "<productos>"
    Entonces el ícono del carrito muestra <cantidad> productos
    Cuando va al carrito de compras
    Entonces ve la página del carrito
    Y el carrito contiene <cantidad> productos
    Y cada producto del carrito tiene cantidad 1

    Ejemplos:
      | cantidad | productos                                                                                                                                         |
      | 1        | Sauce Labs Onesie                                                                                                                                 |
      | 3        | Sauce Labs Backpack,Sauce Labs Bike Light,Sauce Labs Onesie                                                                                       |
      | 6        | Sauce Labs Backpack,Sauce Labs Bike Light,Sauce Labs Bolt T-Shirt,Sauce Labs Fleece Jacket,Sauce Labs Onesie,Test.allTheThings() T-Shirt (Red) |

  @happy @smoke
  Escenario: Ver en el carrito los productos agregados
    Cuando agrega al carrito el producto "Sauce Labs Backpack"
    Y agrega al carrito el producto "Sauce Labs Bolt T-Shirt"
    Y va al carrito de compras
    Entonces ve la página del carrito
    Y el carrito contiene los siguientes productos:
      | producto                | precio |
      | Sauce Labs Backpack     | $29.99 |
      | Sauce Labs Bolt T-Shirt | $15.99 |

  @happy @catalogo
  Esquema del escenario: El carrito muestra nombre, precio y cantidad de "<producto>"
    Cuando agrega al carrito el producto "<producto>"
    Y va al carrito de compras
    Entonces el carrito contiene los siguientes productos:
      | producto   | precio   |
      | <producto> | <precio> |
    Y cada producto del carrito tiene cantidad 1

    Ejemplos:
      | producto                          | precio |
      | Sauce Labs Backpack               | $29.99 |
      | Sauce Labs Bike Light             | $9.99  |
      | Sauce Labs Bolt T-Shirt           | $15.99 |
      | Sauce Labs Fleece Jacket          | $49.99 |
      | Sauce Labs Onesie                 | $7.99  |
      | Test.allTheThings() T-Shirt (Red) | $15.99 |

  @happy @estado
  Escenario: Quitar un producto desde el carrito conserva el resto
    Cuando agrega al carrito el producto "Sauce Labs Backpack"
    Y agrega al carrito el producto "Sauce Labs Onesie"
    Y va al carrito de compras
    Y quita del carrito el producto "Sauce Labs Backpack"
    Entonces el carrito contiene los siguientes productos:
      | producto          | precio |
      | Sauce Labs Onesie | $7.99  |
    Y el ícono del carrito muestra 1 producto

  @happy @estado
  Escenario: Quitar un producto desde la página de productos lo devuelve al estado inicial
    Cuando agrega al carrito el producto "Sauce Labs Backpack"
    Y quita de la página de productos el producto "Sauce Labs Backpack"
    Entonces el ícono del carrito no muestra contador
    Y el botón del producto "Sauce Labs Backpack" cambia a "Add to cart"

  @happy @estado
  Escenario: Quitar todos los productos deja el carrito vacío
    Cuando agrega al carrito todos los productos del catálogo
    Y va al carrito de compras
    Y quita del carrito todos los productos
    Entonces el carrito está vacío
    Y el ícono del carrito no muestra contador

  @happy @estado
  Escenario: Continuar comprando conserva el contenido del carrito
    Cuando agrega al carrito los productos "Sauce Labs Backpack,Sauce Labs Bike Light"
    Y va al carrito de compras
    Y continúa comprando
    Entonces ve la página de productos
    Y el ícono del carrito muestra 2 productos
    Y el botón del producto "Sauce Labs Backpack" cambia a "Remove"
    Y el botón del producto "Sauce Labs Bike Light" cambia a "Remove"

  @happy @estado
  Escenario: Recargar la página conserva el contenido del carrito
    Cuando agrega al carrito los productos "Sauce Labs Backpack,Sauce Labs Bike Light"
    Y recarga la página
    Entonces el ícono del carrito muestra 2 productos
    Cuando va al carrito de compras
    Entonces el carrito contiene los siguientes productos:
      | producto              | precio |
      | Sauce Labs Backpack   | $29.99 |
      | Sauce Labs Bike Light | $9.99  |

  @happy
  Escenario: El carrito de un usuario nuevo está vacío
    Cuando va al carrito de compras
    Entonces ve la página del carrito
    Y el carrito está vacío
    Y el ícono del carrito no muestra contador
