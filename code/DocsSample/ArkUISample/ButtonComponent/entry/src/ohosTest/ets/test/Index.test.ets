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
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
let driver: Driver;
const DOMAIN = 0xF811;
const TAG = '[Sample_Button_Component]'
const BUNDLE = 'ButtonComponent'

export default function ArcButtonTest() {
  describe('ArcButtonTest', () => {
    beforeAll(async () => {
      // 启动应用
      let want: Want = {
        bundleName: "com.samples.buttoncomponent",
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1000);

      // 验证当前页面是否正确
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /**
     * @tc.number LoadList_001
     * @tc.name test Load List
     * @tc.desc 测试首页加载是否成功
     */
    it(BUNDLE + 'LoadList_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "LoadList_001, begin");
      const title = await driver.findComponent(ON.text('Show List'));
      expect(title === null).assertFalse();
      const list = await driver.findComponent(ON.type('List'));
      expect(list === null).assertFalse();
      hilog.info(DOMAIN, TAG, BUNDLE + "LoadList_001, end");
      done();
    });

    /**
     * @tc.number ButtonClick_001
     * @tc.name test Top ArcButton And onClick Event
     * @tc.desc 测试创建上弧形按钮和点击事件
     */
    it(BUNDLE + 'ButtonClick_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "ButtonClick_001, begin");
      const listItem = await driver.findComponent(ON.text('ButtonAlignTop'));
      expect(listItem === null).assertFalse();
      await listItem.click();
      await driver.delayMs(1000);
      const arcButton = await driver.findComponent(ON.text('OK'));
      expect(arcButton === null).assertFalse();
      await arcButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + "ButtonClick_001, end");
      done();
    });

    /**
     * @tc.number ButtonTouch_001
     * @tc.name test Bottom ArcButton And onTouch Event
     * @tc.desc 测试创建下弧形按钮和触摸事件
     */
    it(BUNDLE + 'ButtonTouch_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "ButtonTouch_001, begin");
      const listItem = await driver.findComponent(ON.text('ButtonAlignBottom'));
      expect(listItem === null).assertFalse();
      await listItem.click();
      await driver.delayMs(1000);
      const arcButton = await driver.findComponent(ON.text('OK'));
      expect(arcButton === null).assertFalse();
      await arcButton.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + "ButtonTouch_001, end");
      done();
    });

    /**
     * @tc.number SetBackgroundColor_001
     * @tc.name test ArcButton Set BackgroundColor
     * @tc.desc 测试弧形按钮设置背景色
     */
    it(BUNDLE + 'SetBackgroundColor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "SetBackgroundColor_001, begin");
      const listItem = await driver.findComponent(ON.text('ButtonBcgColor'));
      expect(listItem === null).assertFalse();
      await listItem.click();
      await driver.delayMs(1000);
      const arcButton = await driver.findComponent(ON.text('OK'));
      expect(arcButton === null).assertFalse();
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + "SetBackgroundColor_001, end");
      done();
    });

    /**
     * @tc.number SetFontColor_001
     * @tc.name test ArcButton Set FontColor
     * @tc.desc 测试弧形按钮设置字体颜色
     */
    it(BUNDLE + 'SetFontColor_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "SetFontColor_001, begin");
      const listItem = await driver.findComponent(ON.text('ButtonFontColor'));
      expect(listItem === null).assertFalse();
      await listItem.click();
      await driver.delayMs(1000);
      const arcButton = await driver.findComponent(ON.text('OK'));
      expect(arcButton === null).assertFalse();
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + "SetFontColor_001, end");
      done();
    });

    /**
     * @tc.number SetShadow_001
     * @tc.name test ArcButton Set Shadow
     * @tc.desc 测试弧形按钮设置阴影和颜色
     */
    it(BUNDLE + 'SetShadow_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "SetShadow_001, begin");
      const listItem = await driver.findComponent(ON.text('ButtonShadow'));
      expect(listItem === null).assertFalse();
      await listItem.click();
      await driver.delayMs(1000);
      const arcButton = await driver.findComponent(ON.text('OK'));
      expect(arcButton === null).assertFalse();
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + "SetShadow_001, end");
      done();
    });

    /**
     * @tc.number ChangeValue_001
     * @tc.name test ArcButton Change The Interface Value
     * @tc.desc 测试弧形按钮更改界面值
     */
    it(BUNDLE + 'ChangeValue_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "ChangeValue_001, begin");
      const listItem = await driver.findComponent(ON.text('ButtonBrightness'));
      expect(listItem === null).assertFalse();
      await listItem.click();
      await driver.delayMs(1000);
      let str = delegator.getAppContext().resourceManager.getStringByNameSync('Reset');
      const arcButton = await driver.findComponent(ON.text(str));
      expect(arcButton === null).assertFalse();
      await arcButton.click();
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + "ChangeValue_001, end");
      done();
    });
  });
}