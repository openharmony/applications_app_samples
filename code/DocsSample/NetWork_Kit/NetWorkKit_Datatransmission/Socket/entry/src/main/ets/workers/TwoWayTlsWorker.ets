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

// 获取 workerPort 实例
const workerPort = worker.workerPort;

// 连接到服务器
interface LocalAddress {
  address: string;
  family: number;
}

interface ServerAddress {
  address: string;
  port: number;
  family: number;
}

interface TlsTwoWayMessage {
  type: string;
  fileUri?: string; // 用于传递文件路径
  serverIp?: string; // 服务器 IP 地址
  serverPort?: number; // 服务器端口
  ca?: string; // CA 证书内容
  cert?: string; // 客户端证书内容
  privateKey?: string; // 客户端私钥内容
  message?: string; // 要发送的消息
  caContent?: string; // 从文件中读取的 CA 内容
  certContent?: string; // 从文件中读取的证书内容
  privateKeyContent?: string; // 从文件中读取的私钥内容
}

// 共享变量
let tlsSocket: socket.TLSSocket | null = null;

// 监听主线程消息
workerPort.onmessage = (e: MessageEvents) => {
  const message: TlsTwoWayMessage = e.data;
  handleMessage(message);
};

// 处理不同类型的任务
function handleMessage(message: TlsTwoWayMessage) {
  switch (message.type) {
    case 'loadFile':
      if (message.fileUri) {
        loadFile(message.fileUri);
      }
      break;

    case 'connectServer':
      if (message.serverIp && message.serverPort && message.ca && message.cert && message.privateKey) {
        connectToServer(message.serverIp, message.serverPort, message.ca, message.cert, message.privateKey);
      }
      break;

    case 'sendMessage':
      if (message.message) {
        sendMessageToServer(message.message);
      }
      break;
  }
}

// [Start two-way_authentication_via_tls_socket]
// 读取文件并返回内容
function loadFile(fileUri: string) {
  try {
    let file = fs.openSync(fileUri, fs.OpenMode.READ_ONLY);
    let buf = new ArrayBuffer(1024 * 4);
    let readLen = fs.readSync(file.fd, buf, { offset: 0 });
    let content = buf2String(buf.slice(0, readLen));
    fs.closeSync(file);

    // 根据文件类型返回不同的内容
    let response: TlsTwoWayMessage = { type: 'fileLoaded' };
    if (fileUri.includes('ca')) {
      response.caContent = content;
    } else if (fileUri.includes('cert')) {
      response.certContent = content;
    } else if (fileUri.includes('key')) {
      response.privateKeyContent = content;
    }

    workerPort.postMessage(response);
  } catch (e) {
    workerPort.postMessage({ type: 'error', message: `Failed to load file: ${e.message}` });
  }
}

function connectToServer(serverIp: string, serverPort: number, ca: string, cert: string, privateKey: string) {
  if (tlsSocket) {
    workerPort.postMessage({ type: 'connectFailure', message: 'Socket already connected' });
    return;
  }

  tlsSocket = socket.constructTLSSocketInstance();

  let localAddress: LocalAddress = { address: '0.0.0.0', family: 1 };
  tlsSocket.bind(localAddress).then(() => {
    let serverAddress: ServerAddress = { address: serverIp, port: serverPort, family: 1 };
    let opt: socket.TLSSecureOptions = {
      ca: [ca],
      cert: cert,
      key: privateKey
    };

    tlsSocket!.connect({ address: serverAddress, secureOptions: opt }).then(() => {
      workerPort.postMessage({ type: 'connectSuccess', status: 'Connected successfully' });

      // 监听消息
      tlsSocket!.on('message', (data) => {
        let receivedMsg = buf2String(data.message);
        workerPort.postMessage({ type: 'serverMessage', message: receivedMsg });
      });

      // 监听连接关闭
      tlsSocket!.on('close', () => {
        tlsSocket = null; // 清理连接
        workerPort.postMessage({ type: 'connectionClosed', status: 'Connection closed by server' });
      });
    }).catch((e: BusinessError) => {
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

  tlsSocket.send(message + '\r\n').then(() => {
    workerPort.postMessage({ type: 'sendMessageSuccess', message: message });
  }).catch((e: Error) => {
    workerPort.postMessage({ type: 'sendMessageFailure', message: e.message });
  });
}
// [End two-way_authentication_via_tls_socket]

// ArrayBuffer 转 utf8 字符串
function buf2String(buf: ArrayBuffer): string {
  let msgArray = new Uint8Array(buf);
  let textDecoder = util.TextDecoder.create('utf-8');
  return textDecoder.decodeToString(msgArray);
}


