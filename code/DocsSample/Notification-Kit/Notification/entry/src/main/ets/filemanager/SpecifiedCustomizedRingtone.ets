/*
 * Copyright (c) 2025-2026 Huawei Device Co., Ltd.
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

// [Start specified_customized_ringtone_header]
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import resourceManager from '@ohos.resourceManager';
import { contextConstant, common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';

const TAG: string = '[SpecifiedCustomizedRingtone]';
const DOMAIN_NUMBER: number = 0xFF00;
// [End specified_customized_ringtone_header]

@Entry
@Component
export struct SpecifiedCustomizedRingtone {
  @Consume('pageInfos') pageInfos: NavPathStack;

  // [Start specified_customized_ringtone_get_context]
  private context: common.UIAbilityContext | null = null;

  aboutToAppear() {
    const uiContext = this.getUIContext();
    this.context = uiContext.getHostContext() as common.UIAbilityContext;
    hilog.info(DOMAIN_NUMBER, TAG, 'Context obtained in aboutToAppear.');
  }
  // [End specified_customized_ringtone_get_context]
  // [Start specified_customized_ringtone_save_file]
  async sendFileToEl1(path = 'ringtone_demo.mp3'): Promise<void> {
    if (!this.context) {
      hilog.info(DOMAIN_NUMBER, TAG, 'Context is not initialized.');
      return;
    }

    try {
      let fileDescriptor: resourceManager.RawFileDescriptor = await this.context.resourceManager.getRawFd(path);
      const applicationContext: common.ApplicationContext = this.context.getApplicationContext();
      applicationContext.area = contextConstant.AreaMode.EL1;
      const sanBoxPath: string = applicationContext.filesDir;
      let filePath: string = sanBoxPath + '/' + path;
      let dest: fs.File = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
      let bufsize: number = 4096;
      let buf: ArrayBuffer = new ArrayBuffer(bufsize);
      let off: number = 0;
      let len: number = 0;
      let readedLen: number = 0;

      while (true) {
        len = fs.readSync(fileDescriptor.fd, buf, { offset: fileDescriptor.offset + off, length: bufsize });
        if (!len) {
          break;
        }
        readedLen += len
        fs.writeSync(dest.fd, buf, { offset: off, length: len })
        off = off + len
        if ((fileDescriptor.length - readedLen) < bufsize) {
          bufsize = fileDescriptor.length - readedLen
        }
      }
      fs.close(dest.fd);
      fs.close(fileDescriptor.fd);
      hilog.info(DOMAIN_NUMBER, TAG, 'sendFIleToEl1 success.');
    } catch (error) {
      hilog.info(DOMAIN_NUMBER, TAG, `sendFIleToEl1 error: ${JSON.stringify(error)}`);
    }
  }
  // [End specified_customized_ringtone_save_file]
  build() {
    NavDestination() {
      Column() {
        Button($r('app.string.specified_resources_rawfile'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start specified_resources_rawfile]
            let notificationRequest: notificationManager.NotificationRequest = {
              id: 0,
              notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
              content: {
                notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                normal: {
                  title: 'title',
                  text: 'text',
                  additionalText: 'test_additionalText'
                }
              },
              sound: 'ringtone_demo.mp3'
            }

            notificationManager.publish(notificationRequest).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in publishing notification.`);
            }).catch((err: BusinessError) => {
              hilog.info(DOMAIN_NUMBER, TAG, `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
            });
            // [End specified_resources_rawfile]
          })

        Button($r('app.string.copy_ringtone_file_to_sandbox'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start copy_ringtone_file_to_sandbox]
            let fileName: string = 'ringtone_demo.mp3';
            this.sendFileToEl1(fileName);
            // [End copy_ringtone_file_to_sandbox]
          })

        Button($r('app.string.specified_sandbox_file'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start specified_sandbox_file]
            let fileName: string = 'ringtone_demo.mp3';
            const applicationContext = this.context!.getApplicationContext();
            applicationContext.area = contextConstant.AreaMode.EL1;
            let bundleName: string = this.context!.applicationInfo.name;
            let sanBoxPath = 'uri::file://' + bundleName + applicationContext.filesDir + '/' + fileName;
            let notificationRequest: notificationManager.NotificationRequest = {
              id: 0,
              notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
              content: {
                notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                normal: {
                  title: 'title',
                  text: 'text',
                  additionalText: 'test_additionalText'
                }
              },
              sound: sanBoxPath
            }
            notificationManager.publish(notificationRequest).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in publishing notification.`);
            }).catch((err: BusinessError) => {
              hilog.info(DOMAIN_NUMBER, TAG, `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
            });
            // [End specified_sandbox_file]
          })
      }
      .width('100%')
      .height('100%')

    }
    .title('SpecifiedCustomizedRingtone')
  }
}