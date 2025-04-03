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
import { buffer } from '@kit.ArkTS';

function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('HMAC');
  let symKey = aesGenerator.convertKeySync(symKeyBlob);
  console.info('[Sync]convertKey success');
  return symKey;
}

function doLoopHmacBySync() {
  // 把字符串按utf-8解码为Uint8Array，使用固定的128位的密钥，即16字节
  let keyData = new Uint8Array(buffer.from('12345678abcdefgh', 'utf-8').buffer);
  let key = genSymKeyByData(keyData);
  let macAlgName = 'SHA256'; // 摘要算法名
  let mac = cryptoFramework.createMac(macAlgName);
  // 假设信息总共43字节，根据utf-8解码后，也是43字节
  let messageText = 'aaaaa.....bbbbb.....ccccc.....ddddd.....eee';
  let messageData = new Uint8Array(buffer.from(messageText, 'utf-8').buffer);
  let updateLength = 20; // 假设以20字节为单位进行分段update，实际并无要求
  mac.initSync(key);
  for (let i = 0; i < messageData.length; i += updateLength) {
    let updateMessage = messageData.subarray(i, i + updateLength);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    mac.updateSync(updateMessageBlob);
  }
  let macOutput = mac.doFinalSync();
  console.info('[Sync]HMAC result: ' + macOutput.data);
  let macLen = mac.getMacLength();
  console.info('HMAC len:' + macLen);
}

@Entry
@Component
struct Index {
  @State message: string = 'SingleTime Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_single_time_sync'))
        .width('70%')
        .onClick(() => {
          try {
            doLoopHmacBySync();
            this.message = 'SingleTime Sync Success';
          } catch {
            this.message = 'SingleTime Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}