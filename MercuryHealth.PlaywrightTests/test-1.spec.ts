import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('https://ca-3hfn6bl2n7cf6.salmonplant-b0e313da.eastus2.azurecontainerapps.io/');
  await page.getByText('Connect', { exact: true }).click();
  await page.locator('#noVNC_password_input').fill('password1');
  await page.locator('#noVNC_password_input').press('Enter');
  await page.locator('canvas').press('Enter');
  await page.locator('canvas').press('Enter');
  await page.locator('canvas').press('ArrowRight');
  await page.locator('canvas').press('ArrowRight');
  await page.locator('canvas').press('ArrowRight');
  await page.locator('canvas').press('ArrowUp');
  await page.locator('canvas').press('ArrowUp');
  await page.locator('canvas').press('Control+ArrowRight');
  await page.locator('canvas').press('Control+ArrowRight');
  await page.locator('canvas').press('Enter');
  await page.getByTitle('Hide/Show the control bar').locator('div').click();
  await page.getByRole('button', { name: 'Disconnect' }).click();
});