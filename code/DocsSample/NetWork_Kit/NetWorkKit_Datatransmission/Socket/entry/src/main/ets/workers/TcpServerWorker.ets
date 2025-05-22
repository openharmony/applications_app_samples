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
import { socket } from '@kit.NetworkKit';
import { TcpMessage } from '../connect/TcpClient';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../common/Logger';


let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
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

// [Start application_transmits_data_via_tcp_socket_server]
function startServer(tcpMessage: TcpMessage) {
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

  class SocketInfo {
    public message: ArrayBuffer = new ArrayBuffer(1);
    public remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
  }

  tcpServer.on('connect', (client_: socket.TCPSocketConnection) => {
    Logger.info('client connected');
    workerPort.postMessage({ type: 'client connected' });
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
      Logger.info('received message--:' + str);
      workerPort.postMessage({ type: 'received message--', message: str });
    });
  });

  // 设置连接超时（例如 30 秒后取消连接）
  setTimeout(() => {
    tcpServer.off('connect');
  }, 30 * 1000);
}

function sendMessage(tcpMessage: TcpMessage) {
  if (client) {
    let tcpSendOptions: socket.TCPSendOptions = {} as socket.TCPSendOptions;
    tcpSendOptions.data = tcpMessage.message!;

    client.send(tcpSendOptions).then(() => {
      Logger.info('send success');
      workerPort.postMessage({ type: 'send success', message: tcpMessage.message });

    }).catch((err: Object) => {
      Logger.error('send fail: ' + JSON.stringify(err));
      workerPort.postMessage({ type: 'send fail', message: JSON.stringify(err) });
    });
  } else {
    Logger.info('No client connected');
    workerPort.postMessage({ type: 'No client connected' });

  }
}

function disConnect() {
  if (client) {
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
  } else {
    Logger.info('No client to close');
    workerPort.postMessage({ type: 'No client to close' });

  }
}
// [End application_transmits_data_via_tcp_socket_server]

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