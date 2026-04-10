/**
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
import Header from './Header';
import Packet, { PacketDefinition } from './Packet';
import buffer from '@ohos.buffer';
import ProtocolRequest from '../Request';

class RequestBodyData {
  buffer?: buffer.Buffer;
}

class RequestBodyBuffer {
  buffer?: buffer.Buffer;
}

class EmptyHeader implements Header {
}

export default class Request extends ProtocolRequest {
  declare header: Header;
  declare body: Object;
  typeName: string;
  data?: Object;

  constructor(header?: Header, body?: Object) {
    super(header === undefined ? new EmptyHeader() : header, body === undefined ? new RequestBodyData() : body);
    const packetType = this.header.type;
    if (packetType === undefined) {
      throw new Error('request_packet_type_not_found');
    }
    this.typeName = Packet.getPacketTypeName(packetType);
    const packet = Packet.getPacketByPacketType(packetType) as PacketDefinition;
    const requestBody = this.body as RequestBodyBuffer;
    const requestBuffer = requestBody.buffer;
    if (requestBuffer !== undefined && buffer.isBuffer(requestBuffer) && packet.parseRequestBuffer) {
      this.data = packet.parseRequestBuffer(requestBuffer);
    }
  }

  static parse(buf: buffer.Buffer): Request {
    const packetData = Packet.parse(buf);
    return new Request(packetData.header, packetData.body);
  }

  serialize(): buffer.Buffer {
    return Packet.serialize(this.header, this.body);
  }
}
