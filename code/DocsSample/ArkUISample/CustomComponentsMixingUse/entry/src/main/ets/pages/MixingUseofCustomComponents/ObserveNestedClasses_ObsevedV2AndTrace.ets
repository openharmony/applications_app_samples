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
// [Start obseved_trace]
@ObservedV2
class Info {
  @Trace public myId: number;
  public name: string;

  constructor(myId?: number, name?: string) {
    this.myId = myId || 0;
    this.name = name || 'aaa';
  }
}

@Observed
class MessageInfo { // 一层嵌套
  @Track public info: Info;        // 防止messageId改变导致info的连带刷新
  @Track public messageId: number; // 防止messageId改变导致info的连带刷新

  constructor(info?: Info, messageId?: number) {
    this.info = info || new Info();   // 使用传入的info或创建一个新的Info
    this.messageId = messageId || 0;
  }
}

@Observed
class MessageInfoNested { // 二层嵌套，MessageInfoNested如果是被@ObservedV2装饰，则不可以被V1的状态变量更新相关的装饰器装饰，如@State
  public messageInfo: MessageInfo;

  constructor(messageInfo?: MessageInfo) {
    this.messageInfo = messageInfo || new MessageInfo();
  }
}

@Component
struct Child {
  @ObjectLink messageInfo: MessageInfo;

  build() {
    Column() {
      Text(`ObjectLink MessageInfo messageId:${this.messageInfo.messageId}`)  // 经过@ObjectLink拆解之后，可以观测一层类属性变化
        .fontSize(30)
        .onClick(() => {
          this.messageInfo.messageId++;
        })
    }
  }
}

@Entry
@Component
struct Index {
  @State messageInfoNested: MessageInfoNested = new MessageInfoNested();  // 三层嵌套的数据，如何观测内部。

  build() {
    Column() {
      // 观察messageInfoNested，@State只有一层观测能力，无法观察到变化
      Text(`messageInfoNested messageId:${this.messageInfoNested.messageInfo.messageId}`)
        .fontSize(30)
        .onClick(() => {
          this.messageInfoNested.messageInfo.messageId++;
        })
      Divider()
        .color(Color.Blue)
      Text(`messageInfoNested name:${this.messageInfoNested.messageInfo.info.name}`)   // 未被@Trace修饰，无法观测
        .fontSize(30)
        .onClick(() => {
          this.messageInfoNested.messageInfo.info.name += 'a';
        })
      Divider()
        .color(Color.Blue)
      Text(`messageInfoNested myId:${this.messageInfoNested.messageInfo.info.myId}`)   // 被@Trace修饰，无论嵌套多少层都能观测
        .fontSize(30)
        .onClick(() => {
          this.messageInfoNested.messageInfo.info.myId++;
        })
      Divider()
        .color(Color.Blue)
      // 通过@ObjectLink嵌套观察 messageInfoId
      Child({messageInfo: this.messageInfoNested.messageInfo})      // 经过拆分后，使用@ObjectLink拆分可以观察到深一层的变化
    }
    .height('100%')
    .width('100%')
    .margin(10)
  }
}
// [End obseved_trace]