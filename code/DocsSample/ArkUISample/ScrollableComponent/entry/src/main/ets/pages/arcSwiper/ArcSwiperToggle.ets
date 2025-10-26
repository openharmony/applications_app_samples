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

// [Start toggle]
// 导入ArcButton和ArcSwiper模块
import {
  ArcButton,
  ArcButtonOptions,
  ArcButtonStatus,
  ArcButtonStyleMode,
  ArcButtonPosition,
  ArcSwiper,
  ArcSwiperAttribute, // ArcSwiper的属性依赖ArcSwiperAttribute对象导入，不建议删除该对象的引入。
  ArcDotIndicator,
  // [StartExclude toggle]
  ArcDirection,
  ArcSwiperController
  // [EndExclude toggle]
} from '@kit.ArkUI';
// [StartExclude toggle]
import { ComponentCard } from '../../common/Card';
// [EndExclude toggle]
@Entry
@Component
export struct ArcSwiperToggle {
  private wearableSwiperController: ArcSwiperController = new ArcSwiperController();

  build() {
    // [StartExclude toggle]
    NavDestination() {
      // [EndExclude toggle]
      Column({ space: 12 }) {
        // [StartExclude toggle]
        ComponentCard({ title: $r('app.string.ArcSwiperToggle_title') }) {
          // [EndExclude toggle]
          Stack() {
            // [Start toggle_sensitivity]
            // [Start toggle_focus]
            ArcSwiper(this.wearableSwiperController) {
              // [StartExclude toggle]
              // [StartExclude toggle_focus]
              // [StartExclude toggle_sensitivity]
              Text('0')
                .width(233)
                .height(233)
                .backgroundColor(Color.Gray)
                .textAlign(TextAlign.Center)
                .fontSize(30)

              Text('1')
                .width(233)
                .height(233)
                .backgroundColor(Color.Green)
                .textAlign(TextAlign.Center)
                .fontSize(30)

              Text('2')
                .width(233)
                .height(233)
                .backgroundColor(Color.Pink)
                .textAlign(TextAlign.Center)
                .fontSize(30)
              // [EndExclude toggle_sensitivity]
              // [EndExclude toggle_focus]
              // [EndExclude toggle]
            }
            // [StartExclude toggle_sensitivity]
            // [StartExclude toggle_focus]
            .vertical(true)
            .indicator(false)
            // [EndExclude toggle_focus]

            // [StartExclude toggle]
            .focusable(true)
            .focusOnTouch(true)
            .defaultFocus(true)
            // [EndExclude toggle_sensitivity]
            // [End toggle_focus]

            .digitalCrownSensitivity(CrownSensitivity.MEDIUM)
            // [EndExclude toggle]
            // [End toggle_sensitivity]


            Column() {
              ArcButton({
                options: new ArcButtonOptions({
                  label: 'previous',
                  position: ArcButtonPosition.TOP_EDGE,
                  styleMode: ArcButtonStyleMode.EMPHASIZED_LIGHT,
                  onClick: () => {
                    this.wearableSwiperController.showPrevious(); // 通过controller切换到前一页
                  }
                })
              })

              Blank()

              ArcButton({
                options: new ArcButtonOptions({
                  label: 'next',
                  position: ArcButtonPosition.BOTTOM_EDGE,
                  styleMode: ArcButtonStyleMode.EMPHASIZED_LIGHT,
                  onClick: () => {
                    this.wearableSwiperController.showNext(); // 通过controller切换到后一页
                  }
                })
              })
            }.width('100%').height('100%')
          }
          // [StartExclude toggle]
        }
        // [EndExclude toggle]
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
      // [StartExclude toggle]
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ArcSwiperToggle_title'))
    // [EndExclude toggle]
  }
}
// [End toggle]