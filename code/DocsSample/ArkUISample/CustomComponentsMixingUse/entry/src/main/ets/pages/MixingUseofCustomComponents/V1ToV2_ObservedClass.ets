/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start v1_to_v2_observed_class]
@Observed
class ViewModelV1 {
  @Track public fontSize: number;

  constructor(fontSize: number) {
    this.fontSize = fontSize;
  }

  updateFontSize(fontSize: number) {
    this.fontSize = fontSize;
  }
}

// 存量的V1组件
@Entry
@Component
struct V1Comp {
  build() {
    Column() {
      // ------------ V1桥接组件 ------------
      V1BridgeComponent()

      // ....

    }
  }
}

// V1桥接组件
@Component
struct V1BridgeComponent {
  @State @Watch('onDirectionChange') viewModel: ViewModelV1 = new ViewModelV1(20);

  onDirectionChange() {
    // 将V1的数据转成V2的数据
    ViewModelV2.instance().fontSize = this.viewModel.fontSize;
  }

  build() {
    Column() {
      Text(`V1组件原始数据fontSize-${this.viewModel.fontSize}`)
        .fontSize(this.viewModel.fontSize)

      Button('V1组件修改字体大小').onClick(() => {
        this.viewModel.updateFontSize(10); // V1 V2组件刷新
      })

      // ------------ V2业务组件 ------------
      V2Comp()
    }
  }
}

@ObservedV2
class ViewModelV2 {
  // 单例实例
  private static singleton_: ViewModelV2;
  @Trace public fontSize: number = 40;

  // 私有构造函数（禁止外部new）
  private constructor() {
  }

  static instance(): ViewModelV2 {
    if (!ViewModelV2.singleton_) {
      ViewModelV2.singleton_ = new ViewModelV2();
    }
    return ViewModelV2.singleton_;
  }
}

// 新增V2业务组件
@ComponentV2
struct V2Comp {
  // 获取V2单例实例（组件内可直接访问）
  private v2Model = ViewModelV2.instance();

  build() {
    Column() {
      Text(`V2组件fontSize-${this.v2Model.fontSize}`)
        .fontSize(this.v2Model.fontSize)

      Button('V2组件修改字体大小')
        .onClick(() => {
          this.v2Model.fontSize = 60; // V2组件刷新
        })
    }
  }
}

// [End v1_to_v2_observed_class]