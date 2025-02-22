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

import { socket } from '@kit.NetworkKit';
import Logger from '../common/Logger';
import { ErrorEvent, MessageEvents, worker } from '@kit.ArkTS'; // 引入 worker

// 创建 Worker 实例
const workerPort = new worker.ThreadWorker('entry/ets/workers/MulticastWorker.ets');

// 按钮相关常量
const BUTTON_HEIGHT = 50; //按钮高度
const BUTTON_FONT_SIZE = 20; //按钮字体大小
const COMPONENT_MARGIN = 20; // 组件间隔
const BUTTON_BORDER_RADIUS = 5; // 按钮边缘角度

export interface Message {
  type: string;
  status: string;
  message?: string; // message 是可选的
}

function resourceToString(resource: Resource): string {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct TCPSocketDemo {
  @State startMulticast: string = '';

  aboutToDisappear(): void {
    workerPort.terminate();
  }

  build() {
    Column() {
      Text(`${resourceToString($r('app.string.Start_multicast_communication'))}${this.startMulticast}`)
        .fontSize(BUTTON_FONT_SIZE)
        .margin({ top: COMPONENT_MARGIN })
        .id('multicast_communication')

      Button($r('app.string.StartMulticast'))
        .onClick(() => {
          this.startMulticastCommunication();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: COMPONENT_MARGIN })
        .backgroundColor(Color.Orange)
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)
        .id('StartMulticast')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  startMulticastCommunication() {
    this.startMulticast = 'In Progress';
    // 定义多播配置数据
    const multicastData: socket.NetAddress = {
      address: '224.0.0.1', // 地址IP
      port: 32123, // 端口号
      family: 1
    };

    const message: Message = {
      type: 'startMulticast',
      status: 'Starting multicast',
      message: JSON.stringify(multicastData)
    };

    workerPort.postMessage(message);

    workerPort.onmessage = (e: MessageEvents) => {
      const response: Message = e.data;
      if (response.type === 'multicastStatus') {
        this.startMulticast = response.status;
      }
      if (response.type === 'multicastMessage') {
        Logger.info(`Multicast message: ${response.message}`);
      }
    };

    workerPort.onerror = (e: ErrorEvent) => {
      Logger.error(`Error from Worker: ${e}`);
    };
  }
}
