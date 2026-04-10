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
import { buffer } from '@kit.ArkTS';
import Structure from '../../Structure';
import StructureField from '../../StructureField';
import { convertUuidToBuffer } from '../../util';

const requestStructure = new Structure()
  .addField('version', new StructureField(Number).setSize(1).setDefaultValue(0x05))
  .addField('versionMinor', new StructureField(Number).setSize(1).setDefaultValue(0x00))
  .addField('packageType', new StructureField(Number).setSize(1).setDefaultValue(0x0B))
  .addField('packageFlags', new StructureField(Number).setSize(1).setDefaultValue(0x03))
  .addField('representation', new StructureField(Number).setSize(4).setDefaultValue(0x00000010))
  .addField('fragLength', new StructureField(Number).setSize(2))
  .addField('authLength', new StructureField(Number).setSize(2))
  .addField('callId', new StructureField(Number).setSize(4).setDefaultValue(2))
  .addField('maxXmitFrag', new StructureField(Number).setSize(2).setDefaultValue(4280))
  .addField('maxRecvFrag', new StructureField(Number).setSize(2).setDefaultValue(4280))
  .addField('assocGroup', new StructureField(Number).setSize(4))
  .addField('contextItems', new StructureField(Number).setSize(4))
  .addField('buffer', new StructureField(buffer.Buffer));

const responseStructure = new Structure()
  .addField('version', new StructureField(Number).setSize(1))
  .addField('versionMinor', new StructureField(Number).setSize(1))
  .addField('packageType', new StructureField(Number).setSize(1))
  .addField('packageFlags', new StructureField(Number).setSize(1))
  .addField('representation', new StructureField(Number).setSize(4))
  .addField('fragLength', new StructureField(Number).setSize(2))
  .addField('authLength', new StructureField(Number).setSize(2))
  .addField('callId', new StructureField(Number).setSize(4))
  .addField('maxXmitFrag', new StructureField(Number).setSize(2))
  .addField('maxRecvFrag', new StructureField(Number).setSize(2))
  .addField('assocGroup', new StructureField(Number).setSize(4))
  .addField('scndryAddrLength', new StructureField(Number).setSize(2))
  .addField('scndryAddr', new StructureField(String).setEncoding('utf-8').setSizeFieldName('scndryAddrLength'))
  .addField('reserved', new StructureField(Number).setSize(1))
  .addField('numberResult', new StructureField(Number).setSize(1))
  .addField('reserved2', new StructureField(Number).setSize(3))
  .addField('contextId', new StructureField(Number).setSize(2))
  .addField('arkResult', new StructureField(Number).setSize(1))
  .addField('arkReason', new StructureField(Number).setSize(1))
  .addField('transferSyntax', new StructureField(buffer.Buffer).setSize(16))
  .addField('syntaxVersion', new StructureField(Number).setSize(4));

export interface BindContext {
  contextId: number,
  uuid: string,
  uuidVersion: number,
  transferUuid: string,
  transferUuidVersion: number
}

class BindContextModel implements BindContext {
  contextId: number;
  uuid: string;
  uuidVersion: number;
  transferUuid: string;
  transferUuidVersion: number;

  constructor(contextId: number, uuid: string, uuidVersion: number, transferUuid: string, transferUuidVersion: number) {
    this.contextId = contextId;
    this.uuid = uuid;
    this.uuidVersion = uuidVersion;
    this.transferUuid = transferUuid;
    this.transferUuidVersion = transferUuidVersion;
  }
}


const createRpcBindContext =
  (bindContext: BindContext): buffer.Buffer => {
    const uuidBuf = convertUuidToBuffer(bindContext.uuid)
    const transferUuidBuf = convertUuidToBuffer(bindContext.transferUuid)
    const buf = buffer.alloc(44)
    let offset = 0
    buf.writeUInt16LE(bindContext.contextId, offset)
    offset += 2
    buf.writeUInt16LE(1, offset)
    offset += 2
    uuidBuf.copy(buf, offset)
    offset += uuidBuf.length

    buf.writeUInt32LE(bindContext.uuidVersion, offset)
    offset += 4

    transferUuidBuf.copy(buf, offset)
    offset += transferUuidBuf.length
    buf.writeUInt32LE(bindContext.transferUuidVersion, offset)
    return buf
  }

export const rpcBindContexts: BindContext[] = [
  new BindContextModel(0, '4b324fc8-1670-01d3-1278-5a47bf6ee188', 3, '8a885d04-1ceb-11c9-9fe8-08002b104860', 2),
  new BindContextModel(1, '4b324fc8-1670-01d3-1278-5a47bf6ee188', 3, '71710533-beba-4937-8319-b5dbef9ccc36', 1),
  new BindContextModel(2, '4b324fc8-1670-01d3-1278-5a47bf6ee188', 3, '6cb71c2c-9812-4540-0300-000000000000', 1)
]

const getContextId = (transferSyntaxBuf: buffer.Buffer): number => {
  let context = rpcBindContexts.find((value) => {
    return convertUuidToBuffer(value.transferUuid).equals(transferSyntaxBuf)
  })
  if (context) {
    return context.contextId
  } else {
    throw new Error(`Invalid transferSyntaxBuf: ${JSON.stringify(transferSyntaxBuf)}`);
  }
}

class RpcBindPacket {
  public requestStructure: Structure = requestStructure;
  public responseStructure: Structure = responseStructure;
  public createRpcBindContext = createRpcBindContext;
  public rpcBindContexts = rpcBindContexts;
  public getContextId = getContextId;
}

export default new RpcBindPacket();
