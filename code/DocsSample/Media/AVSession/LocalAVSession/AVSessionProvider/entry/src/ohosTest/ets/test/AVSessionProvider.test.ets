/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[AVSessionProviderTests]';
const DOMAIN = 0xF816;
const BUNDLE = 'AVSessionProviderTests_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

async function runTest(testCaseName: string, buttonText: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btn = await driver.findComponent(ON.text(buttonText));
  if (btn !== undefined) {
    await btn.click();
    await driver.delayMs(delayTime);
  } else {
    hilog.warn(DOMAIN, TAG, BUNDLE + `Button "${buttonText}" not found, still waiting...`);
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

async function navigateToPageAndClickButton(
  pageName: string,
  pageButtonText: string,
  actionButtonText: string,
  delayTime: number,
  description: string,
  done: Function
) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let pageBtn = await driver.findComponent(ON.text(pageButtonText));
  if (pageBtn !== undefined) {
    await pageBtn.click();
    hilog.info(DOMAIN, TAG, BUNDLE + `Navigated to ${pageName} page`);
    await driver.delayMs(1000);
  } else {
    hilog.warn(DOMAIN, TAG, BUNDLE + `Page button "${pageButtonText}" not found`);
    done();
    return;
  }

  let actionBtn = await driver.findComponent(ON.text(actionButtonText));
  if (actionBtn !== undefined) {
    await actionBtn.click();
    hilog.info(DOMAIN, TAG, BUNDLE + `Clicked action button "${actionButtonText}"`);
    await driver.delayMs(delayTime);
  } else {
    hilog.warn(DOMAIN, TAG, BUNDLE + `Action button "${actionButtonText}" not found`);
  }

  await driver.pressBack();
  hilog.info(DOMAIN, TAG, BUNDLE + `Returned to main page`);
  await driver.delayMs(500);

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function avSessionProviderTest() {
  describe('avSessionProviderTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.samples.AVSessionProvider',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number AVSessionProvider_CreateAVSession_0001
     * @tc.name AVSessionProvider_CreateAVSession_0001
     * @tc.desc Navigate to CreateAVSession page and create session
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProvider_CreateAVSession_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'CreateAVSession',
        '创建并激活媒体会话',
        'hello world',
        3000,
        'Create and activate AVSession',
        done
      );
    });

    /**
     * @tc.number AVSessionProvider_Destroy_0001
     * @tc.name AVSessionProvider_Destroy_0001
     * @tc.desc Navigate to Destroy page and destroy session
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProvider_Destroy_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'Destroy',
        '销毁媒体会话',
        'hello world',
        3000,
        'Destroy AVSession',
        done
      );
    });

    /**
     * @tc.number AVSessionProvider_AdvancedPlaybackControlEvents_0001
     * @tc.name AVSessionProvider_AdvancedPlaybackControlEvents_0001
     * @tc.desc Navigate to AdvancedPlaybackControlEvents page and register events
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProvider_AdvancedPlaybackControlEvents_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'AdvancedPlaybackControlEvents',
        '注册高级播放控制事件',
        'hello world',
        3000,
        'Register advanced playback control events',
        done
      );
    });

    /**
     * @tc.number AVSessionProvider_DispatchSessionEvent_0001
     * @tc.name AVSessionProvider_DispatchSessionEvent_0001
     * @tc.desc Navigate to DispatchSessionEvent page and dispatch event
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProvider_DispatchSessionEvent_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'DispatchSessionEvent',
        '分发会话事件',
        'hello world',
        3000,
        'Dispatch session event',
        done
      );
    });

    /**
     * @tc.number AVSessionProvider_SetAVSessionInformation_0001
     * @tc.name AVSessionProvider_SetAVSessionInformation_0001
     * @tc.desc Navigate to SetAVSessionInformation page and set information
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProvider_SetAVSessionInformation_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'SetAVSessionInformation',
        '设置媒体会话信息',
        'hello world',
        3000,
        'Set AVSession information',
        done
      );
    });

    /**
     * @tc.number AVSessionProvider_FixedPlaybackControlCommands_0001
     * @tc.name AVSessionProvider_FixedPlaybackControlCommands_0001
     * @tc.desc Navigate to FixedPlaybackControlCommands page and register commands
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProvider_FixedPlaybackControlCommands_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'FixedPlaybackControlCommands',
        '注册固定播放控制命令',
        'hello world',
        3000,
        'Register fixed playback control commands',
        done
      );
    });

    /**
     * @tc.number AVSessionProvider_GetController_0001
     * @tc.name AVSessionProvider_GetController_0001
     * @tc.desc Navigate to GetController page and get controller
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProvider_GetController_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'GetController',
        '获取Controller对象',
        'hello world',
        3000,
        'Get controller object',
        done
      );
    });

    /**
     * @tc.number AVSessionProvider_SetExtras_0001
     * @tc.name AVSessionProvider_SetExtras_0001
     * @tc.desc Navigate to SetExtras page and set extras
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProvider_SetExtras_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'SetExtras',
        '设置自定义媒体数据包',
        'hello world',
        3000,
        'Set custom media extras',
        done
      );
    });

    /**
     * @tc.number AVSessionProvider_WantAgent_0001
     * @tc.name AVSessionProvider_WantAgent_0001
     * @tc.desc Navigate to WantAgent page and set WantAgent
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProvider_WantAgent_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'WantAgent',
        '设置WantAgent',
        'hello world',
        3000,
        'Set WantAgent',
        done
      );
    });

    /**
     * @tc.number AVSessionProvider_Off_0001
     * @tc.name AVSessionProvider_Off_0001
     * @tc.desc Navigate to Off page and cancel listeners
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AVSessionProvider_Off_0001', Level.LEVEL1, async (done: Function) => {
      await navigateToPageAndClickButton(
        'Off',
        '取消监听',
        'hello world',
        3000,
        'Cancel listeners',
        done
      );
    });
  });
}
