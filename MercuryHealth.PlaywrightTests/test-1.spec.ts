import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('https://app-x7vgm47suuyt2.azurewebsites.net/');
  await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
  await page.click('#button_details_25');
  //await page.getByRole('row', { name: 'Banana 1 7/22/2023 1:58:00 PM API Update 110 1.30 0.40 0.00 1.20 Edit | Details | Delete' }).getByRole('link', { name: 'Edit' }).click();
  await page.getByLabel('Calories').click();

  await page.locator('div').filter({ hasText: 'Description Quantity Meal Time Tags Calories Protein/g Fat/g Carbohydrates/g Sod' }).nth(1).click();
  await page.getByLabel('Calories').click();
  await page.getByRole('link', { name: 'Back to List' }).click();
  await page.getByRole('row', { name: 'Banana 1 7/22/2023 1:59:00 PM API Update 110 1.30 0.40 0.00 1.20 Edit | Details | Delete' }).getByRole('link', { name: 'Details' }).click();
  await page.getByText('110').click();
});