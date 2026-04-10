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
import buffer from '@ohos.buffer';
import flags from './flags';
import hash from './hash';

const NTLMSIGNATURE = 'NTLMSSP\0';
const DEFAULT_WORKSTATION_NAME = 'default'

const TAG = 'SMB_NTLM_util'

// 定义 Type2Message 的类型
export interface Type2Message {
  flags: number;
  flagBuf: buffer.Buffer;
  encoding: 'ascii' | 'ucs2';
  version: number;
  challenge: buffer.Buffer;
  targetName: string;
  targetInfo?: TargetInfo;
}

// 定义 TargetInfo 的类型
export interface TargetInfo {
  parsed: Record<string, string>;
  buffer: buffer.Buffer;
}

export function createType1Message(workstation?: string, target?: string): buffer.Buffer {
  let dataPos = 32;
  let pos = 0;

  workstation = workstation === undefined ? DEFAULT_WORKSTATION_NAME : workstation;
  target = target === undefined ? '' : target;
  const workstationLength = buffer.byteLength(workstation, 'ascii');
  const targetLength = buffer.byteLength(target, 'ascii');

  const buf = buffer.alloc(dataPos + workstationLength + targetLength);
  // Signature
  buf.write(NTLMSIGNATURE, pos, NTLMSIGNATURE.length, 'ascii');
  pos += NTLMSIGNATURE.length;

  // Message type
  buf.writeUInt32LE(1, pos);
  pos += 4;

  // Flags
  buf.writeUInt32LE(
    flags.NTLMFLAG_NEGOTIATE_OEM |
    flags.NTLMFLAG_REQUEST_TARGET |
    flags.NTLMFLAG_NEGOTIATE_NTLM_KEY |
    flags.NTLMFLAG_NEGOTIATE_NTLM2_KEY |
    flags.NTLMFLAG_NEGOTIATE_ALWAYS_SIGN,
    pos
  );
  pos += 4;

  // Domain security buffer
  buf.writeUInt16LE(target.length, pos);
  pos += 2;
  buf.writeUInt16LE(target.length, pos);
  pos += 2;
  buf.writeUInt32LE(target.length === 0 ? 0 : dataPos, pos);
  pos += 4;

  if (target.length > 0) {
    dataPos += buf.write(target, dataPos, target.length, 'ascii');
  }

  // Workstation security buffer
  buf.writeUInt16LE(workstation.length, pos);
  pos += 2;
  buf.writeUInt16LE(workstation.length, pos);
  pos += 2;
  buf.writeUInt32LE(workstation.length === 0 ? 0 : dataPos, pos);
  pos += 4;

  if (workstation.length > 0) {
    dataPos += buf.write(workstation, dataPos, workstation.length, 'ascii');
  }
  return buf
}

export function decodeType2Message(buf: buffer.Buffer): Type2Message {
  const obj: Type2Message = {
    flags: 0,
    flagBuf: buffer.alloc(4),
    encoding: 'ascii',
    version: 1,
    challenge: buffer.alloc(0),
    targetName: '',
  };

  // Check signature
  if (buf.toString('ascii', 0, NTLMSIGNATURE.length) !== NTLMSIGNATURE) {
    throw new Error('Invalid message signature');
  }

  // Check message type
  if (buf.readUInt32LE(NTLMSIGNATURE.length) !== 2) {
    throw new Error('Invalid message type (no type 2)');
  }

  // Read flags
  obj.flags = buf.readUInt32LE(20);
  buf.copy(obj.flagBuf, 0, 20, 23)
  obj.encoding = (obj.flags & flags.NTLMFLAG_NEGOTIATE_OEM) ? 'ascii' : 'ucs2';

  obj.version = (obj.flags & flags.NTLMFLAG_NEGOTIATE_NTLM2_KEY) ? 2 : 1;

  obj.challenge = buf.subarray(24, 32);

  // Read target name
  obj.targetName = (() => {
    const length = buf.readUInt16LE(12);
    // Skipping allocated space
    const offset = buf.readUInt32LE(16);

    if (length === 0) {
      return '';
    }

    if ((offset + length) > buf.length || offset < 32) {
      throw new Error('Bad type 2 message');
    }

    return buf.toString(obj.encoding, offset, offset + length);
  })();

  // Read target info
  if (obj.flags & flags.NTLMFLAG_NEGOTIATE_TARGET_INFO) {
    obj.targetInfo = (() => {
      const info: Record<string, string> = {};

      const length = buf.readUInt16LE(40);
      // Skipping allocated space
      const offset = buf.readUInt32LE(44);

      const targetInfoBuffer = buffer.alloc(length);
      buf.copy(targetInfoBuffer, 0, offset, offset + length);

      if (length === 0) {
        const emptyTargetInfo: TargetInfo = { parsed: info, buffer: targetInfoBuffer };
        return emptyTargetInfo;
      }

      if ((offset + length) > buf.length || offset < 32) {
        throw new Error('Bad type 2 message');
      }

      let pos = offset;

      while (pos < (offset + length)) {
        const blockType = buf.readUInt16LE(pos);
        pos += 2;
        const blockLength = buf.readUInt16LE(pos);
        pos += 2;

        if (blockType === 0) {
          // Reached the terminator subblock
          break;
        }

        let blockTypeStr: string;

        switch (blockType) {
          case 1:
            blockTypeStr = 'SERVER';
            break;
          case 2:
            blockTypeStr = 'DOMAIN';
            break;
          case 3:
            blockTypeStr = 'FQDN';
            break;
          case 4:
            blockTypeStr = 'DNS';
            break;
          case 5:
            blockTypeStr = 'PARENT_DNS';
            break;
          default:
            blockTypeStr = '';
            break;
        }

        if (blockTypeStr) {
          info[blockTypeStr] = buf.toString('ucs2', pos, pos + blockLength);
        }

        pos += blockLength;
      }

      const targetInfo: TargetInfo = {
        parsed: info,
        buffer: targetInfoBuffer
      };
      return targetInfo;
    })();
  }

  return obj;
}

