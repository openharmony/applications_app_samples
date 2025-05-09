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

// [Start message_authentication_code_calculation_hmac_one_time_incoming]

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

async function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('HMAC');
  let symKey = await aesGenerator.convertKey(symKeyBlob);
  console.info('convertKey success');
  return symKey;
}

async function doHmac() {
  // 把字符串按utf-8解码为Uint8Array，使用固定的128位的密钥，即16字节
  let keyData = new Uint8Array(buffer.from('12345678abcdefgh', 'utf-8').buffer);
  let key = await genSymKeyByData(keyData);
  let macAlgName = 'SHA256'; // 摘要算法名
  let message = 'hmacTestMessgae'; // 待进行HMAC的数据
  let mac = cryptoFramework.createMac(macAlgName);
  await mac.init(key);
  // 数据量较少时，可以只做一次update，将数据全部传入，接口未对入参长度做限制
  await mac.update({ data: new Uint8Array(buffer.from(message, 'utf-8').buffer) });
  let macResult = await mac.doFinal();
  console.info('HMAC result:' + macResult.data);
  let macLen = mac.getMacLength();
  console.info('HMAC len:' + macLen);
}

// [End message_authentication_code_calculation_hmac_one_time_incoming]

@Entry
@Component
struct Index {
  @State message: string = 'Segmentation Async';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_segmentation_async'))
        .width('70%')
        .onClick(async () => {
          try {
            await doHmac();
            this.message = 'Segmentation Async Success';
          } catch {
            this.message = 'Segmentation Async Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}