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

// [Start arkts_custom_components_freeze6]
import { hilog } from '@kit.PerformanceAnalysisKit';

@Reusable
@Component({ freezeWhenInactive: true })
struct ChildComponent {
  @Link @Watch('descChange') desc: string;
  @State count: number = 0;

  descChange() {
    hilog.info(0x0000, 'FreezeChild', `ChildComponent messageChange ${this.desc}`);
  }

  aboutToReuse(params: Record<string, ESObject>): void {
    this.count = params.count as number;
  }

  aboutToRecycle(): void {
    hilog.info(0x0000, 'FreezeChild', `ChildComponent has been recycled`);
  }

  build() {
    Column() {
      Text(`ChildComponent desc: ${this.desc}`)
        .fontSize(20)
      Text(`ChildComponent count ${this.count}`)
        .fontSize(20)
    }.border({ width: 2, color: Color.Pink })
  }
}

@Entry
@Component
struct Page {
  @State desc: string = 'Hello World';
  @State flag: boolean = true;
  @State count: number = 0;

  build() {
    Column() {
      Button(`change desc`).onClick(() => {
        this.desc += '!';
      })
      Button(`change flag`).onClick(() => {
        this.count++;
        this.flag = !this.flag;
      })
      if (this.flag) {
        ChildComponent({ desc: this.desc, count: this.count })
      }
    }
    .height('100%')
  }
}
// [End arkts_custom_components_freeze6]