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
import { image } from '@kit.ImageKit';
import avimagegenerator from 'libentry.so';
import {promptAction} from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  @State totalDuration: number = 0;
  @State queryOption: string = 'next sync'
  @State arrowPosition: ArrowPosition = ArrowPosition.END
  @State space: number = 8
  // pixelMap对象声明，用于图片显示。
  @State pixelMap: image.PixelMap | undefined = undefined;
  @State queryOptionIndex: number = 0
  private videoName: string = 'H264_AAC.mp4';

  build() {
    Column() {

      Text(this.videoName).fontSize(20).fontWeight(FontWeight.Bold)

      Select([{ value: $r('app.string.nextSync') },
        { value: $r('app.string.previousSync') },
        { value: $r('app.string.closestSync') },
        { value: $r('app.string.closest') }])
        .selected(this.queryOptionIndex)
        .value(this.queryOption)
        .font({ size: 16, weight: 500 })
        .fontColor('#182431')
        .selectedOptionFont({ size: 16, weight: 400 })
        .optionFont({ size: 16, weight: 400 })
        .space(this.space)
        .arrowPosition(this.arrowPosition)
        .menuAlign(MenuAlignType.START, {dx:0, dy:0})
        .margin({
          top: 20
        })
        .width('60%')
        .onSelect((index:number, text?: string | undefined)=>{
          console.info('Select:' + index)
          this.queryOptionIndex = index;
          if(text){
            this.queryOption = text;
          }
        })

      Button() {
        Text($r('app.string.FetchFrame'))
          .fontSize(30)
          .fontWeight(FontWeight.Bold);
      }
      .type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#0D9FFB')
      .width('60%')
      .height('5%')
      .onClick(() => {
        this.testFetchFrameByTime();
      })
      .id('FetchFrameButton');

      Row () {
        if (this.pixelMap) {
          Image(this.pixelMap)
            .width(300)
            .height(300)
            .margin({
              top: 20
            })
            .borderWidth(2)
            .borderColor('#0D9FFB').objectFit(ImageFit.Fill)
        } else {
          Image(null)
            .width('16.67%')
            .margin({
              top: 20
            })
            .borderWidth(0)
            .borderColor('#0D9FFB')
        }
      }

      Button($r('app.string.ClearPictures'), { type: ButtonType.Normal })
        .onClick(() => {
          this.pixelMap = undefined;
          promptAction.showToast({
            message:$r('app.string.ClearPicturesFinish'),
            duration:2000,
            showMode: promptAction.ToastShowMode.DEFAULT,
            bottom:80
          })
        })
        .id('ClearPicturesButton');
    }.width('100%').height('100%')
  }

  async testFetchFrameByTime() {
    try {
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let avFileDescriptor = await context.resourceManager.getRawFd(this.videoName);
      let fdsrc : number = avFileDescriptor.fd;
      let size : number = avFileDescriptor.length;
      let offset : number = avFileDescriptor.offset;
      let timeMs : number = 0;
      timeMs = avimagegenerator.OhAVMetadataExtractorGetDuration(fdsrc, size, offset);
      this.totalDuration = timeMs / 1_000;
      this.pixelMap = avimagegenerator.OhAvImageGeneratorFetchFrameByTime(fdsrc, size, timeMs * 1000 / 5,
        this.queryOptionIndex, offset);
    } catch (err) {
      console.error(`OhAVMetadataExtractorGetDuration errCode is ${err.code}, message is ${err.message}`);
    }
  }

}
