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
// [Start problem_ui_not_refresh_positive]
class LayoutSize {
  size: number = 0;
}

@Entry
@Component
struct Parent {
  label: string = 'parent';
  @State layoutSize: LayoutSize = { size: 0 };

  @LocalBuilder
  componentBuilder() {
    Text(`this: ${this.label}`)
    Text(`size: ${this.layoutSize.size}`)
  }

  build() {
    Column() {
      Child({
        customBuilder: this.componentBuilder,
        layoutSize: this.layoutSize
      })
    }
  }
}

@Component
struct Child {
  label: string = 'child';
  @BuilderParam customBuilder: () => void;
  @Link layoutSize: LayoutSize;

  build() {
    Column() {
      this.customBuilder()
      Button("add child size")
        .onClick(() => {
          this.layoutSize.size += 1; //子组件传入的参数发生变化，由@Link传入父组件@State，刷新父组件声明的@LocalBuilder函数的UI。
        })
    }
  }
}
// [End problem_ui_not_refresh_positive]
@Component
export struct ProblemUINotRefreshPositive {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Parent()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.problem_ui_not_refresh_positive'))
  }
}