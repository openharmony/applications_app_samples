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

import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

async function doMd() {
  let mdAlgName = 'SHA256'; // 摘要算法名
  let message = 'mdTestMessgae'; // 待摘要的数据
  let md = cryptoFramework.createMd(mdAlgName);
  // 数据量较少时，可以只做一次update，将数据全部传入，接口未对入参长度做限制
  await md.update({ data: new Uint8Array(buffer.from(message, 'utf-8').buffer) });
  let mdResult = await md.digest();
  console.info('Md result:' + mdResult.data);
  let mdLen = md.getMdLength();
  console.info('md len: ' + mdLen);
}

@Entry
@Component
struct Index {
  @State message: string = 'SingleTimeAsync';

  build() {
    Column({ space: 12 }) {
      Text(this.message).fontSize(20).fontWeight(FontWeight.Bold)
      Button($r('app.string.call_single_time_async'))
        .width('70%')
        .onClick(async () => {
          try {
            await doMd();
            this.message = 'SingleTimeAsyncSuccess';
          } catch {
            this.message = 'SingleTimeAsyncFail';
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}