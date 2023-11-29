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
import { colorSpaceTaskDatas } from '../model/AdjustModels';
import { ColorSpaceTasks, ScaleTasks, TaskData } from '../model/AdjustData';
import image from '@ohos.multimedia.image';
import colorSpaceManager from '@ohos.graphics.colorSpaceManager';

const SCALE_COUNT: number = 3;

@Component
export struct ColorSpacePage {
  @State scaleCount: number = SCALE_COUNT; // 缩小次数
  @State amplificationCount: number = 0; // 放大次数
  @State canClick: boolean = true;
  @Link dpi: string;
  @Link pixelMap: PixelMap | null;
  private tempPixelMap: PixelMap | undefined | null = undefined;

  async computeDpi() {
    if (this.pixelMap !== null && this.pixelMap !== undefined) {
      const imageInfo: image.ImageInfo = await this.pixelMap.getImageInfo();
      this.dpi = imageInfo.size.width + '*' + imageInfo.size.height;
    }
  }

  build() {
    Row() {
      ForEach(colorSpaceTaskDatas, (item: TaskData, index) => {
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
          if (item.task === ColorSpaceTasks.ADOBERGB) {
            if (this.canClick) {
              this.canClick = false
              let colorSpaceName = colorSpaceManager.ColorSpace.ADOBE_RGB_1998;
              let csm : colorSpaceManager.ColorSpaceManager = colorSpaceManager.create(colorSpaceName);
              this.pixelMap!.applyColorSpace(csm).then(() => {
                this.flushPage();
              });
              setTimeout(() => {
                this.canClick = true;
              }, 300);
            }
          } else if (item.task === ColorSpaceTasks.DCIP3) {
            if (this.canClick) {
              this.canClick = false;
              let colorSpaceName = colorSpaceManager.ColorSpace.DCI_P3;
              let csm : colorSpaceManager.ColorSpaceManager = colorSpaceManager.create(colorSpaceName);
              this.pixelMap!.applyColorSpace(csm,()=>{
                this.flushPage();
              });
              setTimeout(() => {
                this.canClick = true;
              }, 300);
            }
          } else if (item.task === ColorSpaceTasks.SRGB) {
            if (this.canClick) {
              this.canClick = false;
              let colorSpaceName = colorSpaceManager.ColorSpace.SRGB;
              let csm : colorSpaceManager.ColorSpaceManager = colorSpaceManager.create(colorSpaceName);
              await this.pixelMap!.applyColorSpace(csm);
              setTimeout(() => {
                this.canClick = true;
              }, 300);
            }
          } else if (item.task === ColorSpaceTasks.DISPLAYP3) {
            if (this.canClick) {
              this.canClick = false;
              let colorSpaceName = colorSpaceManager.ColorSpace.DISPLAY_P3;
              let csm : colorSpaceManager.ColorSpaceManager = colorSpaceManager.create(colorSpaceName);
              await this.pixelMap!.applyColorSpace(csm);
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