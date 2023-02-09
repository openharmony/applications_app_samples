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

import router from '@ohos.router'
import AppContext from '../feature/AppContext'

@Entry
@Component
struct AppContextPage {
  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(32)
          .height(32)
          .margin({ left: 32, right: 32 })
          .onClick(() => {
            router.back()
          })
        Text($r('app.string.app_context'))
          .fontColor(Color.Black)
          .fontSize(30)
          .fontWeight(500)
          .layoutWeight(1)
      }
      .width('100%')
      .height('8%')

      Scroll() {
        Column() {
          this.ButtonStyle($r('app.string.get_or_create_local_dir'), AppContext.getOrCreateLocalDir)
          this.ButtonStyle($r('app.string.verify_permission'), AppContext.verifyPermission)
          this.ButtonStyle($r('app.string.request_permission'), AppContext.requestPermissionsFromUser)
          this.ButtonStyle($r('app.string.get_application_info'), AppContext.getApplicationInfo)
          this.ButtonStyle($r('app.string.get_bundle_name'), AppContext.getBundleName)
          this.ButtonStyle($r('app.string.get_display_orientation'), AppContext.getDisplayOrientation)
          this.ButtonStyle($r('app.string.set_display_orientation'), AppContext.setDisplayOrientation)
          this.ButtonStyle($r('app.string.set_show_on_lock_screen'), AppContext.setShowOnLockScreen)
          this.ButtonStyle($r('app.string.set_wake_up_screen'), AppContext.setWakeUpScreen)
          this.ButtonStyle($r('app.string.get_process_info'), AppContext.getProcessInfo)
          this.ButtonStyle($r('app.string.get_element_name'), AppContext.getElementName)
          this.ButtonStyle($r('app.string.get_calling_bundle'), AppContext.getCallingBundle)
          this.ButtonStyle($r('app.string.get_cache_dir'), AppContext.getCacheDir)
          this.ButtonStyle($r('app.string.get_files_dir'), AppContext.getFilesDir)
          this.ButtonStyle($r('app.string.get_or_create_distributed_dir'), AppContext.getOrCreateDistributedDir)
          this.ButtonStyle($r('app.string.get_app_type'), AppContext.getAppType)
          this.ButtonStyle($r('app.string.get_hap_module_info'), AppContext.getHapModuleInfo)
          this.ButtonStyle($r('app.string.get_app_version_info'), AppContext.getAppVersionInfo)
          this.ButtonStyle($r('app.string.get_ability_info'), AppContext.getAbilityInfo)
          this.ButtonStyle($r('app.string.get_application_context'), AppContext.getApplicationContext)
          this.ButtonStyle($r('app.string.is_updating_configurations'), AppContext.isUpdatingConfigurations)
          this.ButtonStyle($r('app.string.print_drawn_completed'), AppContext.printDrawnCompleted)
        }
        .width('100%')
      }
      .width('100%')
      .height('92%')
    }
    .width('100%')
  }

  @Builder ButtonStyle(textStr: Resource, click) {
    Button(textStr)
      .width('60%')
      .margin({ top: 30 })
      .onClick(click)
  }
}