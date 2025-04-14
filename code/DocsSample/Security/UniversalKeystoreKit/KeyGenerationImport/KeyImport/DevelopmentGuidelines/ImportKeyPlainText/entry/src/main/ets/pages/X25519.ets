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

/* 以下以导入X25519密钥的Callback操作使用为例 */
import { huks } from '@kit.UniversalKeystoreKit'

// X25519的公钥数据。X25519 密钥对中的私钥和公钥都是 32 字节（256 位），关于算法原理请自行参考相关密钥学资料。
let x25519KeyPubMaterial = new Uint8Array([
  0x30, 0x2A, 0x30, 0x05, 0x06, 0x03, 0x2B, 0x65, 0x6E, 0x03, 0x21, 0x00, 0xD2, 0x36, 0x9E, 0xCF,
  0xF0, 0x61, 0x5B, 0x73, 0xCE, 0x4F, 0xF0, 0x40, 0x2B, 0x89, 0x18, 0x3E, 0x06, 0x33, 0x60, 0xC6
]);

/* 1.确定密钥别名 */
let keyAlias = 'X25519_Pub_import_sample';
/* 2.封装密钥属性集和密钥材料 */
let properties: huks.HuksParam[] = [
  {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_X25519
  },
  {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_CURVE25519_KEY_SIZE_256
  },
  {
    // 此 tag表示密钥导入后的用途，导入后将不可更改
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_VERIFY
  },
  {
    // 此 tag表示需导入的密钥类型
    tag: huks.HuksTag.HUKS_TAG_IMPORT_KEY_TYPE,
    // 此 value表示导入密钥的公钥，若改为HUKS_KEY_TYPE_KEY_PAIR时表示导入密钥对
    value: huks.HuksImportKeyType.HUKS_KEY_TYPE_PUBLIC_KEY
  },
];

let options: huks.HuksOptions = {
  properties: properties,
  inData: x25519KeyPubMaterial
};

/* 3.明文导入密钥 */
function importX25519() {
  try {
    huks.importKeyItem(keyAlias, options, (error, data) => {
      if (error) {
        console.error(`callback: importKeyItem failed` + error);
      } else {
        console.info(`callback: importKeyItem success`);
      }
    });
  } catch (error) {
    console.error(`callback: importKeyItem input arg invalid` + error);
    throw (error as Error);
  }
}

let isKeyExist = false;

let keyProperties: huks.HuksParam[] = [
  {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_X25519
  },
  {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_CURVE25519_KEY_SIZE_256
  },
  {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_VERIFY
  },
  {
    tag: huks.HuksTag.HUKS_TAG_IMPORT_KEY_TYPE,
    value: huks.HuksImportKeyType.HUKS_KEY_TYPE_PUBLIC_KEY
  },
]

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
  @State message: string = 'X25519';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(Infinity)
        .textAlign(TextAlign.Start)
      Button($r('app.string.call_x25519'))
        .padding('12vp')
        .height('40vp')
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
        .fontSize('14sp')
        .fontColor('#ffffff')
        .onClick(() => {
          try {
            importX25519();
            check();
            this.message = 'X25519 Result: Success';
          }catch{
            this.message = 'X25519 Result: Failed';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
