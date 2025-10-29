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

// [Start LlinkWithPrivate_ErrorCase]
@Entry
@Component
struct LinkErrorAccessRestrictions {
  @Builder
  buildTest() {
    Text('Parent builder');
  }

  build() {
    Column() {
      LinkErrorComponentChild({
        stateValue: 'Hello',
        propValue: 'Hello',
        provideValue: 'Hello',
        builderValue: this.buildTest,
        regularValue: 'Hello'
      })
    }
    .width('100%');
  }
}

@Component
struct LinkErrorComponentChild {
  // 此处使用private修饰符时会出现告警日志
  @State private stateValue: string = 'Hello';
  // 此处使用private修饰符时会出现告警日志
  @Prop private propValue: string = 'Hello';
  // 此处使用private修饰符时会出现告警日志
  @Provide private provideValue: string = 'Hello';
  // 此处使用private修饰符时会出现告警日志
  @BuilderParam private builderValue: () => void = this.buildTest;
  // 此处使用private修饰符时会出现告警日志
  private regularValue: string = 'Hello';

  @Builder
  buildTest() {
    Text('Child builder');
  }

  build() {
    Column() {
      Text('Hello')
        .fontSize(50)
        .fontWeight(FontWeight.Bold);
    }
  }
}

// [End LlinkWithPrivate_ErrorCase]
