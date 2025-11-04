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
// [Start obseved_object_link]
@Observed
class Info1 {
  public myId: number;
  public name: string;

  constructor(myId?: number, name?: string) {
    this.myId = myId || 0;
    this.name = name || 'aaa';
  }
}

@Observed
class MessageInfo1 {         // 一层嵌套
  @Track public info: Info1;        // 防止messageId改变导致info的连带刷新
  @Track public messageId: number; // 防止messageId改变导致info的连带刷新

  constructor(info?: Info1, messageId?: number) {
    this.info = info || new Info1();
    this.messageId = messageId || 0;
  }
}

@Observed
class MessageInfoNested1 {     // 二层嵌套
  public messageInfo: MessageInfo1;

  constructor(messageInfo?: MessageInfo1) {
    this.messageInfo = messageInfo || new MessageInfo1();
  }
}

@Component
struct GrandSon1 {
  @ObjectLink info1: Info1;

  build() {
    Column() {
      Text(`ObjectLink info info.myId:${this.info1.myId}`)  // 经过@ObjectLink拆解两次之后，观测到变化
        .fontSize(30)
        .onClick(() => {
          this.info1.myId++;
        })
    }
  }
}

@Component
struct Child1 {
  @ObjectLink messageInfo: MessageInfo1;

  build() {
    Column() {
      Text(`ObjectLink MessageInfo messageId:${this.messageInfo.messageId}`)  // 经过@ObjectLink拆解之后，可以观测一层类属性变化
        .fontSize(30)
        .onClick(() => {
          this.messageInfo.messageId++;
        })
      Divider()
        .color(Color.Blue)
      Text(`ObjectLink MessageInfo info.myId:${this.messageInfo.info.myId}`)  // 经过@ObjectLink拆解之后，依旧观测不到变化
        .fontSize(30)
        .onClick(() => {
          this.messageInfo.info.myId++;
        })
      GrandSon1({info1: this.messageInfo.info});                // 继续拆解一层子组件
    }
  }
}

@Entry
@Component
struct Index1 {
  @State messageInfoNested: MessageInfoNested1 = new MessageInfoNested1();  // 三层嵌套的数据，需要对所有数据进行观测。

  build() {
    Column() {
      // 观察messageInfoNested
      Text(`messageInfoNested messageId:${this.messageInfoNested.messageInfo.messageId}`)  // @State只有一层类属性观测能力，无法观察到变化
        .fontSize(30)
        .onClick(() => {
          this.messageInfoNested.messageInfo.messageId++;
        })
      Divider()
        .color(Color.Blue)
      // 通过@ObjectLink嵌套观察 messageInfoId
      Child1({messageInfo: this.messageInfoNested.messageInfo})      // 经过拆分后，使用@ObjectLink拆分可以观察到深一层的变化
      Divider()
        .color(Color.Blue)
    }
    .height('100%')
    .width('100%')
    .margin(10)
  }
}
// [End obseved_object_link]