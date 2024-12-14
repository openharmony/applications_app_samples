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

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

class Fruit {
  name: string;

  constructor(name: string) {
    this.name = name;
  }
}

@Entry
@Component
struct Index {
  @State result: string = ''
  private items: string[] = [
    'Reset Result Message',
    '1.napiNewInstance',
    '2.napiRemoveWrap'
  ]

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 3 })
      List({ space: '10vp' }) {
        ForEach(this.items, (item: string) => {
          ListItem() {
            Text(item)
              .fontSize(16)
              .width('100%')
              .height(60)
              .textAlign(TextAlign.Center)
              .fontWeight(FontWeight.Bold)
              .borderRadius(30)
              .backgroundColor(Color.White)
              .onClick(() => {
                if (item === 'Reset Result Message') {
                  this.result = '';
                } else if (item === '1.napiNewInstance') {
                  // napi_new_instance
                  // 调用函数，用变量obj接收函数返回的实例化对象
                  let obj = testNapi.newInstance(Fruit, 'test');
                  // 打印实例化对象obj的信息
                  hilog.info(0x0000, 'Node-API', 'napi_new_instance %{public}s', JSON.stringify(obj));
                  this.result = 'napiNewInstanceSuccess';
                } else if (item === '2.napiRemoveWrap') {
                  try {
                    class Obj {
                    }

                    let obj: Obj = {};
                    testNapi.wrap(obj) // napi_wrap
                    testNapi.unWrap(obj) // napi_unwrap
                    testNapi.removeWrap(obj) // napi_remove_wrap
                    this.result = 'napiRemoveWrapSuccess';
                  } catch (error) {
                    hilog.error(0x0000, 'testTag', 'Test Node-API error: %{public}s', error.message);
                    this.result = 'napiRemoveWrapFail';
                  }
                }
              })
          }
        })
      }.scrollBar(BarState.Off)
      .width('90%')
    }.width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({ top: 5 })
  }
}
