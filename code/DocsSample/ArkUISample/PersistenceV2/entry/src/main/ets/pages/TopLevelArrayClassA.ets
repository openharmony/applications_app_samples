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

// [Start top_level_array_classa]
import { PersistenceV2, UIUtils } from '@kit.ArkUI';

@ObservedV2
class ClassA {
  @Trace public propA: string = '';
  @Trace public propB: string = '';

  public report(): string {
    return `${this.propA} - ${this.propB}`;
  }
}

@Entry
@ComponentV2
struct Comp {
  // 持久化顶层数据类型为Array<ClassA>的数据
  @Local arr: Array<ClassA> = PersistenceV2.globalConnect({
    type: Array<ClassA>,
    defaultCreator: () => UIUtils.makeObserved(new Array<ClassA>()),
    // 添加defaultSubCreator，通知状态管理框架如何创建数组项
    // 另外持久化的数据需要加上makeObserved，因为JSON对象本身没有观察能力，自动持久化会失败
    defaultSubCreator: () => UIUtils.makeObserved(new ClassA())
  })!;

  build() {
    Column() {
      Repeat(this.arr)
        .each(ri => {
          Row() {
            Text(`propA '${ri.item.propA}'`)
            Text(`propB '${ri.item.propB}'`)
            Text(`report?.() '${ri.item.report?.()}'`)
          }
        })
      // 点击'add item',显示`propA 'a' propB 'b'report?.'a' - 'b'`, 杀掉应用，再次进入，会显示上次的结果
      Button('add item')
        .onClick(() => {
          let temp: ClassA = new ClassA();
          temp.propA = 'a';
          temp.propB = 'b';
          this.arr.push(temp);
        })
    }
  }
}
// [End top_level_array_classa]