import { DataTable, Then, When } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { priceOf } from '../data/products';
import { CustomWorld } from '../support/world';

When(
  'ingresa sus datos: nombre {string}, apellido {string} y código postal {string}',
  async function (this: CustomWorld, firstName: string, lastName: string, postalCode: string) {
    await this.checkoutInfoPage.fillInformation(firstName, lastName, postalCode);
  }
);

When('continúa al resumen de la compra', async function (this: CustomWorld) {
  await this.checkoutInfoPage.continue();
});

When('finaliza la compra', async function (this: CustomWorld) {
  await this.checkoutOverviewPage.finish();
});

When('cancela el checkout desde el formulario de datos', async function (this: CustomWorld) {
  await this.checkoutInfoPage.cancel();
});

When('cancela el checkout desde el resumen', async function (this: CustomWorld) {
  await this.checkoutOverviewPage.cancel();
});

When('vuelve a la página de productos desde la confirmación', async function (this: CustomWorld) {
  await this.checkoutCompletePage.backToProducts();
});

Then('ve la página de datos de envío', async function (this: CustomWorld) {
  await expect(this.page).toHaveURL(/checkout-step-one\.html/);
  await expect(this.basePage.title).toHaveText('Checkout: Your Information');
});

Then('ve la página de resumen de la compra', async function (this: CustomWorld) {
  await expect(this.page).toHaveURL(/checkout-step-two\.html/);
  await expect(this.basePage.title).toHaveText('Checkout: Overview');
});

Then('el resumen de compra muestra los siguientes productos:', async function (this: CustomWorld, table: DataTable) {
  await expect(this.checkoutOverviewPage.itemNames).toHaveText(table.raw().flat());
});

Then('el resumen de compra muestra los productos {string}', async function (this: CustomWorld, list: string) {
  const products = list.split(',').map((p) => p.trim()).filter((p) => p.length > 0);
  await expect(this.checkoutOverviewPage.itemNames).toHaveText(products);
});

Then('el impuesto del resumen es el {int}% del subtotal', async function (this: CustomWorld, rate: number) {
  const { subtotal, tax } = await this.checkoutOverviewPage.getAmounts();
  expect(tax).toBeCloseTo(subtotal * (rate / 100), 2);
});

Then('los importes del resumen son correctos', async function (this: CustomWorld) {
  const expectedSubtotal = this.cartProducts.reduce((sum, name) => sum + priceOf(name), 0);
  const { subtotal, tax, total } = await this.checkoutOverviewPage.getAmounts();
  expect(subtotal).toBeCloseTo(expectedSubtotal, 2);
  expect(total).toBeCloseTo(subtotal + tax, 2);
});

Then(
  've la confirmación de la compra con el mensaje {string}',
  async function (this: CustomWorld, message: string) {
    await expect(this.page).toHaveURL(/checkout-complete\.html/);
    await expect(this.basePage.title).toHaveText('Checkout: Complete!');
    await expect(this.checkoutCompletePage.completeHeader).toHaveText(message);
  }
);
