/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import hilog from '@ohos.hilog';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[Sample_SandboxShare]';
const DOMAIN = 0xF811;
const BUNDLE = 'JSSandboxShare_';
const NUMBER = 22;

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

function getContent(): string {
  let content = 'abcdefghijklmnopqrstuvwxyz';
  let fileContent = content.repeat(NUMBER);
  return fileContent;
}

export default function abilityTest() {
  describe('abilityTest', function () {
    it('StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: "com.samples.sandbox_share",
          abilityName: "EntryAbility"
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
    })

    /**
     * SandboxShare 赋权限
     */
    // 点击允许
    it('RequestPermissionFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(2000);
      let permit = await getResourceString($r('app.string.permit'));
      await driver.assertComponentExist(ON.text(permit));
      let permit1 = await driver.findComponent(ON.text(permit));
      await permit1.click();
      await driver.delayMs(200);
      let permit2 = await driver.findComponent(ON.text(permit));
      await permit2.click();
      await driver.delayMs(200);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 end');
    })

    /**
     * SandboxShare 分享沙箱文件到picker打开并编辑保存
     */
    // 点击文件夹中的文件
    it('SandboxFileShareFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandboxFileShareFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.click(442, 205); // 点击沙箱文件夹
      await driver.delayMs(200);
      await driver.click(442, 205); // 点击沙箱文件
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.id('share'));
      let share = await driver.findComponent(ON.id('share'));
      await share.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('editable'));
      let editable = await driver.findComponent(ON.id('editable'));
      await editable.click();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.id('textArea'));
      let textArea = await driver.findComponent(ON.id('textArea'));
      let fileContent = getContent();
      await textArea.inputText(fileContent);
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('save'));
      let save = await driver.findComponent(ON.id('save'));
      await save.click();
      await driver.delayMs(3000);
      await driver.pressBack();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('refresh'));
      let refresh = await driver.findComponent(ON.id('refresh'));
      await refresh.click();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(500);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'SandboxFileShareFunction_001 end');
    })
  })
}