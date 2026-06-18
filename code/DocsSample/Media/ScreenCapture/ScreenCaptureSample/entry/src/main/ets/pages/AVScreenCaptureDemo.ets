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

// [Start screenCapture_arkts_demo]
// [Start screenCapture_arkts_import]
import { common } from '@kit.AbilityKit';
import { media } from '@kit.MediaKit';
import { fileIo } from '@kit.CoreFileKit';
import { display } from '@kit.ArkUI';
// [End screenCapture_arkts_import]
import { BusinessError } from '@kit.BasicServicesKit';

export class AVScreenCaptureDemo {
  private captureFile: fileIo.File | undefined = undefined;
  private captureConfig: media.AVScreenCaptureRecordConfig | undefined = undefined;
  // [Start screenCapture_arkts_create]
  // 声明一个AVScreenCaptureRecorder，并赋值给screenCapture成员变量。
  private screenCapture?: media.AVScreenCaptureRecorder;

  async createAVScreenCapture(): Promise<void> {
    // 创建一个AVScreenCaptureRecorder，并赋值给screenCapture成员变量。
    this.screenCapture = await media.createAVScreenCaptureRecorder();
  }
  // [End screenCapture_arkts_create]

  closeFile(): void {
    if (!this.captureFile) {
      return;
    }
    try {
      fileIo.closeSync(this.captureFile.fd);
    } catch (error) {
      let err = error as BusinessError;
      console.error(`Failed to close fd, error code: ${err.code}, message: ${err.message}`);
    }
  }
  // [Start screenCapture_arkts_config]
  openFile(context: Context): void {
    const path: string = context.filesDir + '/screenCapture.mp4';
    this.captureFile = fileIo.openSync(path, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
  }

  setConfig(context: Context): void {
    this.openFile(context);
    if (!this.captureFile) {
      console.error(`处理异常情况`)
      return;
    }
    let displayClass: display.Display | undefined = undefined;
    try {
      displayClass = display.getDefaultDisplaySync();
      console.info(`The display info is: ${JSON.stringify(displayClass)}`);
    } catch (exception) {
      console.error(`Failed to get default display. Code: ${exception.code}, message: ${exception.message}`);
    }
    if (!displayClass) {
      console.error(`Failed to get displayClass.`);
      return;
    }
    this.captureConfig = {
        // 开发者可根据屏幕宽高设置相应尺寸。
        // 屏幕宽度应设置为64的倍数。
        frameWidth: displayClass.width,
        // 根据屏幕的高设置高度。
        frameHeight: displayClass.height,
        // 参考应用文件访问与管理开发示例新建并读写一个文件fd。
        fd: this.captureFile.fd,
        // 可选参数及其默认值。
        videoBitrate: 10000000,
        audioSampleRate: 48000,
        audioChannelCount: 2,
        audioBitrate: 96000,
        displayId: 0,
        preset: media.AVScreenCaptureRecordPreset.SCREEN_RECORD_PRESET_H264_AAC_MP4
      };
  }
  // [End screenCapture_arkts_config]

  registerScreenCaptureCallback(): void {
    // [Start screenCapture_arkts_Callback]
    this.screenCapture?.on('stateChange', async (infoType: media.AVScreenCaptureStateCode) => {
      switch (infoType) {
        case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_STARTED:
          console.info(`录屏成功开始后会收到的回调`);
          break;
        case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_CANCELED:
          this.screenCapture?.release();
          this.screenCapture = undefined;
          console.info(`不允许使用录屏功能`);
          break;
        case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_STOPPED_BY_USER:
          this.screenCapture?.release();
          this.screenCapture = undefined;
          console.info(`通过录屏胶囊结束录屏，底层录制会停止`);
          break;
        case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_INTERRUPTED_BY_OTHER:
          console.info(`录屏因其他中断而停止，底层录制会停止`);
          break;
        case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_STOPPED_BY_CALL:
          console.info(`录屏过程因通话中断，底层录制会停止`);
          break;
        case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_MIC_UNAVAILABLE:
          console.info(`录屏麦克风不可用`);
          break;
        case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_MIC_MUTED_BY_USER:
          console.info(`录屏麦克风被用户静音`);
          break;
        case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_MIC_UNMUTED_BY_USER:
          console.info(`录屏麦克风被用户取消静音`);
          break;
        case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_ENTER_PRIVATE_SCENE:
          // 目前可以从系统直接注册监听到进入隐私场景。
          console.info(`录屏进入隐私场景`);
          break;
        case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_EXIT_PRIVATE_SCENE:
          console.info(`录屏退出隐私场景`);
          break;
        case media.AVScreenCaptureStateCode.SCREENCAPTURE_STATE_STOPPED_BY_USER_SWITCHES:
          console.info(`用户账号切换，底层录制会停止`);
          break;
        default:
          break;
      }
    })
    this.screenCapture?.on('error', (err) => {
      console.error(`处理异常情况, code is ${err.code}, message is ${err.message}.`);
    })
    // [End screenCapture_arkts_Callback]
  }

  unRegisterScreenCaptureCallback(): void {
    this.screenCapture?.off('stateChange');
    this.screenCapture?.off('error');
  }

  async startRecording(context: Context): Promise<void> {
    this.createAVScreenCapture();
    if (!this.screenCapture) {
      return;
    }
    this.setConfig(context);
    // [Start screenCapture_arkts_init]
    await this.screenCapture?.init(this.captureConfig);
    // [End screenCapture_arkts_init]
    this.registerScreenCaptureCallback();
    // [Start screenCapture_arkts_skipPrivacyMode]
    let windowIDs: number[] = [57, 86];
    await this.screenCapture?.skipPrivacyMode(windowIDs);
    // [End screenCapture_arkts_skipPrivacyMode]
    // [Start screenCapture_arkts_startRecording]
    await this.screenCapture?.startRecording();
    // [End screenCapture_arkts_startRecording]
  }

  async stopRecording(): Promise<void> {
    if (!this.screenCapture) {
      this.closeFile();
      return;
    }
    // [Start screenCapture_arkts_stopRecording]
    await this.screenCapture?.stopRecording();
    // [End screenCapture_arkts_stopRecording]
    this.unRegisterScreenCaptureCallback();
    // 调用release()方法销毁实例，释放资源。
    // [Start screenCapture_arkts_release]
    await this.screenCapture?.release();
    // [End screenCapture_arkts_release]

    // 最后需要关闭创建的录屏文件;
    this.closeFile();
  }
}
// [End screenCapture_arkts_demo]
