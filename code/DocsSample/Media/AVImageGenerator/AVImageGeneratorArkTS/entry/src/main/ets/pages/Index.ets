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
import { media } from '@kit.MediaKit';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';

const TAG = 'MetadataDemo';
@Entry
@Component
struct Index {
  // pixelMap对象声明，用于图片显示。
  @State pixelMap: image.PixelMap | undefined = undefined;

  build() {
    Row() {
      Column() {
        Button() {
          Text($r('app.string.FetchFrame'))
            .fontSize(26)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('60%')
        .height('5%')
        .onClick(async () => {
          // 设置fdSrc, 获取视频的缩略图。
          await this.testFetchFrameByTime();
        })
        .id('FetchFrameButton')
        Image(this.pixelMap).width(300).height(300)
          .margin({
            top: 20
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  // 在以下demo中，使用资源管理接口获取打包在HAP内的视频文件，通过设置fdSrc属性。
  // 获取视频指定时间的缩略图，并通过Image控件显示在屏幕上。
  async testFetchFrameByTime() {
    try {
      // 创建AVImageGenerator对象。
      let avImageGenerator: media.AVImageGenerator = await media.createAVImageGenerator();
      // 设置fdSrc。
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      avImageGenerator.fdSrc = await context.resourceManager.getRawFd('H264_AAC.mp4');

      // 初始化入参。
      let timeUs = 0;
      let queryOption = media.AVImageQueryOptions.AV_IMAGE_QUERY_NEXT_SYNC;
      let param: media.PixelMapParams = {
        width : 300,
        height : 300
      };

      // 获取缩略图（promise模式）。
      this.pixelMap = await avImageGenerator.fetchFrameByTime(timeUs, queryOption, param);

      // 释放资源（promise模式）。
      avImageGenerator.release();
      console.info(TAG, `release success.`);
    } catch (err) {
      console.error(`FetchFrameByTime errCode is ${err.code}, message is ${err.message}`);
    }
  }
}
