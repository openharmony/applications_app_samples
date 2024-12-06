/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import userFileManager from '@ohos.filemanagement.userFileManager';
import MediaManager from '../model/MediaManager';
import Logger from '../model/Logger';
import { TitleBar } from '../common/TitleWithBack';
import { AnimateView } from '../common/AnimateView';
import { RecordModel } from '../model/RecordModel';
import { updateTime } from '../model/Utils';

const TAG = '[Recorder.Record]';

@Entry
@Component
struct RecordPage {
  private mediaManager = new MediaManager(getContext(this));
  private recordModel: RecordModel = new RecordModel();
  private millisecond: number = 0;
  @State fileAsset: userFileManager.FileAsset | undefined = undefined;
  private fd: number | undefined = undefined;
  @StorageLink('playState') playState: boolean = true;
  @State duration: string = '00:00';
  @State resetAnimation: boolean = false;

  async finish() {
    Logger.info(TAG, `avRecordder finished. ${this.fileAsset?.displayName}`);
    if (this.fileAsset !== undefined) {
      await this.mediaManager.saveFileDuration(this.fileAsset.displayName, this.duration);
      this.recordModel.finish(() => {
        Logger.info(TAG, `avRecordder finished.`);
        this.playState = false;
        AppStorage.setOrCreate('playState', this.playState);
        router.back();
      })
    }
  }

  async aboutToAppear() {
    await this.recordModel.initAudioRecorder();
    this.fileAsset = await this.mediaManager.createAudioFile();
    this.fd = await this.fileAsset.open('Rw');
    this.recordModel.startRecorder(`fd://${this.fd}`, this.fileAsset, () => {
      Logger.info(TAG, 'startRecorder callback success');
      this.millisecond = 0;
      this.playState = true;
    })
  }

  updateTimeStr = () => {
    this.millisecond += 1000;
    this.duration = updateTime(this.millisecond);
  }

  build() {
    Column() {
      if (this.fileAsset) {
        TitleBar({ title: this.fileAsset.displayName })
      }
      Column() {
        AnimateView({ resetAnimation: $resetAnimation, updateTimeStr: this.updateTimeStr })
        Image($r('app.media.bg_record'))
          .width('100%')
          .height('40%')
          .objectFit(ImageFit.Fill)

        Text(this.duration)
          .id('recordDuration')
          .fontColor(Color.Black)
          .fontSize(35)
        Row() {
          Blank().layoutWeight(5)
          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Rect({ width: 20, height: 20 }).fill(Color.Red).radius(5)
          }
          .id('finishRecord')
          .width(70)
          .height(70)
          .borderWidth(1)
          .backgroundColor('#FFFFFF')
          .onClick(async () => {
            await this.finish();
          })

          Blank().layoutWeight(2)
          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Image(this.playState ? $r('app.media.ic_pause') : $r('app.media.ic_play'))
              .objectFit(ImageFit.Contain)
              .size({ width: 55, height: 55 })
              .key('playImg')
          }
          .id('pauseOrRecord')
          .size({ width: 60, height: 60 })
          .backgroundColor('#FFFFFF')
          .onClick(() => {
            let callback = () => {
              this.playState = !this.playState;
              AppStorage.setOrCreate('playState', this.playState);
              Logger.info(TAG, `playstate changed.`);
            };
            if (this.playState) {
              this.recordModel.pause(callback);
            } else {
              this.recordModel.resume(callback);
            }
          })

          Blank().layoutWeight(2)
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  async onPageHide() {
    if (this.millisecond > 1000) {
      this.finish();
    } else {
      if (this.fileAsset) {
        if (this.fd) {
          this.fileAsset.close(this.fd);
        }
        await this.mediaManager.deleteFile(this.fileAsset);
      }
    }
  }
}