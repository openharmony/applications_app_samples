/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import { describe, it, expect, TestType, beforeAll } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, UIElementInfo } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const WAIT_UI_READYMS = 1000;

export default function monitorEventTest() {
  describe('monitorEventTest', () => {
    beforeAll(async () => {
      let want: Want = {
        bundleName : bundleName,
        abilityName : 'EntryAbility'
      };
      await delegator.startAbility(want);
    })

    /**
     * @tc.number:testMonitor_001
     * @tc.name: testMonitor_toast
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: toast监听测试
     */
    it("testMonitor_toast", TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let observer = await driver.createUIEventObserver();
      let callback = (uiElementInfo : UIElementInfo) => {
        try {
          expect(uiElementInfo.bundleName == 'com.samples.test.uitest').assertTrue();
          expect(uiElementInfo.text == 'testMessage').assertTrue();
          expect(uiElementInfo.type == 'Toast').assertTrue();
        } catch (e) {
          console.log(`testMonitor_toast, error, ${JSON.stringify(e)}`);
          expect().assertFail();
        }
      }
      observer.once('toastShow', callback)
      let btn = await driver.findComponent(ON.text('showToast'));
      await btn.click();
      await driver.delayMs(WAIT_UI_READYMS * 2);
      done();
    })

    /**
     * @tc.number:testMonitor_002
     * @tc.name: testMonitor_dialog
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: dialog监听测试
     */
    it("testMonitor_dialog", TestType.FUNCTION, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(WAIT_UI_READYMS);
      let observer = await driver.createUIEventObserver();
      let callback = (uiElementInfo : UIElementInfo) => {
        try {
          expect(uiElementInfo.bundleName == 'com.samples.test.uitest').assertTrue();
          expect(uiElementInfo.text == 'testDialogtestMessage').assertTrue();
          expect(uiElementInfo.type == 'AlertDialog').assertTrue();
        } catch (e) {
          console.log(`testMonitor_dialog, error, ${JSON.stringify(e)}`);
          expect().assertFail();
        }
      }
      observer.once('dialogShow', callback);
      let btn = await driver.findComponent(ON.text('showDialog'));
      await btn.click();
      await driver.delayMs(WAIT_UI_READYMS * 2);
      done();
    })
  })
}