'use static'

/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import {
  Entry,
  StorageLink,
  Component,
  BorderOptions,
  Column,
  TextInput,
  TextInputController,
  TextArea,
  KeyboardAppearance,
  Text,
  State,
  Color,
  $r,
} from '@kit.ArkUI';
import { inputMethod } from '@kit.IMEKit';
import Log from '../model/Log';
import { BusinessError } from '@ohos.base';
import { CustomInput } from '../components/CustomInput';
import { hilog } from '@kit.PerformanceAnalysisKit';

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
  @State textFunc: string = '';
  private intervailid: number = -1;
  private flag: boolean = false;
  @State inputWidth: number = 320;
  @State LINE_HEIGHT: number = 20;

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
        .border({ width: 1, color: Color.Gray, radius: 18 } as BorderOptions)
        .maxLength(50)
        .onChange((value: string) => {
          this.addLog('preViewText onChange.');
        })
        .onSubmit(() => {
          this.addLog('preViewText onSubmit.');
        })
      // [Start input_case_input_CustomInput]
      CustomInput()
      // [End input_case_input_CustomInput]

      // [Start input_case_input_KeyboardAppearance]
      TextArea({ placeholder: '沉浸模式' })
        .keyboardAppearance(KeyboardAppearance.IMMERSIVE)

      TextArea({ placeholder: '非沉浸模式' })
        .keyboardAppearance(KeyboardAppearance.NONE_IMMERSIVE)
      // [End input_case_input_KeyboardAppearance]
    }
    .width('100%')
    .padding(20)
  }
}