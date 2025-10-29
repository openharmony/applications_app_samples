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
// [Start UiRefresh_CannotTriggered]
@ObservedV2
class TriggeredPerson {
  // Public property to store the unique identifier
  public id: number = 0;
  // Property 'age' decorated with @Trace to trigger UI updates when its value changes
  @Trace public age: number = 8;
};
@Entry
@ComponentV2
struct UiRefreshCannotTriggered {
  person: TriggeredPerson = new TriggeredPerson();

  build() {
    Column() {
      // age被@Trace装饰，用在UI中可以触发UI刷新
      Text(`${this.person.age}`)
        .onClick(() => {
          this.person.age++; // 点击会触发UI刷新
        });
      // id未被@Trace装饰，用在UI中不会触发UI刷新
      Text(`${this.person.id}`) // 当id变化时不会刷新
        .onClick(() => {
          this.person.id++; // 点击不会触发UI刷新
        });
    }
  }
}
// [End UiRefresh_CannotTriggered]