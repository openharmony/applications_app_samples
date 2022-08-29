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

import prompt from '@ohos.prompt'
import AbilityContextController from '../feature/AbilityContextController'
import { PublicTitleBar } from './component/PublicTitleBar'

@Entry
@Component
struct AbilityContextPage {
  private abilityContext: AbilityContextController
  private appContext: any = null

  build() {
    Column() {
      PublicTitleBar({ textName: $r('app.string.ability_context_page') })
      Scroll() {
        Column() {
          Button($r('app.string.start_ability'))
            .fancy(() => {
              this.abilityContext.startAbility()
            })
          Button($r('app.string.start_ability_forResult'))
            .fancy(() => {
              this.abilityContext.startAbilityForResult()
            })
          Button($r('app.string.start_ability_for_result_with_account'))
            .fancy(() => {
              this.abilityContext.startAbilityForResultWithAccount()
            })
          Button($r('app.string.start_service_extension_ability'))
            .fancy(() => {
              this.abilityContext.startServiceExtensionAbility()
            })
          Button($r('app.string.start_service_extension_ability_with_account'))
            .fancy(() => {
              this.abilityContext.startServiceExtensionAbilityWithAccount()
            })
          Button($r('app.string.stop_service_extension_ability'))
            .fancy(() => {
              this.abilityContext.stopServiceExtensionAbility()
            })
          Button($r('app.string.stop_service_extension_ability_with_account'))
            .fancy(() => {
              this.abilityContext.stopServiceExtensionAbilityWithAccount()
            })
          Button($r('app.string.terminate_self'))
            .fancy(() => {
              this.abilityContext.terminateSelf()
            })
          Button($r('app.string.terminate_self_with_result'))
            .fancy(() => {
              this.abilityContext.terminateSelfWithResult()
            })
          Button($r('app.string.connect_ability'))
            .fancy(() => {
              this.abilityContext.connectAbility()
            })
          Button($r('app.string.connect_ability_with_account'))
            .fancy(() => {
              this.abilityContext.connectAbilityWithAccount()
            })
          Button($r('app.string.disconnect_ability'))
            .fancy(() => {
              this.abilityContext.disconnectAbility()
            })
          Button($r('app.string.start_ability_with_account'))
            .fancy(() => {
              this.abilityContext.startAbilityWithAccount()
            })
          Button($r('app.string.request_permissions_from_user'))
            .fancy(() => {
              this.abilityContext.requestPermissionsFromUser()
            })
          Button($r('app.string.set_mission_label'))
            .fancy(() => {
              this.abilityContext.setMissionLabel()
            })
          Button($r('app.string.is_terminating'))
            .fancy(() => {
              this.abilityContext.isTerminating()
            })

          // 指示有关能力的配置信息,对应FA模型的getAbilityInfo方法
          Button($r('app.string.ability_info'))
            .fancy(() => {
              this.appContext.abilityInfo
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.abilityInfo)}`
              })
            })

          // 指示有关模块的配置信息,对应FA模型的getHapModuleInfo()方法
          Button($r('app.string.current_hap_module_info'))
            .fancy(() => {
              this.appContext.currentHapModuleInfo
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.currentHapModuleInfo)}`
              })
            })

          // 指示配置信息。
          Button($r('app.string.config'))
            .fancy(() => {
              this.appContext.config
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.config)}`
              })
            })

          // 指示访问应用程序资源的能力。
          Button($r('app.string.resource_manager'))
            .fancy(() => {
              this.appContext.resourceManager
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.resourceManager)}`
              })
            })

          // 指示有关应用程序的配置信息。
          Button($r('app.string.application_info'))
            .fancy(() => {
              this.appContext.applicationInfo
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.applicationInfo)}`
              })
            })

          // 指示应用缓存目录，对应FA模型appContext下的getCacheDir()方法
          Button($r('app.string.cache_dir'))
            .fancy(() => {
              this.appContext.cacheDir
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.cacheDir)}`
              })
            })

          // 指示应用程序临时目录。
          Button($r('app.string.temp_dir'))
            .fancy(() => {
              this.appContext.tempDir
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.tempDir)}`
              })
            })

          // 指示应用程序文件目录,对应FA模型的getFilesDir()方法
          Button($r('app.string.files_dir'))
            .fancy(() => {
              this.appContext.filesDir
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.filesDir)}`
              })
            })

          // 指示应用程序数据库目录。
          Button($r('app.string.database_dir'))
            .fancy(() => {
              this.appContext.databaseDir
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.databaseDir)}`
              })
            })

          // 指示应用程序首选项目录。
          Button($r('app.string.preferences_dir'))
            .fancy(() => {
              this.appContext.preferencesDir
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.preferencesDir)}`
              })
            })

          // 指示应用程序分发文件目录,对应FA模型的getOrCreateDistributedDir()方法
          Button($r('app.string.distributed_files_dir'))
            .fancy(() => {
              this.appContext.distributedFilesDir
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.distributedFilesDir)}`
              })
            })

          // 指示当前设备的屏幕方向。对应FA的getDisplayOrientation()
          Button($r('app.string.direction'))
            .fancy(() => {
              this.appContext.config.direction
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.config.direction)}`
              })
            })

          // 指示文件区域。
          Button($r('app.string.area'))
            .fancy(() => {
              this.appContext.area
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.area)}`
              })
            })

          // 指示上下文是FA模式或阶段模式。
          Button($r('app.string.stage_mode'))
            .fancy(() => {
              this.appContext.stageMode
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.stageMode)}`
              })
            })

          // 获取应用上下文信息,对应FA模型的getApplicationContext()方法
          Button($r('app.string.get_application_context'))
            .fancy(() => {
              this.appContext.getApplicationContext()
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.getApplicationContext())}`
              })
            })

          // 获取当前ability的捆绑包名称,对应FA模型的getBundleName()
          Button($r('app.string.bundle_name'))
            .fancy(() => {
              this.appContext.abilityInfo.bundleName
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.abilityInfo.bundleName)}`
              })
            })

          // 获取有关当前进程的信息，包括进程名称,对应FA模型的getProcessInfo()
          Button($r('app.string.description_id'))
            .fancy(() => {
              this.appContext.abilityInfo.descriptionId
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.abilityInfo.descriptionId)}`
              })
            })

          // 获取有关当前进程的信息，包括进程ID,对应FA模型的getProcessInfo()
          Button($r('app.string.name'))
            .fancy(() => {
              this.appContext.abilityInfo.name
              prompt.showToast({
                message: `${JSON.stringify(this.appContext.abilityInfo.name)}`
              })
            })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%' })
  }

  aboutToAppear() {
    this.appContext = getContext(this)
    this.abilityContext = new AbilityContextController(this.appContext)
  }
}

@Extend(Button) function fancy (click) {
  .width('60%')
  .height(40)
  .align(Alignment.Center)
  .margin({ top: 30 })
  .onClick(click)
}