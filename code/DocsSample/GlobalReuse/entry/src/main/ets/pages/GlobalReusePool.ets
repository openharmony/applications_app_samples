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

// [Start GlobalReusePool]
@ReusableV2
@ComponentV2
struct ReusableComponent { // 复用组件
  aboutToRecycle() {
    // 在Index组件中if分支切换时，该组件由上层组件Index声明的全局复用池接纳，并复用到ChildComponentB中的ReusableComponent创建过程中
    console.info('Reusable component is being recycled');
  }
  aboutToDisappear() {
    console.info('Reusable component is being destroyed');
  }
  build() {
    Text('ReusableComponent')
  }
}
@Entry
@ComponentV2({
  reusePool: 'shared', // 配置全局复用池模式，使能全局复用能力
  poolAccepts: [ReusableComponent], // 配置全局复用池接纳名称为ReusableComponent的自定义组件
  freezeWhenInactive: false // 组件冻结默认配置
})
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
struct ChildComponentA { // ReusableComponent复用组件的复用池使用上层组件Index的全局复用池，在ComponentA上的默认复用池会被跳过
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
// [End GlobalReusePool]

@Builder
export function globalReusePool() {
  NavDestination() {
    Index()
  }
}