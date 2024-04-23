/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';

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
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
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
     * 开启长时任务
     */
    it('StartContinuousTaskFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartContinuousTaskFunction_001 begin');
      let driver = Driver.create();
      setTimeout(async ()=>{
        await driver.delayMs(1000);
        // 下拉菜单先清除所有通知
        await driver.swipe(100, 10, 100, 500, 600);
        await driver.delayMs(1000);
        await driver.click(360,1080);
        await driver.swipe(100, 500, 100, 10, 600);
        await driver.delayMs(1000);
        // 点击播放开启长时任务
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartContinuousTaskFunction_001 clickPlay');
        await driver.assertComponentExist(ON.id('image1'));
        let play = await driver.findComponent(ON.id('image1'));
        await play.click();
        await driver.delayMs(2000);
        // 点击上一首
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartContinuousTaskFunction_001 clickPrevious');
        await driver.assertComponentExist(ON.id('image0'));
        let previous = await driver.findComponent(ON.id('image0'));
        await previous.click();
        await driver.delayMs(1000);
        // 点击下一首
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartContinuousTaskFunction_001 clickNext');
        await driver.assertComponentExist(ON.id('image2'));
        let next = await driver.findComponent(ON.id('image2'));
        await next.click();
        await driver.delayMs(1000);
        // 下拉菜单栏查看长时任务开启情况
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartContinuousTaskFunction_001 checkStart');
        await driver.swipe(100, 10, 100, 500, 600);
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text(String($r('app.string.Continuous_task'))));
        await driver.delayMs(1000);
        await driver.swipe(100, 500, 100, 10, 600);
        await driver.delayMs(1000);
        // 将应用退出到桌面
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartContinuousTaskFunction_001 outToHome');
        await driver.click(360, 1245);
        await driver.delayMs(2000);
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartContinuousTaskFunction_001 end');
      },1000)
    })

    /**
     * 结束长时任务
     */
    it('StopContinuousTaskFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StopContinuousTaskFunction_001 begin');
      let driver = Driver.create();
      setTimeout(async ()=>{
        await driver.delayMs(1000);
        // 进入应用
        hilog.info(DOMAIN, TAG, BUNDLE + 'StopContinuousTaskFunction_001 enter');
        await driver.assertComponentExist(ON.text(String($r('app.string.Continuous_task'))));
        let btnEnter = await driver.findComponent(ON.text(String($r('app.string.Continuous_task'))));
        await btnEnter.click();
        await driver.delayMs(2000);
        // 点击暂停结束长时任务
        hilog.info(DOMAIN, TAG, BUNDLE + 'StopContinuousTaskFunction_001 clickPause');
        await driver.assertComponentExist(ON.id('image1'));
        let pause = await driver.findComponent(ON.id('image1'));
        await pause.click();
        await driver.delayMs(2000);
        // 下拉菜单栏查看长时任务关闭情况
        hilog.info(DOMAIN, TAG, BUNDLE + 'StopContinuousTaskFunction_001 checkStop');
        await driver.swipe(100, 10, 100, 500, 600);
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text(String($r('app.string.Without_notification'))));
        await driver.delayMs(1000);
        await driver.swipe(100, 500, 100, 10, 600);
        await driver.delayMs(1000);
        hilog.info(DOMAIN, TAG, BUNDLE + 'StopContinuousTaskFunction_001 end');
      },2000)
    })
  })
}
