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
import HeaderFlag from './HeaderFlag';
import ProtocolResponse from '../Response';
import buffer from '@ohos.buffer';

export class ResponseBodyData {
  public buffer?: buffer.Buffer;
  public fileId?: string | buffer.Buffer;
  public endOfFile?: bigint;
  public maxReadSize?: number;
}

class ResponseBodyBuffer {
  public buffer?: buffer.Buffer;
}

class EmptyHeader implements Header {
}

export default class Response extends ProtocolResponse {
  public declare header: Header;
  public declare body: Object;
  public typeName: string;
  public data?: Object;

  constructor(header?: Header, body?: Object) {
    super(header === undefined ? new EmptyHeader() : header, body === undefined ? new ResponseBodyData() : body);
    const flags = this.header.flags;
    if (flags === undefined) {
      this.header.flags = HeaderFlag.Response;
    } else {
      this.header.flags = flags | HeaderFlag.Response;
    }
    const packetType = this.header.type;
    if (packetType === undefined) {
      throw new Error('response_packet_type_not_found');
    }
    this.typeName = Packet.getPacketTypeName(packetType);
    const packet = Packet.getPacketByPacketType(packetType) as PacketDefinition;
    const responseBody = this.body as ResponseBodyBuffer;
    const responseBuffer = responseBody.buffer;
    if (responseBuffer !== undefined && buffer.isBuffer(responseBuffer) && packet.parseResponseBuffer) {
      this.data = packet.parseResponseBuffer(responseBuffer);
    }
  }

  static parse(buf: buffer.Buffer): Response {
    const packetData = Packet.parse(buf);
    return new Response(packetData.header, packetData.body);
  }

  serialize(): buffer.Buffer {
    return Packet.serialize(this.header, this.body);
  }
}
