/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start v1_to_v2_observedV2_trace]
@ObservedV2
class InfoTen {
  @Trace public myId: number;
  public name: string;

  constructor(myId?: number, name?: string) {
    this.myId = myId || 0;
    this.name = name || 'aaa';
  }
}

@ComponentV2
struct ChildTen {
  // V2对数据输入有严格的管理，从父组件接受数据时，必须@Param装饰器进行数据接收
  @Param info: InfoTen = new InfoTen();

  build() {
    Column() {
      Text(`Child-V2 info id:${this.info.myId}`) // 显示info:myId
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.info.myId++; // 刷新
        })
    }
  }
}

@Entry
@Component
struct IndexTen {
  // @State info: Info = new Info(); // 错误写法。Class类型，不支持传递，编译器报错；消除编译错误请去掉@State
  info: InfoTen = new InfoTen(); // 正确写法

  build() {
    Column() {
      Text(`Parent-V1 info id:${this.info.myId}`) // 显示info:myId
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.info.myId++; // 刷新
        })

      ChildTen({
        info: this.info,
      })
    }
    .height('100%')
    .width('100%')
  }
}
// [End v1_to_v2_observedV2_trace]