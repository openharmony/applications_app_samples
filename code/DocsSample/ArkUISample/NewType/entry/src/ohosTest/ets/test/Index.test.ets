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
import { abilityDelegatorRegistry, Driver, ON, MouseButton, Component, MatchPattern, Point,
  UiWindow } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';


const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator()
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

async function getCenterPoint(comp: Component, offset: number): Promise<Point> {
  // 获取文件控件边框
  let rect = await comp.getBounds();
  // 计算文字控件高度
  let height = rect.bottom - rect.top;
  // 获取文字控件中心点
  let point: Point = await comp.getBoundsCenter();
  point = {x: point.x, y:point.y - height*offset};
  return point;
}

export default function IndexTest() {

  describe('IndexTest', () => {

    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    it('testNewType', 0, async (done: Function) => {
      console.info("uitest: testNewType begin");
      let driver = Driver.create();
      let formManager: Component = await driver.findComponent(ON.type('Text'));
      let pointManager: Point = await getCenterPoint(formManager, 0);
      await driver.click(pointManager.x, pointManager.y);
      await sleep(1000);
      await driver.swipe(639, 2772, 625, 2503, 600);
      await sleep(1000);
      await driver.swipe(832, 1912, 418, 1860, 2000);
      await sleep(1000);
      await driver.swipe(640, 2200, 631, 871, 2000);
      await driver.pressBack();
      await sleep(1000);
      await sleep(1000);
      await driver.assertComponentExist(ON.text('NewType').within(ON.type('GridItem')));
      let com: Component = await driver.findComponent(ON.text('NewType').within(ON.type('GridItem')));
      let pointCom: Point = await getCenterPoint(com, 2);
      await driver.click(pointCom.x, pointCom.y);
      await sleep(2000);
      done();
    })

  })
}