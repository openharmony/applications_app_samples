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

/* 以下以导入AES256密钥的Callback操作使用为例 */
import { huks } from '@kit.UniversalKeystoreKit'

/* 密钥材料 */
let plainTextSize32 = new Uint8Array([
  0xfb, 0x8b, 0x9f, 0x12, 0xa0, 0x83, 0x19, 0xbe, 0x6a, 0x6f, 0x63, 0x2a, 0x7c, 0x86, 0xba, 0xca,
  0x64, 0x0b, 0x88, 0x96, 0xe2, 0xfa, 0x77, 0xbc, 0x71, 0xe3, 0x0f, 0x0f, 0x9e, 0x3c, 0xe5, 0xf9
]);
/* 1.确定密钥别名 */
let keyAlias = 'AES256Alias_sample';

/* 2.封装密钥属性集和密钥材料 */
let properties: huks.HuksParam[] = [
  {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_AES
  },
  {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256
  },
  {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT | huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
  },
];

let options: huks.HuksOptions = {
  properties: properties,
  inData: plainTextSize32
};

/* 3.明文导入密钥 */
function importAES256() {
  try {
    huks.importKeyItem(keyAlias, options, (error, data) => {
      if (error) {
        console.error(`callback: importKeyItem failed` + JSON.stringify(error));
      } else {
        console.info(`callback: importKeyItem success`);
      }
    });
  } catch (error) {
    console.error(`callback: importKeyItem input arg invalid` + JSON.stringify(error));
    throw (error as Error);
  }
}

let isKeyExist = false;

let keyProperties: huks.HuksParam[] = [
  {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_AES
  },
  {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256
  },
  {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT | huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
  },
];

let huksOptions: huks.HuksOptions = {
  properties: keyProperties, // 非空填充
  inData: new Uint8Array([]) // 非空填充
}

function check() {
  try {
    huks.isKeyItemExist(keyAlias, huksOptions, (error, data) => {
      if (error) {
        console.error(`callback: isKeyItemExist failed, ` + JSON.stringify(error));
      } else {
        if (data !== null && data.valueOf() !== null) {
          isKeyExist = data.valueOf();
          console.info(`callback: isKeyItemExist success, isKeyExist = ${isKeyExist}`);
        }
      }
    });
  } catch (error) {
    console.error(`callback: isKeyItemExist input arg invalid, ` + JSON.stringify(error));
    throw (error as Error);
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'AES256';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(Infinity)
        .textAlign(TextAlign.Start)
      Button($r('app.string.call_aes_256'))
        .padding('12vp')
        .height('40vp')
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
        .fontSize('14sp')
        .fontColor('#ffffff')
        .onClick(() => {
          try {
            importAES256();
            check();
            this.message = 'AES256 Result: Success';
          }catch{
            this.message = 'AES256 Result: Failed';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
