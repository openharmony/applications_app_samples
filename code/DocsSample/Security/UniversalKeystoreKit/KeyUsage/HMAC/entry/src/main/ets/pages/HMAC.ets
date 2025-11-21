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

// [Start hmac_to]
/*
 * 以下以HMAC密钥的Promise操作使用为例
 */
import { huks } from '@kit.UniversalKeystoreKit';

let hmacKeyAlias = 'test_HMAC';
let handle: number;
let plainText = '123456';
let hashData: Uint8Array;

function stringToUint8Array(str: String) {
  let arr: number[] = [];
  for (let i = 0, j = str.length; i < j; ++i) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
}

function uint8ArrayToString(fileData: Uint8Array) {
  let dataString = '';
  for (let i = 0; i < fileData.length; i++) {
    dataString += String.fromCharCode(fileData[i]);
  }
  return dataString;
}

function getHMACProperties() {
  const properties: huks.HuksParam[] = [{
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_HMAC
  }, {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256
  }, {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_MAC
  }, {
    tag: huks.HuksTag.HUKS_TAG_DIGEST,
    value: huks.HuksKeyDigest.HUKS_DIGEST_SHA384,
  }];
  return properties;
}

/* 1.生成 HMAC 密钥 */
async function generateHMACKey() {
  let options: huks.HuksOptions = {
    properties: getHMACProperties()
  }

  await huks.generateKeyItem(hmacKeyAlias, options)
    .then((data) => {
      console.info(`promise: generate HMAC Key success`);
    }).catch((error: Error) => {
      console.error(`promise: generate HMAC Key failed, ${JSON.stringify(error)}`);
      throw (error as Error);
    })
}
/* 2.执行 HMAC 计算 */
async function hMACData() {
  let options: huks.HuksOptions = {
    properties: getHMACProperties(),
    inData: stringToUint8Array(plainText)
  }

  await huks.initSession(hmacKeyAlias, options)
    .then((data) => {
      handle = data.handle;
    }).catch((error: Error) => {
      console.error(`promise: init session failed, ${JSON.stringify(error)}`);
      throw (error as Error);
    })

  await huks.finishSession(handle, options)
    .then((data) => {
      console.info(`promise: HMAC data success, data is ` + uint8ArrayToString(data.outData as Uint8Array));
      hashData = data.outData as Uint8Array;
    }).catch((error: Error) => {
      console.error(`promise: HMAC data failed, ${JSON.stringify(error)}`);
      throw (error as Error);
    })
}

async function executeHMAC() {
  await generateHMACKey();
  await hMACData();
}
// [End hmac_to]
@Entry
@Component
struct Index {
  @State message: string = 'HMAC';

  build() {
    Column({ space: 12 }) {
      Text(this.message)
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(Infinity)
        .textAlign(TextAlign.Start)
      Button($r('app.string.call_hmac'))
        .padding('12vp')
        .height('40vp')
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
        .fontSize('14sp')
        .fontColor('#ffffff')
        .onClick(async () => {
          try {
            await executeHMAC();
            this.message = 'HMAC Result: Success';
          } catch (error) {
            this.message = 'HMAC Result: ' + error.message;
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
