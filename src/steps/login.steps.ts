import { Given, Then, When } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { DEFAULT_PASSWORD } from '../support/config';
import { CustomWorld } from '../support/world';

Given('que el usuario está en la página de login', async function (this: CustomWorld) {
  await this.loginPage.open();
});

Given('que el usuario {string} ha iniciado sesión', async function (this: CustomWorld, username: string) {
  await this.loginPage.open();
  await this.loginPage.login(username, DEFAULT_PASSWORD);
  await expect(this.basePage.title).toHaveText('Products');
});

When(
  'inicia sesión con el usuario {string} y la contraseña {string}',
  async function (this: CustomWorld, username: string, password: string) {
    await this.loginPage.login(username, password);
  }
);

When('intenta acceder directamente a la página {string}', async function (this: CustomWorld, path: string) {
  await this.page.goto(path);
});

When('cierra sesión', async function (this: CustomWorld) {
  await this.basePage.logout();
});

Then('ve la página de productos', async function (this: CustomWorld) {
  await expect(this.page).toHaveURL(/inventory\.html/);
  await expect(this.basePage.title).toHaveText('Products');
});

Then('ve {int} productos en el catálogo', async function (this: CustomWorld, expected: number) {
  await expect(this.inventoryPage.productCards).toHaveCount(expected);
});

Then('ve la página de login', async function (this: CustomWorld) {
  await expect(this.loginPage.loginButton).toBeVisible();
  await expect(this.page).toHaveURL(/saucedemo\.com\/?$/);
});

Then('ve el mensaje de error {string}', async function (this: CustomWorld, message: string) {
  await expect(this.basePage.errorMessage).toBeVisible();
  await expect(this.basePage.errorMessage).toHaveText(message);
});

When('cierra el mensaje de error', async function (this: CustomWorld) {
  await this.basePage.closeError();
});

Then('no se muestra ningún mensaje de error', async function (this: CustomWorld) {
  await expect(this.basePage.errorMessage).toHaveCount(0);
});
