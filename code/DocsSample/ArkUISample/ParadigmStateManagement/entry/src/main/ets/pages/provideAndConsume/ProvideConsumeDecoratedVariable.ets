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
// [Start Provide_Consume_Decorated_Variable1]
@Component
struct MyComponent {
  // @Consume装饰的变量设置默认值
  @Consume('withDefault') defaultValue: number = 10;

  // [StartExclude Provide_Consume_Decorated_Variable]
  build() {
  }

  // [EndExclude Provide_Consume_Decorated_Variable]
}
// [End Provide_Consume_Decorated_Variable1]

// [Start Provide_Consume_Decorated_Variable2]
@Entry
@Component
struct Parent {
  @Provide('firstKey') provideOne: string | undefined = undefined;
  @Provide('secondKey') provideTwo: string = 'the second provider';

  build() {
    Column() {
      Row() {
        Column() {
          Text(`${this.provideOne}`)
            .fontSize(20)
            .margin(10)
          Text(`${this.provideTwo}`)
            .fontSize(20)
            .margin(10)
        }
        .width('100%')

        Column() {
          // 点击change provideOne按钮，provideOne和子组件中的textOne属性会同时变化
          Button('change provideOne')
            .onClick(() => {
              this.provideOne = undefined;
            })
            .width(300)
            .margin(10)
          // 点击change provideTwo按钮，provideTwo和子组件中的textTwo属性会同时变化
          Button('change provideTwo')
            .onClick(() => {
              this.provideTwo = 'the next provider';
            })
            .width(300)
            .margin(10)
        }
        .width('100%')
      }

      Row() {
        Column() {
          Child()
        }
        .width('100%')
      }
    }
    .width('100%')
  }
}

@Component
struct Child {
  // @Consume装饰的变量通过相同的别名绑定其祖先内的@Provide装饰的变量，同时设置默认值
  @Consume('firstKey') textOne: string | undefined = 'child';
  // @Consume装饰的变量通过相同的别名绑定其祖先内的@Provide装饰的变量，没有设置默认值
  @Consume('secondKey') textTwo: string;
  // @Consume装饰的变量在祖先内没有匹配成功的@Provide装饰的变量，但设置了默认值
  @Consume('thirdKey') textThree: string = 'defaultValue';

  build() {
    Column() {
      Text(`${this.textOne}`)
        .fontSize(20)
        .margin(10)
      Text(`${this.textTwo}`)
        .fontSize(20)
        .margin(10)
      Text(`${this.textThree}`)
        .fontSize(20)
        .margin(10)
      // 点击change textOne按钮，textOne和父组件的provideOne会同时变化
      Button('change textOne')
        .onClick(() => {
          this.textOne = 'not undefined';
        })
        .width(300)
        .margin(10)
      // 点击change textTwo按钮，textTwo和父组件的provideTwo会同时变化
      Button('change textTwo')
        .onClick(() => {
          this.textTwo = 'change textTwo';
        })
        .width(300)
        .margin(10)
    }
    .width('100%')
  }
}
// [End Provide_Consume_Decorated_Variable2]

@Component
export struct ProvideConsumeDecoratedVariable {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Parent()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.provide_consume_decorated_variable'))
  }
}