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

function generateSM2KeySync() {
  // 创建一个AsyKeyGenerator实例
  let rsaGenerator = cryptoFramework.createAsyKeyGenerator('SM2_256');
  // 使用密钥生成器随机生成非对称密钥对
  try {
    let keyPair = rsaGenerator.generateKeyPairSync();
    if (keyPair != null) {
      let pubKey = keyPair.pubKey;
      let priKey = keyPair.priKey;
      // 获取非对称密钥对的二进制数据
      let pkBlob = pubKey.getEncoded();
      let skBlob = priKey.getEncoded();
      console.info('pk bin data' + pkBlob.data);
      console.info('sk bin data' + skBlob.data);
    } else {
      console.error('[Sync]: get key pair result fail!');
    }
  } catch (e) {
    console.error(`get key pair failed, ${e.code}, ${e.message}`);
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'SM2 Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sm2_sync'))
        .width('70%')
        .onClick(() => {
          try {
            generateSM2KeySync();
            this.message = 'SM2 Sync Success';
          } catch {
            this.message = 'SM2 Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}