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

// [Start v2_built_in]
import { UIUtils } from '@kit.ArkUI';

const TAG = 'CanBeObserved';

// 提供判断对象是否为可被观察对象的方法
function test(obj: object): void {
  console.info(TAG, `res: ${JSON.stringify(UIUtils.canBeObserved(obj))}`);
}

@Entry
@ComponentV2
struct V2BuiltIn {
  @Local arr: string[] = [];
  @Local map: Map<string, string> = new Map<string, string>();
  @Local set: Set<string> = new Set<string>();
  @Local date: Date = new Date();

  aboutToAppear(): void {
    this.arr = ['1', '2', '3'];
    this.map.set('a', '11');
    this.map.set('b', '22');
    this.map.set('c', '33');
    this.set.add('111');
    this.set.add('222');
    this.set.add('333');
    this.date = new Date('2025-12-12');
  }

  build() {
    Column({ space: 20 }) {

      Child01({ arr: this.arr })

      Child02({ map: this.map })

      Child03({ set: this.set })

      Child04({ date: this.date })

      Button('test arr')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象
          test(this.arr);
        })

      Button('test map')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象
          test(this.map);
        })

      Button('test set')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象
          test(this.set);
        })

      Button('test date')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象
          test(this.date);
        })

    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

@ComponentV2
export struct Child01 {
  @Param arr: string[] = [];

  build() {
    Column() {
      ForEach(this.arr, (item: string) => {
        Text('Child01 ' + item)
      })
    }
  }
}

@ComponentV2
export struct Child02 {
  @Param map: Map<string, string> = new Map<string, string>();

  build() {
    Column() {
      ForEach(Array.from(this.map), (item: object) => {
        Text('Child02 ' + JSON.stringify(item))
      })
    }
  }
}

@ComponentV2
export struct Child03 {
  @Param set: Set<string> = new Set<string>();

  build() {
    Column() {
      ForEach(Array.from(this.set), (item: string) => {
        Text('Child03 ' + item)
      })
    }
  }
}

@ComponentV2
export struct Child04 {
  @Param date: Date = new Date();

  build() {
    Column() {
      Text('Child03 year: ' + this.date.getFullYear())
      Text('Child03 month: ' + this.date.getMonth())
      Text('Child03 day: ' + this.date.getDate())
    }
  }
}
// [End v2_built_in]