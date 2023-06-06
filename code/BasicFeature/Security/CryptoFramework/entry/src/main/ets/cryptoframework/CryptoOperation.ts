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

import cryptoFramework from "@ohos.security.cryptoFramework"
import promptAction from '@ohos.promptAction';
import Logger from '../util/Logger';

// 字节流以16进制字符串输出
function uint8ArrayToShowStr(uint8Array: Uint8Array) {
  return Array.prototype.map
    .call(uint8Array, (x) => ('00' + x.toString(16)).slice(-2))
    .join('');
}

// 16进制字符串转字节流
function fromHexString(hexString: string): Uint8Array {
  return new Uint8Array(hexString.match(/.{1,2}/g).map(byte => parseInt(byte, 16)));
}


// 字节流转字符串
function arrayBufferToString(buffer: ArrayBuffer): string {
  return String.fromCharCode.apply(null, new Uint8Array(buffer));
}

// 可理解的字符串转成字节流
function stringToUint8Array(str: string): Uint8Array {
  let arr = [];
  for (let i = 0, j = str.length; i < j; ++i) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
}

function genGcmParamsSpec() {
  let arr = [0, 0, 0, 0 , 0, 0, 0, 0, 0, 0 , 0, 0]; // 12 bytes
  let dataIv = new Uint8Array(arr);
  let ivBlob = {data : dataIv};

  arr = [0, 0, 0, 0 , 0, 0, 0, 0]; // 8 bytes
  let dataAad = new Uint8Array(arr);
  let aadBlob = {data : dataAad};

  arr = [0, 0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0, 0, 0]; // 16 bytes
  let dataTag = new Uint8Array(arr);
  let tagBlob = {data : dataTag};  // GCM的authTag在加密时从doFinal结果中获取，在解密时填入init函数的params参数中

  let gcmParamsSpec = {iv : ivBlob, aad : aadBlob, authTag : tagBlob, algName : "GcmParamsSpec"};
  return gcmParamsSpec;
}

const TAG: string = '[Crypto_Framework]';

export class CryptoOperation {
  async generateAesKey(): Promise<string> {
    let symKeyGenerator;
    let encodedKey;
    // 创建对称密钥生成器
    try {
      symKeyGenerator = cryptoFramework.createSymKeyGenerator('AES256');
    } catch(error) {
      Logger.error(TAG, 'create generator failed');
      return;
    }

    // 通过密钥生成器随机生成对称密钥
    try {
      let symKey = await symKeyGenerator.generateSymKey();
      // 获取对称密钥的二进制数据，输出长度为256bit的字节流
      encodedKey = symKey.getEncoded();
    } catch(error) {
      Logger.error(TAG, 'create symKey failed');
      return;
    }

    let data = encodedKey.data;
    Logger.info('success, key bytes: ' + data);
    Logger.info('success, key hex:' + uint8ArrayToShowStr(data));
    // 将二进制数据转为16进制string。
    return uint8ArrayToShowStr(data);
  }

  async convertAesKey(aesKeyBlobString: string) {
    let globalKey = null;
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator('AES256');
    Logger.info(TAG, 'success, read key string' + aesKeyBlobString);
    Logger.info(TAG, 'success, blob key ' + fromHexString(aesKeyBlobString));
    let symKeyBlob = {data : fromHexString(aesKeyBlobString)};
    try {
      let key = await symKeyGenerator.convertKey(symKeyBlob);
      globalKey = key;
    } catch (error) {
      Logger.error(TAG, `convert aes key failed, ${error.code}, ${error.message}`);
      return;
    }
    return globalKey;
  }

  async aesGcmEncrypt(globalKey, textString: string): Promise<string> {
    let cipherAlgName = 'AES256|GCM|PKCS7';
    let cipher;
    let cipherTextBlob;
    let cipherText;
    let globalGcmParams = genGcmParamsSpec();
    let aesEncryptJsonStr;
    try {
      cipher = cryptoFramework.createCipher(cipherAlgName);
      Logger.info(TAG, `cipher algName: ${cipher.algName}`);
    } catch (error) {
      Logger.error(TAG, `createCipher failed, ${error.code}, ${error.message}`);
      return;
    }
    let mode = cryptoFramework.CryptoMode.ENCRYPT_MODE;
    try {
      await cipher.init(mode, globalKey, globalGcmParams);
    } catch (error) {
      Logger.error(TAG, `init cipher failed, ${error.code}, ${error.message}`);
      return;
    }
    let plainText = { data: stringToUint8Array(textString)};
    Logger.info(TAG, `plain text: ${plainText.data}`);
    try {
      cipherTextBlob = await cipher.update(plainText);
      cipherText = uint8ArrayToShowStr(cipherTextBlob.data);
      Logger.info(TAG, `cipher text: ${cipherText}`);
    } catch (error) {
      Logger.error(TAG, `update cipher failed, ${error.code}, ${error.message}`);
      return;
    }
    try {
      let authTag = await cipher.doFinal(null);
      let aesEncryptJson = ({ aesGcmTag: uint8ArrayToShowStr(authTag.data), encryptedText: cipherText });
      aesEncryptJsonStr = JSON.stringify(aesEncryptJson);
      Logger.info(TAG, `success, authTag blob ${authTag.data}`);
      Logger.info(TAG, `success, authTag string ${uint8ArrayToShowStr(authTag.data)}`);
      Logger.info(TAG, 'success, authTag blob.length = ' + authTag.data.length)
    } catch (error) {
      Logger.error(TAG, `doFinal cipher failed, ${error.code}, ${error.message}`);
      return;
    }
    return aesEncryptJsonStr;
  }

