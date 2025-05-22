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

// [Start generate_hmac_key]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

async function testConvertHmacKey() {
  // 对称密钥长度为64字节，512比特
  let keyMessage = '12345678abcdefgh12345678abcdefgh12345678abcdefgh12345678abcdefgh';
  let keyBlob: cryptoFramework.DataBlob = {
    data: new Uint8Array(buffer.from(keyMessage, 'utf-8').buffer)
  }
  let symKeyGenerator = cryptoFramework.createSymKeyGenerator('HMAC');
  let key = await symKeyGenerator.convertKey(keyBlob);
  let encodedKey = key.getEncoded();
  console.info('key encoded data：' + encodedKey.data);
}
// [End generate_hmac_key]

@Entry
@Component
struct Index {
  @State message: string = 'Await';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_hmac_await'))
        .width('70%')
        .onClick(async () => {
          try {
            await testConvertHmacKey();
            this.message = 'HMAC Await Success';
          } catch {
            this.message = 'HMAC Await Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}