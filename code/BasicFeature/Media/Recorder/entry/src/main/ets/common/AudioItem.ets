/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import DateTimeUtil from '../model/DateTimeUtil';
import Logger from '../model/Logger';
import { Record } from '../model/Record';

const TAG = '[Recorder.AudioItem]';
const TRANSLATE: number = -145;

@Component
export struct AudioItem {
  @ObjectLink record: Record;
  private index: number = -1;
  private clickItem: (record: Record, operate: string) => void;
  private checkItem: (index: number) => void;
  @State translateLeft: number = 0;
  @State translateRight: number = TRANSLATE;
  @State imgRes: Resource = $r('app.media.uncheck');
  @Link checkState: boolean;
  @Link @Watch('leftSliderChange') leftSliderIndex: number;

  leftSliderChange() {
    animateTo({ duration: 500, curve: Curve.Linear }, () => {
      if (this.index !== this.leftSliderIndex) {
        this.translateLeft = 0;
        this.translateRight = TRANSLATE;
      } else {
        if (this.translateLeft < 0) {
          this.translateLeft = 0;
          this.translateRight = TRANSLATE;
        } else {
          this.translateLeft = TRANSLATE;
          this.translateRight = 0;
        }
      }
    })
  }

  getTimeString() {
    let date = new Date(this.record.fileAsset.dateAdded * 1000);
    let dateTimeUtil = new DateTimeUtil();
    return `${date.getFullYear()}/${dateTimeUtil.fill(date.getMonth() + 1)}/${dateTimeUtil.fill(date.getDate())}`;
  }

  build() {
    Row() {
      Row() {
        Column() {
          Text(this.record.fileAsset.title)
            .fontSize(22)
            .fontColor(Color.Black)
          Text(this.getTimeString())
            .fontSize(20)
            .fontColor(Color.Gray)
            .margin({ top: 10 })
        }
        .size({ width: '80%', height: '100%' })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)

        Row() {
          Text(this.record.duration)
            .fontSize(20)
            .fontColor(Color.Gray)
          if (this.checkState) {
            Image(this.record.isCheck ? $r('app.media.check') : $r('app.media.uncheck'))
              .size({ width: 20, height: 20 })
              .objectFit(ImageFit.Contain)
              .margin({ left: 5 })
          } else {
            Image($r('app.media.ic_about'))
              .size({ width: 20, height: 20 })
              .objectFit(ImageFit.Contain)
              .margin({ left: 5 })
          }
        }
        .width('20%')
        .justifyContent(FlexAlign.End)
      }
      .width('100%')
      .padding({ top: 10, bottom: 10, left: 10, right: 10 })
      .margin({ top: 15, right: 15 })
      .backgroundColor('#FFFFFF')
      .borderRadius(20)

      Row() {
        Button() {
          Image($r("app.media.rename_svg"))
            .size({ width: 50, height: 50 })
            .objectFit(ImageFit.Contain)
        }
        .id('renameAudio' + this.index)
        .size({ width: 50, height: 50 })
        .type(ButtonType.Circle)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          Logger.info(TAG, 'rename clicked');
          this.clickItem(this.record, 'rename');
          this.leftSliderIndex = -1;
        })

        Button() {
          Image($r('app.media.delete_fill'))
            .objectFit(ImageFit.Contain)
            .size({ width: 30, height: 30 })
        }
        .id('deleteAudio' + this.index)
        .type(ButtonType.Circle)
        .width(50)
        .height(50)
        .backgroundColor('#FF0000')
        .margin({ left: 5 })
        .onClick(() => {
          Logger.info(TAG, 'Recorder delete clicked ,id= deleteAudio' + this.index);
          this.clickItem(this.record, 'delete');
          this.leftSliderIndex = -1;
        })
      }
      .padding({ right: 10 })
      .margin({ left: 15, right: 15 })
    }
    .width('100%')
    .height('15%')
    .constraintSize({ minHeight: 100 })
    .translate({ x: this.translateLeft, y: 0 })
    .gesture(
    GestureGroup(GestureMode.Parallel,
    LongPressGesture({ repeat: true })
      .onAction(() => {
        if (!this.checkState && this.translateLeft === 0) {
          this.checkState = true;
        }
      }),
    PanGesture({ fingers: 1, direction: PanDirection.Left, distance: 20 })
      .onActionEnd(() => {
        Logger.info(TAG, 'swipe left');
        if (!this.checkState) {
          this.leftSliderIndex = this.index;
        }
      }))
    )
    .onClick(() => {
      Logger.info(TAG, `cilck,checkState=${this.checkState}, this.index = ${this.index}, isSwipeLeft=${this.index == this.leftSliderIndex}`);
      if (this.checkState) {
        this.checkItem(this.index);
        return;
      }
      if (this.index === this.leftSliderIndex) {
        this.leftSliderIndex = -1;
        return;
      }
      this.leftSliderIndex = -1;
      this.clickItem(this.record, 'play');
    })
  }
}