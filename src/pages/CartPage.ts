import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';

export class CartPage extends BasePage {
  constructor(page: Page) {
    super(page);
  }

  get items(): Locator {
    return this.byTest('inventory-item');
  }

  get itemNames(): Locator {
    return this.byTest('inventory-item-name');
  }

  get itemPrices(): Locator {
    return this.byTest('inventory-item-price');
  }

  get itemQuantities(): Locator {
    return this.byTest('item-quantity');
  }

  async removeItem(name: string): Promise<void> {
    await this.items
      .filter({ has: this.page.locator('[data-test="inventory-item-name"]', { hasText: name }) })
      .locator('button')
      .click();
  }

  async checkout(): Promise<void> {
    await this.byTest('checkout').click();
  }

  async continueShopping(): Promise<void> {
    await this.byTest('continue-shopping').click();
  }
}
