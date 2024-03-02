import { test, expect } from '@playwright/test';

// Dynamicly set the URL from pipeline output
test.beforeEach(async ({ page }) => {
  const url = process.env.website_URL || 'https://app-okhgzqoexg6jy.azurewebsites.net/';
  await page.goto(url , { waitUntil: 'load', timeout: 20000 });
});

test('Create a nutrition record from home page', async ({ page }) => {
  await page.getByRole('link', { name: 'Create Nutrition' }).click();
  await page.getByLabel('Description').click();
  await page.getByLabel('Description').fill('Create New Record');
  await page.getByLabel('Quantity').click();
  await page.getByLabel('Quantity').fill('1');
  await page.getByLabel('Meal Time').click();
  await page.getByLabel('Meal Time').fill('2023-11-24T00:12');
  await page.getByLabel('Tags').click();
  await page.getByLabel('Tags').fill('New Record');
  await page.getByLabel('Calories').click();
  await page.getByLabel('Calories').fill('1');
  await page.getByLabel('Protein/g').click();
  await page.getByLabel('Protein/g').fill('1');
  await page.getByLabel('Fat/g').click();
  await page.getByLabel('Fat/g').fill('1');
  await page.getByLabel('Carbohydrates/g').click();
  await page.getByLabel('Carbohydrates/g').fill('1');
  await page.getByLabel('Sodium/g').click();
  await page.getByLabel('Sodium/g').fill('1');
  await page.getByLabel('Color').click();
  await page.getByLabel('Color').fill('Blue');
  await page.getByRole('button', { name: 'Create' }).click();

});

test('Delete a nutrition record from home page', async ({ page }) => {
  await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
  await expect(page).toHaveTitle('Nutrition - Mercury Health');

  // Find the last delete button and click it
  // 1st, get all delete buttons
  const deleteButtons = await page.$$('text=Delete');

  // 2nd, click the last delete button
  await deleteButtons[deleteButtons.length - 1].click();
  
  const detailsPageTitle = await page.title();
  expect(detailsPageTitle).toBe('Delete - Mercury Health');
  await page.getByRole('button', { name: 'Delete' }).click();
  await page.getByRole('link', { name: 'Home', exact: true }).click();

});