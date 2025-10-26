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
const DOMAIN = 0x0001;
const TAG = 'arktsobservedandobjectlink';
// [Start Object_Array]
// Used to generate unique IDs for ObjectArrayInfo instances
let arrayInfoNextID: number = 1;

@Observed
class ObjectArrayInfo {
  public id: number;
  public info: number;

  constructor(info: number) {
    this.id = arrayInfoNextID++;
    this.info = info;
  };
};

@Component
struct ObjectArrayChild {
  // 子组件Child的@ObjectLink的类型是Info
  @ObjectLink info: ObjectArrayInfo;
  label: string = 'ViewChild';

  build() {
    Row() {
      Button(`ViewChild [${this.label}] this.info.info = ${this.info ? this.info.info : 'undefined'}`)
        .width(320)
        .margin(10)
        .onClick(() => {
          this.info.info += 1;
        });
    }
  }
}

@Entry
@Component
struct ObjectArrayChildParent {
  // Parent中有@State装饰的Info[]
  @State arrA: ObjectArrayInfo[] = [new ObjectArrayInfo(0), new ObjectArrayInfo(0)];

  build() {
    Column() {
      ForEach(this.arrA,
        (item: ObjectArrayInfo) => {
          ObjectArrayChild({ label: `#${item.id}`, info: item })
        },
        (item: ObjectArrayInfo): string => item.id.toString()
      );
      // 使用@State装饰的数组的数组项初始化@ObjectLink，其中数组项是被@Observed装饰的Info的实例
      ObjectArrayChild({ label: 'ViewChild this.arrA[first]', info: this.arrA[0] });
      ObjectArrayChild({ label: 'ViewChild this.arrA[last]', info: this.arrA[this.arrA.length-1] });

      Button('ViewParent: reset array')
        .width(320)
        .margin(10)
        .onClick(() => {
          this.arrA = [new ObjectArrayInfo(0), new ObjectArrayInfo(0)];
        });
      Button('ViewParent: push')
        .width(320)
        .margin(10)
        .onClick(() => {
          this.arrA.push(new ObjectArrayInfo(0));
        });
      Button('ViewParent: shift')
        .width(320)
        .margin(10)
        .onClick(() => {
          if (this.arrA.length > 0) {
            this.arrA.shift();
          } else {
            hilog.info(DOMAIN,TAG,'length <= 0');
          };
        });
      Button('ViewParent: item property in middle')
        .width(320)
        .margin(10)
        .onClick(() => {
          this.arrA[Math.floor(this.arrA.length / 2)].info = 10;
        });
      Button('ViewParent: item property in middle')
        .width(320)
        .margin(10)
        .onClick(() => {
          this.arrA[Math.floor(this.arrA.length / 2)] = new ObjectArrayInfo(11);
        });
    }
  }
}
// [End Object_Array]