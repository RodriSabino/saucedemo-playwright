import { Locator, Page } from '@playwright/test';

export class BasePage {
  constructor(protected readonly page: Page) {}

  protected byTest(id: string): Locator {
    return this.page.locator(`[data-test="${id}"]`);
  }

  get title(): Locator {
    return this.byTest('title');
  }

  get cartLink(): Locator {
    return this.byTest('shopping-cart-link');
  }

  get cartBadge(): Locator {
    return this.byTest('shopping-cart-badge');
  }

  get errorMessage(): Locator {
    return this.byTest('error');
  }

  get errorCloseButton(): Locator {
    return this.byTest('error-button');
  }

  async closeError(): Promise<void> {
    await this.errorCloseButton.click();
  }

  async reload(): Promise<void> {
    await this.page.reload();
  }

  async goToCart(): Promise<void> {
    await this.cartLink.click();
  }

  async logout(): Promise<void> {
    await this.page.locator('#react-burger-menu-btn').click();
    await this.byTest('logout-sidebar-link').click();
  }
}
