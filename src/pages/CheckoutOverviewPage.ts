import { Locator, Page } from '@playwright/test';
import { BasePage } from './BasePage';

export interface OrderAmounts {
  subtotal: number;
  tax: number;
  total: number;
}

export class CheckoutOverviewPage extends BasePage {
  constructor(page: Page) {
    super(page);
  }

  get itemNames(): Locator {
    return this.byTest('inventory-item-name');
  }

  private async amountOf(testId: string): Promise<number> {
    const label = this.byTest(testId);
    await label.waitFor();
    const text = (await label.textContent()) ?? '';
    const match = text.match(/(\d+(?:\.\d+)?)/);
    if (!match) {
      throw new Error(`No se pudo leer un importe en "${text}" (${testId})`);
    }
    return parseFloat(match[1]);
  }

  async getAmounts(): Promise<OrderAmounts> {
    return {
      subtotal: await this.amountOf('subtotal-label'),
      tax: await this.amountOf('tax-label'),
      total: await this.amountOf('total-label')
    };
  }

  async finish(): Promise<void> {
    await this.byTest('finish').click();
  }

  async cancel(): Promise<void> {
    await this.byTest('cancel').click();
  }
}
