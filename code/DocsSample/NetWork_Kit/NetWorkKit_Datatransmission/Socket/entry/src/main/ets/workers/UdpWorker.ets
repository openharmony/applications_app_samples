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
import { socket } from '@kit.NetworkKit';
import { TcpMessage } from '../connect/TcpClient';
import { BusinessError } from '@kit.BasicServicesKit';

let udpServer: socket.UDPSocket = socket.constructUDPSocketInstance();

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

// [Start apply_udp_protocol_for_communication]
function startServer(tcpMessage: TcpMessage) {
  let ipAddress: socket.NetAddress = {} as socket.NetAddress;
  ipAddress.address = tcpMessage.serverIp!; // 服务端IP
  ipAddress.port = tcpMessage.serverPort; // 端口号

  udpServer.bind(ipAddress, (err: BusinessError) => {
    if (err) {
      workerPort.postMessage({ type: 'listen fail' });
      return;
    }

    workerPort.postMessage({ type: 'listen success' });

    udpServer.on('message', (value: socket.SocketMessageInfo) => {
      let messageView = '';
      let uint8Array = new Uint8Array(value.message);
      for (let i = 0; i < uint8Array.length; i++) {
        messageView += String.fromCharCode(uint8Array[i]);
      }

      workerPort.postMessage({ type: 'received message--', message: messageView });
    });
  });
}

function sendMessage(tcpMessage: TcpMessage) {
  let netAddress: socket.NetAddress = { address: tcpMessage.clientIp!, port: tcpMessage.clientPort };

  let sendOptions: socket.UDPSendOptions = {
    data: tcpMessage.message!,
    address: netAddress
  };

  udpServer.send(sendOptions, (err: BusinessError) => {
    if (err) {
      workerPort.postMessage({ type: 'send fail', message: JSON.stringify(err) });
    } else {
      workerPort.postMessage({ type: 'send success', message: tcpMessage.message });
    }
  });
}

function disConnect() {
  udpServer.close((err: BusinessError) => {
    if (err) {
      workerPort.postMessage({ type: 'close fail', message: JSON.stringify(err) });
    } else {
      workerPort.postMessage({ type: 'close success' });
    }
  });
}
// [End apply_udp_protocol_for_communication]

workerPort.onmessage = (e: MessageEvents) => {
  const message: TcpMessage = e.data;
  handleMessage(message);
};
