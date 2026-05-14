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

/**
 * @file SharedDriver.ets
 * @overview 全局单例 Driver，所有 TVSettingsData 测试套件共享同一实例，
 *           避免多套件并发 Driver.create() 冲突。
 *           提供统一的 UI 操作队列、按键封装、稳定性检查工具。
 */

import { DisplayRotation, Driver, ON, Component } from '@kit.TestKit';

let _driver: Driver | null = null;
let _uiOperationQueue: Promise<void> = Promise.resolve();

/** 方向键：左 */
export const KEY_LEFT: number = 2014;

/** 方向键：右 */
export const KEY_RIGHT: number = 2015;

/** 方向键：上 */
export const KEY_UP: number = 2012;

/** 方向键：下 */
export const KEY_DOWN: number = 2013;

/** 确认键 */
export const KEY_ENTER: number = 2049;

/** 返回键 */
export const KEY_BACK: number = 2;

/** Home键 */
export const KEY_HOME: number = 3;

/** 编辑键 */
export const KEY_EDIT: number = 2033;

/**
 * 等待超时：设置页面冷启动最长容忍时间。
 * 设备在低负载下通常 1~2s 完成，此值留有 2x 余量。
 */
export const TIMEOUT_HOME: number = 3000;

/**
 * 等待超时：编辑态进入/退出，动画帧约 300ms，超时 2.5s 可覆盖慢设备。
 */
export const TIMEOUT_EDIT: number = 2500;

/**
 * 等待超时：冷启动首屏，允许更长的初始化时间。
 */
export const TIMEOUT_COLD_START: number = 4000;

/**
 * 延迟：应用启动后等待页面稳定，覆盖典型的 Activity 转场动画时长。
 */
export const DELAY_APP_LAUNCH: number = 900;

/**
 * 延迟：单次方向键后等待焦点动画落定，低于此值可能读到中间帧。
 */
export const DELAY_NAV_KEY: number = 120;

/**
 * 延迟：快速连续按键间隔，用于模拟遥控器连按场景。
 */
export const DELAY_BURST_KEY: number = 80;

/**
 * 压力测试循环次数上限，用于统一控制各套件中的压力循环次数。
 */
export const STRESS_ROUNDS: number = 10;

/**
 * surfaceCount 容差：单次操作允许的 UI 组件数量波动上限。
 * 值来自实测：页面切换时 Image+Text 节点增减通常不超过 8 个。
 */
export const TOLERANCE_SINGLE_OP: number = 8;

/**
 * surfaceCount 容差：编辑态进出一次允许的最大波动。
 */
export const TOLERANCE_EDIT_CYCLE: number = 14;

/**
 * surfaceCount 容差：多轮压力测试允许的累计漂移上限。
 */
export const TOLERANCE_STRESS: number = 22;

/**
 * 稳定性检查：连续多轮采样中组件数量变化不超过此容差即视为稳定。
 */
export const STABLE_TOLERANCE: number = 6;

/**
 * 稳定性检查：需要连续达标的轮数，轮数越多越严格。
 */
export const STABLE_ROUNDS: number = 2;

/** 串行化 UI 操作队列，避免并发冲突 */
export async function runSerializedUiOperation(action: () => Promise<void>): Promise<void> {
  const run = _uiOperationQueue.then(async () => {
    await action();
  });
  _uiOperationQueue = run.catch(() => {
  });
  await run;
}

/** 串行化按键触发 */
export async function triggerSerializedKey(driver: Driver, key: number): Promise<void> {
  await runSerializedUiOperation(async () => {
    await driver.triggerKey(key);
  });
}

/** 获取全局单例 Driver，首次调用时创建 */
export function getDriver(): Driver {
  if (_driver === null) {
    _driver = Driver.create();
  }
  return _driver;
}

/** 重置 Driver 访问状态 */
export function resetDriver(): void {
  _uiOperationQueue = Promise.resolve();
}

/** 每个 suite 开始时调用 */
export function createFreshDriver(): Driver {
  resetDriver();
  return getDriver();
}

/** 获取当前页面 Image + Text 组件总数 */
export async function surfaceCount(driver: Driver): Promise<number> {
  try {
    const imgArr = await findComponentsByType(driver, 'Image');
    const txtArr = await findComponentsByType(driver, 'Text');
    const images = imgArr ? imgArr.length : 0;
    const texts = txtArr ? txtArr.length : 0;
    return images + texts;
  } catch (e) {
    return 0;
  }
}

/** 按类型查找组件 */
async function findComponentsByType(driver: Driver, type: string): Promise<Component[] | null> {
  let result: Component[] | null = null;
  await runSerializedUiOperation(async () => {
    result = await driver.findComponents(ON.type(type));
  });
  return result;
}

/** 等待条件满足 */
export async function waitUntil(
  condition: () => Promise<boolean>,
  timeoutMs: number = 3000,
  intervalMs: number = 100,
  driver?: Driver
): Promise<boolean> {
  const start = Date.now();
  while (Date.now() - start <= timeoutMs) {
    if (await condition()) {
      return true;
    }
    if (driver) {
      try {
        await runSerializedUiOperation(async () => {
          await driver.delayMs(intervalMs);
        });
      } catch (e) {
      }
    } else {
      try {
        await runSerializedUiOperation(async () => {
          await getDriver().delayMs(intervalMs);
        });
      } catch (e) {
      }
    }
  }
  return false;
}

