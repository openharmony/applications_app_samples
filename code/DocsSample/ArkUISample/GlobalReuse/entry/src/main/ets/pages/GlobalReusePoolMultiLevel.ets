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

// [Start GlobalReusePoolMultiLevel]
@ReusableV2
@ComponentV2
struct ChildA {
  aboutToAppear() {
    console.info('ChildA aboutToAppear');
  }
  aboutToReuse() {
    console.info('ChildA aboutToReuse');
  }
  aboutToRecycle() {
    console.info('ChildA aboutToRecycle');
  }
  aboutToDisappear() {
    console.info('ChildA aboutToDisappear');
  }

  build() {
    Column({ space: 8 }) {
      Text('子组件 A')
        .fontColor(Color.Blue)
      // 复用组件ChildA中包含复用组件ReusableLeaf
      ReusableLeaf()
    }
  }
}

@ReusableV2
@ComponentV2
struct ReusableLeaf {
  aboutToAppear() {
    console.info('ReusableLeaf aboutToAppear');
  }
  aboutToReuse() {
    console.info('ReusableLeaf aboutToReuse');
  }
  aboutToRecycle() {
    console.info('ReusableLeaf aboutToRecycle');
  }
  aboutToDisappear() {
    console.info('ReusableLeaf aboutToDisappear');
  }

  build() {
    Text('可复用叶子节点')
      .fontColor(Color.Green)
  }
}

@Entry
  // 配置全局复用池，接纳ChildA复用组件
@ComponentV2({ reusePool: 'shared', poolAccepts: [ChildA], freezeWhenInactive: false })
struct EntryComp {
  @Local showParent: boolean = true;

  build() {
    Column({ space: 15 }) {
      Text('入口组件')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
      Button('切换 ParentA')
        .onClick(() => {
          // 修改if条件触发组件复用
          this.showParent = !this.showParent;
        })
      // 切换if分支后，ParentA中的ChildA进入EntryComp的全局复用池
      if (this.showParent) {
        ParentA()
      }
    }
    .width('100%')
  }
}

// 配置全局复用池，接纳ReusableLeaf复用组件
@ComponentV2({ reusePool: 'perInstance', poolAccepts: [ReusableLeaf], freezeWhenInactive: false })
struct ParentA {
  @Local showChild: boolean = true;

  aboutToAppear() {
    console.info('ParentA aboutToAppear');
  }

  build() {
    Column({ space: 8 }) {
      Text('父组件 A')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
      Button('切换 ChildA')
        .onClick(() => {
          // 修改if条件触发子组件ChildA复用
          this.showChild = !this.showChild;
        })
      // 切换if分支后，ChildA进入EntryComp的全局复用池，ReusableLeaf节点跟随ChildA存入EntryComp复用池中。
      if (this.showChild) {
        ChildA()
      }
    }
  }
}

// [End GlobalReusePoolMultiLevel]

@Builder
export function globalReusePoolMultiLevel() {
  NavDestination() {
    EntryComp()
  }
}