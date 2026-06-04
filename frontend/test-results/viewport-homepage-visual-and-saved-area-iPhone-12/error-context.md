# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: viewport.spec.ts >> homepage visual and saved area
- Location: playwright-tests\viewport.spec.ts:15:5

# Error details

```
Error: page.goto: Test ended.
Call log:
  - navigating to "http://localhost:3003/", waiting until "load"

```

# Test source

```ts
  1  | import { test, expect } from '@playwright/test';
  2  | import fs from 'fs';
  3  | import path from 'path';
  4  | 
  5  | const screenshotsDir = path.join(__dirname, '..', 'playwright-screenshots');
  6  | 
  7  | test.beforeAll(() => {
  8  |   try {
  9  |     fs.mkdirSync(screenshotsDir, { recursive: true });
  10 |   } catch (e) {
  11 |     // ignore
  12 |   }
  13 | });
  14 | 
  15 | test('homepage visual and saved area', async ({ page, context }) => {
> 16 |   await page.goto('/');
     |              ^ Error: page.goto: Test ended.
  17 |   await page.waitForTimeout(800); // let animations settle
  18 |   const projectName = test.info().project.name.replace(/[^a-zA-Z0-9-_]/g, '_');
  19 |   const file = path.join(screenshotsDir, `homepage-${projectName}.png`);
  20 |   await page.screenshot({ path: file, fullPage: true });
  21 | });
  22 | 
```