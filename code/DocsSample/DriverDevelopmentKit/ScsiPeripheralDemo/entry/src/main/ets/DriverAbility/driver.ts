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
import scsiNapi from 'libentry.so';
import { RequestCode } from '../utils/RequestCode';

let deviceId;
let initResult;

class FirstDriverAbilityStub extends rpc.RemoteObject {
  constructor(des) {
    if (typeof des === 'string') {
      super(des);
    } else {
      return null;
    }
  }

  checkParams():boolean {
    if (scsiNapi == null || initResult != 31700000) {
      hilog.error(0, 'testTag', `scsiNapi == null or scsiInit is failed.`);
      return false;
    }

    return true;
  }

  onRemoteMessageRequest(code: number,
    data: MessageSequence,
    reply: MessageSequence,
    options: MessageOption
  ) {
    hilog.info(0, 'testTag', `testtag driver extension onRemoteMessageRequest called ${code}`);
    try{
      if (!this.checkParams() && code != RequestCode.ConnectStatus) {
        return false;
      }

      switch (code) {
        case RequestCode.ConnectStatus: {
          hilog.info(0, 'testTag', `driver testtag ConnectStatus`);
          let status = data.readInt();
          hilog.info(0, 'testTag', `driver result: status:${status}`);
          reply.writeInt(type);
          return true;
        }
        case RequestCode.GetDeviceInfo: {
          hilog.info(0, 'testTag', `driver testtag GetDeviceInfo`);
          let [deviceInfo, status]  = scsiNapi.inquiry(deviceId);
          hilog.info(0, 'testTag', `driver result: devType:${deviceInfo.devType}, vendor:${deviceInfo.vendor}, product:${deviceInfo.product}, revision:${deviceInfo.revision}, status:${status}`);
          reply.writeInt(status);
          reply.writeInt(deviceInfo.devType);
          reply.writeString(deviceInfo.vendor);
          reply.writeString(deviceInfo.product);
          reply.writeString(deviceInfo.revision);

          let [lbAddress, blockVolume, status2]  = scsiNapi.readCapacity(deviceId, 0);
          hilog.info(0, 'testTag', `driver result: blockNum:${lbAddress}, blockVolume:${blockVolume}, status:${status2}`);
          reply.writeInt(status2);
          reply.writeLong(lbAddress);
          reply.writeInt(blockVolume);
          return true;
        }
        case RequestCode.Inquiry: {
          hilog.info(0, 'testTag', `driver testtag Inquiry`);
          let [deviceInfo, status]  = scsiNapi.inquiry(deviceId);
          hilog.info(0, 'testTag', `driver result: devType:${deviceInfo.devType}, vendor:${deviceInfo.vendor}, product:${deviceInfo.product}, revision:${deviceInfo.revision}, status:${status}`);
          reply.writeInt(status);
          reply.writeInt(deviceInfo.devType);
          reply.writeString(deviceInfo.vendor);
          reply.writeString(deviceInfo.product);
          reply.writeString(deviceInfo.revision);
          reply.writeString(deviceInfo.originData);
          return true;
        }
        case RequestCode.ReadCapacity: {
          hilog.info(0, 'testTag', `driver testtag ReadCapacity`);
          let blockAddr = data.readLong();
          const [blockNum, blockVolume, status]  = scsiNapi.readCapacity(deviceId, blockAddr);
          hilog.info(0, 'testTag', `driver result: blockNum:${blockNum}, blockVolume:${blockVolume}, status:${status}`);
          reply.writeInt(status);
          reply.writeLong(blockNum);
          reply.writeInt(blockVolume);
          return true;
        }
        case RequestCode.TestUnitReady: {
          hilog.info(0, 'testTag', `driver testtag TestUnitReady`);
          let status = scsiNapi.testUnitReady(deviceId);
          hilog.info(0, 'testTag', `driver testtag result: status:${status}`);
          reply.writeInt(status);
          return true;
        }
        case RequestCode.ReadBlockData: {
          hilog.info(0, 'testTag', `driver testtag ReadBlockData`);
          let blockAddr = data.readInt();
          let blockNum = data.readInt();
          let [blockData, status] = scsiNapi.readBlocksData(deviceId, blockAddr, blockNum);
          hilog.info(0, 'testTag', `driver testtag result: data:${blockData}, status:${status}`);
          reply.writeInt(status);
          reply.writeString(blockData.substring(0, (blockData.length - 1) > 2048? 2048 : (blockData.length - 1)));
          return true;
        }
        case RequestCode.WriteBlockData: {
          hilog.info(0, 'testTag', `driver testtag WriteBlockData`);
          let blockAddr = data.readInt();
          let blockNum = data.readInt();
          let writeData = data.readString();
          let status = scsiNapi.writeBlocksData(deviceId, blockAddr, blockNum, writeData);
          hilog.info(0, 'testTag', `driver testtag result: status:${status}`);
          reply.writeInt(status);
          return true;
        }
        case RequestCode.VerifyBlockData: {
          hilog.info(0, 'testTag', `driver testtag VerifyBlockData`);
          let blockAddr = data.readInt();
          let blockNum = data.readInt();
          let status = scsiNapi.verifyBlocksData(deviceId, blockAddr, blockNum);
          hilog.info(0, 'testTag', `driver testtag result: status:${status}`);
          reply.writeInt(status);
          return true;
        }
        case RequestCode.RequestSense: {
          hilog.info(0, 'testTag', `driver testtag RequestSense`);
          const [data, parseInfo, status] = scsiNapi.requestSense(deviceId);
          hilog.info(0, 'testTag', `driver testtag result: data:${data}, status:${status}`);
          reply.writeInt(status);
          reply.writeString(data);
          reply.writeString(parseInfo);
          return true;
        }
        case RequestCode.SendCdbData: {
          hilog.info(0, 'testTag', `driver testtag SendCdbData`);
          let cmdData = data.readByteArray();
          let extraData = data.readString();
          let cdbLen = data.readInt();
          let direction = data.readInt();
          hilog.info(0, 'testTag', `===driver testtag result: cdbLen:${cdbLen}, dir:${direction}, cmdData:${cmdData}, extraData:${extraData}`);
          let [retData, status] = scsiNapi.sendCDBData(deviceId, cmdData, cdbLen, direction, extraData);
          hilog.info(0, 'testTag', `driver testtag result: status:${status}, retDataLen:${retData.length}, retData:${retData}`);
          reply.writeInt(status);
          reply.writeString(retData.substring(0, (retData.length - 1) > 2048? 2048 : (retData.length - 1)));
          return true;
        }
        default :
          throw new Error("Invalid RequestCode");
      }
    } catch (error) {
      hilog.info(0, 'testTag', `onRemoteMessageRequest exception, RequestCode:${code}`);
    }
  }

