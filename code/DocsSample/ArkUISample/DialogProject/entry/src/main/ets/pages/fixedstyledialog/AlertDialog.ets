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

// [Start alert_dialog]
import { PromptAction } from '@kit.ArkUI';

@Entry
@Component
export struct showAlertDialogExample {

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column() {
          Button('showAlertDialog')
            .margin(30)
            .onClick(() => {
              this.getUIContext().showAlertDialog(
                {
                  title: 'title',
                  message: 'text',
                  autoCancel: true,
                  alignment: DialogAlignment.Center,
                  offset: { dx: 0, dy: -20 },
                  gridCount: 3,
                  transition: TransitionEffect.asymmetric(TransitionEffect.OPACITY
                    .animation({ duration: 3000, curve: Curve.Sharp })
                    .combine(TransitionEffect.scale({ x: 1.5, y: 1.5 })
                    .animation({ duration: 3000, curve: Curve.Sharp })),
                    TransitionEffect.OPACITY.animation({ duration: 100, curve: Curve.Smooth })
                      .combine(TransitionEffect.scale({ x: 0.5, y: 0.5 })
                        .animation({ duration: 100, curve: Curve.Smooth }))),
                  buttons: [{
                    value: 'cancel',
                    action: () => {
                      console.info('Callback when the first button is clicked');
                    }
                  },
                    {
                      enabled: true,
                      defaultFocus: true,
                      style: DialogButtonStyle.HIGHLIGHT,
                      value: 'ok',
                      action: () => {
                        console.info('Callback when the second button is clicked');
                      }
                    }],
                }
              )
            })
        }.width('100%').margin({ top: 5 })

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CustomDialog_AlertDialog'))
  }
}
// [End alert_dialog]