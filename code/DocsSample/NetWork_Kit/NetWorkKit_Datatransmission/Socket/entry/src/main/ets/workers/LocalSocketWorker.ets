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
import { hilog } from '@kit.PerformanceAnalysisKit';
// [Start local_socket_worker_import]
import { socket } from '@kit.NetworkKit';
import { common } from '@kit.AbilityKit';
// [End local_socket_worker_import]

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
  if (message.type === 'closeLocalSocketServer') {
    closeLocalSocketServer();
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

// [Start local_socket_worker_client]
// 创建一个LocalSocket连接，返回一个LocalSocket对象。
let client: socket.LocalSocket = socket.constructLocalSocketInstance();
// [End local_socket_worker_client]

// 启动本地 Socket 客户端
function startLocalSocket(address: string, timeout: number, closeTime: number): void {
  // [Start local_socket_worker_on_message]
  client.on('message', (value: socket.LocalSocketMessageInfo) => {
    const uintArray = new Uint8Array(value.message);
    let messageView = '';
    for (let i = 0; i < uintArray.length; i++) {
      messageView += String.fromCharCode(uintArray[i]);
    }
    hilog.info(0x0000, 'testTag', 'total receive: ' + JSON.stringify(value));
    hilog.info(0x0000, 'testTag', 'message information: ' + messageView);
  });

  client.on('connect', () => {
    // [StartExclude local_socket_worker_on_message]
    workerPort.postMessage({ type: 'clientStatus', status: 'Connected' });
    // [EndExclude local_socket_worker_on_message]
    hilog.info(0x0000, 'testTag', 'Client connected');
  });

  client.on('close', () => {
    // [StartExclude local_socket_worker_on_message]
    workerPort.postMessage({ type: 'clientStatus', status: 'Closed' });
    // [EndExclude local_socket_worker_on_message]
    hilog.info(0x0000, 'testTag', 'Client closed');
  });
  // [End local_socket_worker_on_message]

  let localAddress : socket.LocalAddress = {
    address: address
  }

  let sendOpt: socket.LocalSendOptions = {
    data: 'Hello world!'
  };
  let connectOpt: socket.LocalConnectOptions = {
    address: localAddress,
    timeout: timeout
  }
  // [Start local_socket_worker_sendOpt]
  client.connect(connectOpt).then(() => {
    hilog.info(0x0000, 'testTag', `connect success`);
    // 发送数据。
    client.send(sendOpt).then(() => {
      hilog.info(0x0000, 'testTag', `send success`);
    }).catch((err: Object) => {
      hilog.info(0x0000, 'testTag', `send failed: ` + JSON.stringify(err));
    });
  }).catch((err: Object) => {
    hilog.info(0x0000, 'testTag', `connect fail: ` + JSON.stringify(err));
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
  let listenAddr: socket.LocalAddress  = {
    address
  }
  // [Start local_socket_worker_server_listen]
  server.listen(listenAddr).then(() => {
    // [StartExclude local_socket_worker_server_listen]
    workerPort.postMessage({ type: 'serverStatus', status: 'Listening' });
    // [EndExclude local_socket_worker_server_listen]
    hilog.info(0x0000, 'testTag', `Server listening on ${address}`);
  }).catch((err: object) => {
    // [StartExclude local_socket_worker_server_listen]
    workerPort.postMessage({ type: 'serverStatus', status: 'Listen Failed' });
    // [EndExclude local_socket_worker_server_listen]
    hilog.error(0x0000, 'testTag', `Server listen error: ${JSON.stringify(err)}`);
  });
  // [End local_socket_worker_server_listen]

  // [Start local_socket_worker_server_connection]
  // 订阅LocalSocketServer的connect事件。
  server.on('connect', (connection: socket.LocalSocketConnection) => {
    // 订阅LocalSocketConnection相关的事件。
    connection.on('error', (err: Object) => {
      hilog.info(0x0000, 'testTag', 'on error success');
    });

    connection.on('message', (value: socket.LocalSocketMessageInfo) => {
      const uintArray = new Uint8Array(value.message);
      let messageView = '';
      for (let i = 0; i < uintArray.length; i++) {
        messageView += String.fromCharCode(uintArray[i]);
      }
      hilog.info(0x0000, 'testTag', `Server received: ${messageView}`);
    });

    connection.on('error', (err: Object) => {
      hilog.error(0x0000, 'testTag', 'err:' + JSON.stringify(err));
    })

    // 向客户端发送数据。
    let sendOpt : socket.LocalSendOptions = {
      data: 'Hello world!'
    };
    connection.send(sendOpt).then(() => {
      hilog.info(0x0000, 'testTag', 'Server send success');
    }).catch((err: object) => {
      hilog.error(0x0000, 'testTag', `Server send failed: ${JSON.stringify(err)}`);
    });

    // [StartExclude local_socket_worker_server_connection]
    setTimeout(() => {
      // [EndExclude local_socket_worker_server_connection]
      // 关闭与客户端的连接。
      connection.close().then(() => {
        hilog.info(0x0000, 'testTag', 'close success');
      }).catch((err: Object) => {
        hilog.error(0x0000, 'testTag', 'close failed: ' + JSON.stringify(err));
      });

      // 取消LocalSocketConnection相关的事件订阅。
      connection.off('message');
      connection.off('error');
      // [StartExclude local_socket_worker_server_connection]
    }, 10000); // 设置一个合理的超时关闭
    // [EndExclude local_socket_worker_server_connection]
  });
  // [End local_socket_worker_server_connection]



  // 在关闭服务器连接时取消事件订阅
  setTimeout(() => {
    // [Start local_socket_worker_server_off]
    // 取消LocalSocketServer相关的事件订阅。
    server.off('connect');
    server.off('error');
    // [End local_socket_worker_server_off]
    hilog.info(0x0000, 'testTag', 'Server events unsubscribed.');
  }, 30000); // 设置一个合理的超时关闭（例如30秒后关闭服务器）
}

// 关闭服务
function closeLocalSocketServer(): void {
  // [Start local_socket_worker_close_server]
  // 当不需要再连接服务端，需要断开且取消事件的监听时。
  client.off('message');
  client.off('connect');
  client.off('close');
  client.close().then(() => {
    hilog.info(0x0000, 'testTag', 'close client success')
    // [StartExclude local_socket_worker_close_server]
    workerPort.postMessage({ type: 'success', message: `close socket service successfully` });
    // [EndExclude local_socket_worker_close_server]
  }).catch((err: Object) => {
    hilog.error(0x0000, 'testTag', 'close client err: ' + JSON.stringify(err))
    // [StartExclude local_socket_worker_close_server]
    workerPort.postMessage({ type: 'fail', message: `close socket service failed` });
    // [EndExclude local_socket_worker_close_server]
  })
  // [End local_socket_worker_close_server]
}