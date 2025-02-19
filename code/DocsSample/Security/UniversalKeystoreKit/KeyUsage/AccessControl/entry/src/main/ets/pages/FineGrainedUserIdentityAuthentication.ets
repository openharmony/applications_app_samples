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

import { huks } from '@kit.UniversalKeystoreKit';
import { userAuth } from '@kit.UserAuthenticationKit';
import { BusinessError } from '@kit.BasicServicesKit';

let keyAlias = 'test_sm4_key_alias';
let cipherInData = 'Hks_SM4_Cipher_Test_101010101010101010110_string'; // 明文数据。
let IV = '1234567890123456';
let handle = 0;
let cipherText: Uint8Array; // 密文数据。
let finishOutData: Uint8Array; // 解密后的明文数据。
let authToken: Uint8Array;
let challenge: Uint8Array;
let authType = userAuth.UserAuthType.PIN;
let authTrustLevel = userAuth.AuthTrustLevel.ATL1;

class ThrowObject {
  public isThrow: boolean = false;
}

function stringToUint8Array(str: string) {
  let arr: number[] = [];
  for (let i = 0, j = str.length; i < j; ++i) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
}

/*
 * 确定封装密钥属性参数集
 */
let generateProperties: huks.HuksParam[] = [
  {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_SM4,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT | huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_SM4_KEY_SIZE_128,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
    value: huks.HuksCipherMode.HUKS_MODE_CBC,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_NONE,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_USER_AUTH_TYPE,
    value: huks.HuksUserAuthType.HUKS_USER_AUTH_TYPE_PIN
  },
  {
    tag: huks.HuksTag.HUKS_TAG_KEY_AUTH_ACCESS_TYPE,
    value: huks.HuksAuthAccessType.HUKS_AUTH_ACCESS_INVALID_CLEAR_PASSWORD
  },
  {
    tag: huks.HuksTag.HUKS_TAG_CHALLENGE_TYPE,
    value: huks.HuksChallengeType.HUKS_CHALLENGE_TYPE_NORMAL
  },
  {
    tag: huks.HuksTag.HUKS_TAG_KEY_AUTH_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
  }
];

let generateHuksOptions: huks.HuksOptions = {
  properties: generateProperties,
  inData: new Uint8Array([])
}

/*
 * 生成密钥
 */
async function generateKeyItem(keyAlias: string, huksOptions: huks.HuksOptions, throwObject: ThrowObject) {
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
      throwObject.isThrow = true;
      throw (error as Error);
    }
  });
}

async function publicGenKeyFunc(keyAlias: string, huksOptions: huks.HuksOptions) {
  console.info(`enter promise generateKeyItem`);
  let throwObject: ThrowObject = { isThrow: true };
  try {
    await generateKeyItem(keyAlias, huksOptions, throwObject)
      .then((data) => {
        console.info(`promise: generateKeyItem success, data = ${JSON.stringify(data)}`);
      })
      .catch((error: Error) => {
        if (throwObject.isThrow) {
          throw (error as Error);
        } else {
          console.error(`promise: generateKeyItem failed` + JSON.stringify(error));
        }
      });
  } catch (error) {
    console.error(`promise: generateKeyItem input arg invalid` + JSON.stringify(error));
    throw (error as Error);
  }
}

async function testGenKeyForFingerprintAccessControl() {
  await publicGenKeyFunc(keyAlias, generateHuksOptions);
}

class HuksProperties {
  public tag: huks.HuksTag = huks.HuksTag.HUKS_TAG_ALGORITHM;
  public value: huks.HuksKeyAlg | huks.HuksKeySize | huks.HuksKeyPurpose | huks.HuksKeyPadding | huks.HuksCipherMode
    | Uint8Array = huks.HuksKeyAlg.HUKS_ALG_ECC;
}

/*
 * 确定封装密钥属性参数集
 */

