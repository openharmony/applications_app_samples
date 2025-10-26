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
// [Start foreach_mapCollect_keys]
import { collections } from '@kit.ArkTS';
import { UIUtils } from '@kit.ArkUI';

@Sendable
class Info {
 public id: number = 0;

  constructor(id: number) {
    this.id = id;
  }
}


@Entry
@ComponentV2
struct Page5 {
  mapCollect: collections.Map<string, Info> = UIUtils.makeObserved(new collections.Map<string, Info>([['a', new Info(10)], ['b', new Info(20)]]));

  build() {
    Column() {
      // this.mapCollect.keys()返回迭代器。Foreach不支持迭代器，所以要Array.from浅拷贝生成数据。
      ForEach(Array.from(this.mapCollect.keys()), (item: string) => {
        Text(`${this.mapCollect.get(item)?.id}`).onClick(() => {
          let value: Info|undefined = this.mapCollect.get(item);
          if (value) {
            value.id++;
          }
        })
      }, (item: string, index) => item + index.toString())

      // set c
      Button('set c').onClick(() => {
        this.mapCollect.set('c', new Info(30));
      })
      // delete c
      Button('delete c').onClick(() => {
        if (this.mapCollect.has('c')) {
          this.mapCollect.delete('c');
        }
      })
      // clear
      Button('clear').onClick(() => {
        this.mapCollect.clear();
      })
    }
    .height('100%')
    .width('100%')
  }
}
// [End foreach_mapCollect_keys]