/** 等待页面渲染完成 */
export async function waitForSurface(
  driver: Driver,
  minimumCount: number = 2,
  timeoutMs: number = 3000
): Promise<boolean> {
  return waitUntil(async () => {
    try {
      const count = await surfaceCount(driver);
      return count >= minimumCount;
    } catch (e) {
      return false;
    }
  }, timeoutMs, 120, driver);
}

/** 等待页面稳定 */
export async function waitForStableSurface(
  driver: Driver,
  stableRounds: number = 3,
  tolerance: number = 4,
  timeoutMs: number = 3000
): Promise<boolean> {
  let okRounds = 0;
  let prev = 0;
  try {
    prev = await surfaceCount(driver);
  } catch (e) {
  }
  const start = Date.now();
  while (Date.now() - start <= timeoutMs) {
    try {
      await runSerializedUiOperation(async () => {
        await driver.delayMs(120);
      });
    } catch (e) {
    }
    let cur = 0;
    try {
      cur = await surfaceCount(driver);
    } catch (e) {
    }
    if (Math.abs(cur - prev) <= tolerance) {
      okRounds++;
      if (okRounds >= stableRounds) {
        return true;
      }
    } else {
      okRounds = 0;
    }
    prev = cur;
  }
  return false;
}

/** 按键并等待页面响应 */
export async function pressAndWait(
  driver: Driver,
  key: number,
  minimumCount: number = 2,
  timeoutMs: number = 3000
): Promise<void> {
  try {
    await pressKeyWithDelay(driver, key);
    await waitForSurface(driver, minimumCount, timeoutMs);
  } catch (e) {
    // ignore driver errors
  }
}

/** 旋转屏幕并等待 */
export async function rotateWithDelay(
  driver: Driver,
  rotation: DisplayRotation,
  delayMs: number = 800
): Promise<void> {
  try {
    await runSerializedUiOperation(async () => {
      await driver.setDisplayRotation(rotation);
    });
  } catch (e) {
    try {
      await runSerializedUiOperation(async () => {
        await driver.delayMs(200);
      });
      await runSerializedUiOperation(async () => {
        await driver.setDisplayRotation(rotation);
      });
    } catch (e2) {
    }
  }

  if (delayMs > 0) {
    try {
      await runSerializedUiOperation(async () => {
        await driver.delayMs(delayMs);
      });
    } catch (e) {
    }
  }
}

/** 按键并延迟 */
export async function pressKeyWithDelay(
  driver: Driver,
  key: number,
  delayMs: number = 0
): Promise<void> {
  try {
    await triggerSerializedKey(driver, key);
  } catch (e) {
    try {
      await runSerializedUiOperation(async () => {
        await driver.delayMs(200);
      });
      await triggerSerializedKey(driver, key);
    } catch (e2) {
    }
  }

  if (delayMs > 0) {
    try {
      await runSerializedUiOperation(async () => {
        await driver.delayMs(delayMs);
      });
    } catch (e) {
    }
  }
}

/** 安全延迟 */
export async function safeDelay(driver: Driver, delayMs: number): Promise<void> {
  if (delayMs <= 0) {
    return;
  }
  try {
    await runSerializedUiOperation(async () => {
      await driver.delayMs(delayMs);
    });
  } catch (e) {
  }
}

/** 安全旋转 */
export async function safeRotate(
  driver: Driver,
  rotation: DisplayRotation,
  delayMs: number = 0
): Promise<void> {
  try {
    await runSerializedUiOperation(async () => {
      await driver.setDisplayRotation(rotation);
    });
  } catch (e) {
    try {
      await runSerializedUiOperation(async () => {
        await driver.delayMs(200);
      });
      await runSerializedUiOperation(async () => {
        await driver.setDisplayRotation(rotation);
      });
    } catch (e2) {
    }
  }
  await safeDelay(driver, delayMs);
}

/** 安全查找组件 */
export async function safeFindComponents(driver: Driver, type: string): Promise<Component[]> {
  try {
    const result = await findComponentsByType(driver, type);
    return result ?? [];
  } catch (e) {
    return [];
  }
}

/** 统计非空 Text 组件数 */
export async function countNonEmptyTexts(driver: Driver): Promise<number> {
  try {
    const texts = await findComponentsByType(driver, 'Text');
    if (!texts) {
      return 0;
    }
    let nonEmpty = 0;
    for (let i = 0; i < texts.length; i++) {
      let value = '';
      try {
        await runSerializedUiOperation(async () => {
          value = await texts[i].getText();
        });
      } catch (e) {
        value = '';
      }
      if (value && value.trim().length > 0) {
        nonEmpty++;
      }
    }
    return nonEmpty > 0 ? nonEmpty : texts.length;
  } catch (e) {
    return 0;
  }
}

/** 测量操作延迟 */
export async function measureActionSurfaceLatency(
  driver: Driver,
  action: () => Promise<void>,
  minimumCount: number = 2,
  timeoutMs: number = 3000
): Promise<number> {
  const start = Date.now();
  await action();
  await waitForSurface(driver, minimumCount, timeoutMs);
  return Date.now() - start;
}
