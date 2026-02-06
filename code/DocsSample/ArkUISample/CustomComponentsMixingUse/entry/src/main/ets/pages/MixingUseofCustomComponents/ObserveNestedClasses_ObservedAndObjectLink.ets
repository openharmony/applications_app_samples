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

// [Start observed_object_link]
@ObservedV2
class InfoOne {
  @Trace public myId: number;
  public name: string;

  constructor(myId?: number, name?: string) {
    this.myId = myId || 0;
    this.name = name || 'aaa';
  }
}

@Observed
class MessageInfo1 { // 一层嵌套
  @Track public info: InfoOne; // 防止messageId改变导致info的连带刷新
  @Track public messageId: number; // 防止messageId改变导致info的连带刷新

  constructor(info?: InfoOne, messageId?: number) {
    this.info = info || new InfoOne();
    this.messageId = messageId || 0;
  }
}

@Observed
class MessageInfoNested1 { // 二层嵌套
  public messageInfo: MessageInfo1;

  constructor(messageInfo?: MessageInfo1) {
    this.messageInfo = messageInfo || new MessageInfo1();
  }
}

@ComponentV2
struct GrandSon1 {
  @Param info: InfoOne = new InfoOne();

  build() {
    Column() {
      Text(`ObjectLink info info.myId:${this.info.myId}`) // myId属性被@Trace装饰，可以观测变化
        .fontSize(30)
        .onClick(() => {
          this.info.myId++; // 当前组件和父组件Child1都刷新
        })
    }
  }
}

@Component
struct ChildOne {
  @ObjectLink messageInfo: MessageInfo1;

  build() {
    Column() {
      Text(`ObjectLink MessageInfo messageId:${this.messageInfo.messageId}`) // 经过@ObjectLink拆解之后，可以观测一层类属性变化
        .fontSize(30)
        .onClick(() => {
          this.messageInfo.messageId++; // 当前组件UI刷新
        })
      Divider()
        .color(Color.Blue)
      Text(`ObjectLink MessageInfo info.myId:${this.messageInfo.info.myId}`) // myId属性被@Trace装饰，可以观测变化
        .fontSize(30)
        .onClick(() => {
          this.messageInfo.info.myId++; // 当前组件和GrandSon1子组件的UI都刷新
        })
      GrandSon1({ info: this.messageInfo.info }); // 继续拆解一层子组件
    }
  }
}

@Entry
@Component
struct IndexOne {
  @State messageInfoNested: MessageInfoNested1 = new MessageInfoNested1(); // 三层嵌套的数据，如何观测内部。

  build() {
    Column() {
      // 观察messageInfoNested，@State只有一层观测能力，无法观察到变化
      Text(`messageInfoNested messageId:${this.messageInfoNested.messageInfo.messageId}`)
        .fontSize(30)
        .onClick(() => {
          this.messageInfoNested.messageInfo.messageId++; // 当前组件不刷新，子组件Child1的UI刷新
        })
      Divider()
        .color(Color.Blue)
      // 通过@ObjectLink嵌套观察 messageInfoId
      ChildOne({ messageInfo: this.messageInfoNested.messageInfo }) // 经过拆分后，使用@ObjectLink拆分可以观察到深一层的变化
      Divider()
        .color(Color.Blue)
    }
    .height('100%')
    .width('100%')
    .margin(10)
  }
}
// [End observed_object_link]