/* 集成生成密钥参数集 & 加密参数集 */
let propertiesEncrypt: HuksProperties[] = [
  {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_SM4,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_SM4_KEY_SIZE_128,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_NONE,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
    value: huks.HuksCipherMode.HUKS_MODE_CBC,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_IV,
    value: stringToUint8Array(IV),
  }
];
let encryptOptions: huks.HuksOptions = {
  properties: propertiesEncrypt,
  inData: new Uint8Array([])
}

function initSession(keyAlias: string, huksOptions: huks.HuksOptions, throwObject: ThrowObject) {
  return new Promise<huks.HuksSessionHandle>((resolve, reject) => {
    try {
      huks.initSession(keyAlias, huksOptions, (error, data) => {
        if (error) {
          reject(error);
        } else {
          resolve(data);
        }
      });
    } catch (error) {
      throwObject.isThrow = true;
      throw (error as Error);
    }
  });
}

async function publicInitFunc(keyAlias: string, huksOptions: huks.HuksOptions) {
  console.info(`enter promise doInit`);
  let throwObject: ThrowObject = { isThrow: true };
  try {
    await initSession(keyAlias, huksOptions, throwObject)
      .then((data) => {
        console.info(`promise: doInit success, data = ${JSON.stringify(data)}`);
        handle = data.handle as number;
        challenge = data.challenge as Uint8Array;
      })
      .catch((error: Error) => {
        if (throwObject.isThrow) {
          throw (error as Error);
        } else {
          console.error(`promise: doInit failed` + JSON.stringify(error));
        }
      });
  } catch (error) {
    console.error(`promise: doInit input arg invalid` + JSON.stringify(error));
    throw (error as Error);
  }
}

function finishEncryptSession(handle: number, huksOptions: huks.HuksOptions, throwObject: ThrowObject) {
  return new Promise<huks.HuksReturnResult>((resolve, reject) => {
    try {
      huks.finishSession(handle, huksOptions, (error, data) => {
        if (error) {
          reject(error);
        } else {
          resolve(data);
        }
      });
    } catch (error) {
      throwObject.isThrow = true;
      throw (error as Error);
    }
  });
}

async function publicEncryptFinishFunc(handle: number, huksOptions: huks.HuksOptions) {
  console.info(`enter promise doFinish`);
  let throwObject: ThrowObject = { isThrow: true };
  try {
    await finishEncryptSession(handle, huksOptions, throwObject)
      .then((data) => {
        cipherText = data.outData as Uint8Array;
        console.info(`promise: doFinish success, data = ${JSON.stringify(data)}`);
      })
      .catch((error: Error) => {
        if (throwObject.isThrow) {
          throw (error as Error);
        } else {
          console.error(`promise: doFinish failed` + JSON.stringify(error));
        }
      });
  } catch (error) {
    console.error(`promise: doFinish input arg invalid` + JSON.stringify(error));
    throw (error as Error);
  }
}

async function testSm4Cipher() {
  /* 初始化密钥会话获取挑战值 */
  await publicInitFunc(keyAlias, encryptOptions);
  /* 加密 */
  encryptOptions.inData = stringToUint8Array(cipherInData);
  await publicEncryptFinishFunc(handle, encryptOptions);
}

/* 集成生成密钥参数集 & 加密参数集 */
class PropertyDecryptType {
  public tag: huks.HuksTag = huks.HuksTag.HUKS_TAG_ALGORITHM
  public value: huks.HuksKeyAlg | huks.HuksKeyPurpose | huks.HuksKeySize | huks.HuksKeyPadding | huks.HuksCipherMode
    | Uint8Array = huks.HuksKeyAlg.HUKS_ALG_SM4
}

let propertiesDecrypt: PropertyDecryptType[] = [
  {
    tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
    value: huks.HuksKeyAlg.HUKS_ALG_SM4,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_PURPOSE,
    value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
    value: huks.HuksKeySize.HUKS_SM4_KEY_SIZE_128,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_PADDING,
    value: huks.HuksKeyPadding.HUKS_PADDING_NONE,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
    value: huks.HuksCipherMode.HUKS_MODE_CBC,
  },
  {
    tag: huks.HuksTag.HUKS_TAG_IV,
    value: stringToUint8Array(IV),
  }
]
let decryptOptions: huks.HuksOptions = {
  properties: propertiesDecrypt,
  inData: new Uint8Array([])
}

