import { DataTable, Then, When } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { PRODUCT_PRICES, priceOf } from '../data/products';
import { CustomWorld } from '../support/world';

function parseProducts(list: string): string[] {
  return list.split(',').map((p) => p.trim()).filter((p) => p.length > 0);
}

async function addProducts(world: CustomWorld, products: string[]): Promise<void> {
  for (const product of products) {
    priceOf(product);
    await world.inventoryPage.addToCart(product);
    world.cartProducts.push(product);
  }
}

When('agrega al carrito el producto {string}', async function (this: CustomWorld, product: string) {
  await addProducts(this, [product]);
});

When('agrega al carrito los productos {string}', async function (this: CustomWorld, list: string) {
  await addProducts(this, parseProducts(list));
});

When('agrega al carrito los siguientes productos:', async function (this: CustomWorld, table: DataTable) {
  await addProducts(this, table.raw().flat());
});

When('agrega al carrito todos los productos del catálogo', async function (this: CustomWorld) {
  await addProducts(this, Object.keys(PRODUCT_PRICES));
});

When('quita de la página de productos el producto {string}', async function (this: CustomWorld, product: string) {
  await this.inventoryPage.removeFromCart(product);
  this.cartProducts = this.cartProducts.filter((p) => p !== product);
});

When('recarga la página', async function (this: CustomWorld) {
  await this.basePage.reload();
});

Then('el ícono del carrito muestra {int} producto(s)', async function (this: CustomWorld, count: number) {
  await expect(this.basePage.cartBadge).toHaveText(String(count));
});

Then('el ícono del carrito no muestra contador', async function (this: CustomWorld) {
  await expect(this.basePage.cartBadge).toHaveCount(0);
});

Then(
  'el botón del producto {string} cambia a {string}',
  async function (this: CustomWorld, product: string, label: string) {
    await expect(this.inventoryPage.actionButton(product)).toHaveText(label);
  }
);
