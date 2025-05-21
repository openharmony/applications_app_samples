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

import { LocalMockServer } from '../server/LocalMockServer';
import { aesGcmDecrypt, aesGcmEncrypt, generateAesKey } from '../utils/AesUtils';
import { rsaEncryption, verify } from '../utils/RsaUtils';
import { MessagePosition, sendProcessMessage } from '../utils/Utils';

const TAG: string = 'LocalClient';

class SignedData {
  encryptedMessage: string = "";
  signedMessage: string = "";
}

/**
 * 本地客户端进行加密、验签
 */
export class LocalClient {
  private server: LocalMockServer = new LocalMockServer();
  private publicKey: string = "";
  private aesKey: string = "";

  // 客户端下载公钥
  async downloadPublicKey() {
    let publicKeyResult: SignedData = JSON.parse(await this.server.downloadPublicKey());
    // 验证公钥签名
    if (await verify(publicKeyResult.encryptedMessage, publicKeyResult.signedMessage,
      publicKeyResult.encryptedMessage)) {
      this.publicKey = publicKeyResult.encryptedMessage;
    }
    if (this.publicKey === "") {
      sendProcessMessage("获取公钥失败", MessagePosition.Right);
      throw new Error('downloadPublicKey failed');
    }
    sendProcessMessage("获取公钥成功", MessagePosition.Right);
  }

  // 发送数据到服务端
  async sendMessageToServer(message: string): Promise<void> {
    sendProcessMessage("开始发送数据到服务端...", MessagePosition.Right);
    // 消息加密
    let encryptionMessage: string = await this.encryption(message);
    sendProcessMessage("发送加密数据到服务端...", MessagePosition.Right);
    // 发送服务端
    await this.server.receiveMessageFromClient(encryptionMessage);
  }

  // 从服务端接收数据
  async receiveMessageFromServer(): Promise<string> {
    sendProcessMessage("开始接收服务端数据...", MessagePosition.Right);
    let signMessage: string = await this.server.sendMessageToClient();
    // 验证签名
    let signData: SignedData = JSON.parse(signMessage);
    sendProcessMessage("开始验证签名...", MessagePosition.Right);
    let isVerified: boolean = await verify(signData.encryptedMessage, signData.signedMessage, this.publicKey);
    if (isVerified) {
      sendProcessMessage("签名验证成功，开始解密...", MessagePosition.Right);
      let decryptedMessage = await aesGcmDecrypt(signData.encryptedMessage, this.aesKey);
      sendProcessMessage("解密成功，解密结果：" + decryptedMessage, MessagePosition.Right);
      return decryptedMessage;
    }
    sendProcessMessage("签名验证失败", MessagePosition.Right);
    return "签名验证失败";
  }

  // 加密
  async encryption(message: string): Promise<string> {
    if (!this.publicKey) {
      sendProcessMessage("本地未找到公钥，开始下载...", MessagePosition.Right);
      // 获取公钥
      await this.downloadPublicKey();
      sendProcessMessage("公钥下载成功", MessagePosition.Right);
    }
    if (this.aesKey === "") {
      sendProcessMessage("本地未找到AES密钥，开始生成...", MessagePosition.Right);
      // 生成AES密钥
      this.aesKey = await generateAesKey();
      sendProcessMessage(`AES密钥生成成功，密钥：${this.aesKey}，开始发送到服务端...`, MessagePosition.Right);
      // 将AES密钥发送到服务端
      await this.sendAesKeyToServer();
    }
    sendProcessMessage(`客户端开始加密数据...`, MessagePosition.Right);
    let encryptionResult: string = await aesGcmEncrypt(message, this.aesKey);
    sendProcessMessage(`客户端加密成功，加密结果：${encryptionResult}`, MessagePosition.Right);
    // 使用AES加密数据
    return encryptionResult;
  }

  // 发送AES密钥到服务端
  async sendAesKeyToServer() {
    sendProcessMessage(`AES密钥进行加密...`, MessagePosition.Right);
    // 对AES密钥使用公钥进行加密
    let encryptedAesKey: string = await rsaEncryption(this.aesKey, this.publicKey);
    sendProcessMessage(`加密成功，加密结果：${encryptedAesKey}，开始发送到服务端...`, MessagePosition.Right);
    // 将加密后的AES密钥发送到服务端
    await this.server.receiveKeyFromClient(encryptedAesKey);
  }
}