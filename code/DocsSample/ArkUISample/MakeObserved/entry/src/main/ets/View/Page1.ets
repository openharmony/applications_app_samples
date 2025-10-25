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
//[Start UI_will_not_refresh]
import { UIUtils } from '@kit.ArkUI';
class Person {
  public age: number = 10;
}
class Info {
  public id: number = 0;
  public person: Person = new Person();
}
@Entry
@Component
struct Page1 {
  @State message: Info = new Info();
  @State message2: Info = UIUtils.makeObserved(this.message); // 不会抛异常
  build() {
    Column() {
      Text(`${this.message2.person.age}`)
        .onClick(() => {
          // UI不会刷新，因为State只能观察到第一层的变化
          this.message2.person.age++;
        })
    }
  }
}
//[End UI_will_not_refresh]