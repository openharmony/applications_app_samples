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

import { Driver, ON } from '@ohos.UiTest';
import Logger from '../../../main/ets/Utils/Logger';
import { describe, it, expect, beforeAll } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const DRIVER=Driver.create();
const TAG = '[Sample_FormGame]';
const BUNDLE = 'FormGame_';
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest(){
  describe('ActsAbilityTest',() => {

    /**
     * 添加卡片到桌面功能验证
     */
    it('FormGame_OpenFormList_001',0,async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'FormGame_OpenFormList_001 begin');
      let ability = await abilityDelegatorRegistry.getCurrentTopAbility();
      let manager = ability.context.resourceManager;
      await DRIVER.delayMs(1000);
      await DRIVER.pressBack();
      await DRIVER.delayMs(2000);
      //找到娱乐卡片并且长按
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.Entertainment_card'))));
      let app=await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.Entertainment_card'))));
      // 获取文字控件边框
      let rect = await app.getBounds();
      // 计算文字控件高度
      let height = rect.bottom - rect.top;
      // 获取文字控件中心点
      let point = await app.getBoundsCenter();
      await DRIVER.longClick(point.x, point.y - height);
      await DRIVER.delayMs(1000);
      // 点击列表中的服务卡片
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.Service_card'))));
      let formBtn=await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.Service_card'))));
      await formBtn.click();
      await DRIVER.delayMs(1000);
      // 点击添加到桌面按钮
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.Add_to_table'))));
      let addToDesk = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.Add_to_table'))));
      await addToDesk.click();
      await DRIVER.delayMs(2000);
      // 检查桌面上的娱乐卡片数量
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.Entertainment_card'))));
      let resultArray=await DRIVER.findComponents(ON.text(await manager.getStringValue($r('app.string.Entertainment_card'))));
      expect(resultArray.length).assertEqual(2); // 桌面上本来安装的娱乐卡片，加上添加的接龙游戏娱乐卡片，一个可以找到两个娱乐卡片
      done();
      Logger.info(TAG, BUNDLE + 'FormGame_OpenFormList_001 end');
    })
  })
}




