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

import bundle from '@ohos.bundle.bundleManager'
import prompt from '@ohos.promptAction'
import Logger from '../util/Logger'

const TAG: string = 'BundleController'

let bundleName = "ohos.samples.stagemodel"
let bundleFlags = 0
let userId = 100

export default class BundleController {

  // 获取有关当前应用程序的信息,对应FA模型的getApplicationInfo()
  getApplicationInfo() {
    bundle.getApplicationInfo(bundleName, bundleFlags, userId)
      .then((data) => {
        Logger.info(TAG, `getApplicationInfo successful. Data: ${JSON.stringify(data)}`)
        prompt.showToast({
          message: `getApplicationInfo successful`
        })
      }).catch((error) => {
      Logger.error(TAG, `getApplicationInfo. Cause: ${JSON.stringify(error)}`)
      prompt.showToast({
        message: `getApplicationInfo. Cause: ${JSON.stringify(error)}`
      })
    })
  }

  // 指示应用程序的实体类型,对应FA模型中AppContext的getAppType()
  entityType() {
    bundle.getApplicationInfo(bundleName, bundleFlags, userId)
      .then((data) => {
        let digital = data.description
        if (digital === null) {
          Logger.info(TAG, `digital is null`)
          return
        }
        Logger.info(TAG, `caller onRelease is called: ${digital}`)
        prompt.showToast({
          message: `caller onRelease is called sucess`
        })
      }).catch((error) => {
      Logger.info(TAG, `caller onRelease is error: ${error}`)
    })
  }

  // 应用程序的进程，如果用户未设置，则值等于bundleName
  process() {
    bundle.getApplicationInfo(bundleName, bundleFlags, userId)
      .then((data) => {
        let process = data.process
        if (process === null) {
          Logger.info(TAG, `process is null`)
          return
        }
        Logger.info(TAG, `caller onRelease is called: ${process}`)
        prompt.showToast({
          message: `caller onRelease is called sucess`
        })
      }).catch((error) => {
      Logger.info(TAG, `caller onRelease is error: ${error}`)
    })
  }

  // 获取应用程序的本地根目录,对应FA模型的getOrCreateLocalDir()
  entryDir() {
    bundle.getApplicationInfo(bundleName, bundleFlags, userId)
      .then((data) => {
        let entryDirData = data.codePath
        if (entryDirData === null) {
          Logger.info(TAG, `codePath is null`)
          return
        }
        Logger.info(TAG, `codePath: ${entryDirData}`)
        prompt.showToast({
          message: `codePath: ${entryDirData}`
        })
      }).catch((error) => {
      Logger.info(TAG, `caller onRelease is error: ${error}`)
    })
  }

  // 获取应用的版本信息,对应FA模型的getAppVersionInfo()
  getDispatcherVersion() {
    let bundleName = "ohos.samples.stagemodel"
    let bundleFlags = bundle.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE | bundle.BundleFlag.GET_BUNDLE_INFO_WITH_EXTENSION_ABILITY;

    try {
      bundle.getBundleInfo(bundleName, bundleFlags, (err, data) => {
        if (err) {
          Logger.error(TAG, `getDispatcherVersion() failed. Cause: ${JSON.stringify(err.message)}`)
          prompt.showToast({
            message: `Operation failed. Cause: ${JSON.stringify(err)}`
          })
        } else {
          prompt.showToast({
            message: `Operation successful. Data: ${JSON.stringify(data.targetVersion)}`
          })
        }
      })
    } catch (err) {
      Logger.error(TAG, `getDispatcherVersion() failed. Cause: ${JSON.stringify(err.message)}`)
      prompt.showToast({
        message: `Operation failed. Cause: ${JSON.stringify(err)}`
      })
    }
  }

  // 获取有关当前能力的信息,对应FA模型的getElementName()
  getAbilityInfo() {
    let bundleName = "ohos.samples.stagemodel"
    let bundleFlags = bundle.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE | bundle.BundleFlag.GET_BUNDLE_INFO_WITH_EXTENSION_ABILITY | bundle.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY;

    try {
      bundle.getBundleInfo(bundleName, bundleFlags, (err, data) => {
        if (err) {
          Logger.error(TAG, `getAbilityInfo() failed. Cause: ${JSON.stringify(err.message)}`)
          prompt.showToast({
            message: `Operation failed. Cause: ${JSON.stringify(err)}`
          })
        } else {
          prompt.showToast({
            message: `Operation successful. Data: ${JSON.stringify(data)}`
          })
        }
      })
    } catch (err) {
      Logger.error(TAG, `getAbilityInfo() failed. Cause: ${JSON.stringify(err.message)}`)
      prompt.showToast({
        message: `Operation failed. Cause: ${JSON.stringify(err)}`
      })
    }
  }
}