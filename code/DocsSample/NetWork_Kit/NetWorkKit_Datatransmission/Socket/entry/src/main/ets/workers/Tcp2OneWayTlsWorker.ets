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

const workerPort = worker.workerPort;

let tcpSocket: socket.TCPSocket | null = null;
let tlsSocket: socket.TLSSocket | null = null;

interface ServerAddress {
  address: string;
  port: number;
  family: number;
}

interface TcpConnectOptions {
  address: ServerAddress;
  timeout: number;
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

workerPort.onmessage = (e: MessageEvents) => {
  const message: TlsOneWayMessage = e.data;
  handleMessage(message);
};

function handleMessage(message: TlsOneWayMessage) {
  switch (message.type) {
    case 'loadCA':
      if (message.fileUri) {
        loadCA(message.fileUri);
      }
      break;
    case 'connectToServer':
      if (message.serverIp && message.serverPort && message.ca) {
        connectToServer(message.serverIp, message.serverPort, message.ca);
      }
      break;
    case 'upgradeToTLS':
      if (message.ca) {
        upgradeToTLSSocket(message.ca);
      }
      break;
    case 'sendMessage':
      if (message.message) {
        sendMessageToServer(message.message);
      }
      break;
  }
}

function loadCA(fileUri: string) {
  try {
    let buf = new ArrayBuffer(4096);
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
  if (tcpSocket) {
    workerPort.postMessage({ type: 'connectFailure', message: 'TCP already connected' });
    return;
  }

  tcpSocket = socket.constructTCPSocketInstance();

  let serverAddress: ServerAddress = { address: serverIp, port: serverPort, family: 1 };
  let tcpConnectOptions: TcpConnectOptions = { address: serverAddress, timeout: 6000 };

  tcpSocket.connect(tcpConnectOptions).then(() => {
    workerPort.postMessage({ type: 'connectSuccess', message: 'TCP connection successful' });
  }).catch((e: BusinessError) => {
    workerPort.postMessage({ type: 'connectFailure', message: `TCP connection failed: ${e.message}` });
  });
}

interface CA {
  ca: string[];
}

function upgradeToTLSSocket(ca: string) {
  if (!tcpSocket) {
    workerPort.postMessage({ type: 'connectFailure', message: 'No active TCP connection' });
    return;
  }

  tlsSocket = socket.constructTLSSocketInstance(tcpSocket);

  let secureOptions: CA = { ca: [ca] };

  tlsSocket.connect({
    secureOptions,
    address: undefined
  }).then(() => {
    workerPort.postMessage({ type: 'tlsConnectSuccess', message: 'TLS connection successful' });

    tlsSocket!.on('message', (data) => {
      let receivedMsg = buf2String(data.message);
      workerPort.postMessage({ type: 'serverMessage', message: receivedMsg });
    });

    tlsSocket!.on('close', () => {
      workerPort.postMessage({ type: 'connectionClosed', message: 'TLS connection closed by server' });
      tlsSocket = null;
    });
  }).catch((e: BusinessError) => {
    tlsSocket = null;
    workerPort.postMessage({ type: 'tlsConnectFailure', message: `TLS connection failed: ${e.message}` });
  });
}

function sendMessageToServer(message: string) {
  if (!tlsSocket) {
    workerPort.postMessage({ type: 'sendMessageFailure', message: 'TLS connection is not established' });
    return;
  }

  tlsSocket.send(message + '\r\n').then(() => {
    workerPort.postMessage({ type: 'sendMessageSuccess', message: message });
  }).catch((e: Error) => {
    workerPort.postMessage({ type: 'sendMessageFailure', message: `Failed to send message: ${e.message}` });
  });
}

function buf2String(buf: ArrayBuffer): string {
  let msgArray = new Uint8Array(buf);
  let textDecoder = util.TextDecoder.create('utf-8');
  return textDecoder.decodeToString(msgArray);
}
