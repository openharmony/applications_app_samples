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

import { LocalClient } from '../client/LocalClient';
import { KeyboardAvoidMode } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { Message, messageEvent, MessagePosition, sendProcessMessage } from '../utils/Utils';
import { inputMethod } from '@kit.IMEKit';

/**
 * 模拟数据加密传输流程
 * 1.  请求服务端，获取公钥。
 * 2.  服务端生成RSA密钥，用私钥对公钥签名后返回给客户端。
 * 3.  客户端验证公钥签名。
 * 4.  生成AES密钥，通过公钥加密后发送到服务端
 * 5.  服务端解密并存储AES密钥
 * 6.  客户端使用AES密钥对数据进行加密，发送给服务端
 * 7.  服务端使用AES密钥对数据进行解密，存储
 * 8.  服务端使用AES密钥对数据进行加密
 * 9.  服务端使用私钥对数据签名，并发送给客户端
 * 10. 客户端使用公钥对数据验签，判断是否成功
 * 11. 验签成功后使用AES密钥解密数据
 */

@Entry
@Component
struct KeyManager {
  @State message: string = "";
  private client: LocalClient = new LocalClient();
  @State messageArray: Message[] = [];

  aboutToAppear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);

    emitter.on(messageEvent, (data: emitter.EventData) => {
      let message: Message = new Message();
      message.message = data.data?.message;
      message.position = data.data?.position;
      this.messageArray.push(message);
    });
  }

  build() {
    RelativeContainer() {
      Row() {
        TextInput({ text: this.message, placeholder: $r('app.string.please_input') })
          .id('input')
          .onChange((value: string) => {
            this.message = value;
          })
          .layoutWeight(4)
        Button($r('app.string.send'))
          .id('button')
          .onClick(() => {
            inputMethod.getController().stopInputSession();
            this.sendMessage(this.message);
            this.message = "";
          })
          .layoutWeight(1)
          .margin({
            left: 10
          })
      }
      .padding({
        left: 10,
        right: 10
      })
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End }
      })
      .height(60)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .id("row_input")

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
            .width('100%')
            .justifyContent(message.position === MessagePosition.Left ? FlexAlign.Start : FlexAlign.End)
            .margin({
              top: 10
            })
          }
        })
      }.id('list')
      .scrollBar(BarState.Off)
      .alignRules({
        bottom: { anchor: 'row_input', align: VerticalAlign.Top },
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End }
      })
      .expandSafeArea([SafeAreaType.KEYBOARD])

    }
    .height('100%')
    .width('100%')
  }

  async sendMessage(message: string) {
    sendProcessMessage("需要发送给服务端的数据是：" + message, MessagePosition.Right);
    await this.client.sendMessageToServer(message);

    setTimeout(async () => {
      await this.client.receiveMessageFromServer();
    }, 2000)
  }
}