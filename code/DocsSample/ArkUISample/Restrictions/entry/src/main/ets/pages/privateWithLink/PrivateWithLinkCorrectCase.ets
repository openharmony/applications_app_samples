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

// [Start PrivateWithLink_CorrectCase]
@Entry
@Component
struct PWLCAccessRestrictions  {
  @State linkValue: string = 'Hello';
  @State objectLinkValue: PWLComponentObj  = new PWLComponentObj();
  build() {
    Column() {
      PWLComponentChild({linkValue: this.linkValue, objectLinkValue: this.objectLinkValue});
    }
    .width('100%');
  }
}

@Observed
class PWLComponentObj  {
  public count: number = 0;
}
@Component
struct PWLComponentChild  {
  @Link linkValue: string;
  @ObjectLink objectLinkValue: PWLComponentObj;
  build() {
    Column() {
      Text('Hello')
        .fontSize(50)
        .fontWeight(FontWeight.Bold);
    };
  }
}
// [End PrivateWithLink_CorrectCase]