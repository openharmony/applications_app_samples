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

// [Start data_sync_on_distributed_data_object_cross_device_collaboration]
import { AbilityConstant, Caller, UIAbility, Want } from '@kit.AbilityKit';
import { distributedDataObject } from '@kit.ArkData';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';
import hilog from '@ohos.hilog';

// [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
// 业务数据定义
// [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
class Data {
  title: string | undefined;
  text: string | undefined;

  constructor(title: string | undefined, text: string | undefined) {
    this.title = title;
    this.text = text;
  }
}

const DOMAIN: number = 0x0000;
const TAG: string = '[DistributedDataObject]';

let sessionId: string;
let caller: Caller;
let dataObject: distributedDataObject.DataObject;
const changeCallBack: distributedDataObject.DataObserver = (sessionId: string, fields: Array<string>) => {
  console.info(`change, sessionId: ${sessionId}, fields: ${JSON.stringify(fields)}`);
}

export default class EntryAbility extends UIAbility {
  // [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
  // 1. 调用端调用startAbilityByCall接口拉起对端Ability
  // [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
  callRemote() {
    if (caller) {
      hilog.error(DOMAIN, TAG, 'call remote already');
      return;
    }

    // [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
    // 1.1 调用genSessionId接口创建一个sessionId，通过分布式设备管理接口获取对端设备networkId
    // [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
    sessionId = distributedDataObject.genSessionId();
    hilog.info(DOMAIN, TAG, `gen sessionId: ${sessionId}`);
    let deviceId = getRemoteDeviceId();
    if (deviceId == "") {
      hilog.warn(DOMAIN, TAG, 'no remote device');
      return;
    }
    hilog.info(DOMAIN, TAG, `get remote deviceId: ${deviceId}`);

    // [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
    // 1.2 组装want，并将sessionId放入want
    // [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
    let want: Want = {
      bundleName: 'com.example.collaboration',
      abilityName: 'EntryAbility',
      deviceId: deviceId,
      parameters: {
        'ohos.aafwk.param.callAbilityToForeground': true, // 前台启动，非必须
        'distributedSessionId': sessionId
      }
    }
    try {
      // [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
      // 1.3 调用startAbilityByCall接口拉起对端Ability
      // [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
      this.context.startAbilityByCall(want).then((res) => {
        if (!res) {
          hilog.error(DOMAIN, TAG, 'startAbilityByCall failed');
        }
        caller = res;
      })
    } catch (e) {
      let err = e as BusinessError;
      hilog.error(DOMAIN, TAG, `get remote deviceId error, error code: ${err.code}, error message: ${err.message}`);
    }
  }

  // [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
  // 2. 拉起对端Ability后创建分布式数据对象
  // [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
  createDataObject() {
    if (!caller) {
      hilog.error(DOMAIN, TAG, 'call remote first');
      return;
    }
    if (dataObject) {
      hilog.error(DOMAIN, TAG, 'create dataObject already');
      return;
    }

    // [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
    // 2.1 创建分布式数据对象实例
    // [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
    let data = new Data('The title', 'The text');
    dataObject = distributedDataObject.create(this.context, data);

    // [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
    // 2.2 注册数据变更监听
    // [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
    dataObject.on('change', changeCallBack);
    // [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
    // 2.3 设置同步sessionId加入组网
    // [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
    dataObject.setSessionId(sessionId);
  }

  // [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
  // 3. 被调用端被拉起后创建和恢复分布式数据对象
  // [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    if (want.parameters && want.parameters.distributedSessionId) {
      // [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
      // 3.1 创建分布式数据对象实例
      // [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
      let data = new Data(undefined, undefined);
      dataObject = distributedDataObject.create(this.context, data);

      // [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
      // 3.2 注册数据变更监听
      // [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
      dataObject.on('change', changeCallBack);
      // [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
      // 3.3 从want中获取源端放入的sessionId，使用这个sessionId加入组网
      // [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
      let sessionId = want.parameters.distributedSessionId as string;
      hilog.info(DOMAIN, TAG, `onCreate get sessionId: ${sessionId}`);
      dataObject.setSessionId(sessionId);
    }
  }
}

// [StartExclude data_sync_on_distributed_data_object_cross_device_collaboration]
// 获取可信组网中的设备
// [EndExclude data_sync_on_distributed_data_object_cross_device_collaboration]
function getRemoteDeviceId() {
  let deviceId = "";
  try {
    let deviceManager = distributedDeviceManager.createDeviceManager('com.example.collaboration');
    let devices = deviceManager.getAvailableDeviceListSync();
    if (devices[0] && devices[0].networkId) {
      deviceId = devices[0].networkId;
    }
  } catch (e) {
    let err = e as BusinessError;
    hilog.error(DOMAIN, TAG, `get remote deviceId error, error code: ${err.code}, error message: ${err.message}`);
  }
  return deviceId;
}

// [End data_sync_on_distributed_data_object_cross_device_collaboration]