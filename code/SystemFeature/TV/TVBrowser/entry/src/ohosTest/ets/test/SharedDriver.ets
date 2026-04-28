/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Driver, ON, Component, DisplayRotation } from '@kit.TestKit';

let sharedDriver: Driver | null = null;
let uiQueue: Promise<void> = Promise.resolve();

export const KEY_LEFT: number = 2014;
export const KEY_RIGHT: number = 2015;
export const KEY_UP: number = 2012;
export const KEY_DOWN: number = 2013;
export const KEY_ENTER: number = 2049;
export const KEY_BACK: number = 2;
export const KEY_HOME: number = 3;
export const TIMEOUT_START: number = 5000;
export const TIMEOUT_NAV: number = 2500;
export const TIMEOUT_WEB: number = 4000;
export const STABLE_ROUNDS: number = 2;
export const STABLE_TOLERANCE: number = 10;
export const DELAY_APP_LAUNCH: number = 2000;
export const DELAY_NAV_KEY: number = 300;

export function getDriver(): Driver {
  if (sharedDriver === null) {
    sharedDriver = Driver.create();
  }
  return sharedDriver;
}

export function createFreshDriver(): Driver {
  uiQueue = Promise.resolve();
  return getDriver();
}

export async function runSerialized(operation: () => Promise<void>): Promise<void> {
  const nextRun: Promise<void> = uiQueue.then(async () => {
    await operation();
  });
  uiQueue = nextRun.catch(() => {
  });
  await nextRun;
}

export async function safeDelay(driver: Driver, delayMs: number): Promise<void> {
  if (delayMs <= 0) {
    return;
  }

  // 使用更简单的延迟机制，避免序列化队列导致的阻塞
  try {
    await driver.delayMs(delayMs);
  } catch (error) {
    // 如果driver.delayMs失败，使用setTimeout作为备选方案
    await new Promise<void>(resolve => setTimeout(resolve, delayMs));
  }
}

export async function pressKey(driver: Driver, key: number, delayMs: number = 120): Promise<void> {
  try {
    await runSerialized(async () => {
      await driver.triggerKey(key);
    });
  } catch (error) {
    await safeDelay(driver, 180);
    try {
      await runSerialized(async () => {
        await driver.triggerKey(key);
      });
    } catch (secondError) {
    }
  }
  await safeDelay(driver, delayMs);
}

export async function safePressBack(driver: Driver, delayMs: number = 500): Promise<void> {
  try {
    await runSerialized(async () => {
      await driver.pressBack();
    });
  } catch (error) {
  }
  await safeDelay(driver, delayMs);
}

export async function safeFindById(driver: Driver, id: string): Promise<Component | null> {
  try {
    return await driver.findComponent(ON.id(id));
  } catch (error) {
    return null;
  }
}

export async function safeFindAllById(driver: Driver, id: string): Promise<Component[]> {
  try {
    const list: Component[] | null = await driver.findComponents(ON.id(id));
    return list ?? [];
  } catch (error) {
    return [];
  }
}

export async function safeFindByType(driver: Driver, type: string): Promise<Component[]> {
  try {
    const list: Component[] | null = await driver.findComponents(ON.type(type));
    return list ?? [];
  } catch (error) {
    return [];
  }
}

export async function countSurface(driver: Driver): Promise<number> {
  const images: Component[] = await safeFindByType(driver, 'Image');
  const texts: Component[] = await safeFindByType(driver, 'Text');
  const buttons: Component[] = await safeFindByType(driver, 'Button');
  const textInputs: Component[] = await safeFindByType(driver, 'TextInput');
  const rows: Component[] = await safeFindByType(driver, 'Row');
  const columns: Component[] = await safeFindByType(driver, 'Column');
  const dividers: Component[] = await safeFindByType(driver, 'Divider');
  const tabs: Component[] = await safeFindByType(driver, 'Tabs');
  const tabContents: Component[] = await safeFindByType(driver, 'TabContent');

  return images.length + texts.length + buttons.length + textInputs.length +
  rows.length + columns.length + dividers.length + tabs.length + tabContents.length;
}

export async function debugSurfaceCount(driver: Driver): Promise<string> {
  const images: Component[] = await safeFindByType(driver, 'Image');
  const texts: Component[] = await safeFindByType(driver, 'Text');
  const buttons: Component[] = await safeFindByType(driver, 'Button');
  const textInputs: Component[] = await safeFindByType(driver, 'TextInput');
  const rows: Component[] = await safeFindByType(driver, 'Row');
  const columns: Component[] = await safeFindByType(driver, 'Column');
  const dividers: Component[] = await safeFindByType(driver, 'Divider');
  const tabs: Component[] = await safeFindByType(driver, 'Tabs');
  const tabContents: Component[] = await safeFindByType(driver, 'TabContent');

  const total = images.length + texts.length + buttons.length + textInputs.length +
  rows.length + columns.length + dividers.length + tabs.length + tabContents.length;

  return `Surface Debug - Images: ${images.length}, Texts: ${texts.length}, Buttons: ${buttons.length}, ` +
    `TextInputs: ${textInputs.length}, Rows: ${rows.length}, Columns: ${columns.length}, ` +
    `Dividers: ${dividers.length}, Tabs: ${tabs.length}, TabContents: ${tabContents.length}, Total: ${total}`;
}

