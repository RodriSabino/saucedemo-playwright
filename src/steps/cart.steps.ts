import { DataTable, Then, When } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

When('va al carrito de compras', async function (this: CustomWorld) {
  await this.basePage.goToCart();
});

When('quita del carrito el producto {string}', async function (this: CustomWorld, product: string) {
  await this.cartPage.removeItem(product);
  this.cartProducts = this.cartProducts.filter((p) => p !== product);
});

When('quita del carrito todos los productos', async function (this: CustomWorld) {
  for (const product of [...this.cartProducts]) {
    await this.cartPage.removeItem(product);
  }
  this.cartProducts = [];
});

When('continúa comprando', async function (this: CustomWorld) {
  await this.cartPage.continueShopping();
});

When('inicia el checkout', async function (this: CustomWorld) {
  await this.cartPage.checkout();
});

Then('ve la página del carrito', async function (this: CustomWorld) {
  await expect(this.page).toHaveURL(/cart\.html/);
  await expect(this.basePage.title).toHaveText('Your Cart');
});

Then('el carrito contiene los siguientes productos:', async function (this: CustomWorld, table: DataTable) {
  const rows = table.hashes();
  await expect(this.cartPage.itemNames).toHaveText(rows.map((r) => r.producto));
  await expect(this.cartPage.itemPrices).toHaveText(rows.map((r) => r.precio));
});

Then('el carrito contiene {int} producto(s)', async function (this: CustomWorld, count: number) {
  await expect(this.cartPage.items).toHaveCount(count);
});

Then('cada producto del carrito tiene cantidad {int}', async function (this: CustomWorld, quantity: number) {
  const count = await this.cartPage.items.count();
  await expect(this.cartPage.itemQuantities).toHaveText(Array(count).fill(String(quantity)));
});

Then('el carrito está vacío', async function (this: CustomWorld) {
  await expect(this.cartPage.items).toHaveCount(0);
});
