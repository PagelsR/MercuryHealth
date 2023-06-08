import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('https://app-x7vgm47suuyt2.azurewebsites.net/');
  await expect(page).toHaveTitle('Home Page - Mercury Health');

  await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
  await page.getByRole('row', { name: 'Apple 1 3/22/2022 12:00:00 AM fruit, snack 116 0.60 0.40 38.80 2.00 Edit | Details | Delete' }).getByRole('link', { name: 'Details' }).click();
  await page.getByText('116').click();
  await page.getByRole('link', { name: 'Back to List' }).click();
});