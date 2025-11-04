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

// [Start generate_key_specify_fingerprint_access_control_and_auth_purpose]
import { huks } from '@kit.UniversalKeystoreKit';
import { userAuth } from '@kit.UserAuthenticationKit';
import { BusinessError } from '@kit.BasicServicesKit';

const KEY_ALIAS = 'test_sm4_key_alias';
const CIPHER_IN_DATA = 'Hks_SM4_Cipher_Test_101010101010101010110_string'; // 明文数据
const IV = '1234567890123456'; // 初始化向量
const AUTH_TYPE = userAuth.UserAuthType.PIN; // 认证类型：PIN码
const AUTH_TRUST_LEVEL = userAuth.AuthTrustLevel.ATL1; // 认证信任级别

let sessionHandle = 0; // 会话句柄
let challenge: Uint8Array; // 挑战值
let authToken: Uint8Array; // 认证令牌
let encryptedData: Uint8Array; // 加密后的密文
let decryptedData: Uint8Array; // 解密后的明文

class ThrowObject {
  public isThrow: boolean = false;
}

function stringToUint8Array(str: string): Uint8Array {
  let arr: number[] = [];
  for (let i = 0, j = str.length; i < j; ++i) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
}

// ============================================================================
// 步骤1：密钥生成模块
// 功能：生成带用户认证要求的SM4密钥
// ============================================================================

const KEY_GENERATION_PROPERTIES: huks.HuksParam[] = [
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

/**
 * 生成密钥
 */
function generateKeyItem(keyAlias: string, huksOptions: huks.HuksOptions, throwObject: ThrowObject): Promise<void> {
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
      const err = error instanceof Error ? error : new Error(String(error));
      throw err;
    }
  });
}

/**
 * 步骤1：生成SM4密钥
 * 该密钥具有用户认证保护，解密时需要PIN码认证
 */
async function step1_GenerateKey(): Promise<void> {
  const generateOptions: huks.HuksOptions = {
    properties: KEY_GENERATION_PROPERTIES,
    inData: new Uint8Array([])
  };

  let throwObject: ThrowObject = { isThrow: true };
  try {
    await generateKeyItem(KEY_ALIAS, generateOptions, throwObject)
      .then((data) => {
        console.info(`密钥生成成功: ${JSON.stringify(data)}`);
      })
      .catch((error: Error) => {
        if (throwObject.isThrow) {
          const err = error instanceof Error ? error : new Error(String(error));
          throw err;
        } else {
          console.error(`密钥生成失败: ${JSON.stringify(error)}`);
        }
      });
  } catch (error) {
    console.error(`密钥生成参数无效: ${JSON.stringify(error)}`);
    const err = error instanceof Error ? error : new Error(String(error));
    throw err;
  }
}

// ============================================================================
// 步骤2：加密模块
// 功能：使用生成的SM4密钥对数据进行加密
// ============================================================================
const ENCRYPTION_PROPERTIES: huks.HuksParam[] = [
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

/**
 * 初始化加密会话
 */
function initEncryptSession(keyAlias: string, huksOptions: huks.HuksOptions, throwObject: ThrowObject): Promise<huks.HuksSessionHandle> {
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
      const err = error instanceof Error ? error : new Error(String(error));
      throw err;
    }
  });
}

/**
 * 完成加密会话
 */
function finishEncryptSession(handle: number, huksOptions: huks.HuksOptions, throwObject: ThrowObject): Promise<huks.HuksReturnResult> {
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
      const err = error instanceof Error ? error : new Error(String(error));
      throw err;
    }
  });
}

/**
 * 步骤2：加密数据
 * 使用SM4密钥对明文进行加密，加密过程无需用户认证
 */
