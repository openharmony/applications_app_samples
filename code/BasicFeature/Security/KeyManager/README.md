# 通用密钥管理

### 介绍

本示例介绍了如何使用AES和RSA进行数据加解密，并模拟了服务端和客户端的加解密通信流程。

### 效果图预览

<img src="./common_secret_key_manager.gif" width="300">

**使用说明**：

1. 点击输入框，输入任何内容，点击“发送”按钮，页面将会展示客户端和服务端的加解密通信过程。
2. 客户端会在2s后调用模拟服务端的方法，页面将会展示签名验证数据的过程。

### 实现思路

1. 创建页面，添加List用于显示加解密流程信息，添加TextInput用于输入数据。详细代码可参考[Index.ets](./entry/src/main/ets/pages/KeyManager.ets)。

    ```typescript
    @Entry
    @Component
    struct KeyManager {
      ...
    
      build() {
        RelativeContainer() {
          Row() {
            TextInput({ text: this.message, placeholder: '请输入内容' })
              .id('input')
              .onChange((value: string) => {
                this.message = value;
              })
              .layoutWeight(4)
              ...
          }
          ...
    
          List() {
            ForEach(this.messageArray, (message: Message) => {
              ListItem() {
                Row() {
                  Text(message.message)
                    .padding(10)
                    .fontColor(message.position === MessagePosition.Left ? Color.Blue : Color.Black)
                    .constraintSize({
                      maxWidth: '80%'
                    })
                    .borderRadius(10)
                    .backgroundColor("#F1F1F1")
                    .margin({
                      left: message.position === MessagePosition.Left ? 10 : 0,
                      right: message.position === MessagePosition.Right ? 10 : 0
                    })
                }
                ...
              }
            })
          }
          ...
      }
    
    }
    ```

2. 分别实现AES密钥生成方法和加解密方法。详细代码可参考[AesUtils.ets](./entry/src/main/ets/utils/AesUtils.ets)。

    ```typescript
    /**
     * 生成AES密钥
     * @returns AES密钥的16进制字符串
     */
    export async function generateAesKey(): Promise<string> {
      ...
    }
    
    /**
     * AES解密
     * @param encryptedMessage 已经加密的数据
     * @param aesKey AES密钥
     * @returns 解密后的数据
     */
    export async function aesGcmDecrypt(encryptedMessage: string, aesKey: string): Promise<string> {
      ...
    }
    
    /**
     * AES加密
     * @param textString 需要加密的数据
     * @param aesKey AES密钥
     * @returns
     */
    export async function aesGcmEncrypt(textString: string, aesKey: string): Promise<string> {
      ...
    }
    ```

3. 分别实现RSA密钥生成方法、加解密方法、签名验证方法。详细代码可参考[RsaUtils.ets](./entry/src/main/ets/utils/RsaUtils.ets)。

    ```typescript
    /**
     * 生成RSA密钥对
     * @returns RSA密钥对
     */
    export async function generateRsaKey(): Promise<RsaKey | undefined> {
      ...
    }
    
    /**
     * RSA加密
     * @param data 需要加密的数据
     * @param publicKey 公钥
     * @returns 完成加密的数据
     */
    export async function rsaEncryption(data: string, publicKey: string): Promise<string> {
      ...
    }
    
    /**
     * RSA解密
     * @param encryptedData 经过加密的数据
     * @param privateKey  私钥
     * @returns 解密后的数据
     */
    export async function rsaDecryption(encryptedData: string, privateKey: string): Promise<string> {
      ...
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
      ...
    }
    
    /**
     * 签名
     * @param data 需要签名的数据
     * @param privateKey 私钥
     * @returns 签名信息
     */
    export async function sign(data: string, privateKey: string): Promise<string> {
      ...
    }
    ```
   
4. 在客户端中进行AES密钥生成、加解密以及RSA加密。详细代码可参考[LocalClient.ets](./entry/src/main/ets/client/LocalClient.ets)。

   ```typescript
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
   ```

5. 在客户端中进行AES密钥生成、加解密以及RSA加密。详细代码可参考[LocalClient.ets](./entry/src/main/ets/client/LocalClient.ets)。

   ```typescript
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
   ```

### 工程结构&模块类型

```
KeyManger                                       // har类型
|---client
|   |---LocalClient.ets                         // 模拟客户端
|---pages
|   |---KeyManager.ets                          // 应用页面
|---server
|   |---LocalMockServer.ets                     // 模拟服务端
|---utils
|   |---AesUtils.ets                            // AES加密工具类
|   |---Logger.ets                              // 日志打印类
|   |---RsaUtils.ets                            // RSA加密工具类
|   |---Utils.ets                               // 其他公用方法
```

### 模块依赖

无

### 相关权限

无

### 约束与限制

1. 本示例仅支持标准系统上运行。

2. 本示例为Stage模型，从API version 12开始支持。SDK版本号：5.0.0.71 Release，镜像版本号：OpenHarmony 5.0.1.107。

3. 本示例需要使用DevEco Studio 5.0.4 Release (Build Version: 5.0.11.100, built on March 28, 2025)编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```shell
git init
git config core.sparsecheckout true
echo code/BasicFeature/Security/KeyManager/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```

### 参考资料

[加解密算法库框架cryptoFramework](https://docs.openharmony.cn/pages/v5.1/zh-cn/application-dev/reference/apis-crypto-architecture-kit/js-apis-cryptoFramework.md#cryptoframeworkcreatesymkeygenerator)

[使用RSA非对称密钥（PKCS1模式）加解密](https://docs.openharmony.cn/pages/v5.1/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-rsa-asym-encrypt-decrypt-pkcs1.md)

[使用AES对称密钥（GCM模式）加解密](https://docs.openharmony.cn/pages/v5.1/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-aes-sym-encrypt-decrypt-gcm.md)

[使用RSA密钥对（PKCS1模式）签名验签](https://docs.openharmony.cn/pages/v5.1/zh-cn/application-dev/security/CryptoArchitectureKit/crypto-rsa-sign-sig-verify-pkcs1.md)


