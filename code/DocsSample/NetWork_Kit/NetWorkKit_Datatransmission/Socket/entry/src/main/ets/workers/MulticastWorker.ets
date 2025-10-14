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

import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import Logger from '../common/Logger';
// [Start multicast_worker_import]
import { socket } from '@kit.NetworkKit';
// [End multicast_worker_import]
import { Message } from '../connect/Multicast'
import { BusinessError } from '@kit.BasicServicesKit';

const MULTICAST_MESSAGE_SEND_INTERVAL = 30 * 1000; // 多播消息发送间隔

// 多播通信数据接口
interface MulticastData {
  address: string;
  port: number;
  family: number;
}

interface MulticastMessageEvent {
  message: ArrayBuffer;
}

function postMessage(arg0: Message) {
  workerPort.postMessage(arg0);
}

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

function startMulticast(data: socket.NetAddress) {
  // [Start multicast_worker_multicast]
  // 创建Multicast对象。
  let multicast: socket.MulticastSocket = socket.constructMulticastSocketInstance();
  // [End multicast_worker_multicast]

  // [Start multicast_worker_multicastConfig]
  // 这里构造一个对象用于加入多播组
  let addr : socket.NetAddress = {
    address: data.address,
    port: data.port,
    family: data.family
  };

  multicast.addMembership(addr).then(() => {
    postMessage({ type: 'multicastStatus', status: 'Joined multicast group' });
    Logger.info(`Multicast: Joined group ${data.address}:${data.port}`);
  }).catch((err: BusinessError) => {
    postMessage({ type: 'multicastStatus', status: 'Failed to join multicast group' });
    Logger.error(`Multicast: Failed to join group ${data.address}:${data.port} - ${JSON.stringify(err)}`);
  });
  // [End multicast_worker_multicastConfig]
  // [Start multicast_worker_on_message]
  // 开启监听消息数据，将接收到的ArrayBuffer类型数据转换为String。
  class SocketInfo {
    public message: ArrayBuffer = new ArrayBuffer(1);
    public remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
  }
  multicast.on('message', (data: SocketInfo) => {
     console.info('接收的数据: ' + JSON.stringify(data))
    const uintArray = new Uint8Array(data.message)
    let str = ''
    for (let i = 0; i < uintArray.length; ++i) {
      str += String.fromCharCode(uintArray[i])
    }
    console.info(str)
    postMessage({ type: 'multicastMessage', status: 'Message received', message: str });
  });
  // [End multicast_worker_on_message]
  // [Start multicast_worker_send]
  // 发送一条多播消息
  multicast.send({ data: 'Hello multicast group!', address: addr }).then(() => {
    Logger.info('Multicast: Message sent successfully');
  }).catch((err: BusinessError) => {
    Logger.error(`Multicast: Failed to send message - ${JSON.stringify(err)}`);
  });
  // [End multicast_worker_send]

  // 设定一定时间后退出多播组
  setTimeout(() => {
    // [Start multicast_worker_off_message]
    multicast.off('message');
    // [End multicast_worker_off_message]

    // [Start multicast_worker_dropMembership]
    multicast.dropMembership(addr).then(() => {
      postMessage({ type: 'multicastStatus', status: 'Dropped multicast membership' });
      Logger.info('Multicast: Dropped membership successfully');
    }).catch((err: BusinessError) => {
      Logger.error(`Multicast: Failed to drop membership - ${JSON.stringify(err)}`);
    });
    // [End multicast_worker_dropMembership]
  }, MULTICAST_MESSAGE_SEND_INTERVAL);
}

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = (e: MessageEvents) => {
  const message: Message = e.data;

  if (message.type === 'startMulticast' && message.message) {
    const multicastData = JSON.parse(message.message) as socket.NetAddress;
    startMulticast(multicastData);
  }
};
// [End application_transmits_data_via_multicast_socket]

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = (e: MessageEvents) => {
};

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = (e: ErrorEvent) => {
};