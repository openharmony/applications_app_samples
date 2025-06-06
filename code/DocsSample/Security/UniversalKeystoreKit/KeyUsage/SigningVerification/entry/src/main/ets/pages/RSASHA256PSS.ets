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
//
// [Start key_algorithm_RSASHA256PSS]
/*
 * 密钥算法为RSA，摘要算法为SHA256，填充模式为PSS
 */
import { huks } from '@kit.UniversalKeystoreKit';

let keyAlias = 'test_rsaKeyAlias';
let handle: number;
let plaintext = '123456';
let signature: Uint8Array;

function stringToUint8Array(str: string) {
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

function getRsaGenerateProperties() {
  let properties: huks.HuksParam[] = [{
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_RSA
  }, {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_RSA_KEY_SIZE_2048
  }, {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_SIGN |
    huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_VERIFY
  }, {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_PSS
  }, {
    tag: huks.HuksTag.HUKS_TAG_DIGEST,
    value: huks.HuksKeyDigest.HUKS_DIGEST_SHA256
  }];
  return properties;
}

function getRsaSignProperties() {
  let properties: huks.HuksParam[] = [{
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_RSA
  }, {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_PSS
  }, {
    tag: huks.HuksTag.HUKS_TAG_DIGEST,
    value: huks.HuksKeyDigest.HUKS_DIGEST_SHA256
  }, {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_SIGN
  }];
  return properties;
}

function getRsaVerifyProperties() {
  let properties: huks.HuksParam[] = [{
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_RSA
  }, {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_PSS
  }, {
    tag: huks.HuksTag.HUKS_TAG_DIGEST,
    value: huks.HuksKeyDigest.HUKS_DIGEST_SHA256
  }, {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_VERIFY
  }];
  return properties;
}

async function generateRsaKey(keyAlias: string) {
  let genProperties = getRsaGenerateProperties();
  let options: huks.HuksOptions = {
    properties: genProperties
  };
  await huks.generateKeyItem(keyAlias, options)
    .then((data) => {
      console.info(`promise: generate RSA Key success, data = ${JSON.stringify(data)}`);
    }).catch((err: Error) => {
      console.error(`promise: generate RSA Key failed, error: ` + JSON.stringify(err));
      throw (err as Error);
    });
}

async function sign(keyAlias: string, plaintext: string) {
  let signProperties = getRsaSignProperties();
  let options: huks.HuksOptions = {
    properties: signProperties,
    inData: stringToUint8Array(plaintext)
  }
  await huks.initSession(keyAlias, options)
    .then((data) => {
      handle = data.handle;
    }).catch((err: Error) => {
      console.error(`promise: init sign failed, error: ` + JSON.stringify(err));
      return;
    });

  if (handle !== undefined) {
    await huks.finishSession(handle, options)
      .then((data) => {
        console.info(`promise: sign success, data is ` + uint8ArrayToString(data.outData as Uint8Array));
        signature = data.outData as Uint8Array;
      }).catch((err: Error) => {
        console.error(`promise: sign failed, error: ` + JSON.stringify(err));
        throw (err as Error);
      });
  }
}

async function verify(keyAlias: string, plaintext: string, signature: Uint8Array) {
  let verifyProperties = getRsaVerifyProperties();
  let options: huks.HuksOptions = {
    properties: verifyProperties,
    inData: stringToUint8Array(plaintext)
  }
  await huks.initSession(keyAlias, options)
    .then((data) => {
      handle = data.handle;
    }).catch((err: Error) => {
      console.error(`promise: init verify failed, error: ` + JSON.stringify(err));
      return;
    });

  if (handle !== undefined) {
    await huks.updateSession(handle, options)
      .then((data) => {
        console.info(`promise: update verify success, data is ` + uint8ArrayToString(data.outData as Uint8Array));
      }).catch((err: Error) => {
        console.error(`promise: update verify failed, error: ` + JSON.stringify(err));
        throw (err as Error);
      });

    options.inData = signature;
    await huks.finishSession(handle, options)
      .then((data) => {
        console.info(`promise: verify success, data is ` + uint8ArrayToString(data.outData as Uint8Array));
      }).catch((err: Error) => {
        console.error(`promise: verify failed, error: ` + JSON.stringify(err));
        throw (err as Error);
      });
  }
}

async function deleteRsaKey(keyAlias: string) {
  let emptyOptions: huks.HuksOptions = {
    properties: []
  }
  await huks.deleteKeyItem(keyAlias, emptyOptions)
    .then((data) => {
      console.info(`promise: delete data success`);
    }).catch((err: Error) => {
      console.error(`promise: delete data failed`);
      throw (err as Error);
    });
}

export async function testSignVerify() {
  await generateRsaKey(keyAlias);
  await sign(keyAlias, plaintext);
  await verify(keyAlias, plaintext, signature);
  await deleteRsaKey(keyAlias);
}


// [End key_algorithm_RSASHA256PSS]
@Entry
@Component
struct Index {
  @State message: string = 'RSA/SHA256/PSS';

  build() {
    Column({ space: 12 }) {
      Text(this.message)
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(Infinity)
        .textAlign(TextAlign.Start)
      Button($r('app.string.rsa_sha256_pss'))
        .padding('12vp')
        .height('40vp')
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
        .fontSize('14sp')
        .fontColor('#ffffff')
        .onClick(async () => {
          try {
            await testSignVerify();
            this.message = 'RSA/SHA256/PSS Result: Success';
          }catch {
            this.message = 'RSA/SHA256/PSS Result: Failed';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
