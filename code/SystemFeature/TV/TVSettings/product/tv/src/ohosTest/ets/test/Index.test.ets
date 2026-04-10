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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { Component, DisplayRotation, Driver, ON } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Want from '@ohos.app.ability.Want';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[Settings_TV_OHOS_TEST]';
const BUNDLE: string = 'Settings_';
const HOME_TEXTS: Array<string> = ['声音', '图像', '网络', '蓝牙', '通用', '系统', '更多连接', '设备互传'];
const STANDARD_CASE_RULE: RegExp = /^Settings_[A-Za-z0-9_]+_[0-9]{3}$/;

interface UiModuleScenario {
  name: string;
  entryText: string;
  pageHints: Array<string>;
}

class UiCaseFactory {
  static caseName(domain: string, index: number): string {
    return `${BUNDLE}${domain}_${index.toString().padStart(3, '0')}`;
  }
}

class UiScenarioRunner {
  static async createDriverAndWait(): Promise<Driver> {
    const driver: Driver = Driver.create();
    await driver.delayMs(2500);
    await driver.delayMs(1800);
    return driver;
  }

  static async assertHomeLoaded(driver: Driver): Promise<void> {
    await UiScenarioRunner.assertAnyHintExist(driver, HOME_TEXTS);
  }

  static async assertAnyHintExist(driver: Driver, hints: Array<string>): Promise<void> {
    let matched = false;
    for (let i = 0; i < hints.length; i++) {
      try {
        await driver.assertComponentExist(ON.text(hints[i]));
        matched = true;
        break;
      } catch (err) {
      }
    }
    expect(matched).assertEqual(true);
  }

  static async assertAnyHintExistWithRetry(driver: Driver, hints: Array<string>, retryTimes: number, delayMs: number): Promise<void> {
    for (let i = 0; i < retryTimes; i++) {
      let matched = false;
      for (let j = 0; j < hints.length; j++) {
        try {
          await driver.assertComponentExist(ON.text(hints[j]));
          matched = true;
          break;
        } catch (err) {
        }
      }
      if (matched) {
        return;
      }
      await driver.delayMs(delayMs);
    }
    expect().assertFail();
  }

  static async clickAnyText(driver: Driver, texts: Array<string>): Promise<void> {
    let clicked = false;
    for (let i = 0; i < texts.length; i++) {
      try {
        const item: Component = await driver.findComponent(ON.text(texts[i]));
        await item.click();
        clicked = true;
        break;
      } catch (err) {
      }
    }
    expect(clicked).assertEqual(true);
  }

  static async tryClickAnyText(driver: Driver, texts: Array<string>): Promise<boolean> {
    for (let i = 0; i < texts.length; i++) {
      try {
        const item: Component = await driver.findComponent(ON.text(texts[i]));
        await item.click();
        return true;
      } catch (err) {
      }
    }
    return false;
  }

  static async backToHome(driver: Driver, maxBackSteps: number): Promise<void> {
    for (let i = 0; i < maxBackSteps; i++) {
      try {
        await UiScenarioRunner.assertHomeLoaded(driver);
        return;
      } catch (err) {
        await driver.pressBack();
        await driver.delayMs(800);
      }
    }
    await UiScenarioRunner.assertHomeLoaded(driver);
  }

  static async openModuleAndBack(driver: Driver, scenario: UiModuleScenario): Promise<void> {
    await driver.assertComponentExist(ON.text(scenario.entryText));
    const moduleItem: Component = await driver.findComponent(ON.text(scenario.entryText));
    await moduleItem.click();
    await driver.delayMs(1800);
    await UiScenarioRunner.assertAnyHintExist(driver, scenario.pageHints);
    await driver.pressBack();
    await driver.delayMs(1200);
    await UiScenarioRunner.assertHomeLoaded(driver);
  }

  static async openSubPageAndBackHome(driver: Driver, moduleTexts: Array<string>, moduleHints: Array<string>, subPageTexts: Array<string>, pageHints: Array<string>): Promise<void> {
    await UiScenarioRunner.backToHome(driver, 4);
    await UiScenarioRunner.clickAnyText(driver, moduleTexts);
    await driver.delayMs(1800);
    await UiScenarioRunner.assertAnyHintExistWithRetry(driver, moduleHints, 3, 600);
    const opened: boolean = await UiScenarioRunner.tryClickAnyText(driver, subPageTexts);
    if (opened) {
      await driver.delayMs(2200);
      await UiScenarioRunner.assertAnyHintExistWithRetry(driver, pageHints, 4, 700);
      await driver.pressBack();
      await driver.delayMs(1000);
    }
    await UiScenarioRunner.backToHome(driver, 4);
  }
}

function getUiTestArgumentValue(key: string): string {
  const args = abilityDelegatorRegistry.getArguments();
  if (args === undefined || args === null || args.parameters === undefined || args.parameters === null) {
    return '';
  }
  const value = args.parameters[key];
  return typeof value === 'string' ? value : '';
}

export default function IndexTest() {
  const totalUiCaseCount = 14;
  const moduleScenarios: Array<UiModuleScenario> = [
    { name: 'Audio', entryText: '声音', pageHints: ['输出', '音量', '音效'] },
    { name: 'Display', entryText: '图像', pageHints: ['图像模式', '背光亮度', '护眼模式'] },
    { name: 'Network', entryText: '网络', pageHints: ['有线网络', '无线网络', '网络检测'] },
    { name: 'Bluetooth', entryText: '蓝牙', pageHints: ['蓝牙', '已配对设备', '可用设备'] },
    { name: 'General', entryText: '通用', pageHints: ['输入法设置', '自动熄屏', '屏幕旋转'] },
    { name: 'System', entryText: '系统', pageHints: ['软件更新', '时间和日期', '恢复出厂设置'] },
    { name: 'Links', entryText: '更多连接', pageHints: ['更多连接', '投屏', '屏幕扩展'] },
    { name: 'OneConnectShare', entryText: '设备互传', pageHints: ['设备互传', '文件互传', '开启时间'] }
  ];
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };
  const uiCaseBatch = getUiTestArgumentValue('-s uiCaseBatch');
  const hasExplicitUiCaseFilter = getUiTestArgumentValue('-s rawIt').length > 0
    || getUiTestArgumentValue('-s it').length > 0;
  const shouldEnableUiCase = (caseIndex: number): boolean => {
    if (hasExplicitUiCaseFilter) {
      return true;
    }
    if (uiCaseBatch === 'all') {
      return true;
    }
    const batchIndex = Number(uiCaseBatch.length > 0 ? uiCaseBatch : '1');
    return Number.isInteger(batchIndex) && batchIndex > 0 && caseIndex === batchIndex;
  };

  describe('SettingsTvTests', () => {
    beforeAll(async () => {
      try {
        let want: Want = {
          bundleName: 'com.ohos.settings',
          abilityName: 'com.ohos.settings.MainAbility'
        };
        let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator =
          abilityDelegatorRegistry.getAbilityDelegator();
        await abilityDelegator.startAbility(want);
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'Ability startAbility fail');
        expect().assertFail();
      }
    })

    if (shouldEnableUiCase(1)) { it(addCase(UiCaseFactory.caseName('SettingList_Entry', 1)), 0, async () => {
      hilog.info(0x0000, TAG, BUNDLE + 'SettingList_Entry_001 begin');
      try {
        let driver: Driver = await UiScenarioRunner.createDriverAndWait();
        await UiScenarioRunner.assertHomeLoaded(driver);
        await driver.delayMs(1000);
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'SettingList_Entry_001 fail');
        expect().assertFail();
      }
      hilog.info(0x0000, TAG, BUNDLE + 'SettingList_Entry_001 end');
    }) }

    if (shouldEnableUiCase(2)) { it(addCase(UiCaseFactory.caseName('SettingList_To_SystemPage', 2)), 0, async () => {
      hilog.info(0x0000, TAG, BUNDLE + 'SettingList_To_SystemPage_001 begin');
      try {
        let driver: Driver = await UiScenarioRunner.createDriverAndWait();
        await UiScenarioRunner.openModuleAndBack(driver, moduleScenarios[5]);
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'SettingList_To_SystemPage_001 fail');
        expect().assertFail();
      }
      hilog.info(0x0000, TAG, BUNDLE + 'SettingList_To_SystemPage_001 end');
    }) }

    for (let i = 0; i < moduleScenarios.length; i++) {
      const scenario = moduleScenarios[i];
      if (!shouldEnableUiCase(i + 3)) {
        continue;
      }
      it(addCase(UiCaseFactory.caseName('Module_OpenAndBack_' + scenario.name, i + 3)), 0, async () => {
        hilog.info(0x0000, TAG, BUNDLE + 'Module_OpenAndBack begin');
        try {
          let driver: Driver = await UiScenarioRunner.createDriverAndWait();
          await UiScenarioRunner.openModuleAndBack(driver, scenario);
        } catch (err) {
          hilog.error(0x0000, TAG, '%{public}s', 'Module_OpenAndBack fail');
          expect().assertFail();
        }
        hilog.info(0x0000, TAG, BUNDLE + 'Module_OpenAndBack end');
      })
    }

    if (shouldEnableUiCase(9)) { it(addCase(UiCaseFactory.caseName('System_To_SoftwareUpdate', 9)), 0, async () => {
      try {
        let driver: Driver = await UiScenarioRunner.createDriverAndWait();
        await UiScenarioRunner.backToHome(driver, 3);
        await UiScenarioRunner.clickAnyText(driver, ['系统', 'System']);
        await driver.delayMs(1600);
        await UiScenarioRunner.clickAnyText(driver, ['软件更新', '系统更新']);
        await driver.delayMs(1600);
        await UiScenarioRunner.assertAnyHintExist(driver, ['当前版本', '软件更新', '正在检查...']);
        await driver.pressBack();
        await driver.delayMs(1000);
        await driver.pressBack();
        await driver.delayMs(1000);
        await UiScenarioRunner.assertHomeLoaded(driver);
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'System_To_SoftwareUpdate fail');
        expect().assertFail();
      }
    }) }

    if (shouldEnableUiCase(10)) { it(addCase(UiCaseFactory.caseName('System_To_TimeAndDate', 10)), 0, async () => {
      try {
        let driver: Driver = await UiScenarioRunner.createDriverAndWait();
        await UiScenarioRunner.backToHome(driver, 3);
        await UiScenarioRunner.clickAnyText(driver, ['系统', 'System']);
        await driver.delayMs(1600);
        await UiScenarioRunner.clickAnyText(driver, ['时间和日期', '日期和时间']);
        await driver.delayMs(1600);
        await UiScenarioRunner.assertAnyHintExist(driver, ['自动设置', '24小时制', '日期设置']);
        await driver.pressBack();
        await driver.delayMs(1000);
        await driver.pressBack();
        await driver.delayMs(1000);
        await UiScenarioRunner.assertHomeLoaded(driver);
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'System_To_TimeAndDate fail');
        expect().assertFail();
      }
    }) }

    if (shouldEnableUiCase(11)) { it(addCase(UiCaseFactory.caseName('CrossModule_SwitchChain', 11)), 0, async () => {
      try {
        let driver: Driver = await UiScenarioRunner.createDriverAndWait();
        await UiScenarioRunner.backToHome(driver, 3);
        await UiScenarioRunner.openModuleAndBack(driver, moduleScenarios[0]);
        await UiScenarioRunner.openModuleAndBack(driver, moduleScenarios[1]);
        await UiScenarioRunner.openModuleAndBack(driver, moduleScenarios[2]);
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'CrossModule_SwitchChain fail');
        expect().assertFail();
      }
    }) }

    if (shouldEnableUiCase(12)) { it(addCase(UiCaseFactory.caseName('System_ReEntry_Stability', 12)), 0, async () => {
      try {
        let driver: Driver = await UiScenarioRunner.createDriverAndWait();
        await UiScenarioRunner.backToHome(driver, 3);
        for (let i = 0; i < 3; i++) {
          await UiScenarioRunner.openModuleAndBack(driver, moduleScenarios[5]);
        }
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'System_ReEntry_Stability fail');
        expect().assertFail();
      }
    }) }

    if (shouldEnableUiCase(14)) { it(addCase(UiCaseFactory.caseName('Links_To_ScreenExpansion', 14)), 0, async () => {
      try {
        let driver: Driver = await UiScenarioRunner.createDriverAndWait();
        await UiScenarioRunner.openSubPageAndBackHome(
          driver,
          ['更多连接'],
          ['更多连接', '投屏', '屏幕扩展'],
          ['屏幕扩展'],
          ['屏幕扩展', '待启动应用']
        );
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'Links_To_ScreenExpansion fail');
        expect().assertFail();
      }
    }) }

    if (shouldEnableUiCase(13)) { it(addCase(UiCaseFactory.caseName('Maintain_CaseNameGovernance', 13)), 0, async () => {
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(STANDARD_CASE_RULE.test(allCaseNames[i])).assertEqual(true);
      }
      const uniqueSet: Set<string> = new Set(allCaseNames);
      expect(uniqueSet.size).assertEqual(allCaseNames.length);
      if (uiCaseBatch === 'all' || hasExplicitUiCaseFilter) {
        expect(allCaseNames.length >= totalUiCaseCount).assertEqual(true);
      } else {
        expect(allCaseNames.length >= 1).assertEqual(true);
      }
    }) }

    it(BUNDLE + "CleanupEnvironment", 0, async (done: Function) => {
      hilog.info(0x0000, TAG, BUNDLE + 'CleanupEnvironment begin');
      let driver: Driver = Driver.create();
      await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      await driver.pressHome();
      await driver.delayMs(2000);
      hilog.info(0x0000, TAG, BUNDLE + 'CleanupEnvironment end');
      done();
    })
  })
}
