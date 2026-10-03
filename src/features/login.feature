# language: es
@login
Característica: Inicio de sesión en Sauce Demo
  Como cliente de Sauce Demo
  Quiero iniciar sesión
  Para poder comprar los productos que necesito

  Antecedentes:
    Dado que el usuario está en la página de login

  @happy
  Esquema del escenario: Login exitoso con el usuario <usuario>
    Cuando inicia sesión con el usuario "<usuario>" y la contraseña "secret_sauce"
    Entonces ve la página de productos
    Y ve 6 productos en el catálogo
    Y el ícono del carrito no muestra contador

    @smoke
    Ejemplos: Usuario estándar
      | usuario       |
      | standard_user |

    Ejemplos: Otros usuarios habilitados
      | usuario      |
      | problem_user |
      | visual_user  |
      | error_user   |

  @unhappy @smoke
  Escenario: Login rechazado para locked_out_user
    Cuando inicia sesión con el usuario "locked_out_user" y la contraseña "secret_sauce"
    Entonces ve el mensaje de error "Epic sadface: Sorry, this user has been locked out."
    Y ve la página de login

  @unhappy @validaciones
  Esquema del escenario: Login rechazado - <caso>
    Cuando inicia sesión con el usuario "<usuario>" y la contraseña "<password>"
    Entonces ve el mensaje de error "<mensaje>"
    Y ve la página de login

    Ejemplos:
      | caso                                        | usuario         | password     | mensaje                                                                   |
      | usuario y contraseña vacíos                 |                 |              | Epic sadface: Username is required                                        |
      | usuario vacío y contraseña válida           |                 | secret_sauce | Epic sadface: Username is required                                        |
      | usuario vacío y contraseña inválida         |                 | incorrecta   | Epic sadface: Username is required                                        |
      | usuario válido y contraseña vacía           | standard_user   |              | Epic sadface: Password is required                                        |
      | usuario inexistente y contraseña vacía      | usuario_falso   |              | Epic sadface: Password is required                                        |
      | usuario válido y contraseña incorrecta      | standard_user   | incorrecta   | Epic sadface: Username and password do not match any user in this service |
      | usuario inexistente y contraseña válida     | usuario_falso   | secret_sauce | Epic sadface: Username and password do not match any user in this service |
      | usuario inexistente y contraseña inválida   | usuario_falso   | incorrecta   | Epic sadface: Username and password do not match any user in this service |
      | usuario bloqueado y contraseña incorrecta   | locked_out_user | incorrecta   | Epic sadface: Username and password do not match any user in this service |

  @unhappy @validaciones
  Esquema del escenario: Las credenciales distinguen mayúsculas y minúsculas - <caso>
    Cuando inicia sesión con el usuario "<usuario>" y la contraseña "<password>"
    Entonces ve el mensaje de error "Epic sadface: Username and password do not match any user in this service"
    Y ve la página de login

    Ejemplos:
      | caso                     | usuario       | password     |
      | usuario con mayúsculas   | STANDARD_USER | secret_sauce |
      | usuario capitalizado     | Standard_User | secret_sauce |
      | contraseña en mayúsculas | standard_user | SECRET_SAUCE |

  @unhappy
  Escenario: El mensaje de error se puede cerrar
    Cuando inicia sesión con el usuario "" y la contraseña ""
    Y cierra el mensaje de error
    Entonces no se muestra ningún mensaje de error
    Y ve la página de login

  @unhappy @sesion
  Esquema del escenario: No se puede acceder a <pagina> sin iniciar sesión
    Cuando intenta acceder directamente a la página "<pagina>"
    Entonces ve el mensaje de error "Epic sadface: You can only access '<pagina>' when you are logged in."
    Y ve la página de login

    Ejemplos:
      | pagina                  |
      | /inventory.html         |
      | /cart.html              |
      | /checkout-step-one.html |
      | /checkout-step-two.html |
      | /checkout-complete.html |

  @happy @sesion
  Escenario: El usuario puede cerrar sesión
    Cuando inicia sesión con el usuario "standard_user" y la contraseña "secret_sauce"
    Y cierra sesión
    Entonces ve la página de login

  @unhappy @sesion
  Escenario: Después de cerrar sesión no se puede volver a la página de productos
    Cuando inicia sesión con el usuario "standard_user" y la contraseña "secret_sauce"
    Y cierra sesión
    Y intenta acceder directamente a la página "/inventory.html"
    Entonces ve el mensaje de error "Epic sadface: You can only access '/inventory.html' when you are logged in."
    Y ve la página de login
