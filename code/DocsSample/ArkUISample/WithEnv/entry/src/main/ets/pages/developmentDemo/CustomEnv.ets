/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
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

// [Start CustomEnv]
// xxx.ets
import { WithEnv } from '@kit.ArkUI';

const custom = CustomEnvKey.create<string>();

@Entry
@ComponentV2
struct CustomEnvExample {
  @Local customMsg: string = 'Hello';

  build() {
    Column({space: 20}) {
      Button('update')
        .onClick(() => {
          this.customMsg = 'Hello World';
        })

      WithEnv() {
        Child()
      }
      .customEnv(custom, this.customMsg)
    }
    .width('80%')
    .height('30%')
    .backgroundColor('#F7F7F7')
  }
}

@ComponentV2
struct Child {
  @CustomEnv(custom) message: string = 'default value';

  build() {
    Column() {
      Text('CustomEnv value: ' + this.message)
        .fontSize(20)
    }
  }
}
// [End CustomEnv]