/**
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
import buffer from '@ohos.buffer';
import CryptoJS from '@ohos/crypto-js';
import { md4 } from '../md4/md4';
import { Type2Message } from './ntlm';

const TAG = 'NTLM_hash'

class HashUtil {
  createLMResponse(challenge: buffer.Buffer, lmhash: buffer.Buffer): buffer.Buffer {
    const buf: buffer.Buffer = buffer.alloc(24);
    const pwBuffer: buffer.Buffer = buffer.alloc(21).fill(0);

    lmhash.copy(pwBuffer);

    const part1 = this.calculateDES(pwBuffer.subarray(0, 7), challenge);
    const part2 = this.calculateDES(pwBuffer.subarray(7, 14), challenge);
    const part3 = this.calculateDES(pwBuffer.subarray(14), challenge);

    // 使用索引操作替代 set 方法
    for (let i = 0; i < 8; i++) {
      buf[i] = part1[i];
      buf[i + 8] = part2[i];
      buf[i + 16] = part3[i];
    }

    return buf;
  }

  createLMHash(password: string): buffer.Buffer {
    const buf: buffer.Buffer = buffer.alloc(16);
    const pwBuffer: buffer.Buffer = buffer.alloc(14);
    const magicKey: buffer.Buffer = buffer.from('KGS!@#$%', 'ascii');

    if (password.length > 14) {
      buf.fill(0);
      return buf;
    }

    pwBuffer.fill(0);
    pwBuffer.write(password.toUpperCase(), 0, password.length, 'ascii');

    const part1 = this.calculateDES(pwBuffer.subarray(0, 7), magicKey);
    const part2 = this.calculateDES(pwBuffer.subarray(7), magicKey);

    return buffer.concat([part1, part2]);
  }

  calculateDES(key: buffer.Buffer, message: buffer.Buffer): buffer.Buffer {
    const desKey: buffer.Buffer = buffer.alloc(8);

    desKey[0] = key[0] & 0xFE;
    desKey[1] = ((key[0] << 7) & 0xFF) | (key[1] >> 1);
    desKey[2] = ((key[1] << 6) & 0xFF) | (key[2] >> 2);
    desKey[3] = ((key[2] << 5) & 0xFF) | (key[3] >> 3);
    desKey[4] = ((key[3] << 4) & 0xFF) | (key[4] >> 4);
    desKey[5] = ((key[4] << 3) & 0xFF) | (key[5] >> 5);
    desKey[6] = ((key[5] << 2) & 0xFF) | (key[6] >> 6);
    desKey[7] = (key[6] << 1) & 0xFF;

    for (let i = 0; i < 8; i++) {
      let parity = 0;

      for (let j = 1; j < 8; j++) {
        parity += (desKey[i] >> j) % 2;
      }

      desKey[i] |= (parity % 2) === 0 ? 1 : 0;
    }

    // 使用 CryptoJS 实现 DES 加密
    const keyHex = CryptoJS.enc.Hex.parse(desKey.toString('hex'));
    const messageHex = CryptoJS.enc.Hex.parse(message.toString('hex'));
    const encrypted = CryptoJS.DES.encrypt(messageHex, keyHex, {
      mode: CryptoJS.mode.ECB,
      padding: CryptoJS.pad.NoPadding
    });
    return buffer.from(encrypted.ciphertext.toString(CryptoJS.enc.Hex), 'hex');
  }

  createNTLMResponse(challenge: buffer.Buffer, ntlmhash: buffer.Buffer): buffer.Buffer {
    const buf: buffer.Buffer = buffer.alloc(24);
    const ntlmBuffer: buffer.Buffer = buffer.alloc(21).fill(0);

    ntlmhash.copy(ntlmBuffer);

    const part1 = this.calculateDES(ntlmBuffer.subarray(0, 7), challenge);
    const part2 = this.calculateDES(ntlmBuffer.subarray(7, 14), challenge);
    const part3 = this.calculateDES(ntlmBuffer.subarray(14), challenge);

    // 使用索引操作替代 set 方法
    for (let i = 0; i < 8; i++) {
      buf[i] = part1[i];
      buf[i + 8] = part2[i];
      buf[i + 16] = part3[i];
    }

    return buf;
  }

  createNTLMHash(password: string): buffer.Buffer {
    const ucs2 = buffer.from(password, "ucs2");
    const md = new md4();
    md.update(ucs2.buffer);
    return buffer.from(md.hex(), 'hex');
  }


  createNTLMv2Hash(ntlmhash: buffer.Buffer, username: string, authTargetName: string): buffer.Buffer {
    let hmac = CryptoJS.HmacMD5(CryptoJS.lib.WordArray.create(buffer.from(username + authTargetName, 'utf16le').buffer),
      CryptoJS.lib.WordArray.create(ntlmhash.buffer))

    return buffer.from(hmac.toString(CryptoJS.enc.Hex), 'hex')
  }

  createLMv2Response(type2message: Type2Message, username: string, ntlmhash: buffer.Buffer,
    clientChallenge: buffer.Buffer): buffer.Buffer {
    let ntlm2hash = this.createNTLMv2Hash(ntlmhash, username, type2message.targetName)
    console.warn(TAG, `hmacDigest = ${JSON.stringify(ntlm2hash)}`)

    let hmac =
      CryptoJS.HmacMD5(CryptoJS.lib.WordArray.create(buffer.concat([type2message.challenge, clientChallenge]).buffer),
        CryptoJS.lib.WordArray.create(ntlm2hash.buffer))

    let hmacResult = buffer.from(hmac.toString(CryptoJS.enc.Hex), 'hex')
    console.warn(TAG, `hmacResult = ${JSON.stringify(hmacResult)}`)

    const buf: buffer.Buffer = buffer.alloc(24);

    hmacResult.copy(buf, 0)
    clientChallenge.copy(buf, 16)
    console.warn(TAG, `buf = ${JSON.stringify(buf)}`)
    return buf
  }

  createNTLMv2Resp(type2message: Type2Message, username: string, ntlmhash: buffer.Buffer,
    clientChallenge: buffer.Buffer): buffer.Buffer {
    const targetInfoLength = type2message.targetInfo?.buffer.length ?? 0;
    const clientData = buffer.alloc(28 + targetInfoLength + 4);
    clientData.writeUInt32BE(0x01010000, 0)
    clientData.writeUInt32BE(0x00000000, 4)

    const timestamp: bigint = BigInt(133872737292360000)
    console.warn(TAG, 'timestamp = ' + timestamp)
    clientData.writeBigInt64LE(timestamp, 8)
    clientChallenge.copy(clientData, 16)
    clientData.writeUInt32BE(0x00000000, 24)
    type2message.targetInfo?.buffer.copy(clientData, 28)
    clientData.writeUInt32BE(0x00000000, 28 + targetInfoLength)
    console.warn(TAG, 'clientData = ' + JSON.stringify(clientData))

    let responseKey = this.createNTLMv2Hash(ntlmhash, username, type2message.targetName)

    console.warn(TAG, 'responseKey = ' + JSON.stringify(responseKey))
    let hmac =
      CryptoJS.HmacMD5(CryptoJS.lib.WordArray.create(buffer.concat([type2message.challenge, clientData]).buffer),
        CryptoJS.lib.WordArray.create(responseKey.buffer))
    let mac = buffer.from(hmac.toString(CryptoJS.enc.Hex), 'hex')
    console.warn(TAG, 'mac = ' + JSON.stringify(mac))
    let ret = buffer.alloc(mac.length + clientData.length)
    mac.copy(ret, 0)
    clientData.copy(ret, mac.length)
    console.warn(TAG, 'ret = ' + JSON.stringify(ret))
    return ret
  }

  createNTLMv2Response(type2message: Type2Message, username: string, ntlmhash: buffer.Buffer,
    clientChallenge: buffer.Buffer): buffer.Buffer {
    const targetInfoLength = type2message.targetInfo?.buffer.length ?? 0;
    const clientData = buffer.alloc(28 + targetInfoLength + 4);
    clientData.writeUInt32BE(0x01010000, 0)
    clientData.writeUInt32BE(0x00000000, 4)

    const timestamp = BigInt((Date.now() + 11644473600000) * 10000);
    console.warn(TAG, 'timestamp = ' + timestamp)
    clientData.writeBigInt64LE(timestamp, 8)
    clientChallenge.copy(clientData, 16)
    clientData.writeUInt32BE(0x00000000, 24)
    type2message.targetInfo?.buffer.copy(clientData, 28)
    clientData.writeUInt32BE(0x00000000, 28 + targetInfoLength)
    console.warn(TAG, 'clientData = ' + JSON.stringify(clientData))

    let responseKey = this.createNTLMv2Hash(ntlmhash, username, type2message.targetName)

    console.warn(TAG, 'responseKey = ' + JSON.stringify(responseKey))
    let hmac =
      CryptoJS.HmacMD5(CryptoJS.lib.WordArray.create(buffer.concat([type2message.challenge, clientData]).buffer),
        CryptoJS.lib.WordArray.create(responseKey.buffer))
    let mac = buffer.from(hmac.toString(CryptoJS.enc.Hex), 'hex')
    console.warn(TAG, 'mac = ' + JSON.stringify(mac))
    let ret = buffer.alloc(mac.length + clientData.length)
    mac.copy(ret, 0)
    clientData.copy(ret, mac.length)
    console.warn(TAG, 'ret = ' + JSON.stringify(ret))
    return ret
  }

  createPseudoRandomValue(length: number): buffer.Buffer {
    let values: number[] = [];
    while (values.length < length) {
      values.push(Math.floor(Math.random() * 255));
    }
    return buffer.from(values);
  }
}

let hash = new HashUtil()

export default hash