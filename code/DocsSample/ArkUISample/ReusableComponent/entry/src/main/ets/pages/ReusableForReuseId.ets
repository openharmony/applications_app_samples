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

// [Start reusable_for_reuseid]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_ReusableComponent]';
const DOMAIN = 0xF811;
const BUNDLE = 'ReusableComponent_';

@Entry
@Component
struct Index {
  @State showBranchA: boolean = true;
  @State showBranchB: boolean = false;

  build() {
    Column({ space: 5 }) {
      Button('show/hide branch A')
        .onClick(() => {
          this.showBranchA = !this.showBranchA;
        })
      if (this.showBranchA) {
        ReusableComponent({ flag: true })
          .reuseId('ReuseA') // 通过reuseId区分不同结构的复用组件
      }
      Button('show/hide branch B')
        .onClick(() => {
          this.showBranchB = !this.showBranchB;
        })
      if (this.showBranchB) {
        ReusableComponent({ flag: false })
          .reuseId('ReuseB') // 通过reuseId区分不同结构的复用组件
      }
    }
  }
}

@Reusable
@Component
struct ReusableComponent {
  @Require @Prop flag: boolean = true;

  aboutToAppear() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableComponent aboutToAppear');
  }

  aboutToReuse(params: ESObject) {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableComponent aboutToReuse');
    this.flag = params.flag;
  }

  build() {
    Column({ space: 5 }) {
      Text('ReusableComponent')
      if (this.flag) {
        ReusableChildA()
      } else {
        ReusableChildB()
      }
    }.border({ width: 1 })
  }
}

@Component
struct ReusableChildA {
  aboutToAppear() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableChildA aboutToAppear');
  }

  aboutToReuse() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableChildA aboutToReuse');
  }

  build() {
    Text('ReusableChildA')
      .border({ width: 1 })
  }
}

@Component
struct ReusableChildB {
  aboutToAppear() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableChildB aboutToAppear');
  }

  aboutToReuse() {
    hilog.info(DOMAIN, TAG, BUNDLE + 'ReusableChildB aboutToReuse');
  }

  build() {
    Text('ReusableChildB')
      .border({ width: 1 })
  }
}
// [End reusable_for_reuseid]