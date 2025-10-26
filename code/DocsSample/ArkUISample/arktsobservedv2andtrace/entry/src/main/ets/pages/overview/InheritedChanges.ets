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
// [Start Inherited_Changes]
@ObservedV2
class FatherInheritance {
  @Trace public name: string = 'Tom';
}
class ChangesSon extends FatherInheritance {
}
@Entry
@ComponentV2
struct InheritedChanges {
  son: ChangesSon = new ChangesSon();

  build() {
    Column() {
      // 当点击改变name时，Text组件会刷新
      Text(`${this.son.name}`)
        .onClick(() => {
          this.son.name = 'Jack';
        });
    }
  }
}
// [End Inherited_Changes]