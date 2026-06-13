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

// [Start NestedScopes]
// xxx.ets
import { WithEnv } from '@kit.ArkUI';

const outerKey = CustomEnvKey.create<string>();
const innerKey = CustomEnvKey.create<string>();

@Entry
@ComponentV2
struct NestedExample {
  @Local outerValue: string = 'Outer Value';
  @Local innerValue: string = 'Inner Value';

  build() {
    Column({ space: 12 }) {
      Button('Update Values').onClick(() => {
        this.outerValue = 'Updated Outer';
        this.innerValue = 'Updated Inner';
      })

      // 外层 WithEnv
      WithEnv() {
        Column({ space: 8 }) {
          Text('Outer scope:').fontWeight(FontWeight.Bold)
          OuterChild()

          // 内层 WithEnv
          WithEnv() {
            Column({ space: 8 }) {
              Text('Inner scope:').fontWeight(FontWeight.Bold)
              InnerChildWithInnerKey()
              InnerChildWithOuterKey()
            }
          }
          .customEnv(innerKey, this.innerValue)
        }
      }
      .customEnv(outerKey, this.outerValue)
    }
    .padding(12)
    .width('100%')
  }
}

@ComponentV2
struct OuterChild {
  @CustomEnv(outerKey) message: string = 'default';

  build() {
    Text('OuterChild reads: ' + this.message)
  }
}

@ComponentV2
struct InnerChildWithInnerKey {
  @CustomEnv(innerKey) message: string = 'default';

  build() {
    Text('InnerChild InnerKey reads: ' + this.message)
  }
}

@ComponentV2
struct InnerChildWithOuterKey {
  @CustomEnv(outerKey) message: string = 'default';

  build() {
    Text('InnerChild OuterKey reads: ' + this.message)
  }
}
// [End NestedScopes]