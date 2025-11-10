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

import { ComponentCard } from '../../common/Card'
import common from '@ohos.app.ability.common';
// 消息类型定义
// [Start listitem_data_structure]
interface Message {
  id: number
  content: ResourceStr
  sender: ResourceStr
}
// [End listitem_data_structure]
@Entry
@Component
export struct ListChatRoom {
  // 自定义消息组件
  @Builder
  MessageItem(message: Message) {
    Column() {
      Text(`${message.sender}: ${message.content}`)
        .fontSize(16)
        .textAlign(TextAlign.Start)
        .padding(10)
        .backgroundColor(message.sender === 'system' ? '#F0F0F0' : '#E6F3FF')
        .borderRadius(8)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .margin({ bottom: 8 })
  }

  // 发送消息方法
  sendMessage() {
    if (this.inputText.trim()) {
      this.messages = [...this.messages, {
        id: Date.now(),
        content: this.inputText,
        sender: 'audience'
      }]
      this.inputText = ''
    }
  }

  // 输入框内容
  @State inputText: string = ''

  // 消息列表数据
  // [Start construct_list_structure]
  @State messages: Message[] = [];

  aboutToAppear(): void {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    // app.string.welcome_live_room资源文件中的value值为'欢迎来到直播间'
    const welcomeLiveRoom = context.resourceManager.getStringByNameSync('welcome_live_room');
    // app.string.system资源文件中的value值为'系统'
    const system = context.resourceManager.getStringByNameSync('system');
    // app.string.hello_everyone资源文件中的value值为'大家好啊~'
    const helloEveryone = context.resourceManager.getStringByNameSync('hello_everyone');
    // app.string.anchors资源文件中的value值为'主播'
    const anchors = context.resourceManager.getStringByNameSync('anchors');
    this.messages = [
      { id: 1, content: welcomeLiveRoom, sender: system },
      { id: 2, content: helloEveryone, sender: anchors }
    ];
  }

  build() {
    // [StartExclude construct_list_structure]
    NavDestination() {
      Column({ space: 12 }) {
        // $r('app.string.ListChatRoom_title')需要替换为开发者所需的资源文件
        ComponentCard({ title: $r('app.string.ListChatRoom_title') }) {
          // [EndExclude construct_list_structure]
          Column() {
            // 聊天消息区域
            List({ space: 10 }) {
              ForEach(this.messages, (item: Message) => {
                ListItem() {
                  this.MessageItem(item)
                }
              }, (item: Message) => item.id.toString())
            }
            .stackFromEnd(true)
            .layoutWeight(1)  // 占据剩余空间
            .alignListItem(ListItemAlign.Center)

            // [StartExclude construct_list_structure]
            // 输入区域
            Row({ space: 10 }) {
              // app.string.say_something资源文件中的value值为'说点什么...'
              TextInput({ text: this.inputText, placeholder: $r('app.string.say_something') })
                .layoutWeight(1)
                .onChange((value: string) => {
                  this.inputText = value
                })
                .onSubmit(() => { // 回车发送
                  this.sendMessage()
                })

              Button($r('app.string.message'), { type: ButtonType.Capsule })
                .backgroundColor('#007AFF')
                .onClick(() => {
                  this.sendMessage()
                })
            }
            .padding(10)
            .backgroundColor('#F5F5F5')
            // [EndExclude construct_list_structure]
          }
          .width('100%')
          .height('100%')
          // [StartExclude construct_list_structure]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ListChatRoom_title'))
    // [EndExclude construct_list_structure]
  }
  // [End construct_list_structure]
}