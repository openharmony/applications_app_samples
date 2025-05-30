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

// [Start pkcs1_seg_verify_rsa_keypair_sign_async]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

function signMessageBySegment(priKey: cryptoFramework.PriKey, plainText: Uint8Array) {
  let signAlg = 'RSA1024|PKCS1|SHA256';
  let signer = cryptoFramework.createSign(signAlg);
  signer.initSync(priKey);
  let textSplitLen = 64; // 自定义的数据拆分长度，此处取64
  for (let i = 0; i < plainText.length; i += textSplitLen) {
    let updateMessage = plainText.subarray(i, i + textSplitLen);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    // 分段update
    signer.updateSync(updateMessageBlob);
  }
  // 已通过分段传入所有明文，故此处sign传入null
  let signData = signer.signSync(null);
  return signData;
}

function verifyMessagBySegment(pubKey: cryptoFramework.PubKey, plainText: Uint8Array,
  signMessageBlob: cryptoFramework.DataBlob) {
  let verifyAlg = 'RSA1024|PKCS1|SHA256';
  let verifier = cryptoFramework.createVerify(verifyAlg);
  verifier.initSync(pubKey);
  let textSplitLen = 64; // 自定义的数据拆分长度，此处取64
  for (let i = 0; i < plainText.length; i += textSplitLen) {
    let updateMessage = plainText.subarray(i, i + textSplitLen);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    // 分段update
    verifier.updateSync(updateMessageBlob);
  }
  // 已通过分段传入所有明文，故此处verify第一个参数传入null
  let res = verifier.verifySync(null, signMessageBlob);
  console.info('verify result is ' + res);
  return res;
}

function rsaSignatureBySegment() {
  let message = 'This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!' +
    'This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!';
  let keyGenAlg = 'RSA1024';
  let generator = cryptoFramework.createAsyKeyGenerator(keyGenAlg);
  let keyPair = generator.generateKeyPairSync();
  let messageData = new Uint8Array(buffer.from(message, 'utf-8').buffer);
  let signData = signMessageBySegment(keyPair.priKey, messageData);
  let verifyResult = verifyMessagBySegment(keyPair.pubKey, messageData, signData);
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
      Button($r('app.string.call_signatureseg_synchronous'))
        .width('70%')
        .onClick(() => {
          try {
            rsaSignatureBySegment();
            this.message = 'SignatureSegSuccess';
          } catch {
            this.message = 'SignatureSegFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End pkcs1_seg_verify_rsa_keypair_sign_async]