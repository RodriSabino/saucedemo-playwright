import { Page } from '@playwright/test';
import { BasePage } from './BasePage';

export class CheckoutInfoPage extends BasePage {
  constructor(page: Page) {
    super(page);
  }

  async fillInformation(firstName: string, lastName: string, postalCode: string): Promise<void> {
    await this.byTest('firstName').fill(firstName);
    await this.byTest('lastName').fill(lastName);
    await this.byTest('postalCode').fill(postalCode);
  }

  async continue(): Promise<void> {
    await this.byTest('continue').click();
  }

  async cancel(): Promise<void> {
    await this.byTest('cancel').click();
  }
}
