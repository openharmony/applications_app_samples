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

// [Start kem_encapsulate_decapsulate_await_test]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

namespace Kem {
  export async function kemDecapsulateAwait() {
    let asyKeyGenerator = cryptoFramework.createAsyKeyGenerator('ML-KEM-768');
    let keyPair = await asyKeyGenerator.generateKeyPair();
    let kem : cryptoFramework.Kem = cryptoFramework.createKem(cryptoFramework.KemAlgNameId.ML_KEM_768);
    try {
      let encapResult : cryptoFramework.KemEncapResult = await kem.encapsulate(keyPair.pubKey, null);
      let sharedSecret : Uint8Array = await kem.decapsulate(keyPair.priKey, encapResult.wrappedKey);
      console.info('decapsulate success');
      console.info('sharedSecret length: ' + sharedSecret.length);
      return 'Success';
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`decapsulate failed: errCode: ${e.code}, errMsg: ${e.message}`);
      return 'Failed';
    }
  }
}


// [End kem_encapsulate_decapsulate_await_test]
@Entry
@Component
struct Index {
  @State message: string = 'Test Await';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_await'))
        .width('70%')
        .onClick(async () => {
          let result: string = await Kem.kemDecapsulateAwait();
          this.message = 'Call Await ' + result;
        })
    }
    .height('100%')
    .width('100%')
  }
}
