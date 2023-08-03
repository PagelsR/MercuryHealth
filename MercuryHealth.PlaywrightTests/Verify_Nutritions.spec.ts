import { test, expect } from '@playwright/test';

// test.beforeEach(async ({ page }) => {
//   await page.goto('https://app-okhgzqoexg6jy.azurewebsites.net/' , { waitUntil: 'load', timeout: 100000 });
// });

// Dynamicly set the URL from pipeline output
test.beforeEach(async ({ page }) => {
  const url = process.env.website_URL || 'https://app-okhgzqoexg6jy.azurewebsites.net/';
  await page.goto(url , { waitUntil: 'load', timeout: 100000 });
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

test('Allow me to navigate to nutritions page', async ({ page }) => {
  //await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
  await page.locator('#menu_nutrition').click();
  await expect(page).toHaveTitle('Nutrition - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Nutritionspage.png', fullPage: true, timeout: 60000 });

});

test('Allow me to navigate to nutritions page and click on details', async ({ page }) => {

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

  await page.screenshot({
    path: 'screenshot_nutrition_details_25.png', fullPage: true, timeout: 60000 });
});

  // Todo! Convert the following to TypeScript
  // expect(page.url()).toBe(pageURL + 'Nutritions/Details/25');

  // const myDescription = await page.textContent('id=Description');
  // myDescription = myDescription.replace(/\n/g, '');
  // myDescription = myDescription.trim();

  // await page.screenshot({
  //   path: 'screenshot_Item-Description.png',
  //   fullPage: true
  // });

  // const rnd = Math.floor(Math.random() * 2) + 1;
  // if (rnd === 1) {
  //   expect(myDescription).toBe('Banana');
  // } else {
  //   expect(myDescription).toBe('Strawberry');
  // }

  // await page.click('text=Home');

  // await context.tracing.stop({
  //   path: 'trace_Verify_NavToNutritionDetail.zip'
  // });

  // await browser.close();
//});

