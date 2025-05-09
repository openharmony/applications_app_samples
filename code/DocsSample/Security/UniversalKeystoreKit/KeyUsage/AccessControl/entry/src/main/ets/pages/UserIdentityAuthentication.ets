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


// [Start user_authentication_and_access_control_guide]
import { huks } from '@kit.UniversalKeystoreKit';
import { userAuth } from '@kit.UserAuthenticationKit';

/*
* 确定密钥别名和封装密钥属性参数集
*/
let keyAlias = 'test_sm4_key_alias';
let IV = '1234567890123456';
let handle: number;
let challenge: Uint8Array;
let fingerAuthToken: Uint8Array;
let authType = userAuth.UserAuthType.PIN;
let authTrustLevel = userAuth.AuthTrustLevel.ATL1;
let cipherInData = 'Hks_SM4_Cipher_Test_101010101010101010110_string';
let finishOutData: Uint8Array;

class ThrowObject {
  public isThrow: boolean = false;
}

let generateProperties: huks.HuksParam[] = [{
  tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
  value: huks.HuksKeyAlg.HUKS_ALG_SM4
}, {
  tag: huks.HuksTag.HUKS_TAG_PURPOSE,
  value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT | huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT
}, {
  tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
  value: huks.HuksKeySize.HUKS_SM4_KEY_SIZE_128,
}, {
  tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
  value: huks.HuksCipherMode.HUKS_MODE_CBC,
}, {
  tag: huks.HuksTag.HUKS_TAG_PADDING,
  value: huks.HuksKeyPadding.HUKS_PADDING_NONE,
},
  // 指定密钥身份认证的类型：PIN。
  {
    tag: huks.HuksTag.HUKS_TAG_USER_AUTH_TYPE,
    value: huks.HuksUserAuthType.HUKS_USER_AUTH_TYPE_PIN
  },
  // 指定密钥安全授权的类型（失效类型）：新录入生物特征（PIN）后无效。
  {
    tag: huks.HuksTag.HUKS_TAG_KEY_AUTH_ACCESS_TYPE,
    value: huks.HuksAuthAccessType.HUKS_AUTH_ACCESS_INVALID_CLEAR_PASSWORD
  },
  // 指定挑战值的类型：默认类型。
  {
    tag: huks.HuksTag.HUKS_TAG_CHALLENGE_TYPE,
    value: huks.HuksChallengeType.HUKS_CHALLENGE_TYPE_NORMAL
  }];

let generateHuksOptions: huks.HuksOptions = {
  properties: generateProperties,
  inData: new Uint8Array([])
}

/*
 * 生成密钥
 */

function generateKeyItem(keyAlias: string, huksOptions: huks.HuksOptions, throwObject: ThrowObject) {
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
          console.error(`promise: generateKeyItem failed, ` + JSON.stringify(error));
          throw (error as Error);
        } else {
        }
      });
  } catch (error) {
    console.error(`promise: generateKeyItem input arg invalid, ` + JSON.stringify(error));
    throw (error as Error);
  }
}

async function testGenKeyForFingerprintAccessControl() {
  await publicGenKeyFunc(keyAlias, generateHuksOptions);
}

/* 集成生成密钥参数集 & 加密参数集 */
let initProperties: huks.HuksParam[] = [{
  tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
  value: huks.HuksKeyAlg.HUKS_ALG_SM4,
}, {
  tag: huks.HuksTag.HUKS_TAG_PURPOSE,
  value: huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT,
}, {
  tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
  value: huks.HuksKeySize.HUKS_SM4_KEY_SIZE_128,
}, {
  tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
  value: huks.HuksCipherMode.HUKS_MODE_CBC,
}, {
  tag: huks.HuksTag.HUKS_TAG_PADDING,
  value: huks.HuksKeyPadding.HUKS_PADDING_NONE,
}, {
  tag: huks.HuksTag.HUKS_TAG_IV,
  value: stringToUint8Array(IV),
}];

let initHuksOptions: huks.HuksOptions = {
  properties: initProperties,
  inData: new Uint8Array([])
}

