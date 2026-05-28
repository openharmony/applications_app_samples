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

// [Start create_media_avsession]
import { avSession, AVCastPickerStyle } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct AVCastPickerHelperForMedia {
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private session: avSession.AVSession | undefined = undefined;
  private avCastPickerHelper: avSession.AVCastPickerHelper | undefined = undefined;

  async aboutToAppear() {
    console.log('about to appear');
    try {
      // 应用传入的AVSessionType类型与应用实际类型(如音视频应用)保持一致。
      // 创建audio类型的avsession。'audio'代表音频，'video'代表视频。
      this.session = await avSession.createAVSession(this.context, 'audiotest', 'audio');
    } catch (err) {
      console.error(`AVSession create :  Error: Code: ${err.code}, message: ${err.message}`);
    }

    let metadata: avSession.AVMetadata = {  // 传入当前正在播放的媒体信息
      assetId: '0',
      title: 'TITLE',
      mediaImage: 'IMAGE',
      artist: 'ARTIST'
    };
    this.session?.setAVMetadata(metadata).then(() => {
      console.info(`SetAVMetadata successfully`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to set AVMetadata. Code: ${err.code}, message: ${err.message}`);
    });

    this.avCastPickerHelper = new avSession.AVCastPickerHelper(this.context); // 初始化AVCastPickerHelper
  }
  // [End create_media_avsession]

  // [Start destroy_session]
  async aboutToDisappear() {
    console.log('about to disappear');
    // 应用销毁后，销毁avsession。
    this.session?.destroy((err) => {
      if (err) {
        console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
      } else {
        console.info(`Destroy : SUCCESS `);
      }
    });
  }
  // [End destroy_session]

  // [Start select_media_device]
  async selectMediaDevice() {
    const avCastPickerOptions: avSession.AVCastPickerOptions = {
      sessionType: 'audio',
      pickerStyle: AVCastPickerStyle.STYLE_PANEL
    };

    // 需要显示设备列表时，调用此接口
    this.avCastPickerHelper?.select(avCastPickerOptions).then(() => {
      console.info('select successfully');
    }).catch((err: BusinessError) => {
      console.error(`AVCastPicker.select failed with err: ${err.code}, ${err.message}`);
    });
  }

  build() {
    Row() {
      Column() {
        Button($r('app.string.switch_MediaOutputDevice')) // 切换媒体输出设备按钮
          .onClick(async () => {
            await this.selectMediaDevice();
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
  // [End select_media_device]
}