/*
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

// [Start specify_parameter_generate_rsa_keypair_sync]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

// RSA公钥密钥参数生成函数
function genRsaPubKeySpec(nIn: bigint, eIn: bigint): cryptoFramework.RSAPubKeySpec {
  let rsaCommSpec: cryptoFramework.RSACommonParamsSpec = {
    n: nIn,
    algName: 'RSA',
    specType: cryptoFramework.AsyKeySpecType.COMMON_PARAMS_SPEC
  };
  let rsaPubKeySpec: cryptoFramework.RSAPubKeySpec = {
    params: rsaCommSpec,
    pk: eIn,
    algName: 'RSA',
    specType: cryptoFramework.AsyKeySpecType.PUBLIC_KEY_SPEC
  };
  return rsaPubKeySpec;
}

// 根据密钥参数构造RSA公钥规范对象
function genRsa2048PubKeySpec() {
  let nIn =
    BigInt('0x9260d0750ae117eee55c3f3deaba74917521a262ee76007cdf8a56755ad73a1598a1408410a01434c3f5bc54a88b57fa19fc43' +
      '28daea0750a4c44e88cff3b2382621b80f670464433e4336e6d003e8cd65bff211da144b88291c2259a00a72b711c116ef7686e8fee34' +
      'e4d933c868187bdc26f7be071493c86f7a5941c3510806ad67b0f94d88f5cf5c02a092821d8626e8932b65c5bd8c92049c210932b7afa' +
      '7ac59c0e886ae5c1edb00d8ce2c57633db26bd6639bff73cee82be9275c402b4cf2a4388da8cf8c64eefe1c5a0f5ab8057c39fa5c0589' +
      'c3e253f0960332300f94bea44877b588e1edbde97cf2360727a09b775262d7ee552b3319b9266f05a25');
  let eIn = BigInt('0x010001');
  return genRsaPubKeySpec(nIn, eIn);
}

// 将RSA公钥规格与预期值进行比较
function compareRsaPubKeyBySpec(rsaKeySpec: cryptoFramework.RSAPubKeySpec, n: bigint | string | number,
  e: bigint | string | number) {
  if (typeof n === 'string' || typeof e === 'string') {
    console.error('type is string');
    return false;
  }
  if (typeof n === 'number' || typeof e === 'number') {
    console.error('type is number');
    return false;
  }
  if (rsaKeySpec.params.n != n) {
    return false;
  }
  if (rsaKeySpec.pk != e) {
    return false;
  }
  return true;
}

// 根据RSA公钥规格生成RSA公钥，获取密钥规格，并与预期值进行比较
function rsaUsePubKeySpecGetSync() {
  let rsaPubKeySpec = genRsa2048PubKeySpec();
  let rsaGeneratorSpec = cryptoFramework.createAsyKeyGeneratorBySpec(rsaPubKeySpec);
  try {
    let pubKey = rsaGeneratorSpec.generatePubKeySync();
    if (pubKey != null) {
      let nBN = pubKey.getAsyKeySpec(cryptoFramework.AsyKeySpecItem.RSA_N_BN);
      let eBN = pubKey.getAsyKeySpec(cryptoFramework.AsyKeySpecItem.RSA_PK_BN);
      if (compareRsaPubKeyBySpec(rsaPubKeySpec, nBN, eBN) != true) {
        console.error('error pub key big number');
      } else {
        console.info('n, e in the pubKey are same as the spec.');
      }
    } else {
      console.error('get pub key result fail!');
    }
  } catch (e) {
    console.error(`get pub key result fail, ${e.code}, ${e.message}`);
  }
}
// [End specify_parameter_generate_rsa_keypair_sync]

@Entry
@Component
struct Index {
  @State message: string = 'RSA Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_rsa_sync'))
        .width('70%')
        .onClick(() => {
          try {
            rsaUsePubKeySpecGetSync();
            this.message = 'RSA Sync Success';
          } catch {
            this.message = 'RSA Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}