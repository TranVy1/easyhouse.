import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './playwright-tests',
  timeout: 30_000,
  expect: { timeout: 5000 },
  fullyParallel: true,
  reporter: [['list'], ['html', { outputFolder: 'playwright-report' }]],
  use: {
    baseURL: 'http://localhost:3003',
    headless: true,
    viewport: { width: 1280, height: 800 },
    actionTimeout: 0,
    ignoreHTTPSErrors: true,
  },
  projects: [
    {
      name: 'Desktop-1440x900',
      use: { viewport: { width: 1440, height: 900 } },
    },
    {
      name: 'Desktop-1280x800',
      use: { viewport: { width: 1280, height: 800 } },
    },
    {
      name: 'iPhone-12',
      use: { ...devices['iPhone 12'] },
    },
    {
      name: 'Pixel-5',
      use: { ...devices['Pixel 5'] },
    },
  ],
});
