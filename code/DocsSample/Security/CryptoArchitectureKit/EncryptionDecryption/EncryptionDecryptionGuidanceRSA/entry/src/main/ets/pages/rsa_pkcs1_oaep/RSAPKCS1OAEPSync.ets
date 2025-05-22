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

// [Start pss_verify_rsa_keypair_sign_sync]
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
  let nIn = BigInt('0x9260d0750ae117eee55c3f3deaba74917521a262ee76007cdf8a56755ad73a1598a1408410a01434c3f5bc54a88b57fa19fc4328daea0750a4c44e88cff3b2382621b80f670464433e4336e6d003e8cd65bff211da144b88291c2259a00a72b711c116ef7686e8fee34e4d933c868187bdc26f7be071493c86f7a5941c3510806ad67b0f94d88f5cf5c02a092821d8626e8932b65c5bd8c92049c210932b7afa7ac59c0e886ae5c1edb00d8ce2c57633db26bd6639bff73cee82be9275c402b4cf2a4388da8cf8c64eefe1c5a0f5ab8057c39fa5c0589c3e253f0960332300f94bea44877b588e1edbde97cf2360727a09b775262d7ee552b3319b9266f05a25');
  let eIn = BigInt('0x010001');
  let dIn = BigInt('0x6a7df2ca63ead4dda191d614b6b385e0d9056a3d6d5cfe07db1daabee022db08212d97613d3328e0267c9dd23d787abde2afcb306aeb7dfce69246cc73f5c87fdf06030179a2114b767db1f083ff841c025d7dc00cd82435b9a90f695369e94df23d2ce458bc3b3283ad8bba2b8fa1ba62e2dce9accff3799aae7c840016f3ba8e0048c0b6cc4339af7161003a5beb864a0164b2c1c9237b64bc87556994351b27506c33d4bcdfce0f9c491a7d6b0628c7c852be4f0a9c3132b2ed3a2c8881e9aab07e20e17deb074691be677776a78b5c502e05d9bdde72126b3738695e2dd1a0a98a14247c65d8a7ee79432a092cb0721a12df798e44f7cfce0c498147a9b1');
  return genRsaKeyPairSpec(nIn, eIn, dIn);
}
function main() {
  let plan = 'This is a test';
  // 获得RSA密钥对密钥参数对象
  let rsaKeyPairSpec = genRsa2048KeyPairSpec();
  // 根据RSA密钥对参数生成RSA密钥对
  let rsaGeneratorSpec = cryptoFramework.createAsyKeyGeneratorBySpec(rsaKeyPairSpec);
  let cipher = cryptoFramework.createCipher('RSA2048|PKCS1_OAEP|SHA256|MGF1_SHA1');
  let decoder = cryptoFramework.createCipher('RSA2048|PKCS1_OAEP|SHA256|MGF1_SHA1');
  // RSA加解密PKCS1-OAEP模式填充字节流P
  let pSource = new Uint8Array([1, 2, 3, 4]);
  let input: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(plan, 'utf-8').buffer) };
  // 生成密钥对
  let keyPair = rsaGeneratorSpec.generateKeyPairSync();
  // 进行加密操作初始化
  cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPair.pubKey, null);
  // get和set操作可以放在Cipher对象init之后，此处对cipher进行set和get操作
  cipher.setCipherSpec(cryptoFramework.CipherSpecItem.OAEP_MGF1_PSRC_UINT8ARR, pSource);
  let retP = cipher.getCipherSpec(cryptoFramework.CipherSpecItem.OAEP_MGF1_PSRC_UINT8ARR);
  // 比较get出来的P字节流与set进去的P字节流是否一致
  if (retP.toString() != pSource.toString()) {
    console.error('error init pSource' + retP);
  } else {
    console.info('pSource changed ==' + retP);
  }
  // 进行OAEP其他参数的get操作
  let md = cipher.getCipherSpec(cryptoFramework.CipherSpecItem.OAEP_MD_NAME_STR);
  console.info('md == ' + md);
  let mgf = cipher.getCipherSpec(cryptoFramework.CipherSpecItem.OAEP_MGF_NAME_STR);
  console.info('mgf == ' + mgf);
  let mgf1Md = cipher.getCipherSpec(cryptoFramework.CipherSpecItem.OAEP_MGF1_MD_STR);
  console.info('mgf1Md == ' + mgf1Md);
  let cipherDataBlob = cipher.doFinalSync(input);
  // get和set操作可以放在Cipher对象init之前，且与init之后等价，此处对decoder进行set和get操作
  decoder.setCipherSpec(cryptoFramework.CipherSpecItem.OAEP_MGF1_PSRC_UINT8ARR, pSource);
  retP = decoder.getCipherSpec(cryptoFramework.CipherSpecItem.OAEP_MGF1_PSRC_UINT8ARR);
  // 比较get出来的P字节流与set进去的P字节流是否一致
  if (retP.toString() != pSource.toString()) {
    console.error('error init pSource' + retP);
  } else {
    console.info('pSource changed ==' + retP);
  }
  // 进行OAEP其他参数的get操作
  md = decoder.getCipherSpec(cryptoFramework.CipherSpecItem.OAEP_MD_NAME_STR);
  console.info('md == ' + md);
  mgf = decoder.getCipherSpec(cryptoFramework.CipherSpecItem.OAEP_MGF_NAME_STR);
  console.info('mgf == ' + mgf);
  mgf1Md = decoder.getCipherSpec(cryptoFramework.CipherSpecItem.OAEP_MGF1_MD_STR);
  console.info('mgf1Md == ' + mgf1Md);
  // 初始化解密操作
  decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, keyPair.priKey, null);
  let decodeData = decoder.doFinalSync(cipherDataBlob);
  // 解密成功
  if (decodeData.data.toString() === input.data.toString()) {
    console.info('oaep decrypt success');
  } else {
    console.error('oaep decrypt fail');
  }
}
// [End pss_verify_rsa_keypair_sign_sync]

@Entry
@Component
struct Index {
  @State message: string = 'RSA PKCS1 OAEP Sync';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.call_rsa_pkcs1_oaep_sync'))
        .onClick(() => {
          try {
            main();
            this.message = 'RSA PKCS1 OAEP Sync Success';
          } catch (error) {
            console.error(error);
            this.message = 'RSA PKCS1 OAEP Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}