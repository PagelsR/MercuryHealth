import { test, expect } from '@playwright/test';

// test.beforeEach(async ({ page }) => {
//   await page.goto('https://app-okhgzqoexg6jy.azurewebsites.net/' , { waitUntil: 'load', timeout: 100000 });
// });

// Dynamicly set the URL from pipeline output
test.beforeEach(async ({ page }) => {
  const url = process.env.website_URL || 'https://app-okhgzqoexg6jy.azurewebsites.net/';
  await page.goto(url , { waitUntil: 'load', timeout: 7000 });
});

test("Should be flaky for nutritions page", async ({ page }) => {
  if (Math.random() > 0.5) {
    await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
    await expect(page).toHaveTitle('Nutrition - Mercury Health');
  } else {
    await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
    await expect(page).not.toHaveTitle('Nutrition - Mercury Health');
  }
});

test('Navigate to nutritions page', async ({ page }) => {
  //await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
  await page.locator('#menu_nutrition').click();
  await expect(page).toHaveTitle('Nutrition - Mercury Health');

  // Take screenshot
  //await page.screenshot({ path: 'screenshot_Home-Nutritionspage.png', fullPage: true, timeout: 6000 });

});

test('Navigate to nutritions page and click on details', async ({ page }) => {

  const acceptPolicyButton = await page.$('#accept-policy close');
  if (acceptPolicyButton !== null) {
    await acceptPolicyButton.click();
  }

  const myPageTitle = await page.title();
  expect(myPageTitle).toBe('Home Page - Mercury Health');

  await page.click('#menu_nutrition');
  const nutritionPageTitle = await page.title();
  expect(nutritionPageTitle).toBe('Nutrition - Mercury Health');

  await page.click('#button_details_25');
  const detailsPageTitle = await page.title();
  expect(detailsPageTitle).toBe('Details - Mercury Health');

  //await page.screenshot({ path: 'screenshot_nutrition_details_25-1.png', fullPage: true, timeout: 6000 });
  
  await page.click('#button_back');

});

test('Navigate to nutritions page and update value', async ({ page }) => {

  const acceptPolicyButton = await page.$('#accept-policy close');
  if (acceptPolicyButton !== null) {
    await acceptPolicyButton.click();
  }

  const myPageTitle = await page.title();
  expect(myPageTitle).toBe('Home Page - Mercury Health');

  await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
  await expect(page).toHaveTitle('Nutrition - Mercury Health');

  // ///////////////////////////////////////////////
  // Update the Value to something else
  // ///////////////////////////////////////////////
  await page.click('#button_edit_25');
  const detailsPageTitle = await page.title();
  expect(detailsPageTitle).toBe('Edit - Mercury Health');

  await page.getByLabel('Tags').click();
  await page.getByLabel('Tags').fill('Update by Playwright');

  // Take screenshot
  //await page.screenshot({ path: 'screenshot_nutrition_details_25-2.png', fullPage: true, timeout: 6000 });

  await page.getByRole('button', { name: 'Save' }).click();

  // ///////////////////////////////////////////////
  // Verify the updated value
  // ///////////////////////////////////////////////
  await page.click('#button_details_25');

  // Find the <dd> element by its ID
  const element = await page.$('#Value_Tags');
  const value = await element?.textContent();

  // Take screenshot
  //await page.screenshot({ path: 'screenshot_nutrition_details_25-3.png', fullPage: true, timeout: 6000 });

  // Assert that the value is correct
  expect(value?.trim()).toBe('Update by Playwright');

  await page.click('#button_back');


  // ///////////////////////////////////////////////
  // Update the Value back to original
  // ///////////////////////////////////////////////
  await page.click('#button_edit_25');

  await page.getByLabel('Tags').click();
  await page.getByLabel('Tags').fill('API Update');

  // Take screenshot
  //await page.screenshot({ path: 'screenshot_nutrition_details_25-4.png', fullPage: true, timeout: 6000 });

  await page.getByRole('button', { name: 'Save' }).click();

});

test('Navigate to nutritions page and verify details', async ({ page }) => {

  const acceptPolicyButton = await page.$('#accept-policy close');
  if (acceptPolicyButton !== null) {
    await acceptPolicyButton.click();
  }

  const myPageTitle = await page.title();
  expect(myPageTitle).toBe('Home Page - Mercury Health');

  await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
  await expect(page).toHaveTitle('Nutrition - Mercury Health');

  await page.click('#button_details_25');
  const detailsPageTitle = await page.title();
  expect(detailsPageTitle).toBe('Details - Mercury Health');

  // Take screenshot
  //await page.screenshot({ path: 'screenshot_nutrition_details_25-3.png', fullPage: true, timeout: 6000 });

  // Find the <dd> element by its ID
  const element = await page.$('#Value_Tags');
  const value = await element?.textContent();

  // Assert that the value is correct
  expect(value?.trim()).toBe('API Up');

  await page.click('#button_back');

});