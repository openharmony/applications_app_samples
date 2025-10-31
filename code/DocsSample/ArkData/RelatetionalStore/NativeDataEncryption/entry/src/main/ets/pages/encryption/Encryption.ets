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


// [Start encryption_TS_IncludeSupported]
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit'
// [End encryption_TS_IncludeSupported]

const DOMAIN = 0x0000

// 场景1：不配置cryptoParam属性，此时会使用默认的加密配置进行数据库的加密/解密。
export async function defaultConfigRdbStoreTs() {

  // [Start defaultConfigRdbStoreTs]

  let store: relationalStore.RdbStore | undefined = undefined;
  let context = getContext();

  try {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'RdbTest.db',
      securityLevel: relationalStore.SecurityLevel.S3,
      encrypt: true
    };
    store = await relationalStore.getRdbStore(context, STORE_CONFIG);
    hilog.info(DOMAIN, 'Encryption', 'Succeeded in getting RdbStore.');
  } catch (e) {
    const err = e as BusinessError;
    hilog.error(DOMAIN, 'Encryption', `Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
  }

  // [End defaultConfigRdbStoreTs]
}


// 场景2：配置cryptoParam属性，此时会使用开发者自定义的密钥和算法参数进行数据库的加密/解密。
export async function customizedConfigRdbStoreTs() {

  // [Start customizedConfigRdbStoreTs]

  let store: relationalStore.RdbStore | undefined = undefined;
  let context = getContext();
  // 初始化需要使用的密钥，示例中使用硬编码密钥仅用于演示目的， 实际应用中应使用安全的密钥管理服务
  let key = new Uint8Array(32);
  for (let i = 0; i < 32; i++) {
    key[i] = i;
  }

  // 初始化加密算法
  const CRYPTO_PARAM: relationalStore.CryptoParam = {
    encryptionKey: key, // 必选参数，使用指定的密钥打开加密数据库。为空则由数据库负责生成并保存密钥，并使用生成的密钥打开数据库文件。
    iterationCount: 25000, // 可选参数，迭代次数。迭代次数必须大于零。不指定或等于零则使用默认值10000和默认加密算法。
    encryptionAlgo: relationalStore.EncryptionAlgo.AES_256_CBC, // 可选参数，加密/解密算法。如不指定，默认算法为AES_256_GCM。
    hmacAlgo: relationalStore.HmacAlgo.SHA256, // 可选参数，HMAC算法。如不指定，默认值为SHA256。
    kdfAlgo: relationalStore.KdfAlgo.KDF_SHA512, // 可选参数，KDF算法。如不指定，默认值和HMAC算法相等。
    cryptoPageSize: 2048 // 可选参数，加密/解密时使用的页大小。必须为1024到65536范围内的整数并且为2的幂。如不指定，默认值为1024。
  }

  const STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'encrypted.db',
    securityLevel: relationalStore.SecurityLevel.S3,
    encrypt: true,
    cryptoParam: CRYPTO_PARAM
  }
  try {
    store = await relationalStore.getRdbStore(context, STORE_CONFIG);
    if (store == null) {
      hilog.error(DOMAIN, 'Encryption', 'Failed to get RdbStore.');
    } else {
      hilog.info(DOMAIN, 'Encryption', 'Succeeded in getting RdbStore.');
    }
    // 调用完后需要将密钥清零
    CRYPTO_PARAM.encryptionKey.fill(0);
    key.fill(0);
  } catch (e) {
    const err = e as BusinessError;
    hilog.error(DOMAIN, 'Encryption', `Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
  }

  // [End customizedConfigRdbStoreTs]
}





