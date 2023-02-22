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

import http from '@ohos.net.http'
import Logger from '../util/Logger'
import saveFile from '../feature/SaveFile'
import getFix from '../feature/LoadFile'

const TAG: string = 'UpdateDialog'

@Component
export struct UpdateDialog {
  build() {
    Column() {
      Button($r('app.string.check'))
        .fontSize(20)
        .margin({ top: 30, bottom: 20 })
        .type(ButtonType.Capsule)
        .backgroundColor($r('app.color.background'))
        .size({ width: '40%', height: '8%' })
        .onClick(() => {
          AlertDialog.show(
            {
              message: $r('app.string.message'),
              autoCancel: true,
              alignment: DialogAlignment.Bottom,
              gridCount: 4,
              offset: { dx: 0, dy: -20 },
              primaryButton: {
                value: $r('app.string.cancel'),
                action: () => {
                  Logger.info(TAG, `Callback when the first button is clicked`)
                }
              },
              secondaryButton: {
                value: $r('app.string.update'),
                action: () => {
                  let result: Promise<http.HttpResponse> = getFix()
                  result.then(data => {
                    if (data.responseCode === 200) {
                      saveFile(AppStorage.Get('filePath'), data.result as ArrayBuffer)
                    }
                  })
                }
              }
            }
          )
        })
    }.width('100%')
    .margin({ top: 5 })
  }
}