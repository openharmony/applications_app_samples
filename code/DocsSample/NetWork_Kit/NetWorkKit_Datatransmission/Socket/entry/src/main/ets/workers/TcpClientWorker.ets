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
import { TcpMessage } from '../connect/TcpClient';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [Start tcp_client_worker_import]
import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End tcp_client_worker_import]

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
    hilog.error(0x0000, 'testTag', 'Some required fields are missing in worker.');
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
    hilog.info(0x0000, 'testTag', 'on message');
    let buffer = value.message;
    let dataView = new DataView(buffer);
    let str = '';
    for (let i = 0; i < dataView.byteLength; ++i) {
      str += String.fromCharCode(dataView.getUint8(i));
    }
    hilog.info(0x0000, 'testTag', 'on connect received:' + str);
  });

  tcpClient.on('connect', () => {
    hilog.info(0x0000, 'testTag', 'on connect');
  });

  tcpClient.on('close', () => {
    hilog.info(0x0000, 'testTag', 'on close');
  });
  // [End tcp_client_worker_socketInfo]


  // [Start tcp_client_worker_ipAddress]
  // 绑定本地IP地址和端口。
  // [StartExclude tcp_client_worker_ipAddress]
  let ipAddress: socket.NetAddress = {} as socket.NetAddress;
  ipAddress.address = tcpMessage.clientIp!;
  ipAddress.port = tcpMessage.clientPort;
  // [EndExclude tcp_client_worker_ipAddress]
  tcpClient.bind(ipAddress, (err: BusinessError) => {
    if (err) {
      hilog.error(0x0000, 'testTag', 'bind fail');
      return;
    }
    hilog.info(0x0000, 'testTag', 'bind success');

  // bind成功后，连接到指定的IP地址和端口。
    // [StartExclude tcp_client_worker_ipAddress]
    let netAddress: socket.NetAddress = {
      address: tcpMessage.serverIp!,
      port: tcpMessage.serverPort!
    };
    let tcpConnect: socket.TCPConnectOptions = {
      address: netAddress,
      timeout: 6000 // 超时时间设置
    };
    // [EndExclude tcp_client_worker_ipAddress]
    tcpClient.connect(tcpConnect).then(() => {
      hilog.info(0x0000, 'testTag', 'connect success');
      let tcpSendOptions: socket.TCPSendOptions = {
        data: tcpMessage.message!
      };
      tcpClient.send(tcpSendOptions).then(() => {
        hilog.info(0x0000, 'testTag', 'send success');
        // [StartExclude tcp_client_worker_ipAddress]
        workerPort.postMessage({ type: 'sendMessageSuccess', message: tcpMessage.message });
        // [EndExclude tcp_client_worker_ipAddress]
      }).catch(() => {
        hilog.info(0x0000, 'testTag', 'send fail');
        // [StartExclude tcp_client_worker_ipAddress]
        workerPort.postMessage({ type: 'sendMessageFailure', message: 'Sending message failed.' });
        // [EndExclude tcp_client_worker_ipAddress]
      });
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'testTag', 'connect fail');
    });
  })
  // [End tcp_client_worker_ipAddress]
}

function disConnect() {
  // [Start tcp_client_worker_disConnect]
  // 连接使用完毕后，主动关闭。取消相关事件的订阅。
  setTimeout(() => {
    tcpClient.close().then(() => {
      // [StartExclude tcp_client_worker_disConnect]
      workerPort.postMessage({ type: 'Connection closed' });
      // [EndExclude tcp_client_worker_disConnect]
      hilog.info(0x0000, 'testTag', 'close success');
    }).catch((err: BusinessError) => {
      // [StartExclude tcp_client_worker_disConnect]
      workerPort.postMessage({ type: 'Close connection failed' });
      // [EndExclude tcp_client_worker_disConnect]
      hilog.error(0x0000, 'testTag', 'close fail');
    });
    tcpClient.off('message');
    tcpClient.off('connect');
    tcpClient.off('close');
  }, 30 * 1000);
  // [End tcp_client_worker_disConnect]
}

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

