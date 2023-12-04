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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import { logger } from '../util/Logger';
import inputMethod from '@ohos.inputMethod';
import Want from '@ohos.app.ability.Want';

const TAG = '[Sample_DistributedRdb]';
const BUNDLE = 'DistributedRdb_';

export default function abilityTest() {
  let driver = Driver.create();
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  describe('ActsAbilityTest', () => {
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let want: Want = {
        bundleName: "ohos.samples.distributedrdb",
        abilityName: "EntryAbility"
      };
      delegator.startAbility(want, (err) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    /**
     * 点击允许授权
     */
    it(BUNDLE + 'ClickAcceptFunction_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}ClickAcceptFunction_001 begin`);
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}ClickAcceptFunction_001 clickAccept`);
      // 点击允许
      await driver.assertComponentExist(ON.text('允许'));
      let btnAccept = await driver.findComponent(ON.text('允许'));
      await btnAccept.click();
      await driver.delayMs(2000);
      await delegator.getCurrentTopAbility().then((Ability) => {
        logger.info(TAG, `${BUNDLE}get top ability, ${Ability.context.abilityInfo.name}`);
        expect(Ability.context.abilityInfo.name).assertEqual('EntryAbility');
      })
      logger.info(TAG, `${BUNDLE}ClickAcceptFunction_001 end`);
      done();
    })

    /**
     * 设置页面
     */
    it(BUNDLE + 'Settings_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}Settings_001 begin`);
      await driver.delayMs(1000);
      // 点击右上角更多按钮、弹出菜单
      await driver.assertComponentExist(ON.id('rightBtn'));
      let btnMore = await driver.findComponent(ON.id('rightBtn'));
      await driver.delayMs(500);
      await btnMore.click();
      await driver.delayMs(1000);
      // 点击设置，进入设置页面
      await driver.assertComponentExist(ON.text('设置', MatchPattern.CONTAINS));
      let btnSetting = await driver.findComponent(ON.text('设置', MatchPattern.CONTAINS));
      await btnSetting.click();
      await driver.delayMs(1000);
      // 点击Switch开关设置同步方式
      await driver.assertComponentExist(ON.id('automaticToggle'));
      await driver.assertComponentExist(ON.id('manualToggle'));
      let automaticSwitch = await driver.findComponent(ON.id('automaticToggle'));
      let manualSwitch = await driver.findComponent(ON.id('manualToggle'));
      let isManual = await manualSwitch.isChecked();
      let isAutomatic = await automaticSwitch.isChecked();
      logger.info(TAG, `${BUNDLE}isManual=${isManual},isAutomatic=${isAutomatic}`);
      await automaticSwitch.click();
      await driver.delayMs(1000);
      let isManual1 = await manualSwitch.isChecked();
      let isAutomatic1 = await automaticSwitch.isChecked();
      logger.info(TAG, `${BUNDLE}isManual1=${isManual1},isAutomatic1=${isAutomatic1}`);
      await driver.pressBack();
      logger.info(TAG, `${BUNDLE}Settings_001 end`);
      done();
    })

    /**
     * 连接设备弹窗
     */
    it(BUNDLE + 'SelectDeviceDialog_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}SelectDeviceDialog_001 begin`);
      await driver.delayMs(1000)
      // 点击右上角更多按钮、弹出菜单
      await driver.assertComponentExist(ON.id('rightBtn'));
      let btnMore = await driver.findComponent(ON.id('rightBtn'));
      await driver.delayMs(500);
      await btnMore.click();
      await driver.delayMs(1000);
      // 点击设置，进入设置页面
      await driver.assertComponentExist(ON.text('连接设备', MatchPattern.CONTAINS));
      let btnSetting = await driver.findComponent(ON.text('连接设备', MatchPattern.CONTAINS));
      await btnSetting.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('选择设备', MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.text('取消', MatchPattern.CONTAINS));
      let btnCancel = await driver.findComponent(ON.text('取消', MatchPattern.CONTAINS));
      await btnCancel.click();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}SelectDeviceDialog_001 end`);
      done();
    })

    /**
     * 添加联系人
     */
    it(BUNDLE + 'AddContactFunction_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}AddContactFunction_001 begin`);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('btnAdd'));
      let btnAdd = await driver.findComponent(ON.id('btnAdd'));
      await btnAdd.click();
      await driver.delayMs(1000);
      // 添加联系人数据
      await driver.assertComponentExist(ON.text('性别', MatchPattern.CONTAINS));
      let inputTexts: Component[] = await driver.findComponents(ON.type('TextInput'));
      let inputMethodController = inputMethod.getController();
      await inputTexts[0].inputText('name1');
      inputMethodController.stopInputSession();
      let nameValue = await inputTexts[0].getText();
      logger.info(TAG, `AddContactFunction_001 name:${nameValue}`);
      expect(nameValue).assertEqual('name1');
      await inputTexts[1].inputText('13300000000');
      inputMethodController.stopInputSession();
      let phoneValue = await inputTexts[1].getText();
      logger.info(TAG, `AddContactFunction_001 phone:${phoneValue}`);
      expect(phoneValue).assertEqual('13300000000');
      await inputTexts[2].inputText('remark1');
      inputMethodController.stopInputSession();
      let remarkValue = await inputTexts[2].getText();
      logger.info(TAG, `AddContactFunction_001 remark:${remarkValue}`);
      expect(remarkValue).assertEqual('remark1');
      await inputTexts[3].inputText('11');
      inputMethodController.stopInputSession();
      let ageValue = await inputTexts[3].getText();
      logger.info(TAG, `AddContactFunction_001 age:${ageValue}`);
      expect(ageValue).assertEqual('11');
      await driver.assertComponentExist(ON.id('rightBtn'));
      let rightBtn = await driver.findComponent(ON.id('rightBtn'));
      await rightBtn.click();
      await driver.delayMs(1000);
      let list: Component[] = await driver.findComponents(ON.type('ListItem'));
      expect(list.length > 0).assertTrue();
      logger.info(TAG, `${BUNDLE}AddContactFunction_001 end`);
      done();
    })

    /**
     * 搜索联系人
     */
    it(BUNDLE + 'SearchContactFunction_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}SearchContactFunction_001 begin`);
      await driver.delayMs(1000)
      // 点击搜索框
      await driver.assertComponentExist(ON.id('searchBar'))
      let searchBar = await driver.findComponent(ON.id('searchBar'))
      await searchBar.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.type('TextInput'));
      let input: Component = await driver.findComponent(ON.type('TextInput'));
      let inputMethodController = inputMethod.getController();
      await input.inputText('133');
      inputMethodController.stopInputSession();
      let inputValue = await input.getText();
      logger.info(TAG, `AddContactConflictFunction_001 input:${inputValue}`);
      expect(inputValue).assertEqual('133');
      let btn: Component = await driver.findComponent(ON.type('Button'));
      await btn.click()
      let list: Component[] = await driver.findComponents(ON.type('ListItem'));
      expect(list.length > 0).assertTrue();
      await driver.pressBack();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}SearchContactFunction_001 end`);
      done();
    })

    /**
     * 添加联系人并解决联系人冲突（电话号码一样，联系人名称不一样）
     */
    it(BUNDLE + 'AddContactConflictFunction_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}AddContactConflictFunction_001 begin`);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('btnAdd'));
      let btnAdd = await driver.findComponent(ON.id('btnAdd'));
      await btnAdd.click();
      await driver.delayMs(500);

      // 添加联系人zhangsan
      await driver.assertComponentExist(ON.text('性别', MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.type('TextInput'));
      let inputTexts: Component[] = await driver.findComponents(ON.type('TextInput'));
      let inputMethodController = inputMethod.getController();
      await inputTexts[0].inputText('zhangsan');
      inputMethodController.stopInputSession();
      let nameValue = await inputTexts[0].getText();
      logger.info(TAG, `AddContactConflictFunction_001 name:${nameValue}`);
      expect(nameValue).assertEqual('zhangsan');
      await inputTexts[1].inputText('12345678901');
      inputMethodController.stopInputSession();
      let phoneValue = await inputTexts[1].getText();
      logger.info(TAG, `AddContactConflictFunction_001 phone:${phoneValue}`);
      expect(phoneValue).assertEqual('12345678901');
      await inputTexts[2].inputText('remark1');
      inputMethodController.stopInputSession();
      let remarkValue = await inputTexts[2].getText();
      logger.info(TAG, `AddContactConflictFunction_001 remark:${remarkValue}`);
      expect(remarkValue).assertEqual('remark1');
      await inputTexts[3].inputText('18');
      inputMethodController.stopInputSession();
      let ageValue = await inputTexts[3].getText();
      logger.info(TAG, `AddContactConflictFunction_001 age:${ageValue}`);
      expect(ageValue).assertEqual('18');
      await driver.assertComponentExist(ON.id('rightBtn'));
      let rightBtn = await driver.findComponent(ON.id('rightBtn'));
      await rightBtn.click();
      await driver.delayMs(500);
      let list: Component[] = await driver.findComponents(ON.type('ListItem'));
      expect(list.length > 0).assertTrue();

      // 添加联系人lisi
      await btnAdd.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text('性别', MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.type('TextInput'));

      let inputTexts1: Component[] = await driver.findComponents(ON.type('TextInput'));
      await inputTexts1[0].inputText('lisi');
      inputMethodController.stopInputSession();
      let name = await inputTexts1[0].getText();
      logger.info(TAG, `AddContactConflictFunction_001 name:${name}`);
      expect(name).assertEqual('lisi');
      await inputTexts1[1].inputText('12345678901'); // 电话号码和zhangsan一样
      inputMethodController.stopInputSession();
      let phone = await inputTexts1[1].getText();
      logger.info(TAG, `AddContactConflictFunction_001 phone:${phone}`);
      expect(phone).assertEqual('12345678901');
      await inputTexts1[2].inputText('remark2');
      inputMethodController.stopInputSession();
      let remark = await inputTexts1[2].getText();
      logger.info(TAG, `AddContactConflictFunction_001 remark:${remark}`);
      expect(remark).assertEqual('remark2');
      await inputTexts1[3].inputText('25');
      inputMethodController.stopInputSession();
      let age = await inputTexts1[3].getText();
      logger.info(TAG, `AddContactConflictFunction_001 age:${age}`);
      expect(age).assertEqual('25');
      await driver.assertComponentExist(ON.id('rightBtn'));
      let rightBtn1 = await driver.findComponent(ON.id('rightBtn'));
      await rightBtn1.click();
      await driver.delayMs(500);
      let list1: Component[] = await driver.findComponents(ON.type('ListItem'));
      expect(list1.length > 0).assertTrue();
      await driver.delayMs(500);

      // 点击搜索是否存在电话号码为12345678901的联系人lisi
      await driver.assertComponentExist(ON.id('searchBar'))
      let searchBar = await driver.findComponent(ON.id('searchBar'))
      await searchBar.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.type('TextInput'));
      let input: Component = await driver.findComponent(ON.type('TextInput'));
      await input.inputText('12345678901');
      inputMethodController.stopInputSession();
      let inputValue = await input.getText();
      logger.info(TAG, `AddContactConflictFunction_001 input:${inputValue}`);
      expect(inputValue).assertEqual('12345678901');
      let btn: Component = await driver.findComponent(ON.type('Button'));
      await btn.click()
      let list2: Component[] = await driver.findComponents(ON.type('ListItem'));
      expect(list2.length > 0).assertTrue();
      await driver.pressBack();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}AddContactConflictFunction_001 end`);
      done();
    })

    /**
     * 长按联系人进入多选、退出多选
     */
    it(BUNDLE + 'LongClickFunction_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}LongClickFunction_001 begin`);
      await driver.delayMs(1000)
      // 长按第一条，进入多选
      let list: Component[] = await driver.findComponents(ON.type('ListItem'));
      if (list !== null && list.length > 0) {
        let item = list[0];
        await item.longClick();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('退出', MatchPattern.CONTAINS));
        let exit = await driver.findComponent(ON.text('退出', MatchPattern.CONTAINS));
        await exit.click();
      }
      logger.info(TAG, `${BUNDLE}LongClickFunction_001 end`);
      done();
    })

    /**
     * 进入多选后全选、删除
     */
    it(BUNDLE + 'DeleteContactFunction_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DeleteContactFunction_001 begin`);
      await driver.delayMs(1000)
      // 长按第一条，进入多选
      let list: Component[] = await driver.findComponents(ON.type('ListItem'));
      if (list !== null && list.length > 0) {
        let item = list[0];
        await item.longClick();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('全选', MatchPattern.CONTAINS));
        let allCheck = await driver.findComponent(ON.text('全选', MatchPattern.CONTAINS));
        await allCheck.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('取消', MatchPattern.CONTAINS));
        await driver.assertComponentExist(ON.text('删除', MatchPattern.CONTAINS));
        let btnDelete = await driver.findComponent(ON.text('删除', MatchPattern.CONTAINS));
        await btnDelete.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.type("AlertDialog"));
        let btnInDailog = await driver.findComponents(ON.type('Button'));
        await btnInDailog[0].click();
        await driver.delayMs(1000);
        let list1: Component[] = await driver.findComponents(ON.type('ListItem'));
        expect(list1 == null || list1.length == 0).assertTrue();
      }
      logger.info(TAG, `${BUNDLE}DeleteContactFunction_001 end`);
      done();
    })
  })
}