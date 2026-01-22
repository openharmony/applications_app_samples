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

// [Start v2_monitor]
import { UIUtils } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'CanBeObserved';

@ObservedV2
class MonitorUser {
  @Trace
  public name?: string;
  @Trace
  public age?: number;

  constructor(name?: string, age?: number) {
    this.name = name ?? '';
    this.age = age ?? 0;
  }

  // 在对象中提供判断该对象是否为可被观察对象的方法
  test(): void {
    hilog.info(0x00, TAG, `res: ${JSON.stringify(UIUtils.canBeObserved(this))}`);
  }
}

@Entry
@ComponentV2
struct V2Monitor {
  @Local monitorUser: MonitorUser = new MonitorUser('Poseidon', 76);

  build() {
    Column({ space: 20 }) {

      Child01({ monitorUser: this.monitorUser })

      Child02({ monitorUser: this.monitorUser })

      Button('test')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象
          this.monitorUser.test();
        })

    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

@ComponentV2
export struct Child01 {
  @Param monitorUser: MonitorUser = new MonitorUser();

  @Monitor('monitorUser.name')
  onChild01NameChange(): void {
    hilog.info(0x00, TAG, `onChild01NameChange`);
  }

  @Monitor('monitorUser.age')
  onChild01AgeChange(): void {
    hilog.info(0x00, TAG, `onChild01AgeChange`);
  }

  build() {
    Column() {
      Child03({ monitorUser: this.monitorUser })
    }
  }
}

@ComponentV2
export struct Child02 {
  @Param monitorUser: MonitorUser = new MonitorUser();

  @Monitor('monitorUser.name')
  onChild02NameChange(): void {
    hilog.info(0x00, TAG, `onChild02NameChange`);
  }

  build() {
    Column() {

    }
  }
}

@ComponentV2
export struct Child03 {
  @Param monitorUser: MonitorUser = new MonitorUser();

  @Monitor('monitorUser.age')
  onChild03AgeChange(): void {
    hilog.info(0x00, TAG, `onChild03AgeChange`);
  }

  build() {
    Column() {

    }
  }
}

@ComponentV2
export struct Child04 {
  @Param monitorUser: MonitorUser = new MonitorUser();

  @Monitor('monitorUser.name')
  onChild04NameChange(): void {
    hilog.info(0x00, TAG, `onChild04NameChange`);
  }

  @Monitor('monitorUser.age')
  onChild04AgeChange(): void {
    hilog.info(0x00, TAG, `onChild04AgeChange`);
  }

  build() {
    Column() {

    }
  }
}
// [End v2_monitor]