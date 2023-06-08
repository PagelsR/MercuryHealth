import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto('https://app-x7vgm47suuyt2.azurewebsites.net/');
});

test('Home', async ({ page }) => {
    await expect(page).toHaveTitle('Home Page - Mercury Health');
  
    await expect(page).toHaveProperty('#menu_home');

    await page.getByRole('link', { name: 'Nutrition', exact: true }).click();
    await page.locator('#menu_privacy').click();
    await page.getByRole('link', { name: 'Metrics' }).click();

});