import { test, expect } from '@playwright/test';

// Dynamicly set the URL from pipeline output
test.beforeEach(async ({ page }) => {
  const url = process.env.website_URL || 'https://app-okhgzqoexg6jy.azurewebsites.net/';
  await page.goto(url , { waitUntil: 'load', timeout: 6000 });
});

test("Should be flaky for exercises page", async ({ page }) => {
  if (Math.random() > 0.5) {
    await page.getByRole('link', { name: 'Exercises', exact: true }).click();
    await expect(page).toHaveTitle('Exercises - Mercury Health');
  } else {
    await page.getByRole('link', { name: 'Exercises', exact: true }).click();
    await expect(page).not.toHaveTitle('Exercises - Mercury Health');
  }
});

test('Navigate to exercises page', async ({ page }) => {
  //await page.getByRole('link', { name: 'Exercises', exact: true }).click();
  await page.locator('#menu_exercises').click();
  await expect(page).toHaveTitle('Exercises - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Exercisespage.png', fullPage: true, timeout: 6000 });
});

test('Navigate to exercises page and click on details', async ({ page }) => {

  const acceptPolicyButton = await page.$('#accept-policy close');
  if (acceptPolicyButton !== null) {
    await acceptPolicyButton.click();
  }

  const myPageTitle = await page.title();
  expect(myPageTitle).toBe('Home Page - Mercury Health');

  await page.getByRole('link', { name: 'Exercises', exact: true }).click();
  await expect(page).toHaveTitle('Exercises - Mercury Health');

  await page.click('#button_details_25');
  const detailsPageTitle = await page.title();
  expect(detailsPageTitle).toBe('Details - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_exercise_details_25-1.png', fullPage: true, timeout: 6000 });

});

test('Navigate to exercises page and update value', async ({ page }) => {

  const acceptPolicyButton = await page.$('#accept-policy close');
  if (acceptPolicyButton !== null) {
    await acceptPolicyButton.click();
  }

  const myPageTitle = await page.title();
  expect(myPageTitle).toBe('Home Page - Mercury Health');

  await page.getByRole('link', { name: 'Exercises', exact: true }).click();
  await expect(page).toHaveTitle('Exercises - Mercury Health');

  // ///////////////////////////////////////////////
  // Update the Value to something else
  // ///////////////////////////////////////////////
  await page.click('#button_edit_25');
  const detailsPageTitle = await page.title();
  expect(detailsPageTitle).toBe('Edit - Mercury Health');

  await page.getByLabel('Equipment').click();
  await page.getByLabel('Equipment').fill('Update by Playwright');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_exercise_details_25-2.png', fullPage: true, timeout: 6000 });

  await page.getByRole('button', { name: 'Save' }).click();

  // ///////////////////////////////////////////////
  // Verify the updated value
  // ///////////////////////////////////////////////
  await page.click('#button_details_25');

  // Find the <dd> element by its ID
  const element = await page.$('#Value_Equipment');
  const value = await element?.textContent();

  // Take screenshot
  await page.screenshot({ path: 'screenshot_exercise_details_25-3.png', fullPage: true, timeout: 6000 });

  // Assert that the value is correct
  expect(value?.trim()).toBe('Update by Playwright');

  await page.click('#button_back');

  // ///////////////////////////////////////////////
  // Update the Value back to original
  // ///////////////////////////////////////////////
  await page.click('#button_edit_25');

  await page.getByLabel('Equipment').click();
  await page.getByLabel('Equipment').fill('API Update');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_exercise_details_25-4.png', fullPage: true, timeout: 6000 });

  await page.getByRole('button', { name: 'Save' }).click();

});

test('Navigate to exercises page and verify details', async ({ page }) => {

  const acceptPolicyButton = await page.$('#accept-policy close');
  if (acceptPolicyButton !== null) {
    await acceptPolicyButton.click();
  }

  const myPageTitle = await page.title();
  expect(myPageTitle).toBe('Home Page - Mercury Health');

  await page.getByRole('link', { name: 'Exercises', exact: true }).click();
  await expect(page).toHaveTitle('Exercises - Mercury Health');

  await page.click('#button_details_25');
  const detailsPageTitle = await page.title();
  expect(detailsPageTitle).toBe('Details - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_exercise_details_25-3.png', fullPage: true, timeout: 6000 });

  // Find the <dd> element by its ID
  const element = await page.$('#Value_Equipment');
  const value = await element?.textContent();

  // Assert that the value is correct
  expect(value?.trim()).toBe('Update by Randy');

  await page.click('#button_back');

});
