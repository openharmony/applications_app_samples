/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//@ts-nocheck
import { rpc } from '@kit.IPCKit';
import { DriverExtensionAbility } from '@kit.DriverDevelopmentKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import hidNapi from 'libentry.so';
import { RequestCode, InputType, OutputType} from '../utils/RequestCode';

let deviceId;

class FirstDriverAbilityStub extends rpc.RemoteObject {
  constructor(des) {
    if (typeof des === 'string') {
      super(des);
    } else {
      return null;
    }
  }
  onRemoteMessageRequest(code: number,
    data: MessageSequence,
    reply: MessageSequence,
    options: MessageOption
  ) {
    try{
      switch (code) {
        case RequestCode.GetRawInfo:
          return reply.writeString(hidNapi.getRawInfo());
        case RequestCode.GetRawName:
          return reply.writeString(hidNapi.getRawName());
        case RequestCode.GetPhysicalAddr:
          return reply.writeString(hidNapi.getPhysicalAddress());
        case RequestCode.GetRawUniqueId:
          return reply.writeString(hidNapi.getRawUniqueId());
        case RequestCode.GetInput: {
          let inputType = data.readInt();
          hilog.info(0, 'driverTag', `GetInput prev ${inputType}`);
          let result: keyStates;
          if (inputType == InputType.ReadBlock) {
            result = hidNapi.readKeyboardState(false);
          } else if (inputType == InputType.ReadNonBlock) {
            result = hidNapi.readKeyboardState(true);
          } else {
            result = hidNapi.getKeyboardState();
          }
          result.states.forEach((state) => {
            reply.writeBoolean(state);
          });
          return reply.writeString(result.keys);
        }
        case RequestCode.SetOutput: {
          let outputType = data.readInt();
          hilog.info(0, 'driverTag', `SetOutput prev ${outputType}`);
          const keysLedStates = Array.from({ length: 4 }, (_, index) => {
            return data.readBoolean();
          });
          if (outputType == OutputType.SendReport) {
            let result = hidNapi.applyKeyboardSettings(keysLedStates);
            hilog.info(0, 'driverTag', `applyKeyboardSettings result:${result}`);
          } else {
            let result = hidNapi.writeKeyboardSettings(keysLedStates);
            hilog.info(0, 'driverTag', `writeKeyboardSettings result:${result}`);
          }
          return true;
        }
        case RequestCode.GetFeature:
          return reply.writeString(hidNapi.getKeyboardFeatures());
        case RequestCode.SetFeature:
          let result = hidNapi.applyKeyboardFeatures(data.readString());
          hilog.info(0, 'driverTag', `applyKeyboardFeatures result:${result}`);
          return true;
        case RequestCode.GetDescriptor:
          return reply.writeString(hidNapi.getReportDescriptor());
        default:
          return true;
      }
    } catch (error) {
      hilog.info(0, 'driverTag', `onRemoteMessageRequest exception ${error}`);
    }
  }

  sendDisconnect() {
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    hilog.info(0, 'driverTag', `sendDisconnect`);
    sendMessageRequest(0x99, dataSend, reply, option).then((ret) => {
      let msg = reply.readInt();
      reply.writeInt(msg);
      hilog.info(0, 'driverTag', `sendDisconnect sendMessageRequest ret:${ret} msg:${msg}`);
    }).catch((error) => {
      hilog.info(0, 'driverTag', `sendDisconnect sendMessageRequest failed:${error}`);
    });
  }
}

export default class DriverExtAbility extends DriverExtensionAbility {
  async onInit(want): void {
    hilog.info(0, 'driverTag','DriverAbility OnInit');
    hilog.info(0, 'driverTag','OnInit deviceId '+ want.parameters['deviceId']);
    deviceId = want.parameters['deviceId'];
    hilog.info(0, 'driverTag','before hidInit');
    let result = hidNapi.hidInit(deviceId);
    hilog.info(0, 'driverTag',`hidInit result:${result}`);
  }
  onRelease() :void {
    hilog.info(0, 'driverTag', 'DriverAbility onRelease');
    // 释放底层资源
    let result = hidNapi.releaseResource();
    hilog.info(0, 'driverTag',`releaseResource result:${result}`);
  }
  onConnect(want): rpc.RemoteObject {
    hilog.info(0, 'driverTag', 'DriverAbility onConnect');
    return new FirstDriverAbilityStub('remote');
  }
  onDisconnect(want): void {
    hilog.info(0, 'driverTag', 'DriverAbility onDisconnect');
  }
  onDump(params): Array<string> {
    hilog.info(0, 'driverTag', 'DriverAbility onDump, params:' + JSON.stringify(params));
    return ['params'];
  }
};