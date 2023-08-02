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

test('Allow me to navigate to exercises page and click on details', async ({ page }) => {

  const acceptPolicyButton = await page.$('#accept-policy close');
  if (acceptPolicyButton !== null) {
    await acceptPolicyButton.click();
  }

  const myPageTitle = await page.title();
  expect(myPageTitle).toBe('Home Page - Mercury Health');

  await page.getByRole('link', { name: 'Exercises', exact: true }).click();
  await expect(page).toHaveTitle('Exercises - Mercury Health');

  // await page.click('#menu_exercises');
  // const nutritionPageTitle = await page.title();
  // expect(nutritionPageTitle).toBe('Exercises - Mercury Health');

  await page.click('#button_details_25');
  const detailsPageTitle = await page.title();
  expect(detailsPageTitle).toBe('Details - Mercury Health');

  await page.screenshot({
    path: 'screenshot_exercise_details_25.png', fullPage: true, timeout: 60000 });
    fullPage: true

});

test('Allow me to navigate to exercises page and click on edit', async ({ page }) => {

  const acceptPolicyButton = await page.$('#accept-policy close');
  if (acceptPolicyButton !== null) {
    await acceptPolicyButton.click();
  }

  const myPageTitle = await page.title();
  expect(myPageTitle).toBe('Home Page - Mercury Health');

  await page.getByRole('link', { name: 'Exercises', exact: true }).click();
  await expect(page).toHaveTitle('Exercises - Mercury Health');

  await page.click('#button_edit_22');
  const detailsPageTitle = await page.title();
  expect(detailsPageTitle).toBe('Edit - Mercury Health');

  await page.getByLabel('Equipment').click();
  await page.getByLabel('Equipment').fill('Playwright Update');

  await page.screenshot({
    path: 'screenshot_exercise_details_22.png', fullPage: true, timeout: 60000 });
    fullPage: true

  await page.getByRole('button', { name: 'Save' }).click();

});

