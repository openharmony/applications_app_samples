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

import Base from '@ohos.base';
import image from '@ohos.multimedia.image';
import notificationManager from '@ohos.notificationManager';
import wantAgent from '@ohos.app.ability.wantAgent';
import { WantAgent } from '@ohos.app.ability.wantAgent'
import hilog from '@ohos.hilog';
import resourceManager from '@ohos.resourceManager';

const TAG: string = '[PublishOperation]';
const DOMAIN_NUMBER: number = 0xFF00;

export default class PublishOperation {
  private context: Context;

  constructor(context: Context) {
    this.context = context;
  }

  enableNotification = async () => {
    notificationManager.isNotificationEnabled().then((data: boolean) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'isNotificationEnabled success, data: ' + JSON.stringify(data));
      if(!data){
        notificationManager.requestEnableNotification().then(() => {
          hilog.info(DOMAIN_NUMBER, TAG, `[ANS] requestEnableNotification success`);
        }).catch((err:Base.BusinessError) => {
          hilog.error(DOMAIN_NUMBER, TAG,
            `[ANS] requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
        });
      }
    }).catch((err: Base.BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, `isNotificationEnabled fail: ${JSON.stringify(err)}`);
    });
  }
  publishBasic = async () => {
    let notificationRequest: notificationManager.NotificationRequest = {
      id: 1,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT, // 普通文本类型通知
        normal: {
          title: 'test_title',
          text: 'test_text',
          additionalText: 'test_additionalText',
        }
      }
    };

    // 发布通知
    notificationManager.publish(notificationRequest, (err: Base.BusinessError) => {
      if (err) {
        hilog.error(DOMAIN_NUMBER, TAG,
          `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
    });
  }
  publishLong = async () => {
    let notificationRequest: notificationManager.NotificationRequest = {
      id: 2,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT, // 长文本类型通知
        longText: {
          title: 'test_title',
          text: 'test_text',
          additionalText: 'test_additionalText',
          longText: 'test_longText',
          briefText: 'test_briefText',
          expandedTitle: 'test_expandedTitle',
        }
      }
    };

    // 发布通知
    notificationManager.publish(notificationRequest, (err: Base.BusinessError) => {
      if (err) {
        hilog.error(DOMAIN_NUMBER, TAG,
          `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
    });
  }
  publishMultiLine = async () => {
    let notificationRequest: notificationManager.NotificationRequest = {
      id: 3,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE, // 多行文本类型通知
        multiLine: {
          title: 'test_title',
          text: 'test_text',
          briefText: 'test_briefText',
          longTitle: 'test_longTitle',
          lines: ['line_01', 'line_02', 'line_03', 'line_04'],
        }
      }
    };

    // 发布通知
    notificationManager.publish(notificationRequest, (err: Base.BusinessError) => {
      if (err) {
        hilog.error(DOMAIN_NUMBER, TAG,
          `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
    });
  }

  publishPicture = async () => {
    const resourceMgr: resourceManager.ResourceManager = this.context.resourceManager;
    let imageArray: Uint8Array = await resourceMgr.getMediaContent($r('app.media.pic').id);
    const arraybuffer: ArrayBuffer = imageArray.buffer as ArrayBuffer;
    let imageResource = image.createImageSource(arraybuffer);
    let imagePixelMap = await imageResource.createPixelMap();

    if (imagePixelMap !== undefined) {
      let notificationRequest: notificationManager.NotificationRequest = {
        id: 4,
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_PICTURE,
          picture: {
            title: 'test_title',
            text: 'test_text',
            additionalText: 'test_additionalText',
            briefText: 'test_briefText',
            expandedTitle: 'test_expandedTitle',
            picture: imagePixelMap
          }
        }
      };

      // 发布通知
      notificationManager.publish(notificationRequest, (err: Base.BusinessError) => {
        if (err) {
          hilog.error(DOMAIN_NUMBER, TAG,
            `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
      });
    }
  }
  publishProgressBar = async () => {
    notificationManager.isSupportTemplate('downloadTemplate').then((data: boolean) => {
      hilog.info(DOMAIN_NUMBER, TAG, `[ANS] isSupportTemplate success`);
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in supporting download template notification.');
      if (data == true) { // data的值为true表示支持支持downloadTemplate模板类通知，false表示不支持
        let notificationRequest: notificationManager.NotificationRequest = {
          id: 5,
          content: {
            notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
            normal: {
              title: 'test_title',
              text: 'test_text',
              additionalText: 'test_additionalText'
            }
          },
          // 构造进度条模板，name字段当前需要固定配置为downloadTemplate
          template: {
            name: 'downloadTemplate',
            data: {
              title: 'File Title', fileName: 'music.mp4', progressValue: 45
            }
          }
        }
        // 发布通知
        notificationManager.publish(notificationRequest, (err: Base.BusinessError) => {
          if (err) {
            hilog.error(DOMAIN_NUMBER, TAG,
              `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
            return;
          }
          hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
        });
      }
    }).catch((err: Base.BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG,
        `Failed to support download template notification. Code is ${err.code}, message is ${err.message}`);
    });
  }
  publishWantAgentStartAbility = async () => {
    let wantAgentObj: WantAgent; // 用于保存创建成功的wantAgent对象，后续使用其完成触发的动作。
    // 通过WantAgentInfo的operationType设置动作类型
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          deviceId: '',
          bundleName: 'com.samples.notification',
          abilityName: 'SecondAbility',
          action: '',
          entities: [],
          uri: '',
          parameters: {}
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG]
    };
    // 创建WantAgent
    wantAgent.getWantAgent(wantAgentInfo, (err: Base.BusinessError, data: WantAgent) => {
      if (err) {
        hilog.error(DOMAIN_NUMBER, TAG, `Failed to get want agent. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in getting want agent.');
      wantAgentObj = data;
      this.publishWantAgent(wantAgentObj);
    });
  }
  publishWantAgentCommonEvent = async () => {
    let wantAgentObj: WantAgent; // 用于保存创建成功的WantAgent对象，后续使用其完成触发的动作。
    // 通过WantAgentInfo的operationType设置动作类型
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          action: 'event_name', // 设置事件名
          parameters: {},
        }
      ],
      operationType: wantAgent.OperationType.SEND_COMMON_EVENT,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG],
    };

    // 创建WantAgent
    wantAgent.getWantAgent(wantAgentInfo, (err: Base.BusinessError, data: WantAgent) => {
      if (err) {
        hilog.error(DOMAIN_NUMBER, TAG, `Failed to get want agent. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in getting want agent.');
      wantAgentObj = data;
      this.publishWantAgent(wantAgentObj);
    });
  }
  publishWantAgent = async (wantAgentObj: WantAgent) => {
    // 构造NotificationRequest对象
    let notificationRequest: notificationManager.NotificationRequest = {
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: 'Test_Title',
          text: 'Test_Text',
          additionalText: 'Test_AdditionalText',
        },
      },
      id: 6,
      label: 'TEST',
      wantAgent: wantAgentObj,
    }

    notificationManager.publish(notificationRequest, (err: Base.BusinessError) => {
      if (err) {
        hilog.error(DOMAIN_NUMBER, TAG,
          `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in publishing notification.');
    });
  }
  setBadgeNumberCallback = async (err: Base.BusinessError) => {
    if (err) {
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to set badge number. Code is ${err.code}, message is ${err.message}`);
      return;
    }
    hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in setting badge number.`);
  }
  setBadgeNumber = async () => {
    let badgeNumber = 9;
    notificationManager.setBadgeNumber(badgeNumber, this.setBadgeNumberCallback);
  }
  setBadgeNumberForBasic = async () => {
    await notificationManager.removeAllSlots();
    await notificationManager.addSlot(notificationManager.SlotType.CONTENT_INFORMATION);
    await this.publishBasic();
    await this.setBadgeNumber();
  }
}
