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

// [Start link_usage]
class LinkInfo {
  public value: string = 'Hello';
}

@Component
struct LinkChild {
  // 在子组件中，使用@Link装饰LinkInfo类型的test变量
  @Link test: LinkInfo;

  build() {
    Text(this.test.value)
  }
}

@Entry
@Component
struct LinkExample {
  @State info: LinkInfo = new LinkInfo();

  build() {
    Column() {
      // 在父组件中，使用@State装饰的info变量初始化LinkChild组件的test变量
      LinkChild({test: this.info})
    }
  }
}
// [End link_usage]