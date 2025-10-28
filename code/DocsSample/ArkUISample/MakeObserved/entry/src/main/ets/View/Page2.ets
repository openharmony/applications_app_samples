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
// [Start MakeObserved_only_applies_to_input_parameters]
import { UIUtils } from '@kit.ArkUI';
class Info {
  public id: number = 0;
  constructor(id: number) {
    this.id = id;
  }
}
@Entry
@ComponentV2
struct Page2 {
  @Local message: Info = UIUtils.makeObserved(new Info(20));
  build() {
    Column() {
      Button(`change id`).onClick(() => {
        this.message.id++;
      })
      Button(`change Info ${this.message.id}`).onClick(() => {
        this.message = new Info(30);
      })
      Button(`change Info1 ${this.message.id}`).onClick(() => {
        this.message = UIUtils.makeObserved(new Info(30));
      })
    }
  }
}
// [End MakeObserved_only_applies_to_input_parameters]