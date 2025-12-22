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
// [Start Array_rom_shallow_copy]
import { collections } from '@kit.ArkTS';
import { UIUtils } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0xF811;
const TAG = '[Sample_MakeObserved]';

@Sendable
class Info {
  public id: number = 0;

  constructor(id: number) {
    this.id = id;
  }
}


@Entry
@ComponentV2
struct Page6 {
  set: collections.Set<Info> = UIUtils.makeObserved(new collections.Set<Info>([new Info(10), new Info(20)]));

  build() {
    Column() {
      // 因为ForEach不支持迭代器，所以需要使用Array.from浅拷贝生成数组。
      // 但是浅拷贝生成的新的数组没有观察能力，为了ForEach组件在访问item的时候是可观察的数据，所以需要重新调用makeObserved。
      ForEach((UIUtils.makeObserved(Array.from(this.set.values()))), (item: Info) => {
        Text(`${item.id}`)
          .margin(5)
          .onClick(() => {
            item.id++;
          })
      }, (item: Info, index) => item.id + index.toString())

      Button('add')
        .margin(5)
        .width('50%')
        .onClick(() => {
          this.set.add(new Info(30));
          hilog.info(DOMAIN, TAG, ('size:' + this.set.size));
        })
      Button('delete')
        .margin(5)
        .width('50%')
        .onClick(() => {
          let iterator = this.set.keys();
          this.set.delete(iterator.next().value);
        })
      Button('clear')
        .margin(5)
        .width('50%')
        .onClick(() => {
          this.set.clear();
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End Array_rom_shallow_copy]
