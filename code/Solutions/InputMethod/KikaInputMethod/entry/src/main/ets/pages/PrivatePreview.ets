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

import inputMethod from '@ohos.inputMethod';
import Log from '../model/Log';
import { BusinessError } from '@ohos.base';
import { CustomInput } from '../components/CustomInput';
import testNapi from 'libentry.so';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { UIContext } from '@kit.ArkUI';

const DOMAIN = 0x0000;

const TAG: string = 'PrivatePreview->';


@Entry
@Component
struct PrivatePreview {
  @State message: string = 'Hello World';
  @State accountText: string = '';
  @State preViewText: string = '';
  @StorageLink('isTextPreviewSupported') isTextPreviewSupported: boolean = true;
  controllerPrivate: TextInputController = new TextInputController();
  controllerPreview: TextInputController = new TextInputController();
  @State inputText: string = ''; // inputText作为Text组件要显示的内容

  @State private text: string = 'Hello ArkTS';
  @State private blinkPos: number = 0; // 目标字符位置（从0开始）
  @State private isBlinking: boolean = true;
  @State private opcacity: number = 1.0;
  @State textFunc:string = '';
  private uiContext: UIContext | null = null;
  private intervailid: number = -1;
  private flag : boolean = false;
  @State inputWidth: number = 320;
  @State LINE_HEIGHT: number = 20;
  // 动画控制周期
  startBLinkAnimation() {
    //使用 UIContext.animateTo 替代就方法
    this.uiContext?.animateTo({
      duration: 1000,
      curve: Curve.EaseInOut,
      iterations: -1, // 无限循环
      playMode: PlayMode.Alternate // 往返动画效果
    }, () => {
      this.opcacity = this.opcacity === 1.0 ? 0.3 : 1.0
    })
  }

  // 符合基类要求的onAppear方法
  onAppear(event: () => void): CommonAttribute {
    if (this.isBlinking) {
      this.startBLinkAnimation()
    }
    return {} as CommonAttribute // 返回符合类型的空对象
  }

  aboutToAppear() {
    this.addLog(`private preview aboutToAppear begin!`);
    this.intervailid = setInterval(()=>{
      if (this.flag) {
        this.textFunc = testNapi?.getText()
      }
    }, 50)

    inputMethod.getSetting().showOptionalInputMethods().then((data: boolean) => {
      console.log('onPageShow Succeeded in showing optionalInputMethods.');
    }).catch((err: BusinessError) => {
      console.error(`onPageShow Failed to showOptionalInputMethods: ${JSON.stringify(err)}`);
    })

    this.uiContext = this.getUIContext();
  }

  onPageShow() {
    this.addLog(`private command onPageShow!`);
  }

  addLog(message: string): void {
    Log.showInfo(TAG, `kikaInput-new: ${message}`);
  }

  build() {
    Column() {
      Text($r('app.string.Preview_Text'))
        .width('100%')
        .height(56)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize('16fp')
        .fontColor('#182431')
        .lineHeight(22)
        .fontWeight(500)

      TextInput({
        text: this.preViewText,
        placeholder: $r('app.string.Preview_tip'),
        controller: this.controllerPreview
      })
        .placeholderFont({ size: 16, weight: 400 })
        .width('100%')
        .height(56)
        .margin(10)
        .fontSize(16)
        .fontColor('#182431')
        .backgroundColor('#FFFFFF')
        .border({ width: 1, color: Color.Gray, radius: 18 })
        .maxLength(50)
        .onChange((value: string) => {
          this.addLog('preViewText onChange.');
        })
        .onSubmit(() => {
          this.addLog('preViewText onSubmit.');
        })
      CustomInput()

// [Start input_case_input_KeyboardAppearance]
      TextArea({placeholder: '沉浸模式'})
        .keyboardAppearance(KeyboardAppearance.IMMERSIVE)

      TextArea({placeholder: '非沉浸模式'})
        .keyboardAppearance(KeyboardAppearance.NONE_IMMERSIVE)
// [End input_case_input_KeyboardAppearance]

      Text(this.textFunc) // Text组件作为自绘编辑框的文本显示组件。
        .fontSize(16)
        .width('100%')
        .lineHeight(40)
        .id('customInput123')
        .height(85)
        .border({ color: '#554455', radius: 30, width: 1 })
        .maxLines(1)
        .onClick(() => {
          this.flag = true;
          this.textFunc = testNapi.attachInputMethod();
          hilog.info(DOMAIN, 'testTag', 'textFunc = %{public}s', this.textFunc);
        })
    }
    .width('100%')
    .padding(20)
  }
}