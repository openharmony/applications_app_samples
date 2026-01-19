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

// [Start test_componentV2]
@Entry
@ComponentV2
struct Index {
  @Local p: number[] = [0, 1];
  @Local q: number[] = [2, 3];
  c: number[][] = [this.p, this.q];
  d: number[] = [];

  aboutToAppear(): void {
    this.d = this.c.flatMap(it => it);
  }

  build() {
    Column() {
      Text(`${this.d[0]}`); // 预期显示：0; 实际显示：0,1。
    }
  }
}
// [End test_componentV2]