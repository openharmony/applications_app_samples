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

// [Start GlobalReusePoolGet]
import { UIUtils, IReusableInfo } from '@kit.ArkUI';

@ReusableV2
@ComponentV2
struct GlobalChild {
  @Consumer() provide: number = 10;

  aboutToAppear() {
    console.info('GlobalChild aboutToAppear');
  }
  aboutToReuse() {
    console.info('GlobalChild aboutToReuse');
  }
  aboutToRecycle() {
    console.info('GlobalChild aboutToRecycle');
  }
  aboutToDisappear() {
    console.info('GlobalChild aboutToDisappear');
  }

  build() {
    Column({ space: 20 }) {
      Text('全局子组件')
      SubChild()
    }
  }
}

@ReusableV2
@ComponentV2
struct LegacyComp {
  aboutToAppear() {
    console.info('LegacyComp aboutToAppear');
  }
  aboutToReuse() {
    console.info('LegacyComp aboutToReuse');
  }
  aboutToRecycle() {
    console.info('LegacyComp aboutToRecycle');
  }
  aboutToDisappear() {
    console.info('LegacyComp aboutToDisappear');
  }

  build() {
    Column() {
      Text('传统组件')
      ReusableChild()
    }
  }
}

@ReusableV2
@ComponentV2
struct ReusableChild {
  @Consumer() provide: number = 10;
  aboutToAppear() {
    console.info('ReusableChild aboutToAppear');
  }
  aboutToReuse() {
    console.info('ReusableChild aboutToReuse');
  }
  aboutToRecycle() {
    console.info('ReusableChild aboutToRecycle');
  }
  aboutToDisappear() {
    console.info('ReusableChild aboutToDisappear');
  }

  build() {
    Text(`ReusableChild @Consumer: ${this.provide}`)
  }
}

@ReusableV2
@ComponentV2
struct SubChild {
  @Consumer() provide: number = 10;
  aboutToAppear() {
    console.info('SubChild aboutToAppear');
  }
  aboutToReuse() {
    console.info('SubChild aboutToReuse');
  }
  aboutToRecycle() {
    console.info('SubChild aboutToRecycle');
  }
  aboutToDisappear() {
    console.info('SubChild aboutToDisappear');
  }

  build() {
    Text(`SubChild @Consumer: ${this.provide}`)
  }
}

@Entry
  // 配置全局复用池，使用perInstance所有权模式，全局复用池接纳4个复用组件
@ComponentV2({ reusePool: 'perInstance', poolAccepts: [LegacyComp, GlobalChild, ReusableChild, SubChild], freezeWhenInactive: false })
struct Index {
  @Provider() provide: number = 100;
  @Local boolVal: boolean = true;

  // 检查并打印复用池大小信息
  verifyPool(compName: string, comp: Function) {
    const pool = UIUtils.getCustomComponentContext(this).getReusePool();
    if (!pool) {
      console.info('Cannot find pool.');
      return;
    }
    const ret = pool.getReusableInfo(comp);
    // 基于复用数据类型打印复用池信息
    if (ret === undefined) {
      console.info(`getReusableInfo(${compName}): undefined`);
    } else if (Array.isArray(ret)) {
      console.info(`getReusableInfo(${compName}): Array[${ret.length}]`);
      ret.forEach((info: IReusableInfo, i: number) => {
        console.info(`  [${i}] count=${info.count}, maxCount=${info.maxCount}`);
      });
    } else {
      console.info(`getReusableInfo(${compName}): count=${ret.count}, maxCount=${ret.maxCount}`);
    }
  }

  // 设置复用池大小为0，清空复用池中指定组件的实例
  setPoolMaxCount(compName: string, comp: Function) {
    const pool = UIUtils.getCustomComponentContext(this).getReusePool();
    if (!pool) {
      console.info('Cannot find pool.');
      return;
    }
    const ret = pool.getReusableInfo(comp);
    if (ret && !Array.isArray(ret)) {
      // maxCount赋值为0时会释放复用池中的组件。
      ret.maxCount = 0;
    }
  }

  build() {
    Column({ space: 10 }) {
      Button('切换组件')
        .onClick(() => {
          this.boolVal = !this.boolVal;
        })
        .width(150)

      // 手动池检查按钮
      Button('检查GlobalChild')
        .onClick(() => this.verifyPool('GlobalChild', GlobalChild))
        .width(150)
      Button('检查LegacyComp')
        .onClick(() => this.verifyPool('LegacyComp', LegacyComp))
        .width(150)
      Button('设置复用池大小')
        .onClick(() => this.setPoolMaxCount('LegacyComp', LegacyComp))
        .width(150)

      if (this.boolVal) {
        GlobalChild()
      } else {
        LegacyComp()
      }
    }
    .width('100%')
  }
}

// [End GlobalReusePoolGet]

@Builder
export function globalReusePoolGet() {
  NavDestination() {
    Index()
  }
}