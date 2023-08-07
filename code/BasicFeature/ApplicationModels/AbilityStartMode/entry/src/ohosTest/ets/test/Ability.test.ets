/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';
import { describe, it, expect } from '@ohos/hypium'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';

const DRIVER = Driver.create();

// 结果需要使用aa工具查看，这里仅测试UI部分是否展示正常
export default function abilityTest() {
  describe('ActsAbilityTest', function () {

    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async function (done) {
      hilog.info(0xF811, 'testTag', 'StartAbility_001 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.startmode',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(0xF811, 'testTag', 'StartAbility_001 end');
    })

    /**
     * 检查页面
     */
    it('CheckPage_001', 0, async function () {
      hilog.info(0xF811, 'testTag', 'CheckPage_001 begin');
      await DRIVER.delayMs(1000);
      // 检查是否存在这三个板块
      await DRIVER.assertComponentExist(ON.text('普通多实例'));
      await DRIVER.assertComponentExist(ON.text('指定多实例'));
      await DRIVER.assertComponentExist(ON.text('单实例'));
      hilog.info(0xF811, 'testTag', 'CheckPage_001 end');
    })

    /**
     * 进入详情页
     */
    it('CheckDetailPage_001', 0, async function () {
      hilog.info(0xF811, 'testTag', 'CheckDetailPage_001 begin');
      await DRIVER.delayMs(1000);
      // 点击番茄
      await DRIVER.assertComponentExist(ON.text('番茄'));
      let tomato = await DRIVER.findComponent(ON.text('番茄'));
      await tomato.click();
      await DRIVER.delayMs(1000);
      // 断言存在text为番茄的组件
      await DRIVER.assertComponentExist(ON.text('番茄'));
      await DRIVER.assertComponentExist(ON.id('ContentTable'));
      let contentTable = await DRIVER.findComponent(ON.id('ContentTable'));
      let contentTablePoint = await contentTable.getBoundsCenter();
      // 向左滑动
      await DRIVER.fling({
        x: contentTablePoint.x + 200, y: contentTablePoint.y
      }, {
        x: contentTablePoint.x - 200, y: contentTablePoint.y
      }, 50, 200);
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('CaloriesProgress'));
      await DRIVER.assertComponentExist(ON.id('detailPage'));
      let detailPage = await DRIVER.findComponent(ON.id('detailPage'));
      let detailPagePoint = await detailPage.getBoundsCenter();
      // 向下滑动
      await DRIVER.fling({
        x: detailPagePoint.x, y: detailPagePoint.y + 100
      }, {
        x: detailPagePoint.x, y: detailPagePoint.y - 100
      }, 100, 200);
      await DRIVER.assertComponentExist(ON.text('黄瓜'));
      hilog.info(0xF811, 'testTag', 'CheckDetailPage_001 end');
    })

    /**
     * 进入另个一个详情页
     */
    it('CheckDetailPage_002', 0, async function () {
      hilog.info(0xF811, 'testTag', 'CheckDetailPage_002 begin');
      // 点击黄瓜
      await DRIVER.delayMs(1000);
      let cucumber = await DRIVER.findComponent(ON.text('黄瓜'));
      await cucumber.click();
      await DRIVER.assertComponentExist(ON.text('黄瓜'));
      await DRIVER.assertComponentExist(ON.text('Food Detail'));
      hilog.info(0xF811, 'testTag', 'CheckDetailPage_002 end');
    })
  })
}