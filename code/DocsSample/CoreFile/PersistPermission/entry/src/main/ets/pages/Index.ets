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

import { persistPermissionExample } from '../persistpermission/PersistPermission'
import { revokePermissionExample } from '../persistpermission/PersistPermission'
import { activatePermissionExample } from '../persistpermission/PersistPermission'

@Entry
@Component
struct Index {
  @State message: string = '';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.size_15'))
          .fontWeight(FontWeight.Bold)
        Button($r('app.string.invokeInterfaceButton1'))
          .width('80%') // 设置按钮宽度为 80%
          .height('10%') // 设置按钮高度为 10%
          .margin({ top: $r('app.float.size_20') }) // 设置按钮上边距为 20
          .onClick(() => {
            persistPermissionExample();
          })
        Button($r('app.string.invokeInterfaceButton2'))
          .width('80%') // 设置按钮宽度为 80%
          .height('10%') // 设置按钮高度为 10%
          .margin({ top: $r('app.float.size_20') }) // 设置按钮上边距为 20
          .onClick(() => {
            revokePermissionExample();
          })
        Button($r('app.string.invokeInterfaceButton3'))
          .width('80%') // 设置按钮宽度为 80%
          .height('10%') // 设置按钮高度为 10%
          .margin({ top: $r('app.float.size_20') }) // 设置按钮上边距为 20
          .onClick(() => {
            activatePermissionExample();
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}