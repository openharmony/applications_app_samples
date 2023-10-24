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
import router from '@ohos.router';
import { logger } from '../util/Logger';
import { readImage } from '../util/MediaUtil';

@Component
export struct UpdatePage {
  @State mediaUri: string = (router.getParams() as Record<string, Object>)['mediaUri'] as string;
  @State isLand: boolean = false;
  @State pixelMap: PixelMap | null = null;

 async aboutToAppear(): Promise<void> {
    logger.info('UpdatePage mediaUri' + this.mediaUri);
    this.pixelMap = await readImage(this.mediaUri);
  }

  build() {
    Column() {
      Row() {
        Image($r("app.media.back1"))
          .width($r('app.float.size_35'))
          .height($r('app.float.size_35'))
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back();
          })
      }
      .padding({ left: $r('app.float.size_14') })
      .margin({ top: $r('app.float.size_20') })
      .justifyContent(FlexAlign.Start)
      .width('100%')

      Row() {
        Image(this.pixelMap)
          .objectFit(ImageFit.Contain)
          .backgroundColor($r('app.color.update_page_image'))
          .width('90%')
          .height('90%')
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Center)

      Row() {
        Column() {
          Image($r('app.media.ic_edit'))
            .width($r('app.float.size_35'))
            .height($r('app.float.size_35'))
          Text($r('app.string.update_page_edit'))
            .fontSize($r('app.float.size_18'))
            .fontColor(Color.White)
            .margin({ top: $r('app.float.size_5') })
        }
        .height($r('app.float.size_60'))
        .width($r('app.float.size_100'))
        .id('Edit')
        .onClick(() => {
          router.pushUrl({
            url: 'pages/EditImages',
            params: { mediaUris: this.mediaUri }
          });
        })

        Column() {
          Image($r('app.media.ic_delete'))
            .width($r('app.float.size_35'))
            .height($r('app.float.size_35'))
          Text($r('app.string.update_page_delete'))
            .fontColor(Color.White)
            .fontSize($r('app.float.size_18'))
            .margin({ top: $r('app.float.size_5') })
        }
        .height($r('app.float.size_60'))
        .width($r('app.float.size_100'))
        .onClick(() => {
          // 删除图片
          let imageList: Array<string> = AppStorage.Get('imageList') as Array<string>;
          let index: number = AppStorage.Get('selectIndex') as number;
          imageList.splice(index, 1);
          AppStorage.SetOrCreate<Array<string>>('imageList', imageList);
          // 返回
          router.back();
        })
      }
      .align(Alignment.Center)
      .height('10%')
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
    }
    .backgroundColor(Color.Black)
    .height('100%')
    .width('100%')
  }
}