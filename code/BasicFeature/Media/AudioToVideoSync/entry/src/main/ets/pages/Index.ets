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
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { display, promptAction } from '@kit.ArkUI';
import { fileIo } from '@kit.CoreFileKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { CommonConstants as Const } from '../common/CommonConstants';
import player from 'libplayer.so';

const TAG: string = Const.INDEX_TAG;

@Entry
@Component
struct Player {
  @State buttonEnabled: boolean = true;
  @State isShow: boolean = false;
  private selectFilePath: string | null = null;
  private display = display.getDefaultDisplaySync();
  private heightPx = (this.display.width * Const.DEFAULT_HEIGHT / Const.DEFAULT_WIDTH) + Const.PX;

  selectFile() {
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    photoPicker.select({
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE,
      maxSelectNumber: 1
    })
      .then((photoSelectResult) => {
        this.selectFilePath = photoSelectResult.photoUris[0];
        if (this.selectFilePath === null) {
          promptAction.showToast({
            message: $r('app.string.alert'),
            duration: Const.DURATION,
            bottom: Const.BOTTOM
          });
        } else {
          this.play();
          hilog.info(0x0000, TAG, 'documentViewPicker.select to file succeed and URI is:' + this.selectFilePath);
        }
      });
  }

  ratePlay(speed : number) {
    player.ratePlay(speed);
  }

  play() {
    let inputFile = fileIo.openSync(this.selectFilePath, fileIo.OpenMode.READ_ONLY);
    if (!inputFile) {
      hilog.error(0x0000, TAG, 'player inputFile is null');
    }
    let inputFileState = fileIo.statSync(inputFile.fd);
    if (inputFileState.size <= 0) {
      hilog.error(0x0000, TAG, 'player inputFile size is 0');
    }
    this.buttonEnabled = false;
    player.playNative(inputFile.fd, Const.DEFAULT_VALUE, inputFileState.size, () => {
      hilog.info(0x0000, TAG, 'player JSCallback');
      this.buttonEnabled = true;
      fileIo.close(inputFile);
    });
  }

  build() {
    Column() {
      Column() {
        Text($r('app.string.EntryAbility_label'))
          .width(Const.FULL_SIZE)
          .font({
            size: 32,
            weight: 700
          })
          .fontColor('#e5000000')
      }
      .margin({top: 64})
      .padding({
        left: '16vp'
      })
      .width($r('app.string.full_width'))
      .height($r('app.float.index_column_height'))

      XComponent({
        id: 'player',
        type: XComponentType.SURFACE,
        libraryname: 'player'
      })
        .height(this.heightPx)
        .width(Const.FULL_SIZE)
        .margin({ top: 32 })

      Column({ space: 12 }) {
        Column() {
          Button(this.buttonEnabled ? $r('app.string.play') : $r('app.string.playing'))
            .onClick(() => {
              this.selectFile();
            })
            .size({
              width: '100%',
              height: '40vp'
            })
            .enabled(this.buttonEnabled)
        }
        .padding({
          left: '16vp',
          right: '16vp'
        })
        .width($r('app.string.full_width'))
        .height($r('app.float.index_column_height'))

        Column() {
          Button($r('app.string.rate1'))
            .onClick(() => {
              this.ratePlay(1);
            })
            .size({
              width: '100%',
              height: '40vp'
            })
            .enabled(!this.buttonEnabled)
        }
        .padding({
          left: '16vp',
          right: '16vp',
        })
        .width($r('app.string.full_width'))
        .height($r('app.float.index_column_height'))

        Column() {
          Button($r('app.string.rate2'))
            .onClick(() => {
              this.ratePlay(2);
            })
            .size({
              width: '100%',
              height: '40vp'
            })
            .enabled(!this.buttonEnabled)
        }
        .padding({
          left: '16vp',
          right: '16vp'
        })
        .width($r('app.string.full_width'))
        .height($r('app.float.index_column_height'))

        Column() {
          Button($r('app.string.rate3'))
            .onClick(() => {
              this.ratePlay(3);
            })
            .size({
              width: '100%',
              height: '40vp'
            })
            .enabled(!this.buttonEnabled)
        }
        .padding({
          left: '16vp',
          right: '16vp'
        })
        .width($r('app.string.full_width'))
        .height($r('app.float.index_column_height'))
      }
      .layoutWeight(1)
      .width($r('app.string.full_width'))
      .height($r('app.string.full_width'))
      .justifyContent(FlexAlign.End)
      .padding({ bottom: '16vp' })
    }
    .height($r('app.string.full_width'))
    .backgroundColor('#F1F3F5')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}