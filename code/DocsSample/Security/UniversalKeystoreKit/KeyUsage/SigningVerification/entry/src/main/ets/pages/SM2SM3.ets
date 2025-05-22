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
// [Start key_algorithm_SM2SM3]
/*
 * 密钥算法为SM2、摘要算法为SM3
 */
import { huks } from '@kit.UniversalKeystoreKit';

let keyAlias = 'test_sm2KeyAlias';
let handle: number;
let plaintext = '123456';
let signature: Uint8Array;


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


function getSm2GenerateProperties() {
  let properties: huks.HuksParam[] = [{
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_SM2
  }, {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256
  }, {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_SIGN |
    huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_VERIFY
  }, {
    tag: huks.HuksTag.HUKS_TAG_DIGEST,
    value: huks.HuksKeyDigest.HUKS_DIGEST_SM3
  }];
  return properties;
}

function getSm2SignProperties() {
  let properties: huks.HuksParam[] = [{
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_SM2
  }, {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256
  }, {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_SIGN
  }, {
    tag: huks.HuksTag.HUKS_TAG_DIGEST,
    value: huks.HuksKeyDigest.HUKS_DIGEST_SM3
  }];
  return properties;
}

function getSm2VerifyProperties() {
  let properties: huks.HuksParam[] = [{
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_SM2
  }, {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256
  }, {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_VERIFY
  }, {
    tag: huks.HuksTag.HUKS_TAG_DIGEST,
    value: huks.HuksKeyDigest.HUKS_DIGEST_SM3
  }];
  return properties;
}

async function generateSm2Key(keyAlias: string) {
  let genProperties = getSm2GenerateProperties();
  let options: huks.HuksOptions = {
    properties: genProperties
  }
  await huks.generateKeyItem(keyAlias, options)
    .then((data) => {
      console.info(`promise: generate Sm2 Key success, data = ${JSON.stringify(data)}`);
    }).catch((err: Error) => {
      console.error(`promise: generate Sm2 Key failed, error: ` + JSON.stringify(err));
      throw (err as Error);
    })
}

async function sign(keyAlias: string, plaintext: string) {
  let signProperties = getSm2SignProperties();
  let options: huks.HuksOptions = {
    properties: signProperties,
    inData: stringToUint8Array(plaintext)
  }
  await huks.initSession(keyAlias, options)
    .then((data) => {
      handle = data.handle;
    }).catch((err: Error) => {
      console.error(`promise: init sign failed, error: ` + JSON.stringify(err));
      throw (err as Error);
    })
  await huks.finishSession(handle, options)
    .then((data) => {
      console.info(`promise: sign success, data is ` + uint8ArrayToString(data.outData as Uint8Array));
      signature = data.outData as Uint8Array;
    }).catch((err: Error) => {
      console.error(`promise: sign failed, error: ` + JSON.stringify(err));
      throw (err as Error);
    })
}

async function verify(keyAlias: string, plaintext: string, signature: Uint8Array) {
  let verifyProperties = getSm2VerifyProperties()
  let options: huks.HuksOptions = {
    properties: verifyProperties,
    inData: stringToUint8Array(plaintext)
  }
  await huks.initSession(keyAlias, options)
    .then((data) => {
      handle = data.handle;
    }).catch((err: Error) => {
      console.error(`promise: init verify failed, error: ` + JSON.stringify(err));
      throw (err as Error);
    })
  await huks.updateSession(handle, options)
    .then((data) => {
      console.info(`promise: update verify success, data is ` + uint8ArrayToString(data.outData as Uint8Array));
    }).catch((err: Error) => {
      console.error(`promise: update verify failed, error: ` + JSON.stringify(err));
      throw (err as Error);
    })
  options.inData = signature;
  await huks.finishSession(handle, options)
    .then((data) => {
      console.info(`promise: verify success, data is ` + uint8ArrayToString(data.outData as Uint8Array));
    }).catch((err: Error) => {
      console.error(`promise: verify failed, error: ` + JSON.stringify(err));
      throw (err as Error);
    })
}

async function deleteSm2Key(keyAlias: string) {
  let emptyOptions: huks.HuksOptions = {
    properties: []
  }
  await huks.deleteKeyItem(keyAlias, emptyOptions)
    .then((data) => {
      console.info(`promise: delete data success`);
    }).catch((err: Error) => {
      console.error(`promise: delete data failed`);
      throw (err as Error);
    })
}

export async function testSignVerify() {
  await generateSm2Key(keyAlias);
  await sign(keyAlias, plaintext);
  await verify(keyAlias, plaintext, signature);
  await deleteSm2Key(keyAlias);
}


// [End key_algorithm_SM2SM3]
@Entry
@Component
struct Index {
  @State message: string = 'SM2/SM3';

  build() {
    Column({ space: 12 }) {
      Text(this.message)
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(Infinity)
        .textAlign(TextAlign.Start)
      Button($r('app.string.sm2_sm3'))
        .padding('12vp')
        .height('40vp')
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
        .fontSize('14sp')
        .fontColor('#ffffff')
        .onClick(async () => {
          try {
            let ret = await testSignVerify();
            this.message = 'SM2/SM3 Result: Success';
          } catch {
            this.message = 'SM2/SM3 Result: Failed';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
