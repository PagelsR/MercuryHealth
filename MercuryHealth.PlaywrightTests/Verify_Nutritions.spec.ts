import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  
  await page.goto('https://app-x7vgm47suuyt2.azurewebsites.net/' , { waitUntil: 'load', timeout: 100000 });
});

test('should allow me to navigate to nutritions page', async ({ page }) => {
  
  await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
  await expect(page).toHaveTitle('Nutrition - Mercury Health');

  // Take screenshot
  await page.screenshot({ path: 'screenshot_Home-Nutritionspage.png', fullPage: true, timeout: 60000 });

});


test('Verify_NavToNutritionDetail', async () => {


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
    path: 'screenshot_nutrition_details_25.png',
    fullPage: true
  });

  expect(page.url()).toBe(pageURL + 'Nutritions/Details/25');

  let myDescription = await page.textContent('id=Description');
  myDescription = myDescription.replace(/\n/g, '');
  myDescription = myDescription.trim();

  await page.screenshot({
    path: 'screenshot_Item-Description.png',
    fullPage: true
  });

  const rnd = Math.floor(Math.random() * 2) + 1;
  if (rnd === 1) {
    expect(myDescription).toBe('Banana');
  } else {
    expect(myDescription).toBe('Strawberry');
  }

  await page.click('text=Home');

  await context.tracing.stop({
    path: 'trace_Verify_NavToNutritionDetail.zip'
  });

  await browser.close();
});

