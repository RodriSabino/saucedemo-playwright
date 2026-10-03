import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';

export class CheckoutCompletePage extends BasePage {
  constructor(page: Page) {
    super(page);
  }

  get completeHeader(): Locator {
    return this.byTest('complete-header');
  }

  get completeText(): Locator {
    return this.byTest('complete-text');
  }

  async backToProducts(): Promise<void> {
    await this.byTest('back-to-products').click();
  }
}
