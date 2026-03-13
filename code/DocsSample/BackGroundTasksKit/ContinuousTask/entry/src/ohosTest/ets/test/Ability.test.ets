/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[Sample_ContinuousTask]'
const DOMAIN = 0xF811
const BUNDLE = 'ContinuousTask_'


export default function abilityTest() {
  describe('ActsAbilityTest', ()=>{
    /**
     * 打开应用
     */
    it('StartAbility_001', 0, async  ()=> {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.continuoustask',
          abilityName: 'MainAbility'
        });
      } catch (expection) {
        expect(0).assertEqual(expection.code);
        hilog.info(DOMAIN, TAG, 'StartAbility end err:' + JSON.stringify(expection));
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 开启/取消长时任务
     */
    it('StartAndStopContinuousTaskFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAndStopContinuousTaskFunction_001 begin');
      let driver = Driver.create();
      setTimeout(async ()=>{
        await driver.delayMs(1000);
        // 点击申请长时任务
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAndStopContinuousTaskFunction_001 clickApply');
        await driver.assertComponentExist(ON.id('applyContinuousTask'));
        let apply = await driver.findComponent(ON.id('applyContinuousTask'));
        await apply.click();
        await driver.delayMs(2000);
        // 点击取消长时任务
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAndStopContinuousTaskFunction_001 clickReset');
        await driver.assertComponentExist(ON.id('resetContinuousTask'));
        let reset = await driver.findComponent(ON.id('resetContinuousTask'));
        await reset.click();
        await driver.delayMs(1000);
        // 将应用退出到桌面
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAndStopContinuousTaskFunction_001 outToHome');
        await driver.click(360, 1245);
        await driver.delayMs(2000);
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAndStopContinuousTaskFunction_001 end');
      },1000)
    })

    /**
     * 播放/暂停音乐
     */
    it('PlayAndPauseMusic', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PlayAndPauseMusic begin');
      let driver = Driver.create();
      setTimeout(async ()=>{
        await driver.delayMs(1000);
        // 进入应用
        hilog.info(DOMAIN, TAG, BUNDLE + 'PlayAndPauseMusic enter');
        await driver.assertComponentExist(ON.text(String($r('app.string.Continuous_task'))));
        let btnEnter = await driver.findComponent(ON.text(String($r('app.string.Continuous_task'))));
        await btnEnter.click();
        await driver.delayMs(2000);
        // 点击播放/暂停按钮，开始播音
        hilog.info(DOMAIN, TAG, BUNDLE + 'PlayAndPauseMusic clickPlay');
        await driver.assertComponentExist(ON.id('playAndPause'));
        let play = await driver.findComponent(ON.id('playAndPause'));
        await play.click();
        await driver.delayMs(2000);
        // 再次点击播放/暂停按钮，暂停播音
        hilog.info(DOMAIN, TAG, BUNDLE + 'PlayAndPauseMusic clickPause');
        await driver.assertComponentExist(ON.id('playAndPause'));
        let pause = await driver.findComponent(ON.id('playAndPause'));
        await pause.click();
        await driver.delayMs(2000);
      },2000)
    })
  })
}
