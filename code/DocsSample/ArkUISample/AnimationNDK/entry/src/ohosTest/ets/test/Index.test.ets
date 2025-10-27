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
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import { UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
let driver: Driver;
const DOMAIN = 0xF811;
const TAG = '[Sample_Animation_NDK]';
const BUNDLE = 'AnimationNDK';
let want: Want;

export default function AnimationNdkTest() {
  describe('AnimationNdkTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: "com.sample.myapplication",
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number LoadList_001
     * @tc.name test Load List
     * @tc.desc 测试首页加载是否成功
     */
    it(BUNDLE + 'LoadList_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "LoadList_001, begin");
      await driver.delayMs(1000);
      const title = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(title === null).assertFalse();
      hilog.info(DOMAIN, TAG, BUNDLE + "LoadList_001, end");
      done();
    });

    /**
     * @tc.number TransitionAnimation_001
     * @tc.name test TransitionAnimation
     * @tc.desc 测试TransitionAnimation页面功能
     */
    it(BUNDLE + 'TransitionAnimation_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "TransitionAnimation_001, begin");
      await driver.delayMs(1000);
      const title = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(title === null).assertFalse();
      const transition = await driver.findComponent(ON.text('TransitionAnimation', MatchPattern.CONTAINS));
      expect(transition === null).assertFalse();
      await transition.click();
      await driver.delayMs(1000);
      const nativeButton = await driver.findComponent(ON.text('Native', MatchPattern.CONTAINS));
      expect(nativeButton === null).assertFalse();
      await nativeButton.click();
      await driver.delayMs(1000);
      const showButton = await driver.findComponent(ON.text('show', MatchPattern.CONTAINS));
      expect(showButton === null).assertFalse();
      await showButton.click();
      await driver.delayMs(1000);
      const hideButton = await driver.findComponent(ON.text('hide'));
      expect(hideButton === null).assertFalse();
      await hideButton.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + "TransitionAnimation_001, end");
      await driver.pressBack();
      done();
    });

    /**
     * @tc.number UseFrameAnimation_001
     * @tc.name test UseFrameAnimation
     * @tc.desc 展示UseFrameAnimation_001页面
     */
    it(BUNDLE + 'UseFrameAnimation_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "UseFrameAnimation_001, begin");
      await driver.delayMs(1000);
      const title = await driver.findComponent(ON.text('List', MatchPattern.CONTAINS));
      expect(title === null).assertFalse();
      const transition = await driver.findComponent(ON.text('UseFrameAnimation', MatchPattern.CONTAINS));
      expect(transition === null).assertFalse();
      await transition.click();
      await driver.delayMs(1000);
      const nativeButton = await driver.findComponent(ON.text('Native', MatchPattern.CONTAINS));
      expect(nativeButton === null).assertFalse();
      await nativeButton.click();
      await driver.delayMs(1000);
      const hideButton = await driver.findComponent(ON.text('Hide', MatchPattern.CONTAINS));
      expect(hideButton === null).assertFalse();
      await hideButton.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + "UseFrameAnimation_001, end");
      await driver.pressBack();
      done();
    });
  });
}