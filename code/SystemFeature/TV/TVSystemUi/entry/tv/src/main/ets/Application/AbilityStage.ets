/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 
import { AbilityStage } from '@kit.AbilityKit';
import Log from '@ohos/common/src/main/ets/default/Log';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';

const TAG = 'SystemUI_AbilityStage';

export default class MainAbilityStage extends AbilityStage {
  onCreate(): void {
    Log.showInfo(TAG, 'onCreate');
    this.subscribeFloatWindow()
  }
  // 增加相机中悬浮窗的（是否有悬浮窗以及xu是否有焦点）订阅事件
  subscribeFloatWindow(){
    // 定义订阅者，用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作
    let subscriber: commonEventManager.CommonEventSubscriber;
    // 订阅者信息
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: ['isFloatWindowFocusBlur']
    };
    // 创建订阅者
    try {
      commonEventManager.createSubscriber(subscribeInfo,
        (err: BusinessError, commonEventSubscriber: commonEventManager.CommonEventSubscriber) => {
          if(!err) {
            console.info(`Succeeded in creating subscriber.`);
            subscriber = commonEventSubscriber;
            // 订阅公共事件
            try {
              commonEventManager.subscribe(subscriber, (err: BusinessError,
                data: commonEventManager.CommonEventData) => {
                if (err) {
                  console.error(`Failed to subscribe. Code is ${err.code}, message is ${err.message}`);
                  return;
                }
                let isFloatWindowBlur=data.parameters?.isFloatWindowFocusBlur as boolean
                AppStorage.setOrCreate('isFloatWindowBlur',isFloatWindowBlur)
                console.info(`Succeeded in subscribing, data is ${JSON.stringify(data)}`);
              });
            } catch (error) {
              let err: BusinessError = error as BusinessError;
              console.error(`Failed to subscribe. Code is ${err.code}, message is ${err.message}`);
            }
            return;
          }
          console.error(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
        });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
    }
    // 定义订阅者，用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作
    let subscriber1: commonEventManager.CommonEventSubscriber;
    // 订阅者信息
    let subscribeInfo1: commonEventManager.CommonEventSubscribeInfo = {
      events: ['isFloatWindowDestroy']
    };
    // 创建订阅者
    try {
      commonEventManager.createSubscriber(subscribeInfo1,
        (err: BusinessError, commonEventSubscriber: commonEventManager.CommonEventSubscriber) => {
          if(!err) {
            console.info(`Succeeded in creating subscriber.`);
            subscriber1 = commonEventSubscriber;
            // 订阅公共事件
            try {
              commonEventManager.subscribe(
                subscriber1, (err: BusinessError, data: commonEventManager.CommonEventData
              ) => {
                if (err) {
                  console.error(`Failed to subscribe. Code is ${err.code}, message is ${err.message}`);
                  return;
                }
                let isFloatWindowDestroy=data.parameters?.isFloatWindowDestroy as boolean

                AppStorage.setOrCreate('isFloatWindowBlur',isFloatWindowDestroy)

                console.info(`Succeeded in subscribing, data is ${JSON.stringify(data)}`);
              });
            } catch (error) {
              let err: BusinessError = error as BusinessError;
              console.error(`Failed to subscribe. Code is ${err.code}, message is ${err.message}`);
            }
            return;
          }
          console.error(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
        });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
    }
  }
}
