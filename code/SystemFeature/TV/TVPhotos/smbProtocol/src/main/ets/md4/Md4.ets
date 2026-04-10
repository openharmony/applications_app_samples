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
/**
 * refer to  https://gitee.com/dove-ohos/md4
 */
const HEX_CHARS = '0123456789abcdef'.split('');
const EXTRA = [128, 32768, 8388608, -2147483648];

function bitwiseNot(value: number): number {
  return value ^ 0xffffffff;
}

export class Md4 {
  private blocks: Uint32Array;
  private buffer8: Uint8Array;
  private h0: number;
  private h1: number;
  private h2: number;
  private h3: number;
  private start: number;
  private bytes: number;
  private first: boolean;
  private hashed: boolean;
  private finalized: boolean;
  private lastByteIndex: number = 0;

  constructor() {
    const buffer = new ArrayBuffer(68);
    this.buffer8 = new Uint8Array(buffer);
    this.blocks = new Uint32Array(buffer);
    this.h0 = this.h1 = this.h2 = this.h3 = this.start = this.bytes = 0;
    this.finalized = this.hashed = false;
    this.first = true;
  }

  hex(): string {
    this.finalize();
    const h0 = this.h0;
    const h1 = this.h1;
    const h2 = this.h2;
    const h3 = this.h3;
    return HEX_CHARS[(h0 >> 4) & 0x0F] + HEX_CHARS[h0 & 0x0F] +
    HEX_CHARS[(h0 >> 12) & 0x0F] + HEX_CHARS[(h0 >> 8) & 0x0F] +
    HEX_CHARS[(h0 >> 20) & 0x0F] + HEX_CHARS[(h0 >> 16) & 0x0F] +
    HEX_CHARS[(h0 >> 28) & 0x0F] + HEX_CHARS[(h0 >> 24) & 0x0F] +
    HEX_CHARS[(h1 >> 4) & 0x0F] + HEX_CHARS[h1 & 0x0F] +
    HEX_CHARS[(h1 >> 12) & 0x0F] + HEX_CHARS[(h1 >> 8) & 0x0F] +
    HEX_CHARS[(h1 >> 20) & 0x0F] + HEX_CHARS[(h1 >> 16) & 0x0F] +
    HEX_CHARS[(h1 >> 28) & 0x0F] + HEX_CHARS[(h1 >> 24) & 0x0F] +
    HEX_CHARS[(h2 >> 4) & 0x0F] + HEX_CHARS[h2 & 0x0F] +
    HEX_CHARS[(h2 >> 12) & 0x0F] + HEX_CHARS[(h2 >> 8) & 0x0F] +
    HEX_CHARS[(h2 >> 20) & 0x0F] + HEX_CHARS[(h2 >> 16) & 0x0F] +
    HEX_CHARS[(h2 >> 28) & 0x0F] + HEX_CHARS[(h2 >> 24) & 0x0F] +
    HEX_CHARS[(h3 >> 4) & 0x0F] + HEX_CHARS[h3 & 0x0F] +
    HEX_CHARS[(h3 >> 12) & 0x0F] + HEX_CHARS[(h3 >> 8) & 0x0F] +
    HEX_CHARS[(h3 >> 20) & 0x0F] + HEX_CHARS[(h3 >> 16) & 0x0F] +
    HEX_CHARS[(h3 >> 28) & 0x0F] + HEX_CHARS[(h3 >> 24) & 0x0F];
  }

  update(data: string | ArrayBuffer): Md4 | undefined {
    if (this.finalized) {
      return;
    }
    const message = (typeof data !== 'string') ? new Uint8Array(data) : data;
    let code: number = 0;
    let index: number = 0;
    let i: number = 0;
    const length = message.length || 0;
    const blocks = this.blocks;
    const buffer8 = this.buffer8;
    while (index < length) {
      if (this.hashed) {
        this.hashed = false;
        blocks[0] = blocks[16];
        blocks[16] = blocks[1] = blocks[2] = blocks[3] =
          blocks[4] = blocks[5] = blocks[6] = blocks[7] =
            blocks[8] = blocks[9] = blocks[10] = blocks[11] =
              blocks[12] = blocks[13] = blocks[14] = blocks[15] = 0;
      }
      if (typeof message !== 'string') {
        for (i = this.start; index < length && i < 64; ++index) {
          buffer8[i++] = message[index];
        }
      } else {
        for (i = this.start; index < length && i < 64; ++index) {
          code = message.charCodeAt(index);
          if (code < 0x80) {
            buffer8[i++] = code;
          } else if (code < 0x800) {
            buffer8[i++] = 0xc0 | (code >> 6);
            buffer8[i++] = 0x80 | (code & 0x3f);
          } else if (code < 0xd800 || code >= 0xe000) {
            buffer8[i++] = 0xe0 | (code >> 12);
            buffer8[i++] = 0x80 | ((code >> 6) & 0x3f);
            buffer8[i++] = 0x80 | (code & 0x3f);
          } else {
            code = 0x10000 + (((code & 0x3ff) << 10) | (message.charCodeAt(++index) & 0x3ff));
            buffer8[i++] = 0xf0 | (code >> 18);
            buffer8[i++] = 0x80 | ((code >> 12) & 0x3f);
            buffer8[i++] = 0x80 | ((code >> 6) & 0x3f);
            buffer8[i++] = 0x80 | (code & 0x3f);
          }
        }
      }
      this.lastByteIndex = i;
      this.bytes += i - this.start;
      if (i >= 64) {
        this.start = i - 64;
        this.hash();
        this.hashed = true;
      } else {
        this.start = i;
      }
    }
    return this;
  }

