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
import { hilog } from '@kit.PerformanceAnalysisKit';
import { TcpMessage } from '../connect/TcpClient';
// [Start tcp_server_worker_import]
import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End tcp_server_worker_import]

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
  let ipAddress: socket.NetAddress = {} as socket.NetAddress;
  ipAddress.address = tcpMessage.serverIp!; // 服务端IP
  ipAddress.port = tcpMessage.serverPort; // 端口号
  // [Start tcp_server_worker_ipAddress]
  // 绑定本地IP地址和端口，进行监听。
  tcpServer.listen(ipAddress).then(() => {
    hilog.info(0x0000, 'testTag', 'listen success');
    // [StartExclude tcp_server_worker_ipAddress]
    workerPort.postMessage({ type: 'listen success' });
    // [EndExclude tcp_server_worker_ipAddress]
  }).catch(() => {
    hilog.info(0x0000, 'testTag', 'listen fail');
    // [StartExclude tcp_server_worker_ipAddress]
    workerPort.postMessage({ type: 'listen fail' });
    // [EndExclude tcp_server_worker_ipAddress]
  });
  // [End tcp_server_worker_ipAddress]

  // [Start tcp_server_worker_socketInfo]
  class SocketInfo {
    public message: ArrayBuffer = new ArrayBuffer(1);
    public remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
  }
  // 订阅TCPSocketServer的connect事件
  // 客户端与服务端建立连接后，返回一个TCPSocketConnection对象，用于与客户端通信。
  tcpServer.on('connect', (client: socket.TCPSocketConnection) => {
    // [StartExclude tcp_server_worker_socketInfo]
    hilog.info(0x0000, 'testTag', 'client connected');
    workerPort.postMessage({ type: 'client connected' });
    // 保存客户端连接
    client = client;
    // [EndExclude tcp_server_worker_socketInfo]

    // client即为建立连接后获取到的连接对象，可以通过该对象订阅TCPSocketConnection相关的事件。
    client.on('close', () => {
      hilog.info(0x0000, 'testTag', 'client on close success');
      // [StartExclude tcp_server_worker_socketInfo]
      workerPort.postMessage({ type: 'client on close success' });
      // [EndExclude tcp_server_worker_socketInfo]
    });

    client.on('message', (value: SocketInfo) => {
      let buffer = value.message;
      let dataView = new DataView(buffer);
      let str = '';
      for (let i = 0; i < dataView.byteLength; ++i) {
        str += String.fromCharCode(dataView.getUint8(i));
      }
      hilog.info(0x0000, 'testTag', 'received message--:' + str);
      hilog.info(0x0000, 'testTag', 'received address--:' + value.remoteInfo.address);
      hilog.info(0x0000, 'testTag', 'received family--:' + value.remoteInfo.family);
      hilog.info(0x0000, 'testTag', 'received port--:' + value.remoteInfo.port);
      hilog.info(0x0000, 'testTag', 'received size--:' + value.remoteInfo.size);
      // [StartExclude tcp_server_worker_socketInfo]
      workerPort.postMessage({ type: 'received message--', message: str });
      // [EndExclude tcp_server_worker_socketInfo]
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
    // 用户可根据需要自行定义发送数据
    tcpSendOptions.data = tcpMessage.message!;

    client.send(tcpSendOptions).then(() => {
      hilog.info(0x0000, 'testTag', 'send success');
      // [StartExclude tcp_server_worker_socketInfo]
      workerPort.postMessage({ type: 'send success', message: tcpMessage.message });
      // [EndExclude tcp_server_worker_socketInfo]
    }).catch((err: Object) => {
      hilog.error(0x0000, 'testTag', 'send fail: ' + JSON.stringify(err));
      // [StartExclude tcp_server_worker_socketInfo]
      workerPort.postMessage({ type: 'send fail', message: JSON.stringify(err) });
      // [EndExclude tcp_server_worker_socketInfo]
    });
    // [StartExclude tcp_server_worker_socketInfo]
  } else {
    hilog.info(0x0000, 'testTag', 'No client connected');
    workerPort.postMessage({ type: 'No client connected' });
  }
}

function disConnect() {
  if (client) {
    // [EndExclude tcp_server_worker_socketInfo]
    client.close().then(() => {
      hilog.info(0x0000, 'testTag', 'close success');
      // [StartExclude tcp_server_worker_socketInfo]
      workerPort.postMessage({ type: 'close success' });
      // [EndExclude tcp_server_worker_socketInfo]
    }).catch((err: BusinessError) => {
      hilog.info(0x0000, 'testTag', 'close fail');
      // [StartExclude tcp_server_worker_socketInfo]
      workerPort.postMessage({ type: 'close fail', message: JSON.stringify(err) });
      // [EndExclude tcp_server_worker_socketInfo]
    });

    // 取消事件订阅，设置关闭连接超时（例如 10 秒后取消关闭连接）
    setTimeout(() => {
      client?.off('message');
      client?.off('close');
    }, 10 * 1000);
    // [End tcp_server_worker_socketInfo]

  } else {
    hilog.info(0x0000, 'testTag', 'No client to close');
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