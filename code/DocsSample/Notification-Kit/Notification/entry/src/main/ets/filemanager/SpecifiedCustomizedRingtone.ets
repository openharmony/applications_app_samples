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
import { contextConstant, common } from '@kit.AbilityKit';
import { fileIo as fs, fileUri } from '@kit.CoreFileKit';

const TAG: string = '[SpecifiedCustomizedRingtone]';
const DOMAIN_NUMBER: number = 0xFF00;
const SOUND_FILE_NAME: string = 'ringtone_demo.mp3'; // 实际项目中请替换为自己的音频文件
// [End specified_customized_ringtone_header]

@Component
export struct SpecifiedCustomizedRingtone {
  @Consume('pageInfos') pageInfos: NavPathStack;

  publishNotification(soundFile: string): void {
    // [Start specified_customized_ringtone_publish_notification]
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
      sound: soundFile
    }

    notificationManager.publish(notificationRequest).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
    });
    // [End specified_customized_ringtone_publish_notification]
  }

  build() {
    NavDestination() {
      Column() {
        Button($r('app.string.specified_resources_rawfile'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start specified_resources_rawfile]
            let soundFile: string = SOUND_FILE_NAME; // 需要替换为resources/rawfile目录下对应的音频文件
            // [End specified_resources_rawfile]
            this.publishNotification(soundFile);
          })

        Button($r('app.string.specified_sandbox_file'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            // [Start specified_customized_ringtone_getAppContext]
            // 生成沙箱内音频资源路径
            const uiContext: UIContext = this.getUIContext();
            let context: Context | undefined = uiContext.getHostContext() as common.UIAbilityContext;
            if (!context) {
              hilog.error(DOMAIN_NUMBER, TAG, 'Context is not initialized.');
              return;
            }
            const applicationContext: common.ApplicationContext = context.getApplicationContext();
            applicationContext.area = contextConstant.AreaMode.EL1; // 必须在EL1沙箱下
            const sandboxDir: string = applicationContext.filesDir;
            let sandboxFilePath: string = sandboxDir + '/' + SOUND_FILE_NAME;
            // [End specified_customized_ringtone_getAppContext]
            // [Start specified_customized_ringtone_copyToSandbox]
            // 拷贝resources/rawfile/目录下的音频文件到应用沙箱EL1的files目录下
            try {
              let rawFileData: Uint8Array = context.resourceManager.getRawFileContentSync(SOUND_FILE_NAME);
              if (!fs.accessSync(sandboxDir)) {
                fs.mkdirSync(sandboxDir, true);
              }
              const file = fs.openSync(sandboxFilePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
              fs.writeSync(file.fd, rawFileData.buffer);
              fs.closeSync(file);
              hilog.info(DOMAIN_NUMBER, TAG, 'copy file to sandbox success.');
            } catch (error) {
              hilog.error(DOMAIN_NUMBER, TAG, `copy file to sandbox error: ${JSON.stringify(error)}`);
              return;
            }
            // [End specified_customized_ringtone_copyToSandbox]
            // [Start specified_sandbox_file]
            // 获取沙箱文件uri
            let sandboxFileUri: string = fileUri.getUriFromPath(sandboxFilePath)
            let soundFile: string = 'uri::' + sandboxFileUri; // 必须以uri::开头, 且路径中不能包含'../'和'/..'
            // [End specified_sandbox_file]
            this.publishNotification(soundFile);
          })
      }
      .width('100%')
      .height('100%')

    }
    .title('SpecifiedCustomizedRingtone')
  }
}