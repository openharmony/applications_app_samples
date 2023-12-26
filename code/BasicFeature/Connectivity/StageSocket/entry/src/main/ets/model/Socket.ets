/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

/**
 * 协议类型
 */
export enum SocketType {
  UDP,
  TCP,
  TLS
}

/**
 * TCP TLS UDP 共同实现的接口
 */
export default interface Socket {
  createSocket(localIp: string, port: number): Promise<boolean>;

  connectSocket(address: string, port: number): Promise<boolean>;

  closeSocket(): Promise<void>;

  sendData(data: string, address?: string, port?: number): Promise<void>;

  isConnected(): Promise<boolean>;

  setOnMessageReceivedListener(callback: (buffer: ArrayBuffer) => void): void;

  setOnCloseListener(callback: () => void): void;
}
