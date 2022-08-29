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

import { CheckEmptyUtils } from '../utils/CheckEmptyUtils'
import { ResourceManager } from '../manager/ResourceManager'
import { GridLayoutItemInfo } from '../bean/GridLayoutItemInfo'

@CustomDialog
export struct DeleteDialog {
  private appInfo: GridLayoutItemInfo = new GridLayoutItemInfo()
  private dialogContent: string = ''
  private controller: CustomDialogController
  private confirm: () => void
  private mResourceManager: ResourceManager = ResourceManager.getInstance(getContext(this))
  @State icon: string = ''

  public aboutToAppear(): void  {
    if (CheckEmptyUtils.isEmpty(this.icon)) {
      this.updateIcon()
    }
  }

  public iconLoadCallback(image) {
    this.icon = image
  }

  public updateIcon() {
    this.mResourceManager.getAppIconWithCache( this.appInfo.appIconId, this.appInfo.bundleName,
    this.iconLoadCallback.bind(this), '')
  }

  build() {
    Column() {
      Image(this.icon)
        .width(60)
        .height(60)
      Row() {
        Text($r('app.string.whether_to_uninstall'))
          .fontSize(17)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
        Text(this.dialogContent)
          .fontSize(17)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)
      }
      .margin({ top: 10 })

      Row() {
        Button($r('app.string.cancel'))
          .layoutWeight(7)
          .fontColor(Color.Blue)
          .backgroundColor(Color.White)
          .margin(5)
          .onClick(() => {
            this.controller.close()

          })
        Divider()
          .width(1).height(35)
          .backgroundColor('#8F8F8F')
        Button($r('app.string.uninstall'))
          .layoutWeight(7)
          .fontColor(Color.Red)
          .backgroundColor(Color.White)
          .margin(5)
          .onClick(() => {
            this.confirm()
            this.controller.close()
          })
      }
      .margin({ top: 10 })
    }
    .width('80%')
    .borderRadius(15)
    .padding(16)
    .backgroundColor(Color.White)
  }
}