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

// [Start message_digest_calculation_segmented_digest_algorithm_sync]

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

function doLoopMdBySync() {
  let mdAlgName = 'SHA256'; // 摘要算法名
  let md = cryptoFramework.createMd(mdAlgName);
  // 假设信息总共43字节，根据utf-8解码后，也是43字节
  let messageText = 'aaaaa.....bbbbb.....ccccc.....ddddd.....eee';
  let messageData = new Uint8Array(buffer.from(messageText, 'utf-8').buffer);
  let updateLength = 20; // 假设以20字节为单位进行分段update，实际并无要求
  for (let i = 0; i < messageData.length; i += updateLength) {
    let updateMessage = messageData.subarray(i, i + updateLength);
    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
    md.updateSync(updateMessageBlob);
  }
  let mdOutput = md.digestSync();
  console.info('[Sync]:md result: ' + mdOutput.data);
  let mdLen = md.getMdLength();
  console.info('md len: ' + mdLen);
}
// [End message_digest_calculation_segmented_digest_algorithm_sync]
@Entry
@Component
struct Index {
  @State message: string = 'SegmentationSync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_segmentation_sync'))
        .width('70%')
        .onClick(() => {
          try {
            doLoopMdBySync();
            this.message = 'SegmentationSyncSuccess';
          } catch {
            this.message = 'SegmentationSyncFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}