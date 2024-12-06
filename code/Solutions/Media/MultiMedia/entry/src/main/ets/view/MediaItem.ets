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

import { FileType } from '../model/MediaUtils';
import { getDurationString } from '../model/TimeUtils'
import { MediaData } from './BasicDataSource';

@Component
export struct MediaItem {
  private media: MediaData = {} as MediaData;
  private index: number = 0
  private btnAction: (operate: string, index: number, mediaItemUri: string) => void = () => {};

  tempNum(number: number): string {
    if (number < 10) {
      return "0" + number
    }
    return number.toString()
  }

  getTimeString() {
    const dateAdded: number = this.media.dateAdded as number;
    // js中Date时间戳单位是毫秒（13位），文件创建时间戳的单位是秒(10位)。故需转化成毫秒后表示
    const date = new Date(dateAdded * 1000);
    return `${date.getFullYear()}/${this.tempNum(date.getMonth() + 1)}/${this.tempNum(date.getDate())}`
  }

  getImgSrc(): string | Resource {
    switch (this.media.fileType) {
      case FileType.VIDEO:
        return $r('app.media.video_poster')
      case FileType.AUDIO:
        return $r('app.media.ic_play')
      case FileType.IMAGE:
        return this.media.uri;
      default:
        return $r('app.media.ic_document')
    }
  }

  build() {
    Row() {
      Image(this.getImgSrc())
        .size({ width: 100, height: 100 })
        .aspectRatio(1)
        .borderRadius(10)
        .objectFit(ImageFit.Fill)
      Column() {
        Text(this.media.displayName)
          .width('100%')
          .fontSize(22)
          .id(`fileName${this.index}`)
        Text(this.getTimeString())
          .width('100%')
          .fontSize(22)
          .margin({ top: 10 })
        if (this.media.fileType === FileType.VIDEO) {
          Text(getDurationString(this.media.duration))
            .width('100%')
            .fontSize(22)
            .margin({ top: 10 })
        }
      }
      .margin({ left: 10 })
      .layoutWeight(1)

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Column() {
          Image($r('app.media.ic_rename'))
            .objectFit(ImageFit.Contain)
            .size({ width: 40, height: 40 })
        }
      }
      .id(`rename${this.index}`)
      .size({ width: 50, height: 50 })
      .backgroundColor('#F5F5F5')
      .onClick(() => {
        this.btnAction('rename', this.index, this.media.uri);
      })

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Column() {
          Image($r('app.media.ic_delete'))
            .objectFit(ImageFit.Contain)
            .size({ width: 40, height: 40 })
        }
      }
      .id(`delete${this.index}`)
      .size({ width: 50, height: 50 })
      .margin({ left: 15, right: 10 })
      .backgroundColor('#F5F5F5')
      .onClick(() => {
        this.btnAction('delete', this.index, this.media.uri);
      })
    }
    .padding({ top: 10, bottom: 10, left: 10, right: 10 })
    .margin({ left: 15, right: 15, top: 10 })
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
  }
}