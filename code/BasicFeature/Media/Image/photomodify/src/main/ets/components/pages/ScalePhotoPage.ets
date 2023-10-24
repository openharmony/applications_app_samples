/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { scaleTaskDatas } from '../model/AdjustModels';
import { ScaleTasks, TaskData } from '../model/AdjustData';
import image from '@ohos.multimedia.image';

const SCALE_COUNT: number = 3;

@Component
export struct ScalePhotoPage {
  @Link pixelMap: PixelMap | null;
  @State scaleCount: number = SCALE_COUNT; // 缩小次数
  @State amplificationCount: number = 0; // 放大次数
  @State canClick: boolean = true;
  @Link dpi: string;
  private tempPixelMap: PixelMap | undefined | null = undefined;

  async computeDpi() {
    if (this.pixelMap !== null && this.pixelMap !== undefined) {
      const imageInfo: image.ImageInfo = await this.pixelMap.getImageInfo();
      this.dpi = imageInfo.size.width + '*' + imageInfo.size.height;
    }
  }

  build() {
    Row() {
      ForEach(scaleTaskDatas, (item: TaskData, index) => {
        Column() {
          Image(item.image)
            .height($r('app.float.size_30'))
            .width($r('app.float.size_30'))
          Text(item.text)
            .fontColor(Color.White)
            .fontSize($r('app.float.size_15'))
            .margin({ top: $r('app.float.size_5') })
        }
        .justifyContent(FlexAlign.Center)
        .width('50%')
        .height('100%')
        .layoutWeight(1)
        .onClick(async () => {
          if (item.task === ScaleTasks.NARROW && this.scaleCount > 0 && this.scaleCount <= 6) {
            this.scaleCount--;
            if (this.scaleCount < 0) {
              this.scaleCount = 0;
            }
            if (this.canClick) {
              this.canClick = false;
              await this.pixelMap?.scale(0.8, 0.8);
              this.computeDpi();
              setTimeout(() => {
                this.canClick = true;
              }, 300);
            }
          } else if (item.task === ScaleTasks.AMPLIFICARION && this.scaleCount >= 0 && this.scaleCount < 6) {
            this.scaleCount++;
            if (this.scaleCount > 6) {
              this.scaleCount = 6;
            }
            if (this.canClick) {
              this.canClick = false;
              await this.pixelMap?.scale(1.25, 1.25);
              this.computeDpi();
              setTimeout(() => {
                this.canClick = true;
              }, 300);
            }
          }
          this.flushPage();
        })
      })
    }
  }

  flushPage() {
    this.tempPixelMap = this.pixelMap;
    this.pixelMap = null;
    this.pixelMap = this.tempPixelMap;
  }
}