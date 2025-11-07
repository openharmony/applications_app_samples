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

@Component
export struct LocalObserveChangesDeepObject {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.local_observe_changes_deep_object'))
  }
}

// [Start Local_Observe_Changes_DeepObject]
@ObservedV2
class Region {
  @Trace public x: number;
  @Trace public y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}

@ObservedV2
class Info {
  @Trace public region: Region;
  @Trace public name: string;

  constructor(name: string, x: number, y: number) {
    this.name = name;
    this.region = new Region(x, y);
  }
}

@Entry
@ComponentV2
struct Index {
  @Local infoArr: Info[] = [new Info('Ocean', 28, 120), new Info('Mountain', 26, 20)];
  @Local originInfo: Info = new Info('Origin', 0, 0);

  build() {
    Column() {
      ForEach(this.infoArr, (info: Info) => {
        Row() {
          Text(`name: ${info.name}`)
          Text(`region: ${info.region.x}-${info.region.y}`)
        }
      })
      Row() {
        Text(`Origin name: ${this.originInfo.name}`)
        Text(`Origin region: ${this.originInfo.region.x}-${this.originInfo.region.y}`)
      }

      Button('change infoArr item')
        .onClick(() => {
          // 由于属性name被@Trace装饰，所以能够观察到
          this.infoArr[0].name = 'Win';
        })
      Button('change originInfo')
        .onClick(() => {
          // 由于变量originInfo被@Local装饰，所以能够观察到
          this.originInfo = new Info('Origin', 100, 100);
        })
      Button('change originInfo region')
        .onClick(() => {
          // 由于属性x、y被@Trace装饰，所以能够观察到
          this.originInfo.region.x = 25;
          this.originInfo.region.y = 25;
        })
    }
  }
}
// [End Local_Observe_Changes_DeepObject]