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

// [Start GlobalReusePoolShared]
@Entry
@ComponentV2
struct Parent {
  @Local show: boolean[] = [true, true, true];

  build() {
    Column({ space: 20 }) {
      Row({ space: 10 }) {
        Button('删除Comp1')
          .onClick(() => this.show[0] = false)
        Button('添加Comp1')
          .onClick(() => this.show[0] = true)
      }
      Row({ space: 10 }) {
        Button('删除Comp2')
          .onClick(() => this.show[1] = false)
        Button('添加Comp2')
          .onClick(() => this.show[1] = true)
      }
      Row({ space: 10 }) {
        Button('删除Comp3')
          .onClick(() => this.show[2] = false)
        Button('添加Comp3')
          .onClick(() => this.show[2] = true)
      }

      Column({ space: 10 }) {
        // 使用if切换触发复用。
        if (this.show[0]) {
          CompA({ label: 'A1' })
        }
        if (this.show[1]) {
          CompA({ label: 'A2' })
        }
        if (this.show[2]) {
          CompA({ label: 'A3' })
        }
      }
    }
    .width('100%')
  }
}

@ReusableV2
@ComponentV2
struct ReusableCompA {
  @Require @Param value: number;

  aboutToAppear() {
    console.info('ReusableCompA aboutToAppear');
  }
  aboutToReuse() {
    console.info('ReusableCompA aboutToReuse');
  }
  aboutToRecycle() {
    console.info('ReusableCompA aboutToRecycle');
  }
  aboutToDisappear() {
    console.info('ReusableCompA aboutToDisappear');
  }

  build() {
    Text(`ReusableCompA Item ${this.value}`)
      .fontSize(16)
      .fontColor(Color.Green)
  }
}

// 多个CompA组件实例共用一个ReusableCompA的全局复用池。
@ComponentV2({ reusePool: 'shared', poolAccepts: [ReusableCompA], freezeWhenInactive: false})
struct CompA {
  @Require @Param label: string;

  build() {
    Column({ space: 5 }) {
      Text(`CompA ${this.label}`)
        .fontSize(18)
        .fontColor(Color.Blue)
      ReusableCompA({ value: 1 })
      ReusableCompA({ value: 2 })
    }
    .border({ width: 1, color: Color.Gray })
    .padding(5)
  }
}

// [End GlobalReusePoolShared]

@Builder
export function globalReusePoolShared() {
  NavDestination() {
    Parent()
  }
}