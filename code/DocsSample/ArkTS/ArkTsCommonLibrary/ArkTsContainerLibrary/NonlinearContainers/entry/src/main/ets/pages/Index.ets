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

// [Start nonlinear_container]
// 导入HashMap，TreeMap，LightWeightMap，PlainArray模块
import { HashMap, TreeMap, LightWeightMap, PlainArray } from '@kit.ArkTS';

  // [StartExclude nonlinear_container]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

function testHashMap() {
  // [EndExclude nonlinear_container]
  // HashMap
  let hashMap1: HashMap<string, number> = new HashMap();
  hashMap1.set('a', 123); // 增加一个键为'a'，值为123的元素
  let hashMap2: HashMap<number, number> = new HashMap();
  hashMap2.set(4, 123); // 增加一个键为4，值为123的元素
  console.info(`result: ${hashMap2.hasKey(4)}`); // 判断是否含有键为4的元素。输出：result: true
  // [StartExclude nonlinear_container]
  let logMsg = `result: ${hashMap2.hasKey(4)}\n`;
  // [EndExclude nonlinear_container]
  console.info(`result: ${hashMap1.get('a')}`); // 访问键为'a'的元素。输出：result: 123
  // [StartExclude nonlinear_container]
  logMsg += `result: ${hashMap1.get('a')}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testTreeMap() {
  // [EndExclude nonlinear_container]
  // TreeMap
  let treeMap: TreeMap<string, number> = new TreeMap();
  treeMap.set('a', 123); // 增加一个键为'a'，值为123的元素
  treeMap.set('6', 356); // 增加一个键为'6'，值为356的元素
  console.info(`result: ${treeMap.get('a')}`); // 访问键为'a'的元素。输出：result: 123
  // [StartExclude nonlinear_container]
  let logMsg = `result: ${treeMap.get('a')}\n`;
  // [EndExclude nonlinear_container]
  console.info(`result: ${treeMap.getFirstKey()}`); // 访问首元素。输出：result: 6
  // [StartExclude nonlinear_container]
  logMsg += `result: ${treeMap.getFirstKey()}\n`;
  // [EndExclude nonlinear_container]
  console.info(`result: ${treeMap.getLastKey()}`); // 访问尾元素。输出：result: a
  // [StartExclude nonlinear_container]
  logMsg += `result: ${treeMap.getLastKey()}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testLightWeightMap() {
  // [EndExclude nonlinear_container]
  // LightWeightMap
  let lightWeightMap: LightWeightMap<string, number> = new LightWeightMap();
  lightWeightMap.set('x', 123); // 增加一个键为'x'，值为123的元素
  lightWeightMap.set('8', 356); // 增加一个键为'8'，值为356的元素
  console.info(`result: ${lightWeightMap.get('a')}`); // 访问键为'a'的元素。输出：result: undefined
  // [StartExclude nonlinear_container]
  let logMsg = `result: ${lightWeightMap.get('a')}\n`;
  // [EndExclude nonlinear_container]
  console.info(`result: ${lightWeightMap.get('x')}`); // 访问键为'x'的元素，获取其值。输出：result: 123
  // [StartExclude nonlinear_container]
  logMsg += `result: ${lightWeightMap.get('x')}\n`;
  // [EndExclude nonlinear_container]
  console.info(`result: ${lightWeightMap.getIndexOfKey('8')}`); // 访问键为'8'的元素，获取其索引。输出：result: 0
  // [StartExclude nonlinear_container]
  logMsg += `result: ${lightWeightMap.getIndexOfKey('8')}`;

  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testPlainArray() {
  // [EndExclude nonlinear_container]
  // PlainArray
  let plainArray: PlainArray<string> = new PlainArray();
  plainArray.add(1, 'sdd'); // 增加一个键为1，值为'sdd'的元素
  plainArray.add(2, 'sff'); // 增加一个键为2，值为'sff'的元素
  console.info(`result: ${plainArray.get(1)}`); // 访问键为1的元素，获取值。输出：result: sdd
  // [StartExclude nonlinear_container]
  let logMsg = `result: ${plainArray.get(1)}\n`;
  // [EndExclude nonlinear_container]
  console.info(`result: ${plainArray.getKeyAt(1)}`); // 访问索引为1的元素，获取键。输出：result: 2
  // [End nonlinear_container]
  logMsg += `result: ${plainArray.getKeyAt(1)}`;

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
          Text($r('app.string.test_hashmap')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testHashMap();
          this.currentState = $r('app.string.test_hashmap_complete');
        })

        Column() {
          Text($r('app.string.test_treemap')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testTreeMap();
          this.currentState = $r('app.string.test_treemap_complete');
        })

        Column() {
          Text($r('app.string.test_lightweightmap')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testLightWeightMap();
          this.currentState = $r('app.string.test_lightweightmap_complete');
        })

        Column() {
          Text($r('app.string.test_plainarray')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testPlainArray();
          this.currentState = $r('app.string.test_plainarray_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}