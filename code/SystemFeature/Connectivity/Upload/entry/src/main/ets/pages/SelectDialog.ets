/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router'
import Style from '../util/Style'

@CustomDialog
export default struct SelectDialog {
  controller: CustomDialogController
  getImage: () => void

  build() {
    Column() {
      Text($r('app.string.take_photo'))
        .fontSize(18)
        .margin({ top: Style.MARGIN_TOP, bottom: Style.MARGIN_BOTTOM })
        .onClick(() => {
          this.controller.close()
          router.push({
            url: 'pages/CameraPage',
          })
        })

      Divider().color($r('app.color.gray')).width(1)

      Text($r('app.string.pick_album'))
        .fontSize(18)
        .margin({ top: Style.MARGIN_TOP, bottom: Style.MARGIN_BOTTOM })
        .onClick(() => {
          this.controller.close()
          this.getImage()
        })

      Divider().color($r('app.color.gray')).width(5)

      Text($r('app.string.cancel'))
        .fontSize(18)
        .margin({ top: Style.MARGIN_TOP, bottom: Style.MARGIN_BOTTOM })
        .onClick(() => {
          this.controller.close()
        })
    }.margin({ bottom: Style.MARGIN_BOTTOM })
  }
}
