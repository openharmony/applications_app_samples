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
import fs from '@ohos.file.fs';
// [Start tcp_to_tls_server_import]
import socket from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
// [End tcp_to_tls_server_import]

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
    case 'closeServer':
      if (message.message) {
        closeServer();
      }
      break;
  }
}

// [Start two-way_authentication_by_upgrading_tcp_socket_to_tls_socket]
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


class SocketInfo {
  message: ArrayBuffer = new ArrayBuffer(1);
  remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
}
// [Start tcp_to_tls_server_create_object]
// 创建一个TCPSocket连接，返回一个TCPSocket对象。
let tcpSocket: socket.TCPSocket = socket.constructTCPSocketInstance();
// [End tcp_to_tls_server_create_object]

// Connect to the server and perform TLS upgrade
function connectToServer(serverIp: string, serverPort: number, ca: string, cert: string, privateKey: string) {
  let serverAddress: ServerAddress = { address: serverIp, port: serverPort, family: 1 };
  let tcpConnect: socket.TCPConnectOptions = { address: serverAddress, timeout: 6000 }; // Set timeout to 6s
  // [Start tcp_Upgrade_to_tls_server]
  // 如果需要绑定特定的端口，可通过bind接口实现
  tcpSocket.connect(tcpConnect).then(() => {
    console.info('connect success');
    // [StartExclude tcp_Upgrade_to_tls_server]
    workerPort.postMessage({ type: 'connectSuccess', message: 'TCP connection successful' });
    // [EndExclude tcp_Upgrade_to_tls_server]
    // 确保TCPSocket已连接后，将其升级为TLSSocket连接。
    tlsSocket = socket.constructTLSSocketInstance(tcpSocket);
    // 订阅TLSSocket相关的订阅事件。
    tlsSocket.on('message', (value: SocketInfo) => {
      console.info('tls on message');
      let buffer = value.message;
      let dataView = new DataView(buffer);
      let str = '';
      for (let i = 0; i < dataView.byteLength; ++i) {
        str += String.fromCharCode(dataView.getUint8(i));
      }
      console.info('tls on connect received:' + str);
    });
    tlsSocket.on('connect', () => {
      console.info('tls on connect');
    });
    tlsSocket!.on('close', () => {
      console.info('tls on close');
      // [StartExclude tcp_Upgrade_to_tls_server]
      workerPort.postMessage({ type: 'connectionClosed', message: 'TLS connection closed' });
      // [EndExclude tcp_Upgrade_to_tls_server]
    });
    // [StartExclude tcp_Upgrade_to_tls_server]
    let tlsSecureOption: SecureOptions = {
      ca: [ca],
      cert: cert,
      key: privateKey,
    };
    let tlsTwoWayConnectOption: socket.TLSConnectOptions = {
      secureOptions: tlsSecureOption,
      address: {
        address: serverIp,
        port: serverPort,
        family: 1,
      },
    };
    // [EndExclude tcp_Upgrade_to_tls_server]
    // 建立TLSSocket连接。
    tlsSocket.connect(tlsTwoWayConnectOption).then(() => {
      console.info('tls connect success');
      // [StartExclude tcp_Upgrade_to_tls_server]
      workerPort.postMessage({ type: 'tlsConnectSuccess', message: 'TLS mutual authentication connection successful' });
      // [EndExclude tcp_Upgrade_to_tls_server]
    }).catch((e: BusinessError) => {
      console.info('tls connect fail');
      // [StartExclude tcp_Upgrade_to_tls_server]
      workerPort.postMessage({ type: 'tlsConnectFailure', message: `TLS connection failed: ${e.message}` });
      // [EndExclude tcp_Upgrade_to_tls_server]
    });
  }).catch((e: BusinessError) => {
    console.error('connect fail');
    // [StartExclude tcp_Upgrade_to_tls_server]
    workerPort.postMessage({ type: 'connectFailure', message: `TCP connection failed: ${e.message}` });
    // [EndExclude tcp_Upgrade_to_tls_server]
  });
  // [End tcp_Upgrade_to_tls_server]
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
// [End two-way_authentication_by_upgrading_tcp_socket_to_tls_socket]

function closeServer() {
  if (!tlsSocket) {
    workerPort.postMessage({ type: 'closeFailure', message: 'TLS connection close failed' });
    return;
  }
  // [Start tls_server_close]
  // 连接使用完毕后，主动关闭。取消相关事件的订阅。
  tlsSocket!.close((err: BusinessError) => {
    if (err) {
      // [StartExclude tls_server_close]
      workerPort.postMessage({ type: 'closeFailure', message: 'TLS connection close failed' });
      // [EndExclude tls_server_close]
      console.error('tls close callback error = ' + err);
    } else {
      console.info('tls close success');
      // [StartExclude tls_server_close]
      workerPort.postMessage({ type: 'closeSuccess', message: 'TLS connection close success' });
      // [EndExclude tls_server_close]
    }
    tlsSocket!.off('message');
    tlsSocket!.off('connect');
    tlsSocket!.off('close');
  });
  // [End tls_server_close]
}

function buf2String(buf: ArrayBuffer): string {
  let msgArray = new Uint8Array(buf);
  let textDecoder = util.TextDecoder.create('utf-8');
  return textDecoder.decodeToString(msgArray);
}
