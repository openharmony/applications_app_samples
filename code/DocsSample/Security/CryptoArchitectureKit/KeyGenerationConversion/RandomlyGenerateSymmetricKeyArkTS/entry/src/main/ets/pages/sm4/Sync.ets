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

function testSyncGenerateSm4Key() {
  // 创建SymKeyGenerator实例
  let symKeyGenerator = cryptoFramework.createSymKeyGenerator('SM4_128');
  // 使用密钥生成器随机生成对称密钥
  let promiseSymKey = symKeyGenerator.generateSymKeySync();
  // 获取对称密钥的二进制数据，输出128位字节流。长度为16字节
  let encodedKey = promiseSymKey.getEncoded();
  console.info('key hex:' + encodedKey.data);
}

@Entry
@Component
struct Index {
  @State message: string = 'SM4 Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sm4_sync'))
        .width('70%')
        .onClick(() => {
          try {
            testSyncGenerateSm4Key();
            this.message = 'SM4 Sync Success';
          } catch {
            this.message = 'SM4 Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}