  async aesGcmDecrypt(globalKey, aesEncryptJsonStr: string): Promise<string> {
    let cipherAlgName = 'AES256|GCM|PKCS7';
    let decode;
    let plainTextBlob;
    let plainText;
    let aesEncryptJson;
    try {
      aesEncryptJson = JSON.parse(aesEncryptJsonStr);
    } catch(error) {
      Logger.error(TAG, `trans from json string failed, ${error.code}, ${error.message}`);
      return;
    }
    let authTagStr = aesEncryptJson.aesGcmTag;
    let textString = aesEncryptJson.encryptedText;
    let globalGcmParams = genGcmParamsSpec();
    globalGcmParams.authTag = {data: fromHexString(authTagStr)};
    console.info("success, decrypt authTag string" + authTagStr);
    console.info("success, decrypt authTag blob" + globalGcmParams.authTag.data);
    console.info('success, decrypt authTag blob.length = ' + globalGcmParams.authTag.data.length)
    try {
      decode = cryptoFramework.createCipher(cipherAlgName);
    } catch (error) {
      console.error(`createCipher failed, ${error.code}, ${error.message}`);
      return;
    }
    let mode = cryptoFramework.CryptoMode.DECRYPT_MODE;
    try {
      await decode.init(mode, globalKey, globalGcmParams);
    } catch (error) {
      console.error(`init decode failed, ${error.code}, ${error.message}`);
      return;
    }
    let cipherText = { data: fromHexString(textString)};
    console.info(`success, cipher text: ${cipherText.data}`);
    try {
      plainTextBlob = await decode.update(cipherText);
      plainText = arrayBufferToString(plainTextBlob.data);
      console.info(`success, plain text: ${plainText}`);
    } catch (error) {
      console.error(`update decode failed, ${error.code}, ${error.message}`);
      return;
    }
    try {
      let finalOut = await decode.doFinal(null);
    } catch (error) {
      console.error(`doFinal decode failed, ${error.code}, ${error.message}`);
      return;
    }
    return plainText;
  }

  async aesConvertAndEncrypt(aesKeyBlobString: string, textString: string) {
    let aesEncryptJsonStr = '';
    try {
      let key = await this.convertAesKey(aesKeyBlobString);
      try {
        aesEncryptJsonStr = await this.aesGcmEncrypt(key, textString);
      } catch(error) {
        Logger.error(TAG, `encrypt error, ${error.code}, ${error.message}`);
      }
    } catch(error) {
      Logger.error(TAG, `convert key error, ${error.code}, ${error.message}`);
      return;
    }
    return aesEncryptJsonStr;
  }

  async aesConvertAndDecrypt(aesKeyBlobString: string, textString: string) {
    let plainText = '';
    try {
      let key = await this.convertAesKey(aesKeyBlobString);
      try {
        plainText = await this.aesGcmDecrypt(key, textString);
      } catch(error) {
        Logger.error(TAG, `encrypt error, ${error.code}, ${error.message}`);
      }
    } catch(error) {
      Logger.error(TAG, `convert key error, ${error.code}, ${error.message}`);
      return;
    }
    return plainText;
  }

