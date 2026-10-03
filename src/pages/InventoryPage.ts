import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';

export class InventoryPage extends BasePage {
  constructor(page: Page) {
    super(page);
  }

  get productCards(): Locator {
    return this.byTest('inventory-item');
  }

  productCard(name: string): Locator {
    return this.productCards.filter({
      has: this.page.locator('[data-test="inventory-item-name"]', { hasText: name })
    });
  }

  actionButton(name: string): Locator {
    return this.productCard(name).locator('button');
  }

  async addToCart(name: string): Promise<void> {
    await this.actionButton(name).click();
  }

  async removeFromCart(name: string): Promise<void> {
    await this.actionButton(name).click();
  }
}
