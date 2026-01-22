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

// [Start v2_make_observed]
import { UIUtils } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'CanBeObserved';

class MakeObservedUser {
  public name?: string;
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
struct V2MakeObserved {
  @Local observedUser: MakeObservedUser = UIUtils.makeObserved(new MakeObservedUser('Pluto', 64));

  build() {
    Column({ space: 20 }) {

      Child01({ observedUser: this.observedUser })

      Child02({ observedUser: this.observedUser })

      Button('test')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象
          this.observedUser.test();
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
  @Param observedUser: MakeObservedUser = new MakeObservedUser();

  build() {
    Column() {
      Text('Child01 ' + this.observedUser.name)

      Child03({ observedUser: this.observedUser })
    }
  }
}

@ComponentV2
export struct Child02 {
  @Param observedUser: MakeObservedUser = new MakeObservedUser();

  build() {
    Column() {
      Text('Child02 ' + this.observedUser.age)

      Child04({ observedUser: this.observedUser })
    }
  }
}

@ComponentV2
export struct Child03 {
  @Param observedUser: MakeObservedUser = new MakeObservedUser();

  build() {
    Column() {
      Text('Child03 ' + this.observedUser.name)
    }
  }
}

@ComponentV2
export struct Child04 {
  @Param observedUser: MakeObservedUser = new MakeObservedUser();

  build() {
    Column() {
      Text('Child04 ' + this.observedUser.name)

      Text('Child04 ' + this.observedUser.age)
    }
  }
}
// [End v2_make_observed]