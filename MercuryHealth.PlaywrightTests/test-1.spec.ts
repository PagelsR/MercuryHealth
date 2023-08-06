import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('https://app-okhgzqoexg6jy.azurewebsites.net/');
  await page.getByRole('link', { name: 'Exercises' }).click();
  await page.getByRole('row', { name: 'Leg Raises Another exercise that just about anyone can do is the leg raise. 8/6/2023 5:15:00 PM Legs API Update Edit | Details | Delete' }).getByRole('link', { name: 'Edit' }).click();
  await page.getByLabel('Equipment').click();
  await page.getByText('Mercury Health Home Nutrition Exercises Privacy Metrics Edit Exercises Name Desc').click();
  await page.getByLabel('Equipment').click({
    clickCount: 4
  });
  await page.getByLabel('Equipment').fill('Playwright Update');
  await page.getByLabel('Equipment').press('Tab');
  await page.getByRole('button', { name: 'Save' }).click();
  await page.getByRole('row', { name: 'Leg Raises Another exercise that just about anyone can do is the leg raise. 8/6/2023 5:15:00 PM Legs Playwright Update Edit | Details | Delete' }).getByRole('link', { name: 'Details' }).click();
  await page.getByRole('link', { name: 'Nutrition' }).click();
  await page.getByRole('row', { name: 'Banana 1 8/6/2023 5:15:00 PM API Update 110 1.30 0.40 0.00 1.20 Edit | Details | Delete' }).getByRole('link', { name: 'Details' }).click();
  await page.getByText('Banana').click();
});