import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto('https://app-okhgzqoexg6jy.azurewebsites.net/' , { waitUntil: 'load', timeout: 100000 });
});

test('should allow me to navigate to exercises page', async ({ page }) => {
  await page.getByRole('link', { name: 'Exercises', exact: true }).click();
  await expect(page).toHaveTitle('Exercises - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Exercisespage.png', fullPage: true, timeout: 60000 });
});

test('should allow me to navigate to exercises page and click on the first exercise', async ({ page }) => {

});

test('should allow me to navigate to exercises page and click on the first exercise', async ({ page }) => {

});
