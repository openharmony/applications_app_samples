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
// [ Start HelloComponent Hello ]
@Component
struct HelloComponent {
  @State message: string | Resource = 'Hello, World!';
  build() {
    // HelloComponent自定义组件组合系统组件Row和Text
    Row() {
      Text(this.message)
        .onClick(() => {
          // 状态变量message的改变驱动UI刷新，UI从'Hello, World!'刷新为'Hello, ArkUI!'
          this.message = 'Hello, ArkUI!';
        })
    }
  }
}
// [ End HelloComponent Hello ]
// [ Start ArkUI message ]
@Entry
@Component
struct ParentComponentUI {
  build() {
      Column() {
        Text('ArkUI message')
        HelloComponent({ message: 'Hello World!' });
        Divider()
        HelloComponent({ message: $r('app.string.Hello_The_world') });
      }
  }
}
// [ End ArkUI message ]

