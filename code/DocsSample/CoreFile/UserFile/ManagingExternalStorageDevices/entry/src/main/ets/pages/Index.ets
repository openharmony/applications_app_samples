/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start subscribe_events_1]
import { BusinessError } from '@kit.BasicServicesKit';
import { commonEventManager } from '@kit.BasicServicesKit';
import { volumeManager } from '@kit.CoreFileKit';
import Logger from '../common/Logger';

let subscriber: commonEventManager.CommonEventSubscriber;
// [End subscribe_events_1]
@Entry
@Component
struct Index {
  @State message: string = '';

  build() {
    Column() {
      Text(this.message)
        .fontSize($r('app.float.size_50')) // 文本字体大小为50
        .fontWeight(FontWeight.Bold) // 文本字体加粗
        .margin({ top: $r('app.float.size_20') }) // 文本上边距为20

      // 订阅广播事件按钮
      Button($r('app.string.subscribeBroadcastButton'))
        .width('80%') // 按钮宽度占屏幕宽度80%
        .height('10%') // 按钮高度占屏幕高度10%
        .fontSize($r('app.float.size_25')) // 按钮字体大小为25
        .borderRadius($r('app.float.size_25')) // 按钮圆角半径为25
        .backgroundColor($r('app.color.whiteColor')) // 按钮背景颜色为白色
        .shadow({
          radius: $r('app.float.size_10'), // 阴影半径为10
          color: $r('app.color.grayColor'), // 阴影颜色为灰色
          offsetX: $r('app.float.size_15'), // 阴影水平偏移量为15
          offsetY: $r('app.float.size_15') // 阴影垂直偏移量为15
        })
        .stateStyles({
          pressed: {
            .backgroundColor($r('app.color.lightGrayColor')) // 按下时背景颜色为浅灰色
          }
        })
        .fontColor($r('app.color.blackColor')) // 按钮字体颜色为黑色
        .onClick(() => {
          this.subscribeToEvents();
        })

      // 接收广播通知按钮
      Button($r('app.string.receiveBroadcastButton'))
        .width('80%') // 按钮宽度占屏幕宽度80%
        .height('10%') // 按钮高度占屏幕高度10%
        .fontSize($r('app.float.size_25')) // 按钮字体大小为25
        .borderRadius($r('app.float.size_25')) // 按钮圆角半径为25
        .backgroundColor($r('app.color.whiteColor')) // 按钮背景颜色为白色
        .shadow({
          radius: $r('app.float.size_10'), // 阴影半径为10
          color: $r('app.color.grayColor'), // 阴影颜色为灰色
          offsetX: $r('app.float.size_15'), // 阴影水平偏移量为15
          offsetY: $r('app.float.size_15') // 阴影垂直偏移量为15
        })
        .stateStyles({
          pressed: {
            .backgroundColor($r('app.color.lightGrayColor')) // 按下时背景颜色为浅灰色
          }
        })
        .fontColor($r('app.color.blackColor')) // 按钮字体颜色为黑色
        .onClick(() => {
          this.receiveBroadcastNotifications();
        })
    }
    .width('100%') // 设置外层容器宽度为100%
    .height('100%') // 设置外层容器高度为100%
    .alignItems(HorizontalAlign.Center) // 设置子元素水平居中
    .justifyContent(FlexAlign.Center) // 设置子元素垂直居中
    .backgroundColor($r('app.color.lightGrayColor')) // 设置背景颜色为浅灰色
  }

  // [Start subscribe_events_2]
  async subscribeToEvents() {
    Logger.info('subscribeToEvents() begin');
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [
        'usual.event.data.VOLUME_REMOVED',
        'usual.event.data.VOLUME_UNMOUNTED',
        'usual.event.data.VOLUME_MOUNTED',
        'usual.event.data.VOLUME_BAD_REMOVAL',
        'usual.event.data.VOLUME_EJECT'
      ]
    };
    try {
      subscriber = await commonEventManager.createSubscriber(subscribeInfo);
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('Failed to create subscriber: ' + JSON.stringify(error));
    }
  }
   // [End subscribe_events_2]

  // [Start subscribe_events_3]
  receiveBroadcastNotifications() {
    // [StartExclude subscribe_events_3]
    Logger.info('receiveBroadcastNotifications() begin');
    if (subscriber === undefined) {
      Logger.error('Subscriber is not defined. Please subscribe to events first.');
      return;
    }
    // [EndExclude subscribe_events_3]
    commonEventManager.subscribe(subscriber, (err: BusinessError, data: commonEventManager.CommonEventData) => {
      // [StartExclude subscribe_events_3]
      if (err) {
        Logger.error('Subscription failed: ' + JSON.stringify(err));
        return;
      }
      // [EndExclude subscribe_events_3]
      if (data.event === 'usual.event.data.VOLUME_MOUNTED' && data.parameters !== undefined) {
        let volId: string = data.parameters.id;
        volumeManager.getVolumeById(volId, (error: BusinessError, vol: volumeManager.Volume) => {
          if (error) {
            Logger.error('volumeManager getVolumeById failed for ' + JSON.stringify(error));
          } else {
            Logger.info('volumeManager getVolumeById successfully, the volume state is ' + vol.state);
            // [StartExclude subscribe_events_3]
            this.message = 'Successfully obtained volume device information';
            // [EndExclude subscribe_events_3]
          }
        });
      }
    });
  }
  // [End subscribe_events_3]
}