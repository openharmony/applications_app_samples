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

// [Start v2_computed]
import { UIUtils } from '@kit.ArkUI';

const TAG = 'CanBeObserved';

@ObservedV2
class ComputedUser {
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
    console.info(TAG, `res: ${JSON.stringify(UIUtils.canBeObserved(this))}`);
  }
}

@Entry
@ComponentV2
struct V2Computed {
  @Local computedUser: ComputedUser = new ComputedUser('Shanks', 66);

  build() {
    Column({ space: 20 }) {

      Child01({ computedUser: this.computedUser })

      Child02({ computedUser: this.computedUser })

      Button('test')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象
          this.computedUser.test();
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
  @Param computedUser: ComputedUser = new ComputedUser();

  @Computed
  get child01Name(): string {
    return this.computedUser.name as string;
  }

  @Computed
  get child01Age(): number {
    return this.computedUser.age as number;
  }

  build() {
    Column() {
      Child03({ computedUser: this.computedUser })
    }
  }
}

@ComponentV2
export struct Child02 {
  @Param computedUser: ComputedUser = new ComputedUser();

  @Computed
  get child02Name(): string {
    return this.computedUser.name as string;
  }

  build() {
    Column() {

    }
  }
}

@ComponentV2
export struct Child03 {
  @Param computedUser: ComputedUser = new ComputedUser();

  @Computed
  get child03Age(): number {
    return this.computedUser.age as number;
  }

  build() {
    Column() {

    }
  }
}

@ComponentV2
export struct Child04 {
  @Param computedUser: ComputedUser = new ComputedUser();

  @Computed
  get child04Name(): string {
    return this.computedUser.name as string;
  }

  @Computed
  get child04Age(): number {
    return this.computedUser.age as number;
  }

  build() {
    Column() {

    }
  }
}
// [End v2_computed]