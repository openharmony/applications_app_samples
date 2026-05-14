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

import { Component, DisplayRotation, Driver, ON } from '@ohos.UiTest';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[TVDeviceManagerUiHarness]';
const DEFAULT_DELAY: number = 400;

export class SelectorCandidate {
  text?: string;
  id?: string;

  constructor(text?: string, id?: string) {
    this.text = text;
    this.id = id;
  }
}

export interface UiComponentLike {
  click(): Promise<void>;
}

export interface UiDriverLike {
  delayMs(delay: number): Promise<void>;
  setDisplayRotation(rotation: DisplayRotation): Promise<void>;
  findComponent(locator: UiLocator): Promise<UiComponentLike | undefined>;
}

export class UiLocator {
  type: string;
  value: string;

  constructor(type: string, value: string) {
    this.type = type;
    this.value = value;
  }
}

export class TVDeviceManagerUiHarness {
  static createDriver(): Driver {
    return Driver.create();
  }

  static buildLocator(driver: UiDriverLike, type: string, value: string): UiLocator {
    if (driver instanceof Driver) {
      if (type === 'text') {
        const onLocator = ON.text(value);
        return new UiLocator('text', value);
      }
      const onLocator = ON.id(value);
      return new UiLocator('id', value);
    }
    return new UiLocator(type, value);
  }

  static async waitForStable(driver: UiDriverLike, delay: number = DEFAULT_DELAY): Promise<void> {
    await driver.delayMs(delay);
  }

  static async setRotation(driver: UiDriverLike, rotation: DisplayRotation): Promise<void> {
    await driver.setDisplayRotation(rotation);
    await TVDeviceManagerUiHarness.waitForStable(driver);
  }

  static getRotationNames(): string[] {
    return ['ROTATION_0', 'ROTATION_90', 'ROTATION_180', 'ROTATION_270'];
  }

  static buildConfirmCandidates(): SelectorCandidate[] {
    return [
      new SelectorCandidate('本次允许'),
      new SelectorCandidate('confirm'),
      new SelectorCandidate(undefined, 'confirm')
    ];
  }

  static buildCancelCandidates(): SelectorCandidate[] {
    return [
      new SelectorCandidate('取消'),
      new SelectorCandidate('cancel'),
      new SelectorCandidate(undefined, 'cancel')
    ];
  }

  static buildAlwaysAllowCandidates(): SelectorCandidate[] {
    return [
      new SelectorCandidate('始终允许'),
      new SelectorCandidate('always'),
      new SelectorCandidate(undefined, 'always')
    ];
  }

  static buildPinInputCandidates(): SelectorCandidate[] {
    return [
      new SelectorCandidate(undefined, 'pinInput')
    ];
  }

  static buildPinConfirmCandidates(): SelectorCandidate[] {
    return [
      new SelectorCandidate('确定'),
      new SelectorCandidate(undefined, 'confirm')
    ];
  }

  static buildPinCancelCandidates(): SelectorCandidate[] {
    return [
      new SelectorCandidate('取消'),
      new SelectorCandidate(undefined, 'cancle'),
      new SelectorCandidate(undefined, 'cancel')
    ];
  }

  static async findFirstAvailable(driver: UiDriverLike, candidates: SelectorCandidate[]): Promise<UiComponentLike | undefined> {
    for (let index: number = 0; index < candidates.length; index++) {
      const candidate: SelectorCandidate = candidates[index];
      if (candidate.text) {
        const componentByText: UiComponentLike | undefined =
          await driver.findComponent(TVDeviceManagerUiHarness.buildLocator(driver, 'text', candidate.text));
        if (componentByText) {
          return componentByText;
        }
      }
      if (candidate.id) {
        const componentById: UiComponentLike | undefined =
          await driver.findComponent(TVDeviceManagerUiHarness.buildLocator(driver, 'id', candidate.id));
        if (componentById) {
          return componentById;
        }
      }
    }
    return undefined;
  }

  static async tapFirstAvailable(driver: UiDriverLike, candidates: SelectorCandidate[]): Promise<boolean> {
    const component: UiComponentLike | undefined = await TVDeviceManagerUiHarness.findFirstAvailable(driver, candidates);
    if (!component) {
      return false;
    }
    await component.click();
    await TVDeviceManagerUiHarness.waitForStable(driver);
    return true;
  }

  static normalizeVisibleText(value: string): string {
    return value.replace(/\s+/g, ' ').trim();
  }

  static isReadableLabel(value: string): boolean {
    const normalized: string = TVDeviceManagerUiHarness.normalizeVisibleText(value);
    return normalized.length > 0 && !normalized.includes('undefined') && !normalized.includes('null');
  }

  static createDisplayMatrix(): number[][] {
    return [
      [1280, 720],
      [1920, 1080],
      [2560, 1440],
      [3840, 2160]
    ];
  }

  static buildFocusCandidates(): Map<string, SelectorCandidate[]> {
    const map: Map<string, SelectorCandidate[]> = new Map<string, SelectorCandidate[]>();

    // 系统弹窗存在中英文、组件 key 与 id 三类入口。
    // 统一在基建层收口候选器，能降低后续 UI 套件对文案微调的敏感度。
    map.set('confirm', TVDeviceManagerUiHarness.buildConfirmCandidates());
    map.set('cancel', TVDeviceManagerUiHarness.buildCancelCandidates());
    map.set('always', TVDeviceManagerUiHarness.buildAlwaysAllowCandidates());
    map.set('pinInput', TVDeviceManagerUiHarness.buildPinInputCandidates());
    map.set('pinConfirm', TVDeviceManagerUiHarness.buildPinConfirmCandidates());
    map.set('pinCancel', TVDeviceManagerUiHarness.buildPinCancelCandidates());
    return map;
  }

  static log(message: string): void {
    hilog.info(0x0000, TAG, '%{public}s', message);
  }
}
