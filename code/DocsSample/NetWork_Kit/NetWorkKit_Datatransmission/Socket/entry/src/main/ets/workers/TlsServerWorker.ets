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

import  socket  from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
import { MessageEvents, util, worker } from '@kit.ArkTS';
import { TlsServerMessage } from '../connect/TlsServer';


let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

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
    default:
      break;
  }
}

function startTLSserver(message: TlsServerMessage) {


  try {
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
      address: { address: message.serverIp!, port: message.serverPort },
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ['spdy/1', 'http/1.1']
    };

    tlsServer.listen(tlsConnectOptions).then(() => {
      workerPort.postMessage({ type: 'serverStarted', status: 'TLS server started successfully' });

      tlsServer.on('connect', (client: socket.TLSSocketConnection) => {
        handleClientConnection(client);
      });
    }).catch((err: BusinessError) => {
      workerPort.postMessage({ type: 'error', message: `Failed to start TLS server: ${err.message}` });
    });
  } catch (err) {
    workerPort.postMessage({ type: 'error', message: `Error starting server: ${err.message}` });
  }
}

function handleClientConnection(client: socket.TLSSocketConnection) {
  client.on('message', (value) => {
    let messageView = bufToString(value.message);
    workerPort.postMessage({ type: 'clientMessage', message: messageView });
  });

  client.send('Hello, client!').then(() => {
    workerPort.postMessage({ type: 'messageSent', message: 'Message sent successfully' });
  }).catch((err: Error) => {
    workerPort.postMessage({ type: 'error', message: `Failed to send message: ${err.message}` });
  });

  client.close().then(() => {
    workerPort.postMessage({ type: 'connectionClosed', message: 'Connection closed successfully' });
  }).catch((err: Error) => {
    workerPort.postMessage({ type: 'error', message: `Failed to close connection: ${err.message}` });
  });
}

function bufToString(buf: ArrayBuffer): string {
  let msgArray = new Uint8Array(buf);
  let textDecoder = util.TextDecoder.create('utf-8');
  return textDecoder.decodeToString(msgArray);
}
