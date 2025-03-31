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

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

// 根据密钥参数属性构造RSA非对称密钥对密钥参数
function genRsaKeyPairSpec(nIn: bigint, eIn: bigint, dIn: bigint) {
  let rsaCommSpec: cryptoFramework.RSACommonParamsSpec = {
    n: nIn,
    algName: 'RSA',
    specType: cryptoFramework.AsyKeySpecType.COMMON_PARAMS_SPEC
  };
  let rsaKeyPairSpec: cryptoFramework.RSAKeyPairSpec = {
    params: rsaCommSpec,
    sk: dIn,
    pk: eIn,
    algName: 'RSA',
    specType: cryptoFramework.AsyKeySpecType.KEY_PAIR_SPEC
  };
  return rsaKeyPairSpec;
}

// 生成RSA2048密钥对参数
function genRsa2048KeyPairSpec(): cryptoFramework.RSAKeyPairSpec {
  let nIn =
    BigInt('0x9260d0750ae117eee55c3f3deaba74917521a262ee76007cdf8a56755ad73a1598a1408410a01434c3f5bc54a88b57fa19fc43' +
      '28daea0750a4c44e88cff3b2382621b80f670464433e4336e6d003e8cd65bff211da144b88291c2259a00a72b711c116ef7686e8fee34' +
      'e4d933c868187bdc26f7be071493c86f7a5941c3510806ad67b0f94d88f5cf5c02a092821d8626e8932b65c5bd8c92049c210932b7afa' +
      '7ac59c0e886ae5c1edb00d8ce2c57633db26bd6639bff73cee82be9275c402b4cf2a4388da8cf8c64eefe1c5a0f5ab8057c39fa5c0589' +
      'c3e253f0960332300f94bea44877b588e1edbde97cf2360727a09b775262d7ee552b3319b9266f05a25');
  let eIn = BigInt('0x010001');
  let dIn =
    BigInt('0x6a7df2ca63ead4dda191d614b6b385e0d9056a3d6d5cfe07db1daabee022db08212d97613d3328e0267c9dd23d787abde2afcb' +
      '306aeb7dfce69246cc73f5c87fdf06030179a2114b767db1f083ff841c025d7dc00cd82435b9a90f695369e94df23d2ce458bc3b3283a' +
      'd8bba2b8fa1ba62e2dce9accff3799aae7c840016f3ba8e0048c0b6cc4339af7161003a5beb864a0164b2c1c9237b64bc87556994351b' +
      '27506c33d4bcdfce0f9c491a7d6b0628c7c852be4f0a9c3132b2ed3a2c8881e9aab07e20e17deb074691be677776a78b5c502e05d9bdd' +
      'e72126b3738695e2dd1a0a98a14247c65d8a7ee79432a092cb0721a12df798e44f7cfce0c498147a9b1');
  return genRsaKeyPairSpec(nIn, eIn, dIn);
}

function verifyMessagePSS() {
  // 完整的明文被拆分为input1和input2
  let plan1 = 'This is Sign test plan1';
  let plan2 = 'This is Sign test plan2';
  let input1: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(plan1, 'utf-8').buffer) };
  let input2: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(plan2, 'utf-8').buffer) };
  // 获得RSA密钥对密钥参数对象
  let rsaKeyPairSpec = genRsa2048KeyPairSpec();
  // 构造RSA密钥对生成器
  let rsaGeneratorSpec = cryptoFramework.createAsyKeyGeneratorBySpec(rsaKeyPairSpec);
  // sign和verfiy均支持RSA密钥带长度/不带长度的写法
  let signer = cryptoFramework.createSign('RSA|PSS|SHA256|MGF1_SHA256');
  let verifyer = cryptoFramework.createVerify('RSA2048|PSS|SHA256|MGF1_SHA256');
  let keyPair = rsaGeneratorSpec.generateKeyPairSync();
  signer.initSync(keyPair.priKey);
  // 在签名初始化后，对PSS参数进行set和get操作
  let setN = 32;
  signer.setSignSpec(cryptoFramework.SignSpecItem.PSS_SALT_LEN_NUM, setN);
  let saltLen = signer.getSignSpec(cryptoFramework.SignSpecItem.PSS_SALT_LEN_NUM);
  console.info('SaltLen == ' + saltLen);
  let tf = signer.getSignSpec(cryptoFramework.SignSpecItem.PSS_TRAILER_FIELD_NUM);
  console.info('trailer field == ' + tf);
  let md = signer.getSignSpec(cryptoFramework.SignSpecItem.PSS_MD_NAME_STR);
  console.info('md == ' + md);
  let mgf = signer.getSignSpec(cryptoFramework.SignSpecItem.PSS_MGF_NAME_STR);
  console.info('mgf == ' + mgf);
  let mgf1Md = signer.getSignSpec(cryptoFramework.SignSpecItem.PSS_MGF1_MD_STR);
  console.info('mgf1Md == ' + mgf1Md);
  signer.updateSync(input1);
  let signMessageBlob = signer.signSync(input2);
  // 在验签初始化前，对PSS参数进行set和get操作
  verifyer.setVerifySpec(cryptoFramework.SignSpecItem.PSS_SALT_LEN_NUM, setN);
  saltLen = verifyer.getVerifySpec(cryptoFramework.SignSpecItem.PSS_SALT_LEN_NUM);
  console.info('SaltLen == ' + saltLen);
  tf = verifyer.getVerifySpec(cryptoFramework.SignSpecItem.PSS_TRAILER_FIELD_NUM);
  console.info('trailer field == ' + tf);
  md = verifyer.getVerifySpec(cryptoFramework.SignSpecItem.PSS_MD_NAME_STR);
  console.info('md == ' + md);
  mgf = verifyer.getVerifySpec(cryptoFramework.SignSpecItem.PSS_MGF_NAME_STR);
  console.info('mgf == ' + mgf);
  mgf1Md = verifyer.getVerifySpec(cryptoFramework.SignSpecItem.PSS_MGF1_MD_STR);
  verifyer.initSync(keyPair.pubKey);
  verifyer.updateSync(input1);
  let verifyResult = verifyer.verifySync(input2, signMessageBlob);
  if (verifyResult === true) {
    console.info('verify success');
  } else {
    console.error('verify failed');
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'Signing Signature Verification';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(25).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_psssignatureseg_synchronous'))
        .width('70%')
        .onClick(() => {
          try {
            verifyMessagePSS();
            this.message = 'PSSSignatureSegSuccess';
          } catch {
            this.message = 'PSSSignatureSegFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}