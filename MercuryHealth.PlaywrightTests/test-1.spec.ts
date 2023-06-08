import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto('https://app-x7vgm47suuyt2.azurewebsites.net/');
});

test('test', async ({ page }) => {
  await page.goto('https://app-x7vgm47suuyt2.azurewebsites.net/');
});