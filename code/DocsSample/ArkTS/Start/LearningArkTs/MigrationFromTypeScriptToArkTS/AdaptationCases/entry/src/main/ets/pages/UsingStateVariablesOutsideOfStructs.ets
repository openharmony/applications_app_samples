/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start using_state_variables_outside_of_structs]
class CC {
  public value: string = '1';

  constructor(value: string) {
    this.value = value;
  }
}

export class MyComponentController {
  public item: CC = new CC('1');

  setItem(item: CC) {
    this.item = item;
  }

  changeText(value: string) {
    this.item.value = value;
  }
}

@Component
export default struct MyComponent {
  public controller: MyComponentController | null = null;
  @State value: CC = new CC('Hello World');

  build() {
    Column() {
      Text(`${this.value.value}`)
        .fontSize(50)
    }
  }

  aboutToAppear() {
    if (this.controller) {
      this.controller.setItem(this.value);
    }
  }
}

@Entry
@Component
struct StyleExample {
  controller: MyComponentController = new MyComponentController();

  build() {
    Column() {
      MyComponent({ controller: this.controller })
      Button('change value').onClick(() => {
        this.controller.changeText('Text');
      })
    }
  }
}
// [End using_state_variables_outside_of_structs]