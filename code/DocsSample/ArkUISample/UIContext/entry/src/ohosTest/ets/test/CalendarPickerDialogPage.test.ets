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

import { describe, beforeAll, beforeEach, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import { Router, router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;
const DOMAIN = 0xF811;

export default function CalendarPickerDialogPageTest() {
  describe('CalendarPickerDialogPageTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, 'get top ability', 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })
    beforeEach(() => {
      hilog.info(DOMAIN, 'CalendarPickerDialogPage beforeEach start', 'CalendarPickerDialogPage beforeEach start');
      let options: router.RouterOptions = {
        url: 'pages/CalendarPickerDialogPage',
      }
      try {
        const routerInstance = AppStorage.get<Router>('router') as Router
        let pages = routerInstance.getState();
        hilog.info(DOMAIN, 'get CalendarPickerDialogPage state pages', JSON.stringify(pages));
        if (('CalendarPickerDialogPage' != pages.name)) {
          hilog.info(DOMAIN, 'get CalendarPickerDialogPage state pages', JSON.stringify(pages.name));
          routerInstance.pushUrl(options);
        }
      } catch (err) {
        hilog.error(DOMAIN, 'get CalendarPickerDialogPage state pages', err);
      }
      hilog.info(DOMAIN, 'CalendarPickerDialogPage beforeEach end', 'CalendarPickerDialogPage beforeEach end');
    });

    /*
     * @tc.number     : CalendarPickerDialogPage_01
     * @tc.name       : CalendarPickerDialogPageTest_01
     * @tc.desc       : 测试UIContext替代全局接口
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */

    it('CalendarPickerDialogPageTest_01', 0, async (done: Function) => {
      hilog.info(DOMAIN, 'uitest: CalendarPickerDialogPageTest begin', 'uitest: CalendarPickerDialogPageTest begin');
      let driver = Driver.create();
      let componentText = await driver.findComponent(ON.text('Show CalendarPicker Dialog'));
      await componentText.click();
      hilog.info(DOMAIN, 'uitest: already click', 'uitest: already click');
      await driver.delayMs(2000);
      done();
    })
  });
}