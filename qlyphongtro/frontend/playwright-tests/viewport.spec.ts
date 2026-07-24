import { test, expect } from '@playwright/test';
import fs from 'fs';
import path from 'path';

const screenshotsDir = path.join(__dirname, '..', 'playwright-screenshots');

test.beforeAll(() => {
  try {
    fs.mkdirSync(screenshotsDir, { recursive: true });
  } catch (e) {
    // ignore
  }
});

test('homepage visual and saved area', async ({ page, context }) => {
  await page.goto('/');
  await page.waitForTimeout(800); // let animations settle
  const projectName = test.info().project.name.replace(/[^a-zA-Z0-9-_]/g, '_');
  const file = path.join(screenshotsDir, `homepage-${projectName}.png`);
  await page.screenshot({ path: file, fullPage: true });
});
