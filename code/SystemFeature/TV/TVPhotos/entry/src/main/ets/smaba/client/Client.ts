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

interface Client {
  on(event: "error", callback: (error: Error) => void): this;

  on(event: "changeNotify", callback: (response: Smb2Response) => void): this;

  once(event: "error", callback: (error: Error) => void): this;

  once(event: "changeNotify", callback: (response: Smb2Response) => void): this;
}

class Client extends EventEmitter {
  _id = smbUtil.generateClientId()
  socket: socket.TCPSocket;
  nextMessageId: bigint = BigInt(0);
  responseRestChunk: buffer.Buffer;
  responseMap = new Map<bigint, Smb2Response>();
  responseCallbackMap = new Map<bigint, (response: Smb2Response) => void>();
  connected: boolean = false;
  port: number = 445;
  connectTimeout: number = 2 * 1000;
  connectTimeoutId: number;
  requestTimeout: number = 2 * 1000;
  requestTimeoutIdMap = new Map<bigint, number>();
  sessions: Session[] = [];

  constructor(public host: string, public options: Options = {}) {
    super()
    if (typeof this.options.port === "number") {
      this.port = this.options.port;
    }
    if (typeof this.options.connectTimeout === "number") {
      this.connectTimeout = this.options.connectTimeout;
    }
    if (typeof this.options.requestTimeout === "number") {
      this.requestTimeout = this.options.requestTimeout;
    }
  }

  async connect() {
    if (this.connected) {
      return;
    }
    this.socket = socket.constructTCPSocketInstance();
    this.socket.on("message", this.onData);
    this.socket.setExtraOptions({ keepAlive: true });
    this.socket.on("error", this.onError)
    this.socket.on("close", this.onClose);
    this.socket.setExtraOptions({
      TCPNoDelay: true,
      receiveBufferSize: 8388608,
      sendBufferSize: 8388608
    })
    const connectPromise = withTimeout<void>(new Promise<void>((resolve, reject) => {
      this.socket.on("connect", () => {
        resolve();
      });
      this.socket.on("error", (err) => {
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
      throw err;
    }
  }

  createRequest(header: Smb2Header = {}, body: any = {}) {
    const messageId = this.nextMessageId++;
    return new Smb2Request({ messageId, clientId: this._id, ...header }, body);
  }

  async request(header?: Smb2Header, body?: any) {
    const request = this.createRequest(header, body);
    return await this.send(request);
  }

  async send(request: Smb2Request) {
    console.info(TAG,
      `do send request = ${JSON.stringify(request, smbUtil.bigIntReplacer)}  connected = ${this.connected}`)
    if (!this.connected) {
      throw new Error("not_connected");
    }
    const buffer = request.serialize();
    this.socket.send({ data: buffer.buffer });
    const messageId = request.header.messageId;
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
        (this.responseMap.get(messageId));
        this.responseMap.delete(messageId);
      } else if (!this.responseCallbackMap.has(messageId)) {

        this.responseCallbackMap.set(messageId, finishRequest);
      }
    }), this.requestTimeout, `requset ${request.header.type}`)
    const response = await sendPromise;
    return response;
  }

  onData = (info: socket.SocketMessageInfo) => {
    let buf: buffer.Buffer;
    if (this.responseRestChunk && this.responseRestChunk.length > 0) {
      const b = buffer.from(info.message);
      buf = buffer.concat([this.responseRestChunk, b]);
    } else {
      buf = buffer.from(info.message);
    }
    this.responseRestChunk = undefined;
    const { chunks, restChunk } = Packet.getChunks(buf);
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
      this.emit("changeNotify", response);
    }
    const messageId = response.header.messageId;
    if (this.responseCallbackMap.has(messageId)) {
      this.responseCallbackMap.get(messageId)(response);
      this.responseCallbackMap.delete(messageId);
    } else {
      this.responseMap.set(messageId, response);
    }
  }

  onError = (err: Error) => {
    this.emit("error", err);
  }

  onClose = () => {
    this.connected = false;
    this.emit("error", new Error("client_closed"));
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
    this.socket.off("message", this.onData);
    this.socket.off("error", this.onError);
    this.socket.off("close", this.onClose);
    this.socket.close();
    delete this.socket;
  }

  private registerSession(session: Session) {
    console.info(TAG, `do registerSession`)
    session.once("authenticate", () => this.sessions.push(session))
      .once("logoff", () => this.sessions.splice(this.sessions.indexOf(session), 1));
  }

  async close() {
    if (!this.connected) {
      return;
    }
    await Promise.all(this.sessions.map(x => x.logoff()));
    this.destroySocket();
    this.connected = false;
  }
}

export default Client;