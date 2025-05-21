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

import { cryptoFramework } from "@kit.CryptoArchitectureKit";
import Logger from "./Logger";
import { arrayBufferToString, fromHexString, stringToUint8Array, TAG, uint8ArrayToShowStr } from "./Utils";

// 加密数据结构
class EncryptionData {
  aesGcmTag: string = "";
  encryptedText: string = "";
}

/**
 * 生成AES密钥
 * @returns AES密钥的16进制字符串
 */
export async function generateAesKey(): Promise<string> {
  try {
    // 创建对称密钥生成器
    let symKeyGenerator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES256');
    // 通过密钥生成器随机生成对称密钥
    let symKey = await symKeyGenerator.generateSymKey();
    // 获取对称密钥的二进制数据，输出长度为256bit的字节流
    let encodedKey: cryptoFramework.DataBlob = symKey.getEncoded();
    let data: Uint8Array = encodedKey.data;
    // 将二进制数据转为16进制string。
    return uint8ArrayToShowStr(data);
  } catch (error) {
    Logger.error(TAG, 'AES create failed');
    return "";
  }
}

/**
 * AES解密
 * @param encryptedMessage 已经加密的数据
 * @param aesKey AES密钥
 * @returns 解密后的数据
 */
export async function aesGcmDecrypt(encryptedMessage: string, aesKey: string): Promise<string> {
  let encryptionData: EncryptionData = JSON.parse(encryptedMessage);
  try {
    // 创建对称密钥生成器实例
    let symKeyGenerator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES256');
    // 将AES密钥字符串转换为密钥类型
    let symKeyBlob: cryptoFramework.DataBlob = { data: fromHexString(aesKey) };
    let key: cryptoFramework.SymKey = await symKeyGenerator.convertKey(symKeyBlob);
    // 指定算法名称（含密钥长度）、加密模式以及填充方法的组合
    let cipherAlgName: string = 'AES256|GCM|PKCS7';
    let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher(cipherAlgName);
    // 适用于GCM模式的加密参数
    let globalGcmParams: cryptoFramework.GcmParamsSpec = genGcmParamsSpec(encryptionData.aesGcmTag);
    // 	表示进行加密操作
    let mode: cryptoFramework.CryptoMode = cryptoFramework.CryptoMode.DECRYPT_MODE;
    // Cipher中init、update、doFinal为三段式接口，需要成组使用。其中init和doFinal必选，update可选。
    // 初始化加解密的cipher对象
    await cipher.init(mode, key, globalGcmParams);
    // 将明文转换为Uint8Array，用于后续加密操作
    let plainText: cryptoFramework.DataBlob = { data: fromHexString(encryptionData.encryptedText) };
    // 分段更新加密或者解密数据操作，可选方法
    let cipherTextBlob: cryptoFramework.DataBlob = await cipher.update(plainText);
    await cipher.doFinal(null);
    let tmpArr: Uint8Array = cipherTextBlob.data;
    // 将加密后的密文转换为字符串
    let decryptedText: string = arrayBufferToString(tmpArr);
    return decryptedText;
  } catch (error) {
    Logger.error(TAG, `AES decrypt failed, ${error.code}, ${error.message}`);
    return "";
  }
}

/**
 * AES加密
 * @param textString 需要加密的数据
 * @param aesKey AES密钥
 * @returns
 */
export async function aesGcmEncrypt(textString: string, aesKey: string): Promise<string> {
  try {
    // 创建对称密钥生成器实例
    let symKeyGenerator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES256');
    // 将AES密钥字符串转换为密钥类型
    let symKeyBlob: cryptoFramework.DataBlob = { data: fromHexString(aesKey) };
    let key: cryptoFramework.SymKey = await symKeyGenerator.convertKey(symKeyBlob);
    // 指定算法名称（含密钥长度）、加密模式以及填充方法的组合
    let cipherAlgName: string = 'AES256|GCM|PKCS7';
    let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher(cipherAlgName);
    // 适用于GCM模式的加密参数
    let globalGcmParams: cryptoFramework.GcmParamsSpec = genGcmParamsSpec();
    // 	表示进行加密操作
    let mode: cryptoFramework.CryptoMode = cryptoFramework.CryptoMode.ENCRYPT_MODE;
    // Cipher中init、update、doFinal为三段式接口，需要成组使用。其中init和doFinal必选，update可选。
    // 初始化加解密的cipher对象
    await cipher.init(mode, key, globalGcmParams);
    // 将明文转换为Uint8Array，用于后续加密操作
    let plainText: cryptoFramework.DataBlob = { data: stringToUint8Array(textString) };
    // 分段更新加密或者解密数据操作，可选方法
    let cipherTextBlob: cryptoFramework.DataBlob = await cipher.update(plainText);
    let tmpArr: Uint8Array = cipherTextBlob.data;
    // 将加密后的密文转换为16进制字符串
    let encryptedText: string = uint8ArrayToShowStr(tmpArr);
    // 用于处理剩余数据和本次传入的数据，并最终结束加密或解密操作。
    // 对于GCM模式的对称加密：一次加密流程中，如果将每一次update和doFinal的结果拼接起来，会得到“密文+authTag”，即末尾的16字节（GCM模式）或12字节（CCM模式）是authTag，
    // 而其余部分均为密文。（也就是说，如果doFinal的data参数传入null，则doFinal的结果就是authTag）
    // authTag需要填入解密时的GcmParamsSpec；密文则作为解密时的入参data。
    let authTag: cryptoFramework.DataBlob = await cipher.doFinal(null);
    let tmoTagArr: Uint8Array = authTag.data;
    let aesGcmTag: string = uint8ArrayToShowStr(tmoTagArr);
    // 将AES的加密结果转换为JSON对象
    let aesEncryptResult: EncryptionData = { aesGcmTag: aesGcmTag, encryptedText: encryptedText };
    return JSON.stringify(aesEncryptResult);
  } catch (error) {
    Logger.error(TAG, `AES encrypt failed, ${error.code}, ${error.message}`);
    return "";
  }
}

/**
 * AES加密参数
 * @param authTag 加解密参数，加密数据时不需要传参，会在调用cipher的doFinal方法时生成，解密时需要传入
 * @returns
 */
export function genGcmParamsSpec(authTag?: string): cryptoFramework.GcmParamsSpec {
  let arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 12 bytes
  let dataIv = new Uint8Array(arr);
  let ivBlob: cryptoFramework.DataBlob = { data: dataIv };

  arr = [0, 0, 0, 0, 0, 0, 0, 0]; // 8 bytes
  let dataAad = new Uint8Array(arr);
  let aadBlob: cryptoFramework.DataBlob = { data: dataAad };

  arr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // 16 bytes
  let dataTag = new Uint8Array(arr);
  // GCM的authTag在加密时从doFinal结果中获取，在解密时填入init函数的params参数中
  let tagBlob: cryptoFramework.DataBlob = { data: authTag ? fromHexString(authTag) : dataTag };

  let gcmParamsSpec: cryptoFramework.GcmParamsSpec = {
    iv: ivBlob,
    aad: aadBlob,
    authTag: tagBlob,
    algName: 'GcmParamsSpec'
  };
  return gcmParamsSpec;
}