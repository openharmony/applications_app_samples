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

// [Start v2_provider_and_consumer]
import { UIUtils } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'CanBeObserved';

@ObservedV2
class ProviderConsumerUser {
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
struct V2ProviderAndConsumer {
  @Provider('ProviderUser') pcUser: ProviderConsumerUser = new ProviderConsumerUser('Mars', 145);

  build() {
    Column({ space: 20 }) {

      Child01()

      Child02()

      Button('test')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象
          this.pcUser.test();
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
  @Consumer('ProviderUser') pcUser: ProviderConsumerUser = new ProviderConsumerUser();

  build() {
    Column() {
      Text('Child01 ' + this.pcUser.name)

      Child03()
    }
  }
}

@ComponentV2
export struct Child02 {
  @Consumer('ProviderUser') pcUser: ProviderConsumerUser = new ProviderConsumerUser();

  build() {
    Column() {
      Text('Child02 ' + this.pcUser.age)

      Child04()
    }
  }
}

@ComponentV2
export struct Child03 {
  @Consumer('ProviderUser') pcUser: ProviderConsumerUser = new ProviderConsumerUser();

  build() {
    Column() {
      Text('Child01 ' + this.pcUser.name)
    }
  }
}

@ComponentV2
export struct Child04 {
  @Consumer('ProviderUser') pcUser: ProviderConsumerUser = new ProviderConsumerUser();

  build() {
    Column() {
      Text('Child01 ' + this.pcUser.name)

      Text('Child01 ' + this.pcUser.age)
    }
  }
}
// [End v2_provider_and_consumer]