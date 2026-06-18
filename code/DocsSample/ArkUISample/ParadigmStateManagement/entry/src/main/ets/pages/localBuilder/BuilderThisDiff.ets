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

@Component
export struct LocalBuilderThisDiff {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Parent()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.builder_this_diff'))
  }
}

// [Start pass_by_reference_three]
class Data {
  public size: number = 0;
}

@Entry
@Component
struct Parent {
  label: string = 'parent';
  @State data: Data = new Data();

  @Builder
  componentBuilder($$: Data) {
    // 点击Button 触发UI刷新
    Text('builder + $$')
      .fontSize(20)
      .margin(10)
    Text(`${'this -> ' + this.label}`)
      .fontSize(20)
      .margin(10)
    Text(`${'size : ' + $$.size}`)
      .fontSize(20)
      .margin(10)
  }

  @LocalBuilder
  componentLocalBuilder($$: Data) {
    // 点击Button 不会触发UI刷新
    Text('LocalBuilder + $$ data')
      .fontSize(20)
      .margin(10)
    Text(`${'this -> ' + this.label}`)
      .fontSize(20)
      .margin(10)
    Text(`${'size : ' + $$.size}`)
      .fontSize(20)
      .margin(10)
  }

  @LocalBuilder
  contentLocalBuilderNoArgument() {
    // 点击Button 触发UI刷新
    Text('LocalBuilder + local data')
      .fontSize(20)
      .margin(10)
    Text(`${'this -> ' + this.label}`)
      .fontSize(20)
      .margin(10)
    Text(`${'size : ' + this.data.size}`)
      .fontSize(20)
      .margin(10)
  }

  build() {
    Column() {
      Child({
        contentBuilder: this.componentBuilder,
        contentLocalBuilder: this.componentLocalBuilder,
        contentLocalBuilderNoArgument: this.contentLocalBuilderNoArgument,
        data: this.data
      })
    }
    .width('100%')
  }
}

@Component
struct Child {
  label: string = 'child';

  @Builder
  customBuilder() {
  };

  @BuilderParam contentBuilder: ((data: Data) => void) = this.customBuilder;
  @BuilderParam contentLocalBuilder: ((data: Data) => void) = this.customBuilder;
  @BuilderParam contentLocalBuilderNoArgument: (() => void) = this.customBuilder;
  @Link data: Data;

  build() {
    Column() {
      this.contentBuilder({ size: this.data.size })
      this.contentLocalBuilder({ size: this.data.size })
      this.contentLocalBuilderNoArgument()
      Button('add child size')
        .width(300)
        .margin(10)
        .onClick(() => {
          this.data.size += 1;
        })
    }
    .width('100%')
  }
}
// [End pass_by_reference_three]