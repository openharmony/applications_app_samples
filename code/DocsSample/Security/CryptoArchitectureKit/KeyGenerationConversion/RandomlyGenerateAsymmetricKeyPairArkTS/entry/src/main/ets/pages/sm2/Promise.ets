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

// [Start generate_sm2_keypair]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

function generateSM2Key() {
  // 创建一个AsyKeyGenerator实例
  let sm2Generator = cryptoFramework.createAsyKeyGenerator('SM2_256');
  // 使用密钥生成器随机生成非对称密钥对
  let keyGenPromise = sm2Generator.generateKeyPair();
  keyGenPromise.then(keyPair => {
    let pubKey = keyPair.pubKey;
    let priKey = keyPair.priKey;
    // 获取非对称密钥对的二进制数据
    let pkBlob = pubKey.getEncoded();
    let skBlob = priKey.getEncoded();
    console.info('pk bin data' + pkBlob.data);
    console.info('sk bin data' + skBlob.data);
  });
}
// [End generate_sm2_keypair]

@Entry
@Component
struct Index {
  @State message: string = 'SM2 Promise';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sm2_promise'))
        .width('70%')
        .onClick(() => {
          try {
            generateSM2Key();
            this.message = 'SM2 Promise Success';
          } catch {
            this.message = 'SM2 Promise Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}