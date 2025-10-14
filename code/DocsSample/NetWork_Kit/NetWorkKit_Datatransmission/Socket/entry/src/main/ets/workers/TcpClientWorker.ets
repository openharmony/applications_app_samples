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

import { ErrorEvent, MessageEvents, worker } from '@kit.ArkTS';
import { TcpMessage } from '../connect/TcpClient'
// [Start tcp_client_worker_import]
import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End tcp_client_worker_import]
import Logger from '../common/Logger';

const workerPort = worker.workerPort; // 获取 workerPort 实例

// [Start tcp_client_worker_tcpClient]
// 创建一个TCPSocket连接，返回一个TCPSocket对象。
let tcpClient: socket.TCPSocket = socket.constructTCPSocketInstance();
// [End tcp_client_worker_tcpClient]

function handleMessage(message: TcpMessage) {
  switch (message.type) {
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

function sendMessage(tcpMessage: TcpMessage) {
  if (!tcpMessage.clientIp || !tcpMessage.clientPort || !tcpMessage.serverIp || !tcpMessage.serverPort) {
    Logger.error('Some required fields are missing in worker.');
    return;
  }

  if (!tcpClient) {
    workerPort.postMessage({ type: 'sendMessageFailure', message: 'Tcp connection is not established.' });
    return;
  }

  // 绑定本地服务器地址
  // [Start tcp_client_worker_socketInfo]
  class SocketInfo {
    public message: ArrayBuffer = new ArrayBuffer(1);
    public remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
  }

  tcpClient.on('message', (value: SocketInfo) => {
    Logger.info('on message');
    let buffer = value.message;
    let dataView = new DataView(buffer);
    let str = '';
    for (let i = 0; i < dataView.byteLength; ++i) {
      str += String.fromCharCode(dataView.getUint8(i));
    }
    Logger.info('on connect received:' + str);
  });

  tcpClient.on('connect', () => {
    Logger.info('on connect');
  });

  tcpClient.on('close', () => {
    Logger.info('on close');
  });
  // [End tcp_client_worker_socketInfo]


  // [Start tcp_client_worker_ipAddress]
  // 绑定本地IP地址和端口。
  let ipAddress: socket.NetAddress = {} as socket.NetAddress;
  ipAddress.address = tcpMessage.clientIp!;
  ipAddress.port = tcpMessage.clientPort;
  tcpClient.bind(ipAddress, (err: BusinessError) => {
    if (err) {
      Logger.info('bind fail');
      return;
    }
    Logger.info('bind success');

  // bind成功后，连接到指定的IP地址和端口。
    let netAddress: socket.NetAddress = {
      address: tcpMessage.serverIp!,
      port: tcpMessage.serverPort!
    };
    let tcpconnectoptions: socket.TCPConnectOptions = {
      address: netAddress,
      timeout: 6000 // 超时时间设置
    };
    tcpClient.connect(tcpconnectoptions, () => {
      Logger.info('connect success');
      let tcpSendOptions: socket.TCPSendOptions = {
        data: tcpMessage.message!
      };
      tcpClient.send(tcpSendOptions).then(() => {
        Logger.info('send success');
        workerPort.postMessage({ type: 'sendMessageSuccess', message: tcpMessage.message });
      }).catch(() => {
        Logger.info('send fail');
        workerPort.postMessage({ type: 'sendMessageFailure', message: 'Sending message failed.' });
      });
    })
  })
  // [End tcp_client_worker_ipAddress]
}

// [Start tcp_client_worker_disConnect]
function disConnect() {
  // 连接使用完毕后，主动关闭。取消相关事件的订阅。
  setTimeout(() => {
    tcpClient.close().then(() => {
      workerPort.postMessage({ type: 'Connection closed' });
      console.log('close success');
    }).catch((err: BusinessError) => {
      workerPort.postMessage({ type: 'Close connection failed' });
      console.error('close fail');
    });
    tcpClient.off('message');
    tcpClient.off('connect');
    tcpClient.off('close');
  }, 30 * 1000);
}
// [End tcp_client_worker_disConnect]

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 */
workerPort.onmessage = (e: MessageEvents) => {
  const message: TcpMessage = e.data;
  handleMessage(message);
};

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 */
workerPort.onmessageerror = (e: MessageEvents) => {
};

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 */
workerPort.onerror = (e: ErrorEvent) => {
};