  async generateRsaKey(): Promise<string> {
    // 创建非对称密钥生成器
    let rsaKeyGenerator;
    let jsonStr;
    // 创建对称密钥生成器
    try {
      rsaKeyGenerator = cryptoFramework.createAsyKeyGenerator('RSA3072');
    } catch(error) {
      Logger.error(TAG, 'create generator failed');
      return;
    }
    // 通过密钥生成器随机生成非对称密钥
    try {
      // 通过密钥生成器随机生成非对称密钥
      let keyPair = await rsaKeyGenerator.generateKeyPair();
      // 获取非对称密钥的二进制数据
      let encodedPriKey = keyPair.priKey.getEncoded();
      let priKeyData = encodedPriKey.data;
      console.info('success, gen rsa pri key str length:' + uint8ArrayToShowStr(priKeyData).length);
      let encodedPubKey = keyPair.pubKey.getEncoded();
      let pubKeyData = encodedPubKey.data;
      console.info('success, gen rsa pub key str length:' + uint8ArrayToShowStr(pubKeyData).length);
      let rsaKeyJson = ({ priKey: uint8ArrayToShowStr(priKeyData), pubKey: uint8ArrayToShowStr(pubKeyData)});
      jsonStr = JSON.stringify(rsaKeyJson);
      console.info('success, key string: ' + jsonStr.length);
      return jsonStr;
    } catch(error) {
      Logger.error(TAG, 'create symKey failed');
      return;
    }
  }

  async convertRsaKey(rsaJsonString: string) {
    let globalKey = null;
    let rsaKeyGenerator = cryptoFramework.createAsyKeyGenerator("RSA3072");
    console.info('success, read key string' + rsaJsonString.length);
    let jsonRsaKeyBlob = JSON.parse(rsaJsonString);
    let priKeyStr = jsonRsaKeyBlob.priKey;
    let pubKeyStr = jsonRsaKeyBlob.pubKey;
    console.info('success, read rsa pri str ' + priKeyStr.length);
    console.info('success, read rsa pub str ' + pubKeyStr.length);
    let priKeyBlob = fromHexString(priKeyStr);
    let pubKeyBlob = fromHexString(pubKeyStr);
    console.info('success, read rsa pri blob key ' + priKeyBlob.length);
    console.info('success, read rsa pub blob key ' + pubKeyBlob.length);
    try {
      let key = await rsaKeyGenerator.convertKey({ data: pubKeyBlob } , { data: priKeyBlob });
      globalKey = key;
      console.info('success, read and convert key');
    } catch (error) {
      console.error(`convert rsa key failed, ${error.code}, ${error.message}`);
      return null;
    }
    return globalKey;
  }

  async rsaSign(globalKey, textString: string): Promise<string> {
    let signer = cryptoFramework.createSign("RSA3072|PKCS1|SHA256");
    let keyPair = globalKey;
    try {
      await signer.init(keyPair.priKey);
      let signBlob = stringToUint8Array(textString);
      try {
        let signedBlob = await signer.sign({data: signBlob});
        console.info("success,RSA sign output is " + signedBlob.data.length);
        let rsaSignedBlobString = uint8ArrayToShowStr(signedBlob.data);
        console.info("success,RSA sign string is " + rsaSignedBlobString);
        return rsaSignedBlobString
      } catch(error1) {
        console.error(`sign text failed, ${error1.code}, ${error1.message}`);
        return;
      }
    } catch(error) {
      console.error(`sign init failed, ${error.code}, ${error.message}`);
      return;
    }
  }

  async rsaVerify(globalKey, textString: string, rsaSignedText: string): Promise<Boolean> {
    let verifyer = cryptoFramework.createVerify("RSA3072|PKCS1|SHA256");
    let keyPair = globalKey;
    let signBlob = stringToUint8Array(textString);
    let signedBlob = fromHexString(rsaSignedText);
    console.info("success,RSA sign input is " + signBlob);
    console.info("success,RSA signed file length" + signedBlob.length);
    await verifyer.init(keyPair.pubKey);
    let result = await verifyer.verify({data: signBlob}, {data: signedBlob});
    if (result == false) {
      // flag = false;
      console.error(" RSA Verify result = fail");
    } else {
      console.info(" success, RSA Verify result = success");
    }
    return result;
  }

  async rsaConvertAndSign(rsaJsonString: string, textString: string) {
    let rsaSignString;
    try {
      let key = await this.convertRsaKey(rsaJsonString);
      try {
        rsaSignString = await this.rsaSign(key, textString);
      } catch(error) {
        Logger.error(TAG, `sign error, ${error.code}, ${error.message}`);
        return;
      }
    } catch(error) {
      Logger.error(TAG, `convert rsa key error, ${error.code}, ${error.message}`);
      return;
    }
    return rsaSignString;
  }

  async rsaConvertAndVerify(rsaJsonString: string, textString: string, rsaSignedText: string) {
    let rsaVerifyRes;
    try {
      let key = await this.convertRsaKey(rsaJsonString);
      try {
        rsaVerifyRes = await this.rsaVerify(key, textString, rsaSignedText);
      } catch(error) {
        Logger.error(TAG, `sign error, ${error.code}, ${error.message}`);
        return;
      }
    } catch(error) {
      Logger.error(TAG, `convert rsa key error, ${error.code}, ${error.message}`);
      return;
    }
    return rsaVerifyRes;
  }

}

