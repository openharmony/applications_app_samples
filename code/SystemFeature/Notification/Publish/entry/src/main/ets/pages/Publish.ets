/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import promptAction from '@ohos.promptAction';
import notificationManager from '@ohos.notificationManager';
import Base from '@ohos.base';
import image from '@ohos.multimedia.image';
import common from '@ohos.app.ability.common';
import * as EntryAbility from './../entryability/EntryAbility';

@Entry
@Component
struct DialogExample {
  @State context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @State callBackButton: string = '';
  @State showPublishFlag: Boolean = false;
  @State notificationPublishContent: string = '';
  @State pullNotification: string = 'pullNot';

  async getPixmap() {
    let resourceMgr = EntryAbility.entryAbility.resourceManager;
    try {
      let fileData: Uint8Array = await resourceMgr.getRawFileContent('notification.png');
      const buffer: ArrayBuffer = fileData.buffer as ArrayBuffer;
      const imageSource = image.createImageSource(buffer);
      const pixelMap = await imageSource.createPixelMap();
      return pixelMap;
    } catch (e) {
      let fileData: Uint8Array = await resourceMgr.getRawFileContent('notification.png');
      const buffer: ArrayBuffer = fileData.buffer as ArrayBuffer;
      const imageSource = image.createImageSource(buffer);
      const pixelMap = await imageSource.createPixelMap();
      return pixelMap;
    }
  }

  build() {
    Flex() {
      Flex({
        justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center, direction: FlexDirection.Column
      }) {
        Column() {
          Text($r('app.string.notionContent'))
            .fontWeight('HarmonyHeiTi-Medium')
            .fontSize(40)
            .fontColor('#000000')
            .textAlign(TextAlign.Start)
            .lineHeight(82)
            .fontWeight(500)
            .padding({ bottom: 40, left: 24 })
            .width('100%')
          if (this.showPublishFlag === true) {
            Row() {
              Image($r('app.media.notification'))
                .width(96)
                .height(96)
                .margin({ left: 24, right: 32 })
              Column() {
                Text($r('app.string.notificationTitle'))
                  .margin({ bottom: 8 })
                  .fontFamily('HarmonyHeiTi-Medium')
                  .fontSize(32)
                  .fontColor('#182431')
                  .lineHeight(44)
                  .textAlign(TextAlign.Start)
                  .width('100%')
                  .fontWeight(500)
                Text(this.notificationPublishContent)
                  .width('100%')
                  .opacity(0.8)
                  .fontFamily('HarmonyHeiTi')
                  .fontSize(18)
                  .fontColor('#182431')
                  .lineHeight(38)
                  .fontWeight(400)
                  .textAlign(TextAlign.Start)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .wordBreak(WordBreak.BREAK_ALL)
              }
              .layoutWeight(1)
            }
            .backgroundColor('#FFFFFF')
            .borderRadius(16)
            .margin({ left: 12, right: 12 })
            .padding({ top: 24, bottom: 24 })
          }
        }

        Column() {
          Button($r('app.string.subscribeButtonContent'))
            .fontFamily('HarmonyHeiTi-Medium')
            .fontSize(32)
            .width('100%')
            .fontColor('#FFFFFF')
            .padding({ top: 18, bottom: 18 })
            .fontWeight(500)
            .backgroundColor('#007DFF')
            .height(80)
            .margin({ left: 24, right: 24, bottom: 24 })
            .onClick(() => {
              let onResponseCallback = (id: number, option: notificationManager.ButtonOptions) => {
                this.showPublishFlag = true;
                this.notificationPublishContent = 'pullNot：' + JSON.stringify(option.buttonName)
              }
              let subscriber: notificationManager.SystemLiveViewSubscriber = {
                onResponse: onResponseCallback,
              };
              notificationManager.subscribeSystemLiveView(subscriber).then(() => {
                promptAction.showToast({
                  message: $r('app.string.subscribeSuccess'),
                  duration: 2000,
                  bottom: 464,
                })
              }).catch((error: Base.BusinessError) => {
              });
            })
          Button($r('app.string.publishNotification'))
            .fontFamily('HarmonyHeiTi-Medium')
            .fontSize(32)
            .width('100%')
            .fontColor('#FFFFFF')
            .backgroundColor('#007DFF')
            .padding({ top: 18, bottom: 18 })
            .fontWeight(500)
            .height(80)
            .margin({ left: 24, right: 24, bottom: 48 })
            .onClick(async () => {
              // publish回调
              let publishCallback = (err: Base.BusinessError): void => {
                if (err) {
                } else {
                  promptAction.showToast({
                    message: $r('app.string.publishSuccess'),
                    duration: 2000,
                    bottom: 464
                  })
                }
              }
              let pixMap = await this.getPixmap();

              // 通知Request对象
              let notificationRequest: notificationManager.NotificationRequest = {
                id: 1,
                notificationSlotType: notificationManager.SlotType.LIVE_VIEW,
                content: {
                  notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW,
                  systemLiveView: {
                    title: 'test_title',
                    text: 'test_text',
                    typeCode: 1,
                    button: {
                      names: [this.pullNotification],
                      icons: []
                    }
                  }
                }
              };

              notificationManager.requestEnableNotification().then(() => {
                notificationManager.publish(notificationRequest, publishCallback);
              });

            })
        }
        .padding({ left: 24, right: 24 })
      }
      .padding({ left: 24, right: 24 })
    }
    .width('100%')
    .backgroundColor('#F1F3F5')
  }
}