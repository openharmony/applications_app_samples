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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'

const TAG: string = '[Sample_StaticSubscriber]'
const DOMAIN = 0xF811
const BUNDLE = 'StaticSubscriber_'

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 拉起静态订阅应用
     */
    it(BUNDLE + 'EntryFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EntryFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入静态订阅
      hilog.info(DOMAIN, TAG, BUNDLE + 'EntryFunction_001 enter');
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.static_subscriber'))));
      let btnEnter = await driver.findComponent(ON.text(await getResourceString($r('app.string.static_subscriber'))));
      await btnEnter.click();
      await driver.delayMs(1000);
      // 返回桌面
      hilog.info(DOMAIN, TAG, BUNDLE + 'EntryFunction_001 outToHome');
      await driver.pressBack();
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.static_subscriber'))));
      hilog.info(DOMAIN, TAG, BUNDLE + 'EntryFunction_001 end');
    })

    /**
     * 拉起发布应用
     */
    it(BUNDLE + 'PublishFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入发布应用
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 enter');
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.publish'))));
      let enterBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.publish'))));
      await enterBtn.click();
      await driver.delayMs(2000);
      // 点击发布
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 clickPublish');
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.publish'))));
      let publishBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.publish'))));
      await publishBtn.click();
      await driver.delayMs(1000);
      // 下拉菜单栏查看通知
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 checkNotice');
      await driver.swipe(100, 10, 100, 500, 600);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.static_subscriber'))));
      await driver.delayMs(1000);
      await driver.swipe(100, 500, 100, 10, 600);
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 end');
    })
  })
}