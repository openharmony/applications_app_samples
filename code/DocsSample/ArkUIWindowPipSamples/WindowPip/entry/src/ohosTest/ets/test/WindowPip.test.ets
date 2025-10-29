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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import hilog from '@ohos.hilog';

const TAG = '[Sample_WindowPip]';
const DOMAIN = 0xF811
const BUNDLE = 'WindowPip_'

export default function WindowPipTest() {

  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + "StartAbility_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.testproject',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `StartAbility_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('使用XComponent实现画中画'));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 点击XComponent实现按钮，调用画中画接口
     */
    it(BUNDLE + 'XComponent_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + "XComponent_001, begin")
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.testproject',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `XComponent_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('使用XComponent实现画中画'));
      let clickBtn = await driver.findComponent(ON.text('使用XComponent实现画中画'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('pushPath'));
      clickBtn = await driver.findComponent(ON.text('pushPath'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('startPip'));
      clickBtn = await driver.findComponent(ON.text('startPip'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('updateSize'));
      clickBtn = await driver.findComponent(ON.text('updateSize'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('stopPip'));
      clickBtn = await driver.findComponent(ON.text('stopPip'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);

      await driver.pressBack();

      hilog.info(DOMAIN, TAG, BUNDLE + 'XComponent_001 end');
    })

    /**
     * 点击TypeNode自由节点实现按钮，调用画中画接口
     */
    it(BUNDLE + 'TypeNodeFree_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TypeNodeFree_001 begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.testproject',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `TypeNodeFree_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('使用TypeNode自由节点实现画中画'));
      let clickBtn = await driver.findComponent(ON.text('使用TypeNode自由节点实现画中画'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('startPip'));
      clickBtn = await driver.findComponent(ON.text('startPip'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('updateSize'));
      clickBtn = await driver.findComponent(ON.text('updateSize'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('stopPip'));
      clickBtn = await driver.findComponent(ON.text('stopPip'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.pressBack();

      hilog.info(DOMAIN, TAG, BUNDLE + 'TypeNodeFree_001 end');
    })

    /**
     * 点击Router导航实现按钮，调用画中画接口
     */
    it(BUNDLE + 'RouterTypeNode_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RouterTypeNode_001 begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.testproject',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `RouterTypeNode_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('使用Router导航时通过TypeNode实现画中画'));
      let clickBtn = await driver.findComponent(ON.text('使用Router导航时通过TypeNode实现画中画'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('Jump Next'));
      clickBtn = await driver.findComponent(ON.text('Jump Next'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('startPip'));
      clickBtn = await driver.findComponent(ON.text('startPip'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('Jump Next'));
      clickBtn = await driver.findComponent(ON.text('Jump Next'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('updateSize'));
      clickBtn = await driver.findComponent(ON.text('updateSize'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('stopPip'));
      clickBtn = await driver.findComponent(ON.text('stopPip'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);

      await driver.pressBack();

      hilog.info(DOMAIN, TAG, BUNDLE + 'RouterTypeNode_001 end');
    })

    /**
     * 点击Navigation导航实现按钮，调用画中画接口
     */
    it(BUNDLE + 'NavigationTypeNode_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NavigationTypeNode_001 begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.testproject',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `NavigationTypeNode_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('使用Navigation导航时通过TypeNode实现画中画'));
      let clickBtn = await driver.findComponent(ON.text('使用Navigation导航时通过TypeNode实现画中画'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('Jump Page1'));
      clickBtn = await driver.findComponent(ON.text('Jump Page1'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('startPip'));
      clickBtn = await driver.findComponent(ON.text('startPip'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('Jump Page1'));
      clickBtn = await driver.findComponent(ON.text('Jump Page1'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('updateSize'));
      clickBtn = await driver.findComponent(ON.text('updateSize'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('stopPip'));
      clickBtn = await driver.findComponent(ON.text('stopPip'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.pressBack();
      await driver.delayMs(1000);

      await driver.pressBack();

      hilog.info(DOMAIN, TAG, BUNDLE + 'NavigationTypeNode_001 end');
    })

    /**
     * 点击单页面Ability实现按钮，调用画中画接口
     */
    it(BUNDLE + 'AbilityTypeNode_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AbilityTypeNode_001 begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.testproject',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `AbilityTypeNode_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('使用单页面Ability时通过TypeNode实现画中画'));
      let clickBtn = await driver.findComponent(ON.text('使用单页面Ability时通过TypeNode实现画中画'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('startPip'));
      clickBtn = await driver.findComponent(ON.text('startPip'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('updateSize'));
      clickBtn = await driver.findComponent(ON.text('updateSize'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('stopPip'));
      clickBtn = await driver.findComponent(ON.text('stopPip'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.pressBack();

      hilog.info(DOMAIN, TAG, BUNDLE + 'AbilityTypeNode_001 end');
    })

    /**
     * 点击NDK接口实现按钮，调用画中画接口--视频画中画样式
     */
    it(BUNDLE + 'NDKImplement_001', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NDKImplement_001 begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.testproject',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `NDKImplement_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.swipe(500, 500, 500, 400);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('使用NDK接口实现画中画（C++）'));
      let clickBtn = await driver.findComponent(ON.text('使用NDK接口实现画中画（C++）'));
      await clickBtn.click();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.text('更换模板'));
      clickBtn = await driver.findComponent(ON.text('更换模板'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('视频'));
      clickBtn = await driver.findComponent(ON.text('视频'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('创建画中画'));
      clickBtn = await driver.findComponent(ON.text('创建画中画'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('开启画中画'));
      clickBtn = await driver.findComponent(ON.text('开启画中画'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('关闭画中画'));
      clickBtn = await driver.findComponent(ON.text('关闭画中画'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('删除控制器'));
      clickBtn = await driver.findComponent(ON.text('删除控制器'));
      await clickBtn.click();

      hilog.info(DOMAIN, TAG, BUNDLE + 'NDKImplement_001 end');
    })

    /**
     * 点击NDK接口实现按钮，调用画中画接口--通话画中画样式
     */
    it(BUNDLE + 'NDKImplement_002', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NDKImplement_002 begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.testproject',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `NDKImplement_002 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('更换模板'));
      let clickBtn = await driver.findComponent(ON.text('更换模板'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('通话'));
      clickBtn = await driver.findComponent(ON.text('通话'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('创建画中画'));
      clickBtn = await driver.findComponent(ON.text('创建画中画'))
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('开启画中画'));
      let startBtn = await driver.findComponent(ON.text('开启画中画'));
      await startBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('关闭画中画'));
      let closeBtn = await driver.findComponent(ON.text('关闭画中画'));
      await closeBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('删除控制器'));
      clickBtn = await driver.findComponent(ON.text('删除控制器'));
      await clickBtn.click();

      hilog.info(DOMAIN, TAG, BUNDLE + 'NDKImplement_002 end');
    })

    /**
     * 点击NDK接口实现按钮，调用画中画接口--会议画中画样式
     */
    it(BUNDLE + 'NDKImplement_003', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NDKImplement_003 begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.testproject',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `NDKImplement_003 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('更换模板'));
      let clickBtn = await driver.findComponent(ON.text('更换模板'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('会议'));
      clickBtn = await driver.findComponent(ON.text('会议'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('创建画中画'));
      clickBtn = await driver.findComponent(ON.text('创建画中画'))
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('开启画中画'));
      let startBtn = await driver.findComponent(ON.text('开启画中画'));
      await startBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('关闭画中画'));
      let closeBtn = await driver.findComponent(ON.text('关闭画中画'));
      await closeBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('删除控制器'));
      clickBtn = await driver.findComponent(ON.text('删除控制器'));
      await clickBtn.click();

      hilog.info(DOMAIN, TAG, BUNDLE + 'NDKImplement_003 end');
    })

    /**
     * 点击NDK接口实现按钮，调用画中画接口--直播画中画样式
     */
    it(BUNDLE + 'NDKImplement_004', 2, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NDKImplement_004 begin')
      let driver = Driver.create();
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.example.testproject',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(DOMAIN, TAG, BUNDLE + `NDKImplement_004 exception = ${JSON.stringify(exception)}`)
        expect().assertFail();
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('更换模板'));
      let clickBtn = await driver.findComponent(ON.text('更换模板'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('直播'));
      clickBtn = await driver.findComponent(ON.text('直播'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('创建画中画'));
      clickBtn = await driver.findComponent(ON.text('创建画中画'))
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('开启画中画'));
      let startBtn = await driver.findComponent(ON.text('开启画中画'));
      await startBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('关闭画中画'));
      let closeBtn = await driver.findComponent(ON.text('关闭画中画'));
      await closeBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('删除控制器'));
      clickBtn = await driver.findComponent(ON.text('删除控制器'));
      await clickBtn.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1500);

      hilog.info(DOMAIN, TAG, BUNDLE + 'NDKImplement_004 end');
    })
  })
}