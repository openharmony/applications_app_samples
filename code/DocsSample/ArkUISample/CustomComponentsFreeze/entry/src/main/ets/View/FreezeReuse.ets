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
// [Start Freeze_and_Reuse]
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0001;
const TAG = 'FreezeChild';

@Reusable
@Component({ freezeWhenInactive: true })
struct ChildComponent {
  @Link @Watch('onChange') count: number;

  onChange() {
    hilog.info(DOMAIN, TAG, `ChildComponent messageChange ${this.count}`);
  }

  aboutToReuse(params: Record<string, ESObject>): void {
    // 在aboutToReuse中改值，解冻时同样不会触发Watch回调
    this.count++;
    hilog.info(DOMAIN, TAG, `ChildComponent has been reused`);
  }

  aboutToRecycle(): void {
    hilog.info(DOMAIN, TAG, `ChildComponent has been recycled`);
  }

  build() {
    Column() {
      Text(`ChildComponent count: ${this.count}`)
        .fontSize(20)
    }
  }
}

@Entry
@Component
struct Index {
  @State flag: boolean = true;
  @State count: number = 0;

  build() {
    Column() {
      Button(`change flag`)
        .onClick(() => {
          this.flag = !this.flag;
        })
        .margin(10)
        .width('50%')
      Button(`change count`)
        .onClick(() => {
          this.count++;
        })
        .margin(10)
        .width('50%')
      if (this.flag) {
        ChildComponent({ count: this.count })
      }
    }
    .height('100%')
  }
}
//[End Freeze_and_Reuse]
