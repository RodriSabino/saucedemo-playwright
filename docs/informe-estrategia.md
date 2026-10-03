# Informe de estrategia de automatización (FrontEnd)

## 1. Objetivo y alcance
Validar el flujo de compra de Sauce Demo (https://www.saucedemo.com) a nivel de interfaz: inicio de sesión, carrito y checkout hasta la confirmación, con escenarios legibles para negocio y código mantenible.

| Funcionalidad | Feature | Escenarios |
|---|---|---|
| Inicio de sesión | `login.feature` | 25 |
| Carrito de compras | `carrito.feature` | 17 |
| Proceso de compra | `checkout.feature` | 18 |
| **Total** | | **60** |

Fuera de alcance: ordenamiento de productos, página de detalle de producto, comportamiento visual de `problem_user` y `visual_user`, rendimiento de `performance_glitch_user` y pruebas en varios navegadores.

## 2. Trazabilidad con los criterios de aceptación
| Criterio de aceptación | Cobertura |
|---|---|
| El usuario puede iniciar sesión con credenciales válidas | Login con `standard_user` y otros usuarios habilitados, cierre de sesión |
| El usuario no puede iniciar sesión con credenciales inválidas | `locked_out_user`, tabla de decisión usuario × contraseña, mayúsculas y minúsculas, páginas protegidas sin sesión |
| El usuario puede agregar un producto al carrito desde la página de productos | Contador del carrito, cambio del botón Add/Remove, agregar uno, varios o todos los productos |
| El usuario puede ver los productos agregados en el carrito | Nombre, precio y cantidad de cada producto, quitar productos, persistencia del carrito |
| El usuario puede completar el proceso de compra hasta la confirmación | Compra de punta a punta con validación de importes, formulario de envío, cancelaciones y estado final |

## 3. Técnicas de prueba aplicadas

### 3.1 Partición de equivalencia
| Entrada | Clases válidas | Clases inválidas |
|---|---|---|
| Usuario | `standard_user`, `problem_user`, `visual_user`, `error_user` | Vacío, inexistente, bloqueado (`locked_out_user`), con mayúsculas distintas |
| Contraseña | `secret_sauce` | Vacía, incorrecta, en mayúsculas |
| Datos de envío | Nombre, apellido y código postal completos | Cualquier campo vacío |
| Productos del carrito | Cada uno de los 6 productos del catálogo | No aplica |

### 3.2 Análisis de valores límite
- **Cantidad de productos en el carrito**: 0 (carrito vacío), 1, 3 y 6 (todo el catálogo, el máximo posible).
- **Precio**: compra del producto más barato ($7.99) y del más caro ($49.99).
- **Longitud de los datos de envío**: un carácter por campo (`A`, `B`, `1`) frente al campo vacío, que se rechaza.

### 3.3 Tabla de decisión
**Login (usuario × contraseña):** la aplicación valida en orden, primero que el usuario no esté vacío, luego la contraseña y por último las credenciales.

| Usuario | Contraseña | Resultado |
|---|---|---|
| Vacío | Cualquiera | `Username is required` |
| No vacío | Vacía | `Password is required` |
| Válido | Válida | Ingresa a productos |
| Bloqueado | Válida | `Sorry, this user has been locked out.` |
| Cualquier otra combinación | | `Username and password do not match any user in this service` |

**Formulario de envío (nombre × apellido × código postal):** se probaron las 7 combinaciones con al menos un campo vacío, más la combinación válida. El mensaje corresponde siempre al primer campo vacío en orden.

### 3.4 Transición de estados
Se validaron los estados del producto y del carrito a lo largo del flujo:

```
Producto:  "Add to cart" --agregar--> "Remove" --quitar--> "Add to cart"

Compra:    productos -> carrito -> datos de envío -> resumen -> confirmación -> productos (carrito vacío)
                          ^             |               |
                          +--cancelar---+               +--cancelar--> productos (carrito conservado)

Sesión:    login -> productos -> cerrar sesión -> login (sin acceso a páginas protegidas)
```

También se verificó que el carrito conserve su estado al continuar comprando y al recargar la página.

### 3.5 Pruebas basadas en datos (data-driven)
`Esquema del escenario` con `Ejemplos` para usuarios, combinaciones de credenciales, páginas protegidas, cantidades de productos, catálogo completo de productos con sus precios, compras con distintos conjuntos de productos y datos del formulario de envío.

### 3.6 Pruebas positivas y negativas
Cada escenario está etiquetado como `@happy` (flujo esperado) o `@unhappy` (errores y casos borde), lo que permite ejecutar cada grupo por separado (`npm run test:happy` y `npm run test:unhappy`).

### 3.7 Pruebas de punta a punta (E2E)
Los escenarios `@e2e` recorren el flujo completo desde el login hasta la confirmación y comprueban el estado final: el carrito queda vacío y el usuario puede volver a la tienda.

### 3.8 Validación de cálculos
El resumen de compra se valida contra un catálogo de precios independiente (`data/products.ts`):
- el subtotal es la suma de los precios de los productos agregados;
- el impuesto es el 8% del subtotal;
- el total es el subtotal más el impuesto.

### 3.9 Adivinación de errores (error guessing)
Casos derivados de fallas comunes en interfaces web: credenciales con mayúsculas distintas, usuario bloqueado con contraseña incorrecta, acceso directo por URL a páginas protegidas, acceso después de cerrar sesión y cierre del mensaje de error.

## 4. Arquitectura y patrones de diseño
| Capa | Carpeta | Patrón | Responsabilidad |
|---|---|---|---|
| Escenarios | `src/features/` | BDD con Gherkin en español | Describir el comportamiento en lenguaje de negocio |
| Pasos | `src/steps/` | Step definitions por dominio | Traducir cada paso a acciones y validaciones |
| Páginas | `src/pages/` | Page Object Model con herencia (`BasePage`) | Encapsular localizadores y acciones de cada página |
| Contexto | `src/support/world.ts` | World de Cucumber | Estado y Page Objects aislados por escenario |
| Ciclo de vida | `src/support/hooks.ts` | Hooks | Navegador por ejecución, contexto limpio por escenario y captura de pantalla en fallos |
| Datos | `src/data/`, `src/support/config.ts` | Datos externalizados | Catálogo de precios, URL base y credenciales configurables por variables de entorno |

Los selectores usan el atributo `data-test` que expone la aplicación, en lugar de clases CSS o XPath, para que los tests no se rompan con cambios visuales.

## 5. Ejecución y reportes
- `npm test` ejecuta la suite completa en modo headless; `npm run test:headed` muestra el navegador.
- Al terminar se generan `reports/cucumber-report.html` (con capturas de los escenarios fallidos) y `reports/cucumber-report.json`.

## 6. Mejoras futuras
- Ejecución en paralelo y en varios navegadores (Firefox y WebKit).
- Integración continua (GitHub Actions) con publicación del reporte.
- Escenarios para `problem_user` y `performance_glitch_user`, ordenamiento de productos y detalle de producto.
- Pruebas de accesibilidad y de regresión visual.
