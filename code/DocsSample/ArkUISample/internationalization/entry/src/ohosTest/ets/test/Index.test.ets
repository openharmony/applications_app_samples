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

import { describe, it, expect, beforeAll, Level } from '@ohos/hypium';
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let want: Want;

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}
export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async (done: Function) => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
    })

    /**
     * @tc.number UiTest_001
     * @tc.name InterfaceLayoutBorderSettings001
     * @tc.desc 点击界面布局和边框设置
     */
    it('InterfaceLayoutBorderSettings001', Level.LEVEL1, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let str = await getResourceString($r('app.string.Interface_Layout_Border_Settings'));
      let openModel = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await openModel.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    })
    /**
     * @tc.number UiTest_001
     * @tc.name CustomizeCanvasComponentDrawing001
     * @tc.desc 点击自定义绘制Canvas组件
     */
    it('CustomizeCanvasComponentDrawing001', Level.LEVEL1, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let str = await getResourceString($r('app.string.Customize_Canvas_Component_Drawing'));
      let openModel = await driver.findComponent(ON.text(str, MatchPattern.CONTAINS));
      await openModel.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      done();
    })
  })
}