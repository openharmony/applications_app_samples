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

// [Start custom_dialog_with_transition]
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0000;
@Entry
@Component
export struct customDialogComponentWithTransition {
  private customDialogComponentId: number = 0
  @Builder
  customDialogComponent() {
    Row({ space: 50 }) {
      // $r('app.string.this_is_a_window')资源文件中的value为'这是一个弹窗'
      Button($r('app.string.this_is_a_window'))
    }.height(200).padding(5)
  }

  build() {
    NavDestination() {
      Row() {
        Row({ space: 20 }) {
          // $r('app.string.open_windows')资源文件中的value为'打开弹窗'
          Text($r('app.string.open_windows'))
            .fontSize(30)
            .onClick(() => {
              this.getUIContext()
                .getPromptAction()
                .openCustomDialog({
                  builder: () => {
                    this.customDialogComponent()
                  },
                  isModal: true,
                  showInSubWindow: false,
                  maskColor: Color.Pink,
                  maskRect: {
                    x: 20,
                    y: 20,
                    width: '90%',
                    height: '90%'
                  },

                  dialogTransition: // 设置弹窗内容显示的过渡效果
                  TransitionEffect.translate({ x: 0, y: 290, z: 0 })
                    .animation({ duration: 4000, curve: Curve.Smooth }), // 四秒钟的偏移渐变动画

                  maskTransition: // 设置蒙层显示的过渡效果
                  TransitionEffect.opacity(0)
                    .animation({ duration: 4000, curve: Curve.Smooth }) // 四秒钟的透明渐变动画

                })
                .then((dialogId: number) => {
                  this.customDialogComponentId = dialogId;
                })
                .catch((error: BusinessError) => {
                  hilog.error(DOMAIN, 'testTag', `openCustomDialog error code is ${error.code}, message is ${error.message}`)
                })
            })
        }
        .width('100%')
      }
      .height('100%')
    }
  }
}
// [End custom_dialog_with_transition]