function stringToUint8Array(str: string) {
  let arr: number[] = [];
  for (let i = 0, j = str.length; i < j; ++i) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
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

/* 初始化HUKS中的会话，获取挑战值 */
async function publicInitFunc(keyAlias: string, huksOptions: huks.HuksOptions) {
  console.info(`enter promise doInit`);
  let throwObject: ThrowObject = { isThrow: true };
  try {
    await initSession(keyAlias, huksOptions, throwObject)
      .then((data) => {
        console.info(`promise: doInit success, data = ${JSON.stringify(data)}`);
        handle = data.handle;
        challenge = data.challenge as Uint8Array;
      })
      .catch((error: Error) => {
        if (throwObject.isThrow) {
          throw (error as Error);
        } else {
          console.error(`promise: doInit failed, ` + JSON.stringify(error));
        }
      });
  } catch (error) {
    console.error(`promise: doInit input arg invalid, ` + JSON.stringify(error));
    throw (error as Error);
  }
}

/* 调用UserIAM拉起认证，触发HUKS的访问控制流程 */
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
        fingerAuthToken = result.token;
        testSm4Cipher();
      }
    });
    console.log('subscribe authentication event success');
  } catch (error) {
    console.error('subscribe authentication event failed, ' + JSON.stringify(error));
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

async function testInitAndAuthFinger() {
  /* 初始化密钥会话获取挑战值 */
  await publicInitFunc(keyAlias, initHuksOptions);
  /* 调用userIAM进行身份认证 */
  console.log('challenge value: ' + challenge.toString());
  userIAMAuthFinger(challenge);
}

/* 集成生成密钥参数集 & 加密参数集 */
class PropertyEncryptType {
  public tag: huks.HuksTag = huks.HuksTag.HUKS_TAG_ALGORITHM;
  public value: huks.HuksKeyAlg | huks.HuksKeyPurpose | huks.HuksKeySize | huks.HuksKeyPadding | huks.HuksCipherMode
    | Uint8Array = huks.HuksKeyAlg.HUKS_ALG_SM4;
}

let propertiesEncrypt: PropertyEncryptType[] = [
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
]
let encryptOptions: huks.HuksOptions = {
  properties: propertiesEncrypt,
  inData: new Uint8Array([])
}

function updateSession(handle: number, huksOptions: huks.HuksOptions, token: Uint8Array, throwObject: ThrowObject) {
  return new Promise<huks.HuksReturnResult>((resolve, reject) => {
    try {
      huks.updateSession(handle, huksOptions, token, (error, data) => {
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

async function publicUpdateFunc(handle: number, token: Uint8Array, huksOptions: huks.HuksOptions) {
  console.info(`enter promise doUpdate`);
  let throwObject: ThrowObject = { isThrow: true };
  console.log('token value[publicUpdateFunc]:' + token)
  try {
    await updateSession(handle, huksOptions, token, throwObject)
      .then((data) => {
        console.info(`promise: doUpdate success, data = ${JSON.stringify(data)}`);
      })
      .catch((error: Error) => {
        if (throwObject.isThrow) {
          throw (error as Error);
        } else {
          console.error(`promise: doUpdate failed, ` + JSON.stringify(error));
        }
      });
  } catch (error) {
    console.error(`promise: doUpdate input arg invalid, ` + JSON.stringify(error));
    throw (error as Error);
  }
}

function finishSession(handle: number, huksOptions: huks.HuksOptions, token: Uint8Array, throwObject: ThrowObject) {
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

async function publicFinishFunc(handle: number, token: Uint8Array, huksOptions: huks.HuksOptions) {
  console.info(`enter promise doFinish`);
  let throwObject: ThrowObject = { isThrow: false };
  console.log('token value[publicFinishFunc]:' + token)
  try {
    await finishSession(handle, huksOptions, token, throwObject)
      .then((data) => {
        finishOutData = data.outData as Uint8Array;
        console.info(`promise: doFinish success, data = ${JSON.stringify(data)}`);
      })
      .catch((error: Error) => {
        if (throwObject.isThrow) {
          throw (error as Error);
        } else {
          console.error(`promise: doFinish failed, ` + JSON.stringify(error));
        }
      });
  } catch (error) {
    console.error(`promise: doFinish input arg invalid, ` + JSON.stringify(error));
    throw (error as Error);
  }
}

async function testSm4Cipher() {
  encryptOptions.inData = stringToUint8Array(cipherInData);
  /* 传入认证令牌 */
  await publicUpdateFunc(handle, fingerAuthToken, encryptOptions);
  /* 传入认证令牌 */
  console.log('continue publicFinishFunc');
  await publicFinishFunc(handle, fingerAuthToken, encryptOptions);
  console.log('end publicFinishFunc');
  if (finishOutData === stringToUint8Array(cipherInData)) {
    console.error('test finish encrypt error');
  } else {
    console.info('test finish encrypt success');
  }
}
// [End user_authentication_and_access_control_guide]
async function main() {
  await testGenKeyForFingerprintAccessControl();
  await testInitAndAuthFinger();
}

@Entry
@Component
struct Index {
  @State message: string = 'UserIdentityAuthentication';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20)
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(Infinity)
        .textAlign(TextAlign.Start)
      Button($r('app.string.user_identity_authentication'))
        .padding('12vp')
        .height('40vp')
        .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
        .backgroundColor($r('sys.color.ohos_id_color_emphasize'))
        .fontSize('14sp')
        .fontColor('#ffffff')
        .onClick(async () => {
          try {
            await main();
            this.message = 'Call Result: Success';
          } catch (error) {
            this.message = 'Call Result: Failed';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
