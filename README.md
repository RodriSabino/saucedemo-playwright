# Sauce Demo - Automatización E2E (Playwright + Cucumber + POM)

Suite de pruebas automatizadas para [Sauce Demo](https://www.saucedemo.com/) con **Playwright**, **Cucumber (Gherkin en español)** y **Page Object Model**, escrita en TypeScript.

## Requisitos
- Node.js 18 o superior (`node -v`)
- npm 9 o superior

## Instalación
```bash
npm install
npm run install:browsers   # descarga Chromium para Playwright
```

## Ejecución
```bash
npm test                 # suite completa (headless)
npm run test:smoke       # solo escenarios @smoke
npm run test:login       # feature de login
npm run test:carrito     # feature de carrito
npm run test:checkout    # feature de compra
npm run test:negativo    # solo escenarios negativos
npm run test:headed      # suite completa con el navegador visible
```
Filtrar por cualquier tag: `npx cucumber-js --tags "@positivo and @carrito"`

Variables de entorno opcionales: `HEADLESS=false`, `BASE_URL`, `SAUCE_PASSWORD`.

## Reportes
Al terminar se generan en `reports/`:
- `cucumber-report.html`: reporte HTML (incluye captura de pantalla de los escenarios fallidos)
- `cucumber-report.json`: resultado en JSON para integraciones de CI

## Estructura
```
src/
  features/            # escenarios en Gherkin (español)
    login.feature
    carrito.feature
    checkout.feature
  steps/               # step definitions, agrupados por dominio
  pages/               # Page Objects (BasePage + una clase por página)
  support/
    world.ts           # contexto por escenario (page, page objects, estado)
    hooks.ts           # ciclo de vida del navegador y capturas en fallos
    config.ts          # URL base, modo headless, contraseña
  data/
    products.ts        # catálogo nombre -> precio para validar importes
docs/informe-estrategia.md
cucumber.js            # configuración de Cucumber
```

## Cobertura (criterios de aceptación)
| Criterio | Escenarios |
|---|---|
| Login con credenciales válidas | Login exitoso con `standard_user`, cerrar sesión |
| Login con credenciales inválidas | `locked_out_user`, usuario/contraseña incorrectos, campos vacíos, acceso directo sin sesión |
| Agregar producto desde la página de productos | Uno y varios productos, contador del carrito, botón Add/Remove |
| Ver productos en el carrito | Nombre y precio de cada producto (Esquema con Ejemplos), quitar productos, carrito vacío |
| Completar la compra hasta la confirmación | Compra E2E de uno y varios productos con validación de importes, validaciones del formulario, cancelaciones |

## Tags
`@login`, `@carrito`, `@checkout` (por funcionalidad) · `@smoke`, `@e2e` (prioridad) · `@positivo`, `@negativo` (tipo de caso)
