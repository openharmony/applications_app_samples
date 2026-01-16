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

// [Start v1_state]
import { UIUtils } from '@kit.ArkUI';

const TAG = 'CanBeObserved';

class StateUser {
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
struct V1State {
  @State stateUser: StateUser = new StateUser('Aki');

  build() {
    Column({ space: 20 }) {

      Child01({ stateUser: this.stateUser })

      Child02({ stateUser: this.stateUser })

      Button('test')
        .onClick(() => {
          // 开发者可以在任意页面中使用接口来判断当前对象是否为可被观察对象
          this.stateUser.test();
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
  @State stateUser: StateUser = new StateUser();

  build() {
    Column() {
      Text('Child01 ' + this.stateUser.name)

      Child03({ stateUser: this.stateUser })
    }
  }
}

@Component
export struct Child02 {
  @State stateUser: StateUser = new StateUser();

  build() {
    Column() {
      Text('Child02 ' + this.stateUser.name)
    }
  }
}

@Component
export struct Child03 {
  @State stateUser: StateUser = new StateUser();

  build() {
    Column() {
      Text('Child03 ' + this.stateUser.name)
    }
  }
}
// [End v1_state]