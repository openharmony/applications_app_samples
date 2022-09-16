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

import window from '@ohos.window'

@Entry
@Component
struct BreakpointSample {
  @State currentBreakpoint: string = 'sm'

  private updateBreakpoint(windowWidth) {
    if (windowWidth < 320) {
      this.currentBreakpoint = 'xs'
      return
    }
    if (windowWidth < 520) {
      this.currentBreakpoint = 'sm'
      return
    }
    if (windowWidth < 840) {
      this.currentBreakpoint = 'md'
      return
    }
    this.currentBreakpoint = 'lg'
  }

  aboutToAppear() {
    let windowObj: window.Window = AppStorage.Get('windowObj')
    windowObj.getProperties().then(windowProperties => {
      this.updateBreakpoint(px2vp(windowProperties.windowRect.width))
    })

    windowObj.on('windowSizeChange', data => {
      this.updateBreakpoint(px2vp(data.width))
    })
  }

  aboutToDisappear() {
    let windowObj: window.Window = AppStorage.Get('windowObj')
    windowObj.off('windowSizeChange')
  }

  build() {
    Column() {
      Text(this.currentBreakpoint)
        .fontSize(50)
        .fontWeight(FontWeight.Medium)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}