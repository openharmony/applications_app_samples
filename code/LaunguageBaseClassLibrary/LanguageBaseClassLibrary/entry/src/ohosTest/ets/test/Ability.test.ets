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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import { logger } from '../util/Logger';

const TAG: string = 'Sample_LanguageBaseClassLibraryTest';
const BUNDLE = 'LanguageBaseClassLibrary';
const delegator = AbilityDelegatorRegistry.getAbilityDelegator()

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    // 打开应用
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      let want = {
        bundleName: 'com.samples.languagebaseclasslibrary',
        abilityName: 'EntryAbility'
      };
      let driver: Driver = Driver.create();
      delegator.startAbility(want, (err) => {
        logger.info(TAG, `${BUNDLE}_startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    // 进入xml解析、生成与转换页面
    it(BUNDLE + 'Xml_ConvertXml_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}Xml_ConvertXml_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(200);
      //find component on text 'Xml'
      await driver.assertComponentExist(ON.text('Xml & ConvertXml (XML解析,生成与转换)'));
      let button = await driver.findComponent(ON.text('Xml & ConvertXml (XML解析,生成与转换)'));
      await button.click();
      await driver.delayMs(200);
      //check text
      await driver.assertComponentExist(ON.text('Xml & ConvertXml (XML解析,生成与转换)'));
      await driver.delayMs(200);
      await driver.pressBack();
      done();
      logger.info(TAG, `${BUNDLE}Xml_ConvertXml_001 end`);
    })

    // 进入Util界面
    it(BUNDLE + 'util_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}util_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(200);
      //find component on text 'Xml'
      await driver.assertComponentExist(ON.text('Util (util工具函数)'));
      let button = await driver.findComponent(ON.text('Util (util工具函数)'));
      await button.click();
      await driver.delayMs(200);
      //check text
      await driver.assertComponentExist(ON.text('Util (util工具函数)'));
      await driver.delayMs(200);
      done();
      logger.info(TAG, `${BUNDLE}util_001 end`);
    })

    // RationalNumber (有理数)
    it(BUNDLE + 'RationalNumber_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}RationalNumber_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(200);
      //进入有理数界面
      await driver.assertComponentExist(ON.text('RationalNumber (有理数)'));
      let button = await driver.findComponent(ON.text('RationalNumber (有理数)'));
      await button.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.text('有理数比较'));
      let compare = await driver.findComponent(ON.text('有理数比较'));
      await compare.click();
      await driver.assertComponentExist(ON.text('有理数1小于有理数2'));

      await driver.assertComponentExist(ON.text('获取有理数的值'));
      let getValue = await driver.findComponent(ON.text('获取有理数的值'));
      await getValue.click();
      await driver.assertComponentExist(ON.text('的值是', MatchPattern.CONTAINS));

      await driver.assertComponentExist(ON.text('获取有理数分子分母'));
      let operation0= await driver.findComponent(ON.text('获取有理数分子分母'));
      await operation0.click();
      await driver.assertComponentExist(ON.text('分子:', MatchPattern.CONTAINS));

      await driver.assertComponentExist(ON.text('检查是否为0'));
      let operation1= await driver.findComponent(ON.text('检查是否为0'));
      await operation1.click();
      await driver.assertComponentExist(ON.text('有理数1 is', MatchPattern.CONTAINS));

      await driver.assertComponentExist(ON.text('检查是否表示NaN'));
      let operation2= await driver.findComponent(ON.text('检查是否表示NaN'));
      await operation2.click();
      await driver.assertComponentExist(ON.text('有理数1 is not NaN', MatchPattern.CONTAINS));

      await driver.assertComponentExist(ON.text('检查是否为有限值'));
      let operation3= await driver.findComponent(ON.text('检查是否为有限值'));
      await operation3.click();
      await driver.assertComponentExist(ON.text('Finite', MatchPattern.CONTAINS));

      await driver.pressBack();
      await driver.pressBack();
      done();
      logger.info(TAG, `${BUNDLE}RationalNumber_001 end`);
    })

    // 进入Url字符串解析页面
    it(BUNDLE + 'Url_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}Url_001 begin`);
      let driver: Driver = await Driver.create();
      await driver.delayMs(500);
      //find component on text 'Xml'
      await driver.assertComponentExist(ON.text('Url (Url字符串解析)'));
      let button = await driver.findComponent(ON.text('Url (Url字符串解析)'));
      await button.click();
      await driver.delayMs(1000);
      //check text
      await driver.assertComponentExist(ON.text('Url (Url字符串解析)'));
      await driver.delayMs(200);
      done()
      logger.info(TAG, `${BUNDLE}Url_001 end`);
    })

    // Url字符串解析
    it(BUNDLE + 'ClickUrlStringBtnFunction_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'ClickUrlStringBtnFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 点击插入键值对到查询字符串
      await driver.assertComponentExist(ON.id('item0'))
      let insertKeyValuePairs = await driver.findComponent(ON.id('item0'))
      await insertKeyValuePairs.click()
      await driver.delayMs(500)
      // 是否成功插入
      await driver.assertComponentExist(ON.id('output'))
      let outputInsert = await driver.findComponent(ON.id('output'))
      let insertValue = await outputInsert.getText()
      expect(insertValue).assertContain('node=nodeValue1')
      // 点击删除键值对
      await driver.assertComponentExist(ON.id('item1'))
      let deleteKeyValuePairs = await driver.findComponent(ON.id('item1'))
      await deleteKeyValuePairs.click()
      await driver.delayMs(500)
      // 是否成功删除
      await driver.assertComponentExist(ON.id('output'))
      let outputDelete = await driver.findComponent(ON.id('output'))
      let deleteValue = await outputDelete.getText()
      expect(deleteValue).assertEqual('https://gitee.com/openharmony/')
      // 点击获取指定名称对应的第一个值
      await driver.assertComponentExist(ON.id('item0'))
      let insertKeyValue = await driver.findComponent(ON.id('item0'))
      await insertKeyValue.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('item2'))
      let getFirstValue = await driver.findComponent(ON.id('item2'))
      await getFirstValue.click()
      await driver.delayMs(500)
      // 是否成功获取
      await driver.assertComponentExist(ON.id('output'))
      let outputGet = await driver.findComponent(ON.id('output'))
      let getValue = await outputGet.getText()
      expect(getValue).assertContain('nodeValue1')
      // 点击设置键的新值
      await driver.assertComponentExist(ON.id('item3'))
      let setNewValue = await driver.findComponent(ON.id('item3'))
      await setNewValue.click()
      await driver.delayMs(500)
      // 是否成功设置新值
      await driver.assertComponentExist(ON.id('output'))
      let outputSet = await driver.findComponent(ON.id('output'))
      let setValue = await outputSet.getText()
      expect(setValue).assertContain('newValue')
      // 返回首页
      await driver.pressBack();
      done();
      logger.info(TAG, BUNDLE + 'ClickUrlStringBtnFunction_001 end')
    })
  })
}