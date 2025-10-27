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
// [Start example2_start]
@ObservedV2
class Child4 {
  @Trace public value: number = 10;
}

@ComponentV2
@Entry
struct example2 {
  @Local child: Child4 = new Child4();

  build() {
    Column() {
      Text(this.child.value.toString());
      // @Local只能观察自身，需要给Child加上@ObservedV2和@Trace
      Button('value+1')
        .onClick(() => {
          this.child.value++;
        });
    }
  }
}
// [End example2_start]