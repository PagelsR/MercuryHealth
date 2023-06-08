import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('https://app-x7vgm47suuyt2.azurewebsites.net/');
  await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
  await page.locator('#menu_privacy').click();
  await page.getByRole('link', { name: 'Metrics' }).click();
});