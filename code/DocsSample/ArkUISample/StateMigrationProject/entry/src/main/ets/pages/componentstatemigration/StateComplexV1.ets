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
// [Start example1_start]
class Child3 {
  public value: number = 10;
}

@Component
@Entry
struct example1 {
  @State child: Child3 = new Child3();

  build() {
    Column() {
      Text(this.child.value.toString())
      // @State可以观察第一层变化
      Button('value+1')
        .onClick(() => {
          this.child.value++;
        })
    }
  }
}
// [End example1_start]