function userIAMAuthFinger(huksChallenge: Uint8Array) {
  // 获取认证对象。
  let authTypeList: userAuth.UserAuthType[] = [authType];
  const authParam: userAuth.AuthParam = {
    challenge: huksChallenge,
    authType: authTypeList,
    authTrustLevel: authTrustLevel
  };
  const widgetParam: userAuth.WidgetParam = {
    title: 'PIN',
  };
  let auth: userAuth.UserAuthInstance;
  try {
    auth = userAuth.getUserAuthInstance(authParam, widgetParam);
    console.info('get auth instance success');
  } catch (error) {
    console.error('get auth instance failed' + JSON.stringify(error));
    throw (error as Error);
  }
  // 订阅认证结果。
  try {
    auth.on('result', {
      onResult(result) {
        console.info('[HUKS] -> [IAM]  userAuthInstance callback result = ' + JSON.stringify(result));
        authToken = result.token;
        testSm4CipherFinish();
      }
    });
    console.info('subscribe authentication event success');
  } catch (error) {
    console.error('subscribe authentication event failed ' + JSON.stringify(error));
    throw (error as Error);
  }
  // 开始认证。
  try {
    auth.start();
    console.info('authV9 start auth success');
  } catch (error) {
    console.error('authV9 start auth failed, error = ' + JSON.stringify(error));
    throw (error as Error);
  }
}

function finishDecryptSession(handle: number, huksOptions: huks.HuksOptions, token: Uint8Array,
  throwObject: ThrowObject) {
  return new Promise<huks.HuksReturnResult>((resolve, reject) => {
    try {
      huks.finishSession(handle, huksOptions, token, (error, data) => {
        if (error) {
          reject(error);
        } else {
          resolve(data);
        }
      });
    } catch (error) {
      throwObject.isThrow = true;
      throw (error as Error);
    }
  });
}

async function publicDecryptFinishFunc(handle: number, token: Uint8Array, huksOptions: huks.HuksOptions) {
  console.info(`enter promise doFinish`);
  let throwObject: ThrowObject = { isThrow: true };
  try {
    await finishDecryptSession(handle, huksOptions, token, throwObject)
      .then((data) => {
        finishOutData = data.outData as Uint8Array;
        console.info(`promise: doFinish success, data = ${JSON.stringify(data)}`);
      })
      .catch((error: BusinessError) => {
        if (throwObject.isThrow) {
          throw (error as Error);
        } else {
          console.error(`promise: doFinish failed` + JSON.stringify(error));
        }
      });
  } catch (error) {
    console.error(`promise: doFinish input arg invalid` + JSON.stringify(error));
    throw (error as Error);
  }
}

async function testSm4CipherInit() {
  /* 初始化密钥会话获取挑战值 */
  await publicInitFunc(keyAlias, decryptOptions);
  /* 调用userIAM进行身份认证 */
  console.log('challenge value: ' + challenge.toString());
  userIAMAuthFinger(challenge);
}

async function testSm4CipherFinish() {
  /* 认证成功后进行解密, 需要传入Auth获取到的authToken值 */
  decryptOptions.inData = cipherText;
  await publicDecryptFinishFunc(handle, authToken, decryptOptions);
  if (finishOutData === stringToUint8Array(cipherInData)) {
    console.error('test finish decrypt error');
  } else {
    console.info('test finish decrypt success');
  }
}

async function main() {
  await testGenKeyForFingerprintAccessControl();
  await testSm4Cipher();
  await testSm4CipherInit();
}

@Entry
@Component
struct Index {
  @State message: string = 'FineGrainedUserIdentityAuthentication';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.fine_grained_user_identity_authentication_call'))
        .width('70%')
        .onClick(async () => {
          try {
            await main();
            this.message = 'Call Result: Success';
          } catch (error) {
            this.message = 'Call Result: Failed' + error.message;
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
