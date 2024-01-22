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

import { TitleBar } from '../../../../common/TitleBar';
import ShowToast from '../../../../util/ShowToast';

@Extend(Button) function commonButtonStyle() {
  .margin(8)
  .fontSize(16)
  .layoutWeight(1)
}

@Extend(Row) function rowStyle() {
  .width('100%')
  .borderRadius(24)
  .margin({ top: 12 })
  .justifyContent(FlexAlign.SpaceAround)
}

@Entry
@Component
struct MountUnmountEventSample {
  @State isShow: boolean = false;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.general_mount') })
      Row() {
        if (this.isShow) {
          Image($r('app.media.img_love'))
            .height(100)
            .width(100)
            .onAppear(() => {
              ShowToast.shortToast($r('app.string.general_mount_toast'));
            })
            .onDisAppear(() => {
              ShowToast.shortToast($r('app.string.general_unmount_toast'));
            })
        }
      }
      .justifyContent(FlexAlign.Center)
      .borderRadius(24)
      .backgroundColor(Color.White)
      .height(150)
      .margin({ left: 12, right: 12 })
      .width('100%')

      Scroll() {
        Column() {
          Row({ space: 18 }) {
            Button($r('app.string.general_mount_toast'))
              .commonButtonStyle()
              .margin({ left: 24 })
              .onClick(() => {
                this.isShow = true;
              })
              .id('mount')
            Button($r('app.string.general_unmount_toast'))
              .commonButtonStyle()
              .margin({ right: 24 })
              .onClick(() => {
                this.isShow = false;
              })
              .id('unmount')
          }
          .rowStyle()
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}

