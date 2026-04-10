/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 
import buffer from '@ohos.buffer';
import socket from '@ohos.net.socket';
import Session, { AuthenticateOptions } from './Session';
import { Packet, Smb2Header, Smb2PacketType, Smb2Request, Smb2Response, Smb2StatusCode, smbUtil } from 'smbProtocol';
import { BusinessError } from '@kit.BasicServicesKit';
import EventEmitter from './EventEmitter';
import { sleep, withTimeout } from './utils/TimeoutPromise';

const TAG = 'SMB_client'

export interface Options {
  port?: number;
  connectTimeout?: number;
  requestTimeout?: number;
}

class ClientHeaderOptions implements Smb2Header {
  protocolId?: string;
  structureSize?: number;
  creditCharge?: number;
  status?: number;
  type?: Smb2PacketType;
  credit?: number;
  flags?: number;
  nextCommand?: number;
  messageId?: bigint;
  clientId?: string;
  treeId?: number;
  sessionId?: string;
  signature?: number;
}

class ClientRequestBody {
}

class Client extends EventEmitter {
  public _id = smbUtil.generateClientId()
  public host: string;
  public options: Options;
  public socket: socket.TCPSocket = socket.constructTCPSocketInstance();
  public nextMessageId: bigint = BigInt(0);
  public responseRestChunk: buffer.Buffer = buffer.alloc(0);
  public responseMap = new Map<bigint, Smb2Response>();
  public responseCallbackMap = new Map<bigint, (response: Smb2Response) => void>();
  public connected: boolean = false;
  public port: number = 445;
  public connectTimeout: number = 2 * 1000;
  public connectTimeoutId: number = 0;
  public requestTimeout: number = 2 * 1000;
  public requestTimeoutIdMap = new Map<bigint, number>();
  public sessions: Session[] = [];

  constructor(host: string, options: Options = {}) {
    super()
    this.host = host
    this.options = options
    if (typeof this.options.port === 'number') {
      this.port = this.options.port;
    }
    if (typeof this.options.connectTimeout === 'number') {
      this.connectTimeout = this.options.connectTimeout;
    }
    if (typeof this.options.requestTimeout === 'number') {
      this.requestTimeout = this.options.requestTimeout;
    }
  }

  async connect() {
    if (this.connected) {
      return;
    }
    this.socket = socket.constructTCPSocketInstance();
    this.socket.on('message', this.onData);
    this.socket.setExtraOptions({ keepAlive: true });
    this.socket.on('error', this.onError)
    this.socket.on('close', this.onClose);
    this.socket.setExtraOptions({
      TCPNoDelay: true,
      receiveBufferSize: 8388608,
      sendBufferSize: 8388608
    })
    const connectPromise = withTimeout<void>(new Promise<void>((resolve, reject) => {
      this.socket.on('connect', () => {
        resolve();
      });
      this.socket.on('error', (err) => {
        reject(err);
      }); //?
      this.socket.connect({
        timeout: this.connectTimeout,
        address: { port: this.port, address: this.host }
      }).then(() => {
      }).catch((error: BusinessError) => {
        reject(error)
      })
    }), this.connectTimeout, `connect to ${this.host}`)
    try {
      await connectPromise;
      this.connected = true;
    } catch (err) {
      this.destroySocket();
      throw err instanceof Error ? err : new Error(JSON.stringify(err));
    }
  }

  createRequest(header?: Smb2Header, body: Object = new ClientRequestBody()) {
    const messageId = this.nextMessageId++;
    return new Smb2Request(this.createHeader(messageId, header), body);
  }

  async request(header?: Smb2Header, body: Object = new ClientRequestBody()) {
    const request = this.createRequest(header, body);
    return await this.send(request);
  }

