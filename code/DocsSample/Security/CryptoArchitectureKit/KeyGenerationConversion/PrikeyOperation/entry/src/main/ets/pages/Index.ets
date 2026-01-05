/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { router } from '@kit.ArkUI';
import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State message: string = 'PrikeyOperation';

  goToSample(url: string): void {
    router.pushUrl({
      url: url,
    }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('pushUrl success');
    })
  }

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.prikey_get_pubkey_cpp_test'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestGetPubkeyFromPrikey();
          if (ret == 0) {
            this.message = 'Get Pubkey From Prikey Success';
          } else {
            this.message = 'Get Pubkey From Prikey Fail';
          }
        })
      Button($r('app.string.prikey_encoding_cpp_test'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestGetPubkeyFromPrikey();
          if (ret == 0) {
            this.message = 'Prikey Encoding Success';
          } else {
            this.message = 'Prikey Encoding Fail';
          }
        })
      Button($r('app.string.prikey_decoding_cpp_test'))
        .width('70%')
        .onClick(() => {
          let ret: number = testNapi.doTestGetPubkeyFromPrikey();
          if (ret == 0) {
            this.message = 'Prikey Decoding Success';
          } else {
            this.message = 'Prikey Decoding Fail';
          }
        })
      Button($r('app.string.prikey_get_pubkey_async'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/prikeyGetPubkeyAsync')
        })
      Button($r('app.string.prikey_get_pubkey_sync'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/prikeyGetPubkeySync')
        })
      Button($r('app.string.prikey_encoding'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/prikeyEncoding')
        })
      Button($r('app.string.prikey_decoding'))
        .width('70%')
        .onClick(() => {
          this.goToSample('pages/prikeyDecoding')
        })
    }
    .width('100%')
    .height('100%')
  }
}
