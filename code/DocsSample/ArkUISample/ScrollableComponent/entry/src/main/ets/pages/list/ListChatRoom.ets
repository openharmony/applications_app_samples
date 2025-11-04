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
// [Start Listitem_data_structure]
// 消息类型定义
interface Message {
  id: number
  content: string
  sender: string
}
// [End Listitem_data_structure]
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
  // [Start Construct_list_structure]
  // 消息列表数据
  @State messages: Message[] = [
    { id: 1, content: 'Welcome to the live streaming room！', sender: 'system' },
    { id: 2, content: 'Hello everyone!~', sender: 'system' }
  ]

  // 输入框内容
  @State inputText: string = ''

  build() {
    // [StartExclude Construct_list_structure]
    NavDestination() {
      Column({ space: 12 }) {
        // $r('app.string.ListChatRoom_title')需要替换为开发者所需的资源文件
        ComponentCard({ title: $r('app.string.ListChatRoom_title') }) {
          // [EndExclude Construct_list_structure]
          Column() {
            // 聊天消息区域
            List({ space: 10 }) {
              ForEach(this.messages, (item: Message) => {
                ListItem() {
                  this.MessageItem(item)
                }
              }, (item: Message) => item.id.toString())
            }
            .layoutWeight(1)  // 占据剩余空间
            .alignListItem(ListItemAlign.Center)

            // 输入区域
            Row({ space: 10 }) {
              TextInput({ text: this.inputText, placeholder: 'Say something...' })
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
          }
          .width('100%')
          .height('100%')
          // [StartExclude Construct_list_structure]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ListChatRoom_title'))
    // [EndExclude Construct_list_structure]
  }
  // [End Construct_list_structure]
}