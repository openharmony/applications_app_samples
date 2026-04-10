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
import { convertUuidToBuffer } from '../../util';

const requestStructure: Structure = {
  version: {
    type: Number,
    size: 1,
    defaultValue: 0x05
  },
  versionMinor: {
    type: Number,
    size: 1,
    defaultValue: 0x00
  },
  packageType: {
    type: Number,
    size: 1,
    defaultValue: 0x0B
  },
  packageFlags: {
    type: Number,
    size: 1,
    defaultValue: 0x03
  },
  representation: {
    type: Number,
    size: 4,
    defaultValue: 0x00000010
  },
  //buffer length + 28
  fragLength: {
    type: Number,
    size: 2,
  },
  authLength: {
    type: Number,
    size: 2,
  },
  callId: {
    type: Number,
    size: 4,
    defaultValue: 2
  },
  maxXmitFrag: {
    type: Number,
    size: 2,
    defaultValue: 4280
  },
  maxRecvFrag: {
    type: Number,
    size: 2,
    defaultValue: 4280
  },
  assocGroup: {
    type: Number,
    size: 4
  },
  contextItems: {
    type: Number,
    size: 4,
  },
  'buffer': {
    type: buffer.Buffer
  }
};


const responseStructure: Structure = {
  version: {
    type: Number,
    size: 1
  },
  versionMinor: {
    type: Number,
    size: 1
  },
  packageType: {
    type: Number,
    size: 1
  },
  packageFlags: {
    type: Number,
    size: 1
  },
  representation: {
    type: Number,
    size: 4
  },
  fragLength: {
    type: Number,
    size: 2,
  },
  authLength: {
    type: Number,
    size: 2,
  },
  callId: {
    type: Number,
    size: 4
  },
  maxXmitFrag: {
    type: Number,
    size: 2
  },
  maxRecvFrag: {
    type: Number,
    size: 2
  },
  assocGroup: {
    type: Number,
    size: 4
  },
  scndryAddrLength: {
    type: Number,
    size: 2,
  },
  scndryAddr: {
    type: String,
    encoding: 'utf-8',
    sizeFieldName: 'scndryAddrLength',
  },
  reserved: {
    type: Number,
    size: 1
  },
  numberResult: {
    type: Number,
    size: 1
  },
  reserved2: {
    type: Number,
    size: 3
  },
  contextId: {
    type: Number,
    size: 2
  },
  arkResult: {
    type: Number,
    size: 1
  },
  arkReason: {
    type: Number,
    size: 1
  },
  transferSyntax: {
    type: buffer.Buffer,
    size: 16,
  },
  syntaxVersion: {
    type: Number,
    size: 4
  }

};

export interface BindContext {
  contextId: number,
  uuid: string,
  uuidVersion: number,
  transferUuid: string,
  transferUuidVersion: number
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
  {
    contextId: 0,
    uuid: '4b324fc8-1670-01d3-1278-5a47bf6ee188',
    uuidVersion: 3,
    transferUuid: '8a885d04-1ceb-11c9-9fe8-08002b104860',
    transferUuidVersion: 2
  },
  {
    contextId: 1,
    uuid: '4b324fc8-1670-01d3-1278-5a47bf6ee188',
    uuidVersion: 3,
    transferUuid: '71710533-beba-4937-8319-b5dbef9ccc36',
    transferUuidVersion: 1
  },
  {
    contextId: 2,
    uuid: '4b324fc8-1670-01d3-1278-5a47bf6ee188',
    uuidVersion: 3,
    transferUuid: '6cb71c2c-9812-4540-0300-000000000000',
    transferUuidVersion: 1
  }
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

export default {
  requestStructure,
  responseStructure,
  createRpcBindContext,
  rpcBindContexts,
  getContextId
};