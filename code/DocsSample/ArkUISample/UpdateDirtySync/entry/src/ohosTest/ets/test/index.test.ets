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

import { describe, it, expect, beforeAll, Level } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MatchPattern, On, Component } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';
import router from '@ohos.router';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;
const TAG = '[Sample_UpdateDirtySync]'
const DOMAIN = 0xF811
const BUNDLE = 'UpdateDirtySync'

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

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
      hilog.info(DOMAIN, TAG, BUNDLE + 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number UiTest_001
     * @tc.name applySyncUse
     * @tc.desc applySync接口使用规则
     * @tc.level: Level 1
     */

    it('applySyncUse', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: applySyncUse begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/ApplySyncUse' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.id('applySyncButton'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_002
     * @tc.name flushUpdatesUse
     * @tc.desc flushUpdates接口使用规则
     * @tc.level: Level 1
     */

    it('flushUpdatesUse', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: flushUpdatesUse begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/FlushUpdatesUse' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.id('flushUpdatesButton'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_003
     * @tc.name flushUIUpdatesUse
     * @tc.desc flushUIUpdates接口使用规则
     * @tc.level: Level 1
     */

    it('flushUIUpdatesUse', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: flushUIUpdatesUse begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/FlushUIUpdatesUse' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.id('flushUIUpdatesButton'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_004
     * @tc.name applySyncNestApplySync
     * @tc.desc applySync接口中嵌套applySync
     * @tc.level: Level 1
     */

    it('applySyncNestApplySync', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: applySyncNestApplySync begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/ApplySyncNestApplySync' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.id('ApplySyncNestApplySync'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_005
     * @tc.name applySyncNestOthers
     * @tc.desc applySync接口中嵌套flushUpdates/flushUIUpdates
     * @tc.level: Level 1
     */

    it('applySyncNestOthers', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: applySyncNestOthers begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/ApplySyncNestOthers' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.id('ApplySyncNestOthers'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_006
     * @tc.name callInComputed
     * @tc.desc 不允许在@Computed中调用applySync/flushUpdates/flushUIUpdates
     * @tc.level: Level 1
     */

    it('callInComputed', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: callInComputed begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/CallInComputed' });
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_007
     * @tc.name callInMonitor
     * @tc.desc 不允许在@Monitor中调用flushUpdates/flushUIUpdates
     * @tc.level: Level 1
     */

    it('callInMonitor', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: callInMonitor begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/CallInMonitor' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.id('CallInMonitor'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_008
     * @tc.name animateToUse
     * @tc.desc 动效场景
     * @tc.level: Level 1
     */

    it('animateToUse', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: animateToUse begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/AnimateToUse' });
      await driver.delayMs(1000);
      let btn = await driver.findComponent(ON.id('AnimateToUse'));
      await btn.click();
      await driver.delayMs(1000);
      done();
    });

    /**
     * @tc.number UiTest_009
     * @tc.name pageUse
     * @tc.desc 路由场景
     * @tc.level: Level 1
     */

    it('pageUse', Level.LEVEL1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'uitest: pageUse begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await router.pushUrl({ url: 'pages/PageUse' });
      await driver.delayMs(1000);
      let btn1 = await driver.findComponent(ON.id('PageOne'));
      await btn1.click();
      await driver.delayMs(2000);
      let btn2 = await driver.findComponent(ON.id('PageTwo'));
      await btn2.click();
      await driver.delayMs(1000);
      done();
    });
  })
}