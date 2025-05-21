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

import Logger from '../utils/Logger';
import { aesGcmDecrypt, aesGcmEncrypt } from '../utils/AesUtils';
import { generateRsaKey, rsaDecryption, RsaKey, sign } from '../utils/RsaUtils';
import { emitter } from '@kit.BasicServicesKit';
import { messageEvent, MessagePosition, sendProcessMessage } from '../utils/Utils';

const TAG: string = 'LocalMockServer';

class SignedData {
  encryptedMessage: string = "";
  signedMessage: string = "";
}

/**
 * 模拟服务端进行RSA密钥生成、解密、签名
 */
export class LocalMockServer {
  private publicKey: string = "";
  private privateKey: string = "";
  private messageStorage: string[] = [];
  private aesKey: string = "";

  //生成证书
  async createKey() {
    sendProcessMessage("模拟服务端开始生成证书", MessagePosition.Left);
    let rsaKey: RsaKey | undefined = await generateRsaKey()
    if (rsaKey) {
      this.publicKey = rsaKey.publicKey;
      this.privateKey = rsaKey.privateKey;
      sendProcessMessage("模拟服务端生成证书成功，公钥：" + this.publicKey, MessagePosition.Left);
    }
  }

  // 模拟公钥下载
  async downloadPublicKey(): Promise<string> {
    if (this.publicKey === "") {
      // 创建密钥
      await this.createKey();
    }
    // 对公钥进行签名
    let signResult: string = await sign(this.publicKey, this.privateKey);
    let publicKeyResult: SignedData = { encryptedMessage: this.publicKey, signedMessage: signResult };
    return JSON.stringify(publicKeyResult);
  }

  async receiveKeyFromClient(encryptedAesKey: string) {
    sendProcessMessage(`模拟服务端接收到AES密钥：${encryptedAesKey}`, MessagePosition.Left);
    this.aesKey = await rsaDecryption(encryptedAesKey, this.privateKey);
    sendProcessMessage(`模拟服务端AES密钥解密成功，AES密钥为：${this.aesKey}`, MessagePosition.Left);
    Logger.info(TAG, 'receive key from client success, server aesKey:' + this.aesKey);
  }

  // 获取客户端消息
  async receiveMessageFromClient(message: string): Promise<void> {
    sendProcessMessage("模拟服务端接收到数据，开始解密...", MessagePosition.Left);
    // 解密
    let decryptedMessage = await aesGcmDecrypt(message, this.aesKey);
    sendProcessMessage(`模拟服务端解密成功，解密结果：${decryptedMessage}`, MessagePosition.Left);
    // 存储
    this.messageStorage.push(decryptedMessage);
  }

  async sendMessageToClient(): Promise<string> {
    let needSendMessage: string = "这是模拟服务端返回的测试数据，" + this.messageStorage[this.messageStorage.length-1];
    sendProcessMessage(`模拟服务端开始发送数据，将要发送的数据是：${needSendMessage}`, MessagePosition.Left);
    sendProcessMessage(`模拟服务端开始加密数据：${needSendMessage}`, MessagePosition.Left);
    let encryptedMessage: string = await aesGcmEncrypt(needSendMessage, this.aesKey);
    sendProcessMessage(`模拟服务端加密成功，加密结果：${encryptedMessage}`, MessagePosition.Left);
    // 签名
    sendProcessMessage(`模拟服务端开始签名数据...`, MessagePosition.Left);
    let signedMessage: string = await sign(encryptedMessage, this.privateKey);
    sendProcessMessage(`模拟服务端签名成功，签名结果：${signedMessage}`, MessagePosition.Left);
    let signData: SignedData = { encryptedMessage: encryptedMessage, signedMessage: signedMessage };
    // 发送消息
    return JSON.stringify(signData);
  }
}
