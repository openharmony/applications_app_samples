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
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[Sample_AudioRender]';
const DOMAIN = 0xF811;
const BUNDLE = 'AudioRender_';
let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const driver = Driver.create();

async function runTest(testCaseName: string, buttonText: string, delayTime: number, description: string,
  done: Function) {
  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, begin`);

  let btnAccept = await driver.findComponent(ON.text(buttonText));
  if (btnAccept !== undefined) {
    await btnAccept.click();
    await driver.delayMs(delayTime);
  }
  else {
    await driver.delayMs(delayTime);
  }

  hilog.info(DOMAIN, TAG, BUNDLE + `${description}, end`);
  done();
}

export default function AudioRenderTest() {
  describe('AudioRenderTest', () => {
    beforeAll(() => {
      abilityDelegator.startAbility({
        bundleName: 'com.example.myapplication',
        abilityName: 'EntryAbility'
      });
    })
    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})

    /**
     * @tc.number AudioRender_CreateStream_0001
     * @tc.name AudioRender_CreateStream_0001
     * @tc.desc Create audio render stream
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRender_CreateStream_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRender_CreateStream_0001',
        '创建播放流',
        3000,
        'AudioRender_CreateStream',
        done
      );
    })

    /**
     * @tc.number AudioRender_DestroyStream_0001
     * @tc.name AudioRender_DestroyStream_0001
     * @tc.desc Destroy audio render stream
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRender_DestroyStream_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRender_DestroyStream_0001',
        '销毁播放流',
        3000,
        'AudioRender_DestroyStream',
        done
      );
    })

    /**
     * @tc.number AudioRender_SetVolume_0001
     * @tc.name AudioRender_SetVolume_0001
     * @tc.desc Set audio render volume
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRender_SetVolume_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRender_SetVolume_0001',
        '设置音量',
        3000,
        'AudioRender_SetVolume',
        done
      );
    })

    /**
     * @tc.number AudioRender_SetLatencyMode_0001
     * @tc.name AudioRender_SetLatencyMode_0001
     * @tc.desc Set audio latency mode
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRender_SetLatencyMode_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRender_SetLatencyMode_0001',
        '设置时延模式',
        3000,
        'AudioRender_SetLatencyMode',
        done
      );
    })

    /**
     * @tc.number AudioRender_GetLatencyMode_0001
     * @tc.name AudioRender_GetLatencyMode_0001
     * @tc.desc Get audio latency mode
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRender_GetLatencyMode_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRender_GetLatencyMode_0001',
        '获取时延模式',
        3000,
        'AudioRender_GetLatencyMode',
        done
      );
    })

    /**
     * @tc.number AudioRender_CreateWorkgroup_0001
     * @tc.name AudioRender_CreateWorkgroup_0001
     * @tc.desc Create audio workgroup
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRender_CreateWorkgroup_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRender_CreateWorkgroup_0001',
        '创建工作组',
        3000,
        'AudioRender_CreateWorkgroup',
        done
      );
    })

    /**
     * @tc.number AudioRender_ProcessWorkgroup_0001
     * @tc.name AudioRender_ProcessWorkgroup_0001
     * @tc.desc Process audio workgroup
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRender_ProcessWorkgroup_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRender_ProcessWorkgroup_0001',
        '处理工作组',
        3000,
        'AudioRender_ProcessWorkgroup',
        done
      );
    })

    /**
     * @tc.number AudioRender_RegistCallback1_0001
     * @tc.name AudioRender_RegistCallback1_0001
     * @tc.desc Test custom callback registration method
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRender_RegistCallback1_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRender_RegistCallback1_0001',
        '自定义的回调方法',
        3000,
        'AudioRender_RegistCallback1',
        done
      );
    })

    /**
     * @tc.number AudioRender_RegistCallback2_0001
     * @tc.name AudioRender_RegistCallback2_0001
     * @tc.desc Test null-pointer-initialized callback method
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRender_RegistCallback2_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRender_RegistCallback2_0001',
        '空指针初始化回调方法',
        3000,
        'AudioRender_RegistCallback2',
        done
      );
    })

    /**
     * @tc.number AudioRender_CreateRenderWithDualCallback_0001
     * @tc.name AudioRender_CreateRenderWithDualCallback_0001
     * @tc.desc Create audio renderer with dual write callbacks
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('AudioRender_CreateRenderWithDualCallback_0001', Level.LEVEL1, async (done: Function) => {
      await runTest(
        'AudioRender_CreateRenderWithDualCallback_0001',
        '设置同时写入回调',
        3000,
        'AudioRender_CreateRenderWithDualCallback',
        done
      );
    })
  })
}
