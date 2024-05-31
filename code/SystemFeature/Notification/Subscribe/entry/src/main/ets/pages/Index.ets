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
import notificationSubscribe from '@ohos.notificationSubscribe';
import notificationManager from '@ohos.notificationManager';
import Base from '@ohos.base';
import image from '@ohos.multimedia.image';
import { Level } from '@ohos/hypium';

@Entry
@Component
struct Subscribe {
  @State bundleName: string = '';
  @State pixelMap: image.PixelMap | undefined = undefined;
  @State bundleNames: Array<string> = [];
  @State notificationSubscribeContent: string = '';
  @State showSubscribeFlag: Boolean = false;
  @State notifications: string = 'content';

  @Builder
  overlayContent() {
    Text(this.bundleNames[0])
      .fontSize(20)
      .fontColor('#FFFFFF')
      .textAlign(TextAlign.Center)
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
          if (this.showSubscribeFlag === true) {
            Column() {
              Row() {
                Image($r('app.media.notification'))
                  .width(96)
                  .height(96)
                  .margin({ right: 16 })
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
                  Text(this.notificationSubscribeContent)
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
                .margin({ left: 20, bottom: 40 })

              }

              Button($r('app.string.pullNotification'))
                .fontFamily('HarmonyHeiTi-Medium')
                .fontSize(32)
                .width('100%')
                .fontColor('#FFFFFF')
                .backgroundColor('#007DFF')
                .fontWeight(500)
                .height(80)
                .margin({ left: 24, right: 24 })
                .onClick(() => {
                  // 包信息
                  let bundle: notificationManager.BundleOption = {
                    bundle: 'com.samples.notificationpublish'
                  };
                  // 通知ID
                  let notificationId = 1;
                  // 按钮信息
                  let buttonOptions: notificationManager.ButtonOptions = {
                    buttonName: this.notifications,
                  }
                  notificationManager.triggerSystemLiveView(bundle, notificationId, buttonOptions).then((data) => {
                    promptAction.showToast({
                      message: $r('app.string.pullSuccess'),
                      duration: 2000,
                      bottom: 464
                    })
                  }).catch((error: Base.BusinessError) => {
                    console.error(`triggerSystemLiveView fail: ${JSON.stringify(error)}`);
                  });
                })
            }
            .backgroundColor('#FFFFFF')
            .borderRadius(16)
            .padding({ top: 32, bottom: 32, left: 24, right: 24 })
          }
        }

        Row() {
          Button($r('app.string.subscribeNotification'))
            .fontFamily('HarmonyHeiTi-Medium')
            .fontSize(32)
            .width('100%')
            .fontColor('#FFFFFF')
            .padding({ top: 18, bottom: 18 })
            .fontWeight(500)
            .backgroundColor('#007DFF')
            .height(80)
            .margin({ bottom: 48 })
            .onClick(() => {
              let subscribeCallback = (err: Base.BusinessError) => {
                if (err) {
                  console.error(`subscribe failed, code is ${err.code}, message is ${err.message}`);
                } else {
                  promptAction.showToast({
                    message: $r('app.string.subscribeSuccess'),
                    duration: 2000,
                    bottom: 464
                  })
                }
              }
              let onConsumeCallback = (data: notificationSubscribe.SubscribeCallbackData) => {
                console.info('SubscribeCallbackData', JSON.stringify(data))
                let icons: Array<image.PixelMap> = data.request?.content?.systemLiveView?.button?.icons || [];
                let names = data.request?.content?.systemLiveView?.button?.names || [];
                this.bundleNames[0] = names[0];
                this.showSubscribeFlag = true;
                this.notificationSubscribeContent = 'content：' + this.bundleNames[0]
                this.pixelMap = icons.pop()
              }
              let subscriber: notificationSubscribe.NotificationSubscriber = {
                onConsume: onConsumeCallback
              };
              notificationSubscribe.subscribe(subscriber, subscribeCallback);
            })
        }
        .padding({ left: 24, right: 24 })
      }
      .padding({ left: 24, right: 24 })
    }
    .backgroundColor('#F1F3F5')
    .width('100%')
    .height('100%')
  }
}
