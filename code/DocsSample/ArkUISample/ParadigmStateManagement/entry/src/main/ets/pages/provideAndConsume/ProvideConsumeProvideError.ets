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
// [Start provide_consume_Two_Way]
class Tmp {
  public name: string = '';
}

@Entry
@Component
struct HomePage {
  // 修正点1：将@Provide声明在Entry组件（根作用域），确保子组件能正确消费
  @Provide('name') name: string = 'abc';

  @Builder
  builder2($$: Tmp) {
    // $r('app.string.provide_consume_provide_error_text') 需要更换为开发者所需的字符串资源文件
    Text($r('app.string.provide_consume_provide_error_text', $$.name))
  }

  build() {
    Column() {
      Button($r('app.string.provide_and_consume_text_1')).onClick(() => {
        if (this.name == 'ddd') {
          this.name = 'abc';
        } else {
          this.name = 'ddd';
        }
      })
      // 修正点2：CustomWidget不再声明@Provide，仅作为容器传递builder
      CustomWidget() {
        CustomWidgetChild({ builder: this.builder2 })
      }
    }
  }
}

@Component
struct CustomWidget {
  @BuilderParam
  builder: () => void;

  build() {
    this.builder()
  }
}

@Component
struct CustomWidgetChild {
  // 修正点3：@Consume从根作用域（HomePage）获取@Provide('name')，作用域正确
  @Consume('name') name: string;
  @BuilderParam
  builder: ($$: Tmp) => void;

  build() {
    Column() {
      this.builder({ name: this.name })
    }
  }
}
// [End provide_consume_Two_Way]

@Component
export struct ProvideConsumeProvideError {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      HomePage()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.provide_consume_provide_error'))
  }
}