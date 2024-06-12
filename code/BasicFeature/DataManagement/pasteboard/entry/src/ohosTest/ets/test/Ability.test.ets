/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[Sample_pasteboard]';
const DOMAIN = 0xF811;
const BUNDLE = 'pasteboard_';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('PasteboardTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  it('StartAbilityFunction_001', 0, async () => {
    hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
    let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    try {
      await abilityDelegator.startAbility({
        bundleName: "com.samples.pasteboard",
        abilityName: "EntryAbility"
      });
    } catch (err) {
      expect(err.code).assertEqual(0);
    }
    hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
  })

  /**
   * pasteboard 赋权限
   */
  // 点击允许
  it('RequestPermissionFunction_001', 0, async () => {
    hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
    let driver = await Driver.create();
    await driver.delayMs(2000);
    await driver.assertComponentExist(ON.text('仅本次允许', MatchPattern.CONTAINS));
    let permit = await driver.findComponent(ON.text('仅本次允许', MatchPattern.CONTAINS));
    await permit.click();
    await driver.delayMs(500);
    hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 end');
  })

    // 点击复制
    it('copy_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'copy_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('pasteText'));
      let inputTextArea = await driver.findComponent(ON.id('pasteText'));
      await inputTextArea.click();
      await inputTextArea.clearText();

      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('a', MatchPattern.CONTAINS));
      let inputTextA = await driver.findComponent(ON.text('a', MatchPattern.CONTAINS));
      await inputTextA.click();

      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('b', MatchPattern.CONTAINS));
      let inputTextB = await driver.findComponent(ON.text('b', MatchPattern.CONTAINS));
      await inputTextB.click();

      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('c', MatchPattern.CONTAINS));
      let inputTextC = await driver.findComponent(ON.text('c', MatchPattern.CONTAINS));
      await inputTextC.click();

      await driver.click(670, 700); // 点击收起软键盘

      let copy: string = await getResourceString($r('app.string.Button_copy'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'copy_001 copy: ' + copy);

      await driver.assertComponentExist(ON.text(copy, MatchPattern.CONTAINS));
      let inputText = await driver.findComponent(ON.text(copy, MatchPattern.CONTAINS));
      await inputText.click();

      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'copy_001 end');
    })

    // 点击粘贴
    it('paste_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(2000);

      let paste: string = await getResourceString($r('app.string.Button_paste'));
      await driver.assertComponentExist(ON.text(paste, MatchPattern.CONTAINS));
      let inputText = await driver.findComponent(ON.text(paste, MatchPattern.CONTAINS));
      await inputText.click();

      await driver.assertComponentExist(ON.id('pasteText'));
      let inputTextArea = await driver.findComponent(ON.id('pasteText'));
      let inputString = await inputTextArea.getText();
      expect(inputString === 'abc').assertTrue();

      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_001 end');
    })

    // 点击安全粘贴
    it('paste_security_text_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_security_text_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(2000);

      await driver.assertComponentExist(ON.type('PasteButton'));
      let inputText = await driver.findComponent(ON.type('PasteButton'));
      await inputText.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_security_text_001 22');

      await driver.assertComponentExist(ON.id('pasteText'));
      let inputTextArea = await driver.findComponent(ON.id('pasteText'));
      let inputString = await inputTextArea.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_text_001 inputString: ' + inputString);
      expect(inputString === 'abc').assertTrue();

      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_security_text_001 end');
    })

    // 点击粘贴文本
    it('paste_text_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_text_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(2000);

      await driver.assertComponentExist(ON.id('textPaste'));
      let inputText = await driver.findComponent(ON.id('textPaste'));
      await inputText.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_text_001 22');

      await driver.assertComponentExist(ON.id('pasteText'));
      let inputTextArea = await driver.findComponent(ON.id('pasteText'));
      let inputString = await inputTextArea.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_text_001 inputString: ' + inputString);
      expect(inputString === 'abc').assertTrue();

      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_text_001 end');
    })
  })
}