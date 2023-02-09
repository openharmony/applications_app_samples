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

import WindowController from '../feature/WindowController'
import { PublicTitleBar } from './component/PublicTitleBar'

@Entry
@Component
struct WindowPage {
  private windows: WindowController = new WindowController()

  build() {
    Column() {
      PublicTitleBar({ textName: $r('app.string.window_page')})
      Scroll() {
        Column() {
          Button($r('app.string.set_wake_up_screen'))
            .fancy(() => {
              this.windows.setWakeUpScreen(getContext(this))
            })

          Button($r('app.string.set_preferred_orientation'))
            .fancy(() => {
              this.windows.setPreferredOrientation()
            })

          Button($r('app.string.get_top_window'))
            .fancy(() => {
              this.windows.getTopWindow(getContext(this))
            })
        }
        .width('100%')
      }
      .width('100%')
      .layoutWeight(1)
    }
  }
}

@Extend(Button) function fancy (click) {
  .width('60%')
  .height(40)
  .align(Alignment.Center)
  .margin({ top: 30 })
  .onClick(click)
}