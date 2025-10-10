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
 * WITHOUT WARRANTIES OR CONDITIONS OF InputStyle KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { inputMethod } from '@kit.IMEKit';

@Component
export struct CustomInput {
  @State inputText: string = ''; // inputText作为Text组件要显示的内容
  private isAttach: boolean = false;
  private inputController: inputMethod.InputMethodController = inputMethod.getController();

  build() {
    Text(this.inputText) // Text组件作为自绘编辑框的文本显示组件。
      .fontSize(16)
      .width('100%')
      .lineHeight(40)
      .id('customInput')
      .height(45)
      .border({ color: '#554455', radius: 30, width: 1 })
      .maxLines(1)
      .onBlur(() => {
        this.off();
      })
      .onClick(() => {
        this.attachAndListener(); // 点击控件
      })
  }

  async attachAndListener() { // 绑定和设置监听
    focusControl.requestFocus('CustomInput');
    await this.inputController.attach(true, {
      inputAttribute: {
        textInputType: inputMethod.TextInputType.TEXT,
        enterKeyType: inputMethod.EnterKeyType.SEARCH
      }
    });
    if (!this.isAttach) {
      this.inputController.on('insertText', (text) => {
        this.inputText += text;
      })
      this.inputController.on('deleteLeft', (length) => {
        this.inputText = this.inputText.substring(0, this.inputText.length - length);
      })
      this.isAttach = true;
    }
  }

  off() {
    this.isAttach = false;
    this.inputController.off('insertText');
    this.inputController.off('deleteLeft');
  }
}