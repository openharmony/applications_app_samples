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
// [Start one_way_tls_worker_import]
import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End one_way_tls_worker_import]
const workerPort = worker.workerPort; // 获取 workerPort 实例

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
    case 'disConnect':
      closeConnection();
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

// [Start create_tls_worker_object]
// 创建一个（单向认证）TLS Socket连接，返回一个TLS Socket对象。
let tlsOneWaySocket: socket.TLSSocket = socket.constructTLSSocketInstance();  // One way authentication
// [End create_tls_worker_object]

// [Start tls_worker_bind_the_server]
class SocketInfo {
  public message: ArrayBuffer = new ArrayBuffer(1);
  public remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
}
// [StartExclude tls_worker_bind_the_server]
function connectToServer(serverIp: string, serverPort: number, ca: string) {
  let ipAddress: LocalAddress = { address: '0.0.0.0', family: 1 };
  // [EndExclude tls_worker_bind_the_server]
  // 绑定本地IP地址和端口。
  tlsOneWaySocket!.bind(ipAddress).then(() => {
    hilog.info(0x0000, 'testTag', 'bind success');
    // [StartExclude tls_worker_bind_the_server]
    let serverAddress: ServerAddress = { address: serverIp, port: serverPort, family: 1 };
    let opt: CA = { ca: [ca] };
    // [EndExclude tls_worker_bind_the_server]
    /// 订阅TLS Socket相关的订阅事件
    tlsOneWaySocket!.on('message', (value: SocketInfo) => {
      hilog.info(0x0000, 'testTag', 'on message');
      let buffer = value.message;
      let dataView = new DataView(buffer);
      let str = '';
      for (let i = 0; i < dataView.byteLength; ++i) {
        str += String.fromCharCode(dataView.getUint8(i));
      }
      hilog.info(0x0000, 'testTag', 'on connect received:' + str);
    });
    tlsOneWaySocket!.on('connect', () => {
      hilog.info(0x0000, 'testTag', 'on connect');
    });
    tlsOneWaySocket!.on('close', () => {
      hilog.info(0x0000, 'testTag', 'on close');
      // [StartExclude tls_worker_bind_the_server]
      workerPort.postMessage({ type: 'connectionClosed', status: 'Connection closed by server' });
      // [EndExclude tls_worker_bind_the_server]
    });
    tlsOneWaySocket!.connect({ address: serverAddress, secureOptions: opt }).then(() => {
      hilog.info(0x0000, 'testTag', 'connect successfully');
      // [StartExclude tls_worker_bind_the_server]
      workerPort.postMessage({ type: 'connectSuccess', status: 'Connected successfully' });
      // [EndExclude tls_worker_bind_the_server]
    }).catch((e: BusinessError) => {
      hilog.error(0x0000, 'testTag', `Failed to connect: ${e.message}`);
      // [StartExclude tls_worker_bind_the_server]
      workerPort.postMessage({ type: 'connectFailure', status: `Failed to connect: ${e.message}` });
      // [EndExclude tls_worker_bind_the_server]
    });
  }).catch((e: BusinessError) => {
    hilog.error(0x0000, 'testTag', 'bind fail');
    // [StartExclude tls_worker_bind_the_server]
    workerPort.postMessage({ type: 'connectFailure', status: `Failed to bind socket: ${e.message}` });
    // [EndExclude tls_worker_bind_the_server]
  });
  // [StartExclude tls_worker_bind_the_server]
}

function sendMessageToServer(message: string) {
  if (!tlsOneWaySocket) {
    workerPort.postMessage({ type: 'sendMessageFailure', message: 'TLS connection is not established.' });
    return;
  }
  // [EndExclude tls_worker_bind_the_server]
  // 建立连接，连接建立成功后，可以发送数据。
  tlsOneWaySocket.send(message + '\r\n').then(() => {
    hilog.info(0x0000, 'testTag', 'send successfully');
    // [StartExclude tls_worker_bind_the_server]
    workerPort.postMessage({ type: 'sendMessageSuccess', message: message });
    // [EndExclude tls_worker_bind_the_server]
  }).catch((e: BusinessError) => {
    hilog.error(0x0000, 'testTag', 'send failed ' + JSON.stringify(e));
    // [StartExclude tls_worker_bind_the_server]
    workerPort.postMessage({ type: 'sendMessageFailure', message: e.message });
    // [EndExclude tls_worker_bind_the_server]
  });
  // [End tls_worker_bind_the_server]
}

// 关闭连接
function closeConnection() {
  if (!tlsOneWaySocket) {
    return;
  }
  // [Start tls_worker_close_the_server]
  // 连接使用完毕后，主动关闭，并取消相关事件的订阅。
  tlsOneWaySocket!.close((err: BusinessError) => {
    if (err) {
      hilog.error(0x0000, 'testTag', 'close callback error = ' + err);
      // [StartExclude tls_worker_close_the_server]
      workerPort.postMessage({ type: 'Close connection failed' });
      // [EndExclude tls_worker_close_the_server]
    } else {
      hilog.info(0x0000, 'testTag', 'close success');
      // [StartExclude tls_worker_close_the_server]
      workerPort.postMessage({ type: 'Connection closed' });
      // [EndExclude tls_worker_close_the_server]
    }
    tlsOneWaySocket!.off('message');
    tlsOneWaySocket!.off('connect');
    tlsOneWaySocket!.off('close');
  });
  // [End tls_worker_close_the_server]
}

// ArrayBuffer 转 utf8 字符串
function buf2String(buf: ArrayBuffer): string {
  let msgArray = new Uint8Array(buf);
  let textDecoder = util.TextDecoder.create('utf-8');
  return textDecoder.decodeToString(msgArray);
}

