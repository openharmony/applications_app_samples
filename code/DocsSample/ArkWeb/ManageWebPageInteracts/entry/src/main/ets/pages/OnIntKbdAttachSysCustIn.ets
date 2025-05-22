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

// [Start soft_keyboard_web]
import { webview } from '@kit.ArkWeb';
import { inputMethodEngine } from '@kit.IMEKit';

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  webKeyboardController: WebKeyboardController = new WebKeyboardController();
  inputAttributeMap: Map<string, number> = new Map([
    ['UNSPECIFIED', inputMethodEngine.ENTER_KEY_TYPE_UNSPECIFIED],
    ['GO', inputMethodEngine.ENTER_KEY_TYPE_GO],
    ['SEARCH', inputMethodEngine.ENTER_KEY_TYPE_SEARCH],
    ['SEND', inputMethodEngine.ENTER_KEY_TYPE_SEND],
    ['NEXT', inputMethodEngine.ENTER_KEY_TYPE_NEXT],
    ['DONE', inputMethodEngine.ENTER_KEY_TYPE_DONE],
    ['PREVIOUS', inputMethodEngine.ENTER_KEY_TYPE_PREVIOUS]
  ]);

  /**
   * 自定义键盘组件Builder
   */
  @Builder
  customKeyboardBuilder() {
    // 这里实现自定义键盘组件，对接WebKeyboardController实现输入、删除、关闭等操作。
    Row() {
      Text('finish')
        .fontSize(20)
        .fontColor(Color.Blue)
        .onClick(() => {
          this.webKeyboardController.close();
        })
      // 插入字符。
      Button('insertText').onClick(() => {
        this.webKeyboardController.insertText('insert ');
      }).margin({
        bottom: 200,
      });
      // 从后往前删除length参数指定长度的字符。
      Button('deleteForward').onClick(() => {
        this.webKeyboardController.deleteForward(1);
      }).margin({
        bottom: 200,
      });
      // 从前往后删除length参数指定长度的字符。
      Button('deleteBackward').onClick(() => {
        this.webKeyboardController.deleteBackward(1);
      }).margin({
        left: -220,
      });
      // 插入功能按键。
      Button('sendFunctionKey').onClick(() => {
        this.webKeyboardController.sendFunctionKey(6);
      })
    }
  }

  build() {
    Column() {
      Web({ src: $rawfile('index.html'), controller: this.controller })
        .onInterceptKeyboardAttach((keyBoardCallBackInfo) => {
          // option初始化，默认使用系统默认键盘
          let option: WebKeyboardOptions = {
            useSystemKeyboard: true,
          };
          if (!keyBoardCallBackInfo) {
            return option;
          }

          // 保存WebKeyboardController，使用自定义键盘时候，需要使用该handler控制输入、删除、软键盘关闭等行为
          this.webKeyboardController = keyBoardCallBackInfo.controller;
          let attributes: Record<string, string> = keyBoardCallBackInfo.attributes;
          // 遍历attributes
          let attributeKeys = Object.keys(attributes);
          for (let i = 0; i < attributeKeys.length; i++) {
            console.log('WebCustomKeyboard key = ' + attributeKeys[i] + ', value = ' + attributes[attributeKeys[i]]);
          }

          if (attributes) {
            if (attributes['data-keyboard'] == 'customKeyboard') {
              // 根据html可编辑元素的属性，判断使用不同的软键盘，例如这里如果属性包含有data-keyboard，且值为customKeyboard，则使用自定义键盘
              console.log('WebCustomKeyboard use custom keyboard');
              option.useSystemKeyboard = false;
              // 设置自定义键盘builder
              option.customKeyboard = () => {
                this.customKeyboardBuilder();
              }
              return option;
            }

            if (attributes['keyboard-return'] != undefined) {
              // 根据html可编辑元素的属性，判断使用不同的软键盘，例如这里如果属性包含有keyboard-return，使用系统键盘，并且指定系统软键盘enterKey类型
              option.useSystemKeyboard = true;
              let enterKeyType: number | undefined = this.inputAttributeMap.get(attributes['keyboard-return']);
              if (enterKeyType != undefined) {
                option.enterKeyType = enterKeyType;
              }
              return option;
            }
          }

          return option;
        })
    }
  }
}
// [End soft_keyboard_web]