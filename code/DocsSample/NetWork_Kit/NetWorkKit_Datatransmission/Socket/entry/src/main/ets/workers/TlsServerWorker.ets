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
// [Start tls_server_import]
import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End tls_server_import]
import { MessageEvents, util, worker } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { TlsServerMessage } from '../connect/TlsServer';

// [Start tls_server_instance]
let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
// [End tls_server_instance]

const workerPort = worker.workerPort;

workerPort.onmessage = (e: MessageEvents) => {
  const message:TlsServerMessage = e.data;
  handleMessage(message);
};

function handleMessage(message: TlsServerMessage) {
  switch (message.type) {
    case 'startServer':
      startTLSserver(message);
      break;
    case 'stopServer':
      closeConnection();
      break;
    default:
      break;
  }
}

// [Start application_transmits_encrypted_data_via_tls_socket_server]
function startTLSserver(message: TlsServerMessage) {
  try {
    let netAddress: socket.NetAddress = {
      address: message.serverIp!,
      port: message.serverPort
    }
    const tlsSecureOptions: socket.TLSSecureOptions = {
      key: message.serverKey,
      cert: message.serverCert,
      ca: message.caCert,
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: 'rsa_pss_rsae_sha256:ECDSA+SHA256',
      cipherSuite: 'AES256-SHA256'
    };
    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ['spdy/1', 'http/1.1']
    };
    // [Start tlsServer_start_service]
    tlsServer.listen(tlsConnectOptions).then(() => {
      hilog.info(0x0000, 'testTag', 'listen callback success');
      // [StartExclude tlsServer_start_service]
      workerPort.postMessage({ type: 'serverStarted', status: 'TLS server started successfully' });
      handleClientConnection();
      // [EndExclude tlsServer_start_service]
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'testTag', 'failed' + err);
      // [StartExclude tlsServer_start_service]
      workerPort.postMessage({ type: 'error', message: `Failed to start TLS server: ${err.message}` });
      // [EndExclude tlsServer_start_service]
    });
    // [End tlsServer_start_service]
  } catch (err) {
    workerPort.postMessage({ type: 'error', message: `Error starting server: ${err.message}` });
  }
}

// [Start tlsServer_connection_methods]
class SocketInfo {
  public message: ArrayBuffer = new ArrayBuffer(1);
  public remoteInfo: socket.SocketRemoteInfo = {} as socket.SocketRemoteInfo;
}
let callback = (value: SocketInfo) => {
  let messageView = '';
  for (let i: number = 0; i < value.message.byteLength; i++) {
    let uint8Array = new Uint8Array(value.message)
    let messages = uint8Array[i]
    let message = String.fromCharCode(messages);
    messageView += message;
  }
  hilog.info(0x0000, 'testTag', 'on message message: ' + JSON.stringify(messageView));
  hilog.info(0x0000, 'testTag', 'remoteInfo: ' + JSON.stringify(value.remoteInfo));
  // [StartExclude tlsServer_connection_methods]
  workerPort.postMessage({ type: 'clientMessage', message: messageView });
  // [EndExclude tlsServer_connection_methods]
}
// [StartExclude tlsServer_connection_methods]
function handleClientConnection() {
  // [EndExclude tlsServer_connection_methods]
  tlsServer.on('connect', (client: socket.TLSSocketConnection) => {
    client.on('message', callback);
    // 发送数据。
    client.send('Hello, client!').then(() => {
      hilog.info(0x0000, 'testTag', 'send success');
      // [StartExclude tlsServer_connection_methods]
      workerPort.postMessage({ type: 'messageSent', message: 'Message sent successfully' });
      // [EndExclude tlsServer_connection_methods]
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'testTag', 'send fail');
      // [StartExclude tlsServer_connection_methods]
      workerPort.postMessage({ type: 'error', message: `Failed to send message: ${err.message}` });
      // [EndExclude tlsServer_connection_methods]
    });
    // 断开连接。
    client.close().then(() => {
      hilog.info(0x0000, 'testTag', 'close success');
      // [StartExclude tlsServer_connection_methods]
      workerPort.postMessage({ type: 'connectionClosed', message: 'Connection closed successfully' });
      // [EndExclude tlsServer_connection_methods]
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, 'testTag', 'close fail');
      // [StartExclude tlsServer_connection_methods]
      workerPort.postMessage({ type: 'error', message: `Failed to close connection: ${err.message}` });
      // [EndExclude tlsServer_connection_methods]
    });

    // 可以指定传入on中的callback取消一个订阅，也可以不指定callback清空所有订阅。
    client.off('message', callback);
    client.off('message');
    // [End tlsServer_connection_methods]
  });
}
// [End application_transmits_encrypted_data_via_tls_socket_server]

// 停止服务
function closeConnection() {
  // [Start tlsServer_off_connect]
  tlsServer.close();
  // 取消订阅tlsServer的相关事件
  tlsServer.off('connect');
  // [End tlsServer_off_connect]
  workerPort.postMessage({ type: 'The service is stopped successfully', message: 'The service is stopped successfully' });
}
