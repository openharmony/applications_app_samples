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
export struct ParamDecoratorLimitations {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.param_decorator_limitations'))
  }
}

// [Start Param_Decorator_Limitations]
@Observed
class Region {
  public x: number;
  public y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}

@Observed
class Info {
  public region: Region;

  constructor(x: number, y: number) {
    this.region = new Region(x, y);
  }
}

@Entry
@Component
struct Index {
  @State info: Info = new Info(0, 0);

  build() {
    Column() {
      Button('change Info')
        .onClick(() => {
          this.info = new Info(100, 100);
        })
      Child({
        region: this.info.region,
        regionProp: this.info.region,
        infoProp: this.info,
        infoLink: this.info,
        infoState: this.info
      })
    }
  }
}

@Component
struct Child {
  @ObjectLink region: Region;
  @Prop regionProp: Region;
  @Prop infoProp: Info;
  @Link infoLink: Info;
  @State infoState: Info = new Info(1, 1);

  build() {
    Column() {
      Text(`ObjectLink region: ${this.region.x}-${this.region.y}`)
      Text(`Prop regionProp: ${this.regionProp.x}-${this.regionProp.y}`)
    }
  }
}
// [End Param_Decorator_Limitations]