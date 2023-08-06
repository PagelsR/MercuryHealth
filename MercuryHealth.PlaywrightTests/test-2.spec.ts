import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('https://app-okhgzqoexg6jy.azurewebsites.net/');
  await page.getByRole('link', { name: 'Exercises' }).click();


  await page.click('#button_details_25');
  
  // Find the <dd> element by its ID
  const element = await page.$('#Value_Equipment');
  const value = await element?.textContent();
  // Assert that the value is correct
  expect(value?.trim()).toBe('API Update');


});