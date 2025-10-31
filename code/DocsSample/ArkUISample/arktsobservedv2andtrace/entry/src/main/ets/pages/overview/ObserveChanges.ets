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
// [Start Observe_Changes]
@ObservedV2
class SonChang {
  @Trace public age: number = 100;
}

class FatherChang {
  public son: SonChang = new SonChang();
}

@Entry
@ComponentV2
struct ObserveChanges {
  father: FatherChang = new FatherChang();

  build() {
    Column() {
      // 当点击改变age时，Text组件会刷新
      Text(`${this.father.son.age}`)
        .onClick(() => {
          this.father.son.age++;
        })
    }
  }
}

// [End Observe_Changes]