/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import relationalStore from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { SubWindow } from '../Model/Window'
import DeviceInfo, { Rdb } from '../Model/Rdb'
import dmrnapi from '@ohos.dmrnapi'

const TAG = 'ProjectionPopup '

@CustomDialog
export struct ProjectionPopup {
  controller?: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }
  @StorageLink('window') storWindow: window.WindowStage | null = null
  @StorageLink('windowsize') windowSize: window.WindowProperties | null = null
  private windowStage = this.storWindow
  private subWindowClass: window.Window | null = null
  private deviceInfoList: Array<DeviceInfo> | null = null
  @StorageLink('IP') IP: string | null = null
  private istrust: boolean = false
  @Link pageHide: boolean
  @Link ispop: boolean;

  equalTo(ip: string) {
    Rdb.rdb.equalTo(ip)
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.projection_popup_title'))
          .fontSize($r('app.float.font_30'))
          .margin({ left: '10%', top: $r('app.float.distance_15') })
      }.width('100%').justifyContent(FlexAlign.Start)

      Column() {
        Button($r('app.string.projection_popup_trust'))
          .fontColor(Color.Black)
          .fontSize($r('app.float.font_20'))
          .fontWeight(FontWeight.Regular)
          .borderRadius($r('app.float.borderRadius_10'))
          .backgroundColor(Color.Transparent)
          .width('80%')
          .height('40%')
          .onClick(() => {
            if (this.controller != undefined) {
              if (this.IP != null) {
                Rdb.rdb.insetRdb(this.IP)
              }
              this.controller.close()
              this.ispop = false
            }
            this.pageHide = true
          })
        Button($r('app.string.projection_popup_connection'))
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Regular)
          .fontSize($r('app.float.font_20'))
          .borderRadius($r('app.float.borderRadius_10'))
          .backgroundColor(Color.Transparent)
          .width('80%')
          .height('40%')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
              this.ispop = false
            }
            this.pageHide = true
            dmrnapi.Play();
          })
      }.height($r('app.float.size_120')).justifyContent(FlexAlign.SpaceAround)

      Row() {
        Button($r('app.string.refuse'))
          .fontColor(Color.Red)
          .fontSize($r('app.float.font_24'))
          .backgroundColor(Color.Transparent)
          .width('80%')
          .height($r('app.float.size_55'))
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
              this.ispop = false
            }
          })
      }

    }.height($r('app.float.size_300'))
    .width($r('app.float.size_500'))
    .justifyContent(FlexAlign.SpaceAround)
  }
}
