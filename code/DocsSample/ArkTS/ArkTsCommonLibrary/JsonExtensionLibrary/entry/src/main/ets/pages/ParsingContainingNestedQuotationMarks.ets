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

// [Start json_nesting_method1]
// [Start json_nesting_method2]
import { JSON } from '@kit.ArkTS';

interface Info {
  name: string;
  age: number;
}

interface TestObj {
  info: Info;
}

interface TestStr {
  info: string;
}
// [StartExclude json_nesting_method1]
// [StartExclude json_nesting_method2]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

function testParsing1() {
  // [EndExclude json_nesting_method1]
  /*
   * 将原始JSON字符串`{"info": "{"name": "zhangsan", "age": 18}"}`
   * 修改为`{"info": {"name": "zhangsan", "age": 18}}`。
   * */
  let jsonStr = `{"info": {"name": "zhangsan", "age": 18}}`;
  let obj1  = JSON.parse(jsonStr) as TestObj;
  console.info(JSON.stringify(obj1));    //{"info":{"name":"zhangsan","age":18}}
  // 获取JSON字符串中的name信息
  console.info(obj1.info.name); // zhangsan
  // [End json_nesting_method1]
  let logMsg = 'JSON.stringify(obj1): ' + JSON.stringify(obj1) + '\nobj1.info.name: ' + obj1.info.name;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testParsing2() {
  // [EndExclude json_nesting_method2]
  /*
   * 将原始JSON字符串`{"info": "{"name": "zhangsan", "age": 18}"}`进行双重转义，
   * 修改为`{"info": "{\\"name\\": \\"zhangsan\\", \\"age\\": 18}"}`。
   * */
  let jsonStr = `{"info": "{\\"name\\": \\"zhangsan\\", \\"age\\": 18}"}`;
  let obj2 = JSON.parse(jsonStr) as TestStr;
  console.info(JSON.stringify(obj2));    // {"info":"{\"name\": \"zhangsan\", \"age\": 18}"}
  // 获取JSON字符串中的name信息
  let obj3 = JSON.parse(obj2.info) as Info;
  console.info(obj3.name); // zhangsan
  // [End json_nesting_method2]
  let logMsg = 'JSON.stringify(obj2): ' + JSON.stringify(obj2) + '\nobj3.name: ' + obj3.name;
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
          Text($r('app.string.test_parsing_nested_quotes_method1')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testParsing1();
          this.currentState = $r('app.string.test_parsing_nested_quotes_method1_complete');
        })

        Column() {
          Text($r('app.string.test_parsing_nested_quotes_method2')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testParsing2();
          this.currentState = $r('app.string.test_parsing_nested_quotes_method2_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}