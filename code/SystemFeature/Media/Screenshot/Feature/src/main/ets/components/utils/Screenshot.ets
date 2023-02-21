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

import screenshot from '@ohos.screenshot'
import { Logger } from './Logger'
import { getCurrentWindow } from './WindowPrivacy'

// 屏幕截图 默认参数screenshotOptions为空时 截全屏
export function getScreenshot(screenshotOption = {}) {
  return screenshot.save(screenshotOption)
}

// 设置全屏展示 isFullScreen: boolean
export function setFullScreen(context: Context, isFullScreen: boolean) {
  getCurrentWindow(context)
    .then(res => {
      res.setFullScreen(isFullScreen, (err) => {
        if (err.code) {
          Logger.error('failed set full-screen mode cause: ' + JSON.stringify(err))
          return
        }
        Logger.info('success set full-screen mode')
      })
    })
}
