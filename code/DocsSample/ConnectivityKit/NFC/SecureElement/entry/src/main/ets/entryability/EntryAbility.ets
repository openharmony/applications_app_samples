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

import { omapi } from '@kit.ConnectivityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';

let seService : omapi.SEService;
let seReaders : omapi.Reader[];
let seSession : omapi.Session;
let seChannel : omapi.Channel;
let aidArray : number[] = [0xA0, 0x00, 0x00, 0x00, 0x03, 0x10, 0x10];
let p2 : number = 0x00;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    // 判断设备是否支持安全单元能力
    if (!canIUse('SystemCapability.Communication.SecureElement')) {
      hilog.error(0x0000, 'testTag', 'secure element unavailable.');
      return;
    }
    hilog.info(0x0000, 'testTag', 'secure element available.');
    this.omaTest();
  }

  private async omaTest () {
    // 获取服务
    await omapi.createService().then((data) => {
      if (data == undefined || !data.isConnected()) {
        hilog.error(0x0000, 'testTag', 'secure element service disconnected.');
        return;
      }
      seService = data;
      hilog.info(0x0000, 'testTag', 'secure element service connected.');
    }).catch((error: BusinessError) => {
      hilog.error(0x0000, 'testTag', 'createService error %{public}s', JSON.stringify(error));
      return;
    });

    // 获取读卡器
    try {
      seReaders = seService.getReaders();
    } catch (error) {
      hilog.error(0x0000, 'testTag', 'getReaders error %{public}s', JSON.stringify(error));
    }
    if (seReaders == undefined || seReaders.length == 0) {
      hilog.error(0x0000, 'testTag', 'no valid reader found.');
      seService.shutdown();
      return;
    }
    let reader: (omapi.Reader | undefined);
    for (let i = 0; i < seReaders.length; ++i) {
      let r = seReaders[i];
      if (r.getName().includes('SIM')) {
        reader = r;
        break;
      }
    }
    if (reader == undefined) {
      hilog.error(0x0000, 'testTag', 'no valid sim reader.');
      return;
    }
    hilog.info(0x0000, 'testTag', 'reader is %{public}s', reader?.getName());

    // 获取会话
    try {
      seSession = reader?.openSession() as omapi.Session;
    } catch (error) {
      hilog.error(0x0000, 'testTag', 'openSession error %{public}s', JSON.stringify(error));
    }
    if (seSession == undefined) {
      hilog.error(0x0000, 'testTag', 'seSession invalid.');
      seService.shutdown();
      return;
    }

    // 获取通道
    try {
      // 修改此处的aid值以打开逻辑通道。
      seChannel = await seSession.openLogicalChannel(aidArray, p2);
    } catch (exception) {
      hilog.error(0x0000, 'testTag', 'openLogicalChannel exception %{public}s', JSON.stringify(exception));
    }

    if (seChannel == undefined) {
      hilog.error(0x0000, 'testTag', 'seChannel invalid.');
      return;
    }

    // 发送数据
    let cmdData = [0x01, 0x02, 0x03, 0x04]; // 请根据需要修改原始数据。
    try {
      let response: number[] = await seChannel.transmit(cmdData)
      hilog.info(0x0000, 'testTag', 'seChannel.transmit() response = %{public}s.', JSON.stringify(response));
    } catch (exception) {
      hilog.error(0x0000, 'testTag', 'seChannel.transmit() exception = %{public}s.', JSON.stringify(exception));
    }

    // 关闭通道。必须确保最后关闭通道。
    try {
      seChannel.close();
    } catch (exception) {
      hilog.error(0x0000, 'testTag', 'seChannel.close() exception = %{public}s.', JSON.stringify(exception));
    }

  }
}
