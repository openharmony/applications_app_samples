/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { SourceSizeControlPanel } from '../../../../pages/components/imageVideoAndMedia/imageSample/ImageControlPanel';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';

@Extend(Column) function cardStyle() {
  .backgroundColor($r('app.color.white'))
  .borderRadius(16)
  .width('100%')
  .padding(12)
}

@Entry
@Component
struct ImageSample {
  @State srcType: Resource = $r('app.media.test_image');
  @State imageFitType: string = 'None';
  @State imageHeight: number = 110;
  @State imageWidth: number = 110;
  @State objectFit: ImageFit = ImageFit.None;
  @State RenderMode: ImageRenderMode = ImageRenderMode.Original;
  @State RepeatMode: ImageRepeat = ImageRepeat.NoRepeat;
  @State fillColor: Color = Color.Blue;
  @State colorFilter: ColorFilter = new ColorFilter([0.5, 0, 0.5, 0, 0,
    0, 0.5, 0.5, 0, 0,
    0.5, 0, 0.5, 0, 0,
    0, 0, 0.5, 0, 0])

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      TitleBar({ title: $r('app.string.image_title') }).flexGrow(0)
      IntroductionTitle({ introduction: $r('app.string.image_show_test') }).height(60)
      Column() {
        Column() {
          Row() {
            Image(this.srcType)
              .alt($r('app.media.ic_image_alt'))
              .size({ width: 110, height: 110 })
              .border({ width: 1 })
              .objectFit(this.objectFit)
              .renderMode(this.RenderMode)
              .margin({ right: 10 })
            Image($r('app.media.ic_unselect_universal'))
              .size({ width: 110, height: 110 })
              .border({ width: 1 })
              .objectFit(ImageFit.ScaleDown)
              .objectRepeat(this.RepeatMode)
          }
          .margin({ bottom: 5 })

          Row() {
            Image($r('app.media.icon'))
              .size({ width: 110, height: 110 })
              .border({ width: 1 })
              .sourceSize({ height: this.imageHeight, width: this.imageWidth })
              .matchTextDirection(true)
              .margin({ right: 10 })
            Image($r('app.media.img_love'))
              .size({ width: 110, height: 110 })
              .border({ width: 1 })
              .fillColor(this.fillColor)
              .colorFilter(this.colorFilter)
          }
        }.width('100%')
      }.cardStyle()
      .flexGrow(1)
      .margin({ bottom: 20 })

      Column() {
        Scroll() {
          SourceSizeControlPanel({
            ObjectFit: $objectFit,
            sizeHeight: $imageHeight,
            sizeWidth: $imageWidth,
            RenderMode: $RenderMode,
            ObjectRepeat: $RepeatMode,
            fillColor: $fillColor
          })
        }
      }.cardStyle()
      .margin({ bottom: 5 })
    }.flexGrow(0).margin({ bottom: 30 })
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    .backgroundColor($r('app.color.background_light_gray'))
  }
}