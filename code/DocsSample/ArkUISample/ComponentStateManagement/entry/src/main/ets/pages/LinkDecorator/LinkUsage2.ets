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

// [Start link_usage_two]
class LinkInfo2 {
  public info: string = 'Hello';
}

@Component
struct LinkChild2 {
  @Link msg: string;
  @Link info: LinkInfo2;

  build() {
    Text(this.msg + this.info.info)
  }
}

@Entry
@Component
struct LinkExample2 {
  @State message: string = 'Hello';
  @State info: LinkInfo2 = new LinkInfo2();

  build() {
    Column() {
      // 正确写法
      LinkChild2({msg: this.message, info: this.info})
    }
  }
}
// [End link_usage_two]