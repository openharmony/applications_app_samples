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
import { SocketType } from './Socket';
import Socket from './Socket';

import TcpSocket from '../socket/TcpSocket';
import TlsSocket from '../socket/TlsSocket';
import UdpSocket from '../socket/UdpSocket';

/**
 * 创建Socket对象的工厂
 */
export default class SocketFactory {
  /**
   * 根据协议类型创建对应的Socket
   * @param socketType
   */
  public static createSocket(socketType: SocketType): Socket {
    switch (socketType) {
      case SocketType.UDP:
        return new UdpSocket();
      case SocketType.TCP:
        return new TcpSocket();
      case SocketType.TLS:
        return new TlsSocket();
    }
  }
}
