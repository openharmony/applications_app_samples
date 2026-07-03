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

// [Start GlobalReuseDefault]
@Entry
@ComponentV2
struct Index {
  @Local componentSwitch: boolean = false;
  build() {
    Column() {
      Button('Switch components')
        .onClick(() => {
          this.componentSwitch = !this.componentSwitch;
        })
      if (this.componentSwitch) { // 切换不同子组件
        ChildComponentA()
      } else {
        ChildComponentB()
      }
    }
  }
}
@ComponentV2
struct ChildComponentA { // ReusableComponent复用组件的复用池默认在组件ChildComponentA上，在Index组件中if分支切换时销毁
  build() {
    Column() {
      Text('Component A')
      ReusableComponent() // 子组件ComponentA和ComponentB共用复用组件ReusableComponent
    }
  }
}
@ComponentV2
struct ChildComponentB {
  build() {
    Column() {
      Text('Component B')
      ReusableComponent() // 子组件ComponentA和ComponentB共用复用组件ReusableComponent
    }
  }
}
@ReusableV2
@ComponentV2
struct ReusableComponent { // 复用组件
  aboutToRecycle() {
    console.info('Reusable component is being recycled');
  }
  aboutToDisappear() {
    console.info('Reusable component is being destroyed'); // 在Index组件中if分支切换时，由于位于父组件ChildComponentA的默认复用池被销毁，该复用组件也会被销毁，无法被ChildComponentB复用。
  }
  build() {
    Text('ReusableComponent')
  }
}
// [End GlobalReuseDefault]

@Builder
export function globalReuseDefault() {
  NavDestination() {
    Index()
  }
}