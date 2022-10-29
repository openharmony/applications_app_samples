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

import bundle from '@ohos.bundle'
import featureAbility from '@ohos.ability.featureAbility'
import prompt from '@ohos.prompt'
import Logger from '../util/Logger'
import { BUNDLE_NAME } from '../model/DaHelperConst'

const TAG: string = 'AppContext'
const context = featureAbility.getContext()

class AppContext {

  // 获取应用程序的本地根目录
  getOrCreateLocalDir() {
    context.getOrCreateLocalDir((err, data) => {
      Logger.info(TAG, `getOrCreateLocalDir err = ${JSON.stringify(err)}, data = ${data}`)
      prompt.showToast({
        message: `getWant success ${data}`
      })
    })
  }

  // 验证系统中运行的特定pid和uid是否允许指定的权限，Stage模型中abilityAccessCtrl.verifyAccessToken
  verifyPermission() {
    bundle.getBundleInfo(BUNDLE_NAME, 1, (err, dataInfo) => { // 1代表要查询的应用包标志
      context.verifyPermission('ohos.permission.WRITE_MEDIA', { uid: dataInfo.uid }, (error, data) => {
        Logger.info(TAG, `verifyPermission err = ${JSON.stringify(error)}, data = ${data}`)
        prompt.showToast({
          message: `verifyPermission success ${data}`
        })
      })
    })
  }

  // 获取权限，对应stage模型AbilityContextController中的requestPermissionsFromUser
  requestPermissionsFromUser() {
    let requestCode = 666 // 请求码
    context.requestPermissionsFromUser([''], requestCode, (err, data) => {
      Logger.info(TAG, `requestPermissionsFromUser err = ${JSON.stringify(err)}, requestCode = ${data.requestCode}`)
      prompt.showToast({
        message: `requestPermissionsFromUser success ${JSON.stringify(data)}`
      })
    })
  }

  // 获取有关当前应用程序的信息，Stage模型中BundleController中的getApplicationInfo
  getApplicationInfo() {
    context.getApplicationInfo((err, data) => {
      Logger.info(TAG, `getApplicationInfo err = ${JSON.stringify(err)}, data = ${JSON.stringify(data)}`)
      prompt.showToast({
        message: `getApplicationInfo success ${JSON.stringify(data)}`
      })
    })
  }

  // 获取当前ability的捆绑包名称，Stage模型的abilityinfo.bundleName
  getBundleName() {
    context.getBundleName((err, data) => {
      Logger.info(TAG, `getBundleName err = ${JSON.stringify(err)}, data = ${JSON.stringify(data)}`)
      prompt.showToast({
        message: `getBundleName success ${JSON.stringify(data)}`
      })
    })
  }

  // 获取此能力的当前显示方向，Stage模型中Configuration.direction
  getDisplayOrientation() {
    context.getDisplayOrientation((err, data) => {
      Logger.info(TAG, `getDisplayOrientation err = ${JSON.stringify(err)}, data = ${JSON.stringify(data)}`)
      prompt.showToast({
        message: `getDisplayOrientation success ${JSON.stringify(data)}`
      })
    })
  }

  // 设置当前能力的显示方向，Stage模型中window的setPreferredOrientation
  async setDisplayOrientation() {
    let initialOrientation: bundle.DisplayOrientation = await context.getDisplayOrientation()
    Logger.info(TAG, `await getDisplayOrientation orientation = ${JSON.stringify(initialOrientation)}`)
    if (initialOrientation === bundle.DisplayOrientation.LANDSCAPE) {
      initialOrientation = bundle.DisplayOrientation.PORTRAIT
    } else {
      initialOrientation = bundle.DisplayOrientation.LANDSCAPE
    }
    await context.setDisplayOrientation(initialOrientation)
    Logger.info(TAG, `await setDisplayOrientation`)
    prompt.showToast({
      message: $r('app.string.set_orientation_success')
    })
  }

  // 设置每当显示锁屏时是否在锁屏顶部显示此功能，Stage模型MainAbility中的windowStage.setShowOnLockScreen
  setShowOnLockScreen() {
    context.setShowOnLockScreen(true, (err) => {
      Logger.info(TAG, `setShowOnLockScreen err = ${JSON.stringify(err)}}`)
      prompt.showToast({
        message: `setShowOnLockScreen success`
      })
    })
  }

  // 设置恢复此功能时是否唤醒屏幕，Stage模型WindowController中的setWakeUpScreen
  setWakeUpScreen() {
    context.setWakeUpScreen(true, (err) => {
      Logger.info(TAG, `setWakeUpScreen err = ${JSON.stringify(err)}}`)
      prompt.showToast({
        message: `setWakeUpScreen success`
      })
    })
  }

  // 获取有关当前进程的信息，包括进程ID和名称，Stage模型ApplicationInfo
  getProcessInfo() {
    context.getProcessInfo((err, data) => {
      Logger.info(TAG, `getProcessInfo err = ${JSON.stringify(err)}, data = ${JSON.stringify(data)}`)
      prompt.showToast({
        message: `getProcessInfo success ${JSON.stringify(data)}`
      })
    })
  }

