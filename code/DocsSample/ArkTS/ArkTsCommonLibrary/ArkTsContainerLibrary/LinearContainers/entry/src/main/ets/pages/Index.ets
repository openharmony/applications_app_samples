/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start linear_container]
import { ArrayList, Deque, Stack, List } from '@kit.ArkTS'; // 导入ArrayList,Deque,Stack,List模块。

// [StartExclude linear_container]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

function testArrayList() {
  // [EndExclude linear_container]
  let arrayList1: ArrayList<string> = new ArrayList();
  arrayList1.add('a'); // 增加一个值为'a'的元素。
  let arrayList2: ArrayList<number> = new ArrayList();
  arrayList2.add(1); // 增加一个值为1的元素。
  console.info(`result: ${arrayList2[0]}`); // 访问索引为0的元素。输出：result: 1。
  // [StartExclude linear_container]
  let logMsg = `result: ${arrayList2[0]}\n`;
  // [EndExclude linear_container]
  arrayList1[0] = 'one'; // 修改索引为0的元素。
  console.info(`result: ${arrayList1[0]}`); // 输出：result: one。
  // [StartExclude linear_container]
  logMsg += `result: ${arrayList1[0]}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testDeque() {
  // [EndExclude linear_container]
  let deque1: Deque<string> = new Deque();
  deque1.insertFront('a'); // 头部增加一个值为'a'的元素。
  let deque2: Deque<number> = new Deque();
  deque2.insertFront(1); // 头部增加一个值为1的元素。
  console.info(`result: ${deque2.getFirst()}`); // 访问队列首部的元素。输出：result: 1。
  // [StartExclude linear_container]
  let logMsg = `result: ${deque2.getFirst()}\n`;
  // [EndExclude linear_container]
  deque1.insertEnd('one'); // 尾部增加一个值为'one'的元素。
  console.info(`result: ${deque1.getLast()}`); // 访问队列尾部的元素。输出：result: one。
  // [StartExclude linear_container]
  logMsg += `result: ${deque1.getLast()}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testStack() {
  // [EndExclude linear_container]
  let stack1: Stack<string> = new Stack();
  stack1.push('a'); // 向栈里增加一个值为'a'的元素。
  let stack2: Stack<number> = new Stack();
  stack2.push(1); // 向栈里增加一个值为1的元素。
  console.info(`result: ${stack1.peek()}`); // 访问栈顶元素。输出：result: a。
  // [StartExclude linear_container]
  let logMsg = `result: ${stack1.peek()}\n`;
  // [EndExclude linear_container]
  console.info(`result: ${stack2.pop()}`); // 删除栈顶元素并返回该删除元素。输出：result: 1。
  // [StartExclude linear_container]
  logMsg += `result: ${stack2.pop()}\n`;
  // [EndExclude linear_container]
  console.info(`result: ${stack2.length}`); // 输出：result: 0。
  // [StartExclude linear_container]
  logMsg += `result: ${stack2.length}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testList() {
  // [EndExclude linear_container]
  let list1: List<string> = new List();
  list1.add('a'); // 增加一个值为'a'的元素。
  let list2: List<number> = new List();
  list2.insert(0, 0); // 在0号位置插入（增加）一个值为0的元素。
  let list3: List<Array<number>> = new List();
  let b2 = [1, 2, 3];
  list3.add(b2); // 增加一个Array类型的元素。
  console.info(`result: ${list1[0]}`); // 访问索引为0的元素。输出：result: a。
  // [StartExclude linear_container]
  let logMsg = `result: ${list1[0]}\n`;
  // [EndExclude linear_container]
  console.info(`result: ${list3.get(0)}`); // 访问索引为0的元素。输出：result: 1,2,3。
  // [End linear_container]
  logMsg += `result: ${list3.get(0)}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

@Entry
@Component
struct IndexArkTs {
  @State currentState: string | ResourceStr = $r('app.string.uninitialized');
  @State logMessages: string | ResourceStr = $r('app.string.no_log_info');

  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }

  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  build() {
    Scroll() {
      Column() {
        Column() {
          Text($r('app.string.status_info_title'))
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.current_status'))
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.currentState)
              .fontSize(14)
              .fontColor('#007DFF')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.log_info'))
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.logMessages)
                .fontSize(12)
                .fontColor('#52C41A')
                .width('100%')
                .padding(10)
                .backgroundColor('#F0F0F0')
                .borderRadius(8)
            }
            .width('100%')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 10 })
        }
        .width('100%')
        .padding(18)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 16 })

        Column() {
          Text($r('app.string.test_arraylist')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testArrayList();
          this.currentState = $r('app.string.test_arraylist_complete');
        })

        Column() {
          Text($r('app.string.test_deque')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testDeque();
          this.currentState = $r('app.string.test_deque_complete');
        })

        Column() {
          Text($r('app.string.test_stack')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testStack();
          this.currentState = $r('app.string.test_stack_complete');
        })

        Column() {
          Text($r('app.string.test_list')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testList();
          this.currentState = $r('app.string.test_list_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}