  async send(request: Smb2Request) {
    console.info(TAG,
      `do send request = ${JSON.stringify(request, smbUtil.bigIntReplacer)}  connected = ${this.connected}`)
    if (!this.connected) {
      throw new Error('not_connected');
    }
    const buffer = request.serialize();
    this.socket.send({ data: buffer.buffer });
    const messageId = request.header.messageId;
    if (messageId === undefined) {
      throw new Error('message_id_not_found');
    }
    const sendPromise = withTimeout<Smb2Response>(new Promise<Smb2Response>((resolve, reject) => {
      const finishRequest = (response: Smb2Response) => {
        response.request = request;
        if (response.header.status !== Smb2StatusCode.Success &&
          response.header.status !== Smb2StatusCode.Pending &&
          response.header.status !== Smb2StatusCode.MoreProcessingRequired &&
          response.header.status !== Smb2StatusCode.FileClosed) {
          reject({ code: response.header.status, message: `response fail` } as BusinessError);
        } else {
          resolve(response);
        }
      };
      if (this.responseMap.has(messageId)) {
        const response = this.responseMap.get(messageId);
        this.responseMap.delete(messageId);
        if (response) {
          finishRequest(response);
        }
      } else if (!this.responseCallbackMap.has(messageId)) {

        this.responseCallbackMap.set(messageId, finishRequest);
      }
    }), this.requestTimeout, `requset ${request.header.type}`)
    const response = await sendPromise;
    return response;
  }

  public onData = (info: socket.SocketMessageInfo) => {
    let buf: buffer.Buffer;
    if (this.responseRestChunk && this.responseRestChunk.length > 0) {
      const b = buffer.from(info.message);
      buf = buffer.concat([this.responseRestChunk, b]);
    } else {
      buf = buffer.from(info.message);
    }
    this.responseRestChunk = buffer.alloc(0);
    const packetChunks = Packet.getChunks(buf);
    const chunks = packetChunks.chunks;
    const restChunk = packetChunks.restChunk;
    this.responseRestChunk = restChunk;
    for (const chunk of chunks) {
      const response = Smb2Response.parse(chunk);
      this.onResponse(response);
    }
  }

  async onResponse(response: Smb2Response) {
    console.info(TAG, 'on response = ' + JSON.stringify(response, smbUtil.bigIntReplacer))
    if (response.header.type === Smb2PacketType.InputOutputControl && response.header.status === 259) {
      await sleep(200)
    }
    if (response.header.type === Smb2PacketType.ChangeNotify && response.header.status === Smb2StatusCode.Success) {
      this.emit('changeNotify', response);
    }
    const messageId = response.header.messageId;
    if (messageId === undefined) {
      throw new Error('response_message_id_not_found');
    }
    if (this.responseCallbackMap.has(messageId)) {
      const callback = this.responseCallbackMap.get(messageId);
      if (callback) {
        callback(response);
      }
      this.responseCallbackMap.delete(messageId);
    } else {
      this.responseMap.set(messageId, response);
    }
  }

  public onError = (err: Error) => {
    this.emit('error', err);
  }

  public onClose = () => {
    this.connected = false;
    this.emit('error', new Error('client_closed'));
  }

  async echo() {
    return await this.request({
      type: Smb2PacketType.Echo
    });
  }

  async authenticate(options: AuthenticateOptions) {
    console.info(TAG, `do auth ${JSON.stringify(options)}`)
    if (!this.connected) {
      await this.connect();
    }
    const session = new Session(this);
    this.registerSession(session);
    await session.authenticate(options);
    return session;
  }

  private destroySocket() {
    this.socket.off('message', this.onData);
    this.socket.off('error', this.onError);
    this.socket.off('close', this.onClose);
    this.socket.close();
  }

  private registerSession(session: Session): void {
    console.info(TAG, `do registerSession`)
    session.once('authenticate', (): void => {
      this.sessions.push(session)
    })
    session.once('logoff', (): void => {
      this.sessions.splice(this.sessions.indexOf(session), 1)
    });
  }

  async close() {
    if (!this.connected) {
      return;
    }
    await Promise.all(this.sessions.map((session: Session): Promise<void> => session.logoff()));
    this.destroySocket();
    this.connected = false;
  }

  private createHeader(messageId: bigint, header?: Smb2Header): Smb2Header {
    const requestHeader = new ClientHeaderOptions()
    requestHeader.messageId = messageId
    requestHeader.clientId = this._id
    if (header) {
      requestHeader.protocolId = header.protocolId
      requestHeader.structureSize = header.structureSize
      requestHeader.creditCharge = header.creditCharge
      requestHeader.status = header.status
      requestHeader.type = header.type
      requestHeader.credit = header.credit
      requestHeader.flags = header.flags
      requestHeader.nextCommand = header.nextCommand
      requestHeader.messageId = header.messageId ?? messageId
      requestHeader.clientId = header.clientId ?? this._id
      requestHeader.treeId = header.treeId
      requestHeader.sessionId = header.sessionId
      requestHeader.signature = header.signature
    }
    return requestHeader
  }
}

export default Client;
