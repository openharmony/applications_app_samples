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

import { MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
// [Start local_socket_worker_import]
import { socket } from '@kit.NetworkKit';
import { common } from '@kit.AbilityKit';
// [End local_socket_worker_import]
import Logger from '../common/Logger';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

interface SocketMessage {
  type: string;
  address: string;
  timeout?: number;
  closeTime?: number;
}

// 处理主线程发送的消息
workerPort.onmessage = (e: MessageEvents) => {
  const message: SocketMessage = e.data;

  if (message.type === 'startLocalSocket') {
    startLocalSocket(message.address, message.timeout || 6000, message.closeTime || 30000); // 默认消息超时6s消息关闭时间30s
  }
  if (message.type === 'startLocalSocketServer') {
    startLocalSocketServer(message.address);
  }
};

// 字符串转 `ArrayBuffer`
function stringToArrayBuffer(str: string): ArrayBuffer {
  const buf = new ArrayBuffer(str.length);
  const bufView = new Uint8Array(buf);
  for (let i = 0; i < str.length; i++) {
    bufView[i] = str.charCodeAt(i);
  }
  return buf;
}


// 启动本地 Socket 客户端
function startLocalSocket(address: string, timeout: number, closeTime: number): void {
  // [Start local_socket_worker_client]
  let client: socket.LocalSocket = socket.constructLocalSocketInstance();
  // [End local_socket_worker_client]

  // [Start local_socket_worker_on_message]
  client.on('message', (value: socket.LocalSocketMessageInfo) => {
    const uintArray = new Uint8Array(value.message);
    let messageView = '';
    for (let i = 0; i < uintArray.length; i++) {
      messageView += String.fromCharCode(uintArray[i]);
    }
    Logger.info(`Client received: ${messageView}`);
  });

  client.on('connect', () => {
    // [StartExclude local_socket_worker_on_message_part_one]
    workerPort.postMessage({ type: 'clientStatus', status: 'Connected' });
    // [EndExclude local_socket_worker_on_message_part_one]
    Logger.info('Client connected');
  });

  client.on('close', () => {
    // [StartExclude local_socket_worker_on_message_part_two]
    workerPort.postMessage({ type: 'clientStatus', status: 'Closed' });
    // [EndExclude local_socket_worker_on_message_part_two]
    Logger.info('Client closed');
  });
  // [End local_socket_worker_on_message]

  // [Start local_socket_worker_sendOpt]
  let sendOpt: socket.LocalSendOptions = {
    data: 'Hello world!'
  };

  client.connect({ address: { address }, timeout }).then(() => {
    Logger.info(`connect success`);
    client.send(sendOpt).then(() => {
      Logger.info(`send success`);
    }).catch((err: Object) => {
      Logger.info(`send failed: ` + JSON.stringify(err));
    });
  }).catch((err: Object) => {
    Logger.info(`connect fail: ` + JSON.stringify(err));
  });
  // [End local_socket_worker_sendOpt]

  setTimeout(async () => {
    await client.close();
    workerPort.postMessage({ type: 'clientStatus', status: 'Closed by timeout' });
  }, closeTime);
}


// 启动本地 Socket 服务器
function startLocalSocketServer(address: string): void {
  // [Start local_socket_server_create]
  // 创建一个LocalSocketServer连接，返回一个LocalSocketServer对象。
  let server: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();
  // [End local_socket_server_create]

  // [Start local_socket_worker_server_listen]
  server.listen({ address }).then(() => {
    workerPort.postMessage({ type: 'serverStatus', status: 'Listening' });
    Logger.info(`Server listening on ${address}`);
  }).catch((err: object) => {
    workerPort.postMessage({ type: 'serverStatus', status: 'Listen Failed' });
    Logger.error(`Server listen error: ${JSON.stringify(err)}`);
  });
  // [End local_socket_worker_server_listen]

  // [Start local_socket_worker_server_connection]
  // 订阅LocalSocketServer的connect事件。
  server.on('connect', (connection: socket.LocalSocketConnection) => {
    // 订阅LocalSocketConnection相关的事件。
    connection.on('error', (err: Object) => {
      console.log('on error success');
    });

    connection.on('message', (value: socket.LocalSocketMessageInfo) => {
      const uintArray = new Uint8Array(value.message);
      let messageView = '';
      for (let i = 0; i < uintArray.length; i++) {
        messageView += String.fromCharCode(uintArray[i]);
      }
      Logger.info(`Server received: ${messageView}`);
    });

    connection.on('error', (err: Object) => {
      console.error('err:' + JSON.stringify(err));
    })

    // 向客户端发送数据。
    let sendOpt : socket.LocalSendOptions = {
      data: 'Hello world!'
    };
    connection.send(sendOpt).then(() => {
      Logger.info('Server send success');
    }).catch((err: object) => {
      Logger.error(`Server send failed: ${JSON.stringify(err)}`);
    });
    setTimeout(() => {
      // 取消事件订阅
      connection.close();
      Logger.info('Connection close by server.');
    }, 10000); // 设置一个合理的超时关闭
  });
  // [End local_socket_worker_server_connection]



  // 在关闭服务器连接时取消事件订阅
  setTimeout(() => {
    // [Start local_socket_worker_server_off]
    // 取消事件订阅
    server.off('connect');
    server.off('error');
    // [End local_socket_worker_server_off]
    Logger.info('Server events unsubscribed.');
  }, 30000); // 设置一个合理的超时关闭（例如30秒后关闭服务器）
}