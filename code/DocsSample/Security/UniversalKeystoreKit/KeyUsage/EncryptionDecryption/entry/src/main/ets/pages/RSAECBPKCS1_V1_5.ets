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
// [Start encrypt_and_decrypt_RSAECBPKCS1_V1_5]
/*
 * 以下以RSA/ECB/PKCS1_V1_5模式的Promise操作使用为例
 */
import { huks } from '@kit.UniversalKeystoreKit';

let rsaKeyAlias = 'test_rsaKeyAlias';
let handle: number;
let plainText = '123456';
let cipherData: Uint8Array;

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

function getRsaGenerateProperties() {
  let properties: huks.HuksParam[] = [{
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_RSA
  }, {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_RSA_KEY_SIZE_2048
  }, {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT |
    huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
  }];
  return properties;
}

function getRsaEncryptProperties() {
  let properties: huks.HuksParam[] = [{
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_RSA
  }, {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_RSA_KEY_SIZE_2048
  }, {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT
  }, {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_PKCS1_V1_5
  }, {
    tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
    value: huks.HuksCipherMode.HUKS_MODE_ECB
  }, {
    tag: huks.HuksTag.HUKS_TAG_DIGEST,
    value: huks.HuksKeyDigest.HUKS_DIGEST_NONE
  }];
  return properties;
}

function getRsaDecryptProperties() {
  let properties: huks.HuksParam[] = [{
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_RSA
  }, {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_RSA_KEY_SIZE_2048
  }, {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
  }, {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_PKCS1_V1_5
  }, {
    tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
    value: huks.HuksCipherMode.HUKS_MODE_ECB
  }, {
    tag: huks.HuksTag.HUKS_TAG_DIGEST,
    value: huks.HuksKeyDigest.HUKS_DIGEST_NONE
  }];
  return properties;
}

async function generateRsaKey() {
  /*
  * 模拟生成密钥场景
  * 1. 确定密钥别名
  */
  /*
  * 2. 获取生成密钥算法参数配置
  */
  let genProperties = getRsaGenerateProperties();
  let options: huks.HuksOptions = {
    properties: genProperties
  }
  /*
  * 3. 调用generateKeyItem
  */
  await huks.generateKeyItem(rsaKeyAlias, options)
    .then((data) => {
      console.info(`promise: generate RSA Key success, data = ${JSON.stringify(data)}`);
    }).catch((error: Error) => {
      console.error(`promise: generate RSA Key failed, ${JSON.stringify(error)}`);
      throw (error as Error);
    })
}

async function encryptData() {
  /*
  * 模拟加密场景
  * 1. 获取密钥别名
  */
  /*
  * 2. 获取待加密的数据
  */
  /*
  * 3. 获取加密算法参数配置
  */
  let encryptProperties = getRsaEncryptProperties();
  let options: huks.HuksOptions = {
    properties: encryptProperties,
    inData: stringToUint8Array(plainText)
  }
  /*
  * 4. 调用initSession获取handle
  */
  await huks.initSession(rsaKeyAlias, options)
    .then((data) => {
      handle = data.handle;
    }).catch((error: Error) => {
      console.error(`promise: init EncryptDataRsa failed, ${JSON.stringify(error)}`);
      throw (error as Error);
    })
  /*
  * 5. 调用finishSession获取加密后的密文
  */
  await huks.finishSession(handle, options)
    .then((data) => {
      console.info(`promise: encrypt data success, data is ` + uint8ArrayToString(data.outData as Uint8Array));
      cipherData = data.outData as Uint8Array;
    }).catch((error: Error) => {
      console.error(`promise: encrypt data failed, ${JSON.stringify(error)}`);
      throw (error as Error);
    })
}

async function decryptData() {
  /*
  * 模拟解密场景
  * 1. 获取密钥别名
  */
  /*
  * 2. 获取待解密的密文
  */
  /*
  * 3. 获取解密算法参数配置
  */
  let decryptOptions = getRsaDecryptProperties()
  let options: huks.HuksOptions = {
    properties: decryptOptions,
    inData: cipherData
  }
  /*
  * 4. 调用initSession获取handle
  */
  await huks.initSession(rsaKeyAlias, options)
    .then((data) => {
      handle = data.handle;
    }).catch((error: Error) => {
      console.error(`promise: init DecryptDataRsa failed, ${JSON.stringify(error)}`);
      throw (error as Error);
    })
  /*
  * 5. 调用finishSession获取解密后的数据
  */
  await huks.finishSession(handle, options)
    .then((data) => {
      console.info(`promise: decrypt data success, data is ` + uint8ArrayToString(data.outData as Uint8Array));
    }).catch((error: Error) => {
      console.error(`promise: decrypt data failed, ${JSON.stringify(error)}`);
      throw (error as Error);
    })
}

async function deleteKey() {
  /*
  * 模拟删除密钥场景
  * 1. 获取密钥别名
  */
  let emptyOptions: huks.HuksOptions = {
    properties: []
  }
  /*
  * 2. 调用deleteKeyItem删除密钥
  */
  await huks.deleteKeyItem(rsaKeyAlias, emptyOptions)
    .then((data) => {
      console.info(`promise: delete data success`);
    }).catch((error: Error) => {
      console.error(`promise: delete data failed, ${JSON.stringify(error)}`);
      throw (error as Error);
    })
}



// [End encrypt_and_decrypt_RSAECBPKCS1_V1_5]
@Entry
@Component
struct Index {
  @State message: string = 'RSA/ECB/PKCS1_V1_5';

  build() {
    Column({ space: 12 }) {
      Text(this.message)
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(Infinity)
        .textAlign(TextAlign.Start)
      Button($r('app.string.rsa_ecb_pkcs1_v1_5'))
        .padding('12vp')
        .height('40vp')
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
        .fontSize('14sp')
        .fontColor('#ffffff')
        .onClick(async () => {
          try {
            await generateRsaKey();
            await encryptData();
            await decryptData();
            let ret = await deleteKey();
            this.message = 'RSA/ECB/PKCS1_V1_5 Result: Success';
          } catch {
            this.message = 'RSA/ECB/PKCS1_V1_5 Result: Failed';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
