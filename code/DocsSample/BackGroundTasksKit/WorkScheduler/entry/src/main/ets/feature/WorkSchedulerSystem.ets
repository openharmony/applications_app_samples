/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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

import { fileIo as fs } from '@kit.CoreFileKit';
import { notificationManager, notificationSubscribe } from '@kit.NotificationKit';

import { installer } from '@kit.AbilityKit';
import { osAccount, BusinessError } from '@kit.BasicServicesKit';
import { workScheduler } from '@kit.BackgroundTasksKit';
import { http } from '@kit.NetworkKit';
import { Logger } from '../utils/Logger';

const FILE_NAME = '/UpdateWorkScheduler.hap';
const BUNDLE_NAMES = ['ohos.samples.workschedulerextensionability'];
const INSTALL_PARAMETER = 1;

export namespace WorkSchedulerSystem {
  /**
   * Store the file to the specified directory.
   *
   * @param pathDir Path to save the file.
   * @param content The contents of the file to be saved.
   */
  export function saveFile(pathDir: string, content: ArrayBuffer): void {
    try {
      let filePath = pathDir + FILE_NAME;
      let fd = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).fd;
      fs.writeSync(fd, content);
      fs.closeSync(fd);
    } catch (err) {
      Logger.error(`saveFile failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * Sending a Notification.
   *
   * @permission ohos.permission.NOTIFICATION_CONTROLLER
   */
  export async function handleNotification(): Promise<void> {
    await notificationManager.requestEnableNotification();
    notificationSubscribe.subscribe({
      onConsume: (data) => {
        if (data.request.content.normal?.text === 'isReady') {
          AppStorage.SetOrCreate('isShowDialog', true);
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
    Logger.info(`publishNotification start`);
    let notificationRequest: notificationManager.NotificationRequest = {
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title,
          text,
          additionalText
        }
      }
    }
    notificationManager.publish(notificationRequest, (err: BusinessError) => {
      if (err) {
        Logger.error(`publishNotification failed`);
      }
    })
    Logger.info(`publishNotification success`);
  }

  /**
   * Install the application package in the specified path.
   *
   * @param filePath An array of paths to hold the installation package.
   * @permission ohos.permission.INSTALL_BUNDLE
   */
  export async function installBundle(filePath: Array<string>, workInfo: workScheduler.WorkInfo): Promise<void> {
    try {
      let bundleInstall = await installer.getBundleInstaller();
      let userId = await osAccount.getAccountManager().getOsAccountLocalId();
      bundleInstall.install(filePath, {
        userId: userId,
        installFlag: INSTALL_PARAMETER,
        isKeepData: false
      }, (status, statusMessage) => {
        Logger.info(`installBundle filepath is ${filePath}`);
        Logger.info(`installBundle code is ${status.code}, message is ${JSON.stringify(statusMessage)}`);
        stopWork(workInfo);
      })
    } catch (err) {
      Logger.error(`installBundle failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * Register the delayed task and pass the parameters.
   *
   * @param version Current application version.
   * @param filePath Storage address of the application package.
   */
  export async function startUpdateSample(version: string, filePath: string): Promise<void> {
    // [Start startWork]
    // [Start stopWork]
    let workInfo: workScheduler.WorkInfo = {
      workId: 1,
      networkType: workScheduler.NetworkType.NETWORK_TYPE_ANY,
      bundleName: 'ohos.samples.workschedulerextensionability',
      abilityName: 'WorkSchedulerAbility',
      // [StartExclude startWork]
      // [StartExclude stopWork]
      parameters: {
        version: version,
        filePath: filePath
      }
      // [EndExclude startWork]
      // [EndExclude stopWork]
    }

    // [StartExclude stopWork]
    try {
      workScheduler.startWork(workInfo);
      console.info(`startWork success`);
    }
    catch (error) {
      console.error(`startWork failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
    // [End startWork]
  }

  async function stopWork(workInfo: workScheduler.WorkInfo): Promise<void> {
    // [EndExclude stopWork]
    try {
      workScheduler.stopWork(workInfo);
      console.info(`stopWork success`);
    } catch (error) {
      console.error(`stopWork failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
    // [End stopWork]
  }

  /**
   * Register the delayed task and pass the parameters.
   *
   * @param url Url of the application package.
   * @permission ohos.permission.INTERNET
   */
  export async function getNewHap(url: string): Promise<http.HttpResponse> {
    let result = await http.createHttp().request(
      url,
      {
        expectDataType: http.HttpDataType.ARRAY_BUFFER
      }).catch((err: BusinessError) => {
      Logger.error(`get result failed, code is ${err.code}, message is ${err.message}`);
    });
    return result as http.HttpResponse;
  }
}
