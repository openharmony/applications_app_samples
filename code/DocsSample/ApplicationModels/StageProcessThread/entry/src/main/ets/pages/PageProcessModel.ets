/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Base from '@ohos.base';
import commonEventManager from '@ohos.commonEventManager';
import promptAction from '@ohos.promptAction';
import hilog from '@ohos.hilog';

const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = 'ProcessModel';

@Entry
@Component
struct PageProcessModel {
  // 用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作
  private subscriber: commonEventManager.CommonEventSubscriber | null = null;
  // 订阅者信息
  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: ['usual.event.SCREEN_OFF'], // 订阅灭屏公共事件
  };
  // 判断当前是否发送过粘性公共事件
  private ifSendStickyKey: boolean = false;

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.process_button'))
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .margin({ top: 12 , bottom: 11 , right: 24 , left: 24})
        }
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))


      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.subscribe_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })

          }
          .onClick(() => {
            if (this.subscriber !== null) {
              promptAction.showToast({
                message: $r('app.string.subscribe_failed_toast')
              });
              return;
            }
            // 创建订阅者回调
            commonEventManager.createSubscriber(this.subscribeInfo, (err: Base.BusinessError, data: commonEventManager.CommonEventSubscriber) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG, `Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(DOMAIN_NUMBER, TAG, 'Succeeded in creating subscriber.');
              this.subscriber = data;

              // 订阅公共事件回调
              if (this.subscriber !== null) {
                commonEventManager.subscribe(this.subscriber, (err: Base.BusinessError, data: commonEventManager.CommonEventData) => {
                  if (err) {
                    hilog.error(DOMAIN_NUMBER, TAG, `Failed to subscribe common event. Code is ${err.code}, message is ${err.message}`);
                    return;
                  }
                  promptAction.showToast({
                    message: JSON.stringify(data)
                  });
                  hilog.info(DOMAIN_NUMBER, TAG, `Receive CommonEventData = ` + JSON.stringify(data));
                })
                if (this.ifSendStickyKey === false) {
                  promptAction.showToast({
                    message: $r('app.string.subscribe_success_toast')
                  });
                }
              } else {
                hilog.error(DOMAIN_NUMBER, TAG, `Need create subscriber`);
              }
            })
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })


        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.unsubscribe_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // subscriber为订阅事件时创建的订阅者对象
            if (this.subscriber !== null) {
              commonEventManager.unsubscribe(this.subscriber, (err: Base.BusinessError) => {
                if (err) {
                  hilog.error(DOMAIN_NUMBER, TAG, `UnsubscribeCallBack err = ${JSON.stringify(err)}`);
                } else {
                  promptAction.showToast({
                    message: $r('app.string.unsubscribe_success_toast')
                  });
                  hilog.info(DOMAIN_NUMBER, TAG, `Unsubscribe success`);
                  this.subscriber = null;
                }
              })
            } else {
              promptAction.showToast({
                message: $r('app.string.unsubscribe_failed_toast')
              });
            }
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.publish_noinfo_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // 发布公共事件
            commonEventManager.publish('usual.event.SCREEN_OFF', (err: Base.BusinessError) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG, `PublishCallBack err = ${JSON.stringify(err)}`);
              } else {
                if (this.subscriber === null) {
                  promptAction.showToast({
                    message: $r('app.string.publish_noinfo_success_toast')
                  });
                }
                hilog.info(DOMAIN_NUMBER, TAG, `Publish success`);
              }
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.publish_haveinfo_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // 公共事件相关信息
            let options: commonEventManager.CommonEventPublishData = {
              code: 1, // 公共事件的初始代码
              data: 'initial data', // 公共事件的初始数据
            };

            // 发布公共事件
            commonEventManager.publish('usual.event.SCREEN_OFF', options, (err: Base.BusinessError) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG, 'PublishCallBack err = ' + JSON.stringify(err));
              } else {
                if (this.subscriber === null) {
                  promptAction.showToast({
                    message: $r('app.string.publish_haveinfo_success_toast')
                  });
                }
                hilog.info(DOMAIN_NUMBER, TAG, 'Publish success');
              }
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.publish_sticky_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // 公共事件相关信息
            let options: commonEventManager.CommonEventPublishData = {
              code: 1, // 公共事件的初始代码
              data: 'initial Sticky data', // 公共事件的初始数据
              isSticky: true
            };

            // 发布公共事件
            commonEventManager.publish('usual.event.SCREEN_OFF', options, (err: Base.BusinessError) => {
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG, 'PublishCallBack err=' + JSON.stringify(err));
              } else {
                promptAction.showToast({
                  message: $r('app.string.publish_sticky_success_toast')
                });
                this.ifSendStickyKey = true;
                hilog.info(DOMAIN_NUMBER, TAG, 'Publish success');
              }
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.remove_sticky_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            commonEventManager.removeStickyCommonEvent('usual.event.SCREEN_OFF', (err: Base.BusinessError) => {
              // sticky_event粘性公共事件名
              if (err) {
                hilog.error(DOMAIN_NUMBER, TAG, `Failed to remove sticky common event. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              promptAction.showToast({
                message: $r('app.string.remove_sticky_success_toast')
              });
              this.ifSendStickyKey = false;
              hilog.info(DOMAIN_NUMBER, TAG, `Succeeded in removeing sticky event.`);
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

      }
      .height('100%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .width('100%')
    .margin({ top: 8 })
    .backgroundColor($r('app.color.backGrounding'))
  }

}