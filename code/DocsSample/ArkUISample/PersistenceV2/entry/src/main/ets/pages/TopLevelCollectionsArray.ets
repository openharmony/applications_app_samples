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

// [Start top_level_collections_array]
import { PersistenceV2, UIUtils } from '@kit.ArkUI';
import { collections } from '@kit.ArkTS';

@Entry
@ComponentV2
struct Page1 {
  // 支持直接持久化collections.Array的类型
  @Local array: collections.Array<number> = PersistenceV2.globalConnect({
    // 定义持久化的数据类型
    type: collections.Array<number>,
    // 定义默认构造器，返回时需要调用makeObserved，才能实现自动持久化
    defaultCreator: () => UIUtils.makeObserved(new collections.Array<number>(1,2))
  })!;
  // 基于collections.Array构建Repeat的数据源
  toArray<T>(array: collections.Array<T>): Array<T> {
    const result = new Array<T>();
    array.forEach((item: T) => result.push(item));
    return result;
  }

  build() {
    Column({ space: 10 }) {
      Column({ space: 0 }) {
        Repeat(this.toArray(this.array))
          .each(ri => {
            Row() {
              Text(`Item: `)
              Text(`${ri.item}`)
            }
          })
          .key((item: number, index: number) => `${index} - ${item}`)
      }
      Divider().width('100%')
      // 点击'array.push(0)'，重启应用，Repeat数组项是：1, 2, 0
      Button('array.push(0)')
        .onClick(() => {
          this.array.push(Math.round(0));
        })
        .fontSize(24)
      // 点击'array.pop()'，重启应用，Repeat数组项是：1, 2
      Button('array.pop()')
        .onClick(() => {
          this.array.pop();
        })
        .fontSize(24)
      // 点击'array.splice(0)'，重启应用，Repeat数组项为空
      Button('array.splice(0)')
        .onClick(() => {
          this.array.splice(0);
        })
        .fontSize(24)
      // 点击'splice(1, 0, random)'，重启应用：Repeat组件再次显示相同的数组项
      Button('array.splice(1, 0, random)')
        .onClick(() => {
          this.array.splice(1, 0, Math.round(100*Math.random()));
        })
        .fontSize(24)
      // 点击'array.splice(0, 2, random, random)'，前两个数组项目被替换，记录下来
      // 重启应用：Repeat组件再次显示数组项
      Button('array.splice(0, 2, random, random)')
        .onClick(() => {
          this.array.splice(2, 2, Math.round(100*Math.random()), Math.round(100*Math.random()));
        })
        .fontSize(24)
      // 点击'array.sort', 对数组项升序排列，重启应用，Repeat组件展示升序数组
      Button('array.sort')
        .onClick(() => {
          this.array.sort((a, b) => a -b);
        })
        .fontSize(24)
      // 点击'array.reverse', 对数组项降序排列，重启应用，Repeat组件展示降序数组
      Button('array.reverse')
        .onClick(() => {
          this.array.reverse();
        })
        .fontSize(24)
    }
    .width('100%')
  }
}
// [End top_level_collections_array]