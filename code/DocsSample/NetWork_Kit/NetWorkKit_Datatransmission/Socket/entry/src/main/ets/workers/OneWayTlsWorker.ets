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

import { MessageEvents, util, worker } from '@kit.ArkTS';
import socket from '@ohos.net.socket';
import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';

const workerPort = worker.workerPort; // 获取 workerPort 实例

let tlsSocket: socket.TLSSocket | null = null; // 确保全局 TLS 连接实例

// 连接服务器
interface LocalAddress {
  address: string;
  family: number;
}

interface ServerAddress {
  address: string;
  port: number;
  family: number;
}

interface CA {
  ca: string[];
}

interface TlsOneWayMessage {
  type: string;
  fileUri?: string;
  serverIp?: string;
  serverPort?: number;
  ca?: string;
  message?: string;
  caContent?: string;
}

// 监听主线程消息
workerPort.onmessage = (e: MessageEvents) => {
  const message: TlsOneWayMessage = e.data;
  handleMessage(message);
};

// 统一处理主线程任务
function handleMessage(message: TlsOneWayMessage) {
  switch (message.type) {
    case 'loadCA':
      if (message.fileUri) {
        loadCA(message.fileUri);
      }
      break;

    case 'connectServer':
      if (message.serverIp && message.serverPort && message.ca) {
        connectToServer(message.serverIp, message.serverPort, message.ca);
      }
      break;

    case 'sendMessage':
      if (message.message) {
        sendMessageToServer(message.message);
      }
      break;
  }
}

// 读取 CA 证书
function loadCA(fileUri: string) {
  try {
    let buf = new ArrayBuffer(1024 * 4);
    let file = fs.openSync(fileUri, fs.OpenMode.READ_ONLY);
    let readLen = fs.readSync(file.fd, buf, { offset: 0 });
    let caContent = buf2String(buf.slice(0, readLen));
    fs.closeSync(file);

    workerPort.postMessage({ type: 'caLoaded', caContent: caContent });
  } catch (e) {
    workerPort.postMessage({ type: 'error', message: `Failed to load CA file: ${e.message}` });
  }
}

function connectToServer(serverIp: string, serverPort: number, ca: string) {
  if (tlsSocket) {
    workerPort.postMessage({ type: 'connectFailure', status: 'Socket already connected' });
    return;
  }

  tlsSocket = socket.constructTLSSocketInstance();

  let localAddress: LocalAddress = { address: '0.0.0.0', family: 1 };
  tlsSocket!.bind(localAddress).then(() => {
    let serverAddress: ServerAddress = { address: serverIp, port: serverPort, family: 1 };
    let opt: CA = { ca: [ca] };

    tlsSocket!.connect({ address: serverAddress, secureOptions: opt })
      .then(() => {
        workerPort.postMessage({ type: 'connectSuccess', status: 'Connected successfully' });

        // 监听服务器消息
        tlsSocket!.on('message', (data) => {
          let receivedMsg = buf2String(data.message);
          workerPort.postMessage({ type: 'serverMessage', message: receivedMsg });
        });

        tlsSocket!.on('close', () => {
          tlsSocket = null; // 连接关闭后，清除 tlsSocket
          workerPort.postMessage({ type: 'connectionClosed', status: 'Connection closed by server' });
        });

      })
      .catch((e: BusinessError) => {
        tlsSocket = null;
        workerPort.postMessage({ type: 'connectFailure', status: `Failed to connect: ${e.message}` });
      });
  }).catch((e: BusinessError) => {
    tlsSocket = null;
    workerPort.postMessage({ type: 'connectFailure', status: `Failed to bind socket: ${e.message}` });
  });
}

// 发送消息到服务器
function sendMessageToServer(message: string) {
  if (!tlsSocket) {
    workerPort.postMessage({ type: 'sendMessageFailure', message: 'TLS connection is not established.' });
    return;
  }

  tlsSocket.send(message + '\r\n')
    .then(() => {
      workerPort.postMessage({ type: 'sendMessageSuccess', message: message });
    })
    .catch((e: Error) => {
      workerPort.postMessage({ type: 'sendMessageFailure', message: e.message });
    });
}

// ArrayBuffer 转 utf8 字符串
function buf2String(buf: ArrayBuffer): string {
  let msgArray = new Uint8Array(buf);
  let textDecoder = util.TextDecoder.create('utf-8');
  return textDecoder.decodeToString(msgArray);
}