  // 获取当前ability的ohos.bundle.ElementName对象，Stage模型abilityinfo
  getElementName() {
    context.getElementName((err, data) => {
      Logger.info(TAG, `getElementName err = ${JSON.stringify(err)}, data = ${JSON.stringify(data)}`)
      prompt.showToast({
        message: `getElementName success ${JSON.stringify(data)}`
      })
    })
  }

  // 获取当前进程的名称，Stage模型中BundleController中的process
  getProcessName() {
    context.getProcessName((err, data) => {
      Logger.info(TAG, `getProcessName err = ${JSON.stringify(err)}, data = ${data}`)
      prompt.showToast({
        message: `getProcessName success ${data}`
      })
    })
  }

  // 获取调用ability的包名称，Stage模型want.parameters
  getCallingBundle() {
    context.getCallingBundle((err, data) => {
      Logger.info(TAG, `getCallingBundle err = ${JSON.stringify(err)}, data = ${data}`)
      prompt.showToast({
        message: `getCallingBundle success ${data}`
      })
    })
  }

  // 获取该应用程序的内部存储目录,对应stage模型appcontext的cacheDir属性
  getCacheDir() {
    context.getCacheDir((err, data) => {
      Logger.info(TAG, `getCacheDir err = ${JSON.stringify(err)}, data = ${data}`)
      prompt.showToast({
        message: `getCacheDir success ${data}`
      })
    })
  }

  // 获取内部存储器上此应用程序的文件目录，对应stage模型appcontext的filesDir属性
  getFilesDir() {
    context.getFilesDir((err, data) => {
      Logger.info(TAG, `getFilesDir err = ${JSON.stringify(err)}, data = ${data}`)
      prompt.showToast({
        message: `getFilesDir success ${data}`
      })
    })
  }

  // 获取Ability或应用的分布式文件路径，对应stage模型appcontext的distributedFilesDir属性
  getOrCreateDistributedDir() {
    context.getOrCreateDistributedDir((err, data) => {
      Logger.info(TAG, `getOrCreateDistributedDir err = ${JSON.stringify(err)}, data = ${data}`)
      prompt.showToast({
        message: `getOrCreateDistributedDir success ${data}`
      })
    })
  }

  // 获取此应用的类型，对应stage模型BundleController的entityType
  getAppType() {
    context.getAppType((err, data) => {
      Logger.info(TAG, `getAppType err = ${JSON.stringify(err)}, data = ${data}`)
      prompt.showToast({
        message: `getAppType success ${data}`
      })
    })
  }

  // 获取应用的ModuleInfo对象，对应stage模型appcontext的currentHapModuleInfo属性
  getHapModuleInfo() {
    context.getHapModuleInfo((err, data) => {
      Logger.info(TAG, `getHapModuleInfo err = ${JSON.stringify(err)}, data = ${JSON.stringify(data)}`)
      prompt.showToast({
        message: `getHapModuleInfo success ${JSON.stringify(data)}`
      })
    })
  }

  // 获取应用的版本信息，Stage模型bundle.getDispatcherVersion
  getAppVersionInfo() {
    context.getAppVersionInfo((err, data) => {
      Logger.info(TAG, `getAppVersionInfo err = ${JSON.stringify(err)}, data = ${JSON.stringify(data)}`)
      prompt.showToast({
        message: `getAppVersionInfo success ${JSON.stringify(data)}`
      })
    })
  }

  // 查询当前归属Ability详细信息，对应stage模型appcontext的abilityInfo属性
  getAbilityInfo() {
    context.getAbilityInfo((err, data) => {
      Logger.info(TAG, `getAbilityInfo err = ${JSON.stringify(err)}, data = ${JSON.stringify(data)}`)
      prompt.showToast({
        message: `getAbilityInfo success ${data}`
      })
    })
  }

  // 获取应用上下文信息，对应stage模型appcontext的getApplicationContext
  getApplicationContext() {
    let appLicationContext = context.getApplicationContext()
    Logger.info(TAG, `getApplicationContext ${JSON.stringify(appLicationContext)}`)
    prompt.showToast({
      message: `getApplicationContext success`
    })
  }

  // 检查此能力的配置是否正在更改，Stage模型不支持
  isUpdatingConfigurations() {
    context.isUpdatingConfigurations((err, data) => {
      Logger.info(TAG, `isUpdatingConfigurations err = ${JSON.stringify(err)}, data = ${data}`)
      prompt.showToast({
        message: `isUpdatingConfigurations success ${data}`
      })
    })
  }

  // 通知系统绘制此页面功能所需的时间，Stage模型不支持
  printDrawnCompleted() {
    context.printDrawnCompleted((err, data) => {
      Logger.info(TAG, `printDrawnCompleted err = ${JSON.stringify(err)}, data = ${data}`)
      prompt.showToast({
        message: `printDrawnCompleted success ${data}`
      })
    })
  }
}

export default new AppContext()