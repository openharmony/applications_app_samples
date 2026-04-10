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
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Want from '@ohos.app.ability.Want';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { resourceManager } from '@kit.LocalizationKit';

const TAG = '[PhotosUiHarness]';
const ENTRY_BUNDLE_NAME = 'com.samples.album';
const ENTRY_ABILITY_NAME = 'EntryAbility';
const DEFAULT_BOOT_DELAY = 2500;
const DEFAULT_ACTION_DELAY = 600;

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
  findComponent(locator: Object): Promise<UiComponentLike | undefined>;
}

export class PhotosUiHarness {
  static getEntryWant(): Want {
    return {
      bundleName: ENTRY_BUNDLE_NAME,
      abilityName: ENTRY_ABILITY_NAME
    };
  }

  static createDriver(): Driver {
    return Driver.create();
  }

  static async startEntryAbility(): Promise<void> {
    const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

    // 统一从测试基建启动入口 Ability。
    // 后续所有 UI 套件复用同一入口，可以避免各文件拷贝启动逻辑后逐渐漂移。
    await abilityDelegator.startAbility(PhotosUiHarness.getEntryWant());
  }

  static async launchHome(): Promise<Driver> {
    await PhotosUiHarness.startEntryAbility();
    const driver = PhotosUiHarness.createDriver();
    await driver.delayMs(DEFAULT_BOOT_DELAY);
    await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
    return driver;
  }

  static async waitForStable(driver: UiDriverLike, delay?: number): Promise<void> {
    await driver.delayMs(delay ?? DEFAULT_ACTION_DELAY);
  }

  static async setRotation(driver: UiDriverLike, rotation: DisplayRotation): Promise<void> {
    await driver.setDisplayRotation(rotation);
    await PhotosUiHarness.waitForStable(driver);
  }

  static buildHomeTabCandidates(): Map<string, SelectorCandidate[]> {
    const tabs: Map<string, SelectorCandidate[]> = new Map();

    // 首页入口既有文案也有组件 id。
    // 同时保留中英文字段与 id 回退，能显著降低多语言环境下的脆弱性。
    tabs.set('picture', [
      new SelectorCandidate('照片'),
      new SelectorCandidate('Pictures'),
      new SelectorCandidate(undefined, 'menu0')
    ]);
    tabs.set('album', [
      new SelectorCandidate('相册'),
      new SelectorCandidate('Albums'),
      new SelectorCandidate(undefined, 'menu1')
    ]);
    tabs.set('distributed', [
      new SelectorCandidate('分布式图库'),
      new SelectorCandidate('Distributed Gallery'),
      new SelectorCandidate(undefined, 'menu2')
    ]);
    return tabs;
  }

  static buildEditDialogCandidates(): Map<string, SelectorCandidate[]> {
    const actions: Map<string, SelectorCandidate[]> = new Map();
    actions.set('choose', [
      new SelectorCandidate('选择'),
      new SelectorCandidate('Choose'),
      new SelectorCandidate(undefined, 'dialog2')
    ]);
    actions.set('share', [
      new SelectorCandidate('分享'),
      new SelectorCandidate('Share'),
      new SelectorCandidate(undefined, 'dialog1')
    ]);
    actions.set('delete', [
      new SelectorCandidate('删除'),
      new SelectorCandidate('Delete'),
      new SelectorCandidate(undefined, 'dialog0')
    ]);
    return actions;
  }

  static async findFirstAvailable(driver: UiDriverLike, candidates: SelectorCandidate[]): Promise<UiComponentLike | undefined> {
    for (let index = 0; index < candidates.length; index++) {
      const candidate = candidates[index];
      if (candidate.text) {
        const component = await driver.findComponent(ON.text(candidate.text));
        if (component) {
          return component;
        }
      }

      if (candidate.id) {
        const component = await driver.findComponent(ON.id(candidate.id));
        if (component) {
          return component;
        }
      }
    }
    return undefined;
  }

  static async tapFirstAvailable(driver: UiDriverLike, candidates: SelectorCandidate[]): Promise<boolean> {
    const component = await PhotosUiHarness.findFirstAvailable(driver, candidates);
    if (!component) {
      return false;
    }
    await component.click();
    await PhotosUiHarness.waitForStable(driver);
    return true;
  }

  static async openHomeTab(driver: UiDriverLike, tabKey: string): Promise<boolean> {
    const candidates = PhotosUiHarness.buildHomeTabCandidates().get(tabKey) ?? [];
    return PhotosUiHarness.tapFirstAvailable(driver, candidates);
  }

  static normalizeVisibleText(text: string): string {
    return text.replace(/\s+/g, ' ').trim();
  }

  static isReadableLabel(text: string): boolean {
    const normalizedText = PhotosUiHarness.normalizeVisibleText(text);
    return normalizedText.length > 0 && !normalizedText.includes('undefined');
  }

  static async getResourceString(resource: Resource): Promise<string> {
    const delegator = abilityDelegatorRegistry.getAbilityDelegator();
    const manage: resourceManager.ResourceManager = delegator.getAppContext().resourceManager;
    return manage.getStringValue(resource);
  }

  static async getCoreHomeLabels(): Promise<string[]> {
    const labels: string[] = [];

    // 资源读取在基建阶段提前验证。
    // 这样一旦资源表断裂，UI 用例会在统一入口快速暴露而不是散落在业务断言里。
    labels.push(await PhotosUiHarness.getResourceString($r('app.string.picture')));
    labels.push(await PhotosUiHarness.getResourceString($r('app.string.album')));
    labels.push(await PhotosUiHarness.getResourceString($r('app.string.menu_distributed_photo')));
    return labels;
  }

  static validateLabelSet(labels: string[]): boolean {
    if (labels.length === 0) {
      return false;
    }
    return labels.every((label) => PhotosUiHarness.isReadableLabel(label));
  }

  static getRotationNames(): string[] {
    return ['ROTATION_0', 'ROTATION_90', 'ROTATION_180', 'ROTATION_270'];
  }

  static log(message: string): void {
    hilog.info(0x0000, TAG, '%{public}s', message);
  }
}