async function step2_EncryptData(): Promise<void> {
  const encryptOptions: huks.HuksOptions = {
    properties: ENCRYPTION_PROPERTIES,
    inData: new Uint8Array([])
  };

  // 2.1 初始化加密会话
  let throwObject: ThrowObject = { isThrow: true };
  try {
    await initEncryptSession(KEY_ALIAS, encryptOptions, throwObject)
      .then((data) => {
        console.info(`加密会话初始化成功: ${JSON.stringify(data)}`);
        sessionHandle = data.handle as number;
        challenge = data.challenge as Uint8Array;
      })
      .catch((error: Error) => {
        if (throwObject.isThrow) {
          const err = error instanceof Error ? error : new Error(String(error));
          throw err;
        } else {
          console.error(`加密会话初始化失败: ${JSON.stringify(error)}`);
        }
      });
  } catch (error) {
    console.error(`加密会话初始化参数无效: ${JSON.stringify(error)}`);
    const err = error instanceof Error ? error : new Error(String(error));
    throw err;
  }

  // 2.2 执行加密操作
  encryptOptions.inData = stringToUint8Array(CIPHER_IN_DATA);
  throwObject = { isThrow: true };
  try {
    await finishEncryptSession(sessionHandle, encryptOptions, throwObject)
      .then((data) => {
        encryptedData = data.outData as Uint8Array;
        console.info(`数据加密成功: ${JSON.stringify(data)}`);
      })
      .catch((error: Error) => {
        if (throwObject.isThrow) {
          const err = error instanceof Error ? error : new Error(String(error));
          throw err;
        } else {
          console.error(`数据加密失败: ${JSON.stringify(error)}`);
        }
      });
  } catch (error) {
    console.error(`数据加密参数无效: ${JSON.stringify(error)}`);
    const err = error instanceof Error ? error : new Error(String(error));
    throw err;
  }
}

// ============================================================================
// 步骤3：用户认证模块
// 功能：通过PIN码认证获取授权令牌
// ============================================================================

/**
 * 执行用户认证（PIN码）
 * 认证成功后会触发回调，获取authToken
 */
function performUserAuthentication(huksChallenge: Uint8Array): void {
  // 配置认证参数
  const authTypeList: userAuth.UserAuthType[] = [AUTH_TYPE];
  const authParam: userAuth.AuthParam = {
    challenge: huksChallenge,
    authType: authTypeList,
    authTrustLevel: AUTH_TRUST_LEVEL
  };

  const widgetParam: userAuth.WidgetParam = {
    title: 'PIN',
  };

  // 获取认证实例
  let auth: userAuth.UserAuthInstance;
  try {
    auth = userAuth.getUserAuthInstance(authParam, widgetParam);
    console.info('认证实例获取成功');
  } catch (error) {
    console.error('认证实例获取失败: ' + JSON.stringify(error));
    const err = error instanceof Error ? error : new Error(String(error));
    throw err;
  }

  // 订阅认证结果
  try {
    auth.on('result', {
      onResult(result) {
        console.info('用户认证成功，获取到token: ' + JSON.stringify(result));
        authToken = result.token;
        // 认证成功后，继续执行解密操作
        step3_2_CompleteDecryption();
      }
    });
    console.info('认证结果订阅成功');
  } catch (error) {
    console.error('认证结果订阅失败: ' + JSON.stringify(error));
    const err = error instanceof Error ? error : new Error(String(error));
    throw err;
  }

  // 开始认证
  try {
    auth.start();
    console.info('认证流程已启动，等待用户输入PIN码...');
  } catch (error) {
    console.error('认证启动失败: ' + JSON.stringify(error));
    const err = error instanceof Error ? error : new Error(String(error));
    throw err;
  }
}

// ============================================================================
// 步骤4：解密模块
// 功能：初始化解密会话并使用认证令牌完成解密
// ============================================================================
const DECRYPTION_PROPERTIES: huks.HuksParam[] = [
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
];

/**
 * 初始化解密会话
 */
function initDecryptSession(keyAlias: string, huksOptions: huks.HuksOptions, throwObject: ThrowObject): Promise<huks.HuksSessionHandle> {
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
      const err = error instanceof Error ? error : new Error(String(error));
      throw err;
    }
  });
}

/**
 * 完成解密会话（需要认证令牌）
 */
function finishDecryptSession(handle: number, huksOptions: huks.HuksOptions, token: Uint8Array, throwObject: ThrowObject): Promise<huks.HuksReturnResult> {
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
      const err = error instanceof Error ? error : new Error(String(error));
      throw err;
    }
  });
}

