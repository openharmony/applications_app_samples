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

// [Start v1_and_v2_compatibility]
import { UIUtils } from '@kit.ArkUI';

const TAG = 'CanBeObserved';

class CompatibilityUser {
  public name?: string;
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
@Component
struct V1AndV2Compatibility {
  // 被enableV2Compatibility转换的V1对象必须是可被观察的V1对象
  @State temp: CompatibilityUser = new CompatibilityUser('Galen', 43);
  @State compatibilityUser: CompatibilityUser = UIUtils.enableV2Compatibility(this.temp);

  build() {
    Column({ space: 20 }) {

      Child01({ compatibilityUser: this.compatibilityUser })

      Child02({ compatibilityUser: this.compatibilityUser })

      Button('test')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象
          this.compatibilityUser.test();
        })

    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

@Component
export struct Child01 {
  @State compatibilityUser: CompatibilityUser = new CompatibilityUser();

  build() {
    Column() {
      Text('Child01 ' + this.compatibilityUser.name)
    }
  }
}

@ComponentV2
export struct Child02 {
  @Param compatibilityUser: CompatibilityUser = new CompatibilityUser();

  build() {
    Column() {
      Text('Child02 ' + this.compatibilityUser.age)

      Child03({ compatibilityUser: this.compatibilityUser })
    }
  }
}

@ComponentV2
export struct Child03 {
  @Param compatibilityUser: CompatibilityUser = new CompatibilityUser();

  build() {
    Column() {
      Text('Child03 ' + this.compatibilityUser.name)
    }
  }
}
// [End v1_and_v2_compatibility]