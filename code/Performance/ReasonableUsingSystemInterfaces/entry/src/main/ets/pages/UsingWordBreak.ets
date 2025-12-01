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

import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';

@Entry
@Component
struct UsingWordBreak {
  @State message: string = 'Using Word Break';

  aboutToAppear(): void {
    getContext().resourceManager.getRawFileContent('sanguo.txt', (error: BusinessError, value: Uint8Array) => {
      if (error != null) {
        console.error('error is ' + error);
      } else {
        this.message = util.TextDecoder.create().decodeWithStream(value);
      }
    })
  }

  build() {
    Column() {
      Scroll(){
        Text(this.message)
          .fontSize(12)
          .wordBreak(WordBreak.BREAK_ALL)
      }
    }
    .height('100%')
    .width('100%')
  }
}