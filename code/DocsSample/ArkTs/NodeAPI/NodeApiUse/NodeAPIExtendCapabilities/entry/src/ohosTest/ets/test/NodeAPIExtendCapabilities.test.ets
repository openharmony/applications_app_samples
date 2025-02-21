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
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function nodeAPIExtendCapabilitiesTest() {
  describe('nodeAPIExtendCapabilitiesTest', () => {
    /**
     * 打开应用
     */
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      const driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      await driver.delayMs(1000);
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * 点击，调用napiCreateObjectWithProperties相关函数
     */
    it('testNodeAPIExtendCapabilities001', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities001 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('1.napiCreateObjectWithProperties'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateObjectWithPropertiesSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities001 end');
      done();
    })

    /**
     * 点击，调用napiCreateObjectWithNamedProperties相关函数
     */
    it('testNodeAPIExtendCapabilities002', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities002 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('2.napiCreateObjectWithNamedProperties'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateObjectWithNamedPropertiesSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities002 end');
      done();
    })

    /**
     * 点击，调用napiRunScriptPath相关函数
     */
    it('testNodeAPIExtendCapabilities003', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities003 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('3.napiRunScriptPath'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiRunScriptPathSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities003 end');
      done();
    })

    /**
     * 点击，调用napiCoerceToNativeBindingObject相关函数
     */
    it('testNodeAPIExtendCapabilities004', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities004 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('4.napiCoerceToNativeBindingObject'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCoerceToNativeBindingObjectSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities004 end');
      done();
    })

    /**
     * 点击，调用napiAboutSerialize相关函数
     */
    it('testNodeAPIExtendCapabilities005', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities005 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('5.napiAboutSerialize'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiAboutSerializeSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities005 end');
      done();
    })

    /**
     * 点击，调用napiIsSendable相关函数
     */
    it('testNodeAPIExtendCapabilities006', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities006 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('6.napiIsSendable'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiIsSendableSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities006 end');
      done();
    })

    /**
     * 点击，调用napiDefineSendableClass相关函数
     */
    it('testNodeAPIExtendCapabilities007', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities007 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('7.napiDefineSendableClass'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiDefineSendableClassSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities007 end');
      done();
    })

    /**
     * 点击，调用napiCreateSendableObjectWithProperties相关函数
     */
    it('testNodeAPIExtendCapabilities008', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities008 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('8.napiCreateSendableObjectWithProperties'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateSendableObjectWithPropertiesSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities008 end');
      done();
    })

    /**
     * 点击，调用napiCreateSendableArray相关函数
     */
    it('testNodeAPIExtendCapabilities009', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities009 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('9.napiCreateSendableArray'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateSendableArraySuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities009 end');
      done();
    })

    /**
     * 点击，调用napiCreateSendableArrayWithLength相关函数
     */
    it('testNodeAPIExtendCapabilities010', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities010 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const list = await driver.findComponent(ON.id('List'))
      await list.scrollToBottom();
      const text = await driver.findComponent(ON.text('10.napiCreateSendableArrayWithLength'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateSendableArrayWithLengthSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities010 end');
      done();
    })

    /**
     * 点击，调用napiCreateSendableArraybuffer相关函数
     */
    it('testNodeAPIExtendCapabilities011', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities011 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('11.napiCreateSendableArraybuffer'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateSendableArraybufferSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities011 end');
      done();
    })

    /**
     * 点击，调用napiCreateSendableTypedArray相关函数
     */
    it('testNodeAPIExtendCapabilities012', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIArray012 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('12.napiCreateSendableTypedArray'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiCreateSendableTypedArraySuccess'));
      console.info('uitest: testNodeAPIArray012 end');
      done();
    })

    /**
     * 点击，调用napiWrapSendable相关函数
     */
    it('testNodeAPIExtendCapabilities013', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities013 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('13.napiWrapSendable'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiWrapSendableSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities013 end');
      done();
    })

    /**
     * 点击，调用napiWrapSendableWithSize相关函数
     */
    it('testNodeAPIExtendCapabilities014', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities014 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('14.napiWrapSendableWithSize'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiWrapSendableWithSizeSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities014 end');
      done();
    })

    /**
     * 点击，调用napiUnwrapSendable相关函数
     */
    it('testNodeAPIExtendCapabilities015', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities015 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('15.napiUnwrapSendable'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiUnwrapSendableSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities015 end');
      done();
    })

    /**
     * 点击，调用napiRemoveWrapSendable相关函数
     */
    it('testNodeAPIExtendCapabilities016', 0, async (done: Function) => {
      console.info('uitest: testNodeAPIExtendCapabilities016 begin');
      const driver = Driver.create();
      await driver.delayMs(1000);
      const text = await driver.findComponent(ON.text('16.napiRemoveWrapSendable'));
      await driver.delayMs(1000);
      await text.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('Result: napiRemoveWrapSendableSuccess'));
      console.info('uitest: testNodeAPIExtendCapabilities016 end');
      done();
    })
  })
}