export async function countReadableTexts(driver: Driver): Promise<number> {
  const texts: Component[] = await safeFindByType(driver, 'Text');
  let readable: number = 0;
  for (let index: number = 0; index < texts.length; index++) {
    try {
      const textValue: string = await texts[index].getText();
      if (textValue.trim().length > 0) {
        readable++;
      }
    } catch (error) {
    }
  }
  return readable;
}

export async function waitUntil(
  predicate: () => Promise<boolean>,
  timeoutMs: number,
  intervalMs: number,
  driver: Driver
): Promise<boolean> {
  const startAt: number = Date.now();
  while (Date.now() - startAt <= timeoutMs) {
    if (await predicate()) {
      return true;
    }
    await safeDelay(driver, intervalMs);
  }
  return false;
}

export async function waitForId(driver: Driver, id: string, timeoutMs: number = TIMEOUT_START): Promise<boolean> {
  return await waitUntil(async () => {
    return (await safeFindById(driver, id)) !== null;
  }, timeoutMs, 150, driver);
}

export async function waitForSurface(
  driver: Driver,
  minCount: number = 3,
  timeoutMs: number = TIMEOUT_START
): Promise<boolean> {
  return await waitUntil(async () => {
    const surfaceCount: number = await countSurface(driver);
    return surfaceCount >= minCount;
  }, timeoutMs, 200, driver);
}

export async function waitForStableSurface(
  driver: Driver,
  rounds: number = STABLE_ROUNDS,
  tolerance: number = STABLE_TOLERANCE,
  timeoutMs: number = TIMEOUT_START
): Promise<boolean> {
  let lastValue: number = await countSurface(driver);
  let stableCount: number = 0;
  const startAt: number = Date.now();
  let iterationCount: number = 0;
  const maxIterations: number = Math.floor(timeoutMs / 150);

  while (Date.now() - startAt <= timeoutMs && iterationCount < maxIterations) {
    iterationCount++;
    await safeDelay(driver, 150);
    const currentValue: number = await countSurface(driver);
    if (Math.abs(currentValue - lastValue) <= tolerance) {
      stableCount++;
      if (stableCount >= rounds) {
        return true;
      }
    } else {
      stableCount = 0;
    }
    lastValue = currentValue;
  }
  return false;
}

export async function typeToInput(driver: Driver, inputId: string, text: string): Promise<void> {
  const input: Component | null = await safeFindById(driver, inputId);
  if (input === null) {
    return;
  }

  // 先清空再输入，是为了让 URL 校验类用例与上一个场景完全隔离。
  // 浏览器应用会保留上一次输入值，不重置会让空值、非法值和合法值场景互相污染。
  await input.inputText('');
  await safeDelay(driver, 100);
  await input.inputText(text);
  await safeDelay(driver, 200);
}

export async function clickById(driver: Driver, id: string, delayMs: number = 500): Promise<boolean> {
  const component: Component | null = await safeFindById(driver, id);
  if (component === null) {
    return false;
  }
  try {
    await component.click();
  } catch (error) {
    return false;
  }
  await safeDelay(driver, delayMs);
  return true;
}

export async function readInputText(driver: Driver, inputId: string): Promise<string> {
  const component: Component | null = await safeFindById(driver, inputId);
  if (component === null) {
    return '';
  }
  try {
    const value: string = await component.getText();
    return value;
  } catch (error) {
    return '';
  }
}

export async function rotateScreen(driver: Driver, rotation: DisplayRotation, delayMs: number = 1200): Promise<void> {
  try {
    await runSerialized(async () => {
      await driver.setDisplayRotation(rotation);
    });
  } catch (error) {
  }
  await safeDelay(driver, delayMs);
}

export async function openBrowserHome(driver: Driver): Promise<void> {
  await waitForId(driver, 'inputUrl', TIMEOUT_START);
  await waitForStableSurface(driver, STABLE_ROUNDS, STABLE_TOLERANCE, TIMEOUT_START);
}

export async function backToSafeHome(driver: Driver): Promise<void> {
  await safePressBack(driver, 400);
  await safePressBack(driver, 400);
  await pressKey(driver, KEY_HOME, 450);
}

export async function pressAndWait(driver: Driver, key: number, delayMs: number = DELAY_NAV_KEY): Promise<void> {
  await pressKey(driver, key, delayMs);
}
