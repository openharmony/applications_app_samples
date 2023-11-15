/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import util from '@ohos.util';
import huks from '@ohos.security.huks';
import userAuth from '@ohos.userIAM.userAuth';
import promptAction from '@ohos.promptAction';
import Logger from './Logger';
import restrictions from '@ohos.enterprise.restrictions';

const TAG: string = '[HUKS]';
const CHALLENG_LEN = 6;
const ALWAYSVAILD = 4;
const ENCODEINTO_BUFFER = 20;
const DECRYPT_BYTE = 16;
const IV: string = (Math.floor(Math.random() * 1000000000000) + 1).toString();
let NONCE = '123456789012';
let AAD = '124567890123456';
let AEAD = '124567890123456';
let cipherData: Uint8Array;
let cipherDataString: string;
let challengeNew = new Uint8Array(CHALLENG_LEN);


// 密钥明文
let PLAIN_TEXT_SIZE_16 = new Uint8Array([
  0xfb, 0x8b, 0x9f, 0x12, 0xa0, 0x83, 0x19, 0xbe,
  0x64, 0x0b, 0x88, 0x96, 0xe2, 0xfa, 0x77, 0xbc
]);

function stringToUint8Array(str: string): Uint8Array {
  let arr = [];
  for (let i = 0, j = str.length; i < j; ++i) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
}

function uint8ArrayToString(fileData): string {
  let dataString = '';
  for (let i = 0; i < fileData.length; i++) {
    dataString += String.fromCharCode(fileData[i]);
  }
  return dataString;
}

function base64ToArrayBuffer(info): Uint8Array {
  return new util.Base64().decodeSync(info);
}

function base64ToString(byte): string {
  return new util.Base64().encodeToStringSync(byte);
}

function encodeInto(str: string): Uint8Array {
  let textEncoder = new util.TextEncoder();
  let buffer = new ArrayBuffer(ENCODEINTO_BUFFER);
  let result = new Uint8Array(buffer);
  result = textEncoder.encodeInto(str);

  console.info('retStr==' + result);
  return result;
}

// 生成Sm2密钥属性信息
function getSm2GenerateProperties(properties): void {
  let index = 0;
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_SM2
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_SM2_KEY_SIZE_256
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT |
    huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_CHALLENGE_TYPE,
    value: huks.HuksChallengeType.HUKS_CHALLENGE_TYPE_NORMAL
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_KEY_AUTH_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_USER_AUTH_TYPE,
    value: huks.HuksUserAuthType.HUKS_USER_AUTH_TYPE_PIN
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_KEY_AUTH_ACCESS_TYPE,
    value: ALWAYSVAILD
  };
  return;
}

// Sm2加密密钥属性信息
function getSm2EncryptProperties(properties): void {
  let index = 0;
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_SM2
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_SM2_KEY_SIZE_256
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_DIGEST,
    value: huks.HuksKeyDigest.HUKS_DIGEST_SM3
  };
  return;
}

// Sm2解密密钥属性信息
function getSm2DecryptProperties(properties): void {
  let index = 0;
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_SM2
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_SM2_KEY_SIZE_256
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_DIGEST,
    value: huks.HuksKeyDigest.HUKS_DIGEST_SM3
  };
  return;
}


// AES加密密钥属性信息
function getAesEncryptProperties(properties): void {
  let index = 0;
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_NONE
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
    value: huks.HuksCipherMode.HUKS_MODE_GCM
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_ASSOCIATED_DATA,
    value: stringToUint8Array(AAD)
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_NONCE,
    value: stringToUint8Array(NONCE)
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_AE_TAG,
    value: stringToUint8Array(AEAD)
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_IV,
    value: stringToUint8Array(IV)
  };
  return;
}

// AES解密密钥属性信息
function getAesDecryptProperties(properties, info): void {
  let index = 0;
  let t = base64ToArrayBuffer(info);
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_NONE
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
    value: huks.HuksCipherMode.HUKS_MODE_GCM
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_ASSOCIATED_DATA,
    value: stringToUint8Array(AAD)
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_NONCE,
    value: stringToUint8Array(NONCE)
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_AE_TAG,
    value: t.slice(t.length - DECRYPT_BYTE)
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_IV,
    value: stringToUint8Array(IV)
  };
  return;
}

// 生成AES密钥属性信息
function getAesGenerateProperties(properties): void {
  let index = 0;
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT |
    huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_NONE
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
    value: huks.HuksCipherMode.HUKS_MODE_GCM
  };
  return;
}

