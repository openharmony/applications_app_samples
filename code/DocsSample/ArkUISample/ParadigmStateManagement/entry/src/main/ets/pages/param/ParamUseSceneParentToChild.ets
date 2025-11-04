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
export struct ParamUseSceneParentToChild {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.param_use_scene_parent_to_child'))
  }
}

// [Start Param_Use_Scene_Parent_To_Child]
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
  @Trace public name: string;
  @Trace public age: number;
  @Trace public region: Region;

  constructor(name: string, age: number, x: number, y: number) {
    this.name = name;
    this.age = age;
    this.region = new Region(x, y);
  }
}

@Entry
@ComponentV2
struct Index {
  @Local infoList: Info[] = [new Info('Alice', 8, 0, 0), new Info('Barry', 10, 1, 20), new Info('Cindy', 18, 24, 40)];

  build() {
    Column() {
      ForEach(this.infoList, (info: Info) => {
        MiddleComponent({ info: info })
      })
      Button('change')
        .onClick(() => {
          this.infoList[0] = new Info('Atom', 40, 27, 90);
          this.infoList[1].name = 'Bob';
          this.infoList[2].region = new Region(7, 9);
        })
    }
  }
}

@ComponentV2
struct MiddleComponent {
  @Require @Param info: Info;

  build() {
    Column() {
      Text(`name: ${this.info.name}`)
      Text(`age: ${this.info.age}`)
      SubComponent({ region: this.info.region })
    }
  }
}

@ComponentV2
struct SubComponent {
  @Require @Param region: Region;

  build() {
    Column() {
      Text(`region: ${this.region.x}-${this.region.y}`)
    }
  }
}
// [End Param_Use_Scene_Parent_To_Child]