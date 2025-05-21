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
import { fromHexString, stringToUint8Array, TAG, uint8ArrayToShowStr } from "./Utils";

// RSA密钥对
export interface RsaKey {
  publicKey: string;
  privateKey: string;
}

/**
 * 生成RSA密钥对
 * @returns RSA密钥对
 */
export async function generateRsaKey(): Promise<RsaKey | undefined> {
  try {
    // 创建非对称密钥生成器
    let rsaKeyGenerator: cryptoFramework.AsyKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
    // 通过密钥生成器随机生成非对称密钥
    let keyPair: cryptoFramework.KeyPair = await rsaKeyGenerator.generateKeyPair();
    // 获取非对称密钥的二进制数据
    let encodedPriKey: cryptoFramework.DataBlob = keyPair.priKey.getEncoded();
    // 私钥
    let priKeyData: Uint8Array = encodedPriKey.data;
    let encodedPubKey: cryptoFramework.DataBlob = keyPair.pubKey.getEncoded();
    // 公钥
    let pubKeyData: Uint8Array = encodedPubKey.data;
    let rsaKey: RsaKey = {
      privateKey: uint8ArrayToShowStr(priKeyData),
      publicKey: uint8ArrayToShowStr(pubKeyData)
    };
    return rsaKey;
  } catch (error) {
    Logger.error(TAG, 'RSA create failed');
    return undefined;
  }
}

/**
 * RSA加密
 * @param data 需要加密的数据
 * @param publicKey 公钥
 * @returns 完成加密的数据
 */
export async function rsaEncryption(data: string, publicKey: string): Promise<string> {
  try {
    // 创建非对称密钥生成器实例
    let rsaKeyGenerator: cryptoFramework.AsyKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
    // 将RSA密钥字符串转换为密钥类型
    let pubKeyBlob: cryptoFramework.DataBlob = { data: fromHexString(publicKey) };
    let key: cryptoFramework.PubKey = (await rsaKeyGenerator.convertKey(pubKeyBlob, null)).pubKey;
    // 指定算法名称（含密钥长度）、加密模式以及填充方法的组合
    let cipherAlgName: string = 'RSA1024|PKCS1';
    let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher(cipherAlgName);
    // 	表示进行加密操作
    let mode: cryptoFramework.CryptoMode = cryptoFramework.CryptoMode.ENCRYPT_MODE;
    // Cipher中init、update、doFinal为三段式接口，需要成组使用。其中init和doFinal必选，update可选。
    // 初始化加解密的cipher对象
    await cipher.init(mode, key, null);
    // 将明文转换为Uint8Array，用于后续加密操作
    let plainText: cryptoFramework.DataBlob = { data: fromHexString(data) };
    // 用于处理剩余数据和本次传入的数据，并最终结束加密或解密操作。
    // 在RSA非对称加解密中，doFinal加解密本次传入的数据，通过注册回调函数获取加密或者解密数据。如果数据量较大，可以多次调用doFinal，拼接结果得到完整的明文/密文。
    let encryptBlob: cryptoFramework.DataBlob = await cipher.doFinal(plainText);
    return uint8ArrayToShowStr(encryptBlob.data);
  } catch (err) {
    Logger.error(TAG, `RSA encryption failed, ${err.code}, ${err.message}`);
  }
  return "";
}


/**
 * RSA解密
 * @param encryptedData 经过加密的数据
 * @param privateKey  私钥
 * @returns 解密后的数据
 */
export async function rsaDecryption(encryptedData: string, privateKey: string): Promise<string> {
  try {
    // 创建非对称密钥生成器实例
    let rsaKeyGenerator: cryptoFramework.AsyKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
    // 将RSA密钥字符串转换为密钥类型
    let priKeyBlob: cryptoFramework.DataBlob = { data: fromHexString(privateKey) };
    let key: cryptoFramework.PriKey = (await rsaKeyGenerator.convertKey(null, priKeyBlob)).priKey;
    let cipherAlgName: string = 'RSA1024|PKCS1';
    let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher(cipherAlgName);
    // 	表示进行解密操作
    let mode: cryptoFramework.CryptoMode = cryptoFramework.CryptoMode.DECRYPT_MODE;
    // Cipher中init、update、doFinal为三段式接口，需要成组使用。其中init和doFinal必选，update可选。
    // 初始化加解密的cipher对象
    await cipher.init(mode, key, null);
    // 将秘文转换为Uint8Array，用于后续解密操作
    let plainText: cryptoFramework.DataBlob = { data: fromHexString(encryptedData) };
    let decryptBlob: cryptoFramework.DataBlob = await cipher.doFinal(plainText);
    return uint8ArrayToShowStr(decryptBlob.data);
  } catch (err) {
    Logger.error(TAG, `RSA decryption failed, ${err.code}, ${err.message}`);
  }
  return "";
}

/**
 * 验证签名
 * @param encryptedData 待验证的数据
 * @param singedData  签名信息
 * @param publicKey 公钥
 * @returns 签名验证是否通过
 */
export async function verify(encryptedData: string, singedData: string, publicKey: string): Promise<boolean> {
  try {
    let verifyer = cryptoFramework.createVerify('RSA1024|PKCS1|SHA256');
    // 创建非对称密钥生成器实例
    let rsaKeyGenerator: cryptoFramework.AsyKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
    // 将RSA密钥字符串转换为密钥类型
    let pubKeyBlob: cryptoFramework.DataBlob = { data: fromHexString(publicKey) };
    let key: cryptoFramework.PubKey = (await rsaKeyGenerator.convertKey(pubKeyBlob, null)).pubKey;
    let encryptedBlob: Uint8Array = stringToUint8Array(encryptedData);
    let signedBlob: Uint8Array = fromHexString(singedData);
    await verifyer.init(key);
    let result: boolean = await verifyer.verify({ data: encryptedBlob }, { data: signedBlob });
    return result;
  } catch (err) {
    Logger.error(TAG, `RSA verify failed, ${err.code}, ${err.message}`);
  }
  return false;
}

/**
 * 签名
 * @param data 需要签名的数据
 * @param privateKey 私钥
 * @returns 签名信息
 */
export async function sign(data: string, privateKey: string): Promise<string> {
  try {
    let signer = cryptoFramework.createSign('RSA1024|PKCS1|SHA256');
    // 创建非对称密钥生成器实例
    let rsaKeyGenerator: cryptoFramework.AsyKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA1024');
    // 将RSA密钥字符串转换为密钥类型
    let priKeyBlob: cryptoFramework.DataBlob = { data: fromHexString(privateKey) };
    let key: cryptoFramework.PriKey = (await rsaKeyGenerator.convertKey(null, priKeyBlob)).priKey;
    await signer.init(key);
    let signBlob = stringToUint8Array(data);
    let signedBlob = await signer.sign({ data: signBlob });
    let tmpArr: Uint8Array = signedBlob.data;
    let rsaSignedBlobString = uint8ArrayToShowStr(tmpArr);
    return rsaSignedBlobString;
  } catch (error) {
    Logger.error(TAG, `RSA sign failed, ${error.code}, ${error.message}`);
    return "";
  }
}
