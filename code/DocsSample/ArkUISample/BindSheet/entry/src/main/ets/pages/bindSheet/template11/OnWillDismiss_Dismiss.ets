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

// [Start onWillDismiss_Dismiss]

@Entry
@Component
struct OnWillDismiss_Dismiss {
  @State isShow: Boolean = false;

  @Builder
  myBuilder() {
    Column() {
      Button('Button')
    }
  }

  build() {
    Button('OpenBindSheet')
      .onClick(() => {
        this.isShow = true
      })
      .margin(120)
      .bindSheet($$this.isShow, this.myBuilder(), {
        height: SheetSize.MEDIUM,
        blurStyle: BlurStyle.Thick,
        dragBar: true,
        detents: [SheetSize.MEDIUM, SheetSize.LARGE],
        title: { title: 'title', subtitle: 'subtitle' },
        enableOutsideInteractive: false,
        onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
          // 第二步：确认二次回调交互能力，此处用AlertDialog提示 "是否需要关闭半模态"
          this.getUIContext().showAlertDialog(
            {
              message: $r('app.string.bindContentCover_label2'),
              autoCancel: true,
              alignment: DialogAlignment.Bottom,
              gridCount: 4,
              offset: { dx: 0, dy: -20 },
              primaryButton: {
                value: 'cancel',
                action: () => {
                }
              },
              secondaryButton: {
                enabled: true,
                defaultFocus: true,
                style: DialogButtonStyle.HIGHLIGHT,
                value: 'ok',
                // 第三步：确认关闭半模态逻辑所在，此处为AlertDialog的Button回调
                action: () => {
                  // 第四步：上述第三步逻辑触发的时候，调用dismiss()关闭半模态
                  dismissSheetAction.dismiss();
                }
              },
            }
          )
        })
      })
  }
}

// [End onWillDismiss_Dismiss]