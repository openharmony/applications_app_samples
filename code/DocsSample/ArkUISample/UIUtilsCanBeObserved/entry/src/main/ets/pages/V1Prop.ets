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

// [Start v1_prop]
import { UIUtils } from '@kit.ArkUI';

const TAG = 'CanBeObserved';

class PropUser {
  public name?: string;

  constructor(name?: string) {
    this.name = name ?? '';
  }

  // 在对象中提供判断该对象是否为可被观察对象的方法
  test(): void {
    console.info(TAG, `res: ${JSON.stringify(UIUtils.canBeObserved(this))}`);
  }
}

@Entry
@Component
struct V1Prop {
  @State propUser: PropUser = new PropUser('Lion');

  build() {
    Column({ space: 20 }) {

      Child01({ propUser: this.propUser })

      Child02({ propUser: this.propUser })

      Button('test')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象
          this.propUser.test();
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
  @Prop propUser: PropUser = new PropUser();

  build() {
    Column() {
      Text('Child01 ' + this.propUser.name)

      // Child03是Child01的子组件，使用@Prop时，深拷贝的对象发生变更，无法收集
      Child03({ propUser: this.propUser })
    }
  }
}

@Component
export struct Child02 {
  @Prop propUser: PropUser = new PropUser();

  build() {
    Column() {
      Text('Child02 ' + this.propUser.name)
    }
  }
}

@Component
export struct Child03 {
  @Prop propUser: PropUser = new PropUser();

  build() {
    Column() {
      Text('Child03 ' + this.propUser.name)
    }
  }
}
// [End v1_prop]