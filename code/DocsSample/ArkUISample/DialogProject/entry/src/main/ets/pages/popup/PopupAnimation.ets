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

// [Start animation_popup]
@Entry
@Component
export struct AnimationPopupExample {
  @State handlePopup: boolean = false;
  @State customPopup: boolean = false;

  @Builder popupBuilder() {
    Row() {
      Text('Custom Popup with transitionEffect').fontSize(10)
    }.height(50).padding(5)
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {


          // PopupOptions 类型设置弹框内容
          Button('PopupOptions')
            .margin({ top: 250 })
            .onClick(() => {
              this.handlePopup = !this.handlePopup;
            })
            .bindPopup(this.handlePopup, {
              message: 'This is a popup with transitionEffect',
              placementOnTop: true,
              showInSubWindow: false,
              onStateChange: (e) => {
                if (!e.isVisible) {
                  this.handlePopup = false;
                }
              },
              // 设置弹窗显示动效为透明度动效与平移动效的组合效果，无退出动效
              transition:TransitionEffect.asymmetric(
                TransitionEffect.OPACITY.animation({ duration: 1000, curve: Curve.Ease }).combine(
                  TransitionEffect.translate({ x: 50, y: 50 })),
                TransitionEffect.IDENTITY)
            })


          // CustomPopupOptions 类型设置弹框内容
          Button('CustomPopupOptions')
            .margin({ top: 60 })
            .onClick(() => {
              this.customPopup = !this.customPopup;
            })
            .bindPopup(this.customPopup, {
              builder: this.popupBuilder,
              placement: Placement.Top,
              showInSubWindow: false,
              onStateChange: (e) => {
                if (!e.isVisible) {
                  this.customPopup = false;
                }
              },
              // 设置弹窗显示动效与退出动效为缩放动效
              transition:TransitionEffect.scale({ x: 1, y: 0 }).animation({ duration: 500, curve: Curve.Ease })
            })


      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.AnimationPopup_title'))
  }
}
// [End animation_popup]