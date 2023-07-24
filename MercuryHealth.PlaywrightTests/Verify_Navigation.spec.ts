import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto('https://app-x7vgm47suuyt2.azurewebsites.net/' , { waitUntil: 'load', timeout: 100000 });
});

test('should allow me to navigate to home page', async ({ page }) => {
    await expect(page).toHaveTitle('Home Page - Mercury Health');
  
    // Take screenshot
    await page.screenshot({ path: 'screenshot_Home-Homepage.png', fullPage: true, timeout: 60000 });

});

test('should allow me to navigate to nutritions page', async ({ page }) => {
  
  await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
  await expect(page).toHaveTitle('Nutrition - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Nutritionspage.png', fullPage: true, timeout: 60000 });

});

test('should allow me to navigate to exercises page', async ({ page }) => {
  await page.getByRole('link', { name: 'Exercises', exact: true }).click();
  await expect(page).toHaveTitle('Exercises - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Exercisespage.png', fullPage: true, timeout: 60000 });

});

test('should allow me to navigate to privacy page', async ({ page }) => {
  //await page.getByRole('link', { name: 'Privacy', exact: true }).click();
  await page.locator('#menu_privacy').click();
  await expect(page).toHaveTitle('Privacy Policy - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Privacypage.png', fullPage: true, timeout: 60000 });

});

test('should allow me to navigate to metrics page', async ({ page }) => {
  await page.getByRole('link', { name: 'Metrics', exact: true }).click();
  await expect(page).toHaveTitle('Metrics - Mercury Health', { timeout: 60000 });

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Metricspage.png', fullPage: true, timeout: 60000 });

});