function getAesPublicProperties(properties) {
  let index = 0;
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_AES
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_128
  };
}

// 导入SM4密钥属性信息
function getImportKeyProperties(properties): void {
  let index = 0;
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_SM4
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_SM4_KEY_SIZE_128
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT |
    huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
  };
  return;
}

// SM4 加密密钥属性
function getSm4EnryptProperties(properties): void {
  let index = 0;
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_SM4
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_SM4_KEY_SIZE_128,
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
    value: huks.HuksCipherMode.HUKS_MODE_CBC
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_PKCS7
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_IV,
    value: stringToUint8Array(IV)
  };
  return;
}

// SM4 解密密钥属性
function getSm4DeryptProperties(properties): void {
  let index = 0;
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_SM4
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_SM4_KEY_SIZE_128,
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
    value: huks.HuksCipherMode.HUKS_MODE_CBC
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_PKCS7
  };
  properties[index++] = {
    tag: huks.HuksTag.HUKS_TAG_IV,
    value: stringToUint8Array(IV)
  };
  return;
}

/**
 * 功能模型
 */
export class HuksModel {
  // 模拟使用HUKS生成新密钥
  async encryptData(plainText: string, resultCallback): Promise<void> {
    let aesKeyAlias = 'test_aesKeyAlias';
    let handle;
    let generateKeyProperties = new Array();
    let publicProperties = new Array();
    getAesGenerateProperties(generateKeyProperties);
    getAesPublicProperties(publicProperties);
    let generateKeyOptions = {
      properties: publicProperties.concat(generateKeyProperties)
    };
    await huks.generateKeyItem(aesKeyAlias, generateKeyOptions).then((data) => {
      Logger.info(TAG, `generate key success, data: ${JSON.stringify(data)}`);
    }).catch((err) => {
      Logger.error(TAG, `generate key failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });

    // 模拟使用HUKS生成的新密钥加密
    let encryptProperties = new Array();
    getAesEncryptProperties(encryptProperties);
    let encryptOptions = {
      properties: publicProperties.concat(encryptProperties),
      inData: new Uint8Array(new Array())
    };
    await huks.initSession(aesKeyAlias, encryptOptions).then((data) => {
      Logger.info(TAG, `encrypt initSession success, data: ${JSON.stringify(data)}`);
      handle = data.handle;
    }).catch((err) => {
      Logger.error(TAG, `encrypt initSession failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });
    encryptOptions.inData = encodeInto(plainText);

    await huks.finishSession(handle, encryptOptions).then((data) => {
      Logger.info(TAG, `encrypt finishSession success, data: ${JSON.stringify(data)}`);
      cipherData = data.outData;
      cipherDataString = base64ToString(cipherData);
      let that = new util.Base64Helper();
      resultCallback(that.encodeToStringSync(cipherData));
    }).catch((err) => {
      Logger.error(TAG, `encrypt finishSession failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
      promptAction.showToast({
        message: `send message failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`,
        duration: 6500,
      });
    });
  }

  // 模拟使用HUKS生成的新密钥进行解密
  async decryptData(resultCallback): Promise<void> {
    let decryptOptions = new Array();
    let publicProperties = new Array();
    getAesDecryptProperties(decryptOptions, cipherDataString);
    getAesPublicProperties(publicProperties);
    let aesKeyAlias = 'test_aesKeyAlias';
    let handle;
    let t = base64ToArrayBuffer(cipherDataString);
    let options = {
      properties: publicProperties.concat(decryptOptions),
      inData: base64ToArrayBuffer(cipherDataString)
    };
    let emptyOptions = {
      properties: []
    };

    await huks.initSession(aesKeyAlias, options).then((data) => {
      Logger.info(TAG, `decrypt initSession success, data: ${JSON.stringify(data)}`);
      handle = data.handle;
    }).catch((err) => {
      Logger.error(TAG, `decrypt initSession failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });
    options.inData = base64ToArrayBuffer(cipherDataString).slice(0, t.length - DECRYPT_BYTE);

    await huks.finishSession(handle, options).then((data) => {
      Logger.info(TAG, `decrypt finishSession success, data: ${JSON.stringify(data)}`);
      resultCallback(uint8ArrayToString(data.outData));
    }).catch((err) => {
      Logger.error(TAG, `decrypt finishSession failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
      promptAction.showToast({
        message: `receive message failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`,
        duration: 6500,
      });
    });
    await huks.deleteKeyItem(aesKeyAlias, emptyOptions).then((data) => {
      Logger.info(TAG, `delete key success, data: ${JSON.stringify(data)}`);
    }).catch((err) => {
      Logger.error(TAG, `delete key failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });
  }

  // 模拟使用Sm2 生成密钥并进行加密
  async encryptDataUseSm2(plainText: string, resultCallback): Promise<void> {
    let sm2KeyAlias = 'test_sm2KeyAlias';
    let handle;
    let generateKeyProperties = new Array();
    getSm2GenerateProperties(generateKeyProperties);
    let generateKeyOptions = {
      properties: generateKeyProperties
    };
    await huks.generateKeyItem(sm2KeyAlias, generateKeyOptions).then((data) => {
      Logger.info(TAG, `generate key success, data: ${JSON.stringify(data)}`);
    }).catch((err) => {
      Logger.error(TAG, `generate key failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });

    let encryptProperties = new Array();
    getSm2EncryptProperties(encryptProperties);
    let encryptOptions = {
      properties: encryptProperties,
      inData: stringToUint8Array(plainText)
    };
    await huks.initSession(sm2KeyAlias, encryptOptions).then((data) => {
      Logger.info(TAG, `encrypt initSession success, data: ${JSON.stringify(data)}`);
      handle = data.handle;
    }).catch((err) => {
      Logger.error(TAG, `encrypt initSession failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });
    await huks.finishSession(handle, encryptOptions).then((data) => {
      Logger.info(TAG, `encrypt finishSession success, data: ${JSON.stringify(data)}`);
      cipherData = data.outData;
      let that = new util.Base64Helper();
      resultCallback(that.encodeToStringSync(cipherData));
    }).catch((err) => {
      Logger.error(TAG, `encrypt finishSession failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
      promptAction.showToast({
        message: `send message failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`,
        duration: 6500,
      });
    });
  }

  async finishSession(handle, options, resultCallback, authToken: Uint8Array): Promise<void> {
    await huks.finishSession(handle, options, authToken).then((data) => {
      Logger.info(TAG, `decrypt finishSession success, data: ${JSON.stringify(data)}`);
      resultCallback(uint8ArrayToString(data.outData));
    }).catch((err) => {
      Logger.error(TAG, `decrypt finishSession failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
      promptAction.showToast({
        message: `receive message failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`,
        duration: 6500,
      });
    });
  }

  async userIAMAuthFinger(finishSessionFunction, param): Promise<void> {
    Logger.info(TAG, '[HUKS->userIAM]start userAuth...');
    const authParam: userAuth.AuthParam = {
      challenge: challengeNew,
      authType: [userAuth.UserAuthType.PIN],
      authTrustLevel: userAuth.AuthTrustLevel.ATL1
    };
    const widgetParam: userAuth.WidgetParam = {
      title: 'PIN'
    };
    try {
      let userAuthInstance = await userAuth.getUserAuthInstance(authParam, widgetParam);
      Logger.info(TAG, 'get userAuth instance success');
      await userAuthInstance.on('result', {
        onResult(result) {
          Logger.info(TAG, 'userAuthInstance callback result = ' + JSON.stringify(result));
          finishSessionFunction(param.handleParam, param.optionsParam, param.resultCallbackParam, result.token);
        }
      });
      Logger.info(TAG, 'auth on success');
      await userAuthInstance.start();
      Logger.info(TAG, 'auth on success');
    } catch (error) {
      Logger.error(TAG, 'auth catch error: ' + JSON.stringify(error));
    }
  }

  // 模拟使用HUKS生成的新密钥进行低安访问控制与解密
  async decryptDataUseSm2(resultCallback): Promise<void> {
    let decryptOptions = new Array();
    getSm2DecryptProperties(decryptOptions);
    let sm2KeyAlias = 'test_sm2KeyAlias';
    let handle;
    let options = {
      properties: decryptOptions,
      inData: cipherData
    };
    let emptyOptions = {
      properties: []
    };
    await huks.initSession(sm2KeyAlias, options).then((data) => {
      Logger.info(TAG, `decrypt initSession success, data: ${JSON.stringify(data)}`);
      handle = data.handle;
      challengeNew = data.challenge;
    }).catch((err) => {
      Logger.error(TAG, `decrypt initSession failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });
    let finishSessionFunction = this.finishSession;
    let param = {
      handleParam: handle,
      optionsParam: options,
      resultCallbackParam: resultCallback,
    };
    await this.userIAMAuthFinger(finishSessionFunction, param);
  }


  // 模拟设备1使用旧密钥在本地进行加密
  async encryptDataUserOldKey(plainText: string, resultCallback): Promise<void> {
    let device1KeyAlias = 'device_1_key_alias';
    let importKeyProperties = new Array();
    getImportKeyProperties(importKeyProperties);
    let importKeyOptions = {
      properties: importKeyProperties,
      inData: PLAIN_TEXT_SIZE_16
    };
    Logger.info(TAG, `key plain text: ${JSON.stringify(PLAIN_TEXT_SIZE_16)}`);
    await huks.importKeyItem(device1KeyAlias, importKeyOptions).then((data) => {
      Logger.info(TAG, `import key success, data: ${JSON.stringify(data)}`);
    }).catch((err) => {
      Logger.error(TAG, `import key failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });

    // 加密
    let sm4EncryptProperties = new Array();
    getSm4EnryptProperties(sm4EncryptProperties);
    let sm4EncryptOptions = {
      properties: sm4EncryptProperties,
      inData: stringToUint8Array(plainText)
    };
    let handle;
    await huks.initSession(device1KeyAlias, sm4EncryptOptions).then((data) => {
      Logger.info(TAG, `encrypt initSession success, data: ${JSON.stringify(data)}`);
      handle = data.handle;
    }).catch((err) => {
      Logger.error(TAG, `encrypt initSession failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });
    await huks.finishSession(handle, sm4EncryptOptions).then((data) => {
      Logger.info(TAG, `encrypt finishSession success, data: ${JSON.stringify(data)}`);
      cipherData = data.outData;
      let that = new util.Base64Helper();
      resultCallback(that.encodeToStringSync(cipherData));
    }).catch((err) => {
      Logger.error(TAG, `send message failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
      promptAction.showToast({
        message: `send message failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`,
        duration: 6500,
      });
    });

    // 加密完成删除本地密钥
    let emptyOptions = {
      properties: []
    };
    await huks.deleteKeyItem(device1KeyAlias, emptyOptions).then((data) => {
      Logger.info(TAG, `delete key success, data: ${JSON.stringify(data)}`);
    }).catch((err) => {
      Logger.error(TAG, `delete key failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });
  }

  // 模拟设备2导入设备1中的旧密钥
  async importKey(): Promise<void> {
    let keyAlias = 'import_device_1_key_alias';
    let importOptions = new Array();
    getImportKeyProperties(importOptions);
    let huksoptions = {
      properties: importOptions,
      inData: PLAIN_TEXT_SIZE_16
    };
    Logger.info(TAG, `key plain text: ${JSON.stringify(PLAIN_TEXT_SIZE_16)}`);
    await huks.importKeyItem(keyAlias, huksoptions).then((data) => {
      Logger.info(TAG, `import key success, data: ${JSON.stringify(data)}`);
      promptAction.showToast({
        message: 'import old key success',
        duration: 1000,
      });
    }).catch((err) => {
      Logger.error(TAG, `import old key failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
      promptAction.showToast({
        message: `import old key failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`,
        duration: 1000,
      });
    });
  }

  // 模拟设备2使用导入的设备1中的旧密钥进行解密
  async decryptDataUserOldKey(resultCallback): Promise<void> {
    let handle;
    let keyAlias = 'import_device_1_key_alias';
    let decryptProperties = new Array();
    getSm4DeryptProperties(decryptProperties);
    let decryptOptions = {
      properties: decryptProperties,
      inData: cipherData
    };

    // 解密
    await huks.initSession(keyAlias, decryptOptions).then((data) => {
      Logger.info(TAG, `decrypt initSession success, data: ${JSON.stringify(data)}`);
      handle = data.handle;
    }).catch((err) => {
      Logger.error(TAG, `decrypt initSession failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });
    await huks.finishSession(handle, decryptOptions).then((data) => {
      Logger.info(TAG, `decrypt finishSession success, data: ${JSON.stringify(data)}`);
      resultCallback(uint8ArrayToString(data.outData));
    }).catch((err) => {
      Logger.error(TAG, `receive message failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
      promptAction.showToast({
        message: `receive message failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`,
        duration: 6500,
      });
    });

    // 解密完成删除本地密钥
    let emptyOptions = {
      properties: []
    };
    await huks.deleteKeyItem(keyAlias, emptyOptions).then((data) => {
      Logger.info(TAG, `delete key success, data: ${JSON.stringify(data)}`);
    }).catch((err) => {
      Logger.error(TAG, `delete key failed, ${JSON.stringify(err.code)}: ${JSON.stringify(err.message)}`);
    });
  }
}