  digest(): number[] {
    this.finalize();
    const h0 = this.h0;
    const h1 = this.h1;
    const h2 = this.h2;
    const h3 = this.h3;
    return [h0 & 0xFF, (h0 >> 8) & 0xFF, (h0 >> 16) & 0xFF, (h0 >> 24) & 0xFF,
      h1 & 0xFF, (h1 >> 8) & 0xFF, (h1 >> 16) & 0xFF, (h1 >> 24) & 0xFF,
      h2 & 0xFF, (h2 >> 8) & 0xFF, (h2 >> 16) & 0xFF, (h2 >> 24) & 0xFF,
      h3 & 0xFF, (h3 >> 8) & 0xFF, (h3 >> 16) & 0xFF, (h3 >> 24) & 0xFF];
  }

  arrayBuffer(): ArrayBuffer {
    this.finalize();
    const buffer = new ArrayBuffer(16);
    const blocks = new Uint32Array(buffer);
    blocks[0] = this.h0;
    blocks[1] = this.h1;
    blocks[2] = this.h2;
    blocks[3] = this.h3;
    return buffer;
  }

  private hash(): void {
    let a: number;
    let b: number;
    let c: number;
    let d: number;
    let ab: number;
    let bc: number;
    let cd: number;
    let da: number;
    const blocks = this.blocks;
    if (this.first) {
      a = blocks[0] - 1;
      a = (a << 3) | (a >>> 29);
      d = ((a & 0xefcdab89) | (bitwiseNot(a) & 0x98badcfe)) + blocks[1] + 271733878;
      d = (d << 7) | (d >>> 25);
      c = ((d & a) | (bitwiseNot(d) & 0xefcdab89)) + blocks[2] - 1732584194;
      c = (c << 11) | (c >>> 21);
      b = ((c & d) | (bitwiseNot(c) & a)) + blocks[3] - 271733879;
      b = (b << 19) | (b >>> 13);
    } else {
      a = this.h0;
      b = this.h1;
      c = this.h2;
      d = this.h3;
      a += ((b & c) | (bitwiseNot(b) & d)) + blocks[0];
      a = (a << 3) | (a >>> 29);
      d += ((a & b) | (bitwiseNot(a) & c)) + blocks[1];
      d = (d << 7) | (d >>> 25);
      c += ((d & a) | (bitwiseNot(d) & b)) + blocks[2];
      c = (c << 11) | (c >>> 21);
      b += ((c & d) | (bitwiseNot(c) & a)) + blocks[3];
      b = (b << 19) | (b >>> 13);
    }
    a += ((b & c) | (bitwiseNot(b) & d)) + blocks[4];
    a = (a << 3) | (a >>> 29);
    d += ((a & b) | (bitwiseNot(a) & c)) + blocks[5];
    d = (d << 7) | (d >>> 25);
    c += ((d & a) | (bitwiseNot(d) & b)) + blocks[6];
    c = (c << 11) | (c >>> 21);
    b += ((c & d) | (bitwiseNot(c) & a)) + blocks[7];
    b = (b << 19) | (b >>> 13);
    a += ((b & c) | (bitwiseNot(b) & d)) + blocks[8];
    a = (a << 3) | (a >>> 29);
    d += ((a & b) | (bitwiseNot(a) & c)) + blocks[9];
    d = (d << 7) | (d >>> 25);
    c += ((d & a) | (bitwiseNot(d) & b)) + blocks[10];
    c = (c << 11) | (c >>> 21);
    b += ((c & d) | (bitwiseNot(c) & a)) + blocks[11];
    b = (b << 19) | (b >>> 13);
    a += ((b & c) | (bitwiseNot(b) & d)) + blocks[12];
    a = (a << 3) | (a >>> 29);
    d += ((a & b) | (bitwiseNot(a) & c)) + blocks[13];
    d = (d << 7) | (d >>> 25);
    c += ((d & a) | (bitwiseNot(d) & b)) + blocks[14];
    c = (c << 11) | (c >>> 21);
    b += ((c & d) | (bitwiseNot(c) & a)) + blocks[15];
    b = (b << 19) | (b >>> 13);
    bc = b & c;
    a += (bc | (b & d) | (c & d)) + blocks[0] + 1518500249;
    a = (a << 3) | (a >>> 29);
    ab = a & b;
    d += (ab | (a & c) | bc) + blocks[4] + 1518500249;
    d = (d << 5) | (d >>> 27);
    da = d & a;
    c += (da | (d & b) | ab) + blocks[8] + 1518500249;
    c = (c << 9) | (c >>> 23);
    cd = c & d;
    b += (cd | (c & a) | da) + blocks[12] + 1518500249;
    b = (b << 13) | (b >>> 19);
    bc = b & c;
    a += (bc | (b & d) | cd) + blocks[1] + 1518500249;
    a = (a << 3) | (a >>> 29);
    ab = a & b;
    d += (ab | (a & c) | bc) + blocks[5] + 1518500249;
    d = (d << 5) | (d >>> 27);
    da = d & a;
    c += (da | (d & b) | ab) + blocks[9] + 1518500249;
    c = (c << 9) | (c >>> 23);
    cd = c & d;
    b += (cd | (c & a) | da) + blocks[13] + 1518500249;
    b = (b << 13) | (b >>> 19);
    bc = b & c;
    a += (bc | (b & d) | cd) + blocks[2] + 1518500249;
    a = (a << 3) | (a >>> 29);
    ab = a & b;
    d += (ab | (a & c) | bc) + blocks[6] + 1518500249;
    d = (d << 5) | (d >>> 27);
    da = d & a;
    c += (da | (d & b) | ab) + blocks[10] + 1518500249;
    c = (c << 9) | (c >>> 23);
    cd = c & d;
    b += (cd | (c & a) | da) + blocks[14] + 1518500249;
    b = (b << 13) | (b >>> 19);
    bc = b & c;
    a += (bc | (b & d) | cd) + blocks[3] + 1518500249;
    a = (a << 3) | (a >>> 29);
    ab = a & b;
    d += (ab | (a & c) | bc) + blocks[7] + 1518500249;
    d = (d << 5) | (d >>> 27);
    da = d & a;
    c += (da | (d & b) | ab) + blocks[11] + 1518500249;
    c = (c << 9) | (c >>> 23);
    b += ((c & d) | (c & a) | da) + blocks[15] + 1518500249;
    b = (b << 13) | (b >>> 19);
    bc = b ^ c;
    a += (bc ^ d) + blocks[0] + 1859775393;
    a = (a << 3) | (a >>> 29);
    d += (bc ^ a) + blocks[8] + 1859775393;
    d = (d << 9) | (d >>> 23);
    da = d ^ a;
    c += (da ^ b) + blocks[4] + 1859775393;
    c = (c << 11) | (c >>> 21);
    b += (da ^ c) + blocks[12] + 1859775393;
    b = (b << 15) | (b >>> 17);
    bc = b ^ c;
    a += (bc ^ d) + blocks[2] + 1859775393;
    a = (a << 3) | (a >>> 29);
    d += (bc ^ a) + blocks[10] + 1859775393;
    d = (d << 9) | (d >>> 23);
    da = d ^ a;
    c += (da ^ b) + blocks[6] + 1859775393;
    c = (c << 11) | (c >>> 21);
    b += (da ^ c) + blocks[14] + 1859775393;
    b = (b << 15) | (b >>> 17);
    bc = b ^ c;
    a += (bc ^ d) + blocks[1] + 1859775393;
    a = (a << 3) | (a >>> 29);
    d += (bc ^ a) + blocks[9] + 1859775393;
    d = (d << 9) | (d >>> 23);
    da = d ^ a;
    c += (da ^ b) + blocks[5] + 1859775393;
    c = (c << 11) | (c >>> 21);
    b += (da ^ c) + blocks[13] + 1859775393;
    b = (b << 15) | (b >>> 17);
    bc = b ^ c;
    a += (bc ^ d) + blocks[3] + 1859775393;
    a = (a << 3) | (a >>> 29);
    d += (bc ^ a) + blocks[11] + 1859775393;
    d = (d << 9) | (d >>> 23);
    da = d ^ a;
    c += (da ^ b) + blocks[7] + 1859775393;
    c = (c << 11) | (c >>> 21);
    b += (da ^ c) + blocks[15] + 1859775393;
    b = (b << 15) | (b >>> 17);
    if (this.first) {
      this.h0 = a + 1732584193 << 0;
      this.h1 = b - 271733879 << 0;
      this.h2 = c - 1732584194 << 0;
      this.h3 = d + 271733878 << 0;
      this.first = false;
    } else {
      this.h0 = this.h0 + a << 0;
      this.h1 = this.h1 + b << 0;
      this.h2 = this.h2 + c << 0;
      this.h3 = this.h3 + d << 0;
    }
  }

  private finalize(): void {
    if (this.finalized) {
      return;
    }
    this.finalized = true;
    const blocks = this.blocks;
    const i = this.lastByteIndex;
    blocks[i >> 2] |= EXTRA[i & 3];
    if (i >= 56) {
      if (!this.hashed) {
        this.hash();
      }
      blocks[0] = blocks[16];
      blocks[16] = blocks[1] = blocks[2] = blocks[3] =
        blocks[4] = blocks[5] = blocks[6] = blocks[7] =
          blocks[8] = blocks[9] = blocks[10] = blocks[11] =
            blocks[12] = blocks[13] = blocks[14] = blocks[15] = 0;
    }
    blocks[14] = this.bytes << 3;
    this.hash();
  }
}
