/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Row) function rowStyle() {
  .padding(12)
  .width('100%')
  .borderRadius(24)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.SpaceAround)
}

@Entry
@Component
struct RotateSample {
  private rotateAngele: Array<{
    angle: number,
    rotateInfo: Resource
  }> =
    [
      { angle: 0, rotateInfo: $r('app.string.rotate_before_image') },
      { angle: 15, rotateInfo: $r('app.string.rotate_image_angle') }
    ]
  private componentAngele: Array<{
    angle: number,
    rotateInfo: Resource
  }> =
    [
      { angle: 0, rotateInfo: $r('app.string.rotate_before_component') },
      { angle: 15, rotateInfo: $r('app.string.rotate_image_angle') }
    ]

  build() {
    Column() {
      TitleBar({ title: $r('app.string.graphic_transformation_rotate') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.rotate_photo') })
          // Image rotation
          Row() {
            ForEach(this.rotateAngele, (item) => {
              Column() {
                Image($r('app.media.ic_scenery1'))
                  .width(150)
                  .height(100)
                  .objectFit(ImageFit.Fill)
                  .margin({ bottom: 24 })
                  .rotate({
                    x: 0,
                    y: 0,
                    z: 1,
                    centerX: '50%',
                    centerY: '50%',
                    angle: item.angle
                  })
                Text(item.rotateInfo)
                  .fontSize(18)
              }
              .margin({ left: 20, right: 20, top: 12, bottom: 12 })
            })
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.rotate_container') })
          // Container rotation
          Row() {
            ForEach(this.componentAngele, (item) => {
              Column() {
                Column() {
                  this.TextInfo()
                  this.TextInfo()
                  this.TextInfo()
                }
                .margin({ bottom: 24 })
                .backgroundColor($r('app.color.background_grey'))
                .rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  centerX: '50%',
                  centerY: '50%',
                  angle: item.angle
                })

                Text(item.rotateInfo)
                  .fontSize(18)
              }
              .margin({ left: 20, right: 20, top: 12, bottom: 12 })
            })
          }
          .rowStyle()
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }

  @Builder TextInfo() {
    Text('ArkUI')
      .margin(8)
      .fontSize(18)
  }
}