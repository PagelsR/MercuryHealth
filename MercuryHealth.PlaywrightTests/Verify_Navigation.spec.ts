import { test, expect } from '@playwright/test';

// test.beforeEach(async ({ page }) => {
//   await page.goto('https://app-okhgzqoexg6jy.azurewebsites.net/' , { waitUntil: 'load', timeout: 100000 });
// });

// Dynamicly set the URL from pipeline output
test.beforeEach(async ({ page }) => {
  const url = process.env.website_URL || 'https://app-okhgzqoexg6jy.azurewebsites.net/';
  await page.goto(url , { waitUntil: 'load', timeout: 7000 });
});

test('Allow me to navigate to default page', async ({ page }) => {
    await expect(page).toHaveTitle('Home Page - Mercury Health');
  
    // Take screenshot
    await page.screenshot({ path: 'screenshot_Home-Defaultpage.png', fullPage: true, timeout: 6000 });

});

test('Allow me to navigate to home page', async ({ page }) => {
  await page.locator('#menu_home').click();
  await expect(page).toHaveTitle('Home Page - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Homepage.png', fullPage: true, timeout: 6000 });

});

test('Allow me to navigate to nutritions home page', async ({ page }) => {
  //await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
  await page.locator('#menu_nutrition').click();
  await expect(page).toHaveTitle('Nutrition - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Nutritionspage.png', fullPage: true, timeout: 6000 });

});

test('Allow me to navigate to exercises home page', async ({ page }) => {
  //await page.getByRole('link', { name: 'Exercises', exact: true }).click();
  await page.locator('#menu_exercises').click();
  await expect(page).toHaveTitle('Exercises - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Exercisespage.png', fullPage: true, timeout: 6000 });

});

test('Allow me to navigate to privacy home page', async ({ page }) => {
  //await page.getByRole('link', { name: 'Privacy', exact: true }).click();
  await page.locator('#menu_privacy').click();
  await expect(page).toHaveTitle('Privacy Policy - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Privacypage.png', fullPage: true, timeout: 6000 });

});

test('Allow me to navigate to metrics home page', async ({ page }) => {
  //await page.getByRole('link', { name: 'Metrics', exact: true }).click();
  await page.locator('#menu_metrics').click();
  await expect(page).toHaveTitle('Metrics - Mercury Health', { timeout: 3000 });

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Metricspage.png', fullPage: true, timeout: 6000 });

});
