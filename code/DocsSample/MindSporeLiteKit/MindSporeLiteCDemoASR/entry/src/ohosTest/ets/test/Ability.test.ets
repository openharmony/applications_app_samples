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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import Want from '@ohos.app.ability.Want';
import Base from '@ohos.base';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';

const BUNDLE = 'MSLiteWhisperDemo_';
const TAG = 'abilityTest';
const domain: number = 0xF811;
const answer1 = '播放示例音频';
const answer2 = '识别示例音频';

export default function abilityTest() {
  let driver: Driver = Driver.create();
  describe('MSLiteWhisperDemoTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    /*
         * @tc.number: MSLiteWhisperDemoTest_000
         * @tc.name: Start Ability
         * @tc.desc: Start Ability
         * @tc.size: MediumTest
         * @tc.type: Function
         * @tc.level Level 1
         */
    it('EntryAbility', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'EntryAbility_001 begin');
      // 开启应用
      let want: Want = {
        bundleName: 'com.example.cdemo_test',
        abilityName: 'EntryAbility'
      };
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err: Base.BusinessError) => {
        hilog.info(domain, TAG, 'StartAbility get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      await driver.delayMs(3000);
      hilog.info(domain, TAG, BUNDLE + 'EntryAbility_001 end');
      done();
    })
    /**
     * @tc.number     : MSLiteWhisperDemoTest_001
     * @tc.name       : IfExists
     * @tc.desc       : IfExists
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('IfExists', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'IfExists_001 begin');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('MSLite Whisper Demo'));
      await driver.assertComponentExist(ON.text(answer1));
      await driver.assertComponentExist(ON.text(answer2));
      expect(true).assertTrue();
      hilog.info(domain, TAG, BUNDLE + 'IfExists_001 end');
      done();
    })

    /**
     * @tc.number     : MSLiteWhisperDemoTest_002
     * @tc.name       : Play the recording
     * @tc.desc       : Play the recording
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('RecordingPlay', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'RecordingPlay_001 begin');
      await driver.delayMs(1000);
      // 点击播放示例音频按钮
      hilog.info(domain, TAG, BUNDLE + 'RecordingPlay_001 click play button');
      await driver.assertComponentExist(ON.text('播放示例音频'));
      let msPlay = await driver.findComponent(ON.text('播放示例音频'));
      await msPlay.click();
      await driver.delayMs(1000);
      expect(true).assertTrue();
      hilog.info(domain, TAG, BUNDLE + 'RecordingPlay_001 end');
      done();
    })

    /**
     * @tc.number     : MSLiteWhisperDemoTest_003
     * @tc.name       : RecordingPredict
     * @tc.desc       : RecordingPredict
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('RecordingPredict', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'RecordingPredict_001 begin');
      await driver.delayMs(1000);
      // 点击'识别示例音频'按钮
      hilog.info(domain, TAG, BUNDLE + 'RecordingPredict_001 click predict button');
      await driver.assertComponentExist(ON.text('识别示例音频'));
      let msPredict = await driver.findComponent(ON.text('识别示例音频'));
      await msPredict.click();
      await driver.delayMs(5000);

      // 语音识别
      await driver.assertComponentExist(ON.text('识别内容', 1))
      await driver.assertComponentExist(ON.text('我认为跑步最重要的就是给我带来了身体健康', 1));
      await driver.delayMs(5000);
      expect(true).assertTrue();
      hilog.info(domain, TAG, BUNDLE + 'RecordingPredict_001 end');
      done();
    })
  })
}
