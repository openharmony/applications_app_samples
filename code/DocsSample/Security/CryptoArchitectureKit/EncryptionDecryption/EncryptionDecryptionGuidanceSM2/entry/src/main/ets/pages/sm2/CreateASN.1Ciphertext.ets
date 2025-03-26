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

function testGenCipherTextBySpec() {
  let spec: cryptoFramework.SM2CipherTextSpec = {
    xCoordinate: BigInt('20625015362595980457695435345498579729138244358573902431560627260141789922999'),
    yCoordinate: BigInt('48563164792857017065725892921053777369510340820930241057309844352421738767712'),
    cipherTextData: new Uint8Array([100, 227, 78, 195, 249, 179, 43, 70, 242, 69, 169, 10, 65, 123]),
    hashData: new Uint8Array([87, 167, 167, 247, 88, 146, 203, 234, 83, 126, 117, 129, 52, 142, 82, 54, 152, 226, 201,
      111, 143, 115, 169, 125, 128, 42, 157, 31, 114, 198, 109, 244]),
  }
  // 此处的data可直接使用cryptoFramework进行SM2解密
  let data = cryptoFramework.SM2CryptoUtil.genCipherTextBySpec(spec, 'C1C3C2');
  console.info('genCipherTextBySpec success');
}

@Entry
@Component
struct Index {
  @State message: string = 'Create ASN.1';

  build() {
    Column({ space: 5 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_create_asn1'))
        .width('70%')
        .onClick(() => {
          try {
            testGenCipherTextBySpec();
            this.message = 'Create ASN.1 Success';
          } catch {
            this.message = 'Create ASN.1 Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}