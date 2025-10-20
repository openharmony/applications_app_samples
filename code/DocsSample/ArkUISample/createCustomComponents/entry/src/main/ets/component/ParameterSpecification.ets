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
// [ Start Parameter specification ]
@Component
struct MyComponentSpecification {
  private countDownFrom: number = 0;
  private color: Color = Color.Blue;

  build() {
    // [StartExclude test]
    Text('test')
      .backgroundColor(this.color)
    // [EndExclude test]
  }
}

@Entry
@Component
struct ParentComponentParameter {
  private someColor: Color = Color.Pink;

  build() {
    Column() {
        // 创建MyComponent实例，并将创建MyComponent成员变量countDownFrom初始化为10，将成员变量color初始化为this.someColor
      MyComponentSpecification({ countDownFrom: 10, color: this.someColor })
    }
  }
}
// [ End Parameter specification ]
