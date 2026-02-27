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

// [Start self_castPicker]
import { AVCastPicker } from '@kit.AVSessionKit';
// [StartExclude self_castPicker]
// [Start device_monitor]
import { audio } from '@kit.AudioKit';
// [EndExclude self_castPicker]

@Entry
@Component
struct SelfCastPicker {
  // [StartExclude device_monitor]
  @State pickerImage: ResourceStr = $r('app.media.earpiece'); // 自定义资源。
  // [StartExclude self_castPicker]
  private audioRendererInfo: audio.AudioRendererInfo = {
    // 需使用通话场景相应的参数。
    usage: audio.StreamUsage.STREAM_USAGE_VIDEO_COMMUNICATION, // 音频流使用类型：VOIP视频通话，默认为扬声器。
    rendererFlags: 0 // 音频渲染器标志：默认为0即可。
  }
  // [EndExclude device_monitor]
  async selfObserverDevices() {
    let audioManager = audio.getAudioManager();
    let audioRoutingManager = audioManager.getRoutingManager();

    // 初次拉起AVCastPicker时需获取当前设备,刷新显示。
    this.changePickerShow(audioRoutingManager.getPreferredOutputDeviceForRendererInfoSync(this.audioRendererInfo));

    // 监听当前发声设备切换，及时根据不同设备类型显示不同的样式。
    audioRoutingManager.on('preferOutputDeviceChangeForRendererInfo', this.audioRendererInfo, (desc: audio.AudioDeviceDescriptors) => {
      this.changePickerShow(audioRoutingManager.getPreferredOutputDeviceForRendererInfoSync(this.audioRendererInfo));
    });
  }

  // 设备更新后刷新自定义资源pickerImage。
  private changePickerShow(desc: audio.AudioDeviceDescriptors) {
    if(!desc || !desc.length || !desc[0]) {
      return;
    }
    if (desc[0].deviceType === 2) {
      this.pickerImage = $r('app.media.sound');
    } else if (desc[0].deviceType === 7) {
      this.pickerImage = $r('app.media.bluetooth');
    } else {
      this.pickerImage = $r('app.media.earpiece');
    }
  }
  // [EndExclude self_castPicker]
  // [StartExclude device_monitor]
  build() {
    Row() {
      Column() {
        AVCastPicker(
          {
            customPicker: (): void => this.ImageBuilder() // 新增自定义参数。
          }
        ).size({ height: 45, width: 45 })
      }
    }
  }

  // 自定义内容。
  @Builder
  ImageBuilder() {
    Image(this.pickerImage)
      .size({ width: '100%', height: '100%' })
      .backgroundColor('#00000000')
      .fillColor(Color.Black)
  }
  // [EndExclude device_monitor]
}
// [End self_castPicker]
// [End device_monitor]