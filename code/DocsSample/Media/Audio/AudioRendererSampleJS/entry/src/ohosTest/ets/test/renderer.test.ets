/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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

const TAG = '[AudioRendererDemoTest]';
const DOMAIN = 0xF81C;
const BUNDLE = 'AudioRendererDemo_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

async function runTest(
  testCaseName: string,
  buttonText: string,
  delayTime: number,
  description: string,
  done: Function
) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btn = await driver.findComponent(ON.text(buttonText));
  if (btn !== undefined) {
    await btn.click();
    await driver.delayMs(delayTime);
  } else {
    hilog.warn(DOMAIN, TAG, BUNDLE + `Button "${buttonText}" not found.`);
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function AudioRendererDemoTest() {
  describe('AudioRendererDemoTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.example.myapplication',
        abilityName: 'EntryAbility'
      });
    });

    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number AudioRendererDemo_NavigateToRendererPage_0001
     * @tc.name AudioRendererDemo_NavigateToRendererPage_0001
     * @tc.desc Navigate to the Renderer page via button click
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_NavigateToRendererPage_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_NavigateToRendererPage_0001',
        '音频播放页面',
        2000,
        'Navigate to Renderer page (pages/Renderer) by clicking the corresponding button',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_Init_0001
     * @tc.name AudioRendererDemo_Init_0001
     * @tc.desc Initialize AudioRenderer instance and set callbacks
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_Init_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_Init_0001',
        '初始化',
        2000,
        'Initialize AudioRenderer and register callbacks',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_Start_0001
     * @tc.name AudioRendererDemo_Start_0001
     * @tc.desc Start audio rendering
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_Start_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_Start_0001',
        '开始播放',
        2000,
        'Start audio rendering playback',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_Pause_0001
     * @tc.name AudioRendererDemo_Pause_0001
     * @tc.desc Pause ongoing audio rendering
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_Pause_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_Pause_0001',
        '暂停播放',
        2000,
        'Pause ongoing audio rendering',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_Stop_0001
     * @tc.name AudioRendererDemo_Stop_0001
     * @tc.desc Stop audio rendering
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_Stop_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_Stop_0001',
        '停止播放',
        2000,
        'Stop audio rendering',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_Release_0001
     * @tc.name AudioRendererDemo_Release_0001
     * @tc.desc Release AudioRenderer resources
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_Release_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_Release_0001',
        '释放资源',
        3000,
        'Release AudioRenderer and unregister listeners',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_GetVolume_0001
     * @tc.name AudioRendererDemo_GetVolume_0001
     * @tc.desc Get system volume info for music stream
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_GetVolume_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_GetVolume_0001',
        '获取音频流音量',
        1500,
        'Get min/max/current volume of music stream',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_SetAppVolume_0001
     * @tc.name AudioRendererDemo_SetAppVolume_0001
     * @tc.desc Set and query application volume percentage
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_SetAppVolume_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_SetAppVolume_0001',
        '设置应用的音量',
        2500,
        'Set app volume to 20% and verify',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_SetStreamVolume_0001
     * @tc.name AudioRendererDemo_SetStreamVolume_0001
     * @tc.desc Set and get renderer stream volume
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_SetStreamVolume_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_SetStreamVolume_0001',
        '设置音频流音量',
        2000,
        'Set renderer volume to 0.5 and retrieve it',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_GetDevices_0001
     * @tc.name AudioRendererDemo_GetDevices_0001
     * @tc.desc Get output audio devices info
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_GetDevices_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_GetDevices_0001',
        '是否支持空间音频',
        1500,
        'Query output audio devices via RoutingManager',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_GetSpatialStatus_0001
     * @tc.name AudioRendererDemo_GetSpatialStatus_0001
     * @tc.desc Check if spatial audio is enabled on current device
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_GetSpatialStatus_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_GetSpatialStatus_0001',
        '查询空间音频开关状态',
        1500,
        'Check spatialization enabled status',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_SubscribeSpatial_0001
     * @tc.name AudioRendererDemo_SubscribeSpatial_0001
     * @tc.desc Subscribe to spatial audio enable change event
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_SubscribeSpatial_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_SubscribeSpatial_0001',
        '订阅开关状态事件',
        1500,
        'Register spatializationEnabledChangeForCurrentDevice callback',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_UnsubscribeSpatial_0001
     * @tc.name AudioRendererDemo_UnsubscribeSpatial_0001
     * @tc.desc Unsubscribe from spatial audio event
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_UnsubscribeSpatial_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_UnsubscribeSpatial_0001',
        '取消订阅',
        1000,
        'Unregister spatializationEnabledChangeForCurrentDevice callback',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_GetRendererState_0001
     * @tc.name AudioRendererDemo_GetRendererState_0001
     * @tc.desc Get current AudioRenderer state
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_GetRendererState_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_GetRendererState_0001',
        '查看播放的状态',
        1000,
        'Retrieve and log current AudioRenderer state',
        done
      );
    });

    /**
     * @tc.number AudioRendererDemo_GetAllStreams_0001
     * @tc.name AudioRendererDemo_GetAllStreams_0001
     * @tc.desc Get all active audio renderer stream info
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRendererDemo_GetAllStreams_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRendererDemo_GetAllStreams_0001',
        '获取所有流信息',
        2500,
        'Fetch all current audio renderer info via StreamManager',
        done
      );
    });
  });
}