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

// [Start top_level_array_classa_apis]
import { PersistenceV2, UIUtils } from '@kit.ArkUI';

class ClassA {
  public propA: number = 0;
  public classAToString() : string {
    return this.propA?.toString()
  }
}

@Entry
@ComponentV2
struct Page1 {
  @Local arr: Array<ClassA> = PersistenceV2.globalConnect({
    type: Array<ClassA>,
    defaultCreator: () => UIUtils.makeObserved(new Array<ClassA>()),
    // 添加defaultSubCreator，通知状态管理框架如何创建ClassA对象
    // 另外持久化后的数据需要加上makeObserved，否则会持久化失败
    defaultSubCreator: () => UIUtils.makeObserved(new ClassA())
  })!;

  build() {
    Column({ space: 10 }) {
      Column({ space: 0 }) {
        Repeat(this.arr)
          .each(ri => {
            Row() {
              Text(`Item: `)
              Text(ri.item?.classAToString ? ri.item?.classAToString(): `classAToString() missing from object, propA: ${ri.item?.propA}`)
            }
          })
          .key((item: ClassA, index: number) => `${index} - ${item?.propA}`)
      }

      Divider().width('100%')
      // 点击'array.push(0)'，重启应用，Repeat数组项是：1, 2, 0
      Button('array.push(0)')
        .onClick(() => {
          let temp = new ClassA();
          temp.propA = 0;
          this.arr.push(UIUtils.makeObserved(temp));
        })
        .fontSize(24)
      // 点击'array.pop()'，重启应用，Repeat数组项是：1, 2
      Button('array.pop()')
        .onClick(() => {
          this.arr.pop();
        })
        .fontSize(24)
      // 点击'array.splice(0)'，重启应用，Repeat数组项为空
      Button('array.splice(0)')
        .onClick(() => {
          this.arr.splice(0);
        })
        .fontSize(24)
      // 点击'splice(1, 0, random)'，重启应用：Repeat组件再次显示相同的数组项
      Button('array.splice(1, 0, random)')
        .onClick(() => {
          let temp = new ClassA();
          temp.propA = Math.round(100 * Math.random());
          this.arr.splice(1, 0, UIUtils.makeObserved(temp));
        })
        .fontSize(24)
      // 点击'array.splice(0, 2, random, random)'，前两个数组项目被替换，记录下来
      // 重启应用：Repeat组件再次显示数组项
      Button('array.splice(0, 2, random, random)')
        .onClick(() => {
          let tempA = new ClassA();
          tempA.propA = Math.round(100 * Math.random());
          this.arr.splice(2, 2,
            UIUtils.makeObserved(tempA),
            UIUtils.makeObserved(tempA));
        })
        .fontSize(24)
      // 点击'array.sort', 对数组项升序排列，重启应用，Repeat组件展示升序数组
      Button('array.sort')
        .onClick(() => {
          this.arr.sort((tempA, tempB)=> tempA?.propA - tempB?.propA);
        })
        .fontSize(24)
      // 点击'array.reverse', 对数组项降序排列，重启应用，Repeat组件展示降序数组
      Button('array.reverse')
        .onClick(() => {
          this.arr.reverse();
        })
        .fontSize(24)
    }
    .width('100%')
  }
}
// [End top_level_array_classa_apis]