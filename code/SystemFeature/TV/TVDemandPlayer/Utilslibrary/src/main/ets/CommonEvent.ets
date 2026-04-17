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
import { commonEvent } from '@kit.BasicServicesKit';
import { initInfo } from './log';
import { commonEventManager } from '@kit.BasicServicesKit';
import { BusinessError, deviceInfo as deviceinfo } from '@kit.BasicServicesKit';

const TAG = 'commonEvent-utilslib'
let log = initInfo(TAG);

export class ComEvent {
  public subscribeInfo = { events: [] }
  // public commonEventSubscribeInfo = {
  //     events: [], //表示要订阅的公共事件。
  //     publisherPermission:,//表示发布者的权限，订阅方将只能接收到具有该权限的发送方发布的事件。
  //     publisherDeviceId:deviceinfo.udid,//表示设备ID，该值必须是同一ohos网络上的现有设备ID。通过@ohos.deviceInfo获取udid，作为订阅者的设备ID。
  //     // userId:0,//表示用户ID。此参数是可选的，默认值当前用户的ID。如果指定了此参数，则该值必须是系统中现有的用户ID。通过getOsAccountLocalId获取系统账号ID，作为订阅者的用户ID。
  //     priority:0,//表示订阅者的优先级。值的范围是-100到1000，超过上下限的优先级将被设置为上下限值。
  //     publisherBundleName:"",//表示要订阅的发布者的bundleName。
  // }
  public subscriber = null;

  constructor(events: string[], callback) {
    this.subscribeInfo.events = events;

    //创建订阅者
    try {
      commonEventManager.createSubscriber(this.subscribeInfo,
        (err, commonEventSubscriber: commonEventManager.CommonEventSubscriber) => {
          //创建订阅者回调
          if (!err) {
            console.info('createSubscriber');
            this.subscriber = commonEventSubscriber;
            this.subscribe(callback)
          } else {
            console.error(`createSubscriber failed, code is ${err.code}, message is ${err.message}`);
          }
        });
    } catch (error) {
      let err = error;
      console.error(`createSubscriber failed, code is ${err.code}, message is ${err.message}`);
    }
    // update end

  }

  subscribe(callback) {
    log(`subscribe`);
    try {
      if (this.subscriber) {
        log(`subscriber ready`);


        commonEventManager.subscribe(this.subscriber, callback);

      } else {
        log(`no subscriber`);
      }
    } catch (e) {
      log(JSON.stringify(e));
    }

  }

  unsubscribe(callback?) {
    let fun = (err) => {
      if (err.code) {
        log(`unsubscribe failed: ${JSON.stringify(err)}`);
      } else {
        log(`unsubscribe success`)
      }
    }
    if (callback) {
      fun = callback
    }
    if (this.subscriber) {
      log(`subscriber ready`);


      commonEventManager.unsubscribe(this.subscriber, fun);


    } else {
      log(`no subscriber`);
    }
  }
}
