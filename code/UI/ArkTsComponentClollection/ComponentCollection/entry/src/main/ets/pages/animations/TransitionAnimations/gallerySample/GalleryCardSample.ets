/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar';

@Entry
@Component
struct GalleryCardSample {
  @StorageProp('windowHeight') windowHeight: number = 720;
  @State active: boolean = false;

  build() {
    Column() {
      TitleBar({ title: $r('app.string.Gallery_card_expansion') })
      Stack() {
        if (!this.active) {
          Image($r('app.media.img_test_4'))
            .id('galleryUnexpanded')
            .width('80%')
            .height(150)
            .margin({ top: 10 })
            .borderRadius(20)
            .onClick(() => {
              animateTo({ duration: 800 }, () => {
                this.active = true;
              })
            })
            .geometryTransition('sharedImage')
            .transition({ type: TransitionType.All })
        }

        if (this.active) {
          Stack() {
            Image($r('app.media.img_test_4'))
              .id('galleryExpanded')
              .width('100%')
              .align(Alignment.Center)
              .onClick(() => {
                animateTo({ duration: 800 }, () => {
                  this.active = false;
                })
              })
          }
          .margin({ top: this.windowHeight * 0.2 })
          .geometryTransition('sharedImage')
          .transition({ type: TransitionType.All })
        }
      }
      .alignContent(Alignment.Top)
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}