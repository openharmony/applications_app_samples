/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { Router } from '@kit.ArkUI';
import AudioRenderer from '../utils/AudioRenderer'
import { common } from '@kit.AbilityKit';
// [Start create_voiceCall]
import { AVCastPicker, AVCastPickerState, AVInputCastPicker, avSession } from '@kit.AVSessionKit';

@Entry
@Component
struct Index {
  @State message: string = '模拟通话';
  @State session: avSession.AVSession | undefined = undefined;
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  // [StartExclude create_voiceCall]
  @State audioRenderer: AudioRenderer = new AudioRenderer();
  @State router: Router = new Router();
  @State normalColor:Color = Color.White;
  @State activeColor:Color = Color.Blue;
  @State pickerImage: ResourceStr = $r('app.media.sound'); // 自定义资源。

  async aboutToAppear() {
    console.log('about to appear');
    await this.init();
  }

  // 设备列表显示状态变化回调（可选）。
  private onStateChange(state: AVCastPickerState) {
    if (state === AVCastPickerState.STATE_APPEARING) {
      console.info('The picker starts showing.');
    } else if (state === AVCastPickerState.STATE_DISAPPEARING) {
      console.info('The picker finishes presenting.');
    }
  }

  // [EndExclude create_voiceCall]

  async init() {
    try {
      let context = this.getUIContext().getHostContext() as Context;
      // 通话开始时创建voice_call类型的avsession。
      this.session = await avSession.createAVSession(context, 'voiptest', 'voice_call');
    } catch (err) {
      console.error(`AVSession create :  Error: Code: ${err.code}, message: ${err.message}`);
    }
    // [StartExclude create_voiceCall]
    this.observerDevices();
    // [EndExclude create_voiceCall]
  }
  // [StartExclude create_voiceCall]

  async observerDevices() {
    this.audioRenderer.observerDevices();
  }

  async startRenderer(): Promise<void> {
    this.audioRenderer.appContext = this.context;
    this.audioRenderer.startRenderer();
  }

  async stopRenderer(): Promise<void> {
    this.audioRenderer.stopRenderer();
  }

  destroy(): void {
    // [Start destroy_session]
    // 通话结束销毁第一步创建的session。
    this.session?.destroy((err) => {
      if (err) {
        console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
      } else {
        console.info(`Destroy : SUCCESS `);
      }
    });
    // [End destroy_session]
  }

  onBackPress(): void {
    this.stopRenderer();
    this.destroy();
  }

  async onPageHide(): Promise<void> {
    this.stopRenderer();
    this.destroy();
  }

  onPageShow(): void {
    this.init();
  }

  aboutToDisappear() {
    console.log('about to disappear');
    this.destroy();
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
        Row() {
          Button($r('app.string.start'))
            .onClick(() => {
              this.startRenderer();
            })
            .type(ButtonType.Circle)
            .size({ width: '20%', height: '10%' })
            .margin('10')

          Button($r('app.string.stop'))
            .onClick(() => {
              this.stopRenderer();
            })
            .type(ButtonType.Circle)
            .size({ width: '20%', height: '10%' })
            .margin('10')

          AVCastPicker({
            normalColor: this.normalColor,
            activeColor: this.activeColor,
            customPicker: this.OutputImageBuilder.bind(this), // 新增自定义参数。
          })
            .size({ width: '20%', height: '10%' })
            .margin('10')
            .id('AVCastPicker')

          AVInputCastPicker(
            {
              customPicker: this.InputImageBuilder.bind(this), // 新增自定义参数。
              onStateChange: this.onStateChange
            }
          )
            .size({ width: '20%', height: '10%' })
            .margin('10')
            .id('AVInputCastPicker')
        }
        .margin('25')

        Button($r('app.string.switch_output'))
          .onClick(async () => {
            await this.router.pushUrl({ url: 'pages/SwitchOutputDevice' });
          })
          .type(ButtonType.Normal)
          .size({ width: '50%', height: '10%' })
          .margin('25')

        Button($r('app.string.switch_input'))
          .onClick(async () => {
            await this.router.pushUrl({ url: 'pages/SwitchInputDevice' });
          })
          .type(ButtonType.Normal)
          .size({ width: '50%', height: '10%' })
          .margin('25')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height('100%')
  }

  // 自定义OutputCastPicker样式。
  @Builder
  OutputImageBuilder() {
    Image(this.pickerImage)
      .size({ width: 50, height: 50 })
      .backgroundColor('#00000000')
      .fillColor(Color.Black)
    Text($r('app.string.switch_mockOutput'))
  }

  // 自定义InputCastPicker样式。
  @Builder
  InputImageBuilder() {
    Image(this.pickerImage)
      .size({ width: 50, height: 50 })
      .backgroundColor('#00000000')
      .fillColor(Color.Black)
    Text($r('app.string.switch_mockInput'))
  }
  // [EndExclude create_voiceCall]
}
// [End create_voiceCall]
