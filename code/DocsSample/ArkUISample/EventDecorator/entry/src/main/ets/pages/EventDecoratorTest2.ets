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
// [Start EventDecoratorTest2]
import hilog from '@ohos.hilog';
const TAG = '[Sample_EventDecorator]';
const DOMAIN = 0xF811;
const BUNDLE = 'EventDecorator_';
@ComponentV2
struct Child2 {
  @Param index: number = 0;
  @Event changeIndex: (val: number) => void;

  build() {
    Column() {
      Text(`Child index: ${this.index}`)
        .onClick(() => {
          this.changeIndex(20);
          hilog.info(DOMAIN, TAG, BUNDLE, `after changeIndex ${this.index}`);
        })
    }
  }
}
@Entry
@ComponentV2
struct Index2 {
  @Local index: number = 0;

  build() {
    Column() {
      Child2({
        index: this.index,
        changeIndex: (val: number) => {
          this.index = val;
          hilog.info(DOMAIN, TAG, BUNDLE, `in changeIndex ${this.index}`);
        }
      })
    }
  }
}
// [End EventDecoratorTest2]