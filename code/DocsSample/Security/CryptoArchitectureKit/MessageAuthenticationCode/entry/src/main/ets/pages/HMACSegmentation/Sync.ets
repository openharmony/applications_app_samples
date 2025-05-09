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
// [Start message_authentication_code_calculation_sync_one_time_incoming]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('HMAC');
  let symKey = aesGenerator.convertKeySync(symKeyBlob);
  console.info('[Sync]convertKey success');
  return symKey;
}

function doHmacBySync() {
  // 把字符串按utf-8解码为Uint8Array，使用固定的128位的密钥，即16字节
  let keyData = new Uint8Array(buffer.from('12345678abcdefgh', 'utf-8').buffer);
  let key = genSymKeyByData(keyData);
  let macAlgName = 'SHA256'; // 摘要算法名
  let message = 'hmacTestMessgae'; // 待进行HMAC的数据
  let mac = cryptoFramework.createMac(macAlgName);
  mac.initSync(key);
  // 数据量较少时，可以只做一次update，将数据全部传入，接口未对入参长度做限制
  mac.updateSync({ data: new Uint8Array(buffer.from(message, 'utf-8').buffer) });
  let macResult = mac.doFinalSync();
  console.info('[Sync]HMAC result:' + macResult.data);
  let macLen = mac.getMacLength();
  console.info('HMAC len:' + macLen);
}

// [End message_authentication_code_calculation_sync_one_time_incoming]

@Entry
@Component
struct Index {
  @State message: string = 'Segmentation Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_segmentation_sync'))
        .width('70%')
        .onClick(() => {
          try {
            doHmacBySync();
            this.message = 'Segmentation Sync Success';
          } catch {
            this.message = 'Segmentation Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}