/**
 * 步骤4.1：初始化解密会话并触发用户认证
 * 由于密钥设置了解密时需要用户认证，此步骤会获取挑战值并触发认证流程
 */
async function step3_1_InitDecryptionAndAuth(): Promise<void> {

  const decryptOptions: huks.HuksOptions = {
    properties: DECRYPTION_PROPERTIES,
    inData: new Uint8Array([])
  };

  // 初始化解密会话，获取挑战值
  let throwObject: ThrowObject = { isThrow: true };
  try {
    await initDecryptSession(KEY_ALIAS, decryptOptions, throwObject)
      .then((data) => {
        console.info(`解密会话初始化成功: ${JSON.stringify(data)}`);
        sessionHandle = data.handle as number;
        challenge = data.challenge as Uint8Array;
        console.info('获取到挑战值: ' + challenge.toString());

        // 触发用户认证流程
        performUserAuthentication(challenge);
      })
      .catch((error: Error) => {
        if (throwObject.isThrow) {
          const err = error instanceof Error ? error : new Error(String(error));
          throw err;
        } else {
          console.error(`解密会话初始化失败: ${JSON.stringify(error)}`);
        }
      });
  } catch (error) {
    console.error(`解密会话初始化参数无效: ${JSON.stringify(error)}`);
    const err = error instanceof Error ? error : new Error(String(error));
    throw err;
  }
}

/**
 * 步骤4.2：完成解密操作
 * 使用认证令牌完成解密，并验证结果
 * 注意：此函数由用户认证成功后的回调触发
 */
async function step3_2_CompleteDecryption(): Promise<void> {
  console.info('=== 步骤3.3：完成解密操作 ===');

  const decryptOptions: huks.HuksOptions = {
    properties: DECRYPTION_PROPERTIES,
    inData: encryptedData // 使用之前加密的密文
  };

  let throwObject: ThrowObject = { isThrow: true };
  try {
    await finishDecryptSession(sessionHandle, decryptOptions, authToken, throwObject)
      .then((data) => {
        decryptedData = data.outData as Uint8Array;
        console.info(`数据解密成功: ${JSON.stringify(data)}`);

        // 验证解密结果
        const originalData = stringToUint8Array(CIPHER_IN_DATA);
        if (decryptedData.toString() === originalData.toString()) {
          console.info('解密验证成功！解密后的数据与原始明文一致');
        } else {
          console.error('解密验证失败！解密后的数据与原始明文不一致');
        }
      })
      .catch((error: BusinessError) => {
        if (throwObject.isThrow) {
          const err = error instanceof Error ? error : new Error(String(error));
          throw err;
        } else {
          console.error(`数据解密失败: ${JSON.stringify(error)}`);
        }
      });
  } catch (error) {
    console.error(`数据解密参数无效: ${JSON.stringify(error)}`);
    const err = error instanceof Error ? error : new Error(String(error));
    throw err;
  }
}

/**
 * 主函数：执行完整的SM4加密解密流程
 *
 * 流程说明：
 * 1. 生成带用户认证保护的SM4密钥
 * 2. 使用密钥加密数据（无需认证）
 * 3. 初始化解密会话并进行用户认证
 *    - 3.1 初始化解密会话，获取挑战值
 *    - 3.2 使用挑战值进行PIN码认证
 *    - 3.3 认证成功后，使用令牌完成解密
 *
 * 注意：步骤3是异步的，用户认证完成后会自动触发解密操作
 */
async function main(): Promise<void> {
    // 步骤1：生成密钥
    await step1_GenerateKey();
    // 步骤2：加密数据
    await step2_EncryptData();
    // 步骤3：初始化解密并进行用户认证
    await step3_1_InitDecryptionAndAuth();
}
// [End generate_key_specify_fingerprint_access_control_and_auth_purpose]

@Entry
@Component
struct Index {
  @State message: string = 'FineGrainedUserIdentityAuthentication';

  build() {
    Column({ space: 12 }) {
      Text(this.message)
        .fontWeight(FontWeight.Regular)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(Infinity)
        .textAlign(TextAlign.Start)
      Button($r('app.string.fine_grained_user_identity_authentication_call'))
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
            this.message = 'Call Result: Failed' + error.message;
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}