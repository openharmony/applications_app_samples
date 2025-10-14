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
import { TcpMessage } from '../connect/TcpClient';
// [Start tcp_server_worker_import]
import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End tcp_server_worker_import]
import Logger from '../common/Logger';

// [Start tcp_server_worker_tcpServer]
// 创建一个TCPSocketServer连接，返回一个TCPSocketServer对象。
let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
// [End tcp_server_worker_tcpServer]
let client: socket.TCPSocketConnection | null = null; // 保存客户端连接

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

function handleMessage(message: TcpMessage) {
  switch (message.type) {
    case 'startServer':
      startServer(message);
      break;

    case 'sendMessage':
      if (message.message) {
        sendMessage(message);
      }
      break;

    case 'disConnect':
      disConnect();
      break;
  }
}

function startServer(tcpMessage: TcpMessage) {
  // [Start tcp_server_worker_ipAddress]
  // 绑定本地IP地址和端口，进行监听。
  let ipAddress: socket.NetAddress = {} as socket.NetAddress;
  ipAddress.address = tcpMessage.serverIp!; // 服务端IP
  ipAddress.port = tcpMessage.serverPort; // 端口号
  tcpServer.listen(ipAddress).then(() => {
    Logger.info('listen success');
    workerPort.postMessage({ type: 'listen success' });
  }).catch(() => {
    Logger.info('listen fail');
    workerPort.postMessage({ type: 'listen fail' });
  });
  // [End tcp_server_worker_ipAddress]

  // [Start tcp_server_worker_socketInfo]
  class SocketInfo {
    public message: ArrayBuffer = new ArrayBuffer(1);
    public remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
  }

  tcpServer.on('connect', (client_: socket.TCPSocketConnection) => {
    // [StartExclude tcp_server_worker_socketInfo]
    Logger.info('client connected');
    workerPort.postMessage({ type: 'client connected' });
    // [EndExclude tcp_server_worker_socketInfo]

    // 保存客户端连接
    client = client_;

    // 订阅客户端连接的事件
    client.on('close', () => {
      Logger.info('client on close success');
      workerPort.postMessage({ type: 'client on close success' });
    });

    client.on('message', (value: SocketInfo) => {
      let buffer = value.message;
      let dataView = new DataView(buffer);
      let str = '';
      for (let i = 0; i < dataView.byteLength; ++i) {
        str += String.fromCharCode(dataView.getUint8(i));
      }
      console.log('received message--:' + str);
      console.log('received address--:' + value.remoteInfo.address);
      console.log('received family--:' + value.remoteInfo.family);
      console.log('received port--:' + value.remoteInfo.port);
      console.log('received size--:' + value.remoteInfo.size);
      workerPort.postMessage({ type: 'received message--', message: str });
    });
  });
  // [StartExclude tcp_server_worker_socketInfo]
  // [Start tcp_server_worker_setTimeout]
  // 设置连接超时（例如 30 秒后取消连接）
  setTimeout(() => {
    tcpServer.off('connect');
  }, 30 * 1000);
  // [End tcp_server_worker_setTimeout]
}

function sendMessage(tcpMessage: TcpMessage) {
  if (client) {
    // [EndExclude tcp_server_worker_socketInfo]
    let tcpSendOptions: socket.TCPSendOptions = {} as socket.TCPSendOptions;
    tcpSendOptions.data = tcpMessage.message!;

    client.send(tcpSendOptions).then(() => {
      Logger.info('send success');
      workerPort.postMessage({ type: 'send success', message: tcpMessage.message });

    }).catch((err: Object) => {
      Logger.error('send fail: ' + JSON.stringify(err));
      workerPort.postMessage({ type: 'send fail', message: JSON.stringify(err) });
    });
    // [StartExclude tcp_server_worker_socketInfo]
  } else {
    Logger.info('No client connected');
    workerPort.postMessage({ type: 'No client connected' });
  }
}

function disConnect() {
  if (client) {
    // [EndExclude tcp_server_worker_socketInfo]
    client.close().then(() => {
      Logger.info('close success');
      workerPort.postMessage({ type: 'close success' });
    }).catch((err: BusinessError) => {
      Logger.info('close fail');
      workerPort.postMessage({ type: 'close fail', message: JSON.stringify(err) });
    });

    // 取消事件订阅，设置关闭连接超时（例如 10 秒后取消关闭连接）
    setTimeout(() => {
      client?.off('message');
      client?.off('close');
    }, 10 * 1000);
    // [End tcp_server_worker_socketInfo]

  } else {
    Logger.info('No client to close');
    workerPort.postMessage({ type: 'No client to close' });

  }
}

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = (e: MessageEvents) => {
  const message: TcpMessage = e.data;
  handleMessage(message);
};

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = (e: MessageEvents) => {
}

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = (e: ErrorEvent) => {
}