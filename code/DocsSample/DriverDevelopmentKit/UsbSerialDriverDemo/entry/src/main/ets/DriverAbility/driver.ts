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

import { DriverExtensionAbility } from '@kit.DriverDevelopmentKit';
import { rpc } from '@kit.IPCKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so'

const REQUEST_CODE = 1; // 与扩展外设客户端约定请求码,配置串口
const READ_CODE = 5; // 与扩展外设客户端约定请求码，读取数据
const CLOSE_CODE = 4; // 与扩展外设客户端约定请求码，关闭串口
const SETTIMEOUT_CODE = 6; // 与扩展外设客户端约定请求码，设置超时时间
const TOTAL_CONFIGURATION = 5;
let deviceId;

class Temperature extends rpc.RemoteObject {
  private currentNum: number = 100;
  private let;

  // 接收应用传递过来的消息处理，以及将处理的结果返回给客户端
  onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    option: rpc.MessageOption) {
    let datasize = data.getSize();
    let ret = -1;
    if (code === REQUEST_CODE) {
      let i = 0;
      let ret;
      while (i < TOTAL_CONFIGURATION) {
        i++;
        let keyIndex = data.readInt(); // 取得数据项
        let keyValue = data.readString(); // 取得数据值
        hilog.info(0, 'testTag', `usbSerialInit successful, keyIndex:${keyIndex} keyValue:${keyValue}`);
        ret = testNapi.config(keyIndex, keyValue);
      }
      reply.writeInt(ret);
      return true;
    } else if (code === READ_CODE) {
      // 读取数据
      hilog.info(0, 'testTag ui', 'driver Read');
      let data = testNapi.readTemperature();
      hilog.info(0, 'testTag ui', `driver Read data : ${data}`);
      reply.writeDouble(data);
      return true;
    } else if (code === CLOSE_CODE) {
      // 关闭串口
      let ret = testNapi.close();
      hilog.info(0, 'testTag ui', `driver close，ret：${ret}`);
      reply.writeInt(ret);
      return true;
    } else if (code == SETTIMEOUT_CODE) {
      let timeout = data.readInt();
      let ret = testNapi.setTimeOut(timeout);
      hilog.info(0, 'testTag ui', `setTimeOut successful, ret:${ret}`);
      reply.writeInt(ret);
      return true;
    }
    return true;
  }
}

export default class DriverExtAbility extends DriverExtensionAbility {
  async onInit(want) {
    hilog.info(0, 'testTag', 'DriverAbility OnInit');
    hilog.info(0, 'testTag', 'OnInit deviceId ' + want.parameters["deviceId"]);
    deviceId = want.parameters["deviceId"];
    hilog.info(0, 'testTag ui', `OnInit want deviceId :${deviceId}`);
    let ret = testNapi.usbSerialInit(deviceId);
    hilog.info(0, 'testTag ui', `DriverAbility OnInit ret:${ret}`);
  }

  onRelease() {
    console.info('testTag', `onRelease`);
    testNapi.releaseResource();
  }

  onConnect(want) {
    console.info('testTag', `onConnect, want: ${want.abilityName}`);
    return new Temperature("remote");
  }

  onDisconnect(want) {
    console.info('testTag', `onDisconnect, want: ${want.abilityName}`);
  }

  onDump(params: Array<string>) {
    console.info('testTag', `onDump, params:` + JSON.stringify(params));
    return ['params'];
  }
}
