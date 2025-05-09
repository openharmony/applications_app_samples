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

// [Start pkcs8_convert_ecc_pri_keypair]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

async function main() {
  // 创建一个AsyKeyGenerator实例
  let eccGenerator = cryptoFramework.createAsyKeyGenerator('ECC256');
  // 使用密钥生成器随机生成非对称密钥对
  let keyGenPromise = eccGenerator.generateKeyPair();
  keyGenPromise.then(keyPair => {
    let pubKey = keyPair.pubKey;
    let priKey = keyPair.priKey;
    // 获取非对称密钥对ECC的二进制数据
    let pubBlob = pubKey.getEncoded();
    let skBlob = priKey.getEncodedDer('PKCS8');
    let generator = cryptoFramework.createAsyKeyGenerator('ECC256');
    generator.convertKey(pubBlob, skBlob, (error, data) => {
      if (error) {
        console.error(`convertKey failed, ${error.code}, ${error.message}`);
        return;
      }
      console.info('convertKey success');
    });
  });
}
// [End pkcs8_convert_ecc_pri_keypair]

@Entry
@Component
struct Index {
  @State message: string = 'PKCS8 ECC Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_pkcs8_ecc_sync'))
        .width('70%')
        .onClick(async () => {
          try {
            await main();
            this.message = 'PKCS8 ECC Sync Success';
          } catch {
            this.message = 'PKCS8 ECC Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}