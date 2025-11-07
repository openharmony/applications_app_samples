/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { abilityDelegatorRegistry, Component, Driver } from '@kit.TestKit';
import { afterEach, beforeAll, describe, expect, it } from '@ohos/hypium';
import { ON } from '@ohos.UiTest';
import resource from '../../../main/ets/common/resource';
import { hilog } from '@kit.PerformanceAnalysisKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

const driver = Driver.create();
const BUNDLE = 'Restrictions_';
const TAG = '[Sample_Restrictions]';
const DOMAIN = 0xF811;

let aimComponent: Component;

export function PrivateWithRequireTest() {
  describe('PrivateWithRequireTest', () => {

    beforeAll(async () => {
      // 启动主Ability，进入首页
      await delegator.startAbility({
        bundleName: 'com.samples.restrictions',
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(3000); // 延长延迟，确保首页完全加载
    });

    afterEach(async () => {
      // 每次测试后返回首页（通过多次按返回键，避免页面层级残留）
      let homeEntry: Component | null = null;
      do {
        await driver.pressBack();
        await driver.delayMs(500);
        // 验证是否回到首页：检查linkWithPrivate正确案例入口是否存在
        homeEntry = await driver.findComponent(
          ON.text(await resource.resourceToString($r('app.string.linkWithPrivate_lable')))
        ).catch(() => null);
      } while (homeEntry == null);
    });

    /*
     * @tc.number: PrivateWithRequireTest_001
     * @tc.name: Test correct case of private with require
     * @tc.desc: Test correct case of private with require
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'PrivateWithRequireTest_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'PrivateWithRequireTest_001_begin');

      aimComponent = await driver.findComponent(
        ON.text(await resource.resourceToString($r('app.string.privateWithRequire_lable')))
      );
      if (!aimComponent) {
        hilog.error(DOMAIN, TAG, 'Correct case entry (privateWithRequire_lable) not found');
        expect(false).assertTrue();
        return;
      }
      await aimComponent.click();
      await driver.delayMs(2000); // 延长延迟，确保目标页面渲染完成

      // 验证页面核心元素：Hello文本（与PWRCorrectComponentChild中的Text组件匹配）
      const helloText = await driver.findComponent(
        ON.text(await resource.resourceToString($r('app.string.Hello')))
      );

      hilog.info(DOMAIN, TAG, 'PrivateWithRequireTest_001_end');
    });

    /*
     * @tc.number: PrivateWithRequireTest_002
     * @tc.name: Test error case of private with require
     * @tc.desc: Test error case of private with require
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it(BUNDLE + 'PrivateWithRequireTest_002', 0, async () => {
      hilog.info(DOMAIN, TAG, 'PrivateWithRequireTest_002_begin');

      aimComponent = await driver.findComponent(
        ON.text(await resource.resourceToString($r('app.string.privateWithRequireerr_lable')))
      );
      if (!aimComponent) {
        hilog.error(DOMAIN, TAG, 'Error case entry (privateWithRequireerr_lable) not found');
        expect(false).assertTrue();
        return;
      }
      await aimComponent.click();
      await driver.delayMs(2000); // 延长延迟，确保目标页面渲染完成

      // 验证页面核心元素：Hello文本（与PWRErrorComponentChild中的Text组件匹配）
      const helloText = await driver.findComponent(
        ON.text(await resource.resourceToString($r('app.string.Hello')))
      );

      hilog.info(DOMAIN, TAG, 'PrivateWithRequireTest_002_end');
    });
  });
}