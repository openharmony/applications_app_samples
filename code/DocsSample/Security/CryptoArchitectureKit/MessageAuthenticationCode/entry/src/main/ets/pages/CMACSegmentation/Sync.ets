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
// [Start message_authentication_code_calculation_cmac_segmentation_sync]
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

function genSymKeyByData(symKeyData: Uint8Array) {
  let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
  let aesGenerator = cryptoFramework.createSymKeyGenerator('AES128');
  let symKey = aesGenerator.convertKeySync(symKeyBlob);
  console.info('[Sync]convertKey success');
  return symKey;
}
function doLoopCmacBySync() {
  // 把字符串按utf-8解码为Uint8Array，使用固定的128位的密钥，即16字节。
  let keyData = new Uint8Array(buffer.from('12345678abcdefgh', 'utf-8').buffer);
  let key = genSymKeyByData(keyData);
  let spec: cryptoFramework.CmacSpec = {
    algName: 'CMAC',
    cipherName: 'AES128',
  };
  let mac = cryptoFramework.createMac(spec);
  // 假设信息共43字节，utf-8解码后仍为43字节。
  let messageText = 'aaaaa.....bbbbb.....ccccc.....ddddd.....eee';
  let messageData = new Uint8Array(buffer.from(messageText, 'utf-8').buffer);
  let updateLength = 20; // 假设以20字节为单位进行分段update，实际没有具体要求。
  mac.initSync(key);
  for (let i = 0; i < messageData.length; i += updateLength) {
    let updateMessage = messageData.subarray(i, i + updateLength);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    mac.updateSync(updateMessageBlob);
  }
  let macOutput = mac.doFinalSync();
  console.info('[Sync]CMAC result: ' + macOutput.data);
  let macLen = mac.getMacLength();
  console.info('CMAC len:' + macLen);
}

// [End message_authentication_code_calculation_cmac_segmentation_sync]

@Entry
@Component
struct Index {
  @State message: string = 'CMAC Segmentation Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_cmac_segmentation_sync'))
        .width('70%')
        .onClick(() => {
          try {
            doLoopCmacBySync();
            this.message = 'CMAC Segmentation Sync Success';
          } catch {
            this.message = 'CMAC Segmentation Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}