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

import emitter from '@ohos.events.emitter';
import promptAction from '@ohos.promptAction';
import worker from '@ohos.worker';
import hilog from '@ohos.hilog';

const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = 'ThreadModel';

@Entry
@Component
struct PageThreadModel {
  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.thread_button'))
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .margin({ top: 12, bottom: 11, right: 24, left: 24 })
        }
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))


      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.emitter_subscribe_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })

          }
          .onClick(() => {
            // 定义一个eventId为1的事件
            let event: emitter.InnerEvent = {
              eventId: 1
            };

            // 收到eventId为1的事件后执行该回调
            let callback = (eventData: emitter.EventData): void => {
              promptAction.showToast({
                message: JSON.stringify(eventData)
              });
              hilog.info(DOMAIN_NUMBER, TAG, 'event callback:' + JSON.stringify(eventData));
            };

            // 订阅eventId为1的事件
            emitter.on(event, callback);
            promptAction.showToast({
              message: $r('app.string.emitter_subscribe_success_toast')
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })


        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.emitter_sending_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // 定义一个eventId为1的事件，事件优先级为Low
            let event: emitter.InnerEvent = {
              eventId: 1,
              priority: emitter.EventPriority.LOW
            };

            let eventData: emitter.EventData = {
              data: {
                content: 'c',
                id: 1,
                isEmpty: false
              }
            };

            // 发送eventId为1的事件，事件内容为eventData
            emitter.emit(event, eventData);
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row() {
              Text($r('app.string.worker_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            let wk = new worker.ThreadWorker('entry/ets/workers/Worker.ts');
            // 发送消息到worker线程
            wk.postMessage('message from main thread.');

            // 处理来自worker线程的消息
            wk.onmessage = (message): void => {
              promptAction.showToast({
                message: JSON.stringify(message)
              });
              hilog.info(DOMAIN_NUMBER, TAG, 'message from worker: ' + JSON.stringify(message));

              // 根据业务按需停止worker线程
              wk.terminate();
            }
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