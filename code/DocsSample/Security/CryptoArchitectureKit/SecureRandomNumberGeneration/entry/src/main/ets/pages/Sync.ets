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
// [Start secure_hard_ware_random_number_generation_sync]

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BusinessError } from '@kit.BasicServicesKit';

function doRandBySync() {
  let rand = cryptoFramework.createRandom();
  let len = 24; // Generate a 24-byte random number.
  try {
    let randData = rand.generateRandomSync(len);
    if (randData.data.length !== 0) {
      console.info('[Sync]: rand result: ' + randData.data);
    } else {
      console.error('[Sync]: get rand result: fail!');
    }
  } catch (error) {
    let e: BusinessError = error as BusinessError;
    console.error(`do rand failed: errCode: ${e.code}, message: ${e.message}`);
  }
}
// [End secure_hard_ware_random_number_generation_sync]

@Entry
@Component
struct Index {
  @State message: string = 'Sync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_sync'))
        .width('70%')
        .onClick(() => {
          try {
            doRandBySync();
            this.message = 'Sync Success';
          } catch {
            this.message = 'Sync Fail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}