  sendDisconnect() {
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    hilog.info(0, 'testTag', `sendDisconnect`);
    sendMessageRequest(0x99, dataSend, reply, option).then((ret) => {
      let msg = reply.readInt();
      reply.writeInt(msg);
      hilog.info(0, 'testTag', `sendDisconnect sendMessageRequest ret:${ret} msg:${msg}`);
    }).catch((error) => {
      hilog.info(0, 'testTag', 'sendDisconnect sendMessageRequest failed');
    });
  }
}

export default class DriverExtAbility extends DriverExtensionAbility {
  async onInit(want): void {
    hilog.info(0, 'testTag','DriverAbility OnInit start');
    hilog.info(0, 'testTag','OnInit deviceId '+ want.parameters["deviceId"]);
    deviceId = want.parameters["deviceId"];
    initResult = scsiNapi.scsiInit(deviceId);
    hilog.info(0, 'testTag',`scsiInit initResult:${initResult}`);
  }
  onRelease() :void {
    hilog.info(0, 'testTag', 'DriverAbility onRelease');
    // 释放底层资源
    scsiNapi.releaseResource();
  }
  onConnect(want): rpc.RemoteObject {
    hilog.info(0, 'testTag', 'DriverAbility onConnect');
    return new FirstDriverAbilityStub('remote');
  }
  onDisconnect(want): void {
    hilog.info(0, 'testTag', 'DriverAbility onDisconnect');
  }
  onDump(params): Array<string> {
    hilog.info(0, 'testTag', 'DriverAbility onDump, params:' + JSON.stringify(params));
    return ['params'];
  }
};