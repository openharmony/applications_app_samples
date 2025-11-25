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

// [Start create_a_message_port_to_implement_communication_between_the_two_ends]
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  ports: webview.WebMessagePort[] = [];
  @State sendFromEts: string = 'Send this message from ets to HTML';
  @State receivedFromHtml: string = 'Display received message send from HTML';

  build() {
    Column() {
      // 展示接收到的来自HTML的内容
      Text(this.receivedFromHtml);
      // 输入框的内容发送到HTML
      TextInput({ placeholder: 'Send this message from ets to HTML' })
        .onChange((value: string) => {
          this.sendFromEts = value;
        })

      // 该内容可以放在onPageEnd生命周期中调用。
      Button('postMessage')
        .onClick(() => {
          try {
            // 1、创建两个消息端口。
            this.ports = this.controller.createWebMessagePorts();
            if (this.ports && this.ports[0] && this.ports[1]) {
              // 2、在应用侧的消息端口(如端口1)上注册回调事件。
              this.ports[1].onMessageEvent((result: webview.WebMessage) => {
                let msg = 'Got msg from HTML:';
                if (typeof (result) === 'string') {
                  console.info(`received string message from html5, string is: ${result}`);
                  msg = msg + result;
                } else if (typeof (result) === 'object') {
                  if (result instanceof ArrayBuffer) {
                    console.info(`received arraybuffer from html5, length is: ${result.byteLength}`);
                    msg = msg + 'length is ' + result.byteLength;
                  } else {
                    console.info('not support');
                  }
                } else {
                  console.info('not support');
                }
                this.receivedFromHtml = msg;
              })
              // 3、将另一个消息端口(如端口0)发送到HTML侧，由HTML侧保存并使用。
              this.controller.postMessage('__init_port__', [this.ports[0]], '*');
            } else {
              console.error(`ports is null, Please initialize first`);
            }
          } catch (error) {
            console.error(
              `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })

      // 4、使用应用侧的端口给另一个已经发送到html的端口发送消息。
      Button('SendDataToHTML')
        .onClick(() => {
          try {
            if (this.ports && this.ports[1]) {
              this.ports[1].postMessageEvent(this.sendFromEts);
            } else {
              console.error(`ports is null, Please initialize first`);
            }
          } catch (error) {
            console.error(
              `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })

      // 5、关闭端口。  
      Button('closePort')
      .onClick(() => {
        try {
          if (this.ports && this.ports.length == 2) {
            this.ports[0].close();
            this.ports = [];
          } else {
            console.error(`ports is null, not need close`);
          }
        } catch (error) {
          console.error(
            `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
        }
      })
      Web({ src: $rawfile('index.html'), controller: this.controller })
    }
  }
}
// [End create_a_message_port_to_implement_communication_between_the_two_ends]