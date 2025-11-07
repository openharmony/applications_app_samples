  /**
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

 // [Start inputText_sample]
  import { describe, it, TestType, Size, Level } from '@ohos/hypium';
  // 导入测试依赖kit
  import { Driver, ON } from '@kit.TestKit';

  export default function abilityTest() {
    describe('inputTextTest', () => {
      /**
       * 基于控件的文本输入，调用接口会默认清空文本框中内容后输入指定文本
       * 当输入文本中不包含中文、特殊字符，且文本长度不超过200字符时默认为逐字键入
       */
      it('componentInputText', TestType.FUNCTION, async () => {
        let driver = Driver.create();
        let input = await driver.findComponent(ON.type('TextInput'));
        await input.inputText('abc');
      })
      /**
       * 基于控件的文本输入，指定以复制粘贴方式注入输入指定文本
       * 指定以追加方式输入，即在输入文本签不清空原有内容
       */
      it('componentInputTextAddition', TestType.FUNCTION, async () => {
        let driver = Driver.create();
        let input = await driver.findComponent(ON.type('TextInput'));
        await input.inputText('abc', {paste: true, addition: true});
      })

      /**
       * 基于坐标的文本输入，点击指定位置使输入框获焦，并在光标处输入指定文本
       * 当输入文本中不包含中文、特殊字符，且文本长度不超过200字符时默认为逐字键入
       */
      it('pointInputText', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
        let driver = Driver.create()
        let input = await driver.findComponent(ON.type('TextInput'))
        let center = await input.getBoundsCenter()
        await driver.inputText(center, 'abc')
      })

      /**
       * 基于坐标的文本输入，指定以复制粘贴方式注入输入指定文本
       * 指定以追加方式输入，即点击指定位置使输入框获焦后将光标移动至原有文本末尾后输入
       */
      it('pointInputTextAddition', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
        let driver = Driver.create()
        let input = await driver.findComponent(ON.type('TextInput'))
        let center = await input.getBoundsCenter()
        await driver.inputText(center, '123', {paste: true, addition: true})
      })

      /**
       * 基于坐标的文本输入，指定以复制粘贴方式注入输入指定文本
       * 指定以追加方式输入，即点击指定位置使输入框获焦后将光标移动至原有文本末尾后输入
       * 当输入内容包含中文或特殊字符时，仅支持以复制粘贴方式输入文本，'paste'字段不生效
       */
      it('pointInputTextChinese', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL3, async () => {
        let driver = Driver.create()
        let input = await driver.findComponent(ON.type('TextInput'))
        let center = await input.getBoundsCenter()
        await driver.inputText(center, '你好', {paste: false, addition: true})
      })
    })
  }
  // [End inputText_sample]