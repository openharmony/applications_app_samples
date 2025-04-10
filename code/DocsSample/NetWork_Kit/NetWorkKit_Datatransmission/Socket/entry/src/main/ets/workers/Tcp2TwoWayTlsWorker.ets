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

interface TlsTwoWayMessage {
  type: string;
  fileUri?: string; // For passing file path
  serverIp?: string; // Server IP address
  serverPort?: number; // Server port
  ca?: string; // CA certificate content
  cert?: string; // Client certificate content
  privateKey?: string; // Client private key content
  message?: string; // Message to send
  caContent?: string; // CA content read from file
  certContent?: string; // Certificate content read from file
  privateKeyContent?: string; // Private key content read from file
  content?: string; // General file load return content (optional)
}

let tcpSocket: socket.TCPSocket | null = null;
let tlsSocket: socket.TLSSocket | null = null;

interface ServerAddress {
  address: string;
  port: number;
  family: number;
}

interface SecureOptions {
  ca: string[];
  cert: string;
  key: string;
}

workerPort.onmessage = (e: MessageEvents) => {
  const message: TlsTwoWayMessage = e.data;
  handleMessage(message);
};

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

// Handle file loading (CA certificate, client certificate, private key)
function loadFile(fileUri: string) {
  try {
    let buf = new ArrayBuffer(4096); // Set buffer size
    let file = fs.openSync(fileUri, fs.OpenMode.READ_ONLY);
    let readLen = fs.readSync(file.fd, buf, { offset: 0 });
    let fileContent = buf2String(buf.slice(0, readLen));
    fs.closeSync(file);

    if (fileUri.includes('ca')) {
      workerPort.postMessage({ type: 'fileLoaded', caContent: fileContent });
    } else if (fileUri.includes('cert')) {
      workerPort.postMessage({ type: 'fileLoaded', certContent: fileContent });
    } else if (fileUri.includes('key')) {
      workerPort.postMessage({ type: 'fileLoaded', privateKeyContent: fileContent });
    }
  } catch (e) {
    workerPort.postMessage({ type: 'error', message: `File loading failed: ${e.message}` });
  }
}

// Connect to the server and perform TLS upgrade
function connectToServer(serverIp: string, serverPort: number, ca: string, cert: string, privateKey: string) {
  if (tcpSocket) {
    workerPort.postMessage({ type: 'connectFailure', message: 'TCP already connected' });
    return;
  }

  tcpSocket = socket.constructTCPSocketInstance();

  let serverAddress: ServerAddress = { address: serverIp, port: serverPort, family: 1 };
  let tcpConnectOptions: socket.TCPConnectOptions = { address: serverAddress, timeout: 6000 }; // Set timeout to 6s

  tcpSocket.connect(tcpConnectOptions).then(() => {
    workerPort.postMessage({ type: 'connectSuccess', message: 'TCP connection successful' });

    // Upgrade to TLS
    tlsSocket = socket.constructTLSSocketInstance(tcpSocket);

    let secureOptions: SecureOptions = {
      ca: [ca],
      cert: cert,
      key: privateKey,
    };

    tlsSocket.connect({
      secureOptions,
      address: {
        address: serverIp,
        port: serverPort,
        family: 1,
      },
    }).then(() => {
      workerPort.postMessage({ type: 'tlsConnectSuccess', message: 'TLS mutual authentication connection successful' });

      tlsSocket!.on('message', (data) => {
        let receivedMsg = buf2String(data.message);
        workerPort.postMessage({ type: 'serverMessage', message: receivedMsg });
      });

      tlsSocket!.on('close', () => {
        workerPort.postMessage({ type: 'connectionClosed', message: 'TLS connection closed' });
      });
    }).catch((e: BusinessError) => {
      workerPort.postMessage({ type: 'tlsConnectFailure', message: `TLS connection failed: ${e.message}` });
    });
  }).catch((e: BusinessError) => {
    workerPort.postMessage({ type: 'connectFailure', message: `TCP connection failed: ${e.message}` });
  });
}

// Send message to the server
function sendMessageToServer(message: string) {
  if (!tlsSocket) {
    workerPort.postMessage({ type: 'sendMessageFailure', message: 'TLS connection not established' });
    return;
  }

  tlsSocket.send(message + '\r\n').then(() => {
    workerPort.postMessage({ type: 'sendMessageSuccess', message: message });
  }).catch((e: Error) => {
    workerPort.postMessage({ type: 'sendMessageFailure', message: `Send failed: ${e.message}` });
  });
}

function buf2String(buf: ArrayBuffer): string {
  let msgArray = new Uint8Array(buf);
  let textDecoder = util.TextDecoder.create('utf-8');
  return textDecoder.decodeToString(msgArray);
}
