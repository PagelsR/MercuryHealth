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