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


// [Start querying_the_existence_of_a_key_arkts]
import { huks } from '@kit.UniversalKeystoreKit';

let keyAlias = 'test_key';
let isKeyExist: Boolean;

let generateProperties: huks.HuksParam[] = [
  {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_DH
  },
  {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_AGREE
  },
  {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_DH_KEY_SIZE_2048
  }
];

let generateHuksOptions: huks.HuksOptions = {
  properties: generateProperties,
  inData: new Uint8Array([])
}

/* 1.生成密钥 */
function generateKeyItem(keyAlias: string, huksOptions: huks.HuksOptions) {
  return new Promise<void>((resolve, reject) => {
    try {
      huks.generateKeyItem(keyAlias, huksOptions, (error, data) => {
        if (error) {
          reject(error);
        } else {
          resolve(data);
        }
      });
    } catch (error) {
      throw (error as Error);
    }
  });
}

async function generateKey(keyAlias: string, huksOptions: huks.HuksOptions): Promise<void> {
  console.info(`enter promise generateKeyItem`);
  await generateKeyItem(keyAlias, huksOptions);
  console.info(`promise: generateKeyItem success`);
}

/* 2.检查密钥是否存在 */
let huksOptions: huks.HuksOptions = {
  properties: []
}

function hasKeyItem(keyAlias: string, huksOptions: huks.HuksOptions) {
  return new Promise<boolean>((resolve, reject) => {
    try {
      huks.hasKeyItem(keyAlias, huksOptions, (error, data) => {
        if (error) {
          reject(error);
        } else {
          resolve(data.valueOf());
        }
      });
    } catch (error) {
      throw (error as Error);
    }
  });
}

async function checkKeyExistence(keyAlias: string, huksOptions: huks.HuksOptions): Promise<boolean> {
  console.info(`enter promise hasKeyItem`);
  const exists = await hasKeyItem(keyAlias, huksOptions);
  console.info(`promise: hasKeyItem success, isKeyExist = ${exists}`);
  return exists;
}

async function executeCheckKey(): Promise<string> {
  try {
    /* 1.生成密钥 */
    await generateKey(keyAlias, generateHuksOptions);

    /* 2.检查密钥是否存在 */
    isKeyExist = await checkKeyExistence(keyAlias, huksOptions);

    console.info(`Key check completed, isKeyExist = ${isKeyExist}`);
    return 'Success';
  } catch (error) {
    console.error(`Key check failed: ${JSON.stringify(error)}`);
    return 'Failed';
  }
}
// [End querying_the_existence_of_a_key_arkts]

@Entry
@Component
struct Index {
  @State message: string = 'CheckKeyExists';

  build() {
    Column({ space: 12 }) {
      Text(this.message)
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(Infinity)
        .textAlign(TextAlign.Start)
      Button($r('app.string.call_check_key_exists'))
        .padding('12vp')
        .height('40vp')
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
        .fontSize('14sp')
        .fontColor('#ffffff')
        .onClick(async () => {
          let ret: string = await executeCheckKey();
          this.message = 'CheckKeyExists Result: ' + ret;
        })
    }
    .height('100%')
    .width('100%')
  }
}
