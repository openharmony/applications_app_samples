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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';

const LOG_PRINT_DOMAIN:  number = 0xFF00;
const PREFIX: string = '[Test]'

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let driver: Driver;
let want: Want;

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let textString: string = await manage.getStringValue(resource);
  return textString;
}

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      // 启动应用
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1000);

      // 验证当前页面是否正确
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /**
     * @tc.number: DrawModifier_001
     * @tc.name: testHomePageLoad
     * @tc.desc: To test creat first page
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('testHomePageLoad', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'DrawModifierTest: testHomePageLoad begin');

      // 验证标题存在
      const title = await driver.findComponent(ON.text('Show Image'));
      expect(title === null).assertFalse();

      // 验证列表存在
      const list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();

      hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'ImageTest: testHomePageLoad end');
      done();
    });

    /**
     * @tc.number: DrawModifier_002
     * @tc.name: testdrawFront_drawContent_drawBehind
     * @tc.desc: To test drawFront、drawContent、drawBehind interface
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('testdrawFront_drawContent_drawBehind', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'ImageTest: testdrawFront_drawContent_drawBehind begin');

      const startTime = new Date().getTime();

      // 点击第一个项目
      const firstItem = await driver.findComponent(ON.text('drawFront_drawContent_drawBehind'));
      await firstItem.click();

      // 等待新页面加载完成
      await driver.delayMs(1000);
      let str = await getResourceString($r('app.string.play'));
      let sampleButton = await driver.findComponent(ON.text("play", MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);

      str = await getResourceString($r('app.string.changeModifier'));
      sampleButton = await driver.findComponent(ON.text("changeModifier", MatchPattern.CONTAINS));
      expect(sampleButton === null).assertFalse();
      await sampleButton.click();
      await driver.delayMs(1000);
      sampleButton = await driver.findComponent(ON.text("play", MatchPattern.CONTAINS));
      await driver.delayMs(1000);

      await driver.pressBack();

      hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'ImageTest: testdrawFront_drawContent_drawBehind end');
      done();
    });

    /**
     * @tc.number: DrawModifier_003
     * @tc.name: testdrawForeground
     * @tc.desc: To test drawForeground interface
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('testdrawForeground', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'ImageTest: testdrawForeground begin');

      const startTime = new Date().getTime();

      // 点击第一个项目
      const firstItem = await driver.findComponent(ON.text('drawForeground_index'));

      // 等待新页面加载完成
      await driver.delayMs(1000);
      const endTime = new Date().getTime();

      const loadTime = endTime - startTime;
      hilog.info(LOG_PRINT_DOMAIN, PREFIX, `Page load time: ${loadTime}ms`);
      expect(loadTime < 3000).assertTrue(); // 加载时间应小于3秒

      await driver.pressBack();

      hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'ImageTest: testdrawForeground end');
      done();
    });

    /**
     * @tc.number: DrawModifier_004
     * @tc.name: testCanvas
     * @tc.desc: To test Canvas
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     */
    it('testCanvas', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
      hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'ImageTest: testCanvas begin');

      const startTime = new Date().getTime();

      // 点击第一个项目
      const firstItem = await driver.findComponent(ON.text('Canvas_index'));

      // 等待新页面加载完成
      await driver.delayMs(1000);
      const endTime = new Date().getTime();

      const loadTime = endTime - startTime;
      hilog.info(LOG_PRINT_DOMAIN, PREFIX, `Page load time: ${loadTime}ms`);
      expect(loadTime < 3000).assertTrue(); // 加载时间应小于3秒

      await driver.pressBack();

      hilog.info(LOG_PRINT_DOMAIN, PREFIX, 'ImageTest: testCanvas end');
      done();
    });
  });
}