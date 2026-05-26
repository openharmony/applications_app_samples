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

// [Start create_voiceCall_avsession]
import { avSession, AVCastPickerStyle } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct AVCastPickerHelperForCall {
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private session: avSession.AVSession | undefined = undefined;
  private avCastPickerHelper: avSession.AVCastPickerHelper | undefined = undefined;

  async aboutToAppear() {
    console.log('about to appear');
    try {
      // 应用传入的AVSessionType类型与应用实际类型(如通话类应用)保持一致。
      // 创建voice_call类型的avsession。 'voice_call'代表语音通话，'video_call'代表视频通话。
      this.session = await avSession.createAVSession(this.context, 'voiptest', 'voice_call');
    } catch (err) {
      console.error(`AVSession create :  Error: Code: ${err.code}, message: ${err.message}`);
    }
    this.avCastPickerHelper = new avSession.AVCastPickerHelper(this.context);
  }
  // [End create_voiceCall_avsession]

  // [Start destroy_session]
  async aboutToDisappear() {
    console.log('about to disappear');
    // 通话结束后销毁avsession。
    this.session?.destroy((err) => {
      if (err) {
        console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
      } else {
        console.info(`Destroy : SUCCESS `);
      }
    });
  }
  // [End destroy_session]

  // [Start select_call_device]
  async selectCallDevice() {
    const avCastPickerOptions: avSession.AVCastPickerOptions = {
      sessionType: 'voice_call',
      pickerStyle: AVCastPickerStyle.STYLE_MENU,
      menuPosition: { x: 50, y: 150, width: 50, height: 50 } // 传入需要显示菜单的位置
    };

    this.avCastPickerHelper?.select(avCastPickerOptions).then(() => {
      console.info('select successfully');
    }).catch((err: BusinessError) => {
      console.error(`AVCastPicker.select failed with err: ${err.code}, ${err.message}`);
    });
  }

  build() {
    Row() {
      Column() {
        Button($r('app.string.switch_output'))
          .onClick(async () => {
            await this.selectCallDevice();
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
  // [End select_call_device]
}