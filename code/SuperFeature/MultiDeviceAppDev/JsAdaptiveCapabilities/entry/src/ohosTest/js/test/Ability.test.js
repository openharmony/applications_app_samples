/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required ON applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import hilog from '@ohos.hilog';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const DOMAIN = 0xF811;
const TAG = '[Sample_jsAdaptiveCapabilities]';
const BUNDLE = 'jsAdaptiveCapabilities_';

let driver = Driver.create();

// 通过 text 验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithText(text) {
  let textName = text;
  await driver.assertComponentExist(ON.text(textName));
  let button = await driver.findComponent(ON.text(textName));
  await button.click();
  await driver.delayMs(1000);
}

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.jsadaptivecapabilities',
          abilityName: 'com.example.entry.MainAbility'
        });
      } catch (err) {
        expect(0).assertEqual(err.code);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 资源限定词
     */
    it(BUNDLE + 'clickResourceFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'clickResourceFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // fa模型不支持资源本地化，故用中文
      await checkButtonAndClickWithText('资源限定词');
      // 跳转资源限定词页面
      await driver.assertComponentExist(ON.id('clockFace'));
      // 返回首页
      await driver.pressBack();
    })

    /**
     * 原子布局能力(目前坐标只适用于RK3568)
     */
    it(BUNDLE + 'clickAtomCapabilitiesFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'clickAtomCapabilitiesFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击原子布局能力
      await checkButtonAndClickWithText('原子布局能力');
      // 跳转原子布局能力页面
      await checkButtonAndClickWithText('拉伸能力1');
      // slider滑动
      await driver.swipe(547, 1063, 360, 1065, 200);
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(500);
      await checkButtonAndClickWithText('拉伸能力2');
      // 打开switch
      await driver.assertComponentExist(ON.type('switch'));
      let swit = await driver.findComponent(ON.type('switch'));
      await swit.click();
      await driver.delayMs(1000);
      // slider滑动
      await driver.swipe(561, 1013, 360, 1013, 200);
      await driver.delayMs(1000);
      await driver.pressBack();
      await checkButtonAndClickWithText('缩放能力');
      // slider1滑动
      await driver.swipe(507, 1025, 360, 1025, 200);
      await driver.delayMs(1000);
      // slider2滑动
      await driver.swipe(507, 1085, 360, 1085, 200);
      await driver.delayMs(1000);
      await driver.pressBack();
      await checkButtonAndClickWithText('隐藏能力');
      // slider滑动
      await driver.swipe(547, 1011, 360, 1011, 200);
      await driver.delayMs(1000);
      await driver.pressBack();
      await checkButtonAndClickWithText('折行能力');
      // slider滑动
      await driver.swipe(547, 1063, 360, 1065, 200);
      await driver.delayMs(1000);
      await driver.pressBack();
      await checkButtonAndClickWithText('均分能力');
      // slider滑动
      await driver.swipe(557, 1009, 360, 1009, 200);
      await driver.delayMs(1000);
      await driver.pressBack();
      // 点击占比能力1按钮
      await checkButtonAndClickWithText('占比能力');
      // slider滑动
      await driver.swipe(553, 1015, 360, 1015, 200);
      await driver.delayMs(1000);
      await driver.pressBack();
      // 点击延伸能力1按钮
      await checkButtonAndClickWithText('延伸能力1');
      // scroll 应用滑动
      await driver.swipe(360, 639, 0, 639, 200);
      await driver.delayMs(1000);
      // slider 滑动
      await driver.swipe(410, 1017, 360, 1017, 200);
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      // 点击延伸能力2按钮
      await checkButtonAndClickWithText('延伸能力2');
      // scroll 应用滑动
      await driver.swipe(360, 639, 0, 639, 200);
      await driver.delayMs(1000);
      // slider 滑动
      await driver.swipe(410, 1017, 360, 1017, 200);
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      // 返回首页
      await driver.pressBack();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'clickAtomCapabilitiesFunction_001 end');
    })

    /**
     * 响应式布局
     */
    it(BUNDLE + 'clicAdaptiveCapabilitiesFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'clickAdaptiveCapabilitiesFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击响应式布局
      await checkButtonAndClickWithText('响应式布局');
      // 跳转响应式布局页面
      await checkButtonAndClickWithText('栅格布局');
      await driver.pressBack();
      await driver.delayMs(500);
      // 点击媒体查询
      await checkButtonAndClickWithText('媒体查询');
      await driver.pressBack();
      await driver.delayMs(500);
      // 点击典型场景
      await checkButtonAndClickWithText('典型场景');
      // 跳转典型场景页面
      await checkButtonAndClickWithText('挪移布局');
      await driver.pressBack();
      await driver.delayMs(500);
      // 点击缩进布局
      await checkButtonAndClickWithText('缩进布局');
      await driver.pressBack();
      await driver.delayMs(500);
      // 点击重复布局
      await checkButtonAndClickWithText('重复布局');
      await driver.pressBack();
      await driver.delayMs(500);
      // 回到响应式布局页面
      await driver.pressBack();
      await driver.delayMs(500);
      // 回到首页
      await driver.pressBack();
      await driver.delayMs(500);
      hilog.info(DOMAIN, TAG, BUNDLE + 'clickAdaptiveCapabilitiesFunction_001 end');
    })
  })
}