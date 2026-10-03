import { After, AfterAll, Before, BeforeAll, Status, setDefaultTimeout } from '@cucumber/cucumber';
import { Browser, chromium } from '@playwright/test';
import { BASE_URL, HEADLESS } from './config';
import { CustomWorld } from './world';

setDefaultTimeout(30_000);

let browser: Browser;

BeforeAll(async function () {
  browser = await chromium.launch({ headless: HEADLESS });
});

Before(async function (this: CustomWorld) {
  this.context = await browser.newContext({
    baseURL: BASE_URL,
    viewport: { width: 1280, height: 720 }
  });
  this.page = await this.context.newPage();
  this.initPages();
});

After(async function (this: CustomWorld, scenario) {
  if (scenario.result?.status === Status.FAILED) {
    const screenshot = await this.page.screenshot({ fullPage: true });
    this.attach(screenshot, 'image/png');
  }
  await this.page.close();
  await this.context.close();
});

AfterAll(async function () {
  await browser.close();
});
