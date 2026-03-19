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
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { router,window } from '@kit.ArkUI';
import { audio } from '@kit.AudioKit';
import { AudioPlayer } from './AudioPlayer';
import audioNapi from 'libentry.so';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { avSession } from '@kit.AVSessionKit';
import { AVCastPicker } from '@kit.AVSessionKit'

@Entry
@Component
struct CallOut {
  @State mutePlayData: boolean = false;
  @State muteRecordData: boolean = false;
  private context: Context = this.getUIContext().getHostContext() as Context;
  private audioPlayer: AudioPlayer = new AudioPlayer();
  private session: avSession.AVSession | null = null;
  @State pickerImage: Resource = $r('app.media.earpiece');
  @State deviceName: string = '听筒';
  private audioRendererInfo: audio.AudioRendererInfo = {
    usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION,
    rendererFlags: 0
  }

  onBackPress(): boolean | void {
    return true;
  }

  async aboutToAppear(): Promise<void> {
    let windowClass = window.getLastWindow(getContext(this))
    windowClass.then((win) => {
      win.setWindowLayoutFullScreen(true)
    })

    // 申请长时任务
    this.audioPlayer.startContinuousTask(this.context);

    // VoIP通话起流
    this.startVoIP();
  }

  aboutToDisappear(): void {
    // 取消长时任务
    this.audioPlayer.stopContinuousTask(this.context);
  }

  async startVoIP() {
    this.session = await avSession.createAVSession(this.context, 'voiptest', 'voice_call');
    audioNapi.activateAudioSessionVoIP();
    audioNapi.audioCapturerInitVoIP();
    audioNapi.audioCapturerStartVoIP();
    audioNapi.audioRendererPlayerInitVoIP(audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION);
    audioNapi.audioRendererPlayerStartVoIP();
    this.observerDevices();
  }

  async EndVoIP() {
    audioNapi.deActivateAudioSessionVoIP();
    audioNapi.audioCapturerPauseVoIP();
    audioNapi.audioCapturerStopVoIP();
    audioNapi.audioCapturerReleaseVoIP();
    audioNapi.audioRendererPlayerPauseVoIP()
    audioNapi.audioRendererPlayerStopVoIP();
    audioNapi.audioRendererPlayerReleaseVoIP();
    this.session?.destroy((err) => {
      if (err) {
        console.error(`Failed to destroy session. Code: ${err.code}, message: ${err.message}`);
      } else {
        console.info(`Destroy : SUCCESS `);
      }
    });
  }

  @Builder
  Press2PlayMute() {
    Column({space: 10}) {
      Image($r('app.media.speaker_wave'))
        .width($r('app.float.sub_button_size'))
        .height($r('app.float.sub_button_size'))
        .borderRadius(50)
        .onClick(async => {
          audioNapi.audioRendererPlayerMuteVoIP();
          this.mutePlayData = !this.mutePlayData;
        })

      Text($r('app.string.MUTE_PLAY'))
        .fontSize($r('app.float.sub_button_text_font_size'))
        .fontColor(Color.White)
    }
  }

  @Builder
  Press2PlayUnMute() {
    Column({space: 10}) {
      Image($r('app.media.speaker_slash'))
        .width($r('app.float.sub_button_size'))
        .height($r('app.float.sub_button_size'))
        .borderRadius(50)
        .onClick(async => {
          audioNapi.audioRendererPlayerUnMuteVoIP();
          this.mutePlayData = !this.mutePlayData;
        })

      Text($r('app.string.UNMUTE_PLAY'))
        .fontSize($r('app.float.sub_button_text_font_size'))
        .fontColor(Color.White)
    }
  }

  @Builder
  Press2RecordMute() {
    Column({space: 10}) {
      Image($r('app.media.mic'))
        .width($r('app.float.sub_button_size'))
        .height($r('app.float.sub_button_size'))
        .borderRadius(50)
        .onClick(async => {
          audioNapi.audioCapturerMuteVoIP();
          this.muteRecordData = !this.muteRecordData;
        })

      Text($r('app.string.MUTE_RECORD'))
        .fontSize($r('app.float.sub_button_text_font_size'))
        .fontColor(Color.White)
    }
  }

  @Builder
  Press2RecordUnMute() {
    Column({space: 10}) {
      Image($r('app.media.mic_slash'))
        .width($r('app.float.sub_button_size'))
        .height($r('app.float.sub_button_size'))
        .borderRadius(50)
        .onClick(async => {
          audioNapi.audioCapturerUnMuteVoIP();
          this.muteRecordData = !this.muteRecordData;
        })

      Text($r('app.string.UNMUTE_RECORD'))
        .fontSize($r('app.float.sub_button_text_font_size'))
        .fontColor(Color.White)
    }
  }

  async observerDevices() {
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
      this.pickerImage = $r('app.media.speaker_wave');
      this.deviceName = '扬声器'
    } else if (desc[0].deviceType === 7) {
      this.pickerImage = $r('app.media.bluetooth');
      this.deviceName = '蓝牙'
    } else {
      this.pickerImage = $r('app.media.earpiece');
      this.deviceName = '听筒'
    }
  }

  @Builder
  imageBuilder() {
    Column({space: 10}) {
      Image(this.pickerImage)
        .width($r('app.float.sub_button_size'))
        .height($r('app.float.sub_button_size'))
        .borderRadius(50)
        .objectFit(ImageFit.Contain)

      Text(this.deviceName)
        .fontSize($r('app.float.sub_button_text_font_size'))
        .fontColor(Color.White)
    }
  }

  build() {
    Stack() {
      Image($r('app.media.background_main'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        Text($r('app.string.IN_CALL'))
          .fontSize($r('app.float.page_title_font_size'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ top: $r('app.float.page_title_margin') })

        Row({ space: $r('app.float.sub_button_space') }) {
          AVCastPicker(
            {
              customPicker: (): void => this.imageBuilder()
            }
          )
            .size({ height:$r('app.float.sub_button_size'), width:$r('app.float.sub_button_size') })

          if (!this.muteRecordData) {
            this.Press2RecordMute();
          } else {
            this.Press2RecordUnMute();
          }

          if (!this.mutePlayData) {
            this.Press2PlayMute();
          } else {
            this.Press2PlayUnMute();
          }
        }
        .margin({ top: $r('app.float.button_margin') })
        .alignItems(VerticalAlign.Top)

        Row() {
          Column({ space: 10 }) {
            Button() {
              Image($r('app.media.phone_down'))
                .width($r('app.float.main_button_size'))
                .height($r('app.float.main_button_size'))
                .objectFit(ImageFit.Contain)
                .borderRadius(50)
            }
            .type(ButtonType.Circle)
            .width($r('app.float.main_button_size'))
            .height($r('app.float.main_button_size'))
            .onClick(async() => {
              this.EndVoIP();
              await router.back({ url: 'pages/Index' })
            })

            Text($r('app.string.END_CALL'))
              .fontSize($r('app.float.main_button_text_font_size'))
              .fontColor(Color.White)
          }
        }
        .margin({ top: 40 })
      }
      .height('100%')
      .width('100%')
    }
  }
}