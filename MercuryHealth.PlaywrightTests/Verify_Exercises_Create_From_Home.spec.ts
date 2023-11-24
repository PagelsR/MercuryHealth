import { test, expect } from '@playwright/test';

// Dynamicly set the URL from pipeline output
test.beforeEach(async ({ page }) => {
  const url = process.env.website_URL || 'https://app-okhgzqoexg6jy.azurewebsites.net/';
  await page.goto(url , { waitUntil: 'load', timeout: 15000 });
});

test('Create an exercise record from home page', async ({ page }) => {
  await page.getByRole('link', { name: 'Create Exercise' }).click();
  await page.getByLabel('Name').click();
  await page.getByLabel('Name').fill('Create New Record');
  await page.getByLabel('Description').click();
  await page.getByLabel('Description').fill('Create New Record');
  await page.getByLabel('Exercise Time').click();
  await page.getByLabel('Exercise Time').fill('2023-11-24T00:12');
  await page.getByLabel('Muscles').click();
  await page.getByLabel('Muscles').fill('NA');
  await page.getByLabel('Equipment').click();
  await page.getByLabel('Equipment').fill('NA');
  await page.getByRole('button', { name: 'Create' }).click();

});

test('Delete an exercise record from home page', async ({ page }) => {
  await page.getByRole('link', { name: 'Exercises', exact: true }).click();
  await expect(page).toHaveTitle('Exercises - Mercury Health');

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