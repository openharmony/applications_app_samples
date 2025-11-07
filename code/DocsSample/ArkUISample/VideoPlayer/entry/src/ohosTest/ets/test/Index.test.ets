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

import { describe, it, expect, beforeAll } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import hilog from '@ohos.hilog';
import { UIAbility, Want } from '@kit.AbilityKit';

const TAG = '[Sample_VideoPlayer]';
const DOMAIN = 0xF811;
const BUNDLE = 'VideoPlayer_';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number VideoPlayerTest_001
     * @tc.name testVideoPlayer
     * @tc.desc 测试视频播放是否显示正常
     */
    it('VideoPlayerTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoPlayerTest_001 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('AttributeVideo', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      let button1 = await driver.findComponent(ON.text('CustomizedControl', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      let button2 = await driver.findComponent(ON.text('DataAbility', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      let button3 = await driver.findComponent(ON.text('EventCall', MatchPattern.CONTAINS));
      await button3.click();
      await driver.pressBack();
      let button4 = await driver.findComponent(ON.text('LocalVideo', MatchPattern.CONTAINS));
      await button4.click();
      await driver.pressBack();
      let button5 = await driver.findComponent(ON.text('OnlineVideo', MatchPattern.CONTAINS));
      await button5.click();
      await driver.pressBack();
      let button6 = await driver.findComponent(ON.text('Sandbox', MatchPattern.CONTAINS));
      await button6.click();
      await driver.pressBack();
      let button7 = await driver.findComponent(ON.text('VideoControl', MatchPattern.CONTAINS));
      await button7.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoPlayerTest_001 end');
      done();
    })
  })
}