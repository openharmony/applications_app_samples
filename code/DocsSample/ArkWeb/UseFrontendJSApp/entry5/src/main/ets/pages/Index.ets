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

import testNapi from 'libentry.so';
import web_webview from '@ohos.web.webview';
import { BusinessError } from '@ohos.base';

@Entry
@Component
struct Index {
  @State webTag: string = 'postMessage';
  controller: web_webview.WebviewController = new web_webview.WebviewController(this.webTag);
  @State h5Log: string = 'Display received message send from HTML';

  aboutToAppear() {
    web_webview.WebviewController.setWebDebuggingAccess(true);
    // 初始化web Native Development Kit
    testNapi.nativeWebInit(this.webTag);
  }

  aboutToDisAppear() {
    console.error('aboutToDisAppear');
  }

  build() {
    Scroll() {
      Column({ space: 10 }) {
        // 展示H5接收到的内容
        Text($r('app.string.H5_Side_Message_Display_From_App'))
        TextArea({text: this.h5Log})
          .id('log_area')
          .width('100%')
          .height(100)
          .border({ width: 1 })
        Text($r('app.string.App_Side_Button'))
        Row() {
          Button('createNoControllerTagPort')
            .id('create_no_tag_btn')
            .onClick(() => {
              try {
                testNapi.createWebMessagePorts('noTag');
              } catch (error) {
                console.error(
                  `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
            })
          Button('createPort')
            .id('create_port_btn')
            .onClick(() => {
              try {
                testNapi.createWebMessagePorts(this.webTag);
              } catch (error) {
                console.error(
                  `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
            })
        }

        Row({ space: 10 }) {

          Button('setHandler')
            .id('set_handler_btn')
            .onClick(() => {
              try {
                testNapi.setMessageEventHandler(this.webTag);
              } catch (error) {
                console.error(
                  `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
            })

          Button('setHandlerThread')
            .id('set_handler_thread_btn')
            .onClick(() => {
              try {
                testNapi.setMessageEventHandlerThread(this.webTag);
              } catch (error) {
                console.error(
                  `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
            })
        }

        Row({ space: 10 }) {
          Button('SendString')
            .id('send_string_btn')
            .onClick(() => {
              try {
                this.h5Log = ''
                testNapi.postMessage(this.webTag);
              } catch (error) {
                console.error(
                  `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
            })
          Button('SendStringThread')
            .id('send_string_thread_btn')
            .onClick(() => {
              try {
                this.h5Log = ''
                testNapi.postMessageThread(this.webTag);
              } catch (error) {
                console.error(
                  `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
            })
        }

        Row({ space: 10 }) {
          Button('SendBuffer')
            .id('send_buffer_btn')
            .onClick(() => {
              try {
                this.h5Log = ''
                testNapi.postBufferMessage(this.webTag);
              } catch (error) {
                console.error(
                  `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
            })
          Button('SendNone')
            .id('send_none_btn')
            .onClick(() => {
              try {
                this.h5Log = ''
                testNapi.postNoneMessage(this.webTag);
              } catch (error) {
                console.error(
                  `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
            })
        }

        Row({ space: 10 }) {

          Button('closePort')
            .id('close_port_btn')
            .onClick(() => {
              try {
                testNapi.closeMessagePort(this.webTag);
              } catch (error) {
                console.error(
                  `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
            })
          Button('destroyNullPort')
            .id('destroy_null_btn')
            .onClick(() => {
              try {
                testNapi.destroyNullMessagePort(this.webTag);
              } catch (error) {
                console.error(
                  `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
            })
          Button('destroyPort')
            .id('destroy_port_btn')
            .onClick(() => {
              try {
                testNapi.destroyMessagePort(this.webTag);
              } catch (error) {
                console.error(
                  `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
              }
            })
        }
        .width('100%')
        .padding(10)
        .border({ width: 1 })

        Column({ space: 10 }) {
          Text($r('app.string.H5_Side_Send_Button'))
          Row({ space: 10 }) {
            Button('H5String')
              .id('h5_send_string_btn')
              .onClick(() => {
                try {
                  this.controller.runJavaScript('for(var i = 0; i < 2000; i++) postStringToApp()');
                } catch (error) {
                  console.error(
                    `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
                }
              })
            Button('H5Buffer')
              .id('h5_send_buffer_btn')
              .onClick(() => {
                try {
                  this.controller.runJavaScript('postBufferToApp()');
                } catch (error) {
                  console.error(
                    `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
                }
              })
            Button('H5Number')
              .id('h5_send_number_btn')
              .onClick(() => {
                try {
                  this.controller.runJavaScript('postNumberToApp()');
                } catch (error) {
                  console.error(
                    `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
                }
              })
          }

          Row({ space: 10 }) {
            Button('H5Json')
              .id('h5_send_json_btn')
              .onClick(() => {
                try {
                  this.controller.runJavaScript('postJsonToApp()');
                } catch (error) {
                  console.error(
                    `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
                }
              })
            Button('H5Array')
              .id('h5_send_array_btn')
              .onClick(() => {
                try {
                  this.controller.runJavaScript('postArrayStringToApp()');
                } catch (error) {
                  console.error(
                    `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
                }
              })
            Button('H5Object')
              .id('h5_send_object_btn')
              .onClick(() => {
                try {
                  this.controller.runJavaScript('postObjectToApp()');
                } catch (error) {
                  console.error(
                    `ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
                }
              })
          }
        }
        .width('100%')
        .margin(10)
        .padding(10)
        .border({ width: 1 })

        Web({ src: $rawfile('index.html'), controller: this.controller })
          .onConsole((event) => {
            if (event) {
              let msg = event.message.getMessage();
              if (msg.startsWith('H5')) {
                this.h5Log = event.message.getMessage() + '\n' + this.h5Log;
              }
            }
            return false;
          })
      }
    }.height('100%')
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}
