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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_QRCodeScan]'
const DOMAIN = 0xF811
const BUNDLE = 'QRCodeScan_'

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001 begin', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      try {
        await abilityDelegator.startAbility({
          bundleName: "ohos.samples.qrcodescan",
          abilityName: "MainAbility"
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 扫描二维码
     */
    it(BUNDLE + 'CreateQRCodeScanFunction_001', 0, async () => {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateQRCodeScanFunction_001 begin')
      let driver = Driver.create();
      await driver.delayMs(3000);
      // 允许打开相册
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.button_allow'))))
      let firstButton = await driver.findComponent(ON.text(await getResourceString($r('app.string.button_allow'))))
      await driver.delayMs(1000);
      await firstButton.click();
      await driver.delayMs(1000);
      // 允许访问媒体和文件
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.button_allow'))))
      let secondButton = await driver.findComponent(ON.text(await getResourceString($r('app.string.button_allow'))))
      await driver.delayMs(1000);
      await secondButton.click();
      await driver.delayMs(1000);
      // 允许访问图片和视频
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.button_allow'))));
      let agreeBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.button_allow'))));
      await driver.delayMs(1000);
      await agreeBtn.click();
      await driver.delayMs(1000);
      // 等待触发相机取景框识别失败提示
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.can_not_parse_QRcode'))));
      // 点击相册
      await driver.assertComponentExist(ON.id('scanPhoto'));
      let scanPhoto = await driver.findComponent(ON.id('scanPhoto'));
      await scanPhoto.click();
      await driver.delayMs(1000)
      // 选择一张二维码图片
      await driver.assertComponentExist(ON.type('Image'));
      let chooseImage = await driver.findComponents(ON.type('Image'));
      await chooseImage[6].click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.button_finish'))));
      let finish = await driver.findComponent(ON.text(await getResourceString($r('app.string.button_finish'))));
      await finish.click();
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.can_not_parse_QRcode'))));
      hilog.info(DOMAIN, TAG, BUNDLE + 'CreateQRCodeScanFunction_001 end')
    })
  })
}