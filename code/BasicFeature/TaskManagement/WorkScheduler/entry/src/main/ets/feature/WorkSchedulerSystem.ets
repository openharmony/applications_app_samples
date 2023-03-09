/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import fs from '@ohos.file.fs';
import Notification from '@ohos.notification'
import bundle from '@ohos.bundle.installer';
import account from '@ohos.account.osAccount'
import workScheduler from '@ohos.resourceschedule.workScheduler'
import http from '@ohos.net.http'
import { Logger } from '../utils/Logger'

const FILE_NAME = '/UpdateWorkScheduler.hap'
const BUNDLE_NAMES = ['ohos.samples.workschedulerextensionability']
const INSTALL_PARAMETER = 1

export namespace WorkSchedulerSystem {
  /**
   * Store the file to the specified directory.
   *
   * @param pathDir Path to save the file.
   * @param content The contents of the file to be saved.
   */
  export function saveFile(pathDir: string, content: ArrayBuffer): void {
    try {
      let filePath = pathDir + FILE_NAME
      let fd = fs.openSync(filePath, 0o2 | 0o100).fd
      fs.writeSync(fd, content)
      fs.closeSync(fd)
    } catch (err) {
      Logger.error(`saveFile failed, code is ${err.code}, message is ${err.message}`)
    }
  }

  /**
   * Sending a Notification.
   *
   * @param bundleName Check the name of the application that has permission.
   * @permission ohos.permission.NOTIFICATION_CONTROLLER
   */
  export async function handleNotification(bundleName: string): Promise<void> {
    let isHavePermission = await Notification.isNotificationEnabled({
      bundle: bundleName
    })
    if (!isHavePermission) {
      await Notification.enableNotification({
        bundle: bundleName
      }, true)
    }
    Notification.subscribe({
      onConsume: (data) => {
        if (data.request.content.normal.text === 'isReady') {
          AppStorage.SetOrCreate('isShowDialog', true)
        }
      }
    }, {
      bundleNames: BUNDLE_NAMES
    })
  }

  /**
   * Publishes a notification of the specified content.
   *
   * @param title Title of Notice.
   * @param text Content of Notification Text.
   * @param additionalText Additional text.
   * @permission ohos.permission.NOTIFICATION_CONTROLLER
   */
  export function publishNotification(title: string, text: string, additionalText: string): void {
    Notification.publish({
      content: {
        contentType: Notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title,
          text,
          additionalText
        }
      }
    })
  }

  /**
   * Install the application package in the specified path.
   *
   * @param filePath An array of paths to hold the installation package.
   * @permission ohos.permission.INSTALL_BUNDLE
   */
  export async function installBundle(filePath: Array<string>): Promise<void> {
    try {
      let bundleInstall = await bundle.getBundleInstaller()
      let userId = await account.getAccountManager().getOsAccountLocalIdFromProcess()
      bundleInstall.install(filePath, {
        userId: userId,
        installFlag: INSTALL_PARAMETER,
        isKeepData: false
      }, (status, statusMessage) => {
        Logger.info(`installBundle filepath is ${filePath}`)
        Logger.info(`installBundle code is ${status.code}, message is ${JSON.stringify(statusMessage)}`)
      })
    } catch (err) {
      Logger.error(`installBundle failed, code is ${err.code}, message is ${err.message}`)
    }
  }

  /**
   * Register the delayed task and pass the parameters.
   *
   * @param version Current application version.
   * @param bundleName The name of the application package for which the task needs to be registered.
   * @param filePath Storage address of the application package.
   */
  export async function startUpdateSample(version: string, bundleName: string, filePath: string): Promise<void> {
    try {
      let workInfo = {
        workId: 1,
        bundleName: bundleName,
        abilityName: 'FormAbility',
        networkType: workScheduler.NetworkType.NETWORK_TYPE_WIFI,
        parameters: {
          version: version,
          filePath: filePath
        }
      }
      workScheduler.startWork(workInfo)
    }
    catch (err) {
      Logger.error(`startWork failed, code is ${err.code}, message is ${err.message}`)
    }
  }

  /**
   * Register the delayed task and pass the parameters.
   *
   * @param url Url of the application package.
   * @permission ohos.permission.INTERNET
   */
  export async function getNewHap(url: string): Promise<http.HttpResponse> {
    try {
      return await http.createHttp().request(
        url,
        {
          expectDataType: http.HttpDataType.ARRAY_BUFFER
        })
    } catch (err) {
      Logger.error(`get result failed, code is ${err.code}, message is ${err.message}`)
    }
  }
}
