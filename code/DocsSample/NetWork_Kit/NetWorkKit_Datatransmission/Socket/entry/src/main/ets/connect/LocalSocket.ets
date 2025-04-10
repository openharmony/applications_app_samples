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

import { ErrorEvent, MessageEvents, worker } from '@kit.ArkTS'; // 引入 Worker
import Logger from '../common/Logger';


const BUTTON_HEIGHT = 50; // 按钮高度
const BUTTON_FONT_SIZE = 20; // 按钮字体大小
const COMPONENT_MARGIN = 20; // 组件间隔
const BUTTON_BORDER_RADIUS = 5; // 按钮边缘角度
const TIMEOUT = 6000; // 设置超时时间
const CLIENT_CONNECTION_CLOSE_TIME = 30 * 1000; // 连接关闭时间

// 创建 Worker 实例
const workerPort = new worker.ThreadWorker('entry/ets/workers/LocalSocketWorker.ets');

function resourceToString(resource: Resource): string {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct SocketDemo {
  @State clientStatus: string = 'Not Started'; // 客户端状态
  @State serverStatus: string = 'Not Started'; // 服务端状态

  aboutToDisappear(): void {
    workerPort.terminate();
  }

  build() {
    Column() {
      Text($r('app.string.Socket_Communication_Example'))
        .fontSize(BUTTON_FONT_SIZE)
        .margin({ bottom: COMPONENT_MARGIN })

      Text(`${resourceToString($r('app.string.Server_Status'))}${this.serverStatus}`)
        .fontSize(BUTTON_FONT_SIZE)
        .margin({ bottom: COMPONENT_MARGIN })
        .id('serverStatus')

      Text(`${resourceToString($r('app.string.Client_Status'))}${this.clientStatus}`)
        .fontSize(BUTTON_FONT_SIZE)
        .margin({ bottom: COMPONENT_MARGIN })
        .id('clientStatus')

      Button($r('app.string.Start_Local_Socket_Server'))
        .onClick(() => {
          this.startLocalSocketServer(); // 让 Worker 线程执行服务器逻辑
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: COMPONENT_MARGIN })
        .backgroundColor(Color.Green)
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)
        .id('Start_Local_Socket_Server')

      Button($r('app.string.Start_Local_Socket_Communication'))
        .onClick(() => {
          this.startLocalSocket(); // 让 Worker 线程执行客户端逻辑
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: COMPONENT_MARGIN })
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)
        .id('Start_Local_Socket_Communication')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  startLocalSocket() {
    this.clientStatus = 'Starting';
    const sandboxPath: string = getContext(this).filesDir + '/testSocket';

    // 发送消息到 Worker 线程执行 TCP 连接
    workerPort.postMessage({
      type: 'startLocalSocket',
      address: sandboxPath,
      timeout: TIMEOUT,
      closeTime: CLIENT_CONNECTION_CLOSE_TIME
    });

    // 监听 Worker 返回的结果
    workerPort.onmessage = (e: MessageEvents) => {
      if (e.data.type === 'clientStatus') {
        this.clientStatus = e.data.status;
      }
    };

    workerPort.onerror = (e: ErrorEvent) => {
      Logger.error(`Error from Worker: ${e}`);
    };
  }

  startLocalSocketServer() {
    this.serverStatus = 'Starting';
    const sandboxPath: string = getContext(this).filesDir + '/testSocket';

    // 发送消息到 Worker 线程执行服务器监听
    workerPort.postMessage({
      type: 'startLocalSocketServer',
      address: sandboxPath
    });

    // 监听 Worker 返回的结果
    workerPort.onmessage = (e: MessageEvents) => {
      if (e.data.type === 'serverStatus') {
        this.serverStatus = e.data.status;
      }
    };

    workerPort.onerror = (e: ErrorEvent) => {
      Logger.error(`Error from Worker: ${e}`);
    };
  }
}