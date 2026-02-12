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

// [Start call_want]
// 混淆前
import { Want } from '@kit.AbilityKit';
  // [StartExclude call_want]
// [Start import_json]
// 示例JSON文件结构（ImportJson.json）：
/*
{
  "jsonObj": {
    "jsonProperty": "value"
  }
}
 */

// 混淆前
import jsonData from './ImportJson.json';
// [StartExclude import_json]
// [Start call_myInfo]
// FileOutside.ts
import { MyInfo } from './FileInside';
  // [StartExclude call_myInfo]
// [Start ns_import]
// import.ts
import { NS } from './ExportNs';
  // [StartExclude ns_import]
// [Start call_addNum]
// example.ets
// 混淆前
import testNapi from 'libentry.so';
  // [StartExclude call_addNum]
// [Start call_hsp]
// entry模块
import { addNum } from 'sharedlibrary';

addNum(1, 2);
// [End call_hsp]

let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

function testObjObfuscation() {
  // [EndExclude call_want]
  let petalMapWant: Want = {
    bundleName: 'com.example.myapplication',
    uri: 'maps://',
    parameters: {
      linkSource: 'com.other.app'
    }
  }
  // [End call_want]

  let str = JSON.stringify(petalMapWant);
  console.info(`petalMapWant = ${str}`);
  let logMsg = `petalMapWant = ${str}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testPropertyObfuscation() {
  // [EndExclude call_myInfo]
  const person: MyInfo = {
    age: 20,
    address: {
      city1: 'shanghai'
    }
  }
  // [End call_myInfo]

  let str = JSON.stringify(person);
  console.info(`person = ${str}`);
  let logMsg = `person = ${str}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// [Start add_call]
// main.ts
async function loadAndUseAdd() {
  let result: number = 0;
  try {
    const mathUtils = await import('./ExportUtils');
    result = mathUtils.add(2, 3);
    console.info(`result = ${result}`);
  } catch (error) {
    console.error('Failure reason:', error);
  }
}

loadAndUseAdd();
// [End add_call]

function testExportNamespace() {
  // [EndExclude ns_import]
  NS.foo();
  // [End ns_import]
}

function testLibentryAdd() {
  // [EndExclude call_addNum]
  let sun = testNapi.addNum(1, 2);
  // [End call_addNum]

  console.info(`sun = ${sun}`);
  let logMsg = `sun = ${sun}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testHsp() {
  let sun = addNum(1, 2);

  console.info(`sun = ${sun}`);
  let logMsg = `sun = ${sun}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [EndExclude import_json]
let jsonProp = jsonData.jsonObj.jsonProperty;
// [End import_json]

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
          Text($r('app.string.test_obj_obfuscation')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testObjObfuscation();
          this.currentState = $r('app.string.test_obj_obfuscation_complete');
        })

        Column() {
          Text($r('app.string.test_property_obfuscation')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testPropertyObfuscation();
          this.currentState = $r('app.string.test_property_obfuscation_complete');
        })

        Column() {
          Text($r('app.string.test_external_function')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          loadAndUseAdd();
          this.currentState = $r('app.string.test_external_function_complete');
        })

        Column() {
          Text($r('app.string.test_external_namespace')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testExportNamespace();
          this.currentState = $r('app.string.test_external_namespace_complete');
        })

        Column() {
          Text($r('app.string.test_napi')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testLibentryAdd();
          this.currentState = $r('app.string.test_napi_complete');
        })

        Column() {
          Text($r('app.string.test_hsp')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testHsp();
          this.currentState = $r('app.string.test_hsp_complete');
        })

      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}

@Component
export struct MainPage {
  @State messageStr: string = 'Hello World';

  build() {
  }
}