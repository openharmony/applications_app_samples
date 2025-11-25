/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

// [Start prop_fourteen_start]
@Observed
class Commodity {
  public price: number = 0;

  constructor(price: number) {
    this.price = price;
  }
}

@Component
struct PropChild1 {
  @Prop fruit: Commodity; // 未进行本地初始化

  build() {
    Text(`PropChild1 fruit ${this.fruit.price}`)
      .onClick(() => {
        this.fruit.price += 1;
      })
  }
}

@Component
struct PropChild2 {
  @Prop fruit: Commodity = new Commodity(1); // 进行本地初始化

  build() {
    Text(`PropChild2 fruit ${this.fruit.price}`)
      .onClick(() => {
        this.fruit.price += 1;
      })
  }
}

@Entry
@Component
struct Parent {
  @State fruit: Commodity[] = [new Commodity(1)];

  build() {
    Column() {
      Text(`Parent fruit ${this.fruit[0].price}`)
        .onClick(() => {
          this.fruit[0].price += 1;
        })

      // @PropChild1本地没有初始化，必须从父组件初始化
      PropChild1({ fruit: this.fruit[0] })
      // @PropChild2本地进行了初始化，可以不从父组件初始化，也可以从父组件初始化
      PropChild2()
      PropChild2({ fruit: this.fruit[0] })
    }
  }
}

// [End prop_fourteen_start]
@Builder
export function MyParentBuilder() {
  Parent()
}