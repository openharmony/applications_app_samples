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

// [Start action_sheet_dialog]
@Entry
@Component
export struct showActionSheetExample {

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column() {
          Button('showActionSheet')
            .margin(30)
            .onClick(() => {
              this.getUIContext().showActionSheet({
                title: 'ActionSheet title',
                message: 'message',
                autoCancel: false,
                width: 300,
                height: 300,
                cornerRadius: 20,
                borderWidth: 1,
                borderStyle: BorderStyle.Solid,
                borderColor: Color.Blue,
                backgroundColor: Color.White,
                transition: TransitionEffect.asymmetric(TransitionEffect.OPACITY
                  .animation({ duration: 3000, curve: Curve.Sharp })
                  .combine(TransitionEffect.scale({ x: 1.5, y: 1.5 })
                  .animation({ duration: 3000, curve: Curve.Sharp })),
                  TransitionEffect.OPACITY.animation({ duration: 100, curve: Curve.Smooth })
                    .combine(TransitionEffect.scale({ x: 0.5, y: 0.5 })
                    .animation({ duration: 100, curve: Curve.Smooth }))),
                confirm: {
                  value: 'Confirm button',
                  action: () => {
                    console.info('Get Alert Dialog handled');
                  }
                },
                alignment: DialogAlignment.Center,
                sheets: [
                  {
                    title: 'apples',
                    action: () => {
                    }
                  },
                  {
                    title: 'bananas',
                    action: () => {
                    }
                  },
                  {
                    title: 'pears',
                    action: () => {
                      console.log('pears');
                    }
                  }
                ]
              })
            })
        }.width('100%').margin({ top: 5 })

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CustomDialog_ActionSheet'))
  }
}
// [End action_sheet_dialog]