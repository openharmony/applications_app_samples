/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import display from '@ohos.display';
export default {
  onCreate() {
    console.info('Application onCreate')
  },
  onDestroy() {
    console.info('Application onDestroy')
  },
  screenBreakPoints(data) {
    let displayClass = null
    let screenDpi = null
    displayClass = display.getDefaultDisplaySync()
    screenDpi = displayClass.densityDPI
    AppStorage.SetOrCreate('dpi', screenDpi)
    let windowWidth = data / (screenDpi / 160)
    if (windowWidth >= 320 && windowWidth < 520 || windowWidth < 320) {
      AppStorage.SetOrCreate('breakPoint', 'sm')
    } else if (windowWidth >= 520 && windowWidth < 840) {
      AppStorage.SetOrCreate('breakPoint', 'md')
    } else if (windowWidth >= 840) {
      AppStorage.SetOrCreate('breakPoint', 'lg')
    }
  }
}