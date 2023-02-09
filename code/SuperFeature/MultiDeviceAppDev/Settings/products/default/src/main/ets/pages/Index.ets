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

import { SettingList } from '@ohos/settingItems'

let storage = LocalStorage.GetShared()

@Entry(storage)
@Component
struct Index {
  @LocalStorageProp('currentBreakpoint') curBp: string = 'sm'
  @LocalStorageProp('windowWidth') windowWidth: number = 300
  @LocalStorageProp('isSplitMode') isSplitMode: boolean = false
  @State itemTitle: string = ''

  aboutToAppear() {
    this.itemTitle = getContext().resourceManager.getStringSync($r('app.string.settings').id)
  }

  build() {
    Navigation() {
      SettingList()
    }
    .title(this.itemTitle)
    .mode(this.isSplitMode ? NavigationMode.Split : NavigationMode.Stack)
    .navBarWidth(0.4 * this.windowWidth)
    .hideToolBar(true)
    .width('100%')
    .height('100%')
    .backgroundColor($r("sys.color.ohos_id_color_sub_background"))
  }
}