/*
* Copyright (c) 2023-2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License")
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

/**
 * uitest对web页面内的控件进行查询和操作
 */

import { describe, it, expect, beforeAll } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import web_webview from '@ohos.web.webview';
import { BusinessError } from '@ohos.base';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function webOperateTest() {
  describe('webOperateTest', () => {
    beforeAll(async (done: Function) => {
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'WebAbility'
      };
      await delegator.startAbility(want);
      await sleep(3000);
      done();
    })

    /**
     * @tc.number:testWebInputText_001
     * @tc.name: testWebInputText
     * @tc.desc: webview控件加载htlm页面，根据html中的控件id查询到控件，并对控件进行操作，如点击、输入文本等
     */
    it('testWebInputText', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.delayMs(1000);
      let webComponent = await driver.findComponent(ON.id('webComponent'));
      let webComponentRect = await webComponent.getBounds();
      let webComponentLeft = webComponentRect.left;
      let webComponentTop = webComponentRect.top;
      let webComponentWidth = webComponentRect.right - webComponentRect.left;
      let webComponentHeight = webComponentRect.bottom - webComponentRect.top;
      // 在应用全局状态存储中获取 WebviewController
      let controller = AppStorage.get<web_webview.WebviewController>('controller') as web_webview.WebviewController;
      try {
        // 使用 WebviewController 执行js脚本，获取查询控件的中心点坐标
        let res = await controller.runJavaScript("getCenterById('textField')");
        let inputTextComponentRect = res.split(/,|"/).filter((item) => {
          return item !== '';
        });
        let textInputCenterX = Math.round(parseFloat(inputTextComponentRect[0]) * webComponentWidth + webComponentLeft);
        let textInputCenterY = Math.round(parseFloat(inputTextComponentRect[1]) * webComponentHeight + webComponentTop);
        let text: string = 'hello';
        await driver.inputText({
          x: textInputCenterX, y: textInputCenterY
        }, text);
        await driver.delayMs(3000);
        // 验证文本框内容是否改变
        let textResult = await controller.runJavaScript("getTextById('textField')");
        let textContent = textResult.replace(/"/g, '');
        expect(textContent).assertEqual(text);
      } catch (error) {
        let err: BusinessError = error as BusinessError;
        console.error(`InputText ErrorCode: ${err.code},  Message: ${err.message}`);
        expect(false).assertTrue();
      }
      done();
    })
  })
}