function unsingArray(array: number[]): number[] {
  return array.filter((value) => {
    if (value < 0) {
      return 256 + value
    } else {
      return value
    }
  })
}

function getStringBuffer(str: string, encoding: buffer.BufferEncoding): buffer.Buffer {
  return buffer.from(str, encoding)
}

export function createType3Message(type2Message: Type2Message, username: string, password: string, workstation?: string,
  target?: string): buffer.Buffer {

  let dataPos = 52;
  const buf = buffer.alloc(1024);

  const workstationName = workstation === undefined ? DEFAULT_WORKSTATION_NAME : workstation;
  const targetName = target === undefined ? type2Message.targetName : target;

  // Signature
  buf.write(NTLMSIGNATURE, 0, NTLMSIGNATURE.length, 'ascii');

  // Message type
  buf.writeUInt32LE(3, 8);

  if (type2Message.version === 2) {
    dataPos = 64;
    const ntlmHash = hash.createNTLMHash(password);
    const clientChallenge1 = hash.createPseudoRandomValue(8);
    const lmv2 = hash.createLMv2Response(type2Message, username, ntlmHash, clientChallenge1);
    const clientChallenge2 = hash.createPseudoRandomValue(8);
    const ntlmv2 = hash.createNTLMv2Response(type2Message, username, ntlmHash, clientChallenge2);

    // LMv2 security buffer
    buf.writeUInt16LE(lmv2.length, 12);
    buf.writeUInt16LE(lmv2.length, 14);
    buf.writeUInt32LE(dataPos, 16);

    lmv2.copy(buf, dataPos);
    dataPos += lmv2.length;

    // NTLMv2 security buffer
    buf.writeUInt16LE(ntlmv2.length, 20);
    buf.writeUInt16LE(ntlmv2.length, 22);
    buf.writeUInt32LE(dataPos, 24);

    ntlmv2.copy(buf, dataPos);
    dataPos += ntlmv2.length;
  } else {
    const lmHash = hash.createLMHash(password);
    const ntlmHash = hash.createNTLMHash(password);
    const lm = hash.createLMResponse(type2Message.challenge, lmHash);
    const ntlm = hash.createNTLMResponse(type2Message.challenge, ntlmHash);

    // LM security buffer
    buf.writeUInt16LE(lm.length, 12);
    buf.writeUInt16LE(lm.length, 14);
    buf.writeUInt32LE(dataPos, 16);

    lm.copy(buf, dataPos);
    dataPos += lm.length;

    // NTLM security buffer
    buf.writeUInt16LE(ntlm.length, 20);
    buf.writeUInt16LE(ntlm.length, 22);
    buf.writeUInt32LE(dataPos, 24);

    ntlm.copy(buf, dataPos);
    dataPos += ntlm.length;
  }

  // Target name security buffer

  buf.writeUInt16LE(buffer.byteLength(targetName, type2Message.encoding), 28);
  buf.writeUInt16LE(buffer.byteLength(targetName, type2Message.encoding), 30);
  buf.writeUInt32LE(dataPos, 32);

  getStringBuffer(targetName, type2Message.encoding).copy(buf, dataPos)
  dataPos += buffer.byteLength(targetName, type2Message.encoding)
  // User name security buffer
  buf.writeUInt16LE(buffer.byteLength(username, type2Message.encoding), 36);
  buf.writeUInt16LE(buffer.byteLength(username, type2Message.encoding), 38);
  buf.writeUInt32LE(dataPos, 40);

  getStringBuffer(username, type2Message.encoding).copy(buf, dataPos)
  dataPos += buffer.byteLength(username, type2Message.encoding)
  // Workstation name security buffer
  buf.writeUInt16LE(buffer.byteLength(workstationName, type2Message.encoding), 44);
  buf.writeUInt16LE(buffer.byteLength(workstationName, type2Message.encoding), 46);
  buf.writeUInt32LE(dataPos, 48);

  getStringBuffer(workstationName, type2Message.encoding).copy(buf, dataPos)
  dataPos += buffer.byteLength(workstationName, type2Message.encoding)
  if (type2Message.version === 2) {
    // Session key security buffer
    buf.writeUInt16LE(0, 52);
    buf.writeUInt16LE(0, 54);
    buf.writeUInt32LE(0, 56);

    // Flags
    buf.writeUInt32LE(type2Message.flags, 60);